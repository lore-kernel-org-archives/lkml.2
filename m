Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934069Ab2FENQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:16:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46637 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760760Ab2FENKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:10:11 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com,
        mszeredi@suse.cz
Subject: [PATCH 02/21] vfs: do_last(): separate O_CREAT specific code
Date: Tue,  5 Jun 2012 15:10:13 +0200
Message-Id: <1338901832-14049-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
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
index d6e8c55..73e824c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2265,22 +2265,23 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
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
@@ -2296,7 +2297,7 @@ retry_lookup:
 	path->mnt = nd->path.mnt;
 
 	/* Negative dentry, just create the file */
-	if (!dentry->d_inode) {
+	if (!dentry->d_inode && (open_flag & O_CREAT)) {
 		umode_t mode = op->mode;
 		if (!IS_POSIXACL(dir->d_inode))
 			mode &= ~current_umask();
-- 
1.7.7

