Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab1LVI4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:56:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:56043 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846Ab1LVIz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:55:56 -0500
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com
Subject: [PATCH v2 2/2] vfs: ATTR_OPEN rename
Date: Thu, 22 Dec 2011 10:55:26 +0200
Message-Id: <391823d5d23853330e02aebd75b225bf9900b8c5.1324543719.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1324543719.git.dmitry.kasatkin@intel.com>
References: <cover.1324543719.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1324543719.git.dmitry.kasatkin@intel.com>
References: <cover.1324543719.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ATTR_OPEN is used to indicate truncate situation.
The correct name would be ATTR_TRUNC.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 fs/attr.c          |    2 +-
 fs/fuse/dir.c      |    4 ++--
 fs/namei.c         |    2 +-
 fs/open.c          |    4 ++--
 include/linux/fs.h |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index e02370d..8e1e27d 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -176,7 +176,7 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 			return -EPERM;
 	}
 
-	if ((ia_valid & ATTR_OPEN) && IS_I_VERSION(inode))
+	if ((ia_valid & ATTR_TRUNC) && IS_I_VERSION(inode))
 		inode_inc_iversion(inode);
 
 	if ((ia_valid & ATTR_MODE)) {
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 9f63e49..006cbc8 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1189,7 +1189,7 @@ static bool update_mtime(unsigned ivalid)
 		return true;
 
 	/* If it's an open(O_TRUNC) or an ftruncate(), don't update */
-	if ((ivalid & ATTR_SIZE) && (ivalid & (ATTR_OPEN | ATTR_FILE)))
+	if ((ivalid & ATTR_SIZE) && (ivalid & (ATTR_TRUNC | ATTR_FILE)))
 		return false;
 
 	/* In all other cases update */
@@ -1298,7 +1298,7 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 	if (err)
 		return err;
 
-	if (attr->ia_valid & ATTR_OPEN) {
+	if (attr->ia_valid & ATTR_TRUNC) {
 		if (fc->atomic_o_trunc)
 			return 0;
 		file = NULL;
diff --git a/fs/namei.c b/fs/namei.c
index 5008f01..40fd610 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2064,7 +2064,7 @@ static int handle_truncate(struct file *filp)
 		error = security_path_truncate(path);
 	if (!error) {
 		error = do_truncate(path->dentry, 0,
-				    ATTR_MTIME|ATTR_CTIME|ATTR_OPEN,
+				    ATTR_MTIME|ATTR_CTIME|ATTR_TRUNC,
 				    filp);
 	}
 	put_write_access(inode);
diff --git a/fs/open.c b/fs/open.c
index 4ee6847..989fad1 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -113,7 +113,7 @@ static long do_sys_truncate(const char __user *pathname, loff_t length)
 	if (!error)
 		error = security_path_truncate(&path);
 	if (!error)
-		error = do_truncate(path.dentry, length, ATTR_OPEN, NULL);
+		error = do_truncate(path.dentry, length, ATTR_TRUNC, NULL);
 
 put_write_and_out:
 	put_write_access(inode);
@@ -169,7 +169,7 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 		error = security_path_truncate(&file->f_path);
 	if (!error)
 		error = do_truncate(dentry, length,
-				    ATTR_MTIME|ATTR_CTIME|ATTR_OPEN, file);
+				    ATTR_MTIME|ATTR_CTIME|ATTR_TRUNC, file);
 out_putf:
 	fput(file);
 out:
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e0bc4ff..7548356 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -447,7 +447,7 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define ATTR_KILL_SGID	(1 << 12)
 #define ATTR_FILE	(1 << 13)
 #define ATTR_KILL_PRIV	(1 << 14)
-#define ATTR_OPEN	(1 << 15) /* Truncating from open(O_TRUNC) */
+#define ATTR_TRUNC	(1 << 15) /* Truncating from open(O_TRUNC) */
 #define ATTR_TIMES_SET	(1 << 16)
 
 /*
-- 
1.7.4.1

