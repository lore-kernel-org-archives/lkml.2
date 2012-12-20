Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab2LTOq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 09:46:27 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41658 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab2LTOpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 09:45:11 -0500
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, david@fromorbit.com,
        dave@jikos.cz, darrick.wong@oracle.com, andi@firstfloor.org,
        hch@infradead.org, linuxram@linux.vnet.ibm.com, zwu.kernel@gmail.com,
        wuzhy@linux.vnet.ibm.com
Subject: [PATCH RESEND v1 14/16] proc: add two hot_track proc files
Date: Thu, 20 Dec 2012 22:43:33 +0800
Message-Id: <1356014615-15073-15-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
References: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12122014-7182-0000-0000-000003EDEB33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add two proc files hot-kick-time and hot-update-delay
under the dir /proc/sys/fs/ in order to turn
TIME_TO_KICK and HEAT_UPDATE_DELAY into be tunable.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |   12 +++++++++---
 fs/hot_tracking.h            |    9 ---------
 include/linux/hot_tracking.h |    7 +++++++
 kernel/sysctl.c              |   14 ++++++++++++++
 4 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 94fe029..74d01da 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -27,6 +27,12 @@
 
 static struct dentry *hot_debugfs_root;
 
+int sysctl_hot_kick_time __read_mostly = 300;
+EXPORT_SYMBOL_GPL(sysctl_hot_kick_time);
+
+int sysctl_hot_update_delay __read_mostly = 300;
+EXPORT_SYMBOL_GPL(sysctl_hot_update_delay);
+
 /* kmem_cache pointers for slab caches */
 static struct kmem_cache *hot_inode_item_cachep __read_mostly;
 static struct kmem_cache *hot_range_item_cachep __read_mostly;
@@ -409,7 +415,7 @@ static bool hot_is_obsolete(struct hot_freq_data *freq_data)
 		(cur_time - timespec_to_ns(&freq_data->last_read_time));
 	u64 last_write_ns =
 		(cur_time - timespec_to_ns(&freq_data->last_write_time));
-	u64 kick_ns =  TIME_TO_KICK * NSEC_PER_SEC;
+	u64 kick_ns =  sysctl_hot_kick_time * NSEC_PER_SEC;
 
 	if ((last_read_ns > kick_ns) && (last_write_ns > kick_ns))
 		ret = 1;
@@ -617,7 +623,7 @@ static void hot_update_worker(struct work_struct *work)
 
 	/* Instert next delayed work */
 	queue_delayed_work(root->update_wq, &root->update_work,
-		msecs_to_jiffies(HEAT_UPDATE_DELAY * MSEC_PER_SEC));
+		msecs_to_jiffies(sysctl_hot_update_delay * MSEC_PER_SEC));
 }
 
 static void *hot_range_seq_start(struct seq_file *seq, loff_t *pos)
@@ -1290,7 +1296,7 @@ int hot_track_init(struct super_block *sb)
 	/* Initialize hot tracking wq and arm one delayed work */
 	INIT_DELAYED_WORK(&root->update_work, hot_update_worker);
 	queue_delayed_work(root->update_wq, &root->update_work,
-		msecs_to_jiffies(HEAT_UPDATE_DELAY * MSEC_PER_SEC));
+		msecs_to_jiffies(sysctl_hot_update_delay * MSEC_PER_SEC));
 
 	/* Register a shrinker callback */
 	root->hot_shrink.shrink = hot_track_prune;
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index a969940..ab6d603 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -23,15 +23,6 @@
 #define RANGE_BITS 20
 #define FREQ_POWER 4
 
-/*
- * time to quit keeping track of
- * tracking data (seconds)
- */
-#define TIME_TO_KICK 300
-
-/* set how often to update temperatures (seconds) */
-#define HEAT_UPDATE_DELAY 300
-
 /* NRR/NRW heat unit = 2^X accesses */
 #define NRR_MULTIPLIER_POWER 20 /* NRR - number of reads since mount */
 #define NRR_COEFF_POWER 0
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index a735f58..6130687 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -126,6 +126,13 @@ struct hot_info {
 };
 
 /*
+ * Two variables have meanings as below:
+ * 1. time to quit keeping track of tracking data (seconds)
+ * 2. set how often to update temperatures (seconds)
+ */
+extern int sysctl_hot_kick_time, sysctl_hot_update_delay;
+
+/*
  * Hot data tracking ioctls:
  *
  * HOT_INFO - retrieve info on frequency of access
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c88878d..b7e233e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1586,6 +1586,20 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &pipe_proc_fn,
 		.extra1		= &pipe_min_size,
 	},
+	{
+		.procname	= "hot-kick-time",
+		.data		= &sysctl_hot_kick_time,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "hot-update-delay",
+		.data		= &sysctl_hot_update_delay,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{ }
 };
 
-- 
1.7.6.5

