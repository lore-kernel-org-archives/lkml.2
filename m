Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161139Ab2ERK2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:28:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42345 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762664Ab2ERK2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:28:37 -0400
Date: Fri, 18 May 2012 03:28:06 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-olds8r1atae6j44rso80c2ad@git.kernel.org>
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
Subject: [tip:sched/numa] mm/mpol: Simplify do_mbind()
Git-Commit-ID: 6494a5f2cb894b1bcc4431d0b87d14901b05b3ba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:28:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6494a5f2cb894b1bcc4431d0b87d14901b05b3ba
Gitweb:     http://git.kernel.org/tip/6494a5f2cb894b1bcc4431d0b87d14901b05b3ba
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 30 Jan 2012 15:51:05 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:18 +0200

mm/mpol: Simplify do_mbind()

Code flow got a little convoluted, try and straighten it some.

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
Link: http://lkml.kernel.org/n/tip-olds8r1atae6j44rso80c2ad@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/mempolicy.c |   73 +++++++++++++++++++++++++++++--------------------------
 1 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index b60c991..113b091 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1062,9 +1062,9 @@ static long do_mbind(unsigned long start, unsigned long len,
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
-	struct mempolicy *new;
+	struct mempolicy *new = NULL;
 	unsigned long end;
-	int err;
+	int err, nr_failed = 0;
 	LIST_HEAD(pagelist);
 
   	if (flags & ~(unsigned long)MPOL_MF_VALID)
@@ -1086,13 +1086,15 @@ static long do_mbind(unsigned long start, unsigned long len,
 	if (end == start)
 		return 0;
 
-	new = mpol_new(mode, mode_flags, nmask);
-	if (IS_ERR(new))
-		return PTR_ERR(new);
+	if (mode != MPOL_NOOP) {
+		new = mpol_new(mode, mode_flags, nmask);
+		if (IS_ERR(new))
+			return PTR_ERR(new);
 
-	if (flags & MPOL_MF_LAZY)
-		new->flags |= MPOL_F_MOF;
+		if (flags & MPOL_MF_LAZY)
+			new->flags |= MPOL_F_MOF;
 
+	}
 	/*
 	 * If we are using the default policy then operation
 	 * on discontinuous address spaces is okay after all
@@ -1105,56 +1107,57 @@ static long do_mbind(unsigned long start, unsigned long len,
 		 nmask ? nodes_addr(*nmask)[0] : -1);
 
 	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
-
 		err = migrate_prep();
 		if (err)
 			goto mpol_out;
 	}
-	{
+
+	down_write(&mm->mmap_sem);
+
+	if (mode != MPOL_NOOP) {
 		NODEMASK_SCRATCH(scratch);
+		err = -ENOMEM;
 		if (scratch) {
-			down_write(&mm->mmap_sem);
 			task_lock(current);
 			err = mpol_set_nodemask(new, nmask, scratch);
 			task_unlock(current);
-			if (err)
-				up_write(&mm->mmap_sem);
-		} else
-			err = -ENOMEM;
+		}
 		NODEMASK_SCRATCH_FREE(scratch);
+		if (err)
+			goto mpol_out_unlock;
 	}
-	if (err)
-		goto mpol_out;
 
 	vma = check_range(mm, start, end, nmask,
 			  flags | MPOL_MF_INVERT, &pagelist);
 
 	err = PTR_ERR(vma);	/* maybe ... */
-	if (!IS_ERR(vma) && mode != MPOL_NOOP)
+	if (IS_ERR(vma))
+		goto mpol_out_unlock;
+
+	if (mode != MPOL_NOOP) {
 		err = mbind_range(mm, start, end, new);
+		if (err)
+			goto mpol_out_unlock;
+	}
 
-	if (!err) {
-		int nr_failed = 0;
-
-		if (!list_empty(&pagelist)) {
-			if (flags & MPOL_MF_LAZY)
-				nr_failed = migrate_pages_unmap_only(&pagelist);
-			else {
-				nr_failed = migrate_pages(&pagelist, new_vma_page,
-						(unsigned long)vma,
-						false, true);
-			}
-			if (nr_failed)
-				putback_lru_pages(&pagelist);
+	if (!list_empty(&pagelist)) {
+		if (flags & MPOL_MF_LAZY)
+			nr_failed = migrate_pages_unmap_only(&pagelist);
+		else {
+			nr_failed = migrate_pages(&pagelist, new_vma_page,
+					(unsigned long)vma,
+					false, true);
 		}
+	}
 
-		if (nr_failed && (flags & MPOL_MF_STRICT))
-			err = -EIO;
-	} else
-		putback_lru_pages(&pagelist);
+	if (nr_failed && (flags & MPOL_MF_STRICT))
+		err = -EIO;
+
+	putback_lru_pages(&pagelist);
 
+mpol_out_unlock:
 	up_write(&mm->mmap_sem);
- mpol_out:
+mpol_out:
 	mpol_put(new);
 	return err;
 }
