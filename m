Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161125Ab2ERK3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:29:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161032Ab2ERK31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:29:27 -0400
Date: Fri, 18 May 2012 03:28:57 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-gjd2uz5arf4sl7j9764sae91@git.kernel.org>
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
Subject: [tip:sched/numa] mm/mpol: Introduce vma_dup_policy()
Git-Commit-ID: 9fc52f506a4ed7330bac067a76dd670760008536
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:29:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9fc52f506a4ed7330bac067a76dd670760008536
Gitweb:     http://git.kernel.org/tip/9fc52f506a4ed7330bac067a76dd670760008536
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 9 Jan 2012 11:41:03 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:19 +0200

mm/mpol: Introduce vma_dup_policy()

In preparation of other changes, pull some code duplication in a
common function so that we can later extend its behaviour without
having to touch all these sites.

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
Link: http://lkml.kernel.org/n/tip-gjd2uz5arf4sl7j9764sae91@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mempolicy.h |    3 +++
 kernel/fork.c             |    9 +++------
 mm/mempolicy.c            |   11 +++++++++++
 mm/mmap.c                 |   17 +++++------------
 4 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index c970840..c8525db 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -169,6 +169,8 @@ static inline struct mempolicy *mpol_dup(struct mempolicy *pol)
 #define vma_policy(vma) ((vma)->vm_policy)
 #define vma_set_policy(vma, pol) ((vma)->vm_policy = (pol))
 
+extern int vma_dup_policy(struct vm_area_struct *new, struct vm_area_struct *old);
+
 static inline void mpol_get(struct mempolicy *pol)
 {
 	if (pol)
@@ -309,6 +311,7 @@ mpol_shared_policy_lookup(struct shared_policy *sp, unsigned long idx)
 
 #define vma_policy(vma) NULL
 #define vma_set_policy(vma, pol) do {} while(0)
+#define vma_dup_policy(new, old) (0)
 
 static inline void numa_policy_init(void)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index a1793e4..f01be7f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -344,7 +344,6 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	struct rb_node **rb_link, *rb_parent;
 	int retval;
 	unsigned long charge;
-	struct mempolicy *pol;
 
 	down_write(&oldmm->mmap_sem);
 	flush_cache_dup_mm(oldmm);
@@ -394,11 +393,9 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			goto fail_nomem;
 		*tmp = *mpnt;
 		INIT_LIST_HEAD(&tmp->anon_vma_chain);
-		pol = mpol_dup(vma_policy(mpnt));
-		retval = PTR_ERR(pol);
-		if (IS_ERR(pol))
+		retval = vma_dup_policy(tmp, mpnt);
+		if (retval)
 			goto fail_nomem_policy;
-		vma_set_policy(tmp, pol);
 		tmp->vm_mm = mm;
 		if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
@@ -460,7 +457,7 @@ out:
 	up_write(&oldmm->mmap_sem);
 	return retval;
 fail_nomem_anon_vma_fork:
-	mpol_put(pol);
+	mpol_put(vma_policy(tmp));
 fail_nomem_policy:
 	kmem_cache_free(vm_area_cachep, tmp);
 fail_nomem:
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 113b091..e9c658d 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1940,6 +1940,17 @@ struct mempolicy *__mpol_dup(struct mempolicy *old)
 	return new;
 }
 
+int vma_dup_policy(struct vm_area_struct *new, struct vm_area_struct *old)
+{
+	struct mempolicy *mpol;
+
+	mpol = mpol_dup(vma_policy(old));
+	if (IS_ERR(mpol))
+		return PTR_ERR(mpol);
+	vma_set_policy(new, mpol);
+	return 0;
+}
+
 /*
  * If *frompol needs [has] an extra ref, copy *frompol to *tompol ,
  * eliminate the * MPOL_F_* flags that require conditional ref and
diff --git a/mm/mmap.c b/mm/mmap.c
index 848ef52..8c72aed 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1963,7 +1963,6 @@ detach_vmas_to_be_unmapped(struct mm_struct *mm, struct vm_area_struct *vma,
 static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
 	      unsigned long addr, int new_below)
 {
-	struct mempolicy *pol;
 	struct vm_area_struct *new;
 	int err = -ENOMEM;
 
@@ -1987,12 +1986,9 @@ static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
 		new->vm_pgoff += ((addr - vma->vm_start) >> PAGE_SHIFT);
 	}
 
-	pol = mpol_dup(vma_policy(vma));
-	if (IS_ERR(pol)) {
-		err = PTR_ERR(pol);
+	err = vma_dup_policy(new, vma);
+	if (err)
 		goto out_free_vma;
-	}
-	vma_set_policy(new, pol);
 
 	if (anon_vma_clone(new, vma))
 		goto out_free_mpol;
@@ -2026,7 +2022,7 @@ static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
 	}
 	unlink_anon_vmas(new);
  out_free_mpol:
-	mpol_put(pol);
+	mpol_put(new->vm_policy);
  out_free_vma:
 	kmem_cache_free(vm_area_cachep, new);
  out_err:
@@ -2368,7 +2364,6 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *new_vma, *prev;
 	struct rb_node **rb_link, *rb_parent;
-	struct mempolicy *pol;
 	bool faulted_in_anon_vma = true;
 
 	/*
@@ -2409,13 +2404,11 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 		new_vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 		if (new_vma) {
 			*new_vma = *vma;
-			pol = mpol_dup(vma_policy(vma));
-			if (IS_ERR(pol))
+			if (vma_dup_policy(new_vma, vma))
 				goto out_free_vma;
 			INIT_LIST_HEAD(&new_vma->anon_vma_chain);
 			if (anon_vma_clone(new_vma, vma))
 				goto out_free_mempol;
-			vma_set_policy(new_vma, pol);
 			new_vma->vm_start = addr;
 			new_vma->vm_end = addr + len;
 			new_vma->vm_pgoff = pgoff;
@@ -2432,7 +2425,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	return new_vma;
 
  out_free_mempol:
-	mpol_put(pol);
+	mpol_put(new_vma->vm_policy);
  out_free_vma:
 	kmem_cache_free(vm_area_cachep, new_vma);
 	return NULL;
