Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761634Ab0GTUgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:36:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:38639 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758691Ab0GTUfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:35:47 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, dhowells@redhat.com, sfrench@samba.org,
        anton@samba.org, swhiteho@redhat.com, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/7] gfs2: use workqueue instead of slow-work
Date: Tue, 20 Jul 2010 22:35:00 +0200
Message-Id: <1279658102-20069-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279658102-20069-1-git-send-email-tj@kernel.org>
References: <1279658102-20069-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 20:35:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueue can now handle high concurrency.  Convert gfs to use
workqueue instead of slow-work.

* Steven pointed out that recovery path might be run from allocation
  path and thus requires forward progress guarantee without memory
  allocation.  Create and use gfs_recovery_wq with rescuer.  Please
  note that forward progress wasn't guaranteed with slow-work.

* Updated to use non-reentrant workqueue.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/Kconfig      |    1 -
 fs/gfs2/incore.h     |    3 +-
 fs/gfs2/main.c       |   14 +++++++-----
 fs/gfs2/ops_fstype.c |    8 +++---
 fs/gfs2/recovery.c   |   54 +++++++++++++++++++------------------------------
 fs/gfs2/recovery.h   |    6 +++-
 fs/gfs2/sys.c        |    3 +-
 7 files changed, 40 insertions(+), 49 deletions(-)

diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index a47b431..cc96655 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -7,7 +7,6 @@ config GFS2_FS
 	select IP_SCTP if DLM_SCTP
 	select FS_POSIX_ACL
 	select CRC32
-	select SLOW_WORK
 	select QUOTACTL
 	help
 	  A cluster filesystem.
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index b5d7363..dd8f2e6 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -12,7 +12,6 @@
 
 #include <linux/fs.h>
 #include <linux/workqueue.h>
-#include <linux/slow-work.h>
 #include <linux/dlm.h>
 #include <linux/buffer_head.h>
 
