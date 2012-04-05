Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab2DEO7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:59:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37053 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab2DEO6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:58:52 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 10/34] vfs: do_last() common post lookup
Date: Thu,  5 Apr 2012 16:58:36 +0200
Message-Id: <1333637940-31884-11-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Now the post lookup code can be shared between O_CREAT and plain opens since
they are essentially the same.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   33 ++-------------------------------
 1 files changed, 2 insertions(+), 31 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 69adb62..9e4ec13 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2280,37 +2280,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 
 			inode = path->dentry->d_inode;
 		}
-		error = -ENOENT;
-		if (!inode) {
-			path_to_nameidata(path, nd);
-			goto exit;
-		}
-
-		if (should_follow_link(inode, !symlink_ok)) {
-			if (nd->flags & LOOKUP_RCU) {
-				if (unlikely(unlazy_walk(nd, path->dentry))) {
-					error = -ECHILD;
-					goto exit;
-				}
-			}
-			BUG_ON(inode != path->dentry->d_inode);
-			return NULL;
-		}
-		path_to_nameidata(path, nd);
-		nd->inode = inode;
-
-		/* sayonara */
-		error = complete_walk(nd);
-		if (error)
-			return ERR_PTR(error);
-
-		error = -ENOTDIR;
-		if (nd->flags & LOOKUP_DIRECTORY) {
-			if (!nd->inode->i_op->lookup)
-				goto exit;
-		}
-		audit_inode(pathname, nd->path.dentry);
-		goto ok;
+		goto finish_lookup;
 	}
 
 	/* create side of things */
@@ -2390,6 +2360,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 		nd->flags |= LOOKUP_JUMPED;
 
 	inode = path->dentry->d_inode;
+finish_lookup:
 	error = -ENOENT;
 	if (!inode) {
 		path_to_nameidata(path, nd);
-- 
1.7.7

