Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab2JNO6y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:58:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46523 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932200Ab2JNOn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:26 -0400
Message-Id: <20121014143543.032989051@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>, Kristian Nielsen <knielsen@knielsen-hq.org>
Subject: [ 068/147] ext4: fix fdatasync() for files with only i_size changes
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit b71fc079b5d8f42b2a52743c8d2f1d35d655b1c5 upstream.

Code tracking when transaction needs to be committed on fdatasync(2) forgets
to handle a situation when only inode's i_size is changed. Thus in such
situations fdatasync(2) doesn't force transaction with new i_size to disk
and that can result in wrong i_size after a crash.

Fix the issue by updating inode's i_datasync_tid whenever its size is
updated.

Reported-by: Kristian Nielsen <knielsen@knielsen-hq.org>
Signed-off-by: Jan Kara <jack@suse.cz>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/inode.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4007,6 +4007,7 @@ static int ext4_do_update_inode(handle_t
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct buffer_head *bh = iloc->bh;
 	int err = 0, rc, block;
+	int need_datasync = 0;
 
 	/* For fields not not tracking in the in-memory inode,
 	 * initialise them to zero for new inodes. */
@@ -4055,7 +4056,10 @@ static int ext4_do_update_inode(handle_t
 		raw_inode->i_file_acl_high =
 			cpu_to_le16(ei->i_file_acl >> 32);
 	raw_inode->i_file_acl_lo = cpu_to_le32(ei->i_file_acl);
-	ext4_isize_set(raw_inode, ei->i_disksize);
+	if (ei->i_disksize != ext4_isize(raw_inode)) {
+		ext4_isize_set(raw_inode, ei->i_disksize);
+		need_datasync = 1;
+	}
 	if (ei->i_disksize > 0x7fffffffULL) {
 		struct super_block *sb = inode->i_sb;
 		if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
@@ -4108,7 +4112,7 @@ static int ext4_do_update_inode(handle_t
 		err = rc;
 	ext4_clear_inode_state(inode, EXT4_STATE_NEW);
 
-	ext4_update_inode_fsync_trans(handle, inode, 0);
+	ext4_update_inode_fsync_trans(handle, inode, need_datasync);
 out_brelse:
 	brelse(bh);
 	ext4_std_error(inode->i_sb, err);


