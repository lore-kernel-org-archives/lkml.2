Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab1F2Twq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 15:52:46 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44823 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab1F2Twh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 15:52:37 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v7 08/16] evm: imbed evm_inode_post_setattr
Date: Wed, 29 Jun 2011 15:50:30 -0400
Message-Id: <1309377038-4550-9-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the inode's metadata may require the 'security.evm' extended
attribute to be re-calculated and updated.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>
---
 fs/attr.c           |    5 ++++-
 include/linux/evm.h |    6 ++++++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index caf2aa5..5ad45d3 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -13,6 +13,7 @@
 #include <linux/fsnotify.h>
 #include <linux/fcntl.h>
 #include <linux/security.h>
+#include <linux/evm.h>
 
 /**
  * inode_change_ok - check if attribute changes to an inode are allowed
@@ -243,8 +244,10 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
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
1.7.3.4

