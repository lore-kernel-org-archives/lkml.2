Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab2GSCBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 22:01:07 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:31930 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab2GSCBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 22:01:01 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1342663260!10107397!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 74/90] staging: comedi: dyna_pci10xx: use dev->iobase
Date: Wed, 18 Jul 2012 19:00:54 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181900.55048.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev->iobase to hold one of the pci base addresses used
by the driver instead of carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 95ee422..e7086b1 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -104,7 +104,7 @@ struct dyna_pci10xx_private {
 	struct mutex mutex;
 
 	/* device base address registers */
-	unsigned long BADR2, BADR3;
+	unsigned long BADR3;
 };
 
 #define thisboard ((const struct boardtype *)dev->board_ptr)
@@ -132,11 +132,11 @@ static int dyna_pci10xx_insn_read_ai(struct comedi_device *dev,
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
@@ -172,7 +172,7 @@ static int dyna_pci10xx_insn_write_ao(struct comedi_device *dev,
 	for (n = 0; n < insn->n; n++) {
 		smp_mb();
 		/* trigger conversion and write data */
-		outw_p(data[n], devpriv->BADR2);
+		outw_p(data[n], dev->iobase);
 		udelay(10);
 	}
 	mutex_unlock(&devpriv->mutex);
@@ -288,7 +288,7 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 
 	printk(KERN_INFO "comedi: dyna_pci10xx: device found!\n");
 
-	devpriv->BADR2 = pci_resource_start(pcidev, 2);
+	dev->iobase = pci_resource_start(pcidev, 2);
 	devpriv->BADR3 = pci_resource_start(pcidev, 3);
 
 	ret = comedi_alloc_subdevices(dev, 4);
-- 
1.7.11

