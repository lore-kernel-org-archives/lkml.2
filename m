Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab1E0M77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:59:59 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56265 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab1E0M74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:59:56 -0400
From: Andreas Gruenbacher <agruen@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] xattr: Fix error results for non-existent / invisible attributes
Date: Fri, 27 May 2011 14:50:36 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.36-rc7+; KDE/4.3.5; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105271450.37089.agruen@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENODATA when trying to read a user.* attribute which cannot
exist: user space otherwise does not have a reasonable way to
distinguish between non-existent and inaccessible attributes.

Likewise, return -ENODATA when an unprivileged process tries to read a
trusted.* attribute: to unprivileged processes, those attributes are
invisible (listxattr() won't include them).

Related to this bug report: https://bugzilla.redhat.com/660613

Signed-off-by: Andreas Gruenbacher <agruen@kernel.org>
---
 fs/xattr.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index f1ef949..4be2e76 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -46,18 +46,22 @@ xattr_permission(struct inode *inode, const char *name, int mask)
 		return 0;
 
 	/*
-	 * The trusted.* namespace can only be accessed by a privileged user.
+	 * The trusted.* namespace can only be accessed by privileged users.
 	 */
-	if (!strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN))
-		return (capable(CAP_SYS_ADMIN) ? 0 : -EPERM);
+	if (!strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN)) {
+		if (!capable(CAP_SYS_ADMIN))
+			return (mask & MAY_WRITE) ? -EPERM : -ENODATA;
+		return 0;
+	}
 
-	/* In user.* namespace, only regular files and directories can have
+	/*
+	 * In the user.* namespace, only regular files and directories can have
 	 * extended attributes. For sticky directories, only the owner and
-	 * privileged user can write attributes.
+	 * privileged users can write attributes.
 	 */
 	if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)) {
 		if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
-			return -EPERM;
+			return (mask & MAY_WRITE) ? -EPERM : -ENODATA;
 		if (S_ISDIR(inode->i_mode) && (inode->i_mode & S_ISVTX) &&
 		    (mask & MAY_WRITE) && !inode_owner_or_capable(inode))
 			return -EPERM;
-- 
1.7.1
