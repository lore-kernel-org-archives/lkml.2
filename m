Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934474Ab1CYDbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 23:31:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34988 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934427Ab1CYDbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 23:31:03 -0400
Date: Fri, 25 Mar 2011 14:30:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20110325143049.2e65091f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

After merging the block tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/block/drbd/drbd_bitmap.c: In function '__bm_find_next':
drivers/block/drbd/drbd_bitmap.c:1187: error: implicit declaration of function 'generic_find_next_zero_le_bit'
drivers/block/drbd/drbd_bitmap.c:1190: error: implicit declaration of function 'generic_find_next_le_bit'
drivers/block/drbd/drbd_bitmap.c: In function '__bm_change_bits_to':
drivers/block/drbd/drbd_bitmap.c:1290: error: implicit declaration of function 'generic___test_and_set_le_bit'
drivers/block/drbd/drbd_bitmap.c:1292: error: implicit declaration of function 'generic___test_and_clear_le_bit'
drivers/block/drbd/drbd_bitmap.c: In function 'drbd_bm_test_bit':
drivers/block/drbd/drbd_bitmap.c:1441: error: implicit declaration of function 'generic_test_le_bit'

Caused by commit 95a0f10cddbf ("drbd: store in-core bitmap little endian,
regardless of architecture") interacting with commit c4945b9ed472
("asm-generic: rename generic little-endian bitops functions") from
Linus' tree.

I applied the following merge fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 25 Mar 2011 14:27:57 +1100
Subject: [PATCH] drbd: update for bitop api changes

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/block/drbd/drbd_bitmap.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index f0ae63d..eb925fa 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -1184,10 +1184,10 @@ static unsigned long __bm_find_next(struct drbd_conf *mdev, unsigned long bm_fo,
 			p_addr = __bm_map_pidx(b, bm_bit_to_page_idx(b, bm_fo), km);
 
 			if (find_zero_bit)
-				i = generic_find_next_zero_le_bit(p_addr,
+				i = find_next_zero_bit_le(p_addr,
 						PAGE_SIZE*8, bm_fo & BITS_PER_PAGE_MASK);
 			else
-				i = generic_find_next_le_bit(p_addr,
+				i = find_next_bit_le(p_addr,
 						PAGE_SIZE*8, bm_fo & BITS_PER_PAGE_MASK);
 
 			__bm_unmap(p_addr, km);
@@ -1287,9 +1287,9 @@ static int __bm_change_bits_to(struct drbd_conf *mdev, const unsigned long s,
 			last_page_nr = page_nr;
 		}
 		if (val)
-			c += (0 == generic___test_and_set_le_bit(bitnr & BITS_PER_PAGE_MASK, p_addr));
+			c += (0 == __test_and_set_bit_le(bitnr & BITS_PER_PAGE_MASK, p_addr));
 		else
-			c -= (0 != generic___test_and_clear_le_bit(bitnr & BITS_PER_PAGE_MASK, p_addr));
+			c -= (0 != __test_and_clear_bit_le(bitnr & BITS_PER_PAGE_MASK, p_addr));
 	}
 	if (p_addr)
 		__bm_unmap(p_addr, km);
@@ -1438,7 +1438,7 @@ int drbd_bm_test_bit(struct drbd_conf *mdev, const unsigned long bitnr)
 		bm_print_lock_info(mdev);
 	if (bitnr < b->bm_bits) {
 		p_addr = bm_map_pidx(b, bm_bit_to_page_idx(b, bitnr));
-		i = generic_test_le_bit(bitnr & BITS_PER_PAGE_MASK, p_addr) ? 1 : 0;
+		i = test_bit_le(bitnr & BITS_PER_PAGE_MASK, p_addr) ? 1 : 0;
 		bm_unmap(p_addr);
 	} else if (bitnr == b->bm_bits) {
 		i = -1;
@@ -1482,7 +1482,7 @@ int drbd_bm_count_bits(struct drbd_conf *mdev, const unsigned long s, const unsi
 		ERR_IF (bitnr >= b->bm_bits) {
 			dev_err(DEV, "bitnr=%lu bm_bits=%lu\n", bitnr, b->bm_bits);
 		} else {
-			c += (0 != generic_test_le_bit(bitnr - (page_nr << (PAGE_SHIFT+3)), p_addr));
+			c += (0 != test_bit_le(bitnr - (page_nr << (PAGE_SHIFT+3)), p_addr));
 		}
 	}
 	if (p_addr)
-- 
1.7.4.1


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
