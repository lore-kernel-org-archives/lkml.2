Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679Ab2ERKbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:31:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42420 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560Ab2ERKbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:31:43 -0400
Date: Fri, 18 May 2012 03:30:37 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-g2rnququsbs1htvrg0b3w8a3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        bharata.rao@gmail.com, aarcange@redhat.com, Lee.Schermerhorn@hp.com,
        suresh.b.siddha@intel.com, danms@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm/mpol:
  Split and explose some mempolicy functions
Git-Commit-ID: 5dca4a9119807320b6571ecae878249eef46fa92
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:30:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5dca4a9119807320b6571ecae878249eef46fa92
Gitweb:     http://git.kernel.org/tip/5dca4a9119807320b6571ecae878249eef46fa92
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 9 Jan 2012 11:41:03 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:20 +0200

mm/mpol: Split and explose some mempolicy functions

In order to allow creating 'custom' mpols, expose some guts. In
particular means to allocate fresh mpols and to bind them to memory
ranges, skipping out on the intermediate -- policy -- part of
sys_mbind().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-g2rnququsbs1htvrg0b3w8a3@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mempolicy.h |    8 +++
 mm/mempolicy.c            |  111 +++++++++++++++++++++++++-------------------
 2 files changed, 71 insertions(+), 48 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 3942845..578fcd0 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -205,6 +205,12 @@ struct shared_policy {
 	spinlock_t lock;
 };
 
