Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1HNQKT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:10:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687Ab1HNQKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:10:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:59 2011
Message-Id: <20110812210558.963320597@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:05:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [78/90] eCryptfs: Return error when lower file pointer is NULL
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

commit f61500e000eedc0c7a0201200a7f00ba5529c002 upstream.

When an eCryptfs inode's lower file has been closed, and the pointer has
been set to NULL, return an error when trying to do a lower read or
write rather than calling BUG().

https://bugzilla.kernel.org/show_bug.cgi?id=37292

Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/read_write.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -39,15 +39,16 @@
 int ecryptfs_write_lower(struct inode *ecryptfs_inode, char *data,
 			 loff_t offset, size_t size)
 {
-	struct ecryptfs_inode_info *inode_info;
+	struct file *lower_file;
 	mm_segment_t fs_save;
 	ssize_t rc;
 
-	inode_info = ecryptfs_inode_to_private(ecryptfs_inode);
-	BUG_ON(!inode_info->lower_file);
+	lower_file = ecryptfs_inode_to_private(ecryptfs_inode)->lower_file;
+	if (!lower_file)
+		return -EIO;
 	fs_save = get_fs();
 	set_fs(get_ds());
-	rc = vfs_write(inode_info->lower_file, data, size, &offset);
+	rc = vfs_write(lower_file, data, size, &offset);
 	set_fs(fs_save);
 	mark_inode_dirty_sync(ecryptfs_inode);
 	return rc;
@@ -225,15 +226,16 @@ out:
 int ecryptfs_read_lower(char *data, loff_t offset, size_t size,
 			struct inode *ecryptfs_inode)
 {
-	struct ecryptfs_inode_info *inode_info =
-		ecryptfs_inode_to_private(ecryptfs_inode);
+	struct file *lower_file;
 	mm_segment_t fs_save;
 	ssize_t rc;
 
-	BUG_ON(!inode_info->lower_file);
+	lower_file = ecryptfs_inode_to_private(ecryptfs_inode)->lower_file;
+	if (!lower_file)
+		return -EIO;
 	fs_save = get_fs();
 	set_fs(get_ds());
-	rc = vfs_read(inode_info->lower_file, data, size, &offset);
+	rc = vfs_read(lower_file, data, size, &offset);
 	set_fs(fs_save);
 	return rc;
 }


