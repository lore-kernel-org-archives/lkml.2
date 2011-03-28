Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1C1I3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 04:29:05 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:50449 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab1C1I3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 04:29:03 -0400
X-ASG-Debug-ID: 1301300941-03d6a569fb03110001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D9046C9.8080606@fusionio.com>
Date: Mon, 28 Mar 2011 10:28:57 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [GIT PULL] drbd build fix
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] drbd build fix
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301300941
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59197
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

With the removal of the horribly named generic_* bitops functions, the
merge with master broke drbd. Please pull this fix from Stephen,
modified slightly by me to also kill the now redundant
asm-generic/bitops/le.h header file include as well.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Stephen Rothwell (1):
      drbd: update for bitop api changes

 drivers/block/drbd/drbd_bitmap.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index f0ae63d..76210ba 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -29,8 +29,6 @@
 #include <linux/slab.h>
 #include <asm/kmap_types.h>
 
-#include <asm-generic/bitops/le.h>
-
 #include "drbd_int.h"
 
 
@@ -1184,10 +1182,10 @@ static unsigned long __bm_find_next(struct drbd_conf *mdev, unsigned long bm_fo,
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
@@ -1287,9 +1285,9 @@ static int __bm_change_bits_to(struct drbd_conf *mdev, const unsigned long s,
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
@@ -1438,7 +1436,7 @@ int drbd_bm_test_bit(struct drbd_conf *mdev, const unsigned long bitnr)
 		bm_print_lock_info(mdev);
 	if (bitnr < b->bm_bits) {
 		p_addr = bm_map_pidx(b, bm_bit_to_page_idx(b, bitnr));
-		i = generic_test_le_bit(bitnr & BITS_PER_PAGE_MASK, p_addr) ? 1 : 0;
+		i = test_bit_le(bitnr & BITS_PER_PAGE_MASK, p_addr) ? 1 : 0;
 		bm_unmap(p_addr);
 	} else if (bitnr == b->bm_bits) {
 		i = -1;
@@ -1482,7 +1480,7 @@ int drbd_bm_count_bits(struct drbd_conf *mdev, const unsigned long s, const unsi
 		ERR_IF (bitnr >= b->bm_bits) {
 			dev_err(DEV, "bitnr=%lu bm_bits=%lu\n", bitnr, b->bm_bits);
 		} else {
-			c += (0 != generic_test_le_bit(bitnr - (page_nr << (PAGE_SHIFT+3)), p_addr));
+			c += (0 != test_bit_le(bitnr - (page_nr << (PAGE_SHIFT+3)), p_addr));
 		}
 	}
 	if (p_addr)

-- 
Jens Axboe

