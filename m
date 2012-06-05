Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761419Ab2FENKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:10:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46637 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899Ab2FENKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:10:15 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com,
        mszeredi@suse.cz
Subject: [PATCH 03/21] vfs: do_last(): common slow lookup
Date: Tue,  5 Jun 2012 15:10:14 +0200
Message-Id: <1338901832-14049-4-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Make the slow lookup part of O_CREAT and non-O_CREAT opens common.

This allows atomic_open to be hooked into the slow lookup part.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   27 +++++----------------------
 1 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 73e824c..0a56b61 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2241,30 +2241,13 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 			symlink_ok = 1;
 		/* we _can_ be in RCU mode here */
 		error = lookup_fast(nd, &nd->last, path, &inode);
-		if (unlikely(error)) {
-			if (error < 0)
-				goto exit;
-
-			BUG_ON(nd->inode != dir->d_inode);
-
-			mutex_lock(&dir->d_inode->i_mutex);
-			dentry = __lookup_hash(&nd->last, dir, nd);
-			mutex_unlock(&dir->d_inode->i_mutex);
-			error = PTR_ERR(dentry);
-			if (IS_ERR(dentry))
-				goto exit;
-			path->mnt = nd->path.mnt;
-			path->dentry = dentry;
-			error = follow_managed(path, nd->flags);
-			if (unlikely(error < 0))
-				goto exit_dput;
+		if (likely(!error))
+			goto finish_lookup;
 
-			if (error)
-				nd->flags |= LOOKUP_JUMPED;
+		if (error < 0)
+			goto exit;
 
-			inode = path->dentry->d_inode;
-		}
-		goto finish_lookup;
+		BUG_ON(nd->inode != dir->d_inode);
 	} else {
 		/* create side of things */
 		/*
-- 
1.7.7

