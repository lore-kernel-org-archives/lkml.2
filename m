Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab2F0V7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 17:59:42 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:32478 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab2F0V7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 17:59:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-209.messagelabs.com!1340834378!7107786!9
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/19] staging: comedi: adl_pci6208: pass on the error code from comedi_pci_enable
Date: Wed, 27 Jun 2012 14:59:19 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206271459.19676.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the actual error code from comedi_pci_enable instead of
assuming -EIO on failure. Also, shorten the local variable name 'retval'
to 'ret'.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index e2ca685..8ec2660 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -231,13 +231,13 @@ static int pci6208_attach(struct comedi_device *dev,
 	const struct pci6208_board *thisboard;
 	struct pci6208_private *devpriv;
 	struct comedi_subdevice *s;
-	int retval;
+	int ret;
 
 	printk(KERN_INFO "comedi%d: pci6208: ", dev->minor);
 
-	retval = alloc_private(dev, sizeof(*devpriv));
-	if (retval < 0)
-		return retval;
+	ret = alloc_private(dev, sizeof(*devpriv));
+	if (ret < 0)
+		return ret;
 	devpriv = dev->private;
 
 	devpriv->pci_dev = pci6208_find_device(dev, it);
@@ -245,19 +245,20 @@ static int pci6208_attach(struct comedi_device *dev,
 		return -EIO;
 	thisboard = comedi_board(dev);
 
-	if (comedi_pci_enable(devpriv->pci_dev, "adl_pci6208") < 0) {
+	ret = comedi_pci_enable(devpriv->pci_dev, "adl_pci6208");
+	if (ret) {
 		dev_err(dev->class_dev,
 			"Failed to enable PCI device and request regions\n");
-		return -EIO;
+		return ret;
 	}
 
 	dev->iobase = pci_resource_start(devpriv->pci_dev, 2);
 
 	dev->board_name = thisboard->name;
 
-	retval = comedi_alloc_subdevices(dev, 2);
-	if (retval)
-		return retval;
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* analog output subdevice */
-- 
1.7.11

