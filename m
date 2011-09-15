Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933959Ab1IOOsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 10:48:43 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44800
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932873Ab1IOOsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 10:48:40 -0400
Date: Thu, 15 Sep 2011 10:48:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] hfsplus: fix filesystem size checks
Message-ID: <20110915144840.GB19082@infradead.org>
References: <20110722152722.GA11946@infradead.org>
 <20110915144810.GA18876@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110915144810.GA18876@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@tuxera.com>

generic_check_addressable can't deal with hfsplus's larger than page size
allocation blocks, so simply opencode the checks that we actually need
in hfsplus_fill_super.

Signed-off-by: Christoph Hellwig <hch@tuxera.com>
Reported-by: Pavel Ivanov <paivanof@gmail.com>
Tested-by: Pavel Ivanov <paivanof@gmail.com>

Index: linux-2.6/fs/hfsplus/super.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/super.c	2011-09-15 10:26:10.059350285 -0400
+++ linux-2.6/fs/hfsplus/super.c	2011-09-15 10:26:24.960348414 -0400
@@ -344,6 +344,7 @@ static int hfsplus_fill_super(struct sup
 	struct inode *root, *inode;
 	struct qstr str;
 	struct nls_table *nls = NULL;
+	u64 last_fs_block, last_fs_page;
 	int err;
 
 	err = -EINVAL;
@@ -399,9 +400,13 @@ static int hfsplus_fill_super(struct sup
 	if (!sbi->rsrc_clump_blocks)
 		sbi->rsrc_clump_blocks = 1;
 
-	err = generic_check_addressable(sbi->alloc_blksz_shift,
-					sbi->total_blocks);
-	if (err) {
+	err = -EFBIG;
+	last_fs_block = sbi->total_blocks - 1;
+	last_fs_page = (last_fs_block << sbi->alloc_blksz_shift) >>
+			PAGE_CACHE_SHIFT;
+
+	if ((last_fs_block > (sector_t)(~0ULL) >> (sbi->alloc_blksz_shift - 9)) ||
+	    (last_fs_page > (pgoff_t)(~0ULL))) {
 		printk(KERN_ERR "hfs: filesystem size too large.\n");
 		goto out_free_vhdr;
 	}
