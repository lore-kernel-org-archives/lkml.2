Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab2JSCsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:48:03 -0400
Received: from mail.kernel.org ([198.145.19.201]:51670 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932467Ab2JSCr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:47:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tyler Hicks <tyhicks@canonical.com>,
        John Johansen <john.johansen@canonical.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 50/62] eCryptfs: Unlink lower inode when ecryptfs_create() fails
Date: Thu, 18 Oct 2012 19:45:18 -0700
Message-Id: <20121019024304.043026932@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

commit 8bc2d3cf612994a960c2e8eaea37f6676f67082a upstream.

ecryptfs_create() creates a lower inode, allocates an eCryptfs inode,
initializes the eCryptfs inode and cryptographic metadata attached to
the inode, and then writes the metadata to the header of the file.

If an error was to occur after the lower inode was created, an empty
lower file would be left in the lower filesystem. This is a problem
because ecryptfs_open() refuses to open any lower files which do not
have the appropriate metadata in the file header.

This patch properly unlinks the lower inode when an error occurs in the
later stages of ecryptfs_create(), reducing the chance that an empty
lower file will be left in the lower filesystem.

https://launchpad.net/bugs/872905

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Cc: John Johansen <john.johansen@canonical.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/inode.c |   55 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 23 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -143,6 +143,31 @@ static int ecryptfs_interpose(struct den
 	return 0;
 }
 
+static int ecryptfs_do_unlink(struct inode *dir, struct dentry *dentry,
+			      struct inode *inode)
+{
+	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
+	struct inode *lower_dir_inode = ecryptfs_inode_to_lower(dir);
+	struct dentry *lower_dir_dentry;
+	int rc;
+
+	dget(lower_dentry);
+	lower_dir_dentry = lock_parent(lower_dentry);
+	rc = vfs_unlink(lower_dir_inode, lower_dentry);
+	if (rc) {
+		printk(KERN_ERR "Error in vfs_unlink; rc = [%d]\n", rc);
+		goto out_unlock;
+	}
+	fsstack_copy_attr_times(dir, lower_dir_inode);
+	set_nlink(inode, ecryptfs_inode_to_lower(inode)->i_nlink);
+	inode->i_ctime = dir->i_ctime;
+	d_drop(dentry);
+out_unlock:
+	unlock_dir(lower_dir_dentry);
+	dput(lower_dentry);
+	return rc;
+}
+
 /**
  * ecryptfs_do_create
  * @directory_inode: inode of the new file's dentry's parent in ecryptfs
@@ -182,8 +207,10 @@ ecryptfs_do_create(struct inode *directo
 	}
 	inode = __ecryptfs_get_inode(lower_dentry->d_inode,
 				     directory_inode->i_sb);
-	if (IS_ERR(inode))
+	if (IS_ERR(inode)) {
+		vfs_unlink(lower_dir_dentry->d_inode, lower_dentry);
 		goto out_lock;
+	}
 	fsstack_copy_attr_times(directory_inode, lower_dir_dentry->d_inode);
 	fsstack_copy_inode_size(directory_inode, lower_dir_dentry->d_inode);
 out_lock:
@@ -265,7 +292,9 @@ ecryptfs_create(struct inode *directory_
 	 * that this on disk file is prepared to be an ecryptfs file */
 	rc = ecryptfs_initialize_file(ecryptfs_dentry, ecryptfs_inode);
 	if (rc) {
-		drop_nlink(ecryptfs_inode);
+		ecryptfs_do_unlink(directory_inode, ecryptfs_dentry,
+				   ecryptfs_inode);
+		make_bad_inode(ecryptfs_inode);
 		unlock_new_inode(ecryptfs_inode);
 		iput(ecryptfs_inode);
 		goto out;
@@ -477,27 +506,7 @@ out_lock:
 
 static int ecryptfs_unlink(struct inode *dir, struct dentry *dentry)
 {
-	int rc = 0;
-	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	struct inode *lower_dir_inode = ecryptfs_inode_to_lower(dir);
-	struct dentry *lower_dir_dentry;
-
-	dget(lower_dentry);
-	lower_dir_dentry = lock_parent(lower_dentry);
-	rc = vfs_unlink(lower_dir_inode, lower_dentry);
-	if (rc) {
-		printk(KERN_ERR "Error in vfs_unlink; rc = [%d]\n", rc);
-		goto out_unlock;
-	}
-	fsstack_copy_attr_times(dir, lower_dir_inode);
-	set_nlink(dentry->d_inode,
-		  ecryptfs_inode_to_lower(dentry->d_inode)->i_nlink);
-	dentry->d_inode->i_ctime = dir->i_ctime;
-	d_drop(dentry);
-out_unlock:
-	unlock_dir(lower_dir_dentry);
-	dput(lower_dentry);
-	return rc;
+	return ecryptfs_do_unlink(dir, dentry, dentry->d_inode);
 }
 
 static int ecryptfs_symlink(struct inode *dir, struct dentry *dentry,


