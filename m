Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab2CGVZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:25:07 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65496 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab2CGVXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:32 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 21/25] gfs2: use i_op->atomic_create()
Date: Wed,  7 Mar 2012 22:22:38 +0100
Message-Id: <1331155362-11132-22-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

GFS2 doesn't open the file in ->create, but it does check the LOOKUP_EXCL flag
in it's create function.  Convert to using ->atomic_create and checking O_EXCL
so that the nameidata argument is no longer necessary.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/gfs2/inode.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 5698746..203ec3c 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -754,13 +754,21 @@ fail:
  * Returns: errno
  */
 
-static int gfs2_create(struct inode *dir, struct dentry *dentry,
-		       umode_t mode, struct nameidata *nd)
+static struct file *gfs2_create(struct inode *dir, struct dentry *dentry,
+				struct opendata *od, unsigned open_flag,
+				umode_t mode)
 {
-	int excl = 0;
-	if (nd && (nd->flags & LOOKUP_EXCL))
+	int err;
+	int excl = 0; /* Why is excl not the default? */
+
+	if (od && (open_flag & O_EXCL))
 		excl = 1;
-	return gfs2_create_inode(dir, dentry, S_IFREG | mode, 0, NULL, 0, excl);
+
+	err = gfs2_create_inode(dir, dentry, S_IFREG | mode, 0, NULL, 0, excl);
+	if (err)
+		return ERR_PTR(err);
+
+	return NULL;
 }
 
 /**
@@ -1809,7 +1817,7 @@ const struct inode_operations gfs2_file_iops = {
 };
 
 const struct inode_operations gfs2_dir_iops = {
-	.create = gfs2_create,
+	.atomic_create = gfs2_create,
 	.lookup = gfs2_lookup,
 	.link = gfs2_link,
 	.unlink = gfs2_unlink,
-- 
1.7.7

