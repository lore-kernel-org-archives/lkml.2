Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab2GKTCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:02:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab2GKTCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:02:18 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: aris@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] userns: Convert 9p to use kuid and kgid where appropriate
Date: Wed, 11 Jul 2012 15:01:18 -0400
Message-Id: <1342033282-24933-2-git-send-email-arozansk@redhat.com>
In-Reply-To: <1342033282-24933-1-git-send-email-arozansk@redhat.com>
References: <1342033282-24933-1-git-send-email-arozansk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aristeu Rozanski <aris@redhat.com>

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
---
 fs/9p/fid.c            |    3 ++-
 fs/9p/v9fs.c           |   16 +++++++++++++---
 fs/9p/vfs_inode.c      |   19 ++++++++++++-------
 fs/9p/vfs_inode_dotl.c |   16 ++++++++--------
 init/Kconfig           |    1 -
 5 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index da8eefb..6fb7212 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -243,7 +243,8 @@ struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
 	case V9FS_ACCESS_SINGLE:
 	case V9FS_ACCESS_USER:
 	case V9FS_ACCESS_CLIENT:
-		uid = current_fsuid();
+		uid = from_kuid_munged(current_user_ns(),
+				       current_fsuid());
 		any = 0;
 		break;
 
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index b85efa7..d3ff063 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -110,6 +110,8 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 {
 	char *options, *tmp_options;
 	substring_t args[MAX_OPT_ARGS];
+	kuid_t kuid;
+	uid_t uid;
 	char *p;
 	int option = 0;
 	char *s, *e;
@@ -161,7 +163,14 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 				ret = r;
 				continue;
 			}
-			v9ses->dfltuid = option;
+			kuid = make_kuid(current_user_ns(), option);
+			if (!uid_valid(kuid)) {
+				p9_debug(P9_DEBUG_ERROR,
+					"invalid uid: %i\n", option);
+				continue;
+			}
+			uid = from_kuid_munged(&init_user_ns, kuid);
+			v9ses->dfltuid = (unsigned long)uid;
 			break;
 		case Opt_dfltgid:
 			r = match_int(&args[0], &option);