+extern struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
+				  nodemask_t *nodes);
+extern long mpol_do_mbind(unsigned long start, unsigned long len,
+				struct mempolicy *policy, unsigned long mode,
+				nodemask_t *nmask, unsigned long flags);
+
 void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol);
 int mpol_set_shared_policy(struct shared_policy *info,
 				struct vm_area_struct *vma,
@@ -218,6 +224,8 @@ struct mempolicy *get_vma_policy(struct task_struct *tsk,
 
 extern void numa_default_policy(void);
 extern void numa_policy_init(void);
+extern void mpol_rebind_policy(struct mempolicy *pol, const nodemask_t *new,
+				enum mpol_rebind_step step);
 extern void mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new,
 				enum mpol_rebind_step step);
 extern void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index d1de6b8..1ddbf22 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -243,7 +243,7 @@ static int mpol_set_nodemask(struct mempolicy *pol,
  * This function just creates a new policy, does some check and simple
  * initialization. You must invoke mpol_set_nodemask() to set nodes.
  */
-static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
+struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
 				  nodemask_t *nodes)
 {
 	struct mempolicy *policy;
@@ -389,7 +389,7 @@ static void mpol_rebind_preferred(struct mempolicy *pol,
  * 	MPOL_REBIND_STEP1 - set all the newly nodes
  * 	MPOL_REBIND_STEP2 - clean all the disallowed nodes
  */
-static void mpol_rebind_policy(struct mempolicy *pol, const nodemask_t *newmask,
+void mpol_rebind_policy(struct mempolicy *pol, const nodemask_t *newmask,
 				enum mpol_rebind_step step)
 {
 	if (!pol)
@@ -1056,55 +1056,28 @@ static struct page *new_vma_page(struct page *page, unsigned long private, int *
 }
 #endif
 
-static long do_mbind(unsigned long start, unsigned long len,
-		     unsigned short mode, unsigned short mode_flags,
-		     nodemask_t *nmask, unsigned long flags)
+long mpol_do_mbind(unsigned long start, unsigned long len,
+		struct mempolicy *new, unsigned long mode,
+		nodemask_t *nmask, unsigned long flags)
 {
-	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
-	struct mempolicy *new = NULL;
-	unsigned long end;
+	struct vm_area_struct *vma;
 	int err, nr_failed = 0;
+	unsigned long end;
 	LIST_HEAD(pagelist);
 
-  	if (flags & ~(unsigned long)MPOL_MF_VALID)
-		return -EINVAL;
-	if ((flags & MPOL_MF_MOVE_ALL) && !capable(CAP_SYS_NICE))
-		return -EPERM;
-
-	if (start & ~PAGE_MASK)
-		return -EINVAL;
-
-	if (mode == MPOL_DEFAULT || mode == MPOL_NOOP)
-		flags &= ~MPOL_MF_STRICT;
-
 	len = (len + PAGE_SIZE - 1) & PAGE_MASK;
 	end = start + len;
 
-	if (end < start)
-		return -EINVAL;
-	if (end == start)
-		return 0;
-
-	if (mode != MPOL_NOOP) {
-		new = mpol_new(mode, mode_flags, nmask);
-		if (IS_ERR(new))
-			return PTR_ERR(new);
-
-		if (flags & MPOL_MF_LAZY)
-			new->flags |= MPOL_F_MOF;
-
+	if (end < start) {
+		err = -EINVAL;
+		goto mpol_out;
 	}
-	/*
-	 * If we are using the default policy then operation
-	 * on discontinuous address spaces is okay after all
-	 */
-	if (!new)
-		flags |= MPOL_MF_DISCONTIG_OK;
 
-	pr_debug("mbind %lx-%lx mode:%d flags:%d nodes:%lx\n",
-		 start, start + len, mode, mode_flags,
-		 nmask ? nodes_addr(*nmask)[0] : -1);
+	if (end == start) {
+		err = 0;
+		goto mpol_out;
+	}
 
 	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
 		err = migrate_prep();
@@ -1112,8 +1085,6 @@ static long do_mbind(unsigned long start, unsigned long len,
 			goto mpol_out;
 	}
 
-	down_write(&mm->mmap_sem);
-
 	if (mode != MPOL_NOOP) {
 		NODEMASK_SCRATCH(scratch);
 		err = -ENOMEM;
@@ -1124,7 +1095,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 		}
 		NODEMASK_SCRATCH_FREE(scratch);
 		if (err)
-			goto mpol_out_unlock;
+			goto mpol_out;
 	}
 
 	vma = check_range(mm, start, end, nmask,
@@ -1132,12 +1103,12 @@ static long do_mbind(unsigned long start, unsigned long len,
 
 	err = PTR_ERR(vma);	/* maybe ... */
 	if (IS_ERR(vma))
-		goto mpol_out_unlock;
+		goto mpol_out_putback;
 
 	if (mode != MPOL_NOOP) {
 		err = mbind_range(mm, start, end, new);
 		if (err)
-			goto mpol_out_unlock;
+			goto mpol_out_putback;
 	}
 
 	if (!list_empty(&pagelist)) {
@@ -1153,12 +1124,56 @@ static long do_mbind(unsigned long start, unsigned long len,
 	if (nr_failed && (flags & MPOL_MF_STRICT))
 		err = -EIO;
 
+mpol_out_putback:
 	putback_lru_pages(&pagelist);
 
-mpol_out_unlock:
-	up_write(&mm->mmap_sem);
 mpol_out:
+	return err;
+}
+
+static long do_mbind(unsigned long start, unsigned long len,
+		     unsigned short mode, unsigned short mode_flags,
+		     nodemask_t *nmask, unsigned long flags)
+{
+	struct mm_struct *mm = current->mm;
+	struct mempolicy *new = NULL;
+	int err;
+
+	if (flags & ~(unsigned long)MPOL_MF_VALID)
+		return -EINVAL;
+	if ((flags & MPOL_MF_MOVE_ALL) && !capable(CAP_SYS_NICE))
+		return -EPERM;
+
+	if (start & ~PAGE_MASK)
+		return -EINVAL;
+
+	if (mode == MPOL_DEFAULT || mode == MPOL_NOOP)
+		flags &= ~MPOL_MF_STRICT;
+
+	if (mode != MPOL_NOOP) {
+		new = mpol_new(mode, mode_flags, nmask);
+		if (IS_ERR(new))
+			return PTR_ERR(new);
+
+		if (flags & MPOL_MF_LAZY)
+			new->flags |= MPOL_F_MOF;
+	}
+	/*
+	 * If we are using the default policy then operation
+	 * on discontinuous address spaces is okay after all
+	 */
+	if (!new)
+		flags |= MPOL_MF_DISCONTIG_OK;
+
+	pr_debug("mbind %lx-%lx mode:%d flags:%d nodes:%lx\n",
+		 start, start + len, mode, mode_flags,
+		 nmask ? nodes_addr(*nmask)[0] : -1);
+
+	down_write(&mm->mmap_sem);
+	err = mpol_do_mbind(start, len, new, mode, nmask, flags);
+	up_write(&mm->mmap_sem);
 	mpol_put(new);
+
 	return err;
 }
 
