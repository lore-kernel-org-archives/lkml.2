Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab1EPOs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:48:29 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42617 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab1EPOsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:48:25 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Dave Kleikamp <shaggy@kernel.org>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v5 15/21] evm: add evm_inode_post_init call in jfs
Date: Mon, 16 May 2011 10:45:09 -0400
Message-Id: <1305557115-15652-16-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After creating the initial LSM security extended attribute, call
evm_inode_post_init_security() to create the 'security.evm'
extended attribute.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 fs/jfs/xattr.c |   45 +++++++++++++++++++++++++++++++--------------
 1 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
index 24838f1..68b4ec6 100644
--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/quotaops.h>
 #include <linux/security.h>
+#include <linux/evm.h>
 #include "jfs_incore.h"
 #include "jfs_superblock.h"
 #include "jfs_dmap.h"
@@ -1095,33 +1096,49 @@ int jfs_init_security(tid_t tid, struct inode *inode, struct inode *dir,
 		      const struct qstr *qstr)
 {
 	int rc;
-	size_t len;
-	void *value;
-	char *suffix;
+	struct xattr lsm_xattr;
+	struct xattr evm_xattr;
 	char *name;
 
-	rc = security_inode_init_security(inode, dir, qstr, &suffix, &value,
-					  &len);
+	rc = security_inode_init_security(inode, dir, qstr, &lsm_xattr.name,
+					  &lsm_xattr.value,
+					  &lsm_xattr.value_len);
 	if (rc) {
 		if (rc == -EOPNOTSUPP)
 			return 0;
 		return rc;
 	}
-	name = kmalloc(XATTR_SECURITY_PREFIX_LEN + 1 + strlen(suffix),
+	name = kmalloc(XATTR_SECURITY_PREFIX_LEN + 1 + strlen(lsm_xattr.name),
 		       GFP_NOFS);
 	if (!name) {
 		rc = -ENOMEM;
-		goto kmalloc_failed;
-	}
-	strcpy(name, XATTR_SECURITY_PREFIX);
-	strcpy(name + XATTR_SECURITY_PREFIX_LEN, suffix);
+	} else {
+		strcpy(name, XATTR_SECURITY_PREFIX);
+		strcpy(name + XATTR_SECURITY_PREFIX_LEN, lsm_xattr.name);
 
-	rc = __jfs_setxattr(tid, inode, name, value, len, 0);
+		rc = __jfs_setxattr(tid, inode, name, lsm_xattr.value,
+				    lsm_xattr.value_len, 0);
+		kfree(name);
+	}
+	if (rc)
+		goto kmalloc_failed;
 
-	kfree(name);
+	rc = evm_inode_post_init_security(inode, &lsm_xattr, &evm_xattr);
+	if (rc)
+		goto kmalloc_failed;
+	name = kasprintf(GFP_NOFS, "%s%s", XATTR_SECURITY_PREFIX,
+			 evm_xattr.name);
+	if (!name) {
+		rc = -ENOMEM;
+	} else {
+		rc = __jfs_setxattr(tid, inode, name, evm_xattr.value,
+				    evm_xattr.value_len, 0);
+		kfree(name);
+	}
+	kfree(evm_xattr.value);
 kmalloc_failed:
-	kfree(suffix);
-	kfree(value);
+	kfree(lsm_xattr.name);
+	kfree(lsm_xattr.value);
 
 	return rc;
 }
-- 
1.7.3.4

