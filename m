Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422848Ab2I1Uoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:44:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41696 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031378Ab2I1Uk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:40:56 -0400
X-Sasl-enc: EIm9h5BXBrqi596XLZ1I02ALaf5p1CQPwZsr2/2lQcrH 1348864855
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tyler Hicks <tyhicks@canonical.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: [ 029/127] eCryptfs: Copy up attributes of the lower target inode after rename
Date: Fri, 28 Sep 2012 13:33:22 -0700
Message-Id: <20120928203049.232410101@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/inode.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -653,6 +653,7 @@ ecryptfs_rename(struct inode *old_dir, s
 	struct dentry *lower_old_dir_dentry;
 	struct dentry *lower_new_dir_dentry;
 	struct dentry *trap = NULL;
+	struct inode *target_inode;
 
 	lower_old_dentry = ecryptfs_dentry_to_lower(old_dentry);
 	lower_new_dentry = ecryptfs_dentry_to_lower(new_dentry);
@@ -660,6 +661,7 @@ ecryptfs_rename(struct inode *old_dir, s
 	dget(lower_new_dentry);
 	lower_old_dir_dentry = dget_parent(lower_old_dentry);
 	lower_new_dir_dentry = dget_parent(lower_new_dentry);
+	target_inode = new_dentry->d_inode;
 	trap = lock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
 	/* source should not be ancestor of target */
 	if (trap == lower_old_dentry) {
@@ -675,6 +677,9 @@ ecryptfs_rename(struct inode *old_dir, s
 			lower_new_dir_dentry->d_inode, lower_new_dentry);
 	if (rc)
 		goto out_lock;
+	if (target_inode)
+		fsstack_copy_attr_all(target_inode,
+				      ecryptfs_inode_to_lower(target_inode));
 	fsstack_copy_attr_all(new_dir, lower_new_dir_dentry->d_inode);
 	if (new_dir != old_dir)
 		fsstack_copy_attr_all(old_dir, lower_old_dir_dentry->d_inode);


