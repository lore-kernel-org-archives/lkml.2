Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762759Ab2DLUrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:47:55 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12605 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab2DLUry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:47:54 -0400
Date: Thu, 12 Apr 2012 22:47:52 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: Make free_ipath() deal gracefully with NULL
 pointers
Message-ID: <alpine.LNX.2.00.1204122246410.7553@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make free_ipath() behave like most other freeing functions in the
kernel and gracefully do nothing when passed a NULL pointer.

Besides this making the bahaviour consistent with functions such as
kfree(), vfree(), btrfs_free_path() etc etc, it also fixes a real NULL
deref issue in fs/btrfs/ioctl.c::btrfs_ioctl_ino_to_path(). In that
function we have this code:

...
        ipath = init_ipath(size, root, path);
        if (IS_ERR(ipath)) {
                ret = PTR_ERR(ipath);
                ipath = NULL;
                goto out;
        }
...
out:
        btrfs_free_path(path);
        free_ipath(ipath);
...

If we ever take the true branch of that 'if' statement we'll end up
passing a NULL pointer to free_ipath() which will subsequently
dereference it and we'll go "Boom" :-(
This patch will avoid that.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 fs/btrfs/backref.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index f4e9074..b332ff0 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1414,6 +1414,8 @@ struct inode_fs_paths *init_ipath(s32 total_bytes, struct btrfs_root *fs_root,
 
 void free_ipath(struct inode_fs_paths *ipath)
 {
+	if (!ipath)
+		return;
 	kfree(ipath->fspath);
 	kfree(ipath);
 }
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

