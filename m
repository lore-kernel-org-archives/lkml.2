Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab2AXCxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:53:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50630 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932850Ab2AXCse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:48:34 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:34 2012
Message-Id: <20120124023934.441268897@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stanislaw Gruszka <sgruszka@redhat.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [118/129] rt2800pci: fix spurious interrupts generation
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 3498
Lines: 80

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit dfd00c4c8f3dfa1fd7cec45f83d98b2a49743dcd upstream.

Same devices can generate interrupt without properly setting bit in
INT_SOURCE_CSR register (spurious interrupt), what will cause IRQ line
will be disabled by interrupts controller driver.

We discovered that clearing INT_MASK_CSR stops such behaviour. We
previously first read that register, and then clear all know interrupt
sources bits and do not touch reserved bits. After this patch, we write
to all register content (I believe writing to reserved bits on that
register will not cause any problems, I tested that on my rt2800pci
device).

This fix very bad performance problem, practically making device
unusable (since worked without interrupts), reported in:
https://bugzilla.redhat.com/show_bug.cgi?id=658451

We previously tried to workaround that issue in commit
4ba7d9997869d25bd223dea7536fc1ce9fab3b3b "rt2800pci: handle spurious
interrupts", but it was reverted in commit
82e5fc2a34fa9ffea38f00c4066b7e600a0ca5e6
as thing, that will prevent to detect real spurious interrupts.

Reported-and-tested-by: Amir Hedayaty <hedayaty@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rt2x00/rt2800pci.c |   28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -422,7 +422,6 @@ static int rt2800pci_init_queues(struct
 static void rt2800pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 				 enum dev_state state)
 {
-	int mask = (state == STATE_RADIO_IRQ_ON);
 	u32 reg;
 	unsigned long flags;
 
@@ -436,25 +435,14 @@ static void rt2800pci_toggle_irq(struct
 	}
 
 	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
-	rt2x00pci_register_read(rt2x00dev, INT_MASK_CSR, &reg);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_RXDELAYINT, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_TXDELAYINT, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_RX_DONE, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_AC0_DMA_DONE, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_AC1_DMA_DONE, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_AC2_DMA_DONE, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_AC3_DMA_DONE, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_HCCA_DMA_DONE, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_MGMT_DMA_DONE, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_MCU_COMMAND, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_RXTX_COHERENT, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_TBTT, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_PRE_TBTT, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_TX_FIFO_STATUS, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_AUTO_WAKEUP, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_GPTIMER, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_RX_COHERENT, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_TX_COHERENT, 0);
+	reg = 0;
+	if (state == STATE_RADIO_IRQ_ON) {
+		rt2x00_set_field32(&reg, INT_MASK_CSR_RX_DONE, 1);
+		rt2x00_set_field32(&reg, INT_MASK_CSR_TBTT, 1);
+		rt2x00_set_field32(&reg, INT_MASK_CSR_PRE_TBTT, 1);
+		rt2x00_set_field32(&reg, INT_MASK_CSR_TX_FIFO_STATUS, 1);
+		rt2x00_set_field32(&reg, INT_MASK_CSR_AUTO_WAKEUP, 1);
+	}
 	rt2x00pci_register_write(rt2x00dev, INT_MASK_CSR, reg);
 	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
 


