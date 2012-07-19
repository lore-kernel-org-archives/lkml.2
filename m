Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab2GSBsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:48:43 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:25438 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab2GSBsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:48:39 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-127.messagelabs.com!1342662516!9008739!5
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 53/90] staging: comedi: cb_pcimdas: remove BADR2 from the private data
Date: Wed, 18 Jul 2012 18:48:27 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181848.27776.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pci resource bar 2 address is the primary i/o address used
by this device. Store it in dev->iobase and remove it from the
private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index c8df680..4312e9b 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -57,7 +57,6 @@ See http://www.mccdaq.com/PDFs/Manuals/pcim-das1602-16.pdf for more details.
 
 /* sizes of io regions (bytes) */
 #define BADR0_SIZE 2		/* ?? */
-#define BADR2_SIZE 6
 #define BADR3_SIZE 16
 
 /* DAC Offsets */
@@ -137,7 +136,6 @@ struct cb_pcimdas_private {
 
 	/* base addresses */
 	unsigned long BADR0;
-	unsigned long BADR2;
 	unsigned long BADR3;
 
 	/* Used for AO readback */
@@ -233,7 +231,7 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 	}
 
 	devpriv->BADR0 = pci_resource_start(devpriv->pci_dev, 0);
-	devpriv->BADR2 = pci_resource_start(devpriv->pci_dev, 2);
+	dev->iobase = pci_resource_start(devpriv->pci_dev, 2);
 	devpriv->BADR3 = pci_resource_start(devpriv->pci_dev, 3);
 	iobase_8255 = pci_resource_start(devpriv->pci_dev, 4);
 
@@ -344,7 +342,7 @@ static int cb_pcimdas_ai_rinsn(struct comedi_device *dev,
 	/* convert n samples */
 	for (n = 0; n < insn->n; n++) {
 		/* trigger conversion */
-		outw(0, devpriv->BADR2 + 0);
+		outw(0, dev->iobase + 0);
 
 #define TIMEOUT 1000		/* typically takes 5 loops on a lightly loaded Pentium 100MHz, */
 		/* this is likely to be 100 loops on a 2GHz machine, so set 1000 as the limit. */
@@ -360,7 +358,7 @@ static int cb_pcimdas_ai_rinsn(struct comedi_device *dev,
 			return -ETIMEDOUT;
 		}
 		/* read data */
-		d = inw(devpriv->BADR2 + 0);
+		d = inw(dev->iobase + 0);
 
 		/* mangle the data as necessary */
 		/* d ^= 1<<(thisboard->ai_bits-1); // 16 bit data from ADC, so no mangle needed. */
@@ -384,10 +382,10 @@ static int cb_pcimdas_ao_winsn(struct comedi_device *dev,
 	for (i = 0; i < insn->n; i++) {
 		switch (chan) {
 		case 0:
-			outw(data[i] & 0x0FFF, devpriv->BADR2 + DAC0_OFFSET);
+			outw(data[i] & 0x0FFF, dev->iobase + DAC0_OFFSET);
 			break;
 		case 1:
-			outw(data[i] & 0x0FFF, devpriv->BADR2 + DAC1_OFFSET);
+			outw(data[i] & 0x0FFF, dev->iobase + DAC1_OFFSET);
 			break;
 		default:
 			return -1;
-- 
1.7.11

