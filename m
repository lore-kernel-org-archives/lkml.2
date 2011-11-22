Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab1KVTqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:46:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36389 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab1KVTp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:45:59 -0500
From: Mika Westerberg <mika.westerberg@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, dan.j.williams@intel.com,
        hsweeten@visionengravers.com, rmallon@gmail.com,
        Rafal Prylowski <prylowski@metasoft.pl>,
        Mika Westerberg <mika.westerberg@iki.fi>
Subject: [PATCH 2/2] dma/ep93xx_dma: prevent ep93xx_dma_tasklet() to access empty list
Date: Tue, 22 Nov 2011 21:45:36 +0200
Message-Id: <707c0a5c61bd597ceed3871fc3528f687ac0fcff.1321990466.git.mika.westerberg@iki.fi>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <19bcd0ee953116fd71bc1c705636c5fec80608cb.1321990466.git.mika.westerberg@iki.fi>
References: <19bcd0ee953116fd71bc1c705636c5fec80608cb.1321990466.git.mika.westerberg@iki.fi>
In-Reply-To: <19bcd0ee953116fd71bc1c705636c5fec80608cb.1321990466.git.mika.westerberg@iki.fi>
References: <19bcd0ee953116fd71bc1c705636c5fec80608cb.1321990466.git.mika.westerberg@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafal Prylowski <prylowski@metasoft.pl>

