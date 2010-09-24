Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103Ab0IXQm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:42:57 -0400
Received: from kroah.org ([198.145.64.141]:37212 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933029Ab0IXQfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:22 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:47 2010
Message-Id: <20100924163347.047537327@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:31:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Tso" <tytso@mit.edu>
Subject: [34/68] ext4: Fix remaining racy updates of EXT4_I(inode)->i_flags
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit 84a8dce2710cc425089a2b92acc354d4fbb5788d upstream.

A few functions were still modifying i_flags in a racy manner.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |   38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4815,20 +4815,26 @@ void ext4_set_inode_flags(struct inode *
 /* Propagate flags from i_flags to EXT4_I(inode)->i_flags */
 void ext4_get_inode_flags(struct ext4_inode_info *ei)
 {
-	unsigned int flags = ei->vfs_inode.i_flags;
+	unsigned int vfs_fl;
+	unsigned long old_fl, new_fl;
 
-	ei->i_flags &= ~(EXT4_SYNC_FL|EXT4_APPEND_FL|
-			EXT4_IMMUTABLE_FL|EXT4_NOATIME_FL|EXT4_DIRSYNC_FL);
-	if (flags & S_SYNC)
-		ei->i_flags |= EXT4_SYNC_FL;
-	if (flags & S_APPEND)
-		ei->i_flags |= EXT4_APPEND_FL;
-	if (flags & S_IMMUTABLE)
-		ei->i_flags |= EXT4_IMMUTABLE_FL;
-	if (flags & S_NOATIME)
-		ei->i_flags |= EXT4_NOATIME_FL;
-	if (flags & S_DIRSYNC)
-		ei->i_flags |= EXT4_DIRSYNC_FL;
+	do {
+		vfs_fl = ei->vfs_inode.i_flags;
+		old_fl = ei->i_flags;
+		new_fl = old_fl & ~(EXT4_SYNC_FL|EXT4_APPEND_FL|
+				EXT4_IMMUTABLE_FL|EXT4_NOATIME_FL|
+				EXT4_DIRSYNC_FL);
+		if (vfs_fl & S_SYNC)
+			new_fl |= EXT4_SYNC_FL;
+		if (vfs_fl & S_APPEND)
+			new_fl |= EXT4_APPEND_FL;
+		if (vfs_fl & S_IMMUTABLE)
+			new_fl |= EXT4_IMMUTABLE_FL;
+		if (vfs_fl & S_NOATIME)
+			new_fl |= EXT4_NOATIME_FL;
+		if (vfs_fl & S_DIRSYNC)
+			new_fl |= EXT4_DIRSYNC_FL;
+	} while (cmpxchg(&ei->i_flags, old_fl, new_fl) != old_fl);
 }
 
 static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
@@ -5067,7 +5073,7 @@ static int ext4_inode_blocks_set(handle_
 		 */
 		raw_inode->i_blocks_lo   = cpu_to_le32(i_blocks);
 		raw_inode->i_blocks_high = 0;
-		ei->i_flags &= ~EXT4_HUGE_FILE_FL;
+		ext4_clear_inode_flag(inode, EXT4_INODE_HUGE_FILE);
 		return 0;
 	}
 	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_HUGE_FILE))
@@ -5080,9 +5086,9 @@ static int ext4_inode_blocks_set(handle_
 		 */
 		raw_inode->i_blocks_lo   = cpu_to_le32(i_blocks);
 		raw_inode->i_blocks_high = cpu_to_le16(i_blocks >> 32);
-		ei->i_flags &= ~EXT4_HUGE_FILE_FL;
+		ext4_clear_inode_flag(inode, EXT4_INODE_HUGE_FILE);
 	} else {
-		ei->i_flags |= EXT4_HUGE_FILE_FL;
+		ext4_set_inode_flag(inode, EXT4_INODE_HUGE_FILE);
 		/* i_block is stored in file system block size */
 		i_blocks = i_blocks >> (inode->i_blkbits - 9);
 		raw_inode->i_blocks_lo   = cpu_to_le32(i_blocks);


