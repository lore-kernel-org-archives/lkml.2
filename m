Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030456Ab2GKWeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:34:16 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:30107 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab2GKWeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:34:14 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-131.messagelabs.com!1342046053!25886623!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 27/30] staging: comedi: dyna_pci10xx: use comedi_device iobase
Date: Wed, 11 Jul 2012 15:34:04 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111534.04424.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the iobase in the comedi_device struct instead of carrying it
in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 32fcaee..e31f74a 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -104,8 +104,7 @@ static const struct boardtype boardtypes[] = {
 struct dyna_pci10xx_private {
 	struct mutex mutex;
 
-	/* device base address registers */
-	unsigned long BADR2, BADR3;
+	unsigned long BADR3;
 };
 
 #define thisboard ((const struct boardtype *)dev->board_ptr)
@@ -133,11 +132,11 @@ static int dyna_pci10xx_insn_read_ai(struct comedi_device *dev,
 	for (n = 0; n < insn->n; n++) {
 		/* trigger conversion */
 		smp_mb();
-		outw_p(0x0000 + range + chan, devpriv->BADR2 + 2);
+		outw_p(0x0000 + range + chan, dev->iobase + 2);
 		udelay(10);
 		/* read data */
 		for (counter = 0; counter < READ_TIMEOUT; counter++) {
-			d = inw_p(devpriv->BADR2);
+			d = inw_p(dev->iobase);
 
 			/* check if read is successful if the EOC bit is set */
 			if (d & (1 << 15))
@@ -173,7 +172,7 @@ static int dyna_pci10xx_insn_write_ao(struct comedi_device *dev,
 	for (n = 0; n < insn->n; n++) {
 		smp_mb();
 		/* trigger conversion and write data */
-		outw_p(data[n], devpriv->BADR2);
+		outw_p(data[n], dev->iobase);
 		udelay(10);
 	}
 	mutex_unlock(&devpriv->mutex);
@@ -289,7 +288,7 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 	mutex_init(&devpriv->mutex);
 
 	/* initialize device base address registers */
-	devpriv->BADR2 = pci_resource_start(dev->pcidev, 2);
+	dev->iobase = pci_resource_start(dev->pcidev, 2);
 	devpriv->BADR3 = pci_resource_start(dev->pcidev, 3);
 
 	ret = comedi_alloc_subdevices(dev, 4);
-- 
1.7.11

