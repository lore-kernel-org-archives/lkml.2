Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964799Ab2CMAYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:24:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:48556 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759078Ab2CMAYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:15 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Oskar Schirmer <oskar@scara.com>,
        Steve French <sfrench@us.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 151/196] cifs: fix another memleak, in cifs_root_iget
Date: Mon, 12 Mar 2012 20:21:04 -0400
Message-Id: <1331598109-31424-106-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oskar Schirmer <oskar@scara.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a7851ce73b9fdef53f251420e6883cf4f3766534 upstream.

cifs_root_iget allocates full_path through
cifs_build_path_to_root, but fails to kfree it upon
cifs_get_inode_info* failure.

Make all failure exit paths traverse clean up
handling at the end of the function.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/cifs/inode.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 49b47c3..da3e83f 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -793,8 +793,10 @@ struct inode *cifs_root_iget(struct super_block *sb, unsigned long ino)
 		rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
 						xid, NULL);
 
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
+	if (!inode) {
+		inode = ERR_PTR(-ENOMEM);
+		goto out;
+	}
 
 	if (rc && cifs_sb->tcon->ipc) {
 		cFYI(1, ("ipc connection - fake read inode"));
@@ -805,13 +807,11 @@ struct inode *cifs_root_iget(struct super_block *sb, unsigned long ino)
 		inode->i_uid = cifs_sb->mnt_uid;
 		inode->i_gid = cifs_sb->mnt_gid;
 	} else if (rc) {
-		kfree(full_path);
-		_FreeXid(xid);
 		iget_failed(inode);
-		return ERR_PTR(rc);
+		inode = ERR_PTR(rc);
 	}
 
-
+out:
 	kfree(full_path);
 	/* can not call macro FreeXid here since in a void func
 	 * TODO: This is no longer true
-- 
1.7.9.3

