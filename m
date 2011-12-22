Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab1LVVq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 16:46:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37320 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab1LVVpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 16:45:49 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/7] block: fix deadlock through percpu allocation in blk-cgroup
Date: Thu, 22 Dec 2011 13:45:26 -0800
Message-Id: <1324590326-10135-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1324590326-10135-1-git-send-email-tj@kernel.org>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Percpu allocator depends on %GFP_KERNEL allocation and can't be used
for NOIO or NOFS allocations; unfortunately, blk-cgroup allocates
percpu stats structure in the IO path, which triggers the following
lockdep warning and also leads to actual deadlocks under certain
conditions.

 inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
 qemu-kvm/8774 [HC0[0]:SC0[0]:HE1:SE1] takes:
  (pcpu_alloc_mutex){+.+.?.}, at: [<ffffffff8110c8be>] pcpu_alloc+0x6f/0x835
 {RECLAIM_FS-ON-W} state was registered at:
   [<ffffffff8108f85a>] mark_held_locks+0x6d/0x95
   [<ffffffff8108fe69>] lockdep_trace_alloc+0x9f/0xc2
   [<ffffffff8112d781>] slab_pre_alloc_hook+0x1e/0x54
   [<ffffffff8112fcf9>] __kmalloc+0x64/0x10c
   [<ffffffff8110bec8>] pcpu_mem_alloc+0x5e/0x67
   [<ffffffff8110c169>] pcpu_extend_area_map+0x2b/0xd4
   [<ffffffff8110ca0d>] pcpu_alloc+0x1be/0x835
   [<ffffffff8110d094>] __alloc_percpu+0x10/0x12
   [<ffffffff8113167a>] kmem_cache_open+0x2cc/0x2d6
   [<ffffffff8113185d>] kmem_cache_create+0x1d9/0x281
   [<ffffffff812971a5>] acpi_os_create_cache+0x1d/0x2d
   [<ffffffff812bf742>] acpi_ut_create_caches+0x26/0xb0
   [<ffffffff812c2106>] acpi_ut_init_globals+0xe/0x244
   [<ffffffff81d82ca9>] acpi_initialize_subsystem+0x35/0xae
   [<ffffffff81d819c2>] acpi_early_init+0x5c/0xf7
   [<ffffffff81d51be9>] start_kernel+0x3ce/0x3ea
   [<ffffffff81d512c4>] x86_64_start_reservations+0xaf/0xb3
   [<ffffffff81d51412>] x86_64_start_kernel+0x14a/0x159
 irq event stamp: 48683649
 hardirqs last  enabled at (48683649): [<ffffffff814fd547>] __slab_alloc+0x413/0x434
 hardirqs last disabled at (48683648): [<ffffffff814fd17c>] __slab_alloc+0x48/0x434
 softirqs last  enabled at (48683630): [<ffffffff810630bf>] __do_softirq+0x200/0x25a
 softirqs last disabled at (48683625): [<ffffffff8150debc>] call_softirq+0x1c/0x30

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(pcpu_alloc_mutex);
   <Interrupt>
     lock(pcpu_alloc_mutex);

  *** DEADLOCK ***

 3 locks held by qemu-kvm/8774:
  #0:  (&vcpu->mutex){+.+.+.}, at: [<ffffffffa005d979>] vcpu_load+0x1d/0x90 [kvm]
  #1:  (&kvm->srcu){.+.+.+}, at: [<ffffffffa00663f7>] srcu_read_lock+0x0/0x49 [kvm]
  #2:  (&mm->mmap_sem){++++++}, at: [<ffffffffa005ee6f>] hva_to_pfn+0xbb/0x2d1 [kvm]

 stack backtrace:
 Pid: 8774, comm: qemu-kvm Not tainted 3.1.4 #2
 Call Trace:
  [<ffffffff814fa906>] print_usage_bug+0x1e7/0x1f8
  [<ffffffff8108e232>] mark_lock+0x106/0x220
  [<ffffffff8108e6ee>] __lock_acquire+0x3a2/0xd0c
  [<ffffffff8108f55b>] lock_acquire+0xf3/0x13e
  [<ffffffff815030ad>] __mutex_lock_common+0x5d/0x39a
  [<ffffffff815034f9>] mutex_lock_nested+0x40/0x45
  [<ffffffff8110c8be>] pcpu_alloc+0x6f/0x835
  [<ffffffff8110d094>] __alloc_percpu+0x10/0x12
  [<ffffffff8123d64c>] blkio_alloc_blkg_stats+0x1d/0x31
  [<ffffffff8123ed87>] throtl_alloc_tg+0x3a/0xdf
  [<ffffffff8123f79f>] blk_throtl_bio+0x154/0x39c
  [<ffffffff81231c52>] generic_make_request+0x2e4/0x415
  [<ffffffff81231e61>] submit_bio+0xde/0xfd
  [<ffffffff8111e15d>] swap_writepage+0x94/0x9f
  [<ffffffff811041d1>] shmem_writepage+0x192/0x1d8
  [<ffffffff8110167b>] shrink_page_list+0x402/0x79a
  [<ffffffff81101e1a>] shrink_inactive_list+0x22c/0x3df
  [<ffffffff811026b2>] shrink_zone+0x43f/0x582
  [<ffffffff81102b5e>] do_try_to_free_pages+0x107/0x318
  [<ffffffff811030a6>] try_to_free_pages+0xd5/0x175
  [<ffffffff810f9021>] __alloc_pages_nodemask+0x535/0x7eb
  [<ffffffff81127f02>] alloc_pages_vma+0xf5/0xfa
  [<ffffffff81136bfb>] do_huge_pmd_anonymous_page+0xb3/0x274
  [<ffffffff811112f2>] handle_mm_fault+0xfd/0x1b8
  [<ffffffff8111173c>] __get_user_pages+0x2fa/0x465
  [<ffffffffa005edb2>] get_user_page_nowait+0x37/0x39 [kvm]
  [<ffffffffa005ee8a>] hva_to_pfn+0xd6/0x2d1 [kvm]
  [<ffffffffa005f108>] __gfn_to_pfn+0x83/0x8c [kvm]
  [<ffffffffa005f1c9>] gfn_to_pfn_async+0x1a/0x1c [kvm]
  [<ffffffffa007799e>] try_async_pf+0x3f/0x248 [kvm]
  [<ffffffffa0079140>] tdp_page_fault+0xe8/0x1a5 [kvm]
  [<ffffffffa0077c83>] kvm_mmu_page_fault+0x2b/0x83 [kvm]
  [<ffffffffa00cda71>] handle_ept_violation+0xe1/0xea [kvm_intel]
  [<ffffffffa00d2129>] vmx_handle_exit+0x5ee/0x638 [kvm_intel]
  [<ffffffffa007153f>] kvm_arch_vcpu_ioctl_run+0xb30/0xe00 [kvm]
  [<ffffffffa005db4f>] kvm_vcpu_ioctl+0x120/0x59c [kvm]
  [<ffffffff811502a5>] do_vfs_ioctl+0x472/0x4b3
  [<ffffffff8115033c>] sys_ioctl+0x56/0x7a
  [<ffffffff8150bbc2>] system_call_fastpath+0x16/0x1b

