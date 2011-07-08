Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab1GHOjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 10:39:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34667 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab1GHOjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 10:39:19 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Erez Zadok <ezk@fsl.cs.sunysb.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "viro\@ZenIV.linux.org.uk Viro" <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
	<4540f7aa16724111bd792a1d577261c2@HUBCAS1.cs.stonybrook.edu>
	<954F11FF-339B-48E2-8358-A158DE1E53BC@fsl.cs.sunysb.edu>
	<12728.1308237302@jrobl> <87hb7piwrl.fsf@tucsk.pomaz.szeredi.hu>
Date: Fri, 08 Jul 2011 16:40:10 +0200
In-Reply-To: <87hb7piwrl.fsf@tucsk.pomaz.szeredi.hu> (Miklos Szeredi's message
	of "Thu, 16 Jun 2011 18:09:02 +0200")
Message-ID: <877h7s3kfp.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> "J. R. Okajima" <hooanon05@yahoo.co.jp> writes:
>
>> Additionally the number of members may be important too. Overlayfs
>> supports only two members currently. When a user wants more layers,
>> he has to mount another overlayfs over overlayfs. Since it is
>> essentially equivalent to a recursive function call internally, and of
>> course the stack size in kernel space is limited, I don't think it is
>> good.
>
> Good point about stack space.

Here's a patch to limit stacking overlayfs instances on top of each
other and on ecryptfs to prevent kernel stack overflow.

Thanks,
Miklos


Subject: fs: limit filesystem stacking depth

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
 3 files changed, 28 insertions(+)

Index: linux-2.6/fs/ecryptfs/main.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/main.c	2011-07-08 12:45:21.000000000 +0200
+++ linux-2.6/fs/ecryptfs/main.c	2011-07-08 12:45:27.000000000 +0200
@@ -525,6 +525,13 @@ static struct dentry *ecryptfs_mount(str
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
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2011-07-08 12:45:21.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2011-07-08 12:45:27.000000000 +0200
@@ -480,6 +480,12 @@ struct iattr {
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
@@ -1438,6 +1444,11 @@ struct super_block {
 	 * Saved pool identifier for cleancache (-1 means none)
 	 */
 	int cleancache_poolid;
+
+	/*
+	 * Indicates how deep in a filesystem stack this SB is
+	 */
+	int s_stack_depth;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
Index: linux-2.6/fs/overlayfs/super.c
===================================================================
--- linux-2.6.orig/fs/overlayfs/super.c	2011-07-07 16:01:47.000000000 +0200
+++ linux-2.6/fs/overlayfs/super.c	2011-07-08 12:51:29.000000000 +0200
@@ -545,6 +545,16 @@ static int ovl_fill_super(struct super_b
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
