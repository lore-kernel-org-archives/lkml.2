Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab1LRRd2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 12:33:28 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:51622 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab1LRRd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 12:33:26 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] fs/9p: iattr_valid flags are kernel internal flags map them to 9p values.
Date: Sun, 18 Dec 2011 23:03:13 +0530
Message-Id: <1324229593-19441-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8.247.g10f4e.dirty
x-cbid: 11121817-5564-0000-0000-0000008E09F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Kernel internal values can change, add protocol values for these constant and
use them.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode_dotl.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 0b5745e..a81808a 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -523,6 +523,46 @@ v9fs_vfs_getattr_dotl(struct vfsmount *mnt, struct dentry *dentry,
 	return 0;
 }
 
+/*
+ * Attribute flags.
+ */
+#define P9_ATTR_MODE		(1 << 0)
+#define P9_ATTR_UID		(1 << 1)
+#define P9_ATTR_GID		(1 << 2)
+#define P9_ATTR_SIZE		(1 << 3)
+#define P9_ATTR_ATIME		(1 << 4)
+#define P9_ATTR_MTIME		(1 << 5)
+#define P9_ATTR_CTIME		(1 << 6)
+#define P9_ATTR_ATIME_SET	(1 << 7)
+#define P9_ATTR_MTIME_SET	(1 << 8)
+
+struct dotl_iattr_map {
+	int iattr_valid;
+	int p9_iattr_valid;
+};
+
+static int v9fs_mapped_iattr_valid(int iattr_valid)
+{
+	int i;
+	int p9_iattr_valid = 0;
+	struct dotl_iattr_map dotl_iattr_map[] = {
+		{ ATTR_MODE,		P9_ATTR_MODE },
+		{ ATTR_UID,		P9_ATTR_UID },
+		{ ATTR_GID,		P9_ATTR_GID },
+		{ ATTR_SIZE,		P9_ATTR_SIZE },
+		{ ATTR_ATIME,		P9_ATTR_ATIME },
+		{ ATTR_MTIME,		P9_ATTR_MTIME },
+		{ ATTR_CTIME,		P9_ATTR_CTIME },
+		{ ATTR_ATIME_SET,	P9_ATTR_ATIME_SET },
+		{ ATTR_MTIME_SET,	P9_ATTR_MTIME_SET },
+	};
+	for (i = 0; i < ARRAY_SIZE(dotl_iattr_map); i++) {
+		if (iattr_valid & dotl_iattr_map[i].iattr_valid)
+			p9_iattr_valid |= dotl_iattr_map[i].p9_iattr_valid;
+	}
+	return p9_iattr_valid;
+}
+
 /**
  * v9fs_vfs_setattr_dotl - set file metadata
  * @dentry: file whose metadata to set
@@ -543,7 +583,7 @@ int v9fs_vfs_setattr_dotl(struct dentry *dentry, struct iattr *iattr)
 	if (retval)
 		return retval;
 
-	p9attr.valid = iattr->ia_valid;
+	p9attr.valid = v9fs_mapped_iattr_valid(iattr->ia_valid);
 	p9attr.mode = iattr->ia_mode;
 	p9attr.uid = iattr->ia_uid;
 	p9attr.gid = iattr->ia_gid;
-- 
1.7.8.247.g10f4e.dirty

