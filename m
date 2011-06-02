Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161270Ab1FBMZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 08:25:47 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50842 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161106Ab1FBMZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 08:25:43 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v6 16/20] evm: additional parameter to pass integrity cache entry 'iint'
Date: Thu,  2 Jun 2011 08:23:39 -0400
Message-Id: <1307017423-15093-17-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1307017423-15093-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1307017423-15093-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>

Additional iint parameter allows to skip lookup in the cache.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 include/linux/evm.h               |    8 ++++++--
 security/integrity/evm/evm_main.c |   18 ++++++++----------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/evm.h b/include/linux/evm.h
index c3bc089..8db7b74 100644
--- a/include/linux/evm.h
+++ b/include/linux/evm.h
@@ -11,11 +11,14 @@
 #include <linux/integrity.h>
 #include <linux/xattr.h>
 
+struct integrity_iint_cache;
+
 #ifdef CONFIG_EVM
 extern enum integrity_status evm_verifyxattr(struct dentry *dentry,
 					     const char *xattr_name,
 					     void *xattr_value,
-					     size_t xattr_value_len);
+					     size_t xattr_value_len,
+					     struct integrity_iint_cache *iint);
 extern void evm_inode_post_setattr(struct dentry *dentry, int ia_valid);
 extern int evm_inode_setxattr(struct dentry *dentry, const char *name,
 			      const void *value, size_t size);
@@ -34,7 +37,8 @@ extern int evm_inode_post_init_security(struct inode *inode,
 static inline enum integrity_status evm_verifyxattr(struct dentry *dentry,
 						    const char *xattr_name,
 						    void *xattr_value,
-						    size_t xattr_value_len)
+						    size_t xattr_value_len,
+					struct integrity_iint_cache *iint)
 {
 	return INTEGRITY_UNKNOWN;
 }
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 0f3e8a6..14fbd38 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -127,21 +127,19 @@ static int evm_protected_xattr(const char *req_xattr_name)
  */
 enum integrity_status evm_verifyxattr(struct dentry *dentry,
 				      const char *xattr_name,
-				      void *xattr_value, size_t xattr_value_len)
+				      void *xattr_value, size_t xattr_value_len,
+				      struct integrity_iint_cache *iint)
 {
-	struct inode *inode = dentry->d_inode;
-	struct integrity_iint_cache *iint;
-	enum integrity_status status;
-
 	if (!evm_initialized || !evm_protected_xattr(xattr_name))
 		return INTEGRITY_UNKNOWN;
 
-	iint = integrity_iint_find(inode);
-	if (!iint)
-		return INTEGRITY_UNKNOWN;
-	status = evm_verify_hmac(dentry, xattr_name, xattr_value,
+	if (!iint) {
+		iint = integrity_iint_find(dentry->d_inode);
+		if (!iint)
+			return INTEGRITY_UNKNOWN;
+	}
+	return evm_verify_hmac(dentry, xattr_name, xattr_value,
 				 xattr_value_len, iint);
-	return status;
 }
 EXPORT_SYMBOL_GPL(evm_verifyxattr);
 
-- 
1.7.3.4

