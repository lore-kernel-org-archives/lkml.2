Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab2EUPaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:30:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60065 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab2EUPaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:30:11 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, mszeredi@suse.cz
Subject: [PATCH 03/16] vfs: do_last(): inline walk_component()
Date: Mon, 21 May 2012 17:30:07 +0200
Message-Id: <1337614220-6174-4-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
References: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Copy walk_component() into do_lookup().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   35 ++++++++++++++++++++++++++++++-----
 1 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d55ef9e..1b1a83f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2202,6 +2202,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	int want_write = 0;
 	int acc_mode = op->acc_mode;
 	struct file *filp;
+	struct inode *inode;
 	int error;
 
 	nd->flags &= ~LOOKUP_PARENT;
@@ -2239,12 +2240,36 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 		if (open_flag & O_PATH && !(nd->flags & LOOKUP_FOLLOW))
 			symlink_ok = 1;
 		/* we _can_ be in RCU mode here */
-		error = walk_component(nd, path, &nd->last, LAST_NORM,
-					!symlink_ok);
-		if (error < 0)
-			return ERR_PTR(error);
-		if (error) /* symlink */
+		error = lookup_fast(nd, &nd->last, path, &inode);
+		if (unlikely(error)) {
+			if (error < 0)
+				goto exit;
+
+			error = lookup_slow(nd, &nd->last, path);
+			if (error < 0)
+				goto exit;
+
+			inode = path->dentry->d_inode;
+		}
+		error = -ENOENT;
+		if (!inode) {
+			path_to_nameidata(path, nd);
+			goto exit;
+		}
+
+		if (should_follow_link(inode, !symlink_ok)) {
+			if (nd->flags & LOOKUP_RCU) {
+				if (unlikely(unlazy_walk(nd, path->dentry))) {
+					error = -ECHILD;
+					goto exit;
+				}
+			}
+			BUG_ON(inode != path->dentry->d_inode);
 			return NULL;
+		}
+		path_to_nameidata(path, nd);
+		nd->inode = inode;
+
 		/* sayonara */
 		error = complete_walk(nd);
 		if (error)
-- 
1.7.7

