Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab2IQAvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:51:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33529 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753200Ab2IQAt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:57 -0400
Message-Id: <20120917003644.583170190@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tyler Hicks <tyhicks@canonical.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: [ 133/135] eCryptfs: Copy up attributes of the lower target inode after rename
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

commit 8335eafc2859e1a26282bef7c3d19f3d68868b8a upstream.

After calling into the lower filesystem to do a rename, the lower target
inode's attributes were not copied up to the eCryptfs target inode. This
resulted in the eCryptfs target inode staying around, rather than being
evicted, because i_nlink was not updated for the eCryptfs inode. This
also meant that eCryptfs didn't do the final iput() on the lower target
inode so it stayed around, as well. This would result in a failure to
free up space occupied by the target file in the rename() operation.
Both target inodes would eventually be evicted when the eCryptfs
filesystem was unmounted.

This patch calls fsstack_copy_attr_all() after the lower filesystem
does its ->rename() so that important inode attributes, such as i_nlink,
are updated at the eCryptfs layer. ecryptfs_evict_inode() is now called
and eCryptfs can drop its final reference on the lower inode.

http://launchpad.net/bugs/561129

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Tested-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ecryptfs/inode.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 534b129..cc7709e 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -619,6 +619,7 @@ ecryptfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct dentry *lower_old_dir_dentry;
 	struct dentry *lower_new_dir_dentry;
 	struct dentry *trap = NULL;
+	struct inode *target_inode;
 
 	lower_old_dentry = ecryptfs_dentry_to_lower(old_dentry);
 	lower_new_dentry = ecryptfs_dentry_to_lower(new_dentry);
@@ -626,6 +627,7 @@ ecryptfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	dget(lower_new_dentry);
 	lower_old_dir_dentry = dget_parent(lower_old_dentry);
 	lower_new_dir_dentry = dget_parent(lower_new_dentry);
+	target_inode = new_dentry->d_inode;
 	trap = lock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
 	/* source should not be ancestor of target */
 	if (trap == lower_old_dentry) {
@@ -641,6 +643,9 @@ ecryptfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			lower_new_dir_dentry->d_inode, lower_new_dentry);
 	if (rc)
 		goto out_lock;
+	if (target_inode)
+		fsstack_copy_attr_all(target_inode,
+				      ecryptfs_inode_to_lower(target_inode));
 	fsstack_copy_attr_all(new_dir, lower_new_dir_dentry->d_inode);
 	if (new_dir != old_dir)
 		fsstack_copy_attr_all(old_dir, lower_old_dir_dentry->d_inode);


