Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0H3HHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 03:07:33 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:47991 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab0H3HHa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 03:07:30 -0400
Date: Mon, 30 Aug 2010 09:07:27 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jens Axboe <axboe@kernel.dk>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] block/m68k: z2ram - correct printing of sector_t
Message-ID: <alpine.DEB.2.00.1008300905290.28923@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_LBDAF=y, `sector_t' becomes `u64' instead of `unsigned long':

drivers/block/z2ram.c: In function ¡do_z2_request¢:
drivers/block/z2ram.c:83: warning: format ¡%lu¢ expects type ¡long unsigned int¢, but argument 2 has type ¡sector_t¢

Hence always cast it to `unsigned long long' for printing.
Also do the pr_err() dance, while we're at it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/block/z2ram.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index d75b2bb..2dbcaaa 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -79,8 +79,10 @@ static void do_z2_request(struct request_queue *q)
 		int err = 0;
 
 		if (start + len > z2ram_size) {
-			printk( KERN_ERR DEVICE_NAME ": bad access: block=%lu, count=%u\n",
-				blk_rq_pos(req), blk_rq_cur_sectors(req));
+			pr_err(DEVICE_NAME ": bad access: block=%llu, "
+			       "count=%u\n",
+			       (unsigned long long)blk_rq_pos(req),
+			       blk_rq_cur_sectors(req));
 			err = -EIO;
 			goto done;
 		}
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
