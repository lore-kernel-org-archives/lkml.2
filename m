Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab1DMP6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:58:08 -0400
Received: from kroah.org ([198.145.64.141]:54594 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932312Ab1DMP4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:56:02 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:50 2011
Message-Id: <20110413155149.987951824@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:51:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yongqiang Yang <xiaoqiangnk@gmail.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [65/74] ext4: fix credits computing for indirect mapped files
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

commit 5b41395fcc0265fc9f193aef9df39ce49d64677c upstream.

When writing a contiguous set of blocks, two indirect blocks could be
needed depending on how the blocks are aligned, so we need to increase
the number of credits needed by one.

[ Also fixed a another bug which could further underestimate the
  number of journal credits needed by 1; the code was using integer
  division instead of DIV_ROUND_UP() -- tytso]

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5458,13 +5458,12 @@ static int ext4_indirect_trans_blocks(st
 	/* if nrblocks are contiguous */
 	if (chunk) {
 		/*
-		 * With N contiguous data blocks, it need at most
-		 * N/EXT4_ADDR_PER_BLOCK(inode->i_sb) indirect blocks
-		 * 2 dindirect blocks
-		 * 1 tindirect block
+		 * With N contiguous data blocks, we need at most
+		 * N/EXT4_ADDR_PER_BLOCK(inode->i_sb) + 1 indirect blocks,
+		 * 2 dindirect blocks, and 1 tindirect block
 		 */
-		indirects = nrblocks / EXT4_ADDR_PER_BLOCK(inode->i_sb);
-		return indirects + 3;
+		return DIV_ROUND_UP(nrblocks,
+				    EXT4_ADDR_PER_BLOCK(inode->i_sb)) + 4;
 	}
 	/*
 	 * if nrblocks are not contiguous, worse case, each block touch


