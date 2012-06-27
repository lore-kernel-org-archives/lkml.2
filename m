Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab2F0Vxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 17:53:41 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:29356 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab2F0Vxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 17:53:40 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-160.messagelabs.com!1340833991!8015777!37
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/19] staging: comedi: adl_pci6208: remove thisboard and devpriv macros
Date: Wed, 27 Jun 2012 14:53:28 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206271453.28488.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'thisboard' and 'devpriv' macros rely on a local variable having
a specific name and yield pointers derived from that local variable.
Replace the macros with local variables where used. Use the
comedi_board() helper to get the 'thisboard' pointer.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 79f6765..720f870 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -82,21 +82,17 @@ static const struct pci6208_board pci6208_boards[] = {
 	 }
 };
 
-/* Will be initialized in pci6208_find device(). */
-#define thisboard ((const struct pci6208_board *)dev->board_ptr)
-
 struct pci6208_private {
 	int data;
 	struct pci_dev *pci_dev;	/* for a PCI device */
 	unsigned int ao_readback[2];	/* Used for AO readback */
 };
 
-#define devpriv ((struct pci6208_private *)dev->private)
-
 static int pci6208_ao_winsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
+	struct pci6208_private *devpriv = dev->private;
 	int i = 0, Data_Read;
 	unsigned short chan = CR_CHAN(insn->chanspec);
 	unsigned long invert = 1 << (16 - 1);
@@ -123,6 +119,7 @@ static int pci6208_ao_rinsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
+	struct pci6208_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -183,6 +180,7 @@ static int pci6208_ao_rinsn(struct comedi_device *dev,
 
 static int pci6208_find_device(struct comedi_device *dev, int bus, int slot)
 {
+	struct pci6208_private *devpriv = dev->private;
 	struct pci_dev *pci_dev = NULL;
 	int i;
 
@@ -278,19 +276,23 @@ pci6208_pci_setup(struct pci_dev *pci_dev, unsigned long *io_base_ptr,
 static int pci6208_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	const struct pci6208_board *thisboard;
+	struct pci6208_private *devpriv;
 	struct comedi_subdevice *s;
 	int retval;
 	unsigned long io_base;
 
 	printk(KERN_INFO "comedi%d: pci6208: ", dev->minor);
 
-	retval = alloc_private(dev, sizeof(struct pci6208_private));
+	retval = alloc_private(dev, sizeof(*devpriv));
 	if (retval < 0)
 		return retval;
+	devpriv = dev->private;
 
 	retval = pci6208_find_device(dev, it->options[0], it->options[1]);
 	if (retval < 0)
 		return retval;
+	thisboard = comedi_board(dev);
 
 	retval = pci6208_pci_setup(devpriv->pci_dev, &io_base, dev->minor);
 	if (retval < 0)
@@ -330,6 +332,8 @@ static int pci6208_attach(struct comedi_device *dev,
 
 static void pci6208_detach(struct comedi_device *dev)
 {
+	struct pci6208_private *devpriv = dev->private;
+
 	if (devpriv && devpriv->pci_dev) {
 		if (dev->iobase)
 			comedi_pci_disable(devpriv->pci_dev);
-- 
1.7.11

