Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab1HCRAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 13:00:00 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:41441 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab1HCQ7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 12:59:52 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] fs/9p: Add OS dependent open flags in 9p protocol
Date: Wed,  3 Aug 2011 22:28:43 +0530
Message-Id: <1312390723-4561-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>

Some of the flags are OS/arch dependent we add a 9p
protocol value which maps to asm-generic/fcntl.h values in Linux

Signed-off-by: Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/v9fs_vfs.h       |    2 +
 fs/9p/vfs_file.c       |    2 +-
 fs/9p/vfs_inode.c      |   16 ++++++++++++++-
 fs/9p/vfs_inode_dotl.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/net/9p/9p.h    |   23 ++++++++++++++++++++++
 5 files changed, 89 insertions(+), 3 deletions(-)

diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index bd86d22..f9a28ea 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -82,4 +82,6 @@ static inline void v9fs_invalidate_inode_attr(struct inode *inode)
 	v9inode->cache_validity |= V9FS_INO_INVALID_ATTR;
 	return;
 }
+
+int v9fs_open_to_dotl_flags(int flags);
 #endif
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index ffed558..56907e4 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -65,7 +65,7 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 	v9inode = V9FS_I(inode);
 	v9ses = v9fs_inode2v9ses(inode);
 	if (v9fs_proto_dotl(v9ses))
-		omode = file->f_flags;
+		omode = v9fs_open_to_dotl_flags(file->f_flags);
 	else
 		omode = v9fs_uflags2omode(file->f_flags,
 					v9fs_proto_dotu(v9ses));
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index dc645a3..7ced952 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -553,6 +553,19 @@ v9fs_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,
 }
 
 /**
+ * v9fs_at_to_dotl_flags- convert Linux specific AT flags to
+ * plan 9 AT flag.
+ * @flags: flags to convert
+ */
+static int v9fs_at_to_dotl_flags(int flags)
+{
+	int rflags = 0;
+	if (flags & AT_REMOVEDIR)
+		rflags |= P9_DOTL_AT_REMOVEDIR;
+	return rflags;
+}
+
+/**
  * v9fs_remove - helper function to remove files and directories
  * @dir: directory inode that is being deleted
  * @dentry:  dentry that is being deleted
@@ -579,7 +592,8 @@ static int v9fs_remove(struct inode *dir, struct dentry *dentry, int flags)
 		return retval;
 	}
 	if (v9fs_proto_dotl(v9ses))
-		retval = p9_client_unlinkat(dfid, dentry->d_name.name, flags);
+		retval = p9_client_unlinkat(dfid, dentry->d_name.name,
+					    v9fs_at_to_dotl_flags(flags));
 	if (retval == -EOPNOTSUPP) {
 		/* Try the one based on path */
 		v9fid = v9fs_fid_clone(dentry);
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 818bf6f..2d719ca 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -192,6 +192,52 @@ v9fs_inode_from_fid_dotl(struct v9fs_session_info *v9ses, struct p9_fid *fid,
 }
 
 /**
+ * v9fs_open_to_dotl_flags- convert Linux specific open flags to
+ * plan 9 open flag.
+ * @flags: flags to convert
+ */
+int v9fs_open_to_dotl_flags(int flags)
+{
+	int rflags = 0;
+
+	if (flags & O_WRONLY)
+		rflags |= P9_DOTL_WRONLY;
+	if (flags & O_RDWR)
+		rflags |= P9_DOTL_RDWR;
+	if (flags & O_CREAT)
+		rflags |= P9_DOTL_CREAT;
+	if (flags & O_EXCL)
+		rflags |= P9_DOTL_EXCL;
+	if (flags & O_NOCTTY)
+		rflags |= P9_DOTL_NOCTTY;
+	if (flags & O_TRUNC)
+		rflags |= P9_DOTL_TRUNC;
+	if (flags & O_APPEND)
+		rflags |= P9_DOTL_APPEND;
+	if (flags & O_NONBLOCK)
+		rflags |= P9_DOTL_NONBLOCK;
+	if (flags & O_DSYNC)
+		rflags |= P9_DOTL_DSYNC;
+	if (flags & FASYNC)
+		rflags |= P9_DOTL_FASYNC;
+	if (flags & O_DIRECT)
+		rflags |= P9_DOTL_DIRECT;
+	if (flags & O_LARGEFILE)
+		rflags |= P9_DOTL_LARGEFILE;
+	if (flags & O_DIRECTORY)
+		rflags |= P9_DOTL_DIRECTORY;
+	if (flags & O_NOFOLLOW)
+		rflags |= P9_DOTL_NOFOLLOW;
+	if (flags & O_NOATIME)
+		rflags |= P9_DOTL_NOATIME;
+	if (flags & O_CLOEXEC)
+		rflags |= P9_DOTL_CLOEXEC;
+	if (flags & O_SYNC)
+		rflags |= P9_DOTL_SYNC;
+	return rflags;
+}
+
+/**
  * v9fs_vfs_create_dotl - VFS hook to create files for 9P2000.L protocol.
  * @dir: directory inode that is being created
  * @dentry:  dentry that is being deleted
@@ -259,7 +305,8 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 			   "Failed to get acl values in creat %d\n", err);
 		goto error;
 	}
-	err = p9_client_create_dotl(ofid, name, flags, mode, gid, &qid);
+	err = p9_client_create_dotl(ofid, name, v9fs_open_to_dotl_flags(flags),
+				    mode, gid, &qid);
 	if (err < 0) {
 		P9_DPRINTK(P9_DEBUG_VFS,
 				"p9_client_open_dotl failed in creat %d\n",
diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 700d41e..fbfe88e 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -288,6 +288,29 @@ enum p9_perm_t {
 	P9_DMSETVTX = 0x00010000,
 };
 
+/* 9p2000.L open flags */
+#define P9_DOTL_RDONLY        00000000
+#define P9_DOTL_WRONLY        00000001
+#define P9_DOTL_RDWR          00000002
+#define P9_DOTL_CREAT         00000100
+#define P9_DOTL_EXCL          00000200
+#define P9_DOTL_NOCTTY        00000400
+#define P9_DOTL_TRUNC         00001000
+#define P9_DOTL_APPEND        00002000
+#define P9_DOTL_NONBLOCK      00004000
+#define P9_DOTL_DSYNC         00010000
+#define P9_DOTL_FASYNC        00020000
+#define P9_DOTL_DIRECT        00040000
+#define P9_DOTL_LARGEFILE     00100000
+#define P9_DOTL_DIRECTORY     00200000
+#define P9_DOTL_NOFOLLOW      00400000
+#define P9_DOTL_NOATIME       01000000
+#define P9_DOTL_CLOEXEC       02000000
+#define P9_DOTL_SYNC          04000000
+
+/* 9p2000.L at flags */
+#define P9_DOTL_AT_REMOVEDIR		0x200
+
 /**
  * enum p9_qid_t - QID types
  * @P9_QTDIR: directory
-- 
1.7.4.1

