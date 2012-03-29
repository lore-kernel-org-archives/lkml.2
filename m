Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324Ab2C2OnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 10:43:10 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:55174 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933250Ab2C2Omm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 10:42:42 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@us.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH v4 01/12] vfs: extend vfs_removexattr locking
Date: Thu, 29 Mar 2012 10:41:29 -0400
Message-Id: <1333032100-4159-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1333032100-4159-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1333032100-4159-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032914-7408-0000-0000-000003CF01D1
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

