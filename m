Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab2IMAVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:21:09 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50843 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab2ILXgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:36:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Kristian Nielsen <knielsen@knielsen-hq.org>, Jan Kara <jack@suse.cz>
Subject: [ 091/108] ext3: Fix fdatasync() for files with only i_size changes
Date: Wed, 12 Sep 2012 16:29:29 -0700
Message-Id: <20120912232500.036862745@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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

---
 fs/ext3/inode.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -3072,6 +3072,8 @@ static int ext3_do_update_inode(handle_t
 	struct ext3_inode_info *ei = EXT3_I(inode);
 	struct buffer_head *bh = iloc->bh;
 	int err = 0, rc, block;
+	int need_datasync = 0;
+	__le32 disksize;
 	uid_t i_uid;
 	gid_t i_gid;
 
@@ -3113,7 +3115,11 @@ again:
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
@@ -3129,8 +3135,11 @@ again:
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
@@ -3183,6 +3192,8 @@ again:
 	ext3_clear_inode_state(inode, EXT3_STATE_NEW);
 
 	atomic_set(&ei->i_sync_tid, handle->h_transaction->t_tid);
+	if (need_datasync)
+		atomic_set(&ei->i_datasync_tid, handle->h_transaction->t_tid);
 out_brelse:
 	brelse (bh);
 	ext3_std_error(inode->i_sb, err);


