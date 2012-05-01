Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab2EAPSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 11:18:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46419 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136Ab2EAPSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 11:18:00 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Andy Whitcroft <apw@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 4/5] overlayfs: switch from d_alloc_root() to d_make_root()
Date: Tue,  1 May 2012 16:17:54 +0100
Message-Id: <1335885475-11990-5-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1335885475-11990-1-git-send-email-apw@canonical.com>
References: <1335885475-11990-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d_alloc_root() has been deprecated (and removed) in favour of
d_make_root().  Follow this new interface.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/overlayfs/super.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b679019..24bdcc5 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -538,13 +538,9 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (oe == NULL)
 		goto out_free_config;
 
-	root_inode = ovl_new_inode(sb, S_IFDIR, oe);
-	if (!root_inode)
-		goto out_free_oe;
-
 	err = kern_path(ufs->config.upperdir, LOOKUP_FOLLOW, &upperpath);
 	if (err)
-		goto out_put_root;
+		goto out_free_oe;
 
 	err = kern_path(ufs->config.lowerdir, LOOKUP_FOLLOW, &lowerpath);
 	if (err)
@@ -596,7 +592,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	err = -ENOMEM;
-	root_dentry = d_alloc_root(root_inode);
+	root_inode = ovl_new_inode(sb, S_IFDIR, oe);
+	if (!root_inode)
+		goto out_drop_write;
+
+	root_dentry = d_make_root(root_inode);
 	if (!root_dentry)
 		goto out_drop_write;
 
@@ -626,8 +626,6 @@ out_put_lowerpath:
 	path_put(&lowerpath);
 out_put_upperpath:
 	path_put(&upperpath);
-out_put_root:
-	iput(root_inode);
 out_free_oe:
 	kfree(oe);
 out_free_config:
-- 
1.7.9.5

