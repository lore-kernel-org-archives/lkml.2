Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934163Ab2FENOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:14:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48161 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934069Ab2FENK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:10:58 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com,
        mszeredi@suse.cz, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 09/21] nfs: don't use nd->intent.open.flags
Date: Tue,  5 Jun 2012 15:10:20 +0200
Message-Id: <1338901832-14049-10-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Instead check LOOKUP_EXCL in nd->flags, which is basically what the open intent
flags were used for.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/dir.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 45015d3..0432f47 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1538,7 +1538,7 @@ static int nfs4_lookup_revalidate(struct dentry *dentry, struct nameidata *nd)
 	struct dentry *parent = NULL;
 	struct inode *inode;
 	struct inode *dir;
-	int openflags, ret = 0;
+	int ret = 0;
 
 	if (nd->flags & LOOKUP_RCU)
 		return -ECHILD;
@@ -1562,9 +1562,8 @@ static int nfs4_lookup_revalidate(struct dentry *dentry, struct nameidata *nd)
 	/* NFS only supports OPEN on regular files */
 	if (!S_ISREG(inode->i_mode))
 		goto no_open_dput;
-	openflags = nd->intent.open.flags;
 	/* We cannot do exclusive creation on a positive dentry */
-	if ((openflags & (O_CREAT|O_EXCL)) == (O_CREAT|O_EXCL))
+	if (nd && nd->flags & LOOKUP_EXCL)
 		goto no_open_dput;
 
 	/* Let f_op->open() actually open (and revalidate) the file */
@@ -1643,8 +1642,8 @@ static int nfs_create(struct inode *dir, struct dentry *dentry,
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

