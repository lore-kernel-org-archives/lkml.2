Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975Ab0G3Rd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:33:26 -0400
Received: from kroah.org ([198.145.64.141]:51894 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758686Ab0G3RT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:26 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:08 2010
Message-Id: <20100730171508.848265188@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Akira Fujita <a-fujita@rs.jp.nec.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [102/165] ext4: Fix the NULL reference in double_down_write_data_sem()
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 7247c0caa23d94a1cb6b307edba9dc45fb0798d4 upstream (as of v2.6.33-git11)

If EXT4_IOC_MOVE_EXT ioctl is called with NULL donor_fd, fget() in
ext4_ioctl() gets inappropriate file structure for donor; so we need
to do this check earlier, before calling double_down_write_data_sem().

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/move_extent.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -953,14 +953,6 @@ mext_check_arguments(struct inode *orig_
 	unsigned int blkbits = orig_inode->i_blkbits;
 	unsigned int blocksize = 1 << blkbits;
 
-	/* Regular file check */
-	if (!S_ISREG(orig_inode->i_mode) || !S_ISREG(donor_inode->i_mode)) {
-		ext4_debug("ext4 move extent: The argument files should be "
-			"regular file [ino:orig %lu, donor %lu]\n",
-			orig_inode->i_ino, donor_inode->i_ino);
-		return -EINVAL;
-	}
-
 	if (donor_inode->i_mode & (S_ISUID|S_ISGID)) {
 		ext4_debug("ext4 move extent: suid or sgid is set"
 			   " to donor file [ino:orig %lu, donor %lu]\n",
@@ -1207,6 +1199,14 @@ ext4_move_extents(struct file *o_filp, s
 			orig_inode->i_ino, donor_inode->i_ino);
 		return -EINVAL;
 	}
+
+	/* Regular file check */
+	if (!S_ISREG(orig_inode->i_mode) || !S_ISREG(donor_inode->i_mode)) {
+		ext4_debug("ext4 move extent: The argument files should be "
+			"regular file [ino:orig %lu, donor %lu]\n",
+			orig_inode->i_ino, donor_inode->i_ino);
+		return -EINVAL;
+	}
 
 	/* Protect orig and donor inodes against a truncate */
 	ret1 = mext_inode_double_lock(orig_inode, donor_inode);