For more details, please refer to the following thread.

  http://thread.gmane.org/gmane.comp.emulators.kvm.devel/82755

This patch fixes the bug by using percpu_mempool to allocate blkg
percpu stats.  As the allocations are only per cgroup - request_queue
pair, they aren't expected to be frequent.  Use smallish pool of 8
elements which is refilled once half is consumed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Avi Kivity <avi@redhat.com>
Reported-by: Nate Custer <nate@cpanel.net>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c   |   37 +++++++++++++++++++++++++++++++++++--
 block/blk-cgroup.h   |    2 ++
 block/blk-throttle.c |    2 +-
 block/cfq-iosched.c  |    2 +-
 4 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 2788693..43bf5e8 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -17,17 +17,33 @@
 #include <linux/err.h>
 #include <linux/blkdev.h>
 #include <linux/slab.h>
+#include <linux/mempool.h>
 #include "blk-cgroup.h"
 #include <linux/genhd.h>
 
 #define MAX_KEY_LEN 100
 
+/*
+ * blkg_stats_cpu_pool parameters.  These allocations aren't frequent, can
+ * be opportunistic and percpu memory is expensive.
+ */
+#define BLKG_STATS_CPU_POOL_SIZE	8
+#define BLKG_STATS_CPU_POOL_REFILL	4
+
 static DEFINE_SPINLOCK(blkio_list_lock);
 static LIST_HEAD(blkio_list);
 
 struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
 EXPORT_SYMBOL_GPL(blkio_root_cgroup);
 
