Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab2EBAEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 20:04:07 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:45568 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364Ab2EBAEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 20:04:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-160.messagelabs.com!1335917043!2610493!2
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: fix build errors caused by module_init/module_exit refactor
Date: Tue, 1 May 2012 17:03:48 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205011703.50312.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple build errors were introduced with the module_init/module_exit
refactor.

The struct comedi_driver variable was being accessed directly in the
attach and detach routines. Instead of doing this, access the variable
indirectly using the driver pointer in struct comedi_device.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/pcmda12.c b/drivers/staging/comedi/drivers/pcmda12.c
index 4846d98..a82b343 100644
--- a/drivers/staging/comedi/drivers/pcmda12.c
+++ b/drivers/staging/comedi/drivers/pcmda12.c
@@ -172,10 +172,10 @@ static int pcmda12_attach(struct comedi_device *dev,
 
 	iobase = it->options[0];
 	printk(KERN_INFO
-	       "comedi%d: %s: io: %lx %s ", dev->minor, driver.driver_name,
+	       "comedi%d: %s: io: %lx %s ", dev->minor, dev->driver->driver_name,
 	       iobase, it->options[1] ? "simultaneous xfer mode enabled" : "");
 
-	if (!request_region(iobase, IOSIZE, driver.driver_name)) {
+	if (!request_region(iobase, IOSIZE, dev->driver->driver_name)) {
 		printk("I/O port conflict\n");
 		return -EIO;
 	}
@@ -230,7 +230,7 @@ static int pcmda12_attach(struct comedi_device *dev,
 static int pcmda12_detach(struct comedi_device *dev)
 {
 	printk(KERN_INFO
-	       "comedi%d: %s: remove\n", dev->minor, driver.driver_name);
+	       "comedi%d: %s: remove\n", dev->minor, dev->driver->driver_name);
 	if (dev->iobase)
 		release_region(dev->iobase, IOSIZE);
 	return 0;
diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index e05d157..75ccb48 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -1022,13 +1022,13 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	irq[0] = it->options[1];
 
 	printk(KERN_INFO "comedi%d: %s: io: %lx attaching...\n", dev->minor,
-			driver.driver_name, iobase);
+			dev->driver->driver_name, iobase);
 
 	dev->iobase = iobase;
 
 	if (!iobase || !request_region(iobase,
 				       thisboard->total_iosize,
-				       driver.driver_name)) {
+				       dev->driver->driver_name)) {
 		printk(KERN_ERR "comedi%d: I/O port conflict\n", dev->minor);
 		return -EIO;
 	}
@@ -1227,7 +1227,8 @@ static int pcmmio_detach(struct comedi_device *dev)
 {
 	int i;
 
-	printk(KERN_INFO "comedi%d: %s: remove\n", dev->minor, driver.driver_name);
+	printk(KERN_INFO "comedi%d: %s: remove\n", dev->minor,
+		dev->driver->driver_name);
 	if (dev->iobase)
 		release_region(dev->iobase, thisboard->total_iosize);
 
diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index de4f486..47a3ee6 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -757,13 +757,13 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	irq[1] = it->options[2];
 
 	dev_dbg(dev->hw_dev, "comedi%d: %s: io: %lx attached\n", dev->minor,
-		driver.driver_name, iobase);
+		dev->driver->driver_name, iobase);
 
 	dev->iobase = iobase;
 
 	if (!iobase || !request_region(iobase,
 				       thisboard->num_asics * ASIC_IOSIZE,
-				       driver.driver_name)) {
+				       dev->driver->driver_name)) {
 		dev_err(dev->hw_dev, "I/O port conflict\n");
 		return -EIO;
 	}
@@ -913,7 +913,7 @@ static int pcmuio_detach(struct comedi_device *dev)
 	int i;
 
 	dev_dbg(dev->hw_dev, "comedi%d: %s: remove\n", dev->minor,
-		driver.driver_name);
+		dev->driver->driver_name);
 	if (dev->iobase)
 		release_region(dev->iobase, ASIC_IOSIZE * thisboard->num_asics);
 
