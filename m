Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab1ERQbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:31:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35989 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab1ERQbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:31:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=hVVXbKEA8hxrhEpHaYoBeZTBiY8COWjBPhRsBBA4PgEneVAR+g698VRGyaQM8kB4Op
         ST76Mb6Ve/7v218nKwv7qdpflWwIqBTViUgc+KThmD1VhE53zG3Ub/+TKwwZJJkvv1CV
         Q8j68BQwOOnMWs1fqyX4BgIqIMJf+DX7aolV4=
Date: Wed, 18 May 2011 20:31:44 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        Eugene Teo <eugeneteo@gmail.com>
Subject: [RFC] add mount options to sysfs
Message-ID: <20110518163142.GA3367@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is no good way to effectively globally restrict an
access to sysfs files.  It's possible only to chmod the sysfs'
root/directories to fully deny access to sysfs (sub-)tree to some users
or chmod files after they are created.  The latter approach is racy,
however.

The patch introduces sysfs mount options parsing and adds 4 new options:
uid, gid, mode and umask.  uid, gid, and umask are classical options,
mode is a global restricting mode mask that defined the most relaxed
possible file mode.  E.g. if mode=0750 then "chmod 0664" changes file's
permissions to 0640.

If one uses "umask" then he also has to chmod already existing sysfs
files. "mode" tries to simplify things by restricting _all_ files'
permissions - both already existing and will be created in the future.

uid, gid, and umask values should be reachable when kobject is
created, so it must not be located in sysfs' superblock - there is no
one to one mapping of kobjects and sysfs_super_info.  (If there are any
thoughts about how kobject <-> superblock connection may be introduced,
please tell me.) Only networking kobjects are connected to
sysfs_super_info with the same net namespace, but if/when other
namespaces are added to sysfs_super_info.ns it would be changed.
Currently uid, gid, umask are stored in global struct.  Only root
process of the main namespace should change uid, gid, and umask options
because most kobjects are system wide.  I made a fake check of
capable(CAP_SYS_ADMIN), but it needs some other check.  In OpenVZ kernel
container's root and real root have different capabilities, but this is
not implemented in upstream kernel AFAIK.


TODO:
  - introduce real check for uid/gid/umask
  - document mount options
  - divide the patch into option parsing and adding actual options

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index ea9120a..ce12dfe 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -325,8 +325,10 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 	atomic_set(&sd->s_active, 0);
 
 	sd->s_name = name;
-	sd->s_mode = mode;
+	sd->s_mode = mode & ~sysfs_perms.umask;
 	sd->s_flags = type;
+	sd->s_uid = sysfs_perms.uid;
+	sd->s_gid = sysfs_perms.gid;
 
 	return sd;
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 0a12eb8..2764d07 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -17,6 +17,7 @@
 #include <linux/backing-dev.h>
 #include <linux/capability.h>
 #include <linux/errno.h>
