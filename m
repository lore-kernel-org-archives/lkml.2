Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab1D0Xgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:36:36 -0400
Received: from mout.perfora.net ([74.208.4.195]:49731 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757162Ab1D0Xgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:36:32 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] mm: export get_vma_policy()
Date: Wed, 27 Apr 2011 19:35:42 -0400
Message-Id: <1303947349-3620-2-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1303947349-3620-1-git-send-email-wilsons@start.ca>
References: <1303947349-3620-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:lhVbGq7ENU1bPnhZ1bqPQiHBZXYv9PJi5ZlJRIgwglR
 cHoW3Vqep/WBAmGkG+5rvr1soKlklvkLUow8iQVJqqVFkJn9Sy
 nWlwElwfr3saM9lgwzM7z3Vnr2O2X9cgctNByxWtmyAxu4GhJT
 ofMN105KuHqpSH398GAcrPFLNMgeA7qm6FLL1lXn2JVyQ6oMm4
 aW3beBLZezmzsUVstjs74M2RzUJ0mLjGYaa1o2grCI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 48fce3429df84a94766fbbc845fa8450d0715b48 get_vma_policy() was
marked static as all clients were local to mempolicy.c.

However, the decision to generate /proc/pid/numa_maps in the numa memory
policy code and outside the procfs subsystem introduces an artificial
interdependency between the two systems.  Exporting get_vma_policy()
once again is the first step to clean up this interdependency.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
---
 include/linux/mempolicy.h |    3 +++
 mm/mempolicy.c            |    2 +-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 31ac26c..c2f6032 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -199,6 +199,9 @@ void mpol_free_shared_policy(struct shared_policy *p);
 struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
 					    unsigned long idx);
 
+struct mempolicy *get_vma_policy(struct task_struct *tsk,
+		struct vm_area_struct *vma, unsigned long addr);
+
 extern void numa_default_policy(void);
 extern void numa_policy_init(void);
 extern void mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new,
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 959a8b8..5bfb03e 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1489,7 +1489,7 @@ asmlinkage long compat_sys_mbind(compat_ulong_t start, compat_ulong_t len,
  * freeing by another task.  It is the caller's responsibility to free the
  * extra reference for shared policies.
  */
-static struct mempolicy *get_vma_policy(struct task_struct *task,
+struct mempolicy *get_vma_policy(struct task_struct *task,
 		struct vm_area_struct *vma, unsigned long addr)
 {
 	struct mempolicy *pol = task->mempolicy;
-- 
1.7.3.5

