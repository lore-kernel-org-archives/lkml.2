Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab0HXXqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:46:23 -0400
Received: from kroah.org ([198.145.64.141]:52121 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756456Ab0HXWxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:53:47 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:25:24 2010
Message-Id: <20100824222524.145699375@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:24:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Axel Lin <axel.lin@gmail.com>, Lei Wen <leiwen@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [20/59] pxa3xx: fix ns2cycle equation
In-Reply-To: <20100824224625.GA5449@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit 93b352fce679945845664b56b0c3afbd655a7a12 upstream.

Test on a PXA310 platform with Samsung K9F2G08X0B NAND flash,
with tCH=5 and clk is 156MHz, ns2cycle(5, 156000000) returns -1.

ns2cycle returns negtive value will break NDTR0_tXX macros.

After checking the commit log, I found the problem is introduced by
commit 5b0d4d7c8a67c5ba3d35e6ceb0c5530cc6846db7
"[MTD] [NAND] pxa3xx: convert from ns to clock ticks more accurately"

To get num of clock cycles, we use below equation:
num of clock cycles = time (ns) / one clock cycle (ns) + 1
We need to add 1 cycle here because integer division will truncate the result.
It is possible the developers set the Min values in SPEC for timing settings.
Thus the truncate may cause problem, and it is safe to add an extra cycle here.

The various fields in NDTR{01} are in units of clock ticks minus one,
thus we should subtract 1 cycle then.

Thus the correct equation should be:
num of clock cycles = time (ns) / one clock cycle (ns) + 1 - 1
                    = time (ns) / one clock cycle (ns)

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Lei Wen <leiwen@marvell.com>
Acked-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/nand/pxa3xx_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -316,7 +316,7 @@ static struct pxa3xx_nand_flash *builtin
 #define tAR_NDTR1(r)	(((r) >> 0) & 0xf)
 
 /* convert nano-seconds to nand flash controller clock cycles */
-#define ns2cycle(ns, clk)	(int)(((ns) * (clk / 1000000) / 1000) - 1)
+#define ns2cycle(ns, clk)	(int)((ns) * (clk / 1000000) / 1000)
 
 /* convert nand flash controller clock cycles to nano-seconds */
 #define cycle2ns(c, clk)	((((c) + 1) * 1000000 + clk / 500) / (clk / 1000))


