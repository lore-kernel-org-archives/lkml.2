Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab1EPOrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:47:22 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:35936 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab1EPOrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:47:16 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v5 10/21] fs: add evm_inode_post_init calls
Date: Mon, 16 May 2011 10:45:04 -0400
Message-Id: <1305557115-15652-11-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After creating the initial LSM security extended attribute, call
evm_inode_post_init_security() to create the 'security.evm'
extended attribute.

(Support for other fs are defined as separate patches.)

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>
---
 fs/ext2/xattr_security.c |   31 ++++++++++++++++++++++++-------
 fs/ext3/xattr_security.c |   30 +++++++++++++++++++++++-------
 fs/ext4/xattr_security.c |   30 +++++++++++++++++++++++-------
 3 files changed, 70 insertions(+), 21 deletions(-)

diff --git a/fs/ext2/xattr_security.c b/fs/ext2/xattr_security.c
index 5d979b4..e17820c 100644
--- a/fs/ext2/xattr_security.c
+++ b/fs/ext2/xattr_security.c
@@ -9,6 +9,7 @@
 #include <linux/fs.h>
 #include <linux/ext2_fs.h>
 #include <linux/security.h>
+#include <linux/evm.h>
 #include "xattr.h"
 
 static size_t
@@ -51,21 +52,37 @@ ext2_init_security(struct inode *inode, struct inode *dir,
 		   const struct qstr *qstr)
 {
 	int err;
-	size_t len;
-	void *value;
-	char *name;
+	struct xattr lsm_xattr;
+	struct xattr evm_xattr;
 
-	err = security_inode_init_security(inode, dir, qstr, &name, &value, &len);
+	err = security_inode_init_security(inode, dir, qstr, &lsm_xattr.name,
+					   &lsm_xattr.value,
+					   &lsm_xattr.value_len);
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			return 0;
 		return err;
 	}
 	err = ext2_xattr_set(inode, EXT2_XATTR_INDEX_SECURITY,
-			     name, value, len, 0);
-	kfree(name);
-	kfree(value);
+			     lsm_xattr.name, lsm_xattr.value,
+			     lsm_xattr.value_len, 0);
+	if (err < 0)
+		goto out;
+
+	err = evm_inode_post_init_security(inode, &lsm_xattr, &evm_xattr);
+	if (err)
+		goto out;
+	err = ext2_xattr_set(inode, EXT2_XATTR_INDEX_SECURITY,
+			     evm_xattr.name, evm_xattr.value,
+			     evm_xattr.value_len, 0);
+	kfree(evm_xattr.value);
+out:
+	kfree(lsm_xattr.name);
+	kfree(lsm_xattr.value);
+	if (err == -EOPNOTSUPP)
+		return 0;
 	return err;
+
 }
 
 const struct xattr_handler ext2_xattr_security_handler = {
diff --git a/fs/ext3/xattr_security.c b/fs/ext3/xattr_security.c
index b8d9f83..844786b 100644
--- a/fs/ext3/xattr_security.c
+++ b/fs/ext3/xattr_security.c
@@ -10,6 +10,7 @@
 #include <linux/ext3_jbd.h>
 #include <linux/ext3_fs.h>
 #include <linux/security.h>
+#include <linux/evm.h>
 #include "xattr.h"
 
 static size_t
@@ -53,20 +54,35 @@ ext3_init_security(handle_t *handle, struct inode *inode, struct inode *dir,
 		   const struct qstr *qstr)
 {
 	int err;
-	size_t len;
-	void *value;
-	char *name;
+	struct xattr lsm_xattr;
+	struct xattr evm_xattr;
 
-	err = security_inode_init_security(inode, dir, qstr, &name, &value, &len);
+	err = security_inode_init_security(inode, dir, qstr, &lsm_xattr.name,
+					   &lsm_xattr.value,
+					   &lsm_xattr.value_len);
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			return 0;
 		return err;
 	}
 	err = ext3_xattr_set_handle(handle, inode, EXT3_XATTR_INDEX_SECURITY,
-				    name, value, len, 0);
-	kfree(name);
-	kfree(value);
+				    lsm_xattr.name, lsm_xattr.value,
+				    lsm_xattr.value_len, 0);
+	if (err < 0)
+		goto out;
+
+	err = evm_inode_post_init_security(inode, &lsm_xattr, &evm_xattr);
+	if (err)
+		goto out;
+	err = ext3_xattr_set_handle(handle, inode, EXT3_XATTR_INDEX_SECURITY,
+				    evm_xattr.name, evm_xattr.value,
+				    evm_xattr.value_len, 0);
+	kfree(evm_xattr.value);
+out:
+	kfree(lsm_xattr.name);
+	kfree(lsm_xattr.value);
+	if (err == -EOPNOTSUPP)
+		return 0;
 	return err;
 }
 
diff --git a/fs/ext4/xattr_security.c b/fs/ext4/xattr_security.c
index 007c3bf..c5fdb96 100644
--- a/fs/ext4/xattr_security.c
+++ b/fs/ext4/xattr_security.c
@@ -8,6 +8,7 @@
 #include <linux/fs.h>
 #include <linux/security.h>
 #include <linux/slab.h>
+#include <linux/evm.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
 #include "xattr.h"
@@ -53,20 +54,35 @@ ext4_init_security(handle_t *handle, struct inode *inode, struct inode *dir,
 		   const struct qstr *qstr)
 {
 	int err;
-	size_t len;
-	void *value;
-	char *name;
+	struct xattr lsm_xattr;
+	struct xattr evm_xattr;
 
-	err = security_inode_init_security(inode, dir, qstr, &name, &value, &len);
+	err = security_inode_init_security(inode, dir, qstr, &lsm_xattr.name,
+					   &lsm_xattr.value,
+					   &lsm_xattr.value_len);
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			return 0;
 		return err;
 	}
 	err = ext4_xattr_set_handle(handle, inode, EXT4_XATTR_INDEX_SECURITY,
-				    name, value, len, 0);
-	kfree(name);
-	kfree(value);
+				    lsm_xattr.name, lsm_xattr.value,
+				    lsm_xattr.value_len, 0);
+	if (err < 0)
+		goto out;
+
+	err = evm_inode_post_init_security(inode, &lsm_xattr, &evm_xattr);
+	if (err)
+		goto out;
+	err = ext4_xattr_set_handle(handle, inode, EXT4_XATTR_INDEX_SECURITY,
+				    evm_xattr.name, evm_xattr.value,
+				    evm_xattr.value_len, 0);
+	kfree(evm_xattr.value);
+out:
+	kfree(lsm_xattr.name);
+	kfree(lsm_xattr.value);
+	if (err == -EOPNOTSUPP)
+		return 0;
 	return err;
 }
 
-- 
1.7.3.4

