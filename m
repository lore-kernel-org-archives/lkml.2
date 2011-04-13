Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055Ab1DMQPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:15:18 -0400
Received: from kroah.org ([198.145.64.141]:53112 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933001Ab1DMQNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:50 2011
Message-Id: <20110413161049.978230744@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:10:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>, Moritz Muehlenhoff <jmm@debian.org>
Subject: [70/71] exec: copy-and-paste the fixes into compat_do_execve() paths
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 114279be2120a916e8a04feeb2ac976a10016f2f upstream.

Note: this patch targets 2.6.37 and tries to be as simple as possible.
That is why it adds more copy-and-paste horror into fs/compat.c and
uglifies fs/exec.c, this will be cleanuped later.

compat_copy_strings() plays with bprm->vma/mm directly and thus has
two problems: it lacks the RLIMIT_STACK check and argv/envp memory
is not visible to oom killer.

Export acct_arg_size() and get_arg_page(), change compat_copy_strings()
to use get_arg_page(), change compat_do_execve() to do acct_arg_size(0)
as do_execve() does.

Add the fatal_signal_pending/cond_resched checks into compat_count() and
compat_copy_strings(), this matches the code in fs/exec.c and certainly
makes sense.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Moritz Muehlenhoff <jmm@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/compat.c             |   28 +++++++++++++++-------------
 fs/exec.c               |    8 ++++----
 include/linux/binfmts.h |    4 ++++
 3 files changed, 23 insertions(+), 17 deletions(-)

--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1351,6 +1351,10 @@ static int compat_count(compat_uptr_t __
 			argv++;
 			if (i++ >= max)
 				return -E2BIG;
+
+			if (fatal_signal_pending(current))
+				return -ERESTARTNOHAND;
+			cond_resched();
 		}
 	}
 	return i;
@@ -1392,6 +1396,12 @@ static int compat_copy_strings(int argc,
 		while (len > 0) {
 			int offset, bytes_to_copy;
 
+			if (fatal_signal_pending(current)) {
+				ret = -ERESTARTNOHAND;
+				goto out;
+			}
+			cond_resched();
+
 			offset = pos % PAGE_SIZE;
 			if (offset == 0)
 				offset = PAGE_SIZE;
@@ -1408,18 +1418,8 @@ static int compat_copy_strings(int argc,
 			if (!kmapped_page || kpos != (pos & PAGE_MASK)) {
 				struct page *page;
 
-#ifdef CONFIG_STACK_GROWSUP
-				ret = expand_stack_downwards(bprm->vma, pos);
-				if (ret < 0) {
-					/* We've exceed the stack rlimit. */
-					ret = -E2BIG;
-					goto out;
-				}
-#endif
-				ret = get_user_pages(current, bprm->mm, pos,
-						     1, 1, 1, &page, NULL);
-				if (ret <= 0) {
-					/* We've exceed the stack rlimit. */
+				page = get_arg_page(bprm, pos, 1);
+				if (!page) {
 					ret = -E2BIG;
 					goto out;
 				}
@@ -1540,8 +1540,10 @@ int compat_do_execve(char * filename,
 	return retval;
 
 out:
-	if (bprm->mm)
+	if (bprm->mm) {
+		acct_arg_size(bprm, 0);
 		mmput(bprm->mm);
+	}
 
 out_file:
 	if (bprm->file) {
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -158,7 +158,7 @@ out:
 
 #ifdef CONFIG_MMU
 
-static void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
+void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
 {
 	struct mm_struct *mm = current->mm;
 	long diff = (long)(pages - bprm->vma_pages);
@@ -173,7 +173,7 @@ static void acct_arg_size(struct linux_b
 	up_write(&mm->mmap_sem);
 }
 
-static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
+struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 		int write)
 {
 	struct page *page;
@@ -290,11 +290,11 @@ static bool valid_arg_len(struct linux_b
 
 #else
 
-static inline void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
+void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
 {
 }
 
-static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
+struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 		int write)
 {
 	struct page *page;
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -60,6 +60,10 @@ struct linux_binprm{
 	unsigned long loader, exec;
 };
 
+extern void acct_arg_size(struct linux_binprm *bprm, unsigned long pages);
+extern struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
+					int write);
+
 #define BINPRM_FLAGS_ENFORCE_NONDUMP_BIT 0
 #define BINPRM_FLAGS_ENFORCE_NONDUMP (1 << BINPRM_FLAGS_ENFORCE_NONDUMP_BIT)
 


