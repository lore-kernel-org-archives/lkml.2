Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab2F1M5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:57:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150Ab2F1M5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:57:24 -0400
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
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 20/40] autonuma: alloc/free/init mm_autonuma
Date: Thu, 28 Jun 2012 14:56:00 +0200
Message-Id: <1340888180-15355-21-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
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
index 0adbe09..3e5a0d9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -527,6 +527,8 @@ static void mm_init_aio(struct mm_struct *mm)
 
 static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 {
+	if (unlikely(alloc_mm_autonuma(mm)))
+		goto out_free_mm;
 	atomic_set(&mm->mm_users, 1);
 	atomic_set(&mm->mm_count, 1);
 	init_rwsem(&mm->mmap_sem);
@@ -549,6 +551,8 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 		return mm;
 	}
 
+	free_mm_autonuma(mm);
+out_free_mm:
 	free_mm(mm);
 	return NULL;
 }
@@ -598,6 +602,7 @@ void __mmdrop(struct mm_struct *mm)
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
@@ -1702,6 +1708,7 @@ void __init proc_caches_init(void)
 	mm_cachep = kmem_cache_create("mm_struct",
 			sizeof(struct mm_struct), ARCH_MIN_MMSTRUCT_ALIGN,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
+	mm_autonuma_init();
 	vm_area_cachep = KMEM_CACHE(vm_area_struct, SLAB_PANIC);
 	mmap_init();
 	nsproxy_cache_init();
