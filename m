Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab1EPOrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:47:48 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46938 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab1EPOrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:47:45 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        David Woodhouse <dwmw2@infradead.org>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v5 14/21] evm: add evm_inode_post_init call in jffs2
Date: Mon, 16 May 2011 10:45:08 -0400
Message-Id: <1305557115-15652-15-git-send-email-zohar@linux.vnet.ibm.com>
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
 fs/jffs2/security.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/jffs2/security.c b/fs/jffs2/security.c
index cfeb716..6847769 100644
--- a/fs/jffs2/security.c
+++ b/fs/jffs2/security.c
@@ -20,6 +20,7 @@
 #include <linux/xattr.h>
 #include <linux/mtd/mtd.h>
 #include <linux/security.h>
+#include <linux/evm.h>
 #include "nodelist.h"
 
 /* ---- Initial Security Label Attachment -------------- */
@@ -28,19 +29,30 @@ int jffs2_init_security(struct inode *inode, struct inode *dir,
 {
 	int rc;
 	size_t len;
-	void *value;
-	char *name;
+	struct xattr lsm_xattr;
+	struct xattr evm_xattr;
 
-	rc = security_inode_init_security(inode, dir, qstr, &name, &value, &len);
+	rc = security_inode_init_security(inode, dir, qstr, &lsm_xattr.name,
+					  &lsm_xattr.value,
+					  &lsm_xattr.value_len);
 	if (rc) {
 		if (rc == -EOPNOTSUPP)
 			return 0;
 		return rc;
 	}
-	rc = do_jffs2_setxattr(inode, JFFS2_XPREFIX_SECURITY, name, value, len, 0);
-
-	kfree(name);
-	kfree(value);
+	rc = do_jffs2_setxattr(inode, JFFS2_XPREFIX_SECURITY, lsm_xattr.name,
+			       lsm_xattr.value, lsm_xattr.value_len, 0);
+	if (rc)
+		goto out;
+	rc = evm_inode_post_init_security(inode, &lsm_xattr, &evm_xattr);
+	if (err)
+		goto out;
+	rc = do_jffs2_setxattr(inode, JFFS2_XPREFIX_SECURITY, evm_xattr.name,
+			       evm_xattr.value, evm_xattr.value_len, 0);
+	kfree(evm_xattr.value);
+out:
+	kfree(lsm_xattr.name);
+	kfree(lsm_xattr.value);
 	return rc;
 }
 
-- 
1.7.3.4

