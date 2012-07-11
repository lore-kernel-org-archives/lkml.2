Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab2GKAZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:25:01 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:62635 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab2GKAY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:24:59 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-209.messagelabs.com!1341966297!8334310!2
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 80/83] staging: comedi: rtd520: factor out the "find pci device" code
Date: Tue, 10 Jul 2012 17:24:52 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101724.52666.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor the "find pci device" code out of the attach function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 74 ++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 92f806d..97d888f 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1605,12 +1605,47 @@ static int rtd_dio_insn_config(struct comedi_device *dev,
 	return 1;
 }
 
+static struct pci_dev *rtd_find_pci(struct comedi_device *dev,
+				    struct comedi_devconfig *it)
+{
+	struct pci_dev *pcidev;
+
+	for (pcidev = pci_get_device(PCI_VENDOR_ID_RTD, PCI_ANY_ID, NULL);
+	     pcidev != NULL;
+	     pcidev = pci_get_device(PCI_VENDOR_ID_RTD, PCI_ANY_ID, pcidev)) {
+		int i;
+
+		if (it->options[0] || it->options[1]) {
+			if (pcidev->bus->number != it->options[0]
+			    || PCI_SLOT(pcidev->devfn) != it->options[1]) {
+				continue;
+			}
+		}
+		for (i = 0; i < ARRAY_SIZE(rtd520Boards); ++i) {
+			if (pcidev->device == rtd520Boards[i].device_id) {
+				dev->board_ptr = &rtd520Boards[i];
+				break;
+			}
+		}
+		if (dev->board_ptr)
+			return pcidev;	/* found one */
+	}
+	if (!pcidev) {
+		if (it->options[0] && it->options[1]) {
+			printk(KERN_INFO "No RTD card at bus=%d slot=%d.\n",
+			       it->options[0], it->options[1]);
+		} else {
+			printk(KERN_INFO "No RTD card found.\n");
+		}
+	}
+	return NULL;
+}
+
 static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {				/* board name and options flags */
 	const struct rtdBoard *thisboard;
 	struct rtdPrivate *devpriv;
 	struct comedi_subdevice *s;
-	struct pci_dev *pcidev;
 	int ret;
 	resource_size_t physLas0;	/* configuration */
 	resource_size_t physLas1;	/* data area */
@@ -1635,43 +1670,14 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -ENOMEM;
 	devpriv = dev->private;
 
-	/*
-	 * Probe the device to determine what device in the series it is.
-	 */
-	for (pcidev = pci_get_device(PCI_VENDOR_ID_RTD, PCI_ANY_ID, NULL);
-	     pcidev != NULL;
-	     pcidev = pci_get_device(PCI_VENDOR_ID_RTD, PCI_ANY_ID, pcidev)) {
-		int i;
-
-		if (it->options[0] || it->options[1]) {
-			if (pcidev->bus->number != it->options[0]
-			    || PCI_SLOT(pcidev->devfn) != it->options[1]) {
-				continue;
-			}
-		}
-		for (i = 0; i < ARRAY_SIZE(rtd520Boards); ++i) {
-			if (pcidev->device == rtd520Boards[i].device_id) {
-				dev->board_ptr = &rtd520Boards[i];
-				break;
-			}
-		}
-		if (dev->board_ptr)
-			break;	/* found one */
-	}
-	if (!pcidev) {
-		if (it->options[0] && it->options[1]) {
-			printk(KERN_INFO "No RTD card at bus=%d slot=%d.\n",
-			       it->options[0], it->options[1]);
-		} else {
-			printk(KERN_INFO "No RTD card found.\n");
-		}
+	devpriv->pci_dev = rtd_find_pci(dev, it);
+	if (!devpriv->pci_dev)
 		return -EIO;
-	}
-	devpriv->pci_dev = pcidev;
 	thisboard = comedi_board(dev);
+
 	dev->board_name = thisboard->name;
 
-	ret = comedi_pci_enable(pcidev, DRV_NAME);
+	ret = comedi_pci_enable(devpriv->pci_dev, DRV_NAME);
 	if (ret < 0) {
 		printk(KERN_INFO "Failed to enable PCI device and request regions.\n");
 		return ret;
-- 
1.7.11

