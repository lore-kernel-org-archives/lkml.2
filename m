Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab1DZVcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:32:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:21115 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198Ab1DZVOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483539"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: xiaoqiangnk@gmail.com, tytso@mit.edu, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [45/106] ext4: fix credits computing for indirect mapped files
Message-Id: <20110426211325.1C6863E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ext4/inode.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

Index: linux-2.6.35.y/fs/ext4/inode.c
===================================================================
--- linux-2.6.35.y.orig/fs/ext4/inode.c
+++ linux-2.6.35.y/fs/ext4/inode.c
@@ -5593,13 +5593,12 @@ static int ext4_indirect_trans_blocks(st
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