If dma_terminate_all() is called before the ep93xx_dma_tasklet() gets to run,
it tries to access an empty ->active list causing following OOPS:

  Internal error: Oops - undefined instruction: 0 [#1]
  CPU: 0    Not tainted  (3.2.0-rc1EP-1+ #1008)
  PC is at 0xc184c868
  LR is at ep93xx_dma_tasklet+0xec/0x164
  pc : [<c184c868>]    lr : [<c012b528>]    psr: 00000013
  sp : c02b7e70  ip : ffffffff  fp : c02b7ea4
  r10: 00000100  r9 : 80000013  r8 : c02b7e50
  r7 : c02b7e70  r6 : c02b7ea4  r5 : 000000a4  r4 : c02b7e70
  r3 : c02b751d  r2 : 8ae34598  r1 : c184c6e0  r0 : c02b7ea4
  Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
  Control: c000717f  Table: c0004000  DAC: 00000017
  Process swapper (pid: 0, stack limit = 0xc02b6270)
  Stack: (0xc02b7e70 to 0xc02b8000)
  7e60:                                     c02b7ea4 c02b7e70 c0008b64 c02bd5c4
  7e80: c02d60e0 00000000 00000000 c02bd44c c02d60e0 00000100 c02b7ec4 c02b7ea8
  7ea0: c001c49c c012b44c 00000018 00000001 c02d60e0 c02b6000 c02b7f04 c02b7ec8
  7ec0: c001cbc0 c001c3e4 c02b7eec c02b7ed8 00000006 0000000a c02bf674 c02c458c
  7ee0: 00000011 00000000 c02b7f7c c0004000 41129200 c02b0c80 c02b7f14 c02b7f08
  7f00: c001cdd0 c001cb38 c02b7f34 c02b7f18 c000983c c001cd98 c0009a60 60000013
  7f20: fefb0001 c02b7f7c c02b7f44 c02b7f38 c0008190 c0009810 c02b7f9c c02b7f48
  7f40: c0008b64 c0008190 c02c2bf8 00000002 c02b7f90 60000013 c02b6000 c02d1504
  7f60: c02baa88 c02baa80 c0004000 41129200 c02b0c80 c02b7f9c c02b7fa0 c02b7f90
  7f80: c0009a54 c0009a60 60000013 ffffffff c02b7fbc c02b7fa0 c000a03c c0009a40
  7fa0: c02b80b0 c02b19dc c02b19d8 c02baa80 c02b7fcc c02b7fc0 c02384e4 c0009fd4
  7fc0: c02b7ff4 c02b7fd0 c029d924 c0238494 c029d49c 00000000 00000000 c02b19dc
  7fe0: c0007175 c02b803c 00000000 c02b7ff8 c000803c c029d700 00000000 00000000
  Backtrace:
  [<c012b43c>] (ep93xx_dma_tasklet+0x0/0x164) from [<c001c49c>] (tasklet_action+0xc8/0xdc)
  [<c001c3d4>] (tasklet_action+0x0/0xdc) from [<c001cbc0>] (__do_softirq+0x98/0x154)
   r7:c02b6000 r6:c02d60e0 r5:00000001 r4:00000018
  [<c001cb28>] (__do_softirq+0x0/0x154) from [<c001cdd0>] (irq_exit+0x48/0x50)
  [<c001cd88>] (irq_exit+0x0/0x50) from [<c000983c>] (handle_IRQ+0x3c/0x8c)
  [<c0009800>] (handle_IRQ+0x0/0x8c) from [<c0008190>] (asm_do_IRQ+0x10/0x14)
   r7:c02b7f7c r6:fefb0001 r5:60000013 r4:c0009a60
  [<c0008180>] (asm_do_IRQ+0x0/0x14) from [<c0008b64>] (__irq_svc+0x24/0xc0)
  Exception stack(0xc02b7f48 to 0xc02b7f90)
  7f40:                   c02c2bf8 00000002 c02b7f90 60000013 c02b6000 c02d1504
  7f60: c02baa88 c02baa80 c0004000 41129200 c02b0c80 c02b7f9c c02b7fa0 c02b7f90
  7f80: c0009a54 c0009a60 60000013 ffffffff
  [<c0009a30>] (default_idle+0x0/0x34) from [<c000a03c>] (cpu_idle+0x78/0xb0)
  [<c0009fc4>] (cpu_idle+0x0/0xb0) from [<c02384e4>] (rest_init+0x60/0x78)
   r7:c02baa80 r6:c02b19d8 r5:c02b19dc r4:c02b80b0
  [<c0238484>] (rest_init+0x0/0x78) from [<c029d924>] (start_kernel+0x234/0x278)
  [<c029d6f0>] (start_kernel+0x0/0x278) from [<c000803c>] (0xc000803c)
   r5:c02b803c r4:c0007175
  Code: 42555300 54535953 643d4d45 65766972 (53007372)

As we expect that the ->active list is never empty when the ep93xx_dma_tasklet()
is called, we fix this by adding a new flag per channel EP93XX_DMA_IS_RUNNING
which determines whether the channel is running or not.

We also add BUG_ON() to ep93xx_dma_get_active() to make sure that similar
problems will be caught early.

Signed-off-by: Rafal Prylowski <prylowski@metasoft.pl>
[added a flag instead of just checking for empty list]
Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
---
 drivers/dma/ep93xx_dma.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index 6181811..cc3a302 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -155,6 +155,8 @@ struct ep93xx_dma_chan {
 	unsigned long			flags;
 /* Channel is configured for cyclic transfers */
 #define EP93XX_DMA_IS_CYCLIC		0
+/* Channel is enabled */
+#define EP93XX_DMA_IS_RUNNING		1
 
 	int				buffer;
 	dma_cookie_t			last_completed;
@@ -246,6 +248,7 @@ static void ep93xx_dma_set_active(struct ep93xx_dma_chan *edmac,
 static struct ep93xx_dma_desc *
 ep93xx_dma_get_active(struct ep93xx_dma_chan *edmac)
 {
+	BUG_ON(list_empty(&edmac->active));
 	return list_first_entry(&edmac->active, struct ep93xx_dma_desc, node);
 }
 
@@ -669,24 +672,25 @@ static void ep93xx_dma_tasklet(unsigned long data)
 {
 	struct ep93xx_dma_chan *edmac = (struct ep93xx_dma_chan *)data;
 	struct ep93xx_dma_desc *desc, *d;
-	dma_async_tx_callback callback;
-	void *callback_param;
+	dma_async_tx_callback callback = NULL;
+	void *callback_param = NULL;
 	LIST_HEAD(list);
 
 	spin_lock_irq(&edmac->lock);
-	desc = ep93xx_dma_get_active(edmac);
-	if (desc->complete) {
-		edmac->last_completed = desc->txd.cookie;
-		list_splice_init(&edmac->active, &list);
+	if (test_bit(EP93XX_DMA_IS_RUNNING, &edmac->flags)) {
+		desc = ep93xx_dma_get_active(edmac);
+		if (desc->complete) {
+			edmac->last_completed = desc->txd.cookie;
+			list_splice_init(&edmac->active, &list);
+		}
+		callback = desc->txd.callback;
+		callback_param = desc->txd.callback_param;
 	}
 	spin_unlock_irq(&edmac->lock);
 
 	/* Pick up the next descriptor from the queue */
 	ep93xx_dma_advance_work(edmac);
 
-	callback = desc->txd.callback;
-	callback_param = desc->txd.callback_param;
-
 	/* Now we can release all the chained descriptors */
 	list_for_each_entry_safe(desc, d, &list, node) {
 		/*
@@ -758,6 +762,8 @@ static dma_cookie_t ep93xx_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	edmac->chan.cookie = cookie;
 	desc->txd.cookie = cookie;
 
+	set_bit(EP93XX_DMA_IS_RUNNING, &edmac->flags);
+
 	/*
 	 * If nothing is currently prosessed, we push this descriptor
 	 * directly to the hardware. Otherwise we put the descriptor
@@ -1106,6 +1112,7 @@ static int ep93xx_dma_terminate_all(struct ep93xx_dma_chan *edmac)
 	spin_lock_irqsave(&edmac->lock, flags);
 	/* First we disable and flush the DMA channel */
 	edmac->edma->hw_shutdown(edmac);
+	clear_bit(EP93XX_DMA_IS_RUNNING, &edmac->flags);
 	clear_bit(EP93XX_DMA_IS_CYCLIC, &edmac->flags);
 	list_splice_init(&edmac->active, &list);
 	list_splice_init(&edmac->queue, &list);
-- 
1.7.7

