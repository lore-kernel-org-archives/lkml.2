Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab0EJXPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:15:19 -0400
Received: from kroah.org ([198.145.64.141]:51876 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932894Ab0EJW6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:14 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:39 2010
Message-Id: <20100510223539.801042695@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Leonard Michlmayr <leonard.michlmayr@gmail.com>,
       "Theodore Tso" <tytso@mit.edu>
Subject: [60/98] ext4: correctly calculate number of blocks for fiemap
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Leonard Michlmayr <leonard.michlmayr@gmail.com>

commit aca92ff6f57c000d1b4523e383c8bd6b8269b8b1 upstream.

ext4_fiemap() rounds the length of the requested range down to
blocksize, which is is not the true number of blocks that cover the
requested region.  This problem is especially impressive if the user
requests only the first byte of a file: not a single extent will be
reported.

We fix this by calculating the last block of the region and then
subtract to find the number of blocks in the extents.

Signed-off-by: Leonard Michlmayr <leonard.michlmayr@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/extents.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3711,7 +3711,6 @@ int ext4_fiemap(struct inode *inode, str
 		__u64 start, __u64 len)
 {
 	ext4_lblk_t start_blk;
-	ext4_lblk_t len_blks;
 	int error = 0;
 
 	/* fallback to generic here if not in extents fmt */
@@ -3725,8 +3724,14 @@ int ext4_fiemap(struct inode *inode, str
 	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR) {
 		error = ext4_xattr_fiemap(inode, fieinfo);
 	} else {
+		ext4_lblk_t len_blks;
+		__u64 last_blk;
+
 		start_blk = start >> inode->i_sb->s_blocksize_bits;
-		len_blks = len >> inode->i_sb->s_blocksize_bits;
+		last_blk = (start + len - 1) >> inode->i_sb->s_blocksize_bits;
+		if (last_blk >= EXT_MAX_BLOCK)
+			last_blk = EXT_MAX_BLOCK-1;
+		len_blks = ((ext4_lblk_t) last_blk) - start_blk + 1;
 
 		/*
 		 * Walk the extent tree gathering extent information.