+/*
+ * Percpu mempool for blkgio_group_stats_cpu which are allocated on-demand
+ * on IO path.  As percpu doesn't support NOIO allocations, we need to
+ * buffer them through mempool.
+ */
+struct percpu_mempool *blkg_stats_cpu_pool;
+EXPORT_SYMBOL_GPL(blkg_stats_cpu_pool);
+
 static struct cgroup_subsys_state *blkiocg_create(struct cgroup_subsys *,
 						  struct cgroup *);
 static int blkiocg_can_attach_task(struct cgroup *, struct task_struct *);
@@ -469,8 +485,13 @@ EXPORT_SYMBOL_GPL(blkiocg_update_io_merged_stats);
  */
 int blkio_alloc_blkg_stats(struct blkio_group *blkg)
 {
+	/* Schedule refill if necessary */
+	if (percpu_mempool_nr_elems(blkg_stats_cpu_pool) <=
+	    BLKG_STATS_CPU_POOL_REFILL)
+		percpu_mempool_refill(blkg_stats_cpu_pool, GFP_NOWAIT);
+
 	/* Allocate memory for per cpu stats */
-	blkg->stats_cpu = alloc_percpu(struct blkio_group_stats_cpu);
+	blkg->stats_cpu = percpu_mempool_alloc(blkg_stats_cpu_pool, GFP_NOWAIT);
 	if (!blkg->stats_cpu)
 		return -ENOMEM;
 	return 0;
@@ -1671,12 +1692,24 @@ EXPORT_SYMBOL_GPL(blkio_policy_unregister);
 
 static int __init init_cgroup_blkio(void)
 {
-	return cgroup_load_subsys(&blkio_subsys);
+	int ret;
+
+	blkg_stats_cpu_pool = percpu_mempool_create(BLKG_STATS_CPU_POOL_SIZE,
+				sizeof(struct blkio_group_stats_cpu),
+				__alignof__(struct blkio_group_stats_cpu));
+	if (!blkg_stats_cpu_pool)
+		return -ENOMEM;
+
+	ret = cgroup_load_subsys(&blkio_subsys);
+	if (ret)
+		percpu_mempool_destroy(blkg_stats_cpu_pool);
+	return ret;
 }
 
 static void __exit exit_cgroup_blkio(void)
 {
 	cgroup_unload_subsys(&blkio_subsys);
+	percpu_mempool_destroy(blkg_stats_cpu_pool);
 }
 
 module_init(init_cgroup_blkio);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 6f3ace7..7659564 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -32,6 +32,8 @@ extern struct cgroup_subsys blkio_subsys;
 #define blkio_subsys_id blkio_subsys.subsys_id
 #endif
 
+extern struct percpu_mempool *blkg_stats_cpu_pool;
+
 enum stat_type {
 	/* Total time spent (in ns) between request dispatch to the driver and
 	 * request completion for IOs doen by this cgroup. This may not be
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 5eed6a7..0f0805e 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -159,7 +159,7 @@ static void throtl_free_tg(struct rcu_head *head)
 	struct throtl_grp *tg;
 
 	tg = container_of(head, struct throtl_grp, rcu_head);
-	free_percpu(tg->blkg.stats_cpu);
+	percpu_mempool_free(tg->blkg.stats_cpu, blkg_stats_cpu_pool);
 	kfree(tg);
 }
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 163263d..44d374a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1204,7 +1204,7 @@ static void cfq_put_cfqg(struct cfq_group *cfqg)
 		return;
 	for_each_cfqg_st(cfqg, i, j, st)
 		BUG_ON(!RB_EMPTY_ROOT(&st->rb));
-	free_percpu(cfqg->blkg.stats_cpu);
+	percpu_mempool_free(cfqg->blkg.stats_cpu, blkg_stats_cpu_pool);
 	kfree(cfqg);
 }
 
-- 
1.7.3.1

