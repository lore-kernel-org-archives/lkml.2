Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab0FXSLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 14:11:42 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51373 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902Ab0FXSLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 14:11:37 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 08/15] evm: imbed evm_inode_post_setattr
Date: Thu, 24 Jun 2010 14:10:24 -0400
Message-Id: <1277403031-3080-9-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1277403031-3080-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1277403031-3080-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the inode's metadata may require the 'security.evm' extended
attribute to be re-calculated and updated.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 fs/attr.c           |    5 ++++-
 include/linux/evm.h |    6 ++++++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index b4fa3b0..9293710 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -13,6 +13,7 @@
 #include <linux/fsnotify.h>
 #include <linux/fcntl.h>
 #include <linux/security.h>
+#include <linux/evm.h>
 
 /* Taken over from the old code... */
 
@@ -248,8 +249,10 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 	if (ia_valid & ATTR_SIZE)
 		up_write(&dentry->d_inode->i_alloc_sem);
 
-	if (!error)
+	if (!error) {
 		fsnotify_change(dentry, ia_valid);
+		evm_inode_post_setattr(dentry, ia_valid);
+	}
 
 	return error;
 }
diff --git a/include/linux/evm.h b/include/linux/evm.h
index 93edadd..8626263 100644
--- a/include/linux/evm.h
+++ b/include/linux/evm.h
@@ -15,6 +15,7 @@ extern enum integrity_status evm_verifyxattr(struct dentry *dentry,
 					     char *xattr_name,
 					     char *xattr_value,
 					     size_t xattr_value_len);
+extern void evm_inode_post_setattr(struct dentry *dentry, int ia_valid);
 extern int evm_inode_setxattr(struct dentry *dentry, const char *name,
 			      const void *value, size_t size);
 extern void evm_inode_post_setxattr(struct dentry *dentry,
@@ -33,6 +34,11 @@ static enum integrity_status evm_verifyxattr(struct dentry *dentry,
 	return INTEGRITY_UNKNOWN;
 }
 
+static inline void evm_inode_post_setattr(struct dentry *dentry, int ia_valid)
+{
+	return;
+}
+
 static inline int evm_inode_setxattr(struct dentry *dentry, const char *name,
 				     const void *value, size_t size)
 {
-- 
1.6.6.1

