Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab1ACNut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:50:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39769 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab1ACNuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=yBj7lEzNJwJHT3S3oM8PIwHYiowI82Bsg8S3ghw7Izm+hTvO9pA1468l4nBthWIoPq
         WNizgs3+6BhlU7Ib1c/hdypZN5sEq/GYMD3F6d0EnsA7V2Oj5TSJZFEahuLskQzwcp+4
         3UrgF8r1Ha7qGVehYX8L8c2fo/OHH0PWsF7A4=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <joel.becker@oracle.com>
Subject: [PATCH 26/32] ocfs2: use system_wq instead of ocfs2_quota_wq
Date: Mon,  3 Jan 2011 14:49:49 +0100
Message-Id: <1294062595-30097-27-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ocfs2_quota_wq is not depended upon during memory reclaim and, with
cmwq, there's no reason to use a dedicated workqueue.  Drop
ocfs2_quota_wq and use system_wq instead.  dqi_sync_work is already
sync canceled on quota disable and no further synchronization is
necessary.

This change makes ocfs2_quota_setup/shutdown() noops.  Both functions
removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <joel.becker@oracle.com>
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 fs/ocfs2/quota.h        |    3 ---
 fs/ocfs2/quota_global.c |   27 ++++-----------------------
 fs/ocfs2/super.c        |    7 -------
 3 files changed, 4 insertions(+), 33 deletions(-)

diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
index 196fcb5..d5ab56c 100644
--- a/fs/ocfs2/quota.h
+++ b/fs/ocfs2/quota.h
@@ -114,7 +114,4 @@ int ocfs2_local_write_dquot(struct dquot *dquot);
 extern const struct dquot_operations ocfs2_quota_operations;
 extern struct quota_format_type ocfs2_quota_format;
 
-int ocfs2_quota_setup(void);
-void ocfs2_quota_shutdown(void);
-
 #endif /* _OCFS2_QUOTA_H */
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 4607923..a73f641 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -63,8 +63,6 @@
  *        write to gf
  */
 
-static struct workqueue_struct *ocfs2_quota_wq = NULL;
-
 static void qsync_work_fn(struct work_struct *work);
 
 static void ocfs2_global_disk2memdqb(struct dquot *dquot, void *dp)
@@ -400,8 +398,8 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 						OCFS2_QBLK_RESERVED_SPACE;
 	oinfo->dqi_gi.dqi_qtree_depth = qtree_depth(&oinfo->dqi_gi);
 	INIT_DELAYED_WORK(&oinfo->dqi_sync_work, qsync_work_fn);
-	queue_delayed_work(ocfs2_quota_wq, &oinfo->dqi_sync_work,
-			   msecs_to_jiffies(oinfo->dqi_syncms));
+	schedule_delayed_work(&oinfo->dqi_sync_work,
+			      msecs_to_jiffies(oinfo->dqi_syncms));
 
 out_err:
 	mlog_exit(status);
@@ -635,8 +633,8 @@ static void qsync_work_fn(struct work_struct *work)
 	struct super_block *sb = oinfo->dqi_gqinode->i_sb;
 
 	dquot_scan_active(sb, ocfs2_sync_dquot_helper, oinfo->dqi_type);
-	queue_delayed_work(ocfs2_quota_wq, &oinfo->dqi_sync_work,
-			   msecs_to_jiffies(oinfo->dqi_syncms));
+	schedule_delayed_work(&oinfo->dqi_sync_work,
+			      msecs_to_jiffies(oinfo->dqi_syncms));
 }
 
 /*
@@ -923,20 +921,3 @@ const struct dquot_operations ocfs2_quota_operations = {
 	.alloc_dquot	= ocfs2_alloc_dquot,
 	.destroy_dquot	= ocfs2_destroy_dquot,
 };
-
-int ocfs2_quota_setup(void)
-{
-	ocfs2_quota_wq = create_workqueue("o2quot");
-	if (!ocfs2_quota_wq)
-		return -ENOMEM;
-	return 0;
-}
-
-void ocfs2_quota_shutdown(void)
-{
-	if (ocfs2_quota_wq) {
-		flush_workqueue(ocfs2_quota_wq);
-		destroy_workqueue(ocfs2_quota_wq);
-		ocfs2_quota_wq = NULL;
-	}
-}
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index cfeab7c..23dd818 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1639,16 +1639,11 @@ static int __init ocfs2_init(void)
 		mlog(ML_ERROR, "Unable to create ocfs2 debugfs root.\n");
 	}
 
-	status = ocfs2_quota_setup();
-	if (status)
-		goto leave;
-
 	ocfs2_set_locking_protocol();
 
 	status = register_quota_format(&ocfs2_quota_format);
 leave:
 	if (status < 0) {
-		ocfs2_quota_shutdown();
 		ocfs2_free_mem_caches();
 		exit_ocfs2_uptodate_cache();
 	}
@@ -1665,8 +1660,6 @@ static void __exit ocfs2_exit(void)
 {
 	mlog_entry_void();
 
-	ocfs2_quota_shutdown();
-
 	if (ocfs2_wq) {
 		flush_workqueue(ocfs2_wq);
 		destroy_workqueue(ocfs2_wq);
-- 
1.7.1

