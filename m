Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab1HYPcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:32:08 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33076 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab1HYPJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:09 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 028/118] drbd: Minimal struct drbd_tconn
Date: Thu, 25 Aug 2011 17:07:24 +0200
Message-Id: <1314284934-17999-29-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting to dissolve the network connection from the actual
block devices.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |   15 +++++++++++++
 drivers/block/drbd/drbd_main.c |   45 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 00c9e31..c9d70e1 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -94,6 +94,7 @@ extern char usermode_helper[];
 #define UUID_NEW_BM_OFFSET ((u64)0x0001000000000000ULL)
 
 struct drbd_conf;
+struct drbd_tconn;
 
 
 /* to shorten dev_warn(DEV, "msg"); and relatives statements */
@@ -960,7 +961,18 @@ struct fifo_buffer {
 	unsigned int size;
 };
 
+struct drbd_tconn {			/* is a resource from the config file */
+	char *name;			/* Resource name */
+	struct list_head all_tconn;	/* List of all drbd_tconn, prot by global_state_lock */
+	struct drbd_conf *volume0;	/* TODO: Remove me again */
+
+	struct net_conf *net_conf;	/* protected by get_net_conf() and put_net_conf() */
+};
+
 struct drbd_conf {
+	struct drbd_tconn *tconn;
+	int vnr;			/* volume number within the connection */
+
 	/* things that are stored as / read from meta data on disk */
 	unsigned long flags;
 
@@ -1496,6 +1508,9 @@ extern rwlock_t global_state_lock;
 extern struct drbd_conf *drbd_new_device(unsigned int minor);
 extern void drbd_free_mdev(struct drbd_conf *mdev);
 
+struct drbd_tconn *drbd_new_tconn(char *name);
+extern void drbd_free_tconn(struct drbd_tconn *tconn);
+
 extern int proc_details;
 
 /* drbd_req */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 2902f6d..a6ac0c8 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -132,6 +132,7 @@ module_param_string(usermode_helper, usermode_helper, sizeof(usermode_helper), 0
  * as member "struct gendisk *vdisk;"
  */
 struct drbd_conf **minor_table;
+struct list_head drbd_tconns;  /* list of struct drbd_tconn */
 
 struct kmem_cache *drbd_request_cache;
 struct kmem_cache *drbd_ee_cache;	/* epoch entries */
@@ -3267,6 +3268,7 @@ static void drbd_delete_device(unsigned int minor)
 		bdput(mdev->this_bdev);
 
 	drbd_free_resources(mdev);
+	drbd_free_tconn(mdev->tconn);
 
 	drbd_release_ee_lists(mdev);
 
@@ -3358,6 +3360,41 @@ out:
 	return r;
 }
 
+struct drbd_tconn *drbd_new_tconn(char *name)
+{
+	struct drbd_tconn *tconn;
+
+	tconn = kzalloc(sizeof(struct drbd_tconn), GFP_KERNEL);
+	if (!tconn)
+		return NULL;
+
+	tconn->name = kstrdup(name, GFP_KERNEL);
+	if (!tconn->name)
+		goto fail;
+
+	write_lock_irq(&global_state_lock);
+	list_add(&tconn->all_tconn, &drbd_tconns);
+	write_unlock_irq(&global_state_lock);
+
+	return tconn;
+
+fail:
+	kfree(tconn->name);
+	kfree(tconn);
+
+	return NULL;
+}
+
+void drbd_free_tconn(struct drbd_tconn *tconn)
+{
+	write_lock_irq(&global_state_lock);
+	list_del(&tconn->all_tconn);
+	write_unlock_irq(&global_state_lock);
+
+	kfree(tconn->name);
+	kfree(tconn);
+}
+
 struct drbd_conf *drbd_new_device(unsigned int minor)
 {
 	struct drbd_conf *mdev;
@@ -3368,9 +3405,14 @@ struct drbd_conf *drbd_new_device(unsigned int minor)
 	mdev = kzalloc(sizeof(struct drbd_conf), GFP_KERNEL);
 	if (!mdev)
 		return NULL;
+	mdev->tconn = drbd_new_tconn("dummy");
+	if (!mdev->tconn)
+		goto out_no_tconn;
+
 	if (!zalloc_cpumask_var(&mdev->cpu_mask, GFP_KERNEL))
 		goto out_no_cpumask;
 
+	mdev->tconn->volume0 = mdev;
 	mdev->minor = minor;
 
 	drbd_init_set_defaults(mdev);
@@ -3447,6 +3489,8 @@ out_no_disk:
 out_no_q:
 	free_cpumask_var(mdev->cpu_mask);
 out_no_cpumask:
+	drbd_free_tconn(mdev->tconn);
+out_no_tconn:
 	kfree(mdev);
 	return NULL;
 }
@@ -3526,6 +3570,7 @@ int __init drbd_init(void)
 	}
 
 	rwlock_init(&global_state_lock);
+	INIT_LIST_HEAD(&drbd_tconns);
 
 	printk(KERN_INFO "drbd: initialized. "
 	       "Version: " REL_VERSION " (api:%d/proto:%d-%d)\n",
-- 
1.7.4.1

