Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab2HOPrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:47:42 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39288 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab2HOPrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:47:39 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com, dhowells@redhat.com,
        hpj@urpla.net, sedat.dilek@googlemail.com, penberg@kernel.org,
        goran.cetusic@gmail.com, romain@orebokech.com, mszeredi@suse.cz
Subject: [PATCH 08/13] fs: limit filesystem stacking depth
Date: Wed, 15 Aug 2012 17:48:15 +0200
Message-Id: <1345045700-9062-9-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a simple read-only counter to super_block that indicates deep this
is in the stack of filesystems.  Previously ecryptfs was the only
stackable filesystem and it explicitly disallowed multiple layers of
itself.

Overlayfs, however, can be stacked recursively and also may be stacked
on top of ecryptfs or vice versa.

To limit the kernel stack usage we must limit the depth of the
filesystem stack.  Initially the limit is set to 2.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ecryptfs/main.c   |    7 +++++++
 fs/overlayfs/super.c |   10 ++++++++++
 include/linux/fs.h   |   11 +++++++++++
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 2768138..344fb2c 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -565,6 +565,13 @@ static struct dentry *ecryptfs_mount(struct file_system_type *fs_type, int flags
 	s->s_maxbytes = path.dentry->d_sb->s_maxbytes;
 	s->s_blocksize = path.dentry->d_sb->s_blocksize;
 	s->s_magic = ECRYPTFS_SUPER_MAGIC;
+	s->s_stack_depth = path.dentry->d_sb->s_stack_depth + 1;
+
+	rc = -EINVAL;
+	if (s->s_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
+		printk(KERN_ERR "eCryptfs: maximum fs stacking depth exceeded\n");
+		goto out_free;
+	}
 
 	inode = ecryptfs_get_inode(path.dentry->d_inode, s);
 	rc = PTR_ERR(inode);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 69a2099..64d2695 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -551,6 +551,16 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	    !S_ISDIR(lowerpath.dentry->d_inode->i_mode))
 		goto out_put_lowerpath;
 
+	sb->s_stack_depth = max(upperpath.mnt->mnt_sb->s_stack_depth,
+				lowerpath.mnt->mnt_sb->s_stack_depth) + 1;
+
+	err = -EINVAL;
+	if (sb->s_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
+		printk(KERN_ERR "overlayfs: maximum fs stacking depth exceeded\n");
+		goto out_put_lowerpath;
+	}
+
+
 	ufs->upper_mnt = clone_private_mount(&upperpath);
 	err = PTR_ERR(ufs->upper_mnt);
 	if (IS_ERR(ufs->upper_mnt)) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index abc7a53..1265e24 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -505,6 +505,12 @@ struct iattr {
  */
 #include <linux/quota.h>
 
+/*
+ * Maximum number of layers of fs stack.  Needs to be limited to
+ * prevent kernel stack overflow
+ */
+#define FILESYSTEM_MAX_STACK_DEPTH 2
+
 /** 
  * enum positive_aop_returns - aop return codes with specific semantics
  *
@@ -1579,6 +1585,11 @@ struct super_block {
 
 	/* Being remounted read-only */
 	int s_readonly_remount;
+
+	/*
+	 * Indicates how deep in a filesystem stack this SB is
+	 */
+	int s_stack_depth;
 };
 
 /* superblock cache pruning functions */
-- 
1.7.7

