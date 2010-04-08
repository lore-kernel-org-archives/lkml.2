Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299Ab0DHBmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 21:42:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55095 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab0DHBmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 21:42:38 -0400
Date: Thu, 8 Apr 2010 11:42:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: build failure after merge of the mtd tree
Message-Id: <20100408114235.845264d0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

After merging the mtd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/mtd/sm_ftl.c: In function 'sm_cache_flush':
drivers/mtd/sm_ftl.c:937: error: implicit declaration of function 'for_each_bit'
drivers/mtd/sm_ftl.c:938: error: expected ';' before '{' token
drivers/mtd/sm_ftl.c:964: error: label 'restart' used but not defined

OK, not a suprise since Andrew submitted the "remove for_each_bit" patch
and you haven't applied the patch below to the mtd tree.  Commit
7d17c02a01a111f40986859f044c8c4cce8a4aa6 ("mtd: Add new SmartMedia/xD
FTL") introduces a new use of "for_each_bit".  I have applied the below
patch for today, please add it to the mtd tree ASAP.

Subject: [patch 1/1] bitops: rename for_each_bit() to for_each_set_bit(): mtd
To: dwmw2@infradead.org
Cc: akpm@linux-foundation.org, akinobu.mita@gmail.com, adobriyan@gmail.com,
        davem@davemloft.net, dedekind@infradead.org, rmk@arm.linux.org.uk,
        sfr@canb.auug.org.au
From: akpm@linux-foundation.org
Date: Mon, 05 Apr 2010 13:53:35 -0700

From: Akinobu Mita <akinobu.mita@gmail.com>

Rename for_each_bit() to for_each_set_bit in the kernel source tree.  To
permit for_each_clear_bit(), should that ever be added.

I'll be sending a patch to Linus this week which removes the temporary
for_each_bit() macro, so this patch will be needed to avoid build
breakage.

Suggested-by: Alexey Dobriyan <adobriyan@gmail.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/sm_ftl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/sm_ftl.c~bitops-rename-for_each_bit-to-for_each_set_bit-mtd drivers/mtd/sm_ftl.c
--- a/drivers/mtd/sm_ftl.c~bitops-rename-for_each_bit-to-for_each_set_bit-mtd
+++ a/drivers/mtd/sm_ftl.c
@@ -934,7 +934,7 @@ int sm_cache_flush(struct sm_ftl *ftl)
 
 
 	/* Try to read all unread areas of the cache block*/
-	for_each_bit(sector_num, &ftl->cache_data_invalid_bitmap,
+	for_each_set_bit(sector_num, &ftl->cache_data_invalid_bitmap,
 		ftl->block_size / SM_SECTOR_SIZE) {
 
 		if (!sm_read_sector(ftl,
_

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
