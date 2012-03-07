Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030366Ab2CGV26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:28:58 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52137 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab2CGVXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:03 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 05/25] vfs: add filesystem flags for atomic_open
Date: Wed,  7 Mar 2012 22:22:22 +0100
Message-Id: <1331155362-11132-6-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Allow filesystem to select which cases it wants to perform atomic_open.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c         |   16 +++++++++++++++-
 include/linux/fs.h |    2 ++
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 835dcf1..8dfbe45 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2227,6 +2227,20 @@ look_up:
 	return NULL;
 }
 
+static bool is_atomic_lookup_open(struct inode *dir, struct nameidata *nd)
+{
+	int fs_flags;
+
+	if (!(nd->flags & LOOKUP_OPEN) || !dir->i_op->atomic_open)
+		return false;
+
+	fs_flags = dir->i_sb->s_type->fs_flags;
+	if (nd->flags & LOOKUP_CREATE)
+		return !(fs_flags & FS_NO_LOOKUP_CREATE);
+	else
+		return !(fs_flags & FS_NO_LOOKUP_OPEN);
+}
+
 /*
  * Lookup and possibly open (and create) the last component
  *
@@ -2253,7 +2267,7 @@ static struct file *lookup_open(struct nameidata *nd, struct path *path,
 	if (!need_lookup && dentry->d_inode)
 		goto out_no_open;
 
-	if ((nd->flags & LOOKUP_OPEN) && dir_inode->i_op->atomic_open) {
+	if (is_atomic_lookup_open(dir_inode, nd)) {
 		struct file *filp;
 
 		filp = atomic_open(nd, dentry, op, want_write, &create_error);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3a47ecd..6615355 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -181,6 +181,8 @@ struct inodes_stat_t {
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move()
 					 * during rename() internally.
 					 */
+#define FS_NO_LOOKUP_OPEN	0x10000	/* fs can't do atomic lookup+open */
+#define FS_NO_LOOKUP_CREATE	0x20000 /* fs can't do lookup+create+open */
 
 /*
  * These are the fs-independent mount-flags: up to 32 flags are supported
-- 
1.7.7

