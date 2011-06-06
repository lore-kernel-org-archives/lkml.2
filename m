Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab1FFSB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:01:58 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:60434 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab1FFSB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:01:56 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/3] 9p: add 9P2000.L renameat operation
Date: Mon,  6 Jun 2011 23:31:46 +0530
Message-Id: <1307383308-5773-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

renameat - change name of file or directory

size[4] Trenameat tag[2] olddirfid[4] oldname[s] newdirfid[4] newname[s]
size[4] Rrenameat tag[2]

older Trename have the below request format

size[4] Trename tag[2] fid[4] newdirfid[4] name[s]

The rename message is used to change the name of a file, possibly moving it
to a new directory. The rename opreation is actually a directory opertation
and should ideally have olddirfid, if not we cannot represent the fid on server
with anything other than name. We will have to derive the old directory name
from fid in the Trename request.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c       |    9 ++++++---
 include/net/9p/9p.h     |    2 ++
 include/net/9p/client.h |    5 ++++-
 net/9p/client.c         |   33 ++++++++++++++++++++++++++++++++-
 4 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 7f6c677..651f577 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -862,9 +862,12 @@ v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	down_write(&v9ses->rename_sem);
 	if (v9fs_proto_dotl(v9ses)) {
-		retval = p9_client_rename(oldfid, newdirfid,
-					(char *) new_dentry->d_name.name);
-		if (retval != -ENOSYS)
+		retval = p9_client_renameat(olddirfid, old_dentry->d_name.name,
+					    newdirfid, new_dentry->d_name.name);
+		if (retval == -EOPNOTSUPP)
+			retval = p9_client_rename(oldfid, newdirfid,
+						  new_dentry->d_name.name);
+		if (retval != -EOPNOTSUPP)
 			goto clunk_newdir;
 	}
 	if (old_dentry->d_parent != new_dentry->d_parent) {
diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 008711e..094c3dd 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -175,6 +175,8 @@ enum p9_msg_t {
 	P9_RLINK,
 	P9_TMKDIR = 72,
 	P9_RMKDIR,
+	P9_TRENAMEAT = 74,
+	P9_RRENAMEAT,
 	P9_TVERSION = 100,
 	P9_RVERSION,
 	P9_TAUTH = 102,
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index d26d5e9..5353cbc 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -211,7 +211,10 @@ struct p9_dirent {
 };
 
 int p9_client_statfs(struct p9_fid *fid, struct p9_rstatfs *sb);
-int p9_client_rename(struct p9_fid *fid, struct p9_fid *newdirfid, char *name);
+int p9_client_rename(struct p9_fid *fid, struct p9_fid *newdirfid,
+		     const char *name);
+int p9_client_renameat(struct p9_fid *olddirfid, const char *old_name,
+		       struct p9_fid *newdirfid, const char *new_name);
 struct p9_client *p9_client_create(const char *dev_name, char *options);
 void p9_client_destroy(struct p9_client *clnt);
 void p9_client_disconnect(struct p9_client *clnt);
diff --git a/net/9p/client.c b/net/9p/client.c
index 9e3b0e6..677ae8d 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1643,7 +1643,8 @@ error:
 }
 EXPORT_SYMBOL(p9_client_statfs);
 
-int p9_client_rename(struct p9_fid *fid, struct p9_fid *newdirfid, char *name)
+int p9_client_rename(struct p9_fid *fid,
+		     struct p9_fid *newdirfid, const char *name)
 {
 	int err;
 	struct p9_req_t *req;
@@ -1670,6 +1671,36 @@ error:
 }
 EXPORT_SYMBOL(p9_client_rename);
 
+int p9_client_renameat(struct p9_fid *olddirfid, const char *old_name,
+		       struct p9_fid *newdirfid, const char *new_name)
+{
+	int err;
+	struct p9_req_t *req;
+	struct p9_client *clnt;
+
+	err = 0;
+	clnt = olddirfid->clnt;
+
+	P9_DPRINTK(P9_DEBUG_9P, ">>> TRENAMEAT olddirfid %d old name %s"
+		   " newdirfid %d new name %s\n", olddirfid->fid, old_name,
+		   newdirfid->fid, new_name);
+
+	req = p9_client_rpc(clnt, P9_TRENAMEAT, "dsds", olddirfid->fid,
+			    old_name, newdirfid->fid, new_name);
+	if (IS_ERR(req)) {
+		err = PTR_ERR(req);
+		goto error;
+	}
+
+	P9_DPRINTK(P9_DEBUG_9P, "<<< RRENAMEAT newdirfid %d new name %s\n",
+		   newdirfid->fid, new_name);
+
+	p9_free_req(clnt, req);
+error:
+	return err;
+}
+EXPORT_SYMBOL(p9_client_renameat);
+
 /*
  * An xattrwalk without @attr_name gives the fid for the lisxattr namespace
  */
-- 
1.7.4.1

