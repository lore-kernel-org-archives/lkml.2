Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1AFVpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:45:23 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17611 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab1AFVpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:45:22 -0500
Date: Thu, 6 Jan 2011 22:45:21 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-btrfs@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: [PATCH] btrfs: Mem leak in btrfs_get_acl()
Message-ID: <alpine.LNX.2.00.1101062242320.13988@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It seems to me that we leak the memory allocated to 'value' in 
btrfs_get_acl() if the call to posix_acl_from_xattr() fails.
Here's a patch that attempts to correct that problem.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 acl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

  compile tested only.

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

