Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623Ab1FBM1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 08:27:32 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59025 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161182Ab1FBMZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 08:25:40 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>,
        Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v6 14/20] evm: add evm_inode_post_init call in jfs
Date: Thu,  2 Jun 2011 08:23:37 -0400
Message-Id: <1307017423-15093-15-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1307017423-15093-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1307017423-15093-1-git-send-email-zohar@linux.vnet.ibm.com>
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

