Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab1DYUf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:35:56 -0400
Received: from 1wt.eu ([62.212.114.60]:34530 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932363Ab1DYUZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:17 -0400
Message-Id: <20110425200239.596593378@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:04 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, "Theodore Tso" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 152/173] ext4: fix credits computing for indirect mapped files
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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


