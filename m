Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161174Ab1FBMZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 08:25:37 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59010 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161066Ab1FBMZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 08:25:34 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>,
        Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v6 12/20] evm: add evm_inode_post_init call in gfs2
Date: Thu,  2 Jun 2011 08:23:35 -0400
Message-Id: <1307017423-15093-13-git-send-email-zohar@linux.vnet.ibm.com>
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
Acked-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/inode.c |   29 ++++++++++++++++++++---------
 1 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 03e0c52..7f31e01 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -19,6 +19,8 @@
 #include <linux/crc32.h>
 #include <linux/fiemap.h>
 #include <linux/security.h>
+#include <linux/evm.h>
+#include <linux/time.h>
 #include <asm/uaccess.h>
 
 #include "gfs2.h"
@@ -628,12 +630,12 @@ static int gfs2_security_init(struct gfs2_inode *dip, struct gfs2_inode *ip,
 			      const struct qstr *qstr)
 {
 	int err;
-	size_t len;
-	void *value;
-	char *name;
+	struct xattr lsm_xattr;
+	struct xattr evm_xattr;
 
 	err = security_inode_init_security(&ip->i_inode, &dip->i_inode, qstr,
-					   &name, &value, &len);
+					   &lsm_xattr.name, &lsm_xattr.value,
+					   &lsm_xattr.value_len);
 
 	if (err) {
 		if (err == -EOPNOTSUPP)
@@ -641,11 +643,20 @@ static int gfs2_security_init(struct gfs2_inode *dip, struct gfs2_inode *ip,
 		return err;
 	}
 
-	err = __gfs2_xattr_set(&ip->i_inode, name, value, len, 0,
-			       GFS2_EATYPE_SECURITY);
-	kfree(value);
-	kfree(name);
-
+	err = __gfs2_xattr_set(&ip->i_inode, lsm_xattr.name, lsm_xattr.value,
+			       lsm_xattr.value_len, 0, GFS2_EATYPE_SECURITY);
+	if (err < 0)
+		goto out;
+	err = evm_inode_post_init_security(&ip->i_inode, &lsm_xattr,
+					   &evm_xattr);
+	if (err)
+		goto out;
+	err = __gfs2_xattr_set(&ip->i_inode, evm_xattr.name, evm_xattr.value,
+			       evm_xattr.value_len, 0, GFS2_EATYPE_SECURITY);
+	kfree(evm_xattr.value);
+out:
+	kfree(lsm_xattr.name);
+	kfree(lsm_xattr.value);
 	return err;
 }
 
-- 
1.7.3.4

