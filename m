Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964895Ab2DSVOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:14:17 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36240 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964880Ab2DSVON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:14:13 -0400
Message-Id: <20120419210615.491498065@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:07:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [ 51/59] pch_dma: Fix suspend issue
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>

commit c43f1508686e8e4746012bf87995085eeb0f5307 upstream.

Currently, executing suspend/hibernation,
memory access violation occurs.

In pch_dma_save_regs() called by suspend(),
you can see the following code.

static void pch_dma_save_regs(struct pch_dma *pd)
{
snip...
        list_for_each_entry_safe(chan, _c, &pd->dma.channels, device_node) {
                pd_chan = to_pd_chan(chan);

                pd->ch_regs[i].dev_addr = channel_readl(pd_chan, DEV_ADDR);
                pd->ch_regs[i].mem_addr = channel_readl(pd_chan, MEM_ADDR);
                pd->ch_regs[i].size = channel_readl(pd_chan, SIZE);
                pd->ch_regs[i].next = channel_readl(pd_chan, NEXT);

                i++;
        }
}

Max loop count is 12 defined at pci_table.
So, this caused memory access violation.

This patch fixes the issue
 - Modify array size (MAX_CHAN_NR)

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/pch_dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -60,7 +60,7 @@
 #define DMA_DESC_FOLLOW_WITHOUT_IRQ	0x2
 #define DMA_DESC_FOLLOW_WITH_IRQ	0x3
 
-#define MAX_CHAN_NR			8
+#define MAX_CHAN_NR			12
 
 #define DMA_MASK_CTL0_MODE	0x33333333
 #define DMA_MASK_CTL2_MODE	0x00003333


