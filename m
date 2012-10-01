Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290Ab2JAXDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:03:24 -0400
Received: from 1wt.eu ([62.212.114.60]:35651 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757723Ab2JAXDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:03:17 -0400
Message-Id: <20121001225203.419132056@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:14 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 137/180] ext3: Fix fdatasync() for files with only i_size changes
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 156bddd8e505b295540f3ca0e27dda68cb0d49aa upstream.

Code tracking when transaction needs to be committed on fdatasync(2) forgets
to handle a situation when only inode's i_size is changed. Thus in such
situations fdatasync(2) doesn't force transaction with new i_size to disk
and that can result in wrong i_size after a crash.

Fix the issue by updating inode's i_datasync_tid whenever its size is
updated.

Reported-by: Kristian Nielsen <knielsen@knielsen-hq.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/ext3/inode.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index f9d6937..3191a30 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2948,6 +2948,8 @@ static int ext3_do_update_inode(handle_t *handle,
 	struct ext3_inode_info *ei = EXT3_I(inode);
 	struct buffer_head *bh = iloc->bh;
 	int err = 0, rc, block;
+	int need_datasync = 0;
+	__le32 disksize;
 
 again:
 	/* we can't allow multiple procs in here at once, its a bit racey */
@@ -2985,7 +2987,11 @@ again:
 		raw_inode->i_gid_high = 0;
 	}
 	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
-	raw_inode->i_size = cpu_to_le32(ei->i_disksize);
+	disksize = cpu_to_le32(ei->i_disksize);
+	if (disksize != raw_inode->i_size) {
+		need_datasync = 1;
+		raw_inode->i_size = disksize;
+	}
 	raw_inode->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
 	raw_inode->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
 	raw_inode->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
@@ -3001,8 +3007,11 @@ again:
 	if (!S_ISREG(inode->i_mode)) {
 		raw_inode->i_dir_acl = cpu_to_le32(ei->i_dir_acl);
 	} else {
-		raw_inode->i_size_high =
-			cpu_to_le32(ei->i_disksize >> 32);
+		disksize = cpu_to_le32(ei->i_disksize >> 32);
+		if (disksize != raw_inode->i_size_high) {
+			raw_inode->i_size_high = disksize;
+			need_datasync = 1;
+		}
 		if (ei->i_disksize > 0x7fffffffULL) {
 			struct super_block *sb = inode->i_sb;
 			if (!EXT3_HAS_RO_COMPAT_FEATURE(sb,
@@ -3055,6 +3064,8 @@ again:
 	ei->i_state &= ~EXT3_STATE_NEW;
 
 	atomic_set(&ei->i_sync_tid, handle->h_transaction->t_tid);
+	if (need_datasync)
+		atomic_set(&ei->i_datasync_tid, handle->h_transaction->t_tid);
 out_brelse:
 	brelse (bh);
 	ext3_std_error(inode->i_sb, err);
-- 
1.7.2.1.45.g54fbc



