Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab2GKTCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:02:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758062Ab2GKTCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:02:18 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: aris@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] userns: Convert AFFS to use kuid and kgid where appropriate
Date: Wed, 11 Jul 2012 15:01:20 -0400
Message-Id: <1342033282-24933-4-git-send-email-arozansk@redhat.com>
In-Reply-To: <1342033282-24933-1-git-send-email-arozansk@redhat.com>
References: <1342033282-24933-1-git-send-email-arozansk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aristeu Rozanski <aris@redhat.com>

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
---
 fs/affs/inode.c |   30 ++++++++++++++------------
 fs/affs/super.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++-------
 init/Kconfig    |    1 -
 3 files changed, 68 insertions(+), 23 deletions(-)

diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 88a4b0b..04eba35 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -78,24 +78,24 @@ struct inode *affs_iget(struct super_block *sb, unsigned long ino)
 
 	id = be16_to_cpu(tail->uid);
 	if (id == 0 || sbi->s_flags & SF_SETUID)
-		inode->i_uid = sbi->s_uid;
+		i_uid_write(inode, sbi->s_uid);
 	else if (id == 0xFFFF && sbi->s_flags & SF_MUFS)
-		inode->i_uid = 0;
+		inode->i_uid = GLOBAL_ROOT_UID;
 	else
-		inode->i_uid = id;
+		i_uid_write(inode, id);
 
 	id = be16_to_cpu(tail->gid);
 	if (id == 0 || sbi->s_flags & SF_SETGID)
-		inode->i_gid = sbi->s_gid;
+		i_gid_write(inode, sbi->s_gid);
 	else if (id == 0xFFFF && sbi->s_flags & SF_MUFS)
-		inode->i_gid = 0;
+		inode->i_gid = GLOBAL_ROOT_GID;
 	else
