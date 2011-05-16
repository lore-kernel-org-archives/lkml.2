Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab1EPOsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:48:09 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37080 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756003Ab1EPOsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:48:05 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Alex Elder <aelder@sgi.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v5 16/21] evm: add evm_inode_post_init call in xfs
Date: Mon, 16 May 2011 10:45:10 -0400
Message-Id: <1305557115-15652-17-git-send-email-zohar@linux.vnet.ibm.com>
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
 fs/xfs/linux-2.6/xfs_iops.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index dd21784..01b354d 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -46,6 +46,7 @@
 #include <linux/namei.h>
 #include <linux/posix_acl.h>
 #include <linux/security.h>
+#include <linux/evm.h>
 #include <linux/fiemap.h>
 #include <linux/slab.h>
 
@@ -106,23 +107,33 @@ xfs_init_security(
 	const struct qstr *qstr)
 {
 	struct xfs_inode *ip = XFS_I(inode);
-	size_t		length;
-	void		*value;
-	unsigned char	*name;
+	struct xattr lsm_xattr;
+	struct xattr evm_xattr;
 	int		error;
 
-	error = security_inode_init_security(inode, dir, qstr, (char **)&name,
-					     &value, &length);
+	error = security_inode_init_security(inode, dir, qstr, &lsm_xattr.name,
+					     &lsm_xattr.value,
+					     &lsm_xattr.value_len);
 	if (error) {
 		if (error == -EOPNOTSUPP)
 			return 0;
 		return -error;
 	}
 
-	error = xfs_attr_set(ip, name, value, length, ATTR_SECURE);
+	error = xfs_attr_set(ip, lsm_xattr.name, lsm_xattr.value,
+			     lsm_xattr.value_len, ATTR_SECURE);
+	if (error)
+		goto out;
 
-	kfree(name);
-	kfree(value);
+	error = evm_inode_post_init_security(inode, &lsm_xattr, &evm_xattr);
+	if (error)
+		goto out;
+	error = xfs_attr_set(ip, evm_xattr.name, evm_xattr.value,
+			     evm_xattr.value_len, ATTR_SECURE);
+	kfree(evm_xattr.value);
+out:
+	kfree(lsm_xattr.name);
+	kfree(lsm_xattr.value);
 	return error;
 }
 
-- 
1.7.3.4

