Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761984Ab2FHFWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:22:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43196 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761051Ab2FHFHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:20 -0400
Message-Id: <20120608041843.160615349@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:18:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Woodhouse <dwmw2@infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 17/82] solos-pci: Fix DMA support
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/atm/solos-pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index e8cd652..9851093 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -984,6 +984,7 @@ static uint32_t fpga_tx(struct solos_card *card)
 			} else if (skb && card->using_dma) {
 				SKB_CB(skb)->dma_addr = pci_map_single(card->dev, skb->data,
 								       skb->len, PCI_DMA_TODEVICE);
+				card->tx_skb[port] = skb;
 				iowrite32(SKB_CB(skb)->dma_addr,
 					  card->config_regs + TX_DMA_ADDR(port));
 			}
@@ -1152,7 +1153,8 @@ static int fpga_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		db_fpga_upgrade = db_firmware_upgrade = 0;
 	}
 
-	if (card->fpga_version >= DMA_SUPPORTED){
+	if (card->fpga_version >= DMA_SUPPORTED) {
+		pci_set_master(dev);
 		card->using_dma = 1;
 	} else {
 		card->using_dma = 0;


