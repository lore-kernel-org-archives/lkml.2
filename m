Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab2DEO7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:59:30 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62866 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab2DEO6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:58:43 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 05/34] vfs: make follow_link check RCU safe
Date: Thu,  5 Apr 2012 16:58:31 +0200
Message-Id: <1333637940-31884-6-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This will allow this code to be used in RCU mode.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 58d1f62..a94b0d4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2232,6 +2232,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	int acc_mode = op->acc_mode;
 	struct file *filp;
 	struct inode *inode;
+	int symlink_ok = 0;
 	int error;
 
 	nd->flags &= ~LOOKUP_PARENT;
@@ -2263,7 +2264,6 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	}
 
 	if (!(open_flag & O_CREAT)) {
-		int symlink_ok = 0;
 		if (nd->last.name[nd->last.len])
 			nd->flags |= LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
 		if (open_flag & O_PATH && !(nd->flags & LOOKUP_FOLLOW))
@@ -2394,8 +2394,16 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	if (!inode)
 		goto exit_dput;
 
-	if (inode->i_op->follow_link)
+	if (should_follow_link(inode, !symlink_ok)) {
+		if (nd->flags & LOOKUP_RCU) {
+			if (unlikely(unlazy_walk(nd, path->dentry))) {
+				error = -ECHILD;
+				goto exit;
+			}
+		}
+		BUG_ON(inode != path->dentry->d_inode);
 		return NULL;
+	}
 
 	path_to_nameidata(path, nd);
 	nd->inode = inode;
-- 
1.7.7