@@ -383,7 +382,7 @@ struct gfs2_journal_extent {
 struct gfs2_jdesc {
 	struct list_head jd_list;
 	struct list_head extent_list;
-	struct slow_work jd_work;
+	struct work_struct jd_work;
 	struct inode *jd_inode;
 	unsigned long jd_flags;
 #define JDF_RECOVERY 1
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index fb2a5f9..b1e9630 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -15,7 +15,6 @@
 #include <linux/init.h>
 #include <linux/gfs2_ondisk.h>
 #include <asm/atomic.h>
-#include <linux/slow-work.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -24,6 +23,7 @@
 #include "util.h"
 #include "glock.h"
 #include "quota.h"
+#include "recovery.h"
 
 static struct shrinker qd_shrinker = {
 	.shrink = gfs2_shrink_qd_memory,
@@ -138,9 +138,11 @@ static int __init init_gfs2_fs(void)
 	if (error)
 		goto fail_unregister;
 
-	error = slow_work_register_user(THIS_MODULE);
-	if (error)
-		goto fail_slow;
+	error = -ENOMEM;
+	gfs_recovery_wq = alloc_workqueue("gfs_recovery",
+					  WQ_NON_REENTRANT | WQ_RESCUER, 0);
+	if (!gfs_recovery_wq)
+		goto fail_wq;
 
 	gfs2_register_debugfs();
 
@@ -148,7 +150,7 @@ static int __init init_gfs2_fs(void)
 
 	return 0;
 
-fail_slow:
+fail_wq:
 	unregister_filesystem(&gfs2meta_fs_type);
 fail_unregister:
 	unregister_filesystem(&gfs2_fs_type);
@@ -190,7 +192,7 @@ static void __exit exit_gfs2_fs(void)
 	gfs2_unregister_debugfs();
 	unregister_filesystem(&gfs2_fs_type);
 	unregister_filesystem(&gfs2meta_fs_type);
-	slow_work_unregister_user(THIS_MODULE);
+	destroy_workqueue(gfs_recovery_wq);
 
 	kmem_cache_destroy(gfs2_quotad_cachep);
 	kmem_cache_destroy(gfs2_rgrpd_cachep);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 3593b3a..9a08e1b 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -17,7 +17,6 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/gfs2_ondisk.h>
-#include <linux/slow-work.h>
 #include <linux/quotaops.h>
 
 #include "gfs2.h"
@@ -673,7 +672,7 @@ static int gfs2_jindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ji_gh)
 			break;
 
 		INIT_LIST_HEAD(&jd->extent_list);
-		slow_work_init(&jd->jd_work, &gfs2_recover_ops);
+		INIT_WORK(&jd->jd_work, gfs2_recover_func);
 		jd->jd_inode = gfs2_lookupi(sdp->sd_jindex, &name, 1);
 		if (!jd->jd_inode || IS_ERR(jd->jd_inode)) {
 			if (!jd->jd_inode)
@@ -782,7 +781,8 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 	if (sdp->sd_lockstruct.ls_first) {
 		unsigned int x;
 		for (x = 0; x < sdp->sd_journals; x++) {
-			error = gfs2_recover_journal(gfs2_jdesc_find(sdp, x));
+			error = gfs2_recover_journal(gfs2_jdesc_find(sdp, x),
+						     true);
 			if (error) {
 				fs_err(sdp, "error recovering journal %u: %d\n",
 				       x, error);
@@ -792,7 +792,7 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 
 		gfs2_others_may_mount(sdp);
 	} else if (!sdp->sd_args.ar_spectator) {
-		error = gfs2_recover_journal(sdp->sd_jdesc);
+		error = gfs2_recover_journal(sdp->sd_jdesc, true);
 		if (error) {
 			fs_err(sdp, "error recovering my journal: %d\n", error);
 			goto fail_jinode_gh;
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 4b9bece..f7f89a9 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -14,7 +14,6 @@
 #include <linux/buffer_head.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
-#include <linux/slow-work.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -28,6 +27,8 @@
 #include "util.h"
 #include "dir.h"
 
+struct workqueue_struct *gfs_recovery_wq;
+
 int gfs2_replay_read_block(struct gfs2_jdesc *jd, unsigned int blk,
 			   struct buffer_head **bh)
 {
@@ -443,23 +444,7 @@ static void gfs2_recovery_done(struct gfs2_sbd *sdp, unsigned int jid,
         kobject_uevent_env(&sdp->sd_kobj, KOBJ_CHANGE, envp);
 }
 
-static int gfs2_recover_get_ref(struct slow_work *work)
-{
-	struct gfs2_jdesc *jd = container_of(work, struct gfs2_jdesc, jd_work);
-	if (test_and_set_bit(JDF_RECOVERY, &jd->jd_flags))
-		return -EBUSY;
-	return 0;
-}
-
-static void gfs2_recover_put_ref(struct slow_work *work)
-{
-	struct gfs2_jdesc *jd = container_of(work, struct gfs2_jdesc, jd_work);
-	clear_bit(JDF_RECOVERY, &jd->jd_flags);
-	smp_mb__after_clear_bit();
-	wake_up_bit(&jd->jd_flags, JDF_RECOVERY);
-}
-
-static void gfs2_recover_work(struct slow_work *work)
+void gfs2_recover_func(struct work_struct *work)
 {
 	struct gfs2_jdesc *jd = container_of(work, struct gfs2_jdesc, jd_work);
 	struct gfs2_inode *ip = GFS2_I(jd->jd_inode);
@@ -578,7 +563,7 @@ static void gfs2_recover_work(struct slow_work *work)
 		gfs2_glock_dq_uninit(&j_gh);
 
 	fs_info(sdp, "jid=%u: Done\n", jd->jd_jid);
-	return;
+	goto done;
 
 fail_gunlock_tr:
 	gfs2_glock_dq_uninit(&t_gh);
@@ -590,32 +575,35 @@ fail_gunlock_j:
 	}
 
 	fs_info(sdp, "jid=%u: %s\n", jd->jd_jid, (error) ? "Failed" : "Done");
-
 fail:
 	gfs2_recovery_done(sdp, jd->jd_jid, LM_RD_GAVEUP);
+done:
+	clear_bit(JDF_RECOVERY, &jd->jd_flags);
+	smp_mb__after_clear_bit();
+	wake_up_bit(&jd->jd_flags, JDF_RECOVERY);
 }
 
-struct slow_work_ops gfs2_recover_ops = {
-	.owner	 = THIS_MODULE,
-	.get_ref = gfs2_recover_get_ref,
-	.put_ref = gfs2_recover_put_ref,
-	.execute = gfs2_recover_work,
-};
-
-
 static int gfs2_recovery_wait(void *word)
 {
 	schedule();
 	return 0;
 }
 
-int gfs2_recover_journal(struct gfs2_jdesc *jd)
+int gfs2_recover_journal(struct gfs2_jdesc *jd, bool wait)
 {
 	int rv;
-	rv = slow_work_enqueue(&jd->jd_work);
-	if (rv)
-		return rv;
-	wait_on_bit(&jd->jd_flags, JDF_RECOVERY, gfs2_recovery_wait, TASK_UNINTERRUPTIBLE);
+
+	if (test_and_set_bit(JDF_RECOVERY, &jd->jd_flags))
+		return -EBUSY;
+
+	/* we have JDF_RECOVERY, queue should always succeed */
+	rv = queue_work(gfs_recovery_wq, &jd->jd_work);
+	BUG_ON(!rv);
+
+	if (wait)
+		wait_on_bit(&jd->jd_flags, JDF_RECOVERY, gfs2_recovery_wait,
+			    TASK_UNINTERRUPTIBLE);
+
 	return 0;
 }
 
diff --git a/fs/gfs2/recovery.h b/fs/gfs2/recovery.h
index 1616ac2..2226136 100644
--- a/fs/gfs2/recovery.h
+++ b/fs/gfs2/recovery.h
@@ -12,6 +12,8 @@
 
 #include "incore.h"
 
+extern struct workqueue_struct *gfs_recovery_wq;
+
 static inline void gfs2_replay_incr_blk(struct gfs2_sbd *sdp, unsigned int *blk)
 {
 	if (++*blk == sdp->sd_jdesc->jd_blocks)
@@ -27,8 +29,8 @@ extern void gfs2_revoke_clean(struct gfs2_sbd *sdp);
 
 extern int gfs2_find_jhead(struct gfs2_jdesc *jd,
 		    struct gfs2_log_header_host *head);
-extern int gfs2_recover_journal(struct gfs2_jdesc *gfs2_jd);
-extern struct slow_work_ops gfs2_recover_ops;
+extern int gfs2_recover_journal(struct gfs2_jdesc *gfs2_jd, bool wait);
+extern void gfs2_recover_func(struct work_struct *work);
 
 #endif /* __RECOVERY_DOT_H__ */
 
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 37f5393..6b60316 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -25,6 +25,7 @@
 #include "quota.h"
 #include "util.h"
 #include "glops.h"
+#include "recovery.h"
 
 struct gfs2_attr {
 	struct attribute attr;
@@ -352,7 +353,7 @@ static ssize_t recover_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 	list_for_each_entry(jd, &sdp->sd_jindex_list, jd_list) {
 		if (jd->jd_jid != jid)
 			continue;
-		rv = slow_work_enqueue(&jd->jd_work);
+		rv = gfs2_recover_journal(jd, false);
 		break;
 	}
 out:
-- 
1.6.4.2

