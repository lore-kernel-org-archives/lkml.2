Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab2GKTCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:02:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756668Ab2GKTCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:02:18 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: aris@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] userns: Convert ADFS to use kuid and kgid where appropriate
Date: Wed, 11 Jul 2012 15:01:19 -0400
Message-Id: <1342033282-24933-3-git-send-email-arozansk@redhat.com>
In-Reply-To: <1342033282-24933-1-git-send-email-arozansk@redhat.com>
References: <1342033282-24933-1-git-send-email-arozansk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aristeu Rozanski <aris@redhat.com>

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
---
 fs/adfs/inode.c |   12 ++++++++----
 fs/adfs/super.c |   26 +++++++++++++++++---------
 init/Kconfig    |    1 -
 3 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/fs/adfs/inode.c b/fs/adfs/inode.c
index 1dab6a1..4a2acea 100644
--- a/fs/adfs/inode.c
+++ b/fs/adfs/inode.c
@@ -243,8 +243,8 @@ adfs_iget(struct super_block *sb, struct object_info *obj)
 	if (!inode)
 		goto out;
 
-	inode->i_uid	 = ADFS_SB(sb)->s_uid;
-	inode->i_gid	 = ADFS_SB(sb)->s_gid;
+	i_uid_write(inode, ADFS_SB(sb)->s_uid);
+	i_gid_write(inode, ADFS_SB(sb)->s_gid);
 	inode->i_ino	 = obj->file_id;
 	inode->i_size	 = obj->size;
 	set_nlink(inode, 2);
@@ -297,6 +297,8 @@ adfs_notify_change(struct dentry *dentry, struct iattr *attr)
 	struct super_block *sb = inode->i_sb;
 	unsigned int ia_valid = attr->ia_valid;
 	int error;
+	kuid_t kuid;
+	kgid_t kgid;
 	
 	error = inode_change_ok(inode, attr);
 
@@ -304,8 +306,10 @@ adfs_notify_change(struct dentry *dentry, struct iattr *attr)
 	 * we can't change the UID or GID of any file -
 	 * we have a global UID/GID in the superblock
 	 */
-	if ((ia_valid & ATTR_UID && attr->ia_uid != ADFS_SB(sb)->s_uid) ||
-	    (ia_valid & ATTR_GID && attr->ia_gid != ADFS_SB(sb)->s_gid))
+	kuid = make_kuid(&init_user_ns, ADFS_SB(sb)->s_uid);
+	kgid = make_kgid(&init_user_ns, ADFS_SB(sb)->s_gid);
+	if ((ia_valid & ATTR_UID && !uid_eq(attr->ia_uid, kuid)) ||
+	    (ia_valid & ATTR_GID && !gid_eq(attr->ia_gid, kgid)))
 		error = -EPERM;
 
 	if (error)
diff --git a/fs/adfs/super.c b/fs/adfs/super.c
index 06fdcc9..2e27e82 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -129,11 +129,15 @@ static void adfs_put_super(struct super_block *sb)
 static int adfs_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct adfs_sb_info *asb = ADFS_SB(root->d_sb);
-
-	if (asb->s_uid != 0)
-		seq_printf(seq, ",uid=%u", asb->s_uid);
-	if (asb->s_gid != 0)
-		seq_printf(seq, ",gid=%u", asb->s_gid);
+	kuid_t kuid = make_kuid(&init_user_ns, asb->s_uid);
+	kgid_t kgid = make_kgid(&init_user_ns, asb->s_gid);
+
+	if (!uid_eq(kuid, GLOBAL_ROOT_UID))
+		seq_printf(seq, ",uid=%u", from_kuid_munged(current_user_ns(),
+							    kuid));
+	if (!gid_eq(kgid, GLOBAL_ROOT_GID))
+		seq_printf(seq, ",gid=%u", from_kgid_munged(current_user_ns(),
+							    kgid));
 	if (asb->s_owner_mask != ADFS_DEFAULT_OWNER_MASK)
 		seq_printf(seq, ",ownmask=%o", asb->s_owner_mask);
 	if (asb->s_other_mask != ADFS_DEFAULT_OTHER_MASK)
@@ -160,6 +164,8 @@ static int parse_options(struct super_block *sb, char *options)
 	char *p;
 	struct adfs_sb_info *asb = ADFS_SB(sb);
 	int option;
+	kuid_t kuid;
+	kgid_t kgid;
 
 	if (!options)
 		return 0;
@@ -175,12 +181,14 @@ static int parse_options(struct super_block *sb, char *options)
 		case Opt_uid:
 			if (match_int(args, &option))
 				return -EINVAL;
-			asb->s_uid = option;
+			kuid = make_kuid(current_user_ns(), option);
+			asb->s_uid = from_kuid_munged(&init_user_ns, kuid);
 			break;
 		case Opt_gid:
 			if (match_int(args, &option))
 				return -EINVAL;
-			asb->s_gid = option;
+			kgid = make_kgid(current_user_ns(), option);
+			asb->s_gid = from_kgid_munged(&init_user_ns, kgid);
 			break;
 		case Opt_ownmask:
 			if (match_octal(args, &option))
@@ -370,8 +378,8 @@ static int adfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_fs_info = asb;
 
 	/* set default options */
-	asb->s_uid = 0;
-	asb->s_gid = 0;
+	asb->s_uid = from_kuid_munged(&init_user_ns, GLOBAL_ROOT_UID);
+	asb->s_gid = from_kgid_munged(&init_user_ns, GLOBAL_ROOT_GID);
 	asb->s_owner_mask = ADFS_DEFAULT_OWNER_MASK;
 	asb->s_other_mask = ADFS_DEFAULT_OTHER_MASK;
 	asb->s_ftsuffix = 0;
diff --git a/init/Kconfig b/init/Kconfig
index 589d558..4d8d44d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -909,7 +909,6 @@ config UIDGID_CONVERTED
 	depends on DEVTMPFS = n
 	depends on XENFS = n
 
-	depends on ADFS_FS = n
 	depends on AFFS_FS = n
 	depends on AFS_FS = n
 	depends on AUTOFS4_FS = n
-- 
1.7.1

