Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab2JJXKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:10:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46244 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932579Ab2JJXCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:02:52 -0400
X-Sasl-enc: SYIntmglC+8sOyy8JKG9Yb/8iu6/skFzrFg3XHx6GsfS 1349910171
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Kristian Nielsen <knielsen@knielsen-hq.org>, Jan Kara <jack@suse.cz>
Subject: [ 054/122] ext4: fix fdatasync() for files with only i_size changes
Date: Thu, 11 Oct 2012 07:53:40 +0900
Message-Id: <20121010225347.822641446@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4055,6 +4055,7 @@ static int ext4_do_update_inode(handle_t
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct buffer_head *bh = iloc->bh;
 	int err = 0, rc, block;
+	int need_datasync = 0;
 	uid_t i_uid;
 	gid_t i_gid;
 
@@ -4105,7 +4106,10 @@ static int ext4_do_update_inode(handle_t
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
@@ -4158,7 +4162,7 @@ static int ext4_do_update_inode(handle_t
 		err = rc;
 	ext4_clear_inode_state(inode, EXT4_STATE_NEW);
 
-	ext4_update_inode_fsync_trans(handle, inode, 0);
+	ext4_update_inode_fsync_trans(handle, inode, need_datasync);
 out_brelse:
 	brelse(bh);
 	ext4_std_error(inode->i_sb, err);


