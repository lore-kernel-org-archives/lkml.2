Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab0LXWzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 17:55:14 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22757 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab0LXWzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 17:55:12 -0500
Date: Fri, 24 Dec 2010 23:45:21 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-btrfs@vger.kernel.org
cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] BTRFS: Don't leak memory in btrfs_get_acl()
Message-ID: <alpine.LNX.2.00.1012242342280.28973@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currrently we leak memory in btrfs_get_acl::btrfs_get_acl() if 
posix_acl_from_xattr() fails. With this patch we do not.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 acl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 2222d16..6d1410e 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -60,8 +60,10 @@ static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 		size = __btrfs_getxattr(inode, name, value, size);
 		if (size > 0) {
 			acl = posix_acl_from_xattr(value, size);
-			if (IS_ERR(acl))
+			if (IS_ERR(acl)) {
+				kfree(value);
 				return acl;
+			}
 			set_cached_acl(inode, type, acl);
 		}
 		kfree(value);


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

