Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab2ERKaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:30:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42398 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161032Ab2ERKaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:30:13 -0400
Date: Fri, 18 May 2012 03:29:47 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-qvhepvhyvj0pkqlcq5xv2n8f@git.kernel.org>
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
Subject: [tip:sched/numa] mm/mpol: Introduce vma_put_policy()
Git-Commit-ID: f1b39afe3e55ff32f987200531fab3f548ec2f61
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:29:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1b39afe3e55ff32f987200531fab3f548ec2f61
Gitweb:     http://git.kernel.org/tip/f1b39afe3e55ff32f987200531fab3f548ec2f61
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 8 Mar 2012 23:10:02 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:19 +0200

mm/mpol: Introduce vma_put_policy()

In preparation of other changes, create a new interface so that we can
later extend its behaviour without having to touch all these sites.

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
Link: http://lkml.kernel.org/n/tip-qvhepvhyvj0pkqlcq5xv2n8f@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mempolicy.h |    5 +++++
 mm/mempolicy.c            |    5 +++++
 mm/mmap.c                 |    8 ++++----
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index c8525db..3942845 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -170,6 +170,7 @@ static inline struct mempolicy *mpol_dup(struct mempolicy *pol)
 #define vma_set_policy(vma, pol) ((vma)->vm_policy = (pol))
 
 extern int vma_dup_policy(struct vm_area_struct *new, struct vm_area_struct *old);
+extern void vma_put_policy(struct vm_area_struct *vma);
 
 static inline void mpol_get(struct mempolicy *pol)
 {
@@ -313,6 +314,10 @@ mpol_shared_policy_lookup(struct shared_policy *sp, unsigned long idx)
 #define vma_set_policy(vma, pol) do {} while(0)
 #define vma_dup_policy(new, old) (0)
 
+static inline void vma_put_policy(struct vm_area_struct *vma)
+{
+}
+
 static inline void numa_policy_init(void)
 {
 }
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index e9c658d..d1de6b8 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1951,6 +1951,11 @@ int vma_dup_policy(struct vm_area_struct *new, struct vm_area_struct *old)
 	return 0;
 }
 
+void vma_put_policy(struct vm_area_struct *vma)
+{
+	mpol_put(vma_policy(vma));
+}
+
 /*
  * If *frompol needs [has] an extra ref, copy *frompol to *tompol ,
  * eliminate the * MPOL_F_* flags that require conditional ref and
diff --git a/mm/mmap.c b/mm/mmap.c
index 8c72aed..8950c81 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -235,7 +235,7 @@ static struct vm_area_struct *remove_vma(struct vm_area_struct *vma)
 		if (vma->vm_flags & VM_EXECUTABLE)
 			removed_exe_file_vma(vma->vm_mm);
 	}
-	mpol_put(vma_policy(vma));
+	vma_put_policy(vma);
 	kmem_cache_free(vm_area_cachep, vma);
 	return next;
 }
@@ -626,7 +626,7 @@ again:			remove_next = 1 + (end > next->vm_end);
 		if (next->anon_vma)
 			anon_vma_merge(vma, next);
 		mm->map_count--;
-		mpol_put(vma_policy(next));
+		vma_put_policy(next);
 		kmem_cache_free(vm_area_cachep, next);
 		/*
 		 * In mprotect's case 6 (see comments on vma_merge),
@@ -2022,7 +2022,7 @@ static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
 	}
 	unlink_anon_vmas(new);
  out_free_mpol:
-	mpol_put(new->vm_policy);
+	vma_put_policy(new);
  out_free_vma:
 	kmem_cache_free(vm_area_cachep, new);
  out_err:
@@ -2425,7 +2425,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	return new_vma;
 
  out_free_mempol:
-	mpol_put(new_vma->vm_policy);
+	vma_put_policy(new_vma);
  out_free_vma:
 	kmem_cache_free(vm_area_cachep, new_vma);
 	return NULL;
