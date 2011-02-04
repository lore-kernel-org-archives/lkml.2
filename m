Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab1BDP2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 10:28:45 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:37751 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab1BDP2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 10:28:44 -0500
From: Andrey Vagin <avagin@openvz.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 2/2] fs: devpts_pty_new() return -ENOMEM if dentry allocation failed
Date: Fri,  4 Feb 2011 18:28:27 +0300
Message-Id: <1296833307-22549-2-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1296833307-22549-1-git-send-email-avagin@openvz.org>
References: <1296833307-22549-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this case nobody can open a slave point, so will be better return error
from devpts_pty_new()

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/devpts/inode.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 530b1f1..31474f3 100644
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
-- 
1.7.2.1

