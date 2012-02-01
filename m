Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab2BAUul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:50:41 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54454 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab2BAUuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:50:39 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/16] blkcg: make CONFIG_BLK_CGROUP bool
Date: Wed,  1 Feb 2012 12:50:14 -0800
Message-Id: <1328129429-11823-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328129429-11823-1-git-send-email-tj@kernel.org>
References: <1328129429-11823-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Block cgroup core can be built as module; however, it isn't too useful
as blk-throttle can only be built-in and cfq-iosched is usually the
default built-in scheduler.  Scheduled blkcg cleanup requires calling
into blkcg from block core.  To simplify that, disallow building blkcg
as module by making CONFIG_BLK_CGROUP bool.

If building blkcg core as module really matters, which I doubt, we can
revisit it after blkcg API cleanup.

-v2: Vivek pointed out that IOSCHED_CFQ was incorrectly updated to
     depend on BLK_CGROUP.  Fixed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/Kconfig.iosched |    4 ----
 block/blk-cgroup.c    |   17 -----------------
 block/blk-cgroup.h    |   10 ++--------
 init/Kconfig          |    2 +-
 4 files changed, 3 insertions(+), 30 deletions(-)

diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 3199b76..421bef9 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -23,8 +23,6 @@ config IOSCHED_DEADLINE
 
 config IOSCHED_CFQ
 	tristate "CFQ I/O scheduler"
-	# If BLK_CGROUP is a module, CFQ has to be built as module.
-	depends on (BLK_CGROUP=m && m) || !BLK_CGROUP || BLK_CGROUP=y
 	default y
 	---help---
 	  The CFQ I/O scheduler tries to distribute bandwidth equally
@@ -34,8 +32,6 @@ config IOSCHED_CFQ
 
 	  This is the default I/O scheduler.
 
-	  Note: If BLK_CGROUP=m, then CFQ can be built only as module.
-
 config CFQ_GROUP_IOSCHED
 	bool "CFQ Group Scheduling support"
 	depends on IOSCHED_CFQ && BLK_CGROUP
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index fa8f263..7bfc574 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -50,10 +50,7 @@ struct cgroup_subsys blkio_subsys = {
 	.attach = blkiocg_attach,
 	.destroy = blkiocg_destroy,
 	.populate = blkiocg_populate,
-#ifdef CONFIG_BLK_CGROUP
-	/* note: blkio_subsys_id is otherwise defined in blk-cgroup.h */
 	.subsys_id = blkio_subsys_id,
-#endif
 	.use_id = 1,
 	.module = THIS_MODULE,
 };
@@ -1679,17 +1676,3 @@ void blkio_policy_unregister(struct blkio_policy_type *blkiop)
 	spin_unlock(&blkio_list_lock);
 }
 EXPORT_SYMBOL_GPL(blkio_policy_unregister);
-
-static int __init init_cgroup_blkio(void)
-{
-	return cgroup_load_subsys(&blkio_subsys);
-}
-
-static void __exit exit_cgroup_blkio(void)
-{
-	cgroup_unload_subsys(&blkio_subsys);
-}
-
-module_init(init_cgroup_blkio);
-module_exit(exit_cgroup_blkio);
-MODULE_LICENSE("GPL");
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 6f3ace7..3551687 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -24,13 +24,7 @@ enum blkio_policy_id {
 /* Max limits for throttle policy */
 #define THROTL_IOPS_MAX		UINT_MAX
 
-#if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
-
-#ifndef CONFIG_BLK_CGROUP
-/* When blk-cgroup is a module, its subsys_id isn't a compile-time constant */
-extern struct cgroup_subsys blkio_subsys;
-#define blkio_subsys_id blkio_subsys.subsys_id
-#endif
+#ifdef CONFIG_BLK_CGROUP
 
 enum stat_type {
 	/* Total time spent (in ns) between request dispatch to the driver and
@@ -303,7 +297,7 @@ static inline void blkiocg_update_idle_time_stats(struct blkio_group *blkg) {}
 static inline void blkiocg_set_start_empty_time(struct blkio_group *blkg) {}
 #endif
 
-#if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
+#ifdef CONFIG_BLK_CGROUP
 extern struct blkio_cgroup blkio_root_cgroup;
 extern struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
 extern struct blkio_cgroup *task_blkio_cgroup(struct task_struct *tsk);
diff --git a/init/Kconfig b/init/Kconfig
index 3f42cd6..da9222d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -766,7 +766,7 @@ config RT_GROUP_SCHED
 endif #CGROUP_SCHED
 
 config BLK_CGROUP
-	tristate "Block IO controller"
+	bool "Block IO controller"
 	depends on BLOCK
 	default n
 	---help---
-- 
1.7.7.3

