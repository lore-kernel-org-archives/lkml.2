Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab2E0UbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 16:31:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34196 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab2E0UbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 16:31:16 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: viro@zeniv.linux.org.uk, akpm@linux-foundation.org, davej@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] fs/xattr.c:getxattr(): improve handling of allocation failures
Date: Sun, 27 May 2012 22:32:03 +0200
Message-Id: <1338150723-13408-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allocation can be as large as 64k.

 - Add __GFP_NOWARN so the falied kmalloc() is silent

 - Fall back to vmalloc() if the kmalloc() failed

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 fs/xattr.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 1d7ac37..4d45b71 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -427,6 +427,7 @@ getxattr(struct dentry *d, const char __user *name, void __user *value,
 {
 	ssize_t error;
 	void *kvalue = NULL;
+	void *vvalue = NULL;
 	char kname[XATTR_NAME_MAX + 1];
 
 	error = strncpy_from_user(kname, name, sizeof(kname));
@@ -438,9 +439,13 @@ getxattr(struct dentry *d, const char __user *name, void __user *value,
 	if (size) {
 		if (size > XATTR_SIZE_MAX)
 			size = XATTR_SIZE_MAX;
-		kvalue = kzalloc(size, GFP_KERNEL);
-		if (!kvalue)
-			return -ENOMEM;
+		kvalue = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
+		if (!kvalue) {
+			vvalue = vmalloc(size);
+			if (!vvalue)
+				return -ENOMEM;
+			kvalue = vvalue;
+		}
 	}
 
 	error = vfs_getxattr(d, kname, kvalue, size);
@@ -452,7 +457,10 @@ getxattr(struct dentry *d, const char __user *name, void __user *value,
 		   than XATTR_SIZE_MAX bytes. Not possible. */
 		error = -E2BIG;
 	}
-	kfree(kvalue);
+	if (vvalue)
+		vfree(vvalue);
+	else
+		kfree(kvalue);
 	return error;
 }
 
-- 
1.7.8.6

