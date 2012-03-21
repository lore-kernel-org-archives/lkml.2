Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab2CUS55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 14:57:57 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53347 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab2CUS5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 14:57:53 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@us.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH v3 01/12] vfs: extend vfs_removexattr locking
Date: Wed, 21 Mar 2012 14:54:06 -0400
Message-Id: <1332356057-3356-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1332356057-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1332356057-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032118-1780-0000-0000-000004266613
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000259; HX=3.00000186; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00124013; UDB=6.00029706; UTC=2012-03-21
 18:57:51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch takes the i_mutex lock before security_inode_removexattr(),
instead of after, in preparation of calling ima_inode_removexattr().

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 fs/xattr.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 82f4337..6112c92 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -294,11 +294,13 @@ vfs_removexattr(struct dentry *dentry, const char *name)
 	if (error)
 		return error;
 
+	mutex_lock(&inode->i_mutex);
 	error = security_inode_removexattr(dentry, name);
-	if (error)
+	if (error) {
+		mutex_unlock(&inode->i_mutex);
 		return error;
+	}
 
-	mutex_lock(&inode->i_mutex);
 	error = inode->i_op->removexattr(dentry, name);
 	mutex_unlock(&inode->i_mutex);
 
-- 
1.7.6.5

