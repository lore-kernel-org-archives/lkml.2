Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab2FUC2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:28:10 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:29693 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab2FUC2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:28:08 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-131.messagelabs.com!1340245687!22817991!2
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/12] staging: comedi: s626: factor out the find PCI device code
Date: Wed, 20 Jun 2012 19:28:01 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201928.02217.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out the code that finds a matching PCI device from attach
function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/s626.c | 54 +++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 779ae7a..bef9649 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -2476,6 +2476,35 @@ static void CountersInit(struct comedi_device *dev)
 	}
 }
 
+static struct pci_dev *s626_find_pci(struct comedi_device *dev,
+				     struct comedi_devconfig *it)
+{
+	struct pci_dev *pcidev = NULL;
+	int bus = it->options[0];
+	int slot = it->options[1];
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(s626_boards) && !pcidev; i++) {
+		do {
+			pcidev = pci_get_subsys(s626_boards[i].vendor_id,
+						s626_boards[i].device_id,
+						s626_boards[i].subvendor_id,
+						s626_boards[i].subdevice_id,
+						pcidev);
+
+			if ((bus || slot) && pcidev) {
+				/* matches requested bus/slot */
+				if (pcidev->bus->number == bus &&
+				    PCI_SLOT(pcidev->devfn) == slot)
+					break;
+			} else {
+				break;
+			}
+		} while (1);
+	}
+	return pcidev;
+}
+
 static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 /*   uint8_t	PollList; */
@@ -2489,36 +2518,17 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	resource_size_t resourceStart;
 	dma_addr_t appdma;
 	struct comedi_subdevice *s;
-	struct pci_dev *pdev = NULL;
 
 	if (alloc_private(dev, sizeof(struct s626_private)) < 0)
 		return -ENOMEM;
 
-	for (i = 0; i < ARRAY_SIZE(s626_boards) && !pdev; i++) {
-		do {
-			pdev = pci_get_subsys(s626_boards[i].vendor_id,
-					      s626_boards[i].device_id,
-					      s626_boards[i].subvendor_id,
-					      s626_boards[i].subdevice_id,
-					      pdev);
-
-			if ((it->options[0] || it->options[1]) && pdev) {
-				/* matches requested bus/slot */
-				if (pdev->bus->number == it->options[0] &&
-				    PCI_SLOT(pdev->devfn) == it->options[1])
-					break;
-			} else
-				break;
-		} while (1);
-	}
-	devpriv->pdev = pdev;
-
-	if (pdev == NULL) {
+	devpriv->pdev = s626_find_pci(dev, it);
+	if (!devpriv->pdev) {
 		printk(KERN_ERR "s626_attach: Board not present!!!\n");
 		return -ENODEV;
 	}
 
-	result = comedi_pci_enable(pdev, "s626");
+	result = comedi_pci_enable(devpriv->pdev, "s626");
 	if (result < 0) {
 		printk(KERN_ERR "s626_attach: comedi_pci_enable fails\n");
 		return -ENODEV;
-- 
1.7.11

