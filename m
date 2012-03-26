Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab2CZKy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:54:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:32796 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab2CZKyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:54:13 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 3/6] vfs: move MAY_EXEC check from __lookup_hash()
Date: Mon, 26 Mar 2012 12:54:21 +0200
Message-Id: <1332759264-23533-4-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332759264-23533-1-git-send-email-miklos@szeredi.hu>
References: <1332759264-23533-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

The only caller of __lookup_hash() that needs the exec permission check on
parent is lookup_one_len().

All lookup_hash() callers already checked permission in LOOKUP_PARENT walk.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c93ea6d..3e13412 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1726,13 +1726,7 @@ int vfs_path_lookup(struct dentry *dentry, struct vfsmount *mnt,
 static struct dentry *__lookup_hash(struct qstr *name,
 		struct dentry *base, struct nameidata *nd)
 {
-	struct inode *inode = base->d_inode;
 	struct dentry *dentry;
-	int err;
-
-	err = inode_permission(inode, MAY_EXEC);
-	if (err)
-		return ERR_PTR(err);
 
 	/*
 	 * Don't bother with __d_lookup: callers are for creat as
@@ -1799,6 +1793,7 @@ struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
 {
 	struct qstr this;
 	unsigned int c;
+	int err;
 
 	WARN_ON_ONCE(!mutex_is_locked(&base->d_inode->i_mutex));
 
@@ -1823,6 +1818,10 @@ struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
 			return ERR_PTR(err);
 	}
 
+	err = inode_permission(base->d_inode, MAY_EXEC);
+	if (err)
+		return ERR_PTR(err);
+
 	return __lookup_hash(&this, base, NULL);
 }
 
-- 
1.7.7

