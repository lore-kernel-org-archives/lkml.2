Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855Ab0GVUp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 16:45:29 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36600 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759784Ab0GVUpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 16:45:22 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v2 07/14] evm: imbed evm_inode_post_setattr
Date: Thu, 22 Jul 2010 16:44:08 -0400
Message-Id: <1279831456-2765-8-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279831456-2765-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1279831456-2765-1-git-send-email-zohar@linux.vnet.ibm.com>
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
index a730782..33a9247 100644
--- a/include/linux/evm.h
+++ b/include/linux/evm.h
@@ -15,6 +15,7 @@ extern enum integrity_status evm_verifyxattr(struct dentry *dentry,
 					     const char *xattr_name,
 					     void *xattr_value,
 					     size_t xattr_value_len);
+extern void evm_inode_post_setattr(struct dentry *dentry, int ia_valid);
 extern int evm_inode_setxattr(struct dentry *dentry, const char *name,
 			      const void *value, size_t size);
 extern void evm_inode_post_setxattr(struct dentry *dentry,
@@ -35,6 +36,11 @@ static inline enum integrity_status evm_verifyxattr(struct dentry *dentry,
 }
 #endif
 
+static inline void evm_inode_post_setattr(struct dentry *dentry, int ia_valid)
+{
+	return;
+}
+
 static inline int evm_inode_setxattr(struct dentry *dentry, const char *name,
 				     const void *value, size_t size)
 {
-- 
1.7.1.1

