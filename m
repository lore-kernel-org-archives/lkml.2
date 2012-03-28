Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706Ab2C1U2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:28:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62112 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677Ab2C1UYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 16:24:39 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 08/16] nfs: don't use nd->intent.open.flags
Date: Wed, 28 Mar 2012 22:24:37 +0200
Message-Id: <1332966285-30358-9-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332966285-30358-1-git-send-email-miklos@szeredi.hu>
References: <1332966285-30358-1-git-send-email-miklos@szeredi.hu>
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
index 8828b0d..35fa125 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1508,7 +1508,7 @@ static int nfs4_lookup_revalidate(struct dentry *dentry, struct nameidata *nd)
 	struct dentry *parent = NULL;
 	struct inode *inode;
 	struct inode *dir;
-	int openflags, ret = 0;
+	int ret = 0;
 
 	if (nd->flags & LOOKUP_RCU)
 		return -ECHILD;
@@ -1532,9 +1532,8 @@ static int nfs4_lookup_revalidate(struct dentry *dentry, struct nameidata *nd)
 	/* NFS only supports OPEN on regular files */
 	if (!S_ISREG(inode->i_mode))
 		goto no_open_dput;
-	openflags = nd->intent.open.flags;
 	/* We cannot do exclusive creation on a positive dentry */
-	if ((openflags & (O_CREAT|O_EXCL)) == (O_CREAT|O_EXCL))
+	if (nd && nd->flags & LOOKUP_EXCL)
 		goto no_open_dput;
 
 	/* Let f_op->open() actually open (and revalidate) the file */
@@ -1613,8 +1612,8 @@ static int nfs_create(struct inode *dir, struct dentry *dentry,
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

