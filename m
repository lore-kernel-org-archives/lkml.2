Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab1ITRoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:44:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:44458 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab1ITRoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:44:20 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, balbi@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] x86/dma: make a zero length mapping length not dma capable
Date: Tue, 20 Sep 2011 19:44:25 +0200
Message-Id: <1316540665-15622-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.6.3
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following ooops happens during a call to dma_map_single():

| ------------[ cut here ]------------
| kernel BUG at lib/swiotlb.c:409!
| invalid opcode: 0000 [#1] SMP
| CPU 1
|
| RIP: 0010:[<ffffffff811a00c9>]  [<ffffffff811a00c9>] swiotlb_tbl_map_single+0x87/0x1e0
| Call Trace:
|  [<ffffffff813170e0>] ? printk+0x43/0x48
|  [<ffffffff8100d027>] ? load_TLS+0x7/0xa
|  [<ffffffff811a0261>] ? map_single+0x3f/0x3f
|  [<ffffffff811a02be>] ? swiotlb_map_page+0x5d/0xcd
|  [<ffffffff811a0261>] ? map_single+0x3f/0x3f
|  [<ffffffffa02946ca>] ? dwc3_map_buffer_to_dma+0x8a/0xe2 [dwc3]

As you know from the line 409 the size parameter was 0. This happens
because the upper layer sends a zero length packet which the dwc3 driver
tried to map.
The memory is not really used and the hardware should not really issue a
dma request however we must setup a dma descriptor which contains an
address field and a size field which is set to 0 for the zero length
packet to be sent. So the unconditional mapping was kinda convenient to
do. ARM does not complain about length == 0, the swiotlb which is
used on x86 makes trouble. Looking at other udc drivers, they either
ignore this case or workaround it by incrementing the size by 1 which
looks nasty.
For now I fixed this by not mapping zero packets at all. Anything what I
should expect from the DMA API? I.e. should it be okay to call
dma_map_single() with size = 0?
This patch is untested due to -ENODEV. Changing each implementation of
dma_map_single() will result in large patch and it is also question if
this is worth the effort.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/include/asm/dma-mapping.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index d4c419f..e73d921 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -65,6 +65,8 @@ static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
 {
 	if (!dev->dma_mask)
 		return 0;
+	if (!size)
+		return 0;
 
 	return addr + size - 1 <= *dev->dma_mask;
 }
-- 
1.7.6.3

