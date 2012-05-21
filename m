Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab2EUPaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:30:20 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60065 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab2EUPaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:30:14 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, mszeredi@suse.cz
Subject: [PATCH 04/16] vfs: do_last(): use inode variable
Date: Mon, 21 May 2012 17:30:08 +0200
Message-Id: <1337614220-6174-5-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
References: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Use helper variable instead of path->dentry->d_inode before complete_walk().
This will allow this code to be used in RCU mode.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 1b1a83f..1dba4a7 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2360,15 +2360,17 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	if (error)
 		nd->flags |= LOOKUP_JUMPED;
 
+	BUG_ON(nd->flags & LOOKUP_RCU);
+	inode = path->dentry->d_inode;
 	error = -ENOENT;
-	if (!path->dentry->d_inode)
+	if (!inode)
 		goto exit_dput;
 
-	if (path->dentry->d_inode->i_op->follow_link)
+	if (inode->i_op->follow_link)
 		return NULL;
 
 	path_to_nameidata(path, nd);
-	nd->inode = path->dentry->d_inode;
+	nd->inode = inode;
 	/* Why this, you ask?  _Now_ we might have grown LOOKUP_JUMPED... */
 	error = complete_walk(nd);
 	if (error)
-- 
1.7.7

