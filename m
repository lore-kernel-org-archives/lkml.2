Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423Ab2FGEXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:23:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63657 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933337Ab2FGEXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:23:07 -0400
Message-Id: <20120607041359.520520860@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:14:07 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Woodhouse <David.Woodhouse@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 09/47] solos-pci: Fix DMA support
In-Reply-To: <20120607041504.GA13819@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

commit b4bd8ad9bb311e8536f726f7a633620ccd358cde upstream.

DMA support has finally made its way to the top of the TODO list, having
realised that a Geode using MMIO can't keep up with two ADSL2+ lines
each running at 21Mb/s.

This patch fixes a couple of bugs in the DMA support in the driver, so
once the corresponding FPGA update is complete and tested everything
should work properly.

We weren't storing the currently-transmitting skb, so we were never
unmapping it and never freeing/popping it when the TX was done.
And the addition of pci_set_master() is fairly self-explanatory.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/atm/solos-pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -984,6 +984,7 @@ static uint32_t fpga_tx(struct solos_car
 			} else if (skb && card->using_dma) {
 				SKB_CB(skb)->dma_addr = pci_map_single(card->dev, skb->data,
 								       skb->len, PCI_DMA_TODEVICE);
+				card->tx_skb[port] = skb;
 				iowrite32(SKB_CB(skb)->dma_addr,
 					  card->config_regs + TX_DMA_ADDR(port));
 			}
@@ -1152,7 +1153,8 @@ static int fpga_probe(struct pci_dev *de
 		db_fpga_upgrade = db_firmware_upgrade = 0;
 	}
 
-	if (card->fpga_version >= DMA_SUPPORTED){
+	if (card->fpga_version >= DMA_SUPPORTED) {
+		pci_set_master(dev);
 		card->using_dma = 1;
 	} else {
 		card->using_dma = 0;


