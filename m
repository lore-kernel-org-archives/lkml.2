Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab0FXSLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 14:11:54 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37517 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab0FXSLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 14:11:49 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 10/15] fs: add evm_inode_post_init calls
Date: Thu, 24 Jun 2010 14:10:26 -0400
Message-Id: <1277403031-3080-11-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1277403031-3080-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1277403031-3080-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After creating the initial LSM security extended attribute, call
evm_inode_post_init_security() to create the 'security.evm'
extended attribute.

(Support for other fs still needed.)

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 fs/ext2/xattr_security.c |   31 ++++++++++++++++++++++++-------
 fs/ext3/xattr_security.c |   30 +++++++++++++++++++++++-------
 fs/ext4/xattr_security.c |   30 +++++++++++++++++++++++-------
 3 files changed, 70 insertions(+), 21 deletions(-)

diff --git a/fs/ext2/xattr_security.c b/fs/ext2/xattr_security.c
index 3004e15..bb460ed 100644
--- a/fs/ext2/xattr_security.c
+++ b/fs/ext2/xattr_security.c
@@ -9,6 +9,7 @@
 #include <linux/fs.h>
 #include <linux/ext2_fs.h>
 #include <linux/security.h>
+#include <linux/evm.h>
 #include "xattr.h"
 
 static size_t
@@ -50,21 +51,37 @@ int
 ext2_init_security(struct inode *inode, struct inode *dir)
 {
 	int err;
-	size_t len;
-	void *value;
-	char *name;
+	struct xattr lsm_xattr;
+	struct xattr evm_xattr;
 
-	err = security_inode_init_security(inode, dir, &name, &value, &len);
+	err = security_inode_init_security(inode, dir, &lsm_xattr.name,
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
index 03a99bf..6e44368 100644
--- a/fs/ext3/xattr_security.c
+++ b/fs/ext3/xattr_security.c
@@ -10,6 +10,7 @@
 #include <linux/ext3_jbd.h>
 #include <linux/ext3_fs.h>
 #include <linux/security.h>
+#include <linux/evm.h>
 #include "xattr.h"
 
 static size_t
@@ -52,20 +53,35 @@ int
 ext3_init_security(handle_t *handle, struct inode *inode, struct inode *dir)
 {
 	int err;
-	size_t len;
-	void *value;
-	char *name;
+	struct xattr lsm_xattr;
+	struct xattr evm_xattr;
 
-	err = security_inode_init_security(inode, dir, &name, &value, &len);
+	err = security_inode_init_security(inode, dir, &lsm_xattr.name,
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
index 9b21268..8998fda 100644
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
@@ -52,20 +53,35 @@ int
 ext4_init_security(handle_t *handle, struct inode *inode, struct inode *dir)
 {
 	int err;
-	size_t len;
-	void *value;
-	char *name;
+	struct xattr lsm_xattr;
+	struct xattr evm_xattr;
 
-	err = security_inode_init_security(inode, dir, &name, &value, &len);
+	err = security_inode_init_security(inode, dir, &lsm_xattr.name,
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
1.6.6.1

