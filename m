Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1JKMnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 08:43:46 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:45309 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424Ab1JKMnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 08:43:45 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 1/2 v2] pch_dma: Fix suspend issue
Date: Tue, 11 Oct 2011 21:43:21 +0900
Message-Id: <1318337002-10041-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/dma/pch_dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index ff5b38f..e72bfeb 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -59,7 +59,7 @@
 #define DMA_DESC_FOLLOW_WITHOUT_IRQ	0x2
 #define DMA_DESC_FOLLOW_WITH_IRQ	0x3
 
-#define MAX_CHAN_NR			8
+#define MAX_CHAN_NR			12
 
 static unsigned int init_nr_desc_per_channel = 64;
 module_param(init_nr_desc_per_channel, uint, 0644);
-- 
1.7.4.4

