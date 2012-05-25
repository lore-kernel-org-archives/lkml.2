Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628Ab2EYRLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 13:11:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab2EYRD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 13:03:29 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH 19/35] autonuma: alloc/free/init mm_autonuma
Date: Fri, 25 May 2012 19:02:23 +0200
Message-Id: <1337965359-29725-20-git-send-email-aarcange@redhat.com>
In-Reply-To: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is where the mm_autonuma structure is being handled. Just like
sched_autonuma, this is only allocated at runtime if the hardware the
kernel is running on has been detected as NUMA. On not NUMA hardware
the memory cost is reduced to one pointer per mm.

To get rid of the pointer in the each mm, the kernel can be compiled
with CONFIG_AUTONUMA=n.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 kernel/fork.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index d323eb1..22f102e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -526,6 +526,8 @@ static void mm_init_aio(struct mm_struct *mm)
 
 static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 {
+	if (unlikely(alloc_mm_autonuma(mm)))
+		goto out_free_mm;
 	atomic_set(&mm->mm_users, 1);
 	atomic_set(&mm->mm_count, 1);
 	init_rwsem(&mm->mmap_sem);
@@ -548,6 +550,8 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 		return mm;
 	}
 
+	free_mm_autonuma(mm);
+out_free_mm:
 	free_mm(mm);
 	return NULL;
 }
@@ -597,6 +601,7 @@ void __mmdrop(struct mm_struct *mm)
 	destroy_context(mm);
 	mmu_notifier_mm_destroy(mm);
 	check_mm(mm);
+	free_mm_autonuma(mm);
 	free_mm(mm);
 }
 EXPORT_SYMBOL_GPL(__mmdrop);
@@ -880,6 +885,7 @@ fail_nocontext:
 	 * If init_new_context() failed, we cannot use mmput() to free the mm
 	 * because it calls destroy_context()
 	 */
+	free_mm_autonuma(mm);
 	mm_free_pgd(mm);
 	free_mm(mm);
 	return NULL;
@@ -1706,6 +1712,7 @@ void __init proc_caches_init(void)
 	mm_cachep = kmem_cache_create("mm_struct",
 			sizeof(struct mm_struct), ARCH_MIN_MMSTRUCT_ALIGN,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
+	mm_autonuma_init();
 	vm_area_cachep = KMEM_CACHE(vm_area_struct, SLAB_PANIC);
 	mmap_init();
 	nsproxy_cache_init();
