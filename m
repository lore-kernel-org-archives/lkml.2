Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab2GSBqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:46:19 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:7660 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2GSBqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:46:16 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-127.messagelabs.com!1342662355!9008581!16
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 47/90] staging: comedi: cb_pcimdas: factor out the "find pci device" code
Date: Wed, 18 Jul 2012 18:46:07 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181846.07718.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor the "find pci device" code out of the attach function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c | 61 +++++++++++++++--------------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 2977f2d..8999a72 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -175,30 +175,11 @@ static int cb_pcimdas_ao_rinsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data);
 
-/*
- * Attach is called by the Comedi core to configure the driver
- * for a particular board.  If you specified a board_name array
- * in the driver structure, dev->board_ptr contains that
- * address.
- */
-static int cb_pcimdas_attach(struct comedi_device *dev,
-			     struct comedi_devconfig *it)
+static struct pci_dev *cb_pcimdas_find_pci_dev(struct comedi_device *dev,
+					       struct comedi_devconfig *it)
 {
-	struct comedi_subdevice *s;
 	struct pci_dev *pcidev = NULL;
 	int index;
-	int ret;
-	/* int i; */
-
-/*
- * Allocate the private structure area.
- */
-	if (alloc_private(dev, sizeof(struct cb_pcimdas_private)) < 0)
-		return -ENOMEM;
-
-/*
- * Probe the device to determine what device in the series it is.
- */
 
 	for_each_pci_dev(pcidev) {
 		/*  is it not a computer boards card? */
@@ -217,21 +198,43 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 					continue;
 				}
 			}
-			devpriv->pci_dev = pcidev;
 			dev->board_ptr = cb_pcimdas_boards + index;
-			goto found;
+			dev_dbg(dev->class_dev,
+				"Found %s on bus %i, slot %i\n",
+				cb_pcimdas_boards[index].name,
+				pcidev->bus->number,
+				PCI_SLOT(pcidev->devfn));
+			return pcidev;
 		}
 	}
-
 	dev_err(dev->class_dev,
 		"No supported ComputerBoards/MeasurementComputing card found on requested position\n");
-	return -EIO;
+	return NULL;
+}
 
-found:
+/*
+ * Attach is called by the Comedi core to configure the driver
+ * for a particular board.  If you specified a board_name array
+ * in the driver structure, dev->board_ptr contains that
+ * address.
+ */
+static int cb_pcimdas_attach(struct comedi_device *dev,
+			     struct comedi_devconfig *it)
+{
+	struct pci_dev *pcidev;
+	struct comedi_subdevice *s;
+	int ret;
 
-	dev_dbg(dev->class_dev, "Found %s on bus %i, slot %i\n",
-		cb_pcimdas_boards[index].name, pcidev->bus->number,
-		PCI_SLOT(pcidev->devfn));
+/*
+ * Allocate the private structure area.
+ */
+	if (alloc_private(dev, sizeof(struct cb_pcimdas_private)) < 0)
+		return -ENOMEM;
+
+	pcidev = cb_pcimdas_find_pci_dev(dev, it);
+	if (!pcidev)
+		return -EIO;
+	devpriv->pci_dev = pcidev;
 
 	/*  Warn about non-tested features */
 	switch (thisboard->device_id) {
-- 
1.7.11

