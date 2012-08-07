Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030343Ab2HGWcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:32:19 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57899 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030310Ab2HGWcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:32:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tao Ma <boyu.mt@taobao.com>, "Theodore Tso" <tytso@mit.edu>,
        "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [ 099/122] ext4: use s_csum_seed instead of i_csum_seed for xattr block
Date: Tue,  7 Aug 2012 15:26:27 -0700
Message-Id: <20120807221958.408099265@linuxfoundation.org>
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

commit 41eb70dde42b2360074a559a6f1fc49860a50179 upstream.

In xattr block operation, we use h_refcount to indicate whether the
xattr block is shared among many inodes. And xattr block csum uses
s_csum_seed if it is shared and i_csum_seed if it belongs to
one inode. But this has a problem. So consider the block is shared
first bewteen inode A and B, and B has some xattr update and CoW
the xattr block. When it updates the *old* xattr block(because
of the h_refcount change) and calls ext4_xattr_release_block, we
has no idea that inode A is the real owner of the *old* xattr
block and we can't use the i_csum_seed of inode A either in xattr
block csum calculation. And I don't think we have an easy way to
find inode A.

So this patch just removes the tricky i_csum_seed and we now uses
s_csum_seed every time for the xattr block csum. The corresponding
patch for the e2fsprogs will be sent in another patch.

This is spotted by xfstests 117.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/xattr.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -127,19 +127,16 @@ static __le32 ext4_xattr_block_csum(stru
 				    struct ext4_xattr_header *hdr)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	struct ext4_inode_info *ei = EXT4_I(inode);
 	__u32 csum, old;
 
 	old = hdr->h_checksum;
 	hdr->h_checksum = 0;
-	if (le32_to_cpu(hdr->h_refcount) != 1) {
-		block_nr = cpu_to_le64(block_nr);
-		csum = ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)&block_nr,
-				   sizeof(block_nr));
-	} else
-		csum = ei->i_csum_seed;
+	block_nr = cpu_to_le64(block_nr);
+	csum = ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)&block_nr,
+			   sizeof(block_nr));
 	csum = ext4_chksum(sbi, csum, (__u8 *)hdr,
 			   EXT4_BLOCK_SIZE(inode->i_sb));
+
 	hdr->h_checksum = old;
 	return cpu_to_le32(csum);
 }


