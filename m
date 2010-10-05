Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab0JERCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 13:02:11 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:51796 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab0JERCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 13:02:09 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/3] fs/9p: Update TLCREATE to allow create without open
Date: Tue,  5 Oct 2010 22:31:28 +0530
Message-Id: <1286298090-2422-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need this so that we can support regular file creation
with mknod

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/v9fs.h            |    2 ++
 fs/9p/vfs_inode.c       |   13 +++++++------
 include/net/9p/client.h |    2 +-
 net/9p/client.c         |    6 +++---
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 8bb7792..6209a29 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -126,6 +126,8 @@ void v9fs_session_begin_cancel(struct v9fs_session_info *v9ses);
 #define V9FS_DEFUID	(-2)
 #define V9FS_DEFGID	(-2)
 
+#define P9_LOOKUP_OPEN 0x1
+
 static inline struct v9fs_session_info *v9fs_inode2v9ses(struct inode *inode)
 {
 	return (inode->i_sb->s_fs_info);
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 2f904a8..1ec9075 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -668,8 +668,9 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 	int err = 0;
 	char *name = NULL;
 	gid_t gid;
-	int flags;
+	int flags = 0;
 	mode_t mode;
+	int lookup_flags = 0;
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid = NULL;
 	struct p9_fid *dfid, *ofid;
@@ -679,11 +680,10 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 	struct posix_acl *pacl = NULL, *dacl = NULL;
 
 	v9ses = v9fs_inode2v9ses(dir);
-	if (nd && nd->flags & LOOKUP_OPEN)
+	if (nd && nd->flags & LOOKUP_OPEN) {
 		flags = nd->intent.open.flags - 1;
-	else
-		flags = O_RDWR;
-
+		lookup_flags = P9_LOOKUP_OPEN;
+	}
 	name = (char *) dentry->d_name.name;
 	P9_DPRINTK(P9_DEBUG_VFS, "v9fs_vfs_create_dotl: name:%s flags:0x%x "
 			"mode:0x%x\n", name, flags, omode);
@@ -713,7 +713,8 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 			   "Failed to get acl values in creat %d\n", err);
 		goto error;
 	}
-	err = p9_client_create_dotl(ofid, name, flags, mode, gid, &qid);
+	err = p9_client_create_dotl(ofid, name, flags, mode,
+				    gid, lookup_flags, &qid);
 	if (err < 0) {
 		P9_DPRINTK(P9_DEBUG_VFS,
 				"p9_client_open_dotl failed in creat %d\n",
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index fb358f5..b0b97ec 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -230,7 +230,7 @@ int p9_client_link(struct p9_fid *fid, struct p9_fid *oldfid, char *newname);
 int p9_client_symlink(struct p9_fid *fid, char *name, char *symname, gid_t gid,
 							struct p9_qid *qid);
 int p9_client_create_dotl(struct p9_fid *ofid, char *name, u32 flags, u32 mode,
-		gid_t gid, struct p9_qid *qid);
+			  gid_t gid, int lookup_flags, struct p9_qid *qid);
 int p9_client_clunk(struct p9_fid *fid);
 int p9_client_remove(struct p9_fid *fid);
 int p9_client_read(struct p9_fid *fid, char *data, char __user *udata,
diff --git a/net/9p/client.c b/net/9p/client.c
index 4b90b82..9950275 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1070,7 +1070,7 @@ error:
 EXPORT_SYMBOL(p9_client_open);
 
 int p9_client_create_dotl(struct p9_fid *ofid, char *name, u32 flags, u32 mode,
-		gid_t gid, struct p9_qid *qid)
+			  gid_t gid, int lookup_flags, struct p9_qid *qid)
 {
 	int err = 0;
 	struct p9_client *clnt;
@@ -1085,8 +1085,8 @@ int p9_client_create_dotl(struct p9_fid *ofid, char *name, u32 flags, u32 mode,
 	if (ofid->mode != -1)
 		return -EINVAL;
 
-	req = p9_client_rpc(clnt, P9_TLCREATE, "dsddd", ofid->fid, name, flags,
-			mode, gid);
+	req = p9_client_rpc(clnt, P9_TLCREATE, "dsdddd", ofid->fid, name, flags,
+			    mode, gid, lookup_flags);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto error;
-- 
1.7.0.4

