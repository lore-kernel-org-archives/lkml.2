Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab0ELPxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:53:36 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:33727 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab0ELPvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:51:05 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V7 2/9] vfs: Add uuid based vfsmount lookup
Date: Wed, 12 May 2010 21:20:37 +0530
Message-Id: <1273679444-14903-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.78.g212f0
In-Reply-To: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a new superblock operations get_fsid that returns the
UUID mapping for the file system. The UUID returned is used to
identify the file system apart of file_handle

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namespace.c                |   47 +++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h            |   15 +++++++++++++
 include/linux/mnt_namespace.h |    3 ++
 3 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 8174c8a..c19e4fa 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2364,3 +2364,50 @@ void put_mnt_ns(struct mnt_namespace *ns)
 	kfree(ns);
 }
 EXPORT_SYMBOL(put_mnt_ns);
+
+/*
+ * Get any vfsmount mapping the uuid in the
+ * task namespace
+ */
+struct vfsmount *fs_get_vfsmount(struct task_struct *task,
+				struct uuid *fsid)
+{
+	int error;
+	struct nsproxy *nsp;
+	struct uuid this_fsid;
+	struct super_block *sb;
+	struct list_head *mount_list;
+	struct mnt_namespace *ns = NULL;
+	struct vfsmount *mnt, *sb_mnt = NULL;
+
+	rcu_read_lock();
+	nsp = task_nsproxy(task);
+	if (nsp) {
+		ns = nsp->mnt_ns;
+		if (ns)
+			get_mnt_ns(ns);
+	}
+	rcu_read_unlock();
+	if (!ns)
+		return NULL;
+	down_read(&namespace_sem);
+	list_for_each(mount_list, &ns->list) {
+		mnt = list_entry(mount_list, struct vfsmount, mnt_list);
+		sb  = mnt->mnt_sb;
+		if (!sb->s_op->get_fsid)
+			continue;
+		error = sb->s_op->get_fsid(sb, &this_fsid);
+		if (error)
+			continue;
+		if (!memcmp(fsid->uuid, this_fsid.uuid,
+				sizeof(this_fsid.uuid))) {
+			sb_mnt = mnt;
+			mntget(sb_mnt);
+			break;
+		}
+	}
+	up_read(&namespace_sem);
+
+	put_mnt_ns(ns);
+	return sb_mnt;
+}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 44f35ae..055734c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -948,6 +948,20 @@ struct file {
 	unsigned long f_mnt_write_state;
 #endif
 };
+
+struct uuid {
+	unsigned char uuid[16];
+};
+
+struct file_handle {
+	int handle_size;
+	int handle_type;
+	/* File system identifier */
+	struct uuid fsid;
+	/* file identifier */
+	unsigned char f_handle[0];
+};
+
 extern spinlock_t files_lock;
 #define file_list_lock() spin_lock(&files_lock);
 #define file_list_unlock() spin_unlock(&files_lock);
@@ -1580,6 +1594,7 @@ struct super_operations {
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
+	int (*get_fsid)(struct super_block *, struct uuid *);
 };
 
 /*
diff --git a/include/linux/mnt_namespace.h b/include/linux/mnt_namespace.h
index 0b89efc..76c62b1 100644
--- a/include/linux/mnt_namespace.h
+++ b/include/linux/mnt_namespace.h
@@ -22,6 +22,7 @@ struct proc_mounts {
 };
 
 struct fs_struct;
+struct uuid;
 
 extern struct mnt_namespace *create_mnt_ns(struct vfsmount *mnt);
 extern struct mnt_namespace *copy_mnt_ns(unsigned long, struct mnt_namespace *,
@@ -36,6 +37,8 @@ extern const struct seq_operations mounts_op;
 extern const struct seq_operations mountinfo_op;
 extern const struct seq_operations mountstats_op;
 extern int mnt_had_events(struct proc_mounts *);
+extern struct vfsmount *fs_get_vfsmount(struct task_struct *task,
+					struct uuid *fsid);
 
 #endif
 #endif
-- 
1.7.1.78.g212f0

