Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab2CBGSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 01:18:20 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38603 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab2CBGSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 01:18:18 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of santoshprasadnayak@gmail.com designates 10.68.219.130 as permitted sender) smtp.mail=santoshprasadnayak@gmail.com; dkim=pass header.i=santoshprasadnayak@gmail.com
From: santosh nayak <santoshprasadnayak@gmail.com>
To: sfrench@samba.org
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH] cifs: possible memory leak in xattr.
Date: Fri,  2 Mar 2012 11:47:26 +0530
Message-Id: <1330669046-13738-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

Memory is allocated irrespective of whether CIFS_ACL is configured
or not. But free is happenning only if CIFS_ACL is set. This is a
possible memory leak scenario.

Fix is:
Allocate and free memory only if CIFS_ACL is configured.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 fs/cifs/xattr.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 45f07c4..10d92cf 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -105,7 +105,6 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 	struct cifs_tcon *pTcon;
 	struct super_block *sb;
 	char *full_path;
-	struct cifs_ntsd *pacl;
 
 	if (direntry == NULL)
 		return -EIO;
@@ -164,23 +163,24 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	} else if (strncmp(ea_name, CIFS_XATTR_CIFS_ACL,
 			strlen(CIFS_XATTR_CIFS_ACL)) == 0) {
+#ifdef CONFIG_CIFS_ACL
+		struct cifs_ntsd *pacl;
 		pacl = kmalloc(value_size, GFP_KERNEL);
 		if (!pacl) {
 			cFYI(1, "%s: Can't allocate memory for ACL",
 					__func__);
 			rc = -ENOMEM;
 		} else {
-#ifdef CONFIG_CIFS_ACL
 			memcpy(pacl, ea_value, value_size);
 			rc = set_cifs_acl(pacl, value_size,
 				direntry->d_inode, full_path, CIFS_ACL_DACL);
 			if (rc == 0) /* force revalidate of the inode */
 				CIFS_I(direntry->d_inode)->time = 0;
 			kfree(pacl);
+		}
 #else
 			cFYI(1, "Set CIFS ACL not supported yet");
 #endif /* CONFIG_CIFS_ACL */
-		}
 	} else {
 		int temp;
 		temp = strncmp(ea_name, POSIX_ACL_XATTR_ACCESS,
-- 
1.7.4.4

