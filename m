Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab1L2VJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 16:09:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57771 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab1L2VJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 16:09:08 -0500
Date: Thu, 29 Dec 2011 22:07:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>
Subject: [GIT PULL] futex fixlet
Message-ID: <20111229210707.GA22300@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

Please have a good look at it - it was probably not tested
by everyone with the usual vigor, due to holiday excesse^W 
festivities.

 Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      futex: Fix uninterruptible loop due to gate_area


 include/linux/mm.h |    1 +
 kernel/futex.c     |   40 +++++++++++++++++++++++++++++++++++-----
 mm/mmap.c          |    5 +++++
 3 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4baadd1..3025cbc 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1395,6 +1395,7 @@ extern int may_expand_vm(struct mm_struct *mm, unsigned long npages);
 extern int install_special_mapping(struct mm_struct *mm,
 				   unsigned long addr, unsigned long len,
 				   unsigned long flags, struct page **pages);
+extern bool is_special_mapping(struct vm_area_struct *vma);
 
 extern unsigned long get_unmapped_area(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 
diff --git a/kernel/futex.c b/kernel/futex.c
index ea87f4d..4d66cd3 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -59,6 +59,7 @@
 #include <linux/magic.h>
 #include <linux/pid.h>
 #include <linux/nsproxy.h>
+#include <linux/mm.h>
 
 #include <asm/futex.h>
 
@@ -236,7 +237,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
 	struct page *page, *page_head;
-	int err, ro = 0;
+	int err, ro = 0, no_mapping_tries = 0;
 
 	/*
 	 * The futex address must be "naturally" aligned.
@@ -317,13 +318,42 @@ again:
 	if (!page_head->mapping) {
 		unlock_page(page_head);
 		put_page(page_head);
+
 		/*
-		* ZERO_PAGE pages don't have a mapping. Avoid a busy loop
-		* trying to find one. RW mapping would have COW'd (and thus
-		* have a mapping) so this page is RO and won't ever change.
-		*/
+		 * ZERO_PAGE pages don't have a mapping. Avoid a busy loop
+		 * trying to find one. RW mapping would have COW'd (and thus
+		 * have a mapping) so this page is RO and won't ever change.
+		 */
 		if ((page_head == ZERO_PAGE(address)))
 			return -EFAULT;
+
+		/*
+		 * Similar problem for the gate area.
+		 */
+		if (in_gate_area(mm, address))
+			return -EFAULT;
+
+		/*
+		 * There is a special class of pages that will have no mapping
+		 * and yet is perfectly valid and not going anywhere. These
+		 * are the pages from install_special_mapping(). Since looking
+		 * up the vma is expensive, don't do so on the first go round.
+		 */
+		if (no_mapping_tries) {
+			struct vm_area_struct *vma;
+
+			err = 0;
+			down_read(&mm->mmap_sem);
+			vma = find_vma(mm, address);
+			if (vma && is_special_mapping(vma))
+				err = -EFAULT;
+			up_read(&mm->mmap_sem);
+
+			if (err)
+				return err;
+		}
+
+		++no_mapping_tries;
 		goto again;
 	}
 
diff --git a/mm/mmap.c b/mm/mmap.c
index eae90af..50fde2e 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2479,6 +2479,11 @@ out:
 	return ret;
 }
 
+bool is_special_mapping(struct vm_area_struct *vma)
+{
+	return vma->vm_ops == &special_mapping_vmops;
+}
+
 static DEFINE_MUTEX(mm_all_locks_mutex);
 
 static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
