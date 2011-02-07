Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab1BGVPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:15:34 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:3286 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab1BGVPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:15:33 -0500
From: Andrey Vagin <avagin@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        Andrey Vagin <avagin@openvz.org>
Subject: [PATCH] fs: devpts_pty_new() return -ENOMEM if dentry allocation failed
Date: Tue,  8 Feb 2011 00:14:52 +0300
Message-Id: <1297113292-15374-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this case nobody can open a slave point, so will be better return
from devpts_pty_new()

Now we should not check error code from d_find_alias() in
devpts_pty_kill(), because the dentry exists all times.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/devpts/inode.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 8392c8c..2f27e57 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -479,6 +479,7 @@ int devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty)
 	struct dentry *root = sb->s_root;
 	struct pts_fs_info *fsi = DEVPTS_SB(sb);
 	struct pts_mount_opts *opts = &fsi->mount_opts;
+	int ret = 0;
 	char s[12];
 
 	/* We're supposed to be given the slave end of a pty */
@@ -504,11 +505,14 @@ int devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty)
 	if (dentry) {
 		d_add(dentry, inode);
 		fsnotify_create(root->d_inode, dentry);
+	} else {
+		iput(inode);
+		ret = -ENOMEM;
 	}
 
 	mutex_unlock(&root->d_inode->i_mutex);
 
-	return 0;
+	return ret;
 }
 
 struct tty_struct *devpts_get_tty(struct inode *pts_inode, int number)
@@ -544,17 +548,12 @@ void devpts_pty_kill(struct tty_struct *tty)
 	mutex_lock(&root->d_inode->i_mutex);
 
 	dentry = d_find_alias(inode);
-	if (IS_ERR(dentry))
-		goto out;
-
-	if (dentry) {
-		inode->i_nlink--;
-		d_delete(dentry);
-		dput(dentry);	/* d_alloc_name() in devpts_pty_new() */
-	}
 
+	inode->i_nlink--;
+	d_delete(dentry);
+	dput(dentry);	/* d_alloc_name() in devpts_pty_new() */
 	dput(dentry);		/* d_find_alias above */
-out:
+
 	mutex_unlock(&root->d_inode->i_mutex);
 }
 
-- 
1.7.2.1