@@ -239,14 +248,15 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 				v9ses->flags |= V9FS_ACCESS_CLIENT;
 			} else {
 				v9ses->flags |= V9FS_ACCESS_SINGLE;
-				v9ses->uid = simple_strtoul(s, &e, 10);
-				if (*e != '\0') {
+				kuid = make_kuid(current_user_ns(), simple_strtoul(s, &e, 10));
+				if (*e != '\0' || !uid_valid(kuid)) {
 					ret = -EINVAL;
 					pr_info("Unknown access argument %s\n",
 						s);
 					kfree(s);
 					goto free_and_return;
 				}
+				v9ses->uid = from_kuid_munged(&init_user_ns, kuid);
 			}
 
 			kfree(s);
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 014c8dd..5b8758a 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1111,10 +1111,10 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 
 	if (v9fs_proto_dotu(v9ses)) {
 		if (iattr->ia_valid & ATTR_UID)
-			wstat.n_uid = iattr->ia_uid;
+			wstat.n_uid = from_kuid_munged(&init_user_ns, iattr->ia_uid);
 
 		if (iattr->ia_valid & ATTR_GID)
-			wstat.n_gid = iattr->ia_gid;
+			wstat.n_gid = from_kgid_munged(&init_user_ns, iattr->ia_gid);
 	}
 
 	/* Write all dirty data */
@@ -1154,6 +1154,8 @@ v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
 	unsigned int i_nlink;
 	struct v9fs_session_info *v9ses = sb->s_fs_info;
 	struct v9fs_inode *v9inode = V9FS_I(inode);
+	uid_t uid;
+	gid_t gid;
 
 	set_nlink(inode, 1);
 
@@ -1161,13 +1163,16 @@ v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
 	inode->i_mtime.tv_sec = stat->mtime;
 	inode->i_ctime.tv_sec = stat->mtime;
 
-	inode->i_uid = v9ses->dfltuid;
-	inode->i_gid = v9ses->dfltgid;
-
 	if (v9fs_proto_dotu(v9ses)) {
-		inode->i_uid = stat->n_uid;
-		inode->i_gid = stat->n_gid;
+		uid = (uid_t)stat->n_uid;
+		gid = (gid_t)stat->n_gid;
+	} else {
+		uid = (uid_t)v9ses->dfltuid;
+		gid = (gid_t)v9ses->dfltgid;
 	}
+	i_uid_write(inode, uid);
+	i_gid_write(inode, gid);
+
 	if ((S_ISREG(inode->i_mode)) || (S_ISDIR(inode->i_mode))) {
 		if (v9fs_proto_dotu(v9ses) && (stat->extension[0] != '\0')) {
 			/*
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index a1e6c99..b2e8a45 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -63,9 +63,9 @@ static gid_t v9fs_get_fsgid_for_create(struct inode *dir_inode)
 
 	if (dir_inode->i_mode & S_ISGID) {
 		/* set_gid bit is set.*/
-		return dir_inode->i_gid;
+		return from_kgid_munged(current_user_ns(), dir_inode->i_gid);
 	}
-	return current_fsgid();
+	return from_kgid_munged(current_user_ns(), current_fsgid());
 }
 
 /**
@@ -584,8 +584,8 @@ int v9fs_vfs_setattr_dotl(struct dentry *dentry, struct iattr *iattr)
 
 	p9attr.valid = v9fs_mapped_iattr_valid(iattr->ia_valid);
 	p9attr.mode = iattr->ia_mode;
-	p9attr.uid = iattr->ia_uid;
-	p9attr.gid = iattr->ia_gid;
+	p9attr.uid = from_kuid_munged(&init_user_ns, iattr->ia_uid);
+	p9attr.gid = from_kgid_munged(&init_user_ns, iattr->ia_gid);
 	p9attr.size = iattr->ia_size;
 	p9attr.atime_sec = iattr->ia_atime.tv_sec;
 	p9attr.atime_nsec = iattr->ia_atime.tv_nsec;
@@ -643,8 +643,8 @@ v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct inode *inode)
 		inode->i_mtime.tv_nsec = stat->st_mtime_nsec;
 		inode->i_ctime.tv_sec = stat->st_ctime_sec;
 		inode->i_ctime.tv_nsec = stat->st_ctime_nsec;
-		inode->i_uid = stat->st_uid;
-		inode->i_gid = stat->st_gid;
+		i_uid_write(inode, stat->st_uid);
+		i_gid_write(inode, stat->st_gid);
 		set_nlink(inode, stat->st_nlink);
 
 		mode = stat->st_mode & S_IALLUGO;
@@ -667,9 +667,9 @@ v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct inode *inode)
 			inode->i_ctime.tv_nsec = stat->st_ctime_nsec;
 		}
 		if (stat->st_result_mask & P9_STATS_UID)
-			inode->i_uid = stat->st_uid;
+			i_uid_write(inode, stat->st_uid);
 		if (stat->st_result_mask & P9_STATS_GID)
-			inode->i_gid = stat->st_gid;
+			i_gid_write(inode, stat->st_gid);
 		if (stat->st_result_mask & P9_STATS_NLINK)
 			set_nlink(inode, stat->st_nlink);
 		if (stat->st_result_mask & P9_STATS_MODE) {
diff --git a/init/Kconfig b/init/Kconfig
index b5dff4d..589d558 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -909,7 +909,6 @@ config UIDGID_CONVERTED
 	depends on DEVTMPFS = n
 	depends on XENFS = n
 
-	depends on 9P_FS = n
 	depends on ADFS_FS = n
 	depends on AFFS_FS = n
 	depends on AFS_FS = n
-- 
1.7.1

