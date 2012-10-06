Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab2JFITa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:19:30 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63071 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab2JFIT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:19:27 -0400
Message-ID: <506FE7FF.5060201@gmail.com>
Date: Sat, 06 Oct 2012 10:12:47 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 03/22] reiserfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/file.c     |    3 +--
 fs/reiserfs/inode.c    |   15 +++++++++++----
 fs/reiserfs/reiserfs.h |    1 +
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/reiserfs/file.c b/fs/reiserfs/file.c
index 8375c92..50302d6 100644
--- a/fs/reiserfs/file.c
+++ b/fs/reiserfs/file.c
@@ -126,7 +126,7 @@ static int reiserfs_file_open(struct inode *inode, struct file *file)
 	return err;
 }
 
-static void reiserfs_vfs_truncate_file(struct inode *inode)
+void reiserfs_vfs_truncate_file(struct inode *inode)
 {
 	mutex_lock(&(REISERFS_I(inode)->tailpack));
 	reiserfs_truncate_file(inode, 1);
@@ -312,7 +312,6 @@ const struct file_operations reiserfs_file_operations = {
 };
 
 const struct inode_operations reiserfs_file_inode_operations = {
-	.truncate = reiserfs_vfs_truncate_file,
 	.setattr = reiserfs_setattr,
 	.setxattr = reiserfs_setxattr,
 	.getxattr = reiserfs_getxattr,
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 4648555..8133483 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3078,8 +3078,10 @@ static ssize_t reiserfs_direct_IO(int rw, struct kiocb *iocb,
 		loff_t isize = i_size_read(inode);
 		loff_t end = offset + iov_length(iov, nr_segs);
 
-		if (end > isize)
-			vmtruncate(inode, isize);
+		if ((end > isize) && inode_newsize_ok(inode, isize) == 0) {
+			truncate_setsize(inode, isize);
+			reiserfs_vfs_truncate_file(inode);
+		}
 	}
 
 	return ret;
@@ -3192,8 +3194,13 @@ int reiserfs_setattr(struct dentry *dentry, struct iattr *attr)
 	 */
 	reiserfs_write_unlock_once(inode->i_sb, depth);
 	if ((attr->ia_valid & ATTR_SIZE) &&
-	    attr->ia_size != i_size_read(inode))
-		error = vmtruncate(inode, attr->ia_size);
+	    attr->ia_size != i_size_read(inode)) {
+		error = inode_newsize_ok(inode, attr->ia_size);
+		if (!error) {
+			truncate_setsize(inode, attr->ia_size);
+			reiserfs_vfs_truncate_file(inode);
+		}
+	}
 
 	if (!error) {
 		setattr_copy(inode, attr);
diff --git a/fs/reiserfs/reiserfs.h b/fs/reiserfs/reiserfs.h
index 33215f5..157e474 100644
--- a/fs/reiserfs/reiserfs.h
+++ b/fs/reiserfs/reiserfs.h
@@ -2455,6 +2455,7 @@ struct reiserfs_transaction_handle *reiserfs_persistent_transaction(struct
 								    *,
 								    int count);
 int reiserfs_end_persistent_transaction(struct reiserfs_transaction_handle *);
+void reiserfs_vfs_truncate_file(struct inode *inode);
 int reiserfs_commit_page(struct inode *inode, struct page *page,
 			 unsigned from, unsigned to);
 void reiserfs_flush_old_commits(struct super_block *);
-- 
1.7.3.4
