Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2EMWQm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 18:16:42 -0400
Received: from fallback6.mail.ru ([94.100.176.134]:45512 "EHLO
	fallback6.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2EMWQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 18:16:37 -0400
X-Greylist: delayed 1031 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 May 2012 18:16:37 EDT
Date: Mon, 14 May 2012 01:59:26 +0400
From: Evgeniy Dushistov <dushistov@mail.ru>
To: "Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko" 
	<phcoder@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] update i_blocks on UFS
Message-ID: <20120513215925.GA1998@maclin>
Mail-Followup-To: Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko <phcoder@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <4FAFBCAE.1050401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FAFBCAE.1050401@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 03:52:46PM +0200, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> UFS code dosn't update i_blocks which leads to the problems ranging from wrong
> stat/du to long symlinks (as opposed to inline ones) being damaged. This is
> a fix.
> 

Yes, when quota support was removed, code that update statistic
about usage of blocks also was removed. But why so big change to fix this?
I found this problem some time ago and fixed it with code bellow,
but may be I missed something?

>From 3bba2473d2d09c0ebde5e287d694346ba0e4b4c0 Mon Sep 17 00:00:00 2001
From: Evgeniy Dushistov <dushistov@mail.ru>
Date: Fri, 18 Mar 2011 06:42:57 +0300
Subject: [PATCH] Looks like with quote support code was removed code
 that update statistic about usage blocks per inode.
 So fix this.

---
 fs/ufs/balloc.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index 100d2ee..e7bf2fd 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -83,7 +83,7 @@ void ufs_free_fragments(struct inode *inode, u64 fragment, unsigned count)
 			ufs_error (sb, "ufs_free_fragments",
 				   "bit already cleared for fragment %u", i);
 	}
-	
+	inode_sub_bytes(inode, count << uspi->s_fshift);
 	fs32_add(sb, &ucg->cg_cs.cs_nffree, count);
 	uspi->cs_total.cs_nffree += count;
 	fs32_add(sb, &UFS_SB(sb)->fs_cs(cgno).cs_nffree, count);
@@ -189,6 +189,7 @@ do_more:
 		ubh_setblock(UCPI_UBH(ucpi), ucpi->c_freeoff, blkno);
 		if ((UFS_SB(sb)->s_flags & UFS_CG_MASK) == UFS_CG_44BSD)
 			ufs_clusteracct (sb, ucpi, blkno, 1);
+		inode_sub_bytes(inode, uspi->s_bsize);
 
 		fs32_add(sb, &ucg->cg_cs.cs_nbfree, 1);
 		uspi->cs_total.cs_nbfree++;
@@ -547,7 +548,7 @@ static u64 ufs_add_fragments(struct inode *inode, u64 fragment,
 		fs32_add(sb, &ucg->cg_frsum[fragsize - count], 1);
 	for (i = oldcount; i < newcount; i++)
 		ubh_clrbit (UCPI_UBH(ucpi), ucpi->c_freeoff, fragno + i);
-
+	inode_add_bytes(inode, count << uspi->s_fshift);
 	fs32_sub(sb, &ucg->cg_cs.cs_nffree, count);
 	fs32_sub(sb, &UFS_SB(sb)->fs_cs(cgno).cs_nffree, count);
 	uspi->cs_total.cs_nffree -= count;
@@ -649,6 +650,7 @@ cg_found:
 		for (i = count; i < uspi->s_fpb; i++)
 			ubh_setbit (UCPI_UBH(ucpi), ucpi->c_freeoff, goal + i);
 		i = uspi->s_fpb - count;
+		inode_sub_bytes(inode, i << uspi->s_fshift);
 
 		fs32_add(sb, &ucg->cg_cs.cs_nffree, i);
 		uspi->cs_total.cs_nffree += i;
@@ -660,6 +662,7 @@ cg_found:
 	result = ufs_bitmap_search (sb, ucpi, goal, allocsize);
 	if (result == INVBLOCK)
 		return 0;
+	inode_add_bytes(inode, count << uspi->s_fshift);
 	for (i = 0; i < count; i++)
 		ubh_clrbit (UCPI_UBH(ucpi), ucpi->c_freeoff, result + i);
 	
@@ -725,7 +728,7 @@ gotit:
 	ubh_clrblock (UCPI_UBH(ucpi), ucpi->c_freeoff, blkno);
 	if ((UFS_SB(sb)->s_flags & UFS_CG_MASK) == UFS_CG_44BSD)
 		ufs_clusteracct (sb, ucpi, blkno, -1);
-
+	inode_add_bytes(inode, uspi->s_bsize);
 	fs32_sub(sb, &ucg->cg_cs.cs_nbfree, 1);
 	uspi->cs_total.cs_nbfree--;
 	fs32_sub(sb, &UFS_SB(sb)->fs_cs(ucpi->c_cgx).cs_nbfree, 1);
-- 
1.7.3.4

-- 
/Evgeniy

