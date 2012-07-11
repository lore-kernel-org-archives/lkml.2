Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab2GKTCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:02:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758061Ab2GKTCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:02:18 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: aris@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] userns: Convert AFS to use kuid and kgid where appropriate
Date: Wed, 11 Jul 2012 15:01:21 -0400
Message-Id: <1342033282-24933-5-git-send-email-arozansk@redhat.com>
In-Reply-To: <1342033282-24933-1-git-send-email-arozansk@redhat.com>
References: <1342033282-24933-1-git-send-email-arozansk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aristeu Rozanski <aris@redhat.com>

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
---
 fs/afs/fsclient.c |    8 ++++----
 fs/afs/inode.c    |    8 ++++----
 init/Kconfig      |    1 -
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index b960ff0..daac5b3 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -87,8 +87,8 @@ static void xdr_decode_AFSFetchStatus(const __be32 **_bp,
 		if (changed && !test_bit(AFS_VNODE_UNSET, &vnode->flags)) {
 			_debug("vnode changed");
 			i_size_write(&vnode->vfs_inode, size);
-			vnode->vfs_inode.i_uid = status->owner;
-			vnode->vfs_inode.i_gid = status->group;
+			i_uid_write(&vnode->vfs_inode, status->owner);
+			i_gid_write(&vnode->vfs_inode, status->group);
 			vnode->vfs_inode.i_generation = vnode->fid.unique;
 			set_nlink(&vnode->vfs_inode, status->nlink);
 
@@ -181,12 +181,12 @@ static void xdr_encode_AFS_StoreStatus(__be32 **_bp, struct iattr *attr)
 
 	if (attr->ia_valid & ATTR_UID) {
 		mask |= AFS_SET_OWNER;
-		owner = attr->ia_uid;
+		owner = from_kuid_munged(current_user_ns(), attr->ia_uid);
 	}
 
 	if (attr->ia_valid & ATTR_GID) {
 		mask |= AFS_SET_GROUP;
-		group = attr->ia_gid;
+		group = from_kgid_munged(current_user_ns(), attr->ia_gid);
 	}
 
 	if (attr->ia_valid & ATTR_MODE) {
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index d890ae3..1e6f1c8 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -68,8 +68,8 @@ static int afs_inode_map_status(struct afs_vnode *vnode, struct key *key)
 #endif
 
 	set_nlink(inode, vnode->status.nlink);
-	inode->i_uid		= vnode->status.owner;
-	inode->i_gid		= 0;
+	i_uid_write(inode, vnode->status.owner);
+	inode->i_gid = GLOBAL_ROOT_GID;
 	inode->i_size		= vnode->status.size;
 	inode->i_ctime.tv_sec	= vnode->status.mtime_server;
 	inode->i_ctime.tv_nsec	= 0;
@@ -175,8 +175,8 @@ struct inode *afs_iget_autocell(struct inode *dir, const char *dev_name,
 	inode->i_mode		= S_IFDIR | S_IRUGO | S_IXUGO;
 	inode->i_op		= &afs_autocell_inode_operations;
 	set_nlink(inode, 2);
-	inode->i_uid		= 0;
-	inode->i_gid		= 0;
+	inode->i_uid = GLOBAL_ROOT_UID;
+	inode->i_gid = GLOBAL_ROOT_GID;
 	inode->i_ctime.tv_sec	= get_seconds();
 	inode->i_ctime.tv_nsec	= 0;
 	inode->i_atime		= inode->i_mtime = inode->i_ctime;
diff --git a/init/Kconfig b/init/Kconfig
index 52a3736..2ab57ca 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -909,7 +909,6 @@ config UIDGID_CONVERTED
 	depends on DEVTMPFS = n
 	depends on XENFS = n
 
-	depends on AFS_FS = n
 	depends on AUTOFS4_FS = n
 	depends on BEFS_FS = n
 	depends on BFS_FS = n
-- 
1.7.1

