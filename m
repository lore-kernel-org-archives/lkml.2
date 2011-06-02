Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161219Ab1FBMZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 08:25:41 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40142 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161176Ab1FBMZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 08:25:37 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v6 13/20] evm: add evm_inode_post_init call in jffs2
Date: Thu,  2 Jun 2011 08:23:36 -0400
Message-Id: <1307017423-15093-14-git-send-email-zohar@linux.vnet.ibm.com>
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

