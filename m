Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977Ab1I1XH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:07:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932866Ab1I1WqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:46:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:38 2011
Message-Id: <20110928220138.404821744@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [124/244] restore pinning the victim dentry in vfs_rmdir()/vfs_rename_dir()
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit 1d2ef5901483004d74947bbf78d5146c24038fe7 upstream.

We used to get the victim pinned by dentry_unhash() prior to commit
64252c75a219 ("vfs: remove dget() from dentry_unhash()") and ->rmdir()
and ->rename() instances relied on that; most of them don't care, but
ones that used d_delete() themselves do.  As the result, we are getting
rmdir() oopses on NFS now.

Just grab the reference before locking the victim and drop it explicitly
after unlocking, same as vfs_rename_other() does.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Simon Kirby <sim@hostway.ca>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namei.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2582,6 +2582,7 @@ int vfs_rmdir(struct inode *dir, struct
 	if (!dir->i_op->rmdir)
 		return -EPERM;
 
+	dget(dentry);
 	mutex_lock(&dentry->d_inode->i_mutex);
 
 	error = -EBUSY;
@@ -2602,6 +2603,7 @@ int vfs_rmdir(struct inode *dir, struct
 
 out:
 	mutex_unlock(&dentry->d_inode->i_mutex);
+	dput(dentry);
 	if (!error)
 		d_delete(dentry);
 	return error;
@@ -3005,6 +3007,7 @@ static int vfs_rename_dir(struct inode *
 	if (error)
 		return error;
 
+	dget(new_dentry);
 	if (target)
 		mutex_lock(&target->i_mutex);
 
@@ -3025,6 +3028,7 @@ static int vfs_rename_dir(struct inode *
 out:
 	if (target)
 		mutex_unlock(&target->i_mutex);
+	dput(new_dentry);
 	if (!error)
 		if (!(old_dir->i_sb->s_type->fs_flags & FS_RENAME_DOES_D_MOVE))
 			d_move(old_dentry,new_dentry);


