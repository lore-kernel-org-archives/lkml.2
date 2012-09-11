Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab2IKOug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:50:36 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59157 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755975Ab2IKOue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:50:34 -0400
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
        viro@zeniv.linux.org.uk, hch@lst.de, chris.mason@fusionio.com,
        cmm@us.ibm.com, linuxram@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC 10/11] vfs: add 3 new ioctl interfaces
Date: Tue, 11 Sep 2012 22:40:44 +0800
Message-Id: <1347374445-3018-5-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1347374445-3018-1-git-send-email-zwu.kernel@gmail.com>
References: <1347374445-3018-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091114-7182-0000-0000-000002930AB0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  FS_IOC_GET_HEAT_INFO: return a struct containing the various
metrics collected in btrfs_freq_data structs, and also return a
calculated data temperature based on those metrics. Optionally, retrieve
the temperature from the hot data hash list instead of recalculating it.

  FS_IOC_GET_HEAT_OPTS: return an integer representing the current
state of hot data tracking and migration:

0 = do nothing
1 = track frequency of access

FS_IOC_SET_HEAT_OPTS: change the state of hot data tracking and
migration, as described above.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/compat_ioctl.c         |    8 +++
 fs/ioctl.c                |  132 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h        |   11 ++++
 include/linux/hot_track.h |   12 ++++
 4 files changed, 163 insertions(+), 0 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index debdfe0..a88c7de 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1390,6 +1390,11 @@ COMPATIBLE_IOCTL(TIOCSTART)
 COMPATIBLE_IOCTL(TIOCSTOP)
 #endif
 
+/*Hot data tracking*/
+COMPATIBLE_IOCTL(FS_IOC_GET_HEAT_INFO)
+COMPATIBLE_IOCTL(FS_IOC_SET_HEAT_OPTS)
+COMPATIBLE_IOCTL(FS_IOC_GET_HEAT_OPTS)
+
 /* fat 'r' ioctls. These are handled by fat with ->compat_ioctl,
    but we don't want warnings on other file systems. So declare
    them as compatible here. */
@@ -1572,6 +1577,9 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 	case FIBMAP:
 	case FIGETBSZ:
 	case FIONREAD:
+	case FS_IOC_GET_HEAT_INFO:
+	case FS_IOC_SET_HEAT_OPTS:
+	case FS_IOC_GET_HEAT_OPTS:
 		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
 			break;
 		/*FALL THROUGH*/
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 29167be..9242969 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -18,6 +18,9 @@
 
 #include <asm/ioctls.h>
 
+#include "hot_hash.h"
+#include "hot_rb.h"
+
 /* So that the fiemap access checks can't overflow on 32 bit machines. */
 #define FIEMAP_MAX_EXTENTS	(UINT_MAX / sizeof(struct fiemap_extent))
 
