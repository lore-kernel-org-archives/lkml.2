Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421Ab1C3WCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:02:05 -0400
Received: from cobra.newdream.net ([66.33.216.30]:43164 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998Ab1C3WB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:01:57 -0400
From: Sage Weil <sage@newdream.net>
To: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mszeredi@suse.cz,
        Sage Weil <sage@newdream.net>
Subject: [PATCH 1/7] vfs: dentry_unhash immediately prior to rmdir
Date: Wed, 30 Mar 2011 15:09:22 -0700
Message-Id: <1301522968-4382-2-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1301522968-4382-1-git-send-email-sage@newdream.net>
References: <1301522968-4382-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This presumes that there is no reason to unhash a dentry if we fail because
it is a mountpoint or the LSM check fails, and that the LSM checks do not
depend on the dentry being unhashed.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/namei.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a4689eb..f47a5c0 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2838,24 +2838,24 @@ int vfs_rmdir(struct inode *dir, struct dentry *dentry)
 		return -EPERM;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
-	dentry_unhash(dentry);
 	if (d_mountpoint(dentry))
 		error = -EBUSY;
 	else {
 		error = security_inode_rmdir(dir, dentry);
 		if (!error) {
+			dentry_unhash(dentry);
 			error = dir->i_op->rmdir(dir, dentry);
 			if (!error) {
 				dentry->d_inode->i_flags |= S_DEAD;
 				dont_mount(dentry);
 			}
+			dput(dentry);
 		}
 	}
 	mutex_unlock(&dentry->d_inode->i_mutex);
 	if (!error) {
 		d_delete(dentry);
 	}
-	dput(dentry);
 
 	return error;
 }
-- 
1.7.0

