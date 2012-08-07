Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab2HGXYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:24:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030247Ab2HGWcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:32:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tao Ma <boyu.mt@taobao.com>, "Theodore Tso" <tytso@mit.edu>,
        "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [ 098/122] ext4: use proper csum calculation in ext4_rename
Date: Tue,  7 Aug 2012 15:26:26 -0700
Message-Id: <20120807221958.306955276@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Ma <boyu.mt@taobao.com>

commit ef58f69c3c34f6377f1e21d3533c806dbd980ad0 upstream.

In ext4_rename, when the old name is a dir, we need to
change ".." to its new parent and journal the change, so
with metadata_csum enabled, we have to re-calc the csum.

As the first block of the dir can be either a htree root
or a normal directory block and we have different csum
calculation for these 2 types, we have to choose the right
one in ext4_rename.

btw, it is found by xfstests 013.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/namei.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2918,8 +2918,15 @@ static int ext4_rename(struct inode *old
 		PARENT_INO(dir_bh->b_data, new_dir->i_sb->s_blocksize) =
 						cpu_to_le32(new_dir->i_ino);
 		BUFFER_TRACE(dir_bh, "call ext4_handle_dirty_metadata");
-		retval = ext4_handle_dirty_dirent_node(handle, old_inode,
-						       dir_bh);
+		if (is_dx(old_inode)) {
+			retval = ext4_handle_dirty_dx_node(handle,
+							   old_inode,
+							   dir_bh);
+		} else {
+			retval = ext4_handle_dirty_dirent_node(handle,
+							       old_inode,
+							       dir_bh);
+		}
 		if (retval) {
 			ext4_std_error(old_dir->i_sb, retval);
 			goto end_rename;


