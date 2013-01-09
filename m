Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3AIFoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 00:44:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab3AIFoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 00:44:12 -0500
Date: Wed, 9 Jan 2013 00:44:07 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Guangliang Zhao <gzhao@suse.com>
cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, lucienchao@gmail.com,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: [PATCH 1/2] mirror throttling
In-Reply-To: <1357552933-26126-1-git-send-email-gzhao@suse.com>
Message-ID: <Pine.LNX.4.64.1301090043270.29917@file.rdu.redhat.com>
References: <1357552933-26126-1-git-send-email-gzhao@suse.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dm-kcopyd: introduce per-module throttle structure

The structure contains the throttle parameter (it could be set in
/sys/module/*/parameters and auxulary variables for activity counting.

The throttle does nothing, it will be activated in the next patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c    |    2 +-
 drivers/md/dm-raid1.c     |    5 ++++-
 drivers/md/dm-snap.c      |    5 ++++-
 drivers/md/dm-thin.c      |    5 ++++-
 include/linux/dm-kcopyd.h |   15 ++++++++++++++-
 5 files changed, 27 insertions(+), 5 deletions(-)

Index: linux-3.8-rc1-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-3.8-rc1-fast.orig/drivers/md/dm-kcopyd.c	2013-01-02 23:00:49.000000000 +0100
+++ linux-3.8-rc1-fast/drivers/md/dm-kcopyd.c	2013-01-02 23:23:17.000000000 +0100
@@ -695,7 +695,7 @@ int kcopyd_cancel(struct kcopyd_job *job
 /*-----------------------------------------------------------------
  * Client setup
  *---------------------------------------------------------------*/
-struct dm_kcopyd_client *dm_kcopyd_client_create(void)
+struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *throttle)
 {
 	int r = -ENOMEM;
 	struct dm_kcopyd_client *kc;
Index: linux-3.8-rc1-fast/drivers/md/dm-raid1.c
===================================================================
--- linux-3.8-rc1-fast.orig/drivers/md/dm-raid1.c	2013-01-02 23:00:49.000000000 +0100
+++ linux-3.8-rc1-fast/drivers/md/dm-raid1.c	2013-01-02 23:23:17.000000000 +0100
@@ -82,6 +82,9 @@ struct mirror_set {
 	struct mirror mirror[0];
 };
 
+DECLARE_DM_KCOPYD_THROTTLE(raid1_resync_throttle,
+		"A percentage of time allocated for raid resynchronization");
+
 static void wakeup_mirrord(void *context)
 {
 	struct mirror_set *ms = context;
@@ -1111,7 +1114,7 @@ static int mirror_ctr(struct dm_target *
 		goto err_destroy_wq;
 	}
 
-	ms->kcopyd_client = dm_kcopyd_client_create();
+	ms->kcopyd_client = dm_kcopyd_client_create(&dm_kcopyd_throttle);
 	if (IS_ERR(ms->kcopyd_client)) {
 		r = PTR_ERR(ms->kcopyd_client);
 		goto err_destroy_wq;
Index: linux-3.8-rc1-fast/drivers/md/dm-snap.c
===================================================================
--- linux-3.8-rc1-fast.orig/drivers/md/dm-snap.c	2013-01-02 23:00:49.000000000 +0100
+++ linux-3.8-rc1-fast/drivers/md/dm-snap.c	2013-01-02 23:23:17.000000000 +0100
@@ -124,6 +124,9 @@ struct dm_snapshot {
 #define RUNNING_MERGE          0
 #define SHUTDOWN_MERGE         1
 
+DECLARE_DM_KCOPYD_THROTTLE(snapshot_copy_throttle,
+		"A percentage of time allocated for copy on write");
+
 struct dm_dev *dm_snap_origin(struct dm_snapshot *s)
 {
 	return s->origin;
@@ -1109,7 +1112,7 @@ static int snapshot_ctr(struct dm_target
 		goto bad_hash_tables;
 	}
 
-	s->kcopyd_client = dm_kcopyd_client_create();
+	s->kcopyd_client = dm_kcopyd_client_create(&dm_kcopyd_throttle);
 	if (IS_ERR(s->kcopyd_client)) {
 		r = PTR_ERR(s->kcopyd_client);
 		ti->error = "Could not create kcopyd client";
Index: linux-3.8-rc1-fast/include/linux/dm-kcopyd.h
===================================================================
--- linux-3.8-rc1-fast.orig/include/linux/dm-kcopyd.h	2013-01-02 22:59:41.000000000 +0100
+++ linux-3.8-rc1-fast/include/linux/dm-kcopyd.h	2013-01-02 23:23:17.000000000 +0100
@@ -21,11 +21,24 @@
 
 #define DM_KCOPYD_IGNORE_ERROR 1
 
+struct dm_kcopyd_throttle {
+	unsigned throttle;
+	unsigned long num_io_jobs;
+	unsigned io_period;
+	unsigned total_period;
+	unsigned last_jiffies;
+};
+
+#define DECLARE_DM_KCOPYD_THROTTLE(name, description)	\
+static struct dm_kcopyd_throttle dm_kcopyd_throttle = { 100, 0, 0, 0, 0 }; \
+module_param_named(name, dm_kcopyd_throttle.throttle, uint, 0644); \
+MODULE_PARM_DESC(name, description)
+
 /*
  * To use kcopyd you must first create a dm_kcopyd_client object.
  */
 struct dm_kcopyd_client;
-struct dm_kcopyd_client *dm_kcopyd_client_create(void);
+struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *throttle);
 void dm_kcopyd_client_destroy(struct dm_kcopyd_client *kc);
 
 /*
Index: linux-3.8-rc1-fast/drivers/md/dm-thin.c
===================================================================
--- linux-3.8-rc1-fast.orig/drivers/md/dm-thin.c	2013-01-02 23:00:49.000000000 +0100
+++ linux-3.8-rc1-fast/drivers/md/dm-thin.c	2013-01-02 23:23:17.000000000 +0100
@@ -26,6 +26,9 @@
 #define PRISON_CELLS 1024
 #define COMMIT_PERIOD HZ
 
+DECLARE_DM_KCOPYD_THROTTLE(snapshot_copy_throttle,
+		"A percentage of time allocated for copy on write");
+
 /*
  * The block size of the device holding pool data must be
  * between 64KB and 1GB.
@@ -1636,7 +1639,7 @@ static struct pool *pool_create(struct m
 		goto bad_prison;
 	}
 
-	pool->copier = dm_kcopyd_client_create();
+	pool->copier = dm_kcopyd_client_create(&dm_kcopyd_throttle);
 	if (IS_ERR(pool->copier)) {
 		r = PTR_ERR(pool->copier);
 		*error = "Error creating pool's kcopyd client";

