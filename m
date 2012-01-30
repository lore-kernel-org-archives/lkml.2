Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2A3WTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:19:42 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44309 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407Ab2A3WTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:19:40 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, David Safford <safford@watson.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@us.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [RFC][PATCH v1 1/9] vfs: extend vfs_removexattr locking
Date: Mon, 30 Jan 2012 17:13:56 -0500
Message-Id: <1327961644-6886-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1327961644-6886-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1327961644-6886-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12013022-5930-0000-0000-000004969E7C
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

