Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab2KPJw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:52:27 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45803 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab2KPJwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:52:24 -0500
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v1 hot_track 12/16] vfs: add one ioctl interface
Date: Fri, 16 Nov 2012 17:51:14 +0800
Message-Id: <1353059478-25474-13-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1353059478-25474-1-git-send-email-zwu.kernel@gmail.com>
References: <1353059478-25474-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111609-1976-0000-0000-000013734A14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  FS_IOC_GET_HEAT_INFO: return a struct containing the various
metrics collected in hot_freq_data structs, and also return a
calculated data temperature based on those metrics. Optionally, retrieve
the temperature from the hot data hash list instead of recalculating it.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/compat_ioctl.c            |    5 +++
 fs/ioctl.c                   |   74 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/hot_tracking.h |   19 +++++++++++
 3 files changed, 98 insertions(+), 0 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 4c6285f..ad1d603 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -57,6 +57,7 @@
 #include <linux/i2c-dev.h>
 #include <linux/atalk.h>
 #include <linux/gfp.h>
+#include <linux/hot_tracking.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci.h>
@@ -1400,6 +1401,9 @@ COMPATIBLE_IOCTL(TIOCSTART)
 COMPATIBLE_IOCTL(TIOCSTOP)
 #endif
 
+/*Hot data tracking*/
+COMPATIBLE_IOCTL(FS_IOC_GET_HEAT_INFO)
+
 /* fat 'r' ioctls. These are handled by fat with ->compat_ioctl,
    but we don't want warnings on other file systems. So declare
    them as compatible here. */
@@ -1579,6 +1583,7 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 	case FIBMAP:
 	case FIGETBSZ:
 	case FIONREAD:
+	case FS_IOC_GET_HEAT_INFO:
 		if (S_ISREG(f.file->f_path.dentry->d_inode->i_mode))
 			break;
 		/*FALL THROUGH*/
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 3bdad6d..79fe81f 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -15,6 +15,7 @@
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
 #include <linux/falloc.h>
+#include <linux/hot_tracking.h>
 
 #include <asm/ioctls.h>
 
@@ -537,6 +538,76 @@ static int ioctl_fsthaw(struct file *filp)
 }
 
 /*
+ * Retrieve information about access frequency for the given file. Return it in
+ * a userspace-friendly struct for btrfsctl (or another tool) to parse.
+ *
+ * The temperature that is returned can be "live" -- that is, recalculated when
+ * the ioctl is called -- or it can be returned from the hashtable, reflecting
+ * the (possibly old) value that the system will use when considering files
+ * for migration. This behavior is determined by hot_heat_info->live.
+ */
+static int ioctl_heat_info(struct file *file, void __user *argp)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct hot_heat_info heat_info;
+	struct hot_inode_item *he;
+	int ret = 0;
+
+	if (copy_from_user((void *)&heat_info,
+			argp,
+			sizeof(struct hot_heat_info)) != 0) {
+		ret = -EFAULT;
+		goto err;
+	}
+
+	he = hot_inode_item_lookup(inode->i_sb->s_hot_root, inode->i_ino);
+	if (!he) {
+		/* we don't have any info on this file yet */
+		ret = -ENODATA;
+		goto err;
+	}
+
+	spin_lock(&he->hot_inode.lock);
+	heat_info.avg_delta_reads =
+		(__u64) he->hot_inode.hot_freq_data.avg_delta_reads;
+	heat_info.avg_delta_writes =
+		(__u64) he->hot_inode.hot_freq_data.avg_delta_writes;
+	heat_info.last_read_time =
+	(__u64) timespec_to_ns(&he->hot_inode.hot_freq_data.last_read_time);
+	heat_info.last_write_time =
+	(__u64) timespec_to_ns(&he->hot_inode.hot_freq_data.last_write_time);
+	heat_info.num_reads =
+		(__u32) he->hot_inode.hot_freq_data.nr_reads;
+	heat_info.num_writes =
+		(__u32) he->hot_inode.hot_freq_data.nr_writes;
+
+	if (heat_info.live > 0) {
+		/*
+		 * got a request for live temperature,
+		 * call hot_hash_calc_temperature to recalculate
+		 */
+		heat_info.temp =
+		inode->i_sb->s_hot_root->hot_type->ops.hot_temp_calc_fn(
+					&he->hot_inode.hot_freq_data);
+	} else {
+		/* not live temperature, get it from the hashlist */
+		heat_info.temp = he->hot_inode.hot_freq_data.last_temp;
+	}
+	spin_unlock(&he->hot_inode.lock);
+
+	hot_inode_item_put(he);
+
+	if (copy_to_user(argp, (void *)&heat_info,
+			sizeof(struct hot_heat_info))) {
+		ret = -EFAULT;
+		goto err;
+	}
+
+err:
+	return ret;
+}
+
+/*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
  *
@@ -591,6 +662,9 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 	case FIGETBSZ:
 		return put_user(inode->i_sb->s_blocksize, argp);
 
+	case FS_IOC_GET_HEAT_INFO:
+		return ioctl_heat_info(filp, argp);
+
 	default:
 		if (S_ISREG(inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 24e91ff..97283b3 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -44,6 +44,17 @@ struct hot_freq_data {
 	u32 last_temp;
 };
 
+struct hot_heat_info {
+	__u64 avg_delta_reads;
+	__u64 avg_delta_writes;
+	__u64 last_read_time;
+	__u64 last_write_time;
+	__u32 num_reads;
+	__u32 num_writes;
+	__u32 temp;
+	__u8 live;
+};
+
 /* List heads in hot map array */
 struct hot_map_head {
 	struct list_head node_list;
@@ -113,6 +124,14 @@ struct hot_info {
 	struct shrinker hot_shrink;
 };
 
+/*
+ * Hot data tracking ioctls:
+ *
+ * HOT_INFO - retrieve info on frequency of access
+ */
+#define FS_IOC_GET_HEAT_INFO _IOR('f', 17, \
+			struct hot_heat_info)
+
 extern void __init hot_cache_init(void);
 extern int hot_track_init(struct super_block *sb);
 extern void hot_track_exit(struct super_block *sb);
-- 
1.7.6.5