-		inode->i_gid = id;
+		i_gid_write(inode, id);
 
 	switch (be32_to_cpu(tail->stype)) {
 	case ST_ROOT:
-		inode->i_uid = sbi->s_uid;
-		inode->i_gid = sbi->s_gid;
+		i_uid_write(inode, sbi->s_uid);
+		i_gid_write(inode, sbi->s_gid);
 		/* fall through */
 	case ST_USERDIR:
 		if (be32_to_cpu(tail->stype) == ST_USERDIR ||
@@ -193,13 +193,15 @@ affs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		tail->size = cpu_to_be32(inode->i_size);
 		secs_to_datestamp(inode->i_mtime.tv_sec,&tail->change);
 		if (!(inode->i_ino == AFFS_SB(sb)->s_root_block)) {
-			uid = inode->i_uid;
-			gid = inode->i_gid;
+			uid = from_kuid_munged(&init_user_ns, inode->i_uid);
+			gid = from_kgid_munged(&init_user_ns, inode->i_gid);
 			if (AFFS_SB(sb)->s_flags & SF_MUFS) {
-				if (inode->i_uid == 0 || inode->i_uid == 0xFFFF)
-					uid = inode->i_uid ^ ~0;
-				if (inode->i_gid == 0 || inode->i_gid == 0xFFFF)
-					gid = inode->i_gid ^ ~0;
+				if (uid_eq(inode->i_uid, GLOBAL_ROOT_UID) ||
+				    uid == 0xFFFF)
+					uid ^= ~0;
+				if (gid_eq(inode->i_gid, GLOBAL_ROOT_GID) ||
+				    gid == 0xFFFF)
+					gid ^= ~0;
 			}
 			if (!(AFFS_SB(sb)->s_flags & SF_SETUID))
 				tail->uid = cpu_to_be16(uid);
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 0782653..49d6e3e 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -176,11 +176,13 @@ parse_options(char *options, uid_t *uid, gid_t *gid, int *mode, int *reserved, s
 {
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
+	kuid_t kuid;
+	kgid_t kgid;
 
 	/* Fill in defaults */
 
-	*uid        = current_uid();
-	*gid        = current_gid();
+	*uid        = from_kuid_munged(&init_user_ns, current_uid());
+	*gid        = from_kgid_munged(&init_user_ns, current_gid());
 	*reserved   = 2;
 	*root       = -1;
 	*blocksize  = -1;
@@ -236,13 +238,23 @@ parse_options(char *options, uid_t *uid, gid_t *gid, int *mode, int *reserved, s
 		case Opt_setgid:
 			if (match_int(&args[0], &option))
 				return 0;
-			*gid = option;
+			kgid = make_kgid(current_user_ns(), option);
+			if (!gid_valid(kgid)) {
+				printk(KERN_INFO "AFFS: invalid GID\n");
+				return 0;
+			}
+			*gid = from_kgid_munged(&init_user_ns, kgid);
 			*mount_opts |= SF_SETGID;
 			break;
 		case Opt_setuid:
 			if (match_int(&args[0], &option))
 				return 0;
-			*uid = option;
+			kuid = make_kuid(current_user_ns(), option);
+			if (!uid_valid(kuid)) {
+				printk(KERN_INFO "AFFS: invalid UID\n");
+				return 0;
+			}
+			*uid = from_kuid_munged(&init_user_ns, kuid);
 			*mount_opts |= SF_SETUID;
 			break;
 		case Opt_verbose:
@@ -291,6 +303,8 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 	int			 tmp_flags;	/* fix remount prototype... */
 	u8			 sig[4];
 	int			 ret = -EINVAL;
+	kuid_t			 kuid;
+	kgid_t			 kgid;
 
 	save_mount_options(sb, data);
 
@@ -318,10 +332,24 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	/* N.B. after this point s_prefix must be released */
 
+	kuid = make_kuid(current_user_ns(), uid);
+	if (!uid_valid(kuid)) {
+		printk(KERN_ERR "AFFS: Invalid UID\n");
+		kfree(sbi->s_prefix);
+		kfree(sbi);
+		return -EINVAL;
+	}
+	kgid = make_kgid(current_user_ns(), gid);
+	if (!gid_valid(kgid)) {
+		printk(KERN_ERR "AFFS: Invalid GID\n");
+		kfree(sbi->s_prefix);
+		kfree(sbi);
+		return -EINVAL;
+	}
 	sbi->s_flags   = mount_flags;
 	sbi->s_mode    = i;
-	sbi->s_uid     = uid;
-	sbi->s_gid     = gid;
+	sbi->s_uid     = from_kuid_munged(&init_user_ns, kuid);
+	sbi->s_gid     = from_kgid_munged(&init_user_ns, kgid);
 	sbi->s_reserved= reserved;
 
 	/* Get the size of the device in 512-byte blocks.
@@ -517,6 +545,8 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 	char			*new_opts = kstrdup(data, GFP_KERNEL);
 	char			 volume[32];
 	char			*prefix = NULL;
+	kuid_t			 kuid;
+	kgid_t			 kgid;
 
 	pr_debug("AFFS: remount(flags=0x%x,opts=\"%s\")\n",*flags,data);
 
@@ -533,10 +563,24 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 
 	replace_mount_options(sb, new_opts);
 
+	kuid = make_kuid(current_user_ns(), uid);
+	if (!uid_valid(kuid)) {
+		printk(KERN_ERR "AFFS: Invalid UID\n");
+		kfree(prefix);
+		kfree(new_opts);
+		return -EINVAL;
+	}
+	kgid = make_kgid(current_user_ns(), gid);
+	if (!gid_valid(kgid)) {
+		printk(KERN_ERR "AFFS: Invalid GID\n");
+		kfree(prefix);
+		kfree(new_opts);
+		return -EINVAL;
+	}
 	sbi->s_flags = mount_flags;
 	sbi->s_mode  = mode;
-	sbi->s_uid   = uid;
-	sbi->s_gid   = gid;
+	sbi->s_uid   = from_kuid_munged(&init_user_ns, kuid);
+	sbi->s_gid   = from_kgid_munged(&init_user_ns, kgid);
 	/* protect against readers */
 	spin_lock(&sbi->symlink_lock);
 	if (prefix) {
diff --git a/init/Kconfig b/init/Kconfig
index 4d8d44d..52a3736 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -909,7 +909,6 @@ config UIDGID_CONVERTED
 	depends on DEVTMPFS = n
 	depends on XENFS = n
 
-	depends on AFFS_FS = n
 	depends on AFS_FS = n
 	depends on AUTOFS4_FS = n
 	depends on BEFS_FS = n
-- 
1.7.1

