Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab2DEPAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:00:00 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49884 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab2DEO7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:59:06 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 18/34] vfs: do_last(): separate O_CREAT specific code
Date: Thu,  5 Apr 2012 16:58:44 +0200
Message-Id: <1333637940-31884-19-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Check O_CREAT on the slow lookup paths where necessary.  This allows the rest to
be shared with plain open.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   33 +++++++++++++++++----------------
 1 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 47bff57..f89827a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2296,22 +2296,23 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 			inode = path->dentry->d_inode;
 		}
 		goto finish_lookup;
-	}
-
-	/* create side of things */
-	/*
-	 * This will *only* deal with leaving RCU mode - LOOKUP_JUMPED has been
-	 * cleared when we got to the last component we are about to look up
-	 */
-	error = complete_walk(nd);
-	if (error)
-		return ERR_PTR(error);
+	} else {
+		/* create side of things */
+		/*
+		 * This will *only* deal with leaving RCU mode - LOOKUP_JUMPED
+		 * has been cleared when we got to the last component we are
+		 * about to look up
+		 */
+		error = complete_walk(nd);
+		if (error)
+			return ERR_PTR(error);
 
-	audit_inode(pathname, dir);
-	error = -EISDIR;
-	/* trailing slashes? */
-	if (nd->last.name[nd->last.len])
-		goto exit;
+		audit_inode(pathname, dir);
+		error = -EISDIR;
+		/* trailing slashes? */
+		if (nd->last.name[nd->last.len])
+			goto exit;
+	}
 
 retry_lookup:
 	mutex_lock(&dir->d_inode->i_mutex);
@@ -2327,7 +2328,7 @@ retry_lookup:
 	path->mnt = nd->path.mnt;
 
 	/* Negative dentry, just create the file */
-	if (!dentry->d_inode) {
+	if (!dentry->d_inode && (open_flag & O_CREAT)) {
 		umode_t mode = op->mode;
 		if (!IS_POSIXACL(dir->d_inode))
 			mode &= ~current_umask();
-- 
1.7.7

