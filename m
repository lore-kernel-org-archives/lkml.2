Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab0KJVrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:47:04 -0500
Received: from skyrme.org ([193.175.80.135]:44539 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757074Ab0KJVrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:47:03 -0500
X-Greylist: delayed 2443 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Nov 2010 16:47:02 EST
From: Oskar Schirmer <oskar@scara.com>
To: Steve French <sfrench@samba.org>
Cc: stable@kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Suresh Jayaraman <sjayaraman@suse.de>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        Oskar Schirmer <oskar@scara.com>
Subject: [PATCH] cifs: fix another memleak, in cifs_root_iget
Date: Wed, 10 Nov 2010 21:06:13 +0000
Message-Id: <1289423173-7044-1-git-send-email-oskar@scara.com>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cifs_root_iget allocates full_path through
cifs_build_path_to_root, but fails to kfree it upon
cifs_get_inode_info* failure.

Make all failure exit paths traverse clean up
handling at the end of the function.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
Cc: stable@kernel.org
---
 fs/cifs/inode.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index ef3a55b..ff7d299 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -881,8 +881,10 @@ struct inode *cifs_root_iget(struct super_block *sb, unsigned long ino)
 		rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
 						xid, NULL);
 
-	if (!inode)
-		return ERR_PTR(rc);
+	if (!inode) {
+		inode = ERR_PTR(rc);
+		goto out;
+	}
 
 #ifdef CONFIG_CIFS_FSCACHE
 	/* populate tcon->resource_id */
@@ -898,13 +900,11 @@ struct inode *cifs_root_iget(struct super_block *sb, unsigned long ino)
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
1.7.0.4

