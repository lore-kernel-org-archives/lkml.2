Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1LGAjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 19:39:54 -0500
Received: from nm15.access.bullet.mail.mud.yahoo.com ([66.94.237.216]:21413
	"HELO nm15.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755136Ab1LGAjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 19:39:53 -0500
X-Yahoo-Newman-Id: 514466.8789.bm@smtp103.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 4spwev4VM1mJfFJoI36CaHNDCwm0gWngOlT9rAdILdLMqOz
 kKO12gQEwT1fXYV.Qvi4fJBnfw1S3.qIraNgce3RNFgzNsbZjwCCVcwxgK7N
 ZoxNV6rLGbYdiQq7nMw2Gwz0IapwJExdg68FXIna1DYHIG78NKJjTlYfmgDq
 lBAsR.sV1LcG4HFYV441uLJqU8blsbipvrxAOUOpTJ22qk_R0q1_hnOnRY8d
 6WtuZieotK0Sd57v49RTlU0i60qCHtOF.BykpKkEfRY00kviPNUuwqnOi_bZ
 WYO6pFUgAeUl_o0ykb.JoiR4F_Bo041XRX5PGaGNZGbuTbvjmDxrW6ebYTot
 qcicMdtLf7kj7V1K3VgZL.lOfc6nT1zodlc6if6pcBq1CCbfGsh2YIBHEZCn
 VhpNO6OJbhsBU0LvF.YTNQ5AiTtybmthEeDE1llw-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4EDEB5D6.4040202@schaufler-ca.com>
Date: Tue, 06 Dec 2011 16:39:50 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Casey Schaufler <casey@schaufler-ca.com>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH] BTRFS: Establish i_ops before calling d_instantiate
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

The Smack LSM hook for security_d_instantiate checks
the inode's i_op->getxattr value to determine if the
containing filesystem supports extended attributes.
The BTRFS filesystem sets the inode's i_op value only
after it has instantiated the inode. This results in
Smack incorrectly giving new BTRFS inodes attributes
from the filesystem defaults on the assumption that
values can't be stored on the filesystem. This patch
moves the assignment of inode operation vectors ahead
of the calls to d_instantiate, letting Smack know that
the filesystem supports extended attributes. There
should be no impact on the performance or behavior of
BTRFS.


Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

  fs/btrfs/inode.c |   31 ++++++++++++++++++++++++++-----
  1 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2c984f7..df0efca 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4555,11 +4555,18 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
  		goto out_unlock;
  	}
  
+	/*
+	 * If the active LSM wants to access the inode during
+	 * d_instantiate it needs these. Smack checks to see
+	 * if the filesystem supports xattrs by looking at the
+	 * ops vector.
+	 */
+	inode->i_op = &btrfs_special_inode_operations;
+
  	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
  	if (err)
  		drop_inode = 1;
  	else {
-		inode->i_op = &btrfs_special_inode_operations;
  		init_special_inode(inode, inode->i_mode, rdev);
  		btrfs_update_inode(trans, root, inode);
  	}
@@ -4613,14 +4620,21 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
  		goto out_unlock;
  	}
  
+	/*
+	 * If the active LSM wants to access the inode during
+	 * d_instantiate it needs these. Smack checks to see
+	 * if the filesystem supports xattrs by looking at the
+	 * ops vector.
+	 */
+	inode->i_fop = &btrfs_file_operations;
+	inode->i_op = &btrfs_file_inode_operations;
+
  	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
  	if (err)
  		drop_inode = 1;
  	else {
  		inode->i_mapping->a_ops = &btrfs_aops;
  		inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
-		inode->i_fop = &btrfs_file_operations;
-		inode->i_op = &btrfs_file_inode_operations;
  		BTRFS_I(inode)->io_tree.ops = &btrfs_extent_io_ops;
  	}
  out_unlock:
@@ -7076,14 +7090,21 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
  		goto out_unlock;
  	}
  
+	/*
+	 * If the active LSM wants to access the inode during
+	 * d_instantiate it needs these. Smack checks to see
+	 * if the filesystem supports xattrs by looking at the
+	 * ops vector.
+	 */
+	inode->i_fop = &btrfs_file_operations;
+	inode->i_op = &btrfs_file_inode_operations;
+
  	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
  	if (err)
  		drop_inode = 1;
  	else {
  		inode->i_mapping->a_ops = &btrfs_aops;
  		inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
-		inode->i_fop = &btrfs_file_operations;
-		inode->i_op = &btrfs_file_inode_operations;
  		BTRFS_I(inode)->io_tree.ops = &btrfs_extent_io_ops;
  	}
  	if (drop_inode)

