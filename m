Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab0G2JGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 05:06:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64094 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab0G2JEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 05:04:46 -0400
Message-ID: <4C513B31.3010409@cn.fujitsu.com>
Date: Thu, 29 Jul 2010 16:26:25 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, Yan Zheng <zheng.yan@oracle.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/7] btrfs/acl: adjust logical path of btrfs_get_acl()
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Bo <liubo2009@cn.fujitsu.com>

- There exists a memory leak.
- More checks of returned "size" are needed.

According to ext3_get_acl()'s style, we do some adjustments here.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/acl.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 1606dc1..2f4f65a 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -52,26 +52,25 @@ static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 		BUG();
 	}
 
-	size = __btrfs_getxattr(inode, name, "", 0);
+	size = __btrfs_getxattr(inode, name, NULL, 0);
 	if (size > 0) {
 		value = kzalloc(size, GFP_NOFS);
 		if (!value)
 			return ERR_PTR(-ENOMEM);
 		size = __btrfs_getxattr(inode, name, value, size);
-		if (size > 0) {
-			acl = posix_acl_from_xattr(value, size);
-			if (IS_ERR(acl))
-				return acl;
-			set_cached_acl(inode, type, acl);
-		}
-		kfree(value);
+	}
+	if (size > 0) {
+		acl = posix_acl_from_xattr(value, size);
 	} else if (size == -ENOENT || size == -ENODATA || size == 0) {
 		/* FIXME, who returns -ENOENT?  I think nobody */
 		acl = NULL;
-		set_cached_acl(inode, type, acl);
 	} else {
 		acl = ERR_PTR(-EIO);
 	}
+	kfree(value);
+
+	if (!IS_ERR(acl))
+		set_cached_acl(inode, type, acl);
 
 	return acl;
 }
-- 
1.7.0.1
