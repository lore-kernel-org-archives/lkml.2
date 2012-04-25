Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471Ab2DYMsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:48:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45860 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab2DYMoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:44:09 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, mszeredi@suse.cz
Subject: [PATCH 04/16] vfs: do_last(): use inode variable
Date: Wed, 25 Apr 2012 14:44:05 +0200
Message-Id: <1335357857-16416-5-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1335357857-16416-1-git-send-email-miklos@szeredi.hu>
References: <1335357857-16416-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Use helper variable instead of path->dentry->d_inode before complete_walk().
This will allow this code to be used in RCU mode.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 46d4bf6..f21ddb3 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2360,15 +2360,16 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	if (error)
 		nd->flags |= LOOKUP_JUMPED;
 
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

