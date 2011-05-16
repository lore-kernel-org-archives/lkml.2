Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab1EPOrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:47:39 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50006 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab1EPOrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:47:35 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Chris Mason <chris.mason@oracle.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v5 12/21] evm: add evm_inode_post_init call in btrfs
Date: Mon, 16 May 2011 10:45:06 -0400
Message-Id: <1305557115-15652-13-git-send-email-zohar@linux.vnet.ibm.com>
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
 fs/btrfs/xattr.c |   39 +++++++++++++++++++++++++++++----------
 1 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index cfd6605..df07619 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -22,6 +22,7 @@
 #include <linux/rwsem.h>
 #include <linux/xattr.h>
 #include <linux/security.h>
+#include <linux/evm.h>
 #include "ctree.h"
 #include "btrfs_inode.h"
 #include "transaction.h"
@@ -367,31 +368,49 @@ int btrfs_xattr_security_init(struct btrfs_trans_handle *trans,
 			      const struct qstr *qstr)
 {
 	int err;
-	size_t len;
-	void *value;
-	char *suffix;
+	struct xattr lsm_xattr;
+	struct xattr evm_xattr;
 	char *name;
 
-	err = security_inode_init_security(inode, dir, qstr, &suffix, &value,
-					   &len);
+	err = security_inode_init_security(inode, dir, qstr, &lsm_xattr.name,
+					   &lsm_xattr.value,
+					   &lsm_xattr.value_len);
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			return 0;
 		return err;
 	}
 
-	name = kmalloc(XATTR_SECURITY_PREFIX_LEN + strlen(suffix) + 1,
+	name = kmalloc(XATTR_SECURITY_PREFIX_LEN + strlen(lsm_xattr.name) + 1,
 		       GFP_NOFS);
 	if (!name) {
 		err = -ENOMEM;
 	} else {
 		strcpy(name, XATTR_SECURITY_PREFIX);
-		strcpy(name + XATTR_SECURITY_PREFIX_LEN, suffix);
-		err = __btrfs_setxattr(trans, inode, name, value, len, 0);
+		strcpy(name + XATTR_SECURITY_PREFIX_LEN, lsm_xattr.name);
+		err = __btrfs_setxattr(trans, inode, name, lsm_xattr.value,
+				       lsm_xattr.value_len, 0);
 		kfree(name);
 	}
+	if (err)
+		goto out;
+
+	err = evm_inode_post_init_security(inode, &lsm_xattr, &evm_xattr);
+	if (err)
+		goto out;
 
-	kfree(suffix);
-	kfree(value);
+	name = kasprintf(GFP_NOFS, "%s%s", XATTR_SECURITY_PREFIX,
+			 evm_xattr.name);
+	if (!name)
+		err = -ENOMEM;
+	else {
+		err = __btrfs_setxattr(trans, inode, name, evm_xattr.value,
+				       evm_xattr.value_len, 0);
+		kfree(name);
+	}
+	kfree(evm_xattr.value);
+out:
+	kfree(lsm_xattr.name);
+	kfree(lsm_xattr.value);
 	return err;
 }
-- 
1.7.3.4

