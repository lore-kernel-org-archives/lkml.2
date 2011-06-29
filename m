Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab1F2Twl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 15:52:41 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59495 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab1F2Twh (ORCPT
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
Subject: [PATCH v7 10/16] evm: call evm_inode_init_security from security_inode_init_security
Date: Wed, 29 Jun 2011 15:50:32 -0400
Message-Id: <1309377038-4550-11-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog v7:
- moved the initialization call to security_inode_init_security,
  renaming evm_inode_post_init_security to evm_inode_init_security
- increase size of xattr array for EVM xattr

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/security.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/security/security.c b/security/security.c
index 21a79b3..181990a 100644
--- a/security/security.c
+++ b/security/security.c
@@ -20,7 +20,7 @@
 #include <linux/ima.h>
 #include <linux/evm.h>
 
-#define MAX_LSM_XATTR	1
+#define MAX_LSM_EVM_XATTR	2
 
 /* Boot-time LSM user choice */
 static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
@@ -346,8 +346,8 @@ int security_inode_init_security(struct inode *inode, struct inode *dir,
 				 const struct qstr *qstr,
 				 const initxattrs initxattrs, void *fs_data)
 {
-	struct xattr new_xattrs[MAX_LSM_XATTR + 1];
-	struct xattr *lsm_xattr;
+	struct xattr new_xattrs[MAX_LSM_EVM_XATTR + 1];
+	struct xattr *lsm_xattr, *evm_xattr, *xattr;
 	int ret;
 
 	if (unlikely(IS_PRIVATE(inode)))
@@ -364,11 +364,17 @@ int security_inode_init_security(struct inode *inode, struct inode *dir,
 						&lsm_xattr->value_len);
 	if (ret)
 		goto out;
+
+	evm_xattr = lsm_xattr + 1;
+	ret = evm_inode_init_security(inode, lsm_xattr, evm_xattr);
+	if (ret)
+		goto out;
 	ret = initxattrs(inode, new_xattrs, fs_data);
 out:
-	kfree(lsm_xattr->name);
-	kfree(lsm_xattr->value);
-
+	for (xattr = new_xattrs; xattr->name != NULL; xattr++) {
+		kfree(xattr->name);
+		kfree(xattr->value);
+	}
 	return (ret == -EOPNOTSUPP) ? 0 : ret;
 }
 EXPORT_SYMBOL(security_inode_init_security);
-- 
1.7.3.4

