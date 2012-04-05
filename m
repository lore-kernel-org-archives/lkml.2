Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab2DEPAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:00:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62866 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab2DEO7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:59:19 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 25/34] nfs: don't use nd->intent.open.flags
Date: Thu,  5 Apr 2012 16:58:51 +0200
Message-Id: <1333637940-31884-26-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
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
index 8bfced6..73137be 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1512,7 +1512,7 @@ static int nfs4_lookup_revalidate(struct dentry *dentry, struct nameidata *nd)
 	struct dentry *parent = NULL;
 	struct inode *inode;
 	struct inode *dir;
-	int openflags, ret = 0;
+	int ret = 0;
 
 	if (nd->flags & LOOKUP_RCU)
 		return -ECHILD;
@@ -1536,9 +1536,8 @@ static int nfs4_lookup_revalidate(struct dentry *dentry, struct nameidata *nd)
 	/* NFS only supports OPEN on regular files */
 	if (!S_ISREG(inode->i_mode))
 		goto no_open_dput;
-	openflags = nd->intent.open.flags;
 	/* We cannot do exclusive creation on a positive dentry */
-	if ((openflags & (O_CREAT|O_EXCL)) == (O_CREAT|O_EXCL))
+	if (nd && nd->flags & LOOKUP_EXCL)
 		goto no_open_dput;
 
 	/* Let f_op->open() actually open (and revalidate) the file */
@@ -1617,8 +1616,8 @@ static int nfs_create(struct inode *dir, struct dentry *dentry,
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

