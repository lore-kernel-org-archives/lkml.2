Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab2CGV1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:27:55 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61992 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865Ab2CGVXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:12 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 10/25] nfs: don't use nd->intent.open.flags
Date: Wed,  7 Mar 2012 22:22:27 +0100
Message-Id: <1331155362-11132-11-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Instead check LOOKUP_EXCL in nd->flags, which is basically what the open intent
flags were used for.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/nfs/dir.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 8627965..cd35abb 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1502,7 +1502,7 @@ static int nfs4_lookup_revalidate(struct dentry *dentry, struct nameidata *nd)
 	struct dentry *parent = NULL;
 	struct inode *inode;
 	struct inode *dir;
-	int openflags, ret = 0;
+	int ret = 0;
 
 	if (nd->flags & LOOKUP_RCU)
 		return -ECHILD;
@@ -1526,9 +1526,8 @@ static int nfs4_lookup_revalidate(struct dentry *dentry, struct nameidata *nd)
 	/* NFS only supports OPEN on regular files */
 	if (!S_ISREG(inode->i_mode))
 		goto no_open_dput;
-	openflags = nd->intent.open.flags;
 	/* We cannot do exclusive creation on a positive dentry */
-	if ((openflags & (O_CREAT|O_EXCL)) == (O_CREAT|O_EXCL))
+	if (nd && nd->flags & LOOKUP_EXCL)
 		goto no_open_dput;
 
 	/* Let f_op->open() actually open (and revalidate) the file */
@@ -1607,8 +1606,8 @@ static int nfs_create(struct inode *dir, struct dentry *dentry,
 	attr.ia_mode = mode;
 	attr.ia_valid = ATTR_MODE;
 
-	if (nd)
-		open_flags = nd->intent.open.flags;
+	if (nd && !(nd->flags & LOOKUP_EXCL))
+		open_flags = O_CREAT;
 
 	error = NFS_PROTO(dir)->create(dir, dentry, &attr, open_flags);
 	if (error != 0)
-- 
1.7.7

