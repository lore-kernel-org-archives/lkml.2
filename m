Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933767Ab1ESSEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:04:35 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34328 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933638Ab1ESSEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:04:33 -0400
Date: Thu, 19 May 2011 19:04:28 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, mszeredi@suse.cz
Subject: Re: [PATCH 0/7] overlay filesystem v9
Message-ID: <20110519180428.GI3702@shadowen.org>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
 <20110519163709.GH3702@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519163709.GH3702@shadowen.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 05:37:09PM +0100, Andy Whitcroft wrote:

> Now I am nothing like a filesystems expert but looking at what other
> filesystems do I think the patch below is sufficient, but certainly it
> needs some sanity checking.  At least it fixes all the issues I see here.

Doh.  Below.

-apw

>From 8bab7242155e614d357e23132cc86964822300d0 Mon Sep 17 00:00:00 2001
From: Andy Whitcroft <apw@canonical.com>
Date: Thu, 19 May 2011 12:43:59 +0100
Subject: [PATCH 1/1] ovl: ensure overlayfs inodes have correct ownerships

Overlayfs builds internal inodes representing the intersection between
the upper and lower directories.  However these inodes do not inherit the
ownership of the underlying inodes, this is transparent in the normal case
as most operations apply to the real backing inodes.  However the LSM
hooks commonly are passed these inodes and may make erroneous decisions
based on the carried credentials.

Fix up the permissions in any new inode to either match the intended
ownership of the directory for new files, or the underlying file for
existing files.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/overlayfs/dir.c   |   15 +++++++++------
 fs/overlayfs/super.c |    2 ++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index e1c09c4..f0a672f 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -268,8 +268,8 @@ static int ovl_dir_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	return 0;
 }
 
-static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
-			     const char *link)
+static int ovl_create_object(struct inode *dir, struct dentry *dentry, int mode,
+				dev_t rdev, const char *link)
 {
 	int err;
 	struct dentry *newdentry;
@@ -284,6 +284,7 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 	inode = ovl_new_inode(dentry->d_sb, mode, dentry->d_fsdata);
 	if (!inode)
 		goto out;
+	inode_init_owner(inode, dir, mode);
 
 	err = ovl_copy_up(dentry->d_parent);
 	if (err)
@@ -325,24 +326,26 @@ out:
 static int ovl_create(struct inode *dir, struct dentry *dentry, int mode,
 			struct nameidata *nd)
 {
-	return ovl_create_object(dentry, (mode & 07777) | S_IFREG, 0, NULL);
+	return ovl_create_object(dir, dentry,
+					(mode & 07777) | S_IFREG, 0, NULL);
 }
 
 static int ovl_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
-	return ovl_create_object(dentry, (mode & 07777) | S_IFDIR, 0, NULL);
+	return ovl_create_object(dir, dentry,
+					(mode & 07777) | S_IFDIR, 0, NULL);
 }
 
 static int ovl_mknod(struct inode *dir, struct dentry *dentry, int mode,
 		       dev_t rdev)
 {
-	return ovl_create_object(dentry, mode, rdev, NULL);
+	return ovl_create_object(dir, dentry, mode, rdev, NULL);
 }
 
 static int ovl_symlink(struct inode *dir, struct dentry *dentry,
 			 const char *link)
 {
-	return ovl_create_object(dentry, S_IFLNK, 0, link);
+	return ovl_create_object(dir, dentry, S_IFLNK, 0, link);
 }
 
 static int ovl_do_remove(struct dentry *dentry, bool is_dir)
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index a9a09a6..e6b3af5 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -321,6 +321,8 @@ int ovl_do_lookup(struct dentry *dentry)
 		realdentry = upperdentry ? upperdentry : lowerdentry;
 		err = -ENOMEM;
 		inode = ovl_new_inode(dentry->d_sb, realdentry->d_inode->i_mode, oe);
+		inode->i_uid = realdentry->d_inode->i_uid;
+		inode->i_gid = realdentry->d_inode->i_gid;
 		if (!inode)
 			goto out_dput;
 	}
-- 
1.7.4.1