+#include <linux/mount.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/sysfs.h>
@@ -217,8 +218,9 @@ static int sysfs_count_nlink(struct sysfs_dirent *sd)
 static void sysfs_refresh_inode(struct sysfs_dirent *sd, struct inode *inode)
 {
 	struct sysfs_inode_attrs *iattrs = sd->s_iattr;
+	struct sysfs_super_info *sb_info = sysfs_info(inode->i_sb);
 
-	inode->i_mode = sd->s_mode;
+	inode->i_mode = sd->s_mode & (sb_info->mode | ~0777);
 	if (iattrs) {
 		/* sysfs_dirent has non-default attributes
 		 * get them from persistent copy in sysfs_dirent
@@ -256,6 +258,8 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 	inode->i_op = &sysfs_inode_operations;
 
 	set_default_inode_attr(inode, sd->s_mode);
+	inode->i_uid = sd->s_uid;
+	inode->i_gid = sd->s_gid;
 	sysfs_refresh_inode(sd, inode);
 
 	/* initialize inode according to type */
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 2668957..c6c337d 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -18,10 +18,14 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/magic.h>
+#include <linux/parser.h>
 #include <linux/slab.h>
 
 #include "sysfs.h"
 
+struct sysfs_perms sysfs_perms;
+
+static int sysfs_remount_fs(struct super_block * sb, int *flags, char *data);
 
 static struct vfsmount *sysfs_mnt;
 struct kmem_cache *sysfs_dir_cachep;
@@ -30,6 +34,7 @@ static const struct super_operations sysfs_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
 	.evict_inode	= sysfs_evict_inode,
+	.remount_fs	= sysfs_remount_fs,
 };
 
 struct sysfs_dirent sysfs_root = {
@@ -40,10 +45,77 @@ struct sysfs_dirent sysfs_root = {
 	.s_ino		= 1,
 };
 
+enum {
+	Opt_uid, Opt_gid, Opt_umask, Opt_mode, Opt_err
+};
+
+static const match_table_t sysfs_tokens = {
+	{Opt_uid, "uid=%u"},
+	{Opt_gid, "gid=%u"},
+	{Opt_umask, "umask=%o"},
+	{Opt_mode, "mode=%o"},
+	{Opt_err, NULL},
+};
+
+static int parse_options(char *options, struct sysfs_super_info *sb_info)
+{
+	char *p;
+	int option;
+	substring_t args[MAX_OPT_ARGS];
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		int token;
+		if (!*p)
+			continue;
+
+		token = match_token(p, sysfs_tokens, args);
+
+		switch (token) {
+		case Opt_uid:
+		case Opt_gid:
+		case Opt_umask:
+			if (!capable(CAP_SYS_ADMIN))
+				return -EPERM;
+		default:
+			break;
+		}
+
+		switch (token) {
+		case Opt_uid:
+			if (match_int(&args[0], &option))
+				return -EINVAL;
+			sysfs_perms.uid = option;
+			break;
+		case Opt_gid:
+			if (match_int(&args[0], &option))
+				return -EINVAL;
+			sysfs_perms.gid = option;
+			break;
+		case Opt_mode:
+			if (match_octal(&args[0], &option))
+				return -EINVAL;
+			sb_info->mode = option;
+			break;
+		case Opt_umask:
+			if (match_octal(&args[0], &option))
+				return -EINVAL;
+			sysfs_perms.umask = option;
+			break;
+		default:
+			pr_err("SYSFS: Unrecognized mount option \"%s\" "
+			       "or missing value\n", p);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct inode *inode;
 	struct dentry *root;
+	int err;
 
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
@@ -51,6 +123,10 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_op = &sysfs_ops;
 	sb->s_time_gran = 1;
 
+	err = parse_options(data, sysfs_info(sb));
+	if (err)
+		return err;
+
 	/* get root inode, initialize and unlock it */
 	mutex_lock(&sysfs_mutex);
 	inode = sysfs_get_inode(sb, &sysfs_root);
@@ -109,6 +185,7 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 
 	for (type = KOBJ_NS_TYPE_NONE; type < KOBJ_NS_TYPES; type++)
 		info->ns[type] = kobj_ns_current(type);
+	info->mode = 0777;
 
 	sb = sget(fs_type, sysfs_test_super, sysfs_set_super, info);
 	if (IS_ERR(sb) || sb->s_fs_info != info)
@@ -128,6 +205,11 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 	return dget(sb->s_root);
 }
 
+static int sysfs_remount_fs(struct super_block * sb, int *flags, char *data)
+{
+	return parse_options(data, sysfs_info(sb));
+}
+
 static void sysfs_kill_sb(struct super_block *sb)
 {
 	struct sysfs_super_info *info = sysfs_info(sb);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 3d28af3..d474f1e 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -69,6 +69,8 @@ struct sysfs_dirent {
 
 	unsigned int		s_flags;
 	unsigned short		s_mode;
+	uid_t			s_uid;
+	gid_t			s_gid;
 	ino_t			s_ino;
 	struct sysfs_inode_attrs *s_iattr;
 };
@@ -130,6 +132,13 @@ struct sysfs_addrm_cxt {
  * mount.c
  */
 
+struct sysfs_perms {
+	unsigned int umask;
+	gid_t gid;
+	uid_t uid;
+};
+extern struct sysfs_perms sysfs_perms;
+
 /*
  * Each sb is associated with a set of namespace tags (i.e.
  * the network namespace of the task which mounted this sysfs
@@ -137,6 +146,7 @@ struct sysfs_addrm_cxt {
  */
 struct sysfs_super_info {
 	const void *ns[KOBJ_NS_TYPES];
+	unsigned int mode;
 };
 #define sysfs_info(SB) ((struct sysfs_super_info *)(SB->s_fs_info))
 extern struct sysfs_dirent sysfs_root;
