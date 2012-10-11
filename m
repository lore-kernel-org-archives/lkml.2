Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810Ab2JKCOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:14:16 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42586 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933030Ab2JKCOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:14:10 -0400
X-Sasl-enc: KqoyLDgmyTT+wsrF+OLMQWLnMLplPp/Tuzuq4KSyoxjM 1349921648
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Kristian Nielsen <knielsen@knielsen-hq.org>, Jan Kara <jack@suse.cz>
Subject: [ 49/84] ext4: fix fdatasync() for files with only i_size changes
Date: Thu, 11 Oct 2012 11:03:33 +0900
Message-Id: <20121011015425.873653248@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5151,6 +5151,7 @@ static int ext4_do_update_inode(handle_t
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct buffer_head *bh = iloc->bh;
 	int err = 0, rc, block;
+	int need_datasync = 0;
 
 	/* For fields not not tracking in the in-memory inode,
 	 * initialise them to zero for new inodes. */
@@ -5199,7 +5200,10 @@ static int ext4_do_update_inode(handle_t
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
@@ -5252,7 +5256,7 @@ static int ext4_do_update_inode(handle_t
 		err = rc;
 	ext4_clear_inode_state(inode, EXT4_STATE_NEW);
 
-	ext4_update_inode_fsync_trans(handle, inode, 0);
+	ext4_update_inode_fsync_trans(handle, inode, need_datasync);
 out_brelse:
 	brelse(bh);
 	ext4_std_error(inode->i_sb, err);