@@ -537,6 +540,126 @@ static int ioctl_fsthaw(struct file *filp)
 }
 
 /*
+ * Retrieve information about access frequency for the given file. Return it in
+ * a userspace-friendly struct for btrfsctl (or another tool) to parse.
+ *
+ * The temperature that is returned can be "live" -- that is, recalculated when
+ * the ioctl is called -- or it can be returned from the hashtable, reflecting
+ * the (possibly old) value that the system will use when considering files
+ * for migration. This behavior is determined by heat_info->live.
+ */
+static int ioctl_heat_info(struct file *file, void __user *argp)
+{
+	struct inode *mnt_inode = file->f_path.dentry->d_inode;
+	struct inode *file_inode;
+	struct file *file_filp;
+	struct hot_info *root = &(mnt_inode->i_sb->s_hotinfo);
+	struct heat_info *heat_info;
+	struct hot_inode_tree *hitree;
+	struct hot_inode_item *he;
+	int ret;
+
+	heat_info = kmalloc(sizeof(struct heat_info),
+				GFP_KERNEL | GFP_NOFS);
+
+	if (copy_from_user((void *) heat_info,
+			argp,
+			sizeof(struct heat_info)) != 0) {
+		ret = -EFAULT;
+		goto err;
+	}
+
+	file_filp = filp_open(heat_info->filename, O_RDONLY, 0);
+	file_inode = file_filp->f_dentry->d_inode;
+	filp_close(file_filp, NULL);
+
+	hitree = &root->hot_inode_tree;
+	read_lock(&hitree->lock);
+	he = hot_rb_lookup_hot_inode_item(hitree, file_inode->i_ino);
+	read_unlock(&hitree->lock);
+	if (!he) {
+		/* we don't have any info on this file yet */
+		ret = -ENODATA;
+		goto err;
+	}
+
+	spin_lock(&he->lock);
+	heat_info->avg_delta_reads =
+			(__u64) he->hot_freq_data.avg_delta_reads;
+	heat_info->avg_delta_writes =
+			(__u64) he->hot_freq_data.avg_delta_writes;
+	heat_info->last_read_time =
+			(__u64) timespec_to_ns(&he->hot_freq_data.last_read_time);
+	heat_info->last_write_time =
+			(__u64) timespec_to_ns(&he->hot_freq_data.last_write_time);
+	heat_info->num_reads =
+			(__u32) he->hot_freq_data.nr_reads;
+	heat_info->num_writes =
+			(__u32) he->hot_freq_data.nr_writes;
+
+	if (heat_info->live > 0) {
+		/* got a request for live temperature,
+		 * call hot_hash_calc_temperature to recalculate
+		 */
+		heat_info->temperature =
+			hot_hash_calc_temperature(&he->hot_freq_data);
+	} else {
+		/* not live temperature, get it from the hashlist */
+		read_lock(&he->heat_node->hlist->rwlock);
+		heat_info->temperature = he->heat_node->hlist->temperature;
+		read_unlock(&he->heat_node->hlist->rwlock);
+	}
+	spin_unlock(&he->lock);
+
+	hot_rb_free_hot_inode_item(he);
+
+	if (copy_to_user(argp, (void *) heat_info,
+			sizeof(struct heat_info))) {
+		ret = -EFAULT;
+		goto err;
+	}
+
+	kfree(heat_info);
+	return 0;
+
+err:
+	kfree(heat_info);
+	return ret;
+}
+
+static int ioctl_heat_opts(struct file *file, void __user *argp, int set)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	int arg, ret = 0;
+
+	if (!set) {
+		arg = TRACK_THIS_INODE(inode) ? 1 : 0;
+
+		if (copy_to_user(argp, (void *) &arg, sizeof(int)) != 0)
+			ret = -EFAULT;
+	} else {
+		if (copy_from_user((void *) &arg, argp, sizeof(int)) != 0) {
+			ret = -EFAULT;
+		} else {
+			switch (arg) {
+			case 0: /* track nothing */
+				/* set S_NOHOTDATATRACK */
+				inode->i_flags |= S_NOHOTDATATRACK;
+				break;
+			case 1: /* do tracking */
+				/* clear S_NOHOTDATATRACK */
+				inode->i_flags &= ~S_NOHOTDATATRACK;
+				break;
+			default:
+				ret = -EINVAL;
+			}
+		}
+	}
+
+	return ret;
+}
+
+/*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
  *
@@ -591,6 +714,15 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 	case FIGETBSZ:
 		return put_user(inode->i_sb->s_blocksize, argp);
 
+	case FS_IOC_GET_HEAT_INFO:
+		return ioctl_heat_info(filp, argp);
+
+	case FS_IOC_SET_HEAT_OPTS:
+		return ioctl_heat_opts(filp, argp, 1);
+
+	case FS_IOC_GET_HEAT_OPTS:
+		return ioctl_heat_opts(filp, argp, 0);
+
 	default:
 		if (S_ISREG(inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6229895..99698f1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -256,6 +256,7 @@ struct inodes_stat_t {
 #define S_IMA		1024	/* Inode has an associated IMA struct */
 #define S_AUTOMOUNT	2048	/* Automount/referral quasi-directory */
 #define S_NOSEC		4096	/* no suid or xattr security attributes */
+#define S_NOHOTDATATRACK (1 << 13)	/* hot data tracking */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
@@ -354,6 +355,16 @@ struct inodes_stat_t {
 #define FS_IOC32_SETVERSION		_IOW('v', 2, int)
 
 /*
+ * Hot data tracking ioctls:
+ *
+ * HOT_INFO - retrieve info on frequency of access
+ */
+#define FS_IOC_GET_HEAT_INFO _IOR('f', 17, \
+				struct heat_info)
+#define FS_IOC_SET_HEAT_OPTS _IOW('f', 18, int)
+#define FS_IOC_GET_HEAT_OPTS _IOR('f', 19, int)
+
+/*
  * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
  */
 #define	FS_SECRM_FL			0x00000001 /* Secure deletion */
diff --git a/include/linux/hot_track.h b/include/linux/hot_track.h
index 6b8493a..152d3f6 100644
--- a/include/linux/hot_track.h
+++ b/include/linux/hot_track.h
@@ -68,6 +68,18 @@ struct hot_freq_data {
 	u32 last_temperature;
 };
 
+struct heat_info {
+	__u64 avg_delta_reads;
+	__u64 avg_delta_writes;
+	__u64 last_read_time;
+	__u64 last_write_time;
+	__u32 num_reads;
+	__u32 num_writes;
+	__u32 temperature;
+	__u8 live;
+	char filename[PATH_MAX];
+};
+
 /* Hash list heads for hot hash table */
 struct hot_hash_head {
 	struct hlist_head hashhead;
-- 
1.7.6.5

