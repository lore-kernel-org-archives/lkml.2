Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab1EPOrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:47:00 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:53926 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab1EPOq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:46:57 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v5 08/21] evm: imbed evm_inode_post_setattr
Date: Mon, 16 May 2011 10:45:02 -0400
Message-Id: <1305557115-15652-9-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
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
index 91dbe2a..b717f86 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -13,6 +13,7 @@
 #include <linux/fsnotify.h>
 #include <linux/fcntl.h>
 #include <linux/security.h>
+#include <linux/evm.h>
 
 /**
  * inode_change_ok - check if attribute changes to an inode are allowed
@@ -236,8 +237,10 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
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

