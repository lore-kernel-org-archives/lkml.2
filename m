Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab2HOBXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 21:23:35 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:32528 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab2HOBXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 21:23:33 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-131.messagelabs.com!1344993812!24210952!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] staging: comedi: dnya_pci10xx: remove thisboard and devpriv macros
Date: Tue, 14 Aug 2012 18:23:24 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208141823.24406.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros rely on local variables having a specific name. Replace
them with local variables where used. Use the comedi_board() helper
to get the thisboard pointer.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 064be9a..7884a94 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -104,9 +104,6 @@ struct dyna_pci10xx_private {
 	unsigned long BADR3;
 };
 
-#define thisboard ((const struct boardtype *)dev->board_ptr)
-#define devpriv ((struct dyna_pci10xx_private *)dev->private)
-
 /******************************************************************************/
 /************************** READ WRITE FUNCTIONS ******************************/
 /******************************************************************************/
@@ -116,6 +113,8 @@ static int dyna_pci10xx_insn_read_ai(struct comedi_device *dev,
 			struct comedi_subdevice *s,
 			struct comedi_insn *insn, unsigned int *data)
 {
+	const struct boardtype *thisboard = comedi_board(dev);
+	struct dyna_pci10xx_private *devpriv = dev->private;
 	int n, counter;
 	u16 d = 0;
 	unsigned int chan, range;
@@ -159,6 +158,8 @@ static int dyna_pci10xx_insn_write_ao(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	const struct boardtype *thisboard = comedi_board(dev);
+	struct dyna_pci10xx_private *devpriv = dev->private;
 	int n;
 	unsigned int chan, range;
 
@@ -181,6 +182,7 @@ static int dyna_pci10xx_di_insn_bits(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
+	struct dyna_pci10xx_private *devpriv = dev->private;
 	u16 d = 0;
 
 	mutex_lock(&devpriv->mutex);
@@ -200,6 +202,8 @@ static int dyna_pci10xx_do_insn_bits(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
+	struct dyna_pci10xx_private *devpriv = dev->private;
+
 	/* The insn data is a mask in data[0] and the new data
 	 * in data[1], each channel cooresponding to a bit.
 	 * s->state contains the previous write data
@@ -257,20 +261,22 @@ static struct pci_dev *dyna_pci10xx_find_pci_dev(struct comedi_device *dev,
 static int dyna_pci10xx_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	const struct boardtype *thisboard;
+	struct dyna_pci10xx_private *devpriv;
 	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int ret;
 
-	if (alloc_private(dev, sizeof(struct dyna_pci10xx_private)) < 0) {
-		printk(KERN_ERR "comedi: dyna_pci10xx: "
-			"failed to allocate memory!\n");
-		return -ENOMEM;
-	}
+	ret = alloc_private(dev, sizeof(*devpriv));
+	if (ret)
+		return ret;
+	devpriv = dev->private;
 
 	pcidev = dyna_pci10xx_find_pci_dev(dev, it);
 	if (!pcidev)
 		return -EIO;
 	comedi_set_hw_dev(dev, &pcidev->dev);
+	thisboard = comedi_board(dev);
 
 	dev->board_name = thisboard->name;
 	dev->irq = 0;
@@ -342,6 +348,7 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 static void dyna_pci10xx_detach(struct comedi_device *dev)
 {
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
+	struct dyna_pci10xx_private *devpriv = dev->private;
 
 	if (devpriv)
 		mutex_destroy(&devpriv->mutex);
-- 
1.7.11

