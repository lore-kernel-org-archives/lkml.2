Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab1ILPbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 11:31:33 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53375
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757915Ab1ILPbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 11:31:32 -0400
Date: Mon, 12 Sep 2011 11:31:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Ivanov <paivanof@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Hin-Tak Leung <hintak_leung@yahoo.co.uk>,
        linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@tuxera.com>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
Message-ID: <20110912153129.GA10625@infradead.org>
References: <CAG1a4ruG8bL9j01RgSXuK2w9FV0izp8vdoQMLEZzc=qZfCNpzA@mail.gmail.com>
 <1315285921.46647.YahooMailClassic@web29519.mail.ird.yahoo.com>
 <CAG1a4rttHKgp=nAjQ=7zUu=bURq9x7DdhL2fTAZKimicpfdYsw@mail.gmail.com>
 <CAG1a4rt5wLihR-ZkUD78WRbHk39xWP0ypJzMe4K5G1O-k12-MQ@mail.gmail.com>
 <20110912143452.GA31539@infradead.org>
 <CAG1a4rsuYVehnSCM3KxeYQ+g94nrivG1vfss=y8275E4D24qTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG1a4rsuYVehnSCM3KxeYQ+g94nrivG1vfss=y8275E4D24qTg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, the shifts were the wrong way around.  I'll leave the 9 in for now,
we use it in so many places and if we're going to clean it up I'd do it
in ne go.

Index: linux-2.6/fs/hfsplus/super.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/super.c	2011-09-12 11:20:33.866598100 -0400
+++ linux-2.6/fs/hfsplus/super.c	2011-09-12 11:20:52.538098052 -0400
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
