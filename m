Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab2GSBnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:43:32 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:64250 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab2GSBna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:43:30 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-127.messagelabs.com!1342662209!8565091!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 41/90] staging: comedi: cb_pcidas64: store the pci_dev in the comedi_device
Date: Wed, 18 Jul 2012 18:43:18 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181843.19047.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hw_dev pointer in the comedi_device struct to hold the
pci_dev instead of carrying it in the private data.

Save the pci bar in dev->iobase so the detach is consistent with
the other comedi pci drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c | 39 +++++++++++++++-------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index d1b0327..65cbaab 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1047,8 +1047,6 @@ struct ext_clock_info {
 
 /* this structure is for data unique to this hardware driver. */
 struct pcidas64_private {
-
-	struct pci_dev *hw_dev;	/*  pointer to board's pci_dev struct */
 	/*  base addresses (physical) */
 	resource_size_t plx9080_phys_iobase;
 	resource_size_t main_phys_iobase;
@@ -1553,12 +1551,13 @@ static void init_stc_registers(struct comedi_device *dev)
 
 static int alloc_and_init_dma_members(struct comedi_device *dev)
 {
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 	int i;
 
 	/*  alocate pci dma buffers */
 	for (i = 0; i < ai_dma_ring_count(board(dev)); i++) {
 		priv(dev)->ai_buffer[i] =
-		    pci_alloc_consistent(priv(dev)->hw_dev, DMA_BUFFER_SIZE,
+		    pci_alloc_consistent(pcidev, DMA_BUFFER_SIZE,
 					 &priv(dev)->ai_buffer_bus_addr[i]);
 		if (priv(dev)->ai_buffer[i] == NULL)
 			return -ENOMEM;
@@ -1567,7 +1566,7 @@ static int alloc_and_init_dma_members(struct comedi_device *dev)
 	for (i = 0; i < AO_DMA_RING_COUNT; i++) {
 		if (ao_cmd_is_supported(board(dev))) {
 			priv(dev)->ao_buffer[i] =
-			    pci_alloc_consistent(priv(dev)->hw_dev,
+			    pci_alloc_consistent(pcidev,
 						 DMA_BUFFER_SIZE,
 						 &priv(dev)->
 						 ao_buffer_bus_addr[i]);
@@ -1578,7 +1577,7 @@ static int alloc_and_init_dma_members(struct comedi_device *dev)
 	}
 	/*  allocate dma descriptors */
 	priv(dev)->ai_dma_desc =
-	    pci_alloc_consistent(priv(dev)->hw_dev,
+	    pci_alloc_consistent(pcidev,
 				 sizeof(struct plx_dma_desc) *
 				 ai_dma_ring_count(board(dev)),
 				 &priv(dev)->ai_dma_desc_bus_addr);
@@ -1589,7 +1588,7 @@ static int alloc_and_init_dma_members(struct comedi_device *dev)
 		    priv(dev)->ai_dma_desc_bus_addr);
 	if (ao_cmd_is_supported(board(dev))) {
 		priv(dev)->ao_dma_desc =
-		    pci_alloc_consistent(priv(dev)->hw_dev,
+		    pci_alloc_consistent(pcidev,
 					 sizeof(struct plx_dma_desc) *
 					 AO_DMA_RING_COUNT,
 					 &priv(dev)->ao_dma_desc_bus_addr);
@@ -1699,7 +1698,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	pcidev = cb_pcidas64_find_pci_dev(dev, it);
 	if (!pcidev)
 		return -EIO;
-	priv(dev)->hw_dev = pcidev;
+	comedi_set_hw_dev(dev, &pcidev->dev);
 
 	if (comedi_pci_enable(pcidev, dev->driver->driver_name)) {
 		dev_warn(dev->class_dev,
@@ -1711,10 +1710,11 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* Initialize dev->board_name */
 	dev->board_name = board(dev)->name;
 
+	dev->iobase = pci_resource_start(pcidev, MAIN_BADDRINDEX);
+
 	priv(dev)->plx9080_phys_iobase =
 	    pci_resource_start(pcidev, PLX9080_BADDRINDEX);
-	priv(dev)->main_phys_iobase =
-	    pci_resource_start(pcidev, MAIN_BADDRINDEX);
+	priv(dev)->main_phys_iobase = dev->iobase;
 	priv(dev)->dio_counter_phys_iobase =
 	    pci_resource_start(pcidev, DIO_COUNTER_BADDRINDEX);
 
@@ -1791,12 +1791,13 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void detach(struct comedi_device *dev)
 {
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 	unsigned int i;
 
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (priv(dev)) {
-		if (priv(dev)->hw_dev) {
+		if (pcidev) {
 			if (priv(dev)->plx9080_iobase) {
 				disable_plx_interrupts(dev);
 				iounmap(priv(dev)->plx9080_iobase);
@@ -1808,7 +1809,7 @@ static void detach(struct comedi_device *dev)
 			/*  free pci dma buffers */
 			for (i = 0; i < ai_dma_ring_count(board(dev)); i++) {
 				if (priv(dev)->ai_buffer[i])
-					pci_free_consistent(priv(dev)->hw_dev,
+					pci_free_consistent(pcidev,
 							    DMA_BUFFER_SIZE,
 							    priv(dev)->
 							    ai_buffer[i],
@@ -1818,7 +1819,7 @@ static void detach(struct comedi_device *dev)
 			}
 			for (i = 0; i < AO_DMA_RING_COUNT; i++) {
 				if (priv(dev)->ao_buffer[i])
-					pci_free_consistent(priv(dev)->hw_dev,
+					pci_free_consistent(pcidev,
 							    DMA_BUFFER_SIZE,
 							    priv(dev)->
 							    ao_buffer[i],
@@ -1828,7 +1829,7 @@ static void detach(struct comedi_device *dev)
 			}
 			/*  free dma descriptors */
 			if (priv(dev)->ai_dma_desc)
-				pci_free_consistent(priv(dev)->hw_dev,
+				pci_free_consistent(pcidev,
 						    sizeof(struct plx_dma_desc)
 						    *
 						    ai_dma_ring_count(board
@@ -1837,20 +1838,22 @@ static void detach(struct comedi_device *dev)
 						    priv(dev)->
 						    ai_dma_desc_bus_addr);
 			if (priv(dev)->ao_dma_desc)
-				pci_free_consistent(priv(dev)->hw_dev,
+				pci_free_consistent(pcidev,
 						    sizeof(struct plx_dma_desc)
 						    * AO_DMA_RING_COUNT,
 						    priv(dev)->ao_dma_desc,
 						    priv(dev)->
 						    ao_dma_desc_bus_addr);
-			if (priv(dev)->main_phys_iobase)
-				comedi_pci_disable(priv(dev)->hw_dev);
-
-			pci_dev_put(priv(dev)->hw_dev);
 		}
 	}
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 4);
+	if (pcidev) {
+		if (dev->iobase)
+			comedi_pci_disable(pcidev);
+
+		pci_dev_put(pcidev);
+	}
 }
 
 static int ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
-- 
1.7.11

