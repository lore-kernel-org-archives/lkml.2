Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605Ab2ERALg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:11:36 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:65291 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933088Ab2ERALa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:11:30 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-160.messagelabs.com!1337299887!6754879!2
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: cleanup all the comedi_driver 'detach' functions
Date: Thu, 17 May 2012 17:11:14 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205171711.14968.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Change the return type from int to void

All the detach functions, except for the comedi usb drivers, simply
return success (0). Plus, the return code is never checked in the
comedi core.

The comedi usb drivers do return error codes but the conditions can
never happen.

The first check is:

	if (!dev)
		return -EFAULT;

This checks that the passed comedi_device pointer is valid. The detach
function itself is called using this pointer so it MUST always be valid
or there is a bug in the core:

	if (dev->driver)
		dev->driver->detach(dev);

And the second check:

	usb = dev->private;
	if (!usb)
		return -EFAULT;

The dev->private pointer is setup in the attach function to point to the
probed usb device. This value could be NULL if the attach fails. But,
since the comedi core is going to unload the driver anyway and does not
check for errors there is no gain by returning one.

After removing these checks from the comedi usb drivers the detach
functions required a bit of cleanup.

2. Remove all the printk noise in the detach functions

All of the printk output is really just noise. The user did a rmmod to
unload the driver, we really don't need to tell them about it.

Also, some of the messages are output using:

	dev_dbg(dev->hw_dev, ...
or
	dev_info(dev->hw_dev, ...

Unfortunately the hw_dev value is only used by drivers that are doing
DMA. For most drivers this variable is going to be NULL so the output
is not going to work as expected.

3. Refactor a couple static 'free_resource' functions into the detach
   functions.

The 'free_resource' function is only being called by the detach and it
makes more sense to just absorb the code.

4. Remove a couple unnecessary braces for single statements.

5. Remove unnecessary comments.

Most of the comedi drivers appear to be based on the comedi skel driver
and have the comments from that driver included. These comments make
sense in the skel driver for reference but they don't need to be in any
of the actual drivers.

6. Remove all the extra whitespace.

It's not needed to make the functions any more readable.

7. Remove the now unused 'attached_successfully' variable in the
   cb_pcimdda driver.

This variable was only used to conditionally output some driver noise
during the detach. Since all the printk's have been removed this
variable is no longer necessary.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

This is a pretty large patch but it's mostly line removal. I can break
it up if necessary.

 drivers/staging/comedi/comedidev.h                 |    2 +-
 drivers/staging/comedi/drivers/8255.c              |    6 +--
 drivers/staging/comedi/drivers/acl7225b.c          |    6 +--
 .../staging/comedi/drivers/addi-data/addi_common.c |   48 ++------------
 .../staging/comedi/drivers/addi-data/addi_common.h |    2 +-
 drivers/staging/comedi/drivers/adl_pci6208.c       |    6 +--
 drivers/staging/comedi/drivers/adl_pci7230.c       |    6 +--
 drivers/staging/comedi/drivers/adl_pci7296.c       |    8 +--
 drivers/staging/comedi/drivers/adl_pci7432.c       |    6 +--
 drivers/staging/comedi/drivers/adl_pci8164.c       |    6 +--
 drivers/staging/comedi/drivers/adl_pci9111.c       |   12 +---
 drivers/staging/comedi/drivers/adl_pci9118.c       |    4 +-
 drivers/staging/comedi/drivers/adq12b.c            |    7 +--
 drivers/staging/comedi/drivers/adv_pci1710.c       |    5 +-
 drivers/staging/comedi/drivers/adv_pci1723.c       |    7 +--
 drivers/staging/comedi/drivers/adv_pci_dio.c       |   18 +-----
 drivers/staging/comedi/drivers/aio_aio12_8.c       |    3 +-
 drivers/staging/comedi/drivers/aio_iiro_16.c       |    6 +--
 drivers/staging/comedi/drivers/amplc_dio200.c      |   20 +-----
 drivers/staging/comedi/drivers/amplc_pc236.c       |   20 +-----
 drivers/staging/comedi/drivers/amplc_pc263.c       |   20 +-----
 drivers/staging/comedi/drivers/amplc_pci224.c      |   12 +---
 drivers/staging/comedi/drivers/amplc_pci230.c      |   18 +-----
 drivers/staging/comedi/drivers/c6xdigio.c          |   15 +----
 drivers/staging/comedi/drivers/cb_das16_cs.c       |    9 +--
 drivers/staging/comedi/drivers/cb_pcidas.c         |   18 +-----
 drivers/staging/comedi/drivers/cb_pcidas64.c       |   12 +---
 drivers/staging/comedi/drivers/cb_pcidda.c         |   16 +-----
 drivers/staging/comedi/drivers/cb_pcidio.c         |    3 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |   25 +-------
 drivers/staging/comedi/drivers/cb_pcimdda.c        |   23 +-------
 drivers/staging/comedi/drivers/comedi_bond.c       |   49 ++++++--------
 drivers/staging/comedi/drivers/comedi_parport.c    |    7 +--
 drivers/staging/comedi/drivers/comedi_test.c       |    6 +--
 drivers/staging/comedi/drivers/contec_pci_dio.c    |    6 +--
 drivers/staging/comedi/drivers/daqboard2000.c      |    5 +-
 drivers/staging/comedi/drivers/das08.c             |    9 +---
 drivers/staging/comedi/drivers/das08.h             |    2 +-
 drivers/staging/comedi/drivers/das16.c             |   10 +---
 drivers/staging/comedi/drivers/das16m1.c           |    9 +---
 drivers/staging/comedi/drivers/das1800.c           |    8 +--
 drivers/staging/comedi/drivers/das6402.c           |    4 +-
 drivers/staging/comedi/drivers/das800.c            |    8 +--
 drivers/staging/comedi/drivers/dmm32at.c           |   15 +----
 drivers/staging/comedi/drivers/dt2801.c            |    4 +-
 drivers/staging/comedi/drivers/dt2811.c            |    6 +--
 drivers/staging/comedi/drivers/dt2814.c            |    7 +--
 drivers/staging/comedi/drivers/dt2815.c            |   11 +---
 drivers/staging/comedi/drivers/dt2817.c            |    6 +--
 drivers/staging/comedi/drivers/dt282x.c            |   11 +---
 drivers/staging/comedi/drivers/dt3000.c            |    5 +-
 drivers/staging/comedi/drivers/dt9812.c            |    4 +-
 drivers/staging/comedi/drivers/dyna_pci10xx.c      |    4 +-
 drivers/staging/comedi/drivers/fl512.c             |    4 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c          |    5 +-
 drivers/staging/comedi/drivers/icp_multi.c         |    8 +--
 drivers/staging/comedi/drivers/ii_pci20kc.c        |    6 +-
 drivers/staging/comedi/drivers/jr3_pci.c           |    5 +-
 drivers/staging/comedi/drivers/ke_counter.c        |    5 +-
 drivers/staging/comedi/drivers/me4000.c            |    6 +--
 drivers/staging/comedi/drivers/me_daq.c            |    4 +-
 drivers/staging/comedi/drivers/mpc624.c            |    6 +--
 drivers/staging/comedi/drivers/mpc8260cpm.c        |    6 +-
 drivers/staging/comedi/drivers/multiq3.c           |    6 +--
 drivers/staging/comedi/drivers/ni_6527.c           |    8 +--
 drivers/staging/comedi/drivers/ni_65xx.c           |    7 +--
 drivers/staging/comedi/drivers/ni_660x.c           |    9 +--
 drivers/staging/comedi/drivers/ni_670x.c           |   10 +---
 drivers/staging/comedi/drivers/ni_at_a2150.c       |    9 +---
 drivers/staging/comedi/drivers/ni_at_ao.c          |    6 +--
 drivers/staging/comedi/drivers/ni_atmio.c          |    6 +--
 drivers/staging/comedi/drivers/ni_atmio16d.c       |    9 +---
 drivers/staging/comedi/drivers/ni_daq_700.c        |   17 +----
 drivers/staging/comedi/drivers/ni_daq_dio24.c      |   17 +----
 drivers/staging/comedi/drivers/ni_labpc.c          |    7 +--
 drivers/staging/comedi/drivers/ni_labpc.h          |    2 +-
 drivers/staging/comedi/drivers/ni_labpc_cs.c       |   10 +---
 drivers/staging/comedi/drivers/ni_mio_cs.c         |   13 +---
 drivers/staging/comedi/drivers/ni_pcidio.c         |    5 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |    6 +--
 drivers/staging/comedi/drivers/pcl711.c            |    7 +--
 drivers/staging/comedi/drivers/pcl724.c            |    8 +--
 drivers/staging/comedi/drivers/pcl725.c            |    6 +--
 drivers/staging/comedi/drivers/pcl726.c            |    7 +--
 drivers/staging/comedi/drivers/pcl730.c            |    6 +--
 drivers/staging/comedi/drivers/pcl812.c            |    7 +--
 drivers/staging/comedi/drivers/pcl816.c            |   62 +++++++-----------
 drivers/staging/comedi/drivers/pcl818.c            |   66 ++++++++------------
 drivers/staging/comedi/drivers/pcm3724.c           |    4 +-
 drivers/staging/comedi/drivers/pcm3730.c           |    6 +--
 drivers/staging/comedi/drivers/pcmad.c             |    7 +--
 drivers/staging/comedi/drivers/pcmda12.c           |    5 +-
 drivers/staging/comedi/drivers/pcmmio.c            |    8 +--
 drivers/staging/comedi/drivers/pcmuio.c            |    8 +--
 drivers/staging/comedi/drivers/poc.c               |    7 +--
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |   16 +----
 drivers/staging/comedi/drivers/rtd520.c            |   33 +----------
 drivers/staging/comedi/drivers/rti800.c            |    7 +--
 drivers/staging/comedi/drivers/rti802.c            |    6 +--
 drivers/staging/comedi/drivers/s526.c              |    6 +--
 drivers/staging/comedi/drivers/s626.c              |    8 +--
 drivers/staging/comedi/drivers/serial2002.c        |    4 +-
 drivers/staging/comedi/drivers/skel.c              |    7 +--
 drivers/staging/comedi/drivers/ssv_dnp.c           |    8 +--
 drivers/staging/comedi/drivers/unioxx5.c           |    4 +-
 drivers/staging/comedi/drivers/usbdux.c            |   35 +++--------
 drivers/staging/comedi/drivers/usbduxfast.c        |   44 +++----------
 drivers/staging/comedi/drivers/usbduxsigma.c       |   36 +++--------
 drivers/staging/comedi/drivers/vmk80xx.c           |   32 +++-------
 109 files changed, 235 insertions(+), 992 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 92a1199..2f1fe07 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -189,7 +189,7 @@ struct comedi_driver {
 	const char *driver_name;
 	struct module *module;
 	int (*attach) (struct comedi_device *, struct comedi_devconfig *);
-	int (*detach) (struct comedi_device *);
+	void (*detach) (struct comedi_device *);
 	int (*attach_pci) (struct comedi_device *, struct pci_dev *);
 	int (*attach_usb) (struct comedi_device *, struct usb_interface *);
 
diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index f709107..27e39e4 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -417,14 +417,12 @@ static int dev_8255_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int dev_8255_detach(struct comedi_device *dev)
+static void dev_8255_detach(struct comedi_device *dev)
 {
 	int i;
 	unsigned long iobase;
 	struct comedi_subdevice *s;
 
-	printk(KERN_INFO "comedi%d: 8255: remove\n", dev->minor);
-
 	for (i = 0; i < dev->n_subdevices; i++) {
 		s = dev->subdevices + i;
 		if (s->type != COMEDI_SUBD_UNUSED) {
@@ -433,8 +431,6 @@ static int dev_8255_detach(struct comedi_device *dev)
 		}
 		subdev_8255_cleanup(dev, s);
 	}
-
-	return 0;
 }
 
 static struct comedi_driver dev_8255_driver = {
diff --git a/drivers/staging/comedi/drivers/acl7225b.c b/drivers/staging/comedi/drivers/acl7225b.c
index e5f8729..4e4fc41 100644
--- a/drivers/staging/comedi/drivers/acl7225b.c
+++ b/drivers/staging/comedi/drivers/acl7225b.c
@@ -119,14 +119,10 @@ static int acl7225b_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int acl7225b_detach(struct comedi_device *dev)
+static void acl7225b_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: acl7225b: remove\n", dev->minor);
-
 	if (dev->iobase)
 		release_region(dev->iobase, this_board->io_range);
-
-	return 0;
 }
 
 static const struct boardtype boardtypes[] = {
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.c b/drivers/staging/comedi/drivers/addi-data/addi_common.c
index 49d11ef..32c8e5e 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.c
@@ -2942,50 +2942,22 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-/*
-+----------------------------------------------------------------------------+
-| Function name     : static int i_ADDI_Detach(struct comedi_device *dev)           |
-|                                        									 |
-|                                            						         |
-+----------------------------------------------------------------------------+
-| Task              : Deallocates resources of the addi_common driver        |
-|			  Free the DMA buffers, unregister irq.				     |
-|                     										                 |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev									 |
-|                     														 |
-|                                                 					         |
-+----------------------------------------------------------------------------+
-| Return Value      : 0             					                     |
-|                    													     |
-+----------------------------------------------------------------------------+
-*/
-
-static int i_ADDI_Detach(struct comedi_device *dev)
+static void i_ADDI_Detach(struct comedi_device *dev)
 {
-
 	if (dev->private) {
-		if (devpriv->b_ValidDriver) {
+		if (devpriv->b_ValidDriver)
 			i_ADDI_Reset(dev);
-		}
-
-		if (dev->irq) {
+		if (dev->irq)
 			free_irq(dev->irq, dev);
-		}
-
-		if ((this_board->pc_EepromChip == NULL)
-			|| (strcmp(this_board->pc_EepromChip,
-					ADDIDATA_9054) != 0)) {
-			if (devpriv->allocated) {
+		if ((this_board->pc_EepromChip == NULL) ||
+		    (strcmp(this_board->pc_EepromChip, ADDIDATA_9054) != 0)) {
+			if (devpriv->allocated)
 				i_pci_card_free(devpriv->amcc);
-			}
-
 			if (devpriv->ul_DmaBufferVirtual[0]) {
 				free_pages((unsigned long)devpriv->
 					ul_DmaBufferVirtual[0],
 					devpriv->ui_DmaBufferPages[0]);
 			}
-
 			if (devpriv->ul_DmaBufferVirtual[1]) {
 				free_pages((unsigned long)devpriv->
 					ul_DmaBufferVirtual[1],
@@ -2993,20 +2965,14 @@ static int i_ADDI_Detach(struct comedi_device *dev)
 			}
 		} else {
 			iounmap(devpriv->dw_AiBase);
-
-			if (devpriv->allocated) {
+			if (devpriv->allocated)
 				i_pci_card_free(devpriv->amcc);
-			}
 		}
-
 		if (pci_list_builded) {
-			/* v_pci_card_list_cleanup(PCI_VENDOR_ID_AMCC); */
 			v_pci_card_list_cleanup(this_board->i_VendorId);
 			pci_list_builded = 0;
 		}
 	}
-
-	return 0;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.h b/drivers/staging/comedi/drivers/addi-data/addi_common.h
index 0a153fe..2c3f347 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.h
@@ -416,7 +416,7 @@ static unsigned short pci_list_builded;	/* set to 1 when list of card is known *
 
 /* Function declarations */
 static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int i_ADDI_Detach(struct comedi_device *dev);
+static void i_ADDI_Detach(struct comedi_device *dev);
 static int i_ADDI_Reset(struct comedi_device *dev);
 
 static irqreturn_t v_ADDI_Interrupt(int irq, void *d);
diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index f9fefef..de8c68a 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -330,17 +330,13 @@ static int pci6208_attach(struct comedi_device *dev,
 	return 1;
 }
 
-static int pci6208_detach(struct comedi_device *dev)
+static void pci6208_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: pci6208: remove\n", dev->minor);
-
 	if (devpriv && devpriv->pci_dev) {
 		if (dev->iobase)
 			comedi_pci_disable(devpriv->pci_dev);
 		pci_dev_put(devpriv->pci_dev);
 	}
-
-	return 0;
 }
 
 static struct comedi_driver adl_pci6208_driver = {
diff --git a/drivers/staging/comedi/drivers/adl_pci7230.c b/drivers/staging/comedi/drivers/adl_pci7230.c
index 430ec73..e8053bc 100644
--- a/drivers/staging/comedi/drivers/adl_pci7230.c
+++ b/drivers/staging/comedi/drivers/adl_pci7230.c
@@ -150,17 +150,13 @@ static int adl_pci7230_attach(struct comedi_device *dev,
 	return 1;
 }
 
-static int adl_pci7230_detach(struct comedi_device *dev)
+static void adl_pci7230_detach(struct comedi_device *dev)
 {
-	printk(KERN_DEBUG "comedi%d: pci7230: remove\n", dev->minor);
-
 	if (devpriv && devpriv->pci_dev) {
 		if (dev->iobase)
 			comedi_pci_disable(devpriv->pci_dev);
 		pci_dev_put(devpriv->pci_dev);
 	}
-
-	return 0;
 }
 
 static struct comedi_driver adl_pci7230_driver = {
diff --git a/drivers/staging/comedi/drivers/adl_pci7296.c b/drivers/staging/comedi/drivers/adl_pci7296.c
index a84a384..b4dae3b 100644
--- a/drivers/staging/comedi/drivers/adl_pci7296.c
+++ b/drivers/staging/comedi/drivers/adl_pci7296.c
@@ -134,25 +134,19 @@ static int adl_pci7296_attach(struct comedi_device *dev,
 	return -EIO;
 }
 
-static int adl_pci7296_detach(struct comedi_device *dev)
+static void adl_pci7296_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: pci7432: remove\n", dev->minor);
-
 	if (devpriv && devpriv->pci_dev) {
 		if (dev->iobase)
 			comedi_pci_disable(devpriv->pci_dev);
 		pci_dev_put(devpriv->pci_dev);
 	}
-	/*  detach four 8255 digital io subdevices */
 	if (dev->subdevices) {
 		subdev_8255_cleanup(dev, dev->subdevices + 0);
 		subdev_8255_cleanup(dev, dev->subdevices + 1);
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
 		subdev_8255_cleanup(dev, dev->subdevices + 3);
-
 	}
-
-	return 0;
 }
 
 static struct comedi_driver adl_pci7296_driver = {
diff --git a/drivers/staging/comedi/drivers/adl_pci7432.c b/drivers/staging/comedi/drivers/adl_pci7432.c
index 330be9d..9cbfb61 100644
--- a/drivers/staging/comedi/drivers/adl_pci7432.c
+++ b/drivers/staging/comedi/drivers/adl_pci7432.c
@@ -161,17 +161,13 @@ static int adl_pci7432_attach(struct comedi_device *dev,
 	return -EIO;
 }
 
-static int adl_pci7432_detach(struct comedi_device *dev)
+static void adl_pci7432_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: pci7432: remove\n", dev->minor);
-
 	if (devpriv && devpriv->pci_dev) {
 		if (dev->iobase)
 			comedi_pci_disable(devpriv->pci_dev);
 		pci_dev_put(devpriv->pci_dev);
 	}
-
-	return 0;
 }
 
 static struct comedi_driver adl_pci7432_driver = {
diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c b/drivers/staging/comedi/drivers/adl_pci8164.c
index 9c5906b..409ef13 100644
--- a/drivers/staging/comedi/drivers/adl_pci8164.c
+++ b/drivers/staging/comedi/drivers/adl_pci8164.c
@@ -314,17 +314,13 @@ static int adl_pci8164_attach(struct comedi_device *dev,
 	return -EIO;
 }
 
-static int adl_pci8164_detach(struct comedi_device *dev)
+static void adl_pci8164_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: pci8164: remove\n", dev->minor);
-
 	if (devpriv && devpriv->pci_dev) {
 		if (dev->iobase)
 			comedi_pci_disable(devpriv->pci_dev);
 		pci_dev_put(devpriv->pci_dev);
 	}
-
-	return 0;
 }
 
 static struct comedi_driver adl_pci8164_driver = {
diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 31dfd86..ccfb1a5 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -1382,29 +1382,19 @@ found:
 	return 0;
 }
 
-/*  Detach */
-
-static int pci9111_detach(struct comedi_device *dev)
+static void pci9111_detach(struct comedi_device *dev)
 {
-	/*  Reset device */
-
 	if (dev->private != NULL) {
 		if (dev_private->is_valid)
 			pci9111_reset(dev);
-
 	}
-	/*  Release previously allocated irq */
-
 	if (dev->irq != 0)
 		free_irq(dev->irq, dev);
-
 	if (dev_private != NULL && dev_private->pci_device != NULL) {
 		if (dev->iobase)
 			comedi_pci_disable(dev_private->pci_device);
 		pci_dev_put(dev_private->pci_device);
 	}
-
-	return 0;
 }
 
 static struct comedi_driver adl_pci9111_driver = {
diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index dd9dfec..7864586 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -2353,7 +2353,7 @@ static int pci9118_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int pci9118_detach(struct comedi_device *dev)
+static void pci9118_detach(struct comedi_device *dev)
 {
 	if (dev->private) {
 		if (devpriv->valid)
@@ -2373,8 +2373,6 @@ static int pci9118_detach(struct comedi_device *dev)
 			free_pages((unsigned long)devpriv->dmabuf_virt[1],
 				   devpriv->dmabuf_pages[1]);
 	}
-
-	return 0;
 }
 
 static const struct boardtype boardtypes[] = {
diff --git a/drivers/staging/comedi/drivers/adq12b.c b/drivers/staging/comedi/drivers/adq12b.c
index 6a68d53..7d585a1 100644
--- a/drivers/staging/comedi/drivers/adq12b.c
+++ b/drivers/staging/comedi/drivers/adq12b.c
@@ -324,16 +324,11 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int adq12b_detach(struct comedi_device *dev)
+static void adq12b_detach(struct comedi_device *dev)
 {
 	if (dev->iobase)
 		release_region(dev->iobase, ADQ12B_SIZE);
-
 	kfree(devpriv);
-
-	printk(KERN_INFO "comedi%d: adq12b: removed\n", dev->minor);
-
-	return 0;
 }
 
 static const struct adq12b_board adq12b_boards[] = {
diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index ff61dff..de8c98c 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -1551,7 +1551,7 @@ static int pci1710_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int pci1710_detach(struct comedi_device *dev)
+static void pci1710_detach(struct comedi_device *dev)
 {
 	if (dev->private) {
 		if (devpriv->valid)
@@ -1561,12 +1561,9 @@ static int pci1710_detach(struct comedi_device *dev)
 		if (devpriv->pcidev) {
 			if (dev->iobase)
 				comedi_pci_disable(devpriv->pcidev);
-
 			pci_dev_put(devpriv->pcidev);
 		}
 	}
-
-	return 0;
 }
 
 static struct comedi_driver adv_pci1710_driver = {
diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index 6356bd8..336addc 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -431,22 +431,17 @@ static int pci1723_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int pci1723_detach(struct comedi_device *dev)
+static void pci1723_detach(struct comedi_device *dev)
 {
-	printk(KERN_ERR "comedi%d: pci1723: remove\n", dev->minor);
-
 	if (dev->private) {
 		if (devpriv->valid)
 			pci1723_reset(dev);
-
 		if (devpriv->pcidev) {
 			if (dev->iobase)
 				comedi_pci_disable(devpriv->pcidev);
 			pci_dev_put(devpriv->pcidev);
 		}
 	}
-
-	return 0;
 }
 
 static struct comedi_driver adv_pci1723_driver = {
diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 9d3868e..43a32dc 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -1210,7 +1210,7 @@ static int pci_dio_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int pci_dio_detach(struct comedi_device *dev)
+static void pci_dio_detach(struct comedi_device *dev)
 {
 	int i, j;
 	struct comedi_subdevice *s;
@@ -1219,20 +1219,14 @@ static int pci_dio_detach(struct comedi_device *dev)
 	if (dev->private) {
 		if (devpriv->valid)
 			pci_dio_reset(dev);
-
-
-		/* This shows the silliness of using this kind of
-		 * scheme for numbering subdevices.  Don't do it.  --ds */
 		subdev = 0;
 		for (i = 0; i < MAX_DI_SUBDEVS; i++) {
 			if (this_board->sdi[i].chans)
 				subdev++;
-
 		}
 		for (i = 0; i < MAX_DO_SUBDEVS; i++) {
 			if (this_board->sdo[i].chans)
 				subdev++;
-
 		}
 		for (i = 0; i < MAX_DIO_SUBDEVG; i++) {
 			for (j = 0; j < this_board->sdio[i].regs; j++) {
@@ -1241,37 +1235,27 @@ static int pci_dio_detach(struct comedi_device *dev)
 				subdev++;
 			}
 		}
-
 		if (this_board->boardid.chans)
 			subdev++;
-
 		for (i = 0; i < MAX_8254_SUBDEVS; i++)
 			if (this_board->s8254[i].chans)
 				subdev++;
-
 		for (i = 0; i < dev->n_subdevices; i++) {
 			s = dev->subdevices + i;
 			s->private = NULL;
 		}
-
 		if (devpriv->pcidev) {
 			if (dev->iobase)
 				comedi_pci_disable(devpriv->pcidev);
-
 			pci_dev_put(devpriv->pcidev);
 		}
-
 		if (devpriv->prev)
 			devpriv->prev->next = devpriv->next;
 		else
 			pci_priv = devpriv->next;
-
 		if (devpriv->next)
 			devpriv->next->prev = devpriv->prev;
-
 	}
-
-	return 0;
 }
 
 static struct comedi_driver adv_pci_dio_driver = {
diff --git a/drivers/staging/comedi/drivers/aio_aio12_8.c b/drivers/staging/comedi/drivers/aio_aio12_8.c
index 1a28e67..64d82bc 100644
--- a/drivers/staging/comedi/drivers/aio_aio12_8.c
+++ b/drivers/staging/comedi/drivers/aio_aio12_8.c
@@ -209,12 +209,11 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int aio_aio12_8_detach(struct comedi_device *dev)
+static void aio_aio12_8_detach(struct comedi_device *dev)
 {
 	subdev_8255_cleanup(dev, &dev->subdevices[2]);
 	if (dev->iobase)
 		release_region(dev->iobase, 24);
-	return 0;
 }
 
 static struct comedi_driver aio_aio12_8_driver = {
diff --git a/drivers/staging/comedi/drivers/aio_iiro_16.c b/drivers/staging/comedi/drivers/aio_iiro_16.c
index 242255c..04f6f94 100644
--- a/drivers/staging/comedi/drivers/aio_iiro_16.c
+++ b/drivers/staging/comedi/drivers/aio_iiro_16.c
@@ -149,14 +149,10 @@ static int aio_iiro_16_attach(struct comedi_device *dev,
 	return 1;
 }
 
-static int aio_iiro_16_detach(struct comedi_device *dev)
+static void aio_iiro_16_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: aio_iiro_16: remove\n", dev->minor);
-
 	if (dev->iobase)
 		release_region(dev->iobase, AIO_IIRO_16_SIZE);
-
-	return 0;
 }
 
 static struct comedi_driver aio_iiro_16_driver = {
diff --git a/drivers/staging/comedi/drivers/amplc_dio200.c b/drivers/staging/comedi/drivers/amplc_dio200.c
index cbfa0cd..c9c5d97 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200.c
@@ -493,7 +493,7 @@ struct dio200_subdev_intr {
  */
 static int dio200_attach(struct comedi_device *dev,
 			 struct comedi_devconfig *it);
-static int dio200_detach(struct comedi_device *dev);
+static void dio200_detach(struct comedi_device *dev);
 static struct comedi_driver driver_amplc_dio200 = {
 	.driver_name = DIO200_DRIVER_NAME,
 	.module = THIS_MODULE,
@@ -1518,22 +1518,11 @@ static int dio200_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 1;
 }
 
-/*
- * _detach is called to deconfigure a device.  It should deallocate
- * resources.
- * This function is also called when _attach() fails, so it should be
- * careful not to release resources that were not necessarily
- * allocated by _attach().  dev->private and dev->subdevices are
- * deallocated automatically by the core.
- */
-static int dio200_detach(struct comedi_device *dev)
+static void dio200_detach(struct comedi_device *dev)
 {
 	const struct dio200_layout_struct *layout;
 	unsigned n;
 
-	printk(KERN_DEBUG "comedi%d: %s: detach\n", dev->minor,
-	       DIO200_DRIVER_NAME);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (dev->subdevices) {
@@ -1570,11 +1559,6 @@ static int dio200_detach(struct comedi_device *dev)
 #endif
 		}
 	}
-	if (dev->board_name)
-		printk(KERN_INFO "comedi%d: %s removed\n",
-		       dev->minor, dev->board_name);
-
-	return 0;
 }
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 821cf1d..57ba322 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -176,7 +176,7 @@ struct pc236_private {
  * the device code.
  */
 static int pc236_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int pc236_detach(struct comedi_device *dev);
+static void pc236_detach(struct comedi_device *dev);
 static struct comedi_driver driver_amplc_pc236 = {
 	.driver_name = PC236_DRIVER_NAME,
 	.module = THIS_MODULE,
@@ -477,21 +477,10 @@ static int pc236_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 1;
 }
 
-/*
- * _detach is called to deconfigure a device.  It should deallocate
- * resources.
- * This function is also called when _attach() fails, so it should be
- * careful not to release resources that were not necessarily
- * allocated by _attach().  dev->private and dev->subdevices are
- * deallocated automatically by the core.
- */
-static int pc236_detach(struct comedi_device *dev)
+static void pc236_detach(struct comedi_device *dev)
 {
-	printk(KERN_DEBUG "comedi%d: %s: detach\n", dev->minor,
-	       PC236_DRIVER_NAME);
 	if (devpriv)
 		pc236_intr_disable(dev);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (dev->subdevices)
@@ -511,11 +500,6 @@ static int pc236_detach(struct comedi_device *dev)
 #endif
 		}
 	}
-	if (dev->board_name) {
-		printk(KERN_INFO "comedi%d: %s removed\n",
-		       dev->minor, dev->board_name);
-	}
-	return 0;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/amplc_pc263.c b/drivers/staging/comedi/drivers/amplc_pc263.c
index 58ef6e4..974d745 100644
--- a/drivers/staging/comedi/drivers/amplc_pc263.c
+++ b/drivers/staging/comedi/drivers/amplc_pc263.c
@@ -141,7 +141,7 @@ struct pc263_private {
  * the device code.
  */
 static int pc263_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int pc263_detach(struct comedi_device *dev);
+static void pc263_detach(struct comedi_device *dev);
 static struct comedi_driver driver_amplc_pc263 = {
 	.driver_name = PC263_DRIVER_NAME,
 	.module = THIS_MODULE,
@@ -355,19 +355,8 @@ static int pc263_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 1;
 }
 
-/*
- * _detach is called to deconfigure a device.  It should deallocate
- * resources.
- * This function is also called when _attach() fails, so it should be
- * careful not to release resources that were not necessarily
- * allocated by _attach().  dev->private and dev->subdevices are
- * deallocated automatically by the core.
- */
-static int pc263_detach(struct comedi_device *dev)
+static void pc263_detach(struct comedi_device *dev)
 {
-	printk(KERN_DEBUG "comedi%d: %s: detach\n", dev->minor,
-	       PC263_DRIVER_NAME);
-
 #ifdef CONFIG_COMEDI_AMPLC_PC263_PCI
 	if (devpriv)
 #endif
@@ -386,11 +375,6 @@ static int pc263_detach(struct comedi_device *dev)
 #endif
 		}
 	}
-	if (dev->board_name) {
-		printk(KERN_INFO "comedi%d: %s removed\n",
-		       dev->minor, dev->board_name);
-	}
-	return 0;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 8b515f3..fbf19ca 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -1522,13 +1522,10 @@ pci224_attach_pci(struct comedi_device *dev, struct pci_dev *pci_dev)
 	return pci224_attach_common(dev, pci_dev, NULL);
 }
 
-static int pci224_detach(struct comedi_device *dev)
+static void pci224_detach(struct comedi_device *dev)
 {
-	printk(KERN_DEBUG "comedi%d: %s: detach\n", dev->minor, DRIVER_NAME);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
 	if (dev->subdevices) {
 		struct comedi_subdevice *s;
 
@@ -1543,16 +1540,9 @@ static int pci224_detach(struct comedi_device *dev)
 		if (devpriv->pci_dev) {
 			if (dev->iobase)
 				comedi_pci_disable(devpriv->pci_dev);
-
 			pci_dev_put(devpriv->pci_dev);
 		}
 	}
-	if (dev->board_name) {
-		printk(KERN_INFO "comedi%d: %s removed\n",
-		       dev->minor, dev->board_name);
-	}
-
-	return 0;
 }
 
 static struct comedi_driver amplc_pci224_driver = {
diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 2a23f15..d4c80b1 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -937,35 +937,19 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 1;
 }
 
-/*
- * _detach is called to deconfigure a device.  It should deallocate
- * resources.
- * This function is also called when _attach() fails, so it should be
- * careful not to release resources that were not necessarily
- * allocated by _attach().  dev->private and dev->subdevices are
- * deallocated automatically by the core.
- */
-static int pci230_detach(struct comedi_device *dev)
+static void pci230_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: amplc_pci230: remove\n", dev->minor);
-
 	if (dev->subdevices && thisboard->have_dio)
-		/* Clean up dio subdevice. */
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
 	if (devpriv) {
 		if (devpriv->pci_dev) {
 			if (dev->iobase)
 				comedi_pci_disable(devpriv->pci_dev);
-
 			pci_dev_put(devpriv->pci_dev);
 		}
 	}
-
-	return 0;
 }
 
 static int get_resources(struct comedi_device *dev, unsigned int res_mask,
diff --git a/drivers/staging/comedi/drivers/c6xdigio.c b/drivers/staging/comedi/drivers/c6xdigio.c
index 56dd33a..fb9951a 100644
--- a/drivers/staging/comedi/drivers/c6xdigio.c
+++ b/drivers/staging/comedi/drivers/c6xdigio.c
@@ -397,10 +397,6 @@ static void board_init(struct comedi_device *dev)
 
 }
 
-/* static void board_halt(struct comedi_device *dev) { */
-/* C6X_pwmInit(dev->iobase); */
-/* } */
-
 /*
    options[0] - I/O port
    options[1] - irq
@@ -490,22 +486,13 @@ static int c6xdigio_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int c6xdigio_detach(struct comedi_device *dev)
+static void c6xdigio_detach(struct comedi_device *dev)
 {
-	/* board_halt(dev);  may not need this */
-
-	printk(KERN_DEBUG "comedi%d: c6xdigio: remove\n", dev->minor);
-
 	if (dev->iobase)
 		release_region(dev->iobase, C6XDIGIO_SIZE);
-
-	/*  Not using IRQ so I am not sure if I need this */
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
 	pnp_unregister_driver(&c6xdigio_pnp_driver);
-
-	return 0;
 }
 
 static struct comedi_driver c6xdigio_driver = {
diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 49404f4..3515923 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -91,7 +91,7 @@ struct das16cs_private {
 
 static int das16cs_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it);
-static int das16cs_detach(struct comedi_device *dev);
+static void das16cs_detach(struct comedi_device *dev);
 static struct comedi_driver driver_das16cs = {
 	.driver_name = "cb_das16_cs",
 	.module = THIS_MODULE,
@@ -255,15 +255,10 @@ static int das16cs_attach(struct comedi_device *dev,
 	return 1;
 }
 
-static int das16cs_detach(struct comedi_device *dev)
+static void das16cs_detach(struct comedi_device *dev)
 {
-	dev_dbg(dev->hw_dev, "comedi%d: das16cs: remove\n", dev->minor);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
-
-	return 0;
 }
 
 static irqreturn_t das16cs_interrupt(int irq, void *d)
diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 7e11910..ee9e084 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -726,26 +726,12 @@ found:
 	return 1;
 }
 
-/*
- * cb_pcidas_detach is called to deconfigure a device.  It should deallocate
- * resources.
- * This function is also called when _attach() fails, so it should be
- * careful not to release resources that were not necessarily
- * allocated by _attach().  dev->private and dev->subdevices are
- * deallocated automatically by the core.
- */
-static int cb_pcidas_detach(struct comedi_device *dev)
+static void cb_pcidas_detach(struct comedi_device *dev)
 {
-
 	if (devpriv) {
 		if (devpriv->s5933_config) {
-			/*  disable and clear interrupts on amcc s5933 */
 			outl(INTCSR_INBOX_INTR_STATUS,
 			     devpriv->s5933_config + AMCC_OP_REG_INTCSR);
-#ifdef CB_PCIDAS_DEBUG
-			dev_dbg(dev->hw_dev, "detaching, incsr is 0x%x\n",
-				inl(devpriv->s5933_config + AMCC_OP_REG_INTCSR));
-#endif
 		}
 	}
 	if (dev->irq)
@@ -757,8 +743,6 @@ static int cb_pcidas_detach(struct comedi_device *dev)
 			comedi_pci_disable(devpriv->pci_dev);
 		pci_dev_put(devpriv->pci_dev);
 	}
-
-	return 0;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index bea5120..9d0b875 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1790,15 +1790,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-/*
- * _detach is called to deconfigure a device.  It should deallocate
- * resources.
- * This function is also called when _attach() fails, so it should be
- * careful not to release resources that were not necessarily
- * allocated by _attach().  dev->private and dev->subdevices are
- * deallocated automatically by the core.
- */
-static int detach(struct comedi_device *dev)
+static void detach(struct comedi_device *dev)
 {
 	unsigned int i;
 
@@ -1860,8 +1852,6 @@ static int detach(struct comedi_device *dev)
 	}
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 4);
-
-	return 0;
 }
 
 static int ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 31b21aa..25ebca1 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -374,19 +374,8 @@ found:
 	return 1;
 }
 
-/*
- * _detach is called to deconfigure a device.  It should deallocate
- * resources.
- * This function is also called when _attach() fails, so it should be
- * careful not to release resources that were not necessarily
- * allocated by _attach().  dev->private and dev->subdevices are
- * deallocated automatically by the core.
- */
-static int cb_pcidda_detach(struct comedi_device *dev)
+static void cb_pcidda_detach(struct comedi_device *dev)
 {
-/*
- * Deallocate the I/O ports.
- */
 	if (devpriv) {
 		if (devpriv->pci_dev) {
 			if (devpriv->dac)
@@ -394,13 +383,10 @@ static int cb_pcidda_detach(struct comedi_device *dev)
 			pci_dev_put(devpriv->pci_dev);
 		}
 	}
-	/*  cleanup 8255 */
 	if (dev->subdevices) {
 		subdev_8255_cleanup(dev, dev->subdevices + 1);
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
 	}
-
-	return 0;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 47a2c9b..713132c 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -195,7 +195,7 @@ found:
 	return 1;
 }
 
-static int pcidio_detach(struct comedi_device *dev)
+static void pcidio_detach(struct comedi_device *dev)
 {
 	if (devpriv) {
 		if (devpriv->pci_dev) {
@@ -209,7 +209,6 @@ static int pcidio_detach(struct comedi_device *dev)
 		for (i = 0; i < thisboard->n_8255; i++)
 			subdev_8255_cleanup(dev, dev->subdevices + i);
 	}
-	return 0;
 }
 
 static struct comedi_driver cb_pcidio_driver = {
diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 31541e1..5f834d0 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -310,29 +310,8 @@ found:
 	return 1;
 }
 
-/*
- * _detach is called to deconfigure a device.  It should deallocate
- * resources.
- * This function is also called when _attach() fails, so it should be
- * careful not to release resources that were not necessarily
- * allocated by _attach().  dev->private and dev->subdevices are
- * deallocated automatically by the core.
- */
-static int cb_pcimdas_detach(struct comedi_device *dev)
+static void cb_pcimdas_detach(struct comedi_device *dev)
 {
-	if (devpriv) {
-		dev_dbg(dev->hw_dev, "devpriv->BADR0 = 0x%lx\n",
-			devpriv->BADR0);
-		dev_dbg(dev->hw_dev, "devpriv->BADR1 = 0x%lx\n",
-			devpriv->BADR1);
-		dev_dbg(dev->hw_dev, "devpriv->BADR2 = 0x%lx\n",
-			devpriv->BADR2);
-		dev_dbg(dev->hw_dev, "devpriv->BADR3 = 0x%lx\n",
-			devpriv->BADR3);
-		dev_dbg(dev->hw_dev, "devpriv->BADR4 = 0x%lx\n",
-			devpriv->BADR4);
-	}
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (devpriv) {
@@ -342,8 +321,6 @@ static int cb_pcimdas_detach(struct comedi_device *dev)
 			pci_dev_put(devpriv->pci_dev);
 		}
 	}
-
-	return 0;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 857d0c3..b339685 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -150,7 +150,6 @@ struct board_private_struct {
 	unsigned long registers;	/* set by probe */
 	unsigned long dio_registers;
 	char attached_to_8255;	/* boolean */
-	char attached_successfully;	/* boolean */
 	/* would be useful for a PCI device */
 	struct pci_dev *pci_dev;
 
@@ -283,44 +282,24 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	devpriv->attached_successfully = 1;
-
 	printk("attached\n");
 
 	return 1;
 }
 
-/*
- * _detach is called to deconfigure a device.  It should deallocate
- * resources.
- * This function is also called when _attach() fails, so it should be
- * careful not to release resources that were not necessarily
- * allocated by _attach().  dev->private and dev->subdevices are
- * deallocated automatically by the core.
- */
-static int detach(struct comedi_device *dev)
+static void detach(struct comedi_device *dev)
 {
 	if (devpriv) {
-
 		if (dev->subdevices && devpriv->attached_to_8255) {
-			/* de-register us from the 8255 driver */
 			subdev_8255_cleanup(dev, dev->subdevices + 2);
 			devpriv->attached_to_8255 = 0;
 		}
-
 		if (devpriv->pci_dev) {
 			if (devpriv->registers)
 				comedi_pci_disable(devpriv->pci_dev);
 			pci_dev_put(devpriv->pci_dev);
 		}
-
-		if (devpriv->attached_successfully && thisboard)
-			printk("comedi%d: %s: detached\n", dev->minor,
-			       thisboard->name);
-
 	}
-
-	return 0;
 }
 
 static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 4507bab..29412de 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -332,30 +332,6 @@ static int doDevConfig(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 1;
 }
 
-static void doDevUnconfig(struct comedi_device *dev)
-{
-	unsigned long devs_closed = 0;
-
-	if (devpriv) {
-		while (devpriv->ndevs-- && devpriv->devs) {
-			struct BondedDevice *bdev;
-
-			bdev = devpriv->devs[devpriv->ndevs];
-			if (!bdev)
-				continue;
-			if (!(devs_closed & (0x1 << bdev->minor))) {
-				comedi_close(bdev->dev);
-				devs_closed |= (0x1 << bdev->minor);
-			}
-			kfree(bdev);
-		}
-		kfree(devpriv->devs);
-		devpriv->devs = NULL;
-		kfree(devpriv);
-		dev->private = NULL;
-	}
-}
-
 static int bonding_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
@@ -406,11 +382,28 @@ static int bonding_attach(struct comedi_device *dev,
 	return 1;
 }
 
-static int bonding_detach(struct comedi_device *dev)
+static void bonding_detach(struct comedi_device *dev)
 {
-	LOG_MSG("comedi%d: remove\n", dev->minor);
-	doDevUnconfig(dev);
-	return 0;
+	unsigned long devs_closed = 0;
+
+	if (devpriv) {
+		while (devpriv->ndevs-- && devpriv->devs) {
+			struct BondedDevice *bdev;
+
+			bdev = devpriv->devs[devpriv->ndevs];
+			if (!bdev)
+				continue;
+			if (!(devs_closed & (0x1 << bdev->minor))) {
+				comedi_close(bdev->dev);
+				devs_closed |= (0x1 << bdev->minor);
+			}
+			kfree(bdev);
+		}
+		kfree(devpriv->devs);
+		devpriv->devs = NULL;
+		kfree(devpriv);
+		dev->private = NULL;
+	}
 }
 
 static const struct BondingBoard bondingBoards[] = {
diff --git a/drivers/staging/comedi/drivers/comedi_parport.c b/drivers/staging/comedi/drivers/comedi_parport.c
index 1172114..bff5dcd 100644
--- a/drivers/staging/comedi/drivers/comedi_parport.c
+++ b/drivers/staging/comedi/drivers/comedi_parport.c
@@ -372,17 +372,12 @@ static int parport_attach(struct comedi_device *dev,
 	return 1;
 }
 
-static int parport_detach(struct comedi_device *dev)
+static void parport_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: parport: remove\n", dev->minor);
-
 	if (dev->iobase)
 		release_region(dev->iobase, PARPORT_SIZE);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
-	return 0;
 }
 
 static struct comedi_driver parport_driver = {
diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index 6594046..873e374 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -494,14 +494,10 @@ static int waveform_attach(struct comedi_device *dev,
 	return 1;
 }
 
-static int waveform_detach(struct comedi_device *dev)
+static void waveform_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: comedi_test: remove\n", dev->minor);
-
 	if (dev->private)
 		waveform_ai_cancel(dev, dev->read_subdev);
-
-	return 0;
 }
 
 static const struct waveform_board waveform_boards[] = {
diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 9dc3a92..b8bac80 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -169,17 +169,13 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return -EIO;
 }
 
-static int contec_detach(struct comedi_device *dev)
+static void contec_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: contec: remove\n", dev->minor);
-
 	if (devpriv && devpriv->pci_dev) {
 		if (dev->iobase)
 			comedi_pci_disable(devpriv->pci_dev);
 		pci_dev_put(devpriv->pci_dev);
 	}
-
-	return 0;
 }
 
 static struct comedi_driver contec_pci_dio_driver = {
diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index dc974ce..696b58c 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -836,14 +836,12 @@ out:
 	return result;
 }
 
-static int daqboard2000_detach(struct comedi_device *dev)
+static void daqboard2000_detach(struct comedi_device *dev)
 {
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
 	if (devpriv) {
 		if (devpriv->daq)
 			iounmap(devpriv->daq);
@@ -855,7 +853,6 @@ static int daqboard2000_detach(struct comedi_device *dev)
 			pci_dev_put(devpriv->pci_dev);
 		}
 	}
-	return 0;
 }
 
 static struct comedi_driver daqboard2000_driver = {
diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index 575c5cc..1f31943 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -1079,15 +1079,10 @@ static int das08_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 }
 #endif /* DO_COMEDI_DRIVER_REGISTER */
 
-
-int das08_common_detach(struct comedi_device *dev)
+void das08_common_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: das08: remove\n", dev->minor);
-
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 4);
-
-	/*  deallocate ioports for non-pcmcia, non-pci boards */
 	if ((thisboard->bustype != pcmcia) && (thisboard->bustype != pci)) {
 		if (dev->iobase)
 			release_region(dev->iobase, thisboard->iosize);
@@ -1102,8 +1097,6 @@ int das08_common_detach(struct comedi_device *dev)
 		}
 	}
 #endif
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(das08_common_detach);
 
diff --git a/drivers/staging/comedi/drivers/das08.h b/drivers/staging/comedi/drivers/das08.h
index 2a30d76..0b92f24 100644
--- a/drivers/staging/comedi/drivers/das08.h
+++ b/drivers/staging/comedi/drivers/das08.h
@@ -74,6 +74,6 @@ struct das08_private_struct {
 extern struct das08_board_struct das08_cs_boards[NUM_DAS08_CS_BOARDS];
 
 int das08_common_attach(struct comedi_device *dev, unsigned long iobase);
-int das08_common_detach(struct comedi_device *dev);
+void das08_common_detach(struct comedi_device *dev);
 
 #endif /* _DAS08_H */
diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index 73c0a2d..998444c 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -1362,15 +1362,11 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int das16_detach(struct comedi_device *dev)
+static void das16_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: das16: remove\n", dev->minor);
-
 	das16_reset(dev);
-
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 4);
-
 	if (devpriv) {
 		int i;
 		for (i = 0; i < 2; i++) {
@@ -1385,10 +1381,8 @@ static int das16_detach(struct comedi_device *dev)
 		kfree(devpriv->user_ai_range_table);
 		kfree(devpriv->user_ao_range_table);
 	}
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
 	if (dev->iobase) {
 		if (thisboard->size < 0x400) {
 			release_region(dev->iobase, thisboard->size);
@@ -1398,8 +1392,6 @@ static int das16_detach(struct comedi_device *dev)
 				       thisboard->size & 0x3ff);
 		}
 	}
-
-	return 0;
 }
 
 static const struct das16_board das16_boards[] = {
diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index b22382e..d2e1490 100644
--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -703,23 +703,16 @@ static int das16m1_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int das16m1_detach(struct comedi_device *dev)
+static void das16m1_detach(struct comedi_device *dev)
 {
-
-/* das16m1_reset(dev); */
-
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 3);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
 	if (dev->iobase) {
 		release_region(dev->iobase, DAS16M1_SIZE);
 		release_region(dev->iobase + DAS16M1_82C55, DAS16M1_SIZE2);
 	}
-
-	return 0;
 }
 
 static const struct das16m1_board das16m1_boards[] = {
diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index 0b1f499..2ac3443 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -767,9 +767,8 @@ static int das1800_attach(struct comedi_device *dev,
 	return 0;
 };
 
-static int das1800_detach(struct comedi_device *dev)
+static void das1800_detach(struct comedi_device *dev)
 {
-	/* only free stuff if it has been allocated by _attach */
 	if (dev->iobase)
 		release_region(dev->iobase, DAS1800_SIZE);
 	if (dev->irq)
@@ -784,11 +783,6 @@ static int das1800_detach(struct comedi_device *dev)
 		kfree(devpriv->ai_buf0);
 		kfree(devpriv->ai_buf1);
 	}
-
-	dev_dbg(dev->hw_dev, "comedi%d: %s: remove\n", dev->minor,
-		dev->driver->driver_name);
-
-	return 0;
 };
 
 /* probes and checks das-1800 series board type
diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
index 889527d..881f392 100644
--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -327,14 +327,12 @@ static int das6402_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int das6402_detach(struct comedi_device *dev)
+static void das6402_detach(struct comedi_device *dev)
 {
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (dev->iobase)
 		release_region(dev->iobase, DAS6402_SIZE);
-
-	return 0;
 }
 
 static struct comedi_driver das6402_driver = {
diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/comedi/drivers/das800.c
index 6e347b4..a3a54e1 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -245,7 +245,7 @@ struct das800_private {
 
 static int das800_attach(struct comedi_device *dev,
 			 struct comedi_devconfig *it);
-static int das800_detach(struct comedi_device *dev);
+static void das800_detach(struct comedi_device *dev);
 static int das800_cancel(struct comedi_device *dev, struct comedi_subdevice *s);
 
 static struct comedi_driver driver_das800 = {
@@ -556,16 +556,12 @@ static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 };
 
-static int das800_detach(struct comedi_device *dev)
+static void das800_detach(struct comedi_device *dev)
 {
-	dev_info(dev->hw_dev, "comedi%d: das800: remove\n", dev->minor);
-
-	/* only free stuff if it has been allocated by _attach */
 	if (dev->iobase)
 		release_region(dev->iobase, DAS800_SIZE);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-	return 0;
 };
 
 static int das800_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index 2b4e6e6..8382890 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -224,7 +224,7 @@ struct dmm32at_private {
  */
 static int dmm32at_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it);
-static int dmm32at_detach(struct comedi_device *dev);
+static void dmm32at_detach(struct comedi_device *dev);
 static struct comedi_driver driver_dmm32at = {
 	.driver_name = "dmm32at",
 	.module = THIS_MODULE,
@@ -450,23 +450,12 @@ static int dmm32at_attach(struct comedi_device *dev,
 
 }
 
-/*
- * _detach is called to deconfigure a device.  It should deallocate
- * resources.
- * This function is also called when _attach() fails, so it should be
- * careful not to release resources that were not necessarily
- * allocated by _attach().  dev->private and dev->subdevices are
- * deallocated automatically by the core.
- */
-static int dmm32at_detach(struct comedi_device *dev)
+static void dmm32at_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: dmm32at: remove\n", dev->minor);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (dev->iobase)
 		release_region(dev->iobase, DMM32AT_MEMSIZE);
-
-	return 0;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/dt2801.c b/drivers/staging/comedi/drivers/dt2801.c
index 7aafd85..625bd61 100644
--- a/drivers/staging/comedi/drivers/dt2801.c
+++ b/drivers/staging/comedi/drivers/dt2801.c
@@ -693,12 +693,10 @@ out:
 	return ret;
 }
 
-static int dt2801_detach(struct comedi_device *dev)
+static void dt2801_detach(struct comedi_device *dev)
 {
 	if (dev->iobase)
 		release_region(dev->iobase, DT2801_IOSIZE);
-
-	return 0;
 }
 
 static struct comedi_driver dt2801_driver = {
diff --git a/drivers/staging/comedi/drivers/dt2811.c b/drivers/staging/comedi/drivers/dt2811.c
index 2292426..106ffea 100644
--- a/drivers/staging/comedi/drivers/dt2811.c
+++ b/drivers/staging/comedi/drivers/dt2811.c
@@ -571,16 +571,12 @@ static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int dt2811_detach(struct comedi_device *dev)
+static void dt2811_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: dt2811: remove\n", dev->minor);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (dev->iobase)
 		release_region(dev->iobase, DT2811_SIZE);
-
-	return 0;
 }
 
 static const struct dt2811_board boardtypes[] = {
diff --git a/drivers/staging/comedi/drivers/dt2814.c b/drivers/staging/comedi/drivers/dt2814.c
index a935e9c..fa4ade6 100644
--- a/drivers/staging/comedi/drivers/dt2814.c
+++ b/drivers/staging/comedi/drivers/dt2814.c
@@ -361,17 +361,12 @@ static int dt2814_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int dt2814_detach(struct comedi_device *dev)
+static void dt2814_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: dt2814: remove\n", dev->minor);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
 	if (dev->iobase)
 		release_region(dev->iobase, DT2814_SIZE);
-
-	return 0;
 }
 
 static struct comedi_driver dt2814_driver = {
diff --git a/drivers/staging/comedi/drivers/dt2815.c b/drivers/staging/comedi/drivers/dt2815.c
index 152959c..bbab712 100644
--- a/drivers/staging/comedi/drivers/dt2815.c
+++ b/drivers/staging/comedi/drivers/dt2815.c
@@ -227,21 +227,12 @@ static int dt2815_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static void dt2815_free_resources(struct comedi_device *dev)
+static void dt2815_detach(struct comedi_device *dev)
 {
 	if (dev->iobase)
 		release_region(dev->iobase, DT2815_SIZE);
 }
 
-static int dt2815_detach(struct comedi_device *dev)
-{
-	printk(KERN_INFO "comedi%d: dt2815: remove\n", dev->minor);
-
-	dt2815_free_resources(dev);
-
-	return 0;
-}
-
 static struct comedi_driver dt2815_driver = {
 	.driver_name	= "dt2815",
 	.module		= THIS_MODULE,
diff --git a/drivers/staging/comedi/drivers/dt2817.c b/drivers/staging/comedi/drivers/dt2817.c
index d8149f4..1ee10e7b 100644
--- a/drivers/staging/comedi/drivers/dt2817.c
+++ b/drivers/staging/comedi/drivers/dt2817.c
@@ -159,14 +159,10 @@ static int dt2817_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int dt2817_detach(struct comedi_device *dev)
+static void dt2817_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: dt2817: remove\n", dev->minor);
-
 	if (dev->iobase)
 		release_region(dev->iobase, DT2817_SIZE);
-
-	return 0;
 }
 
 static struct comedi_driver dt2817_driver = {
diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index 461a056..736d8fa 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -1331,7 +1331,7 @@ static int dt282x_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static void free_resources(struct comedi_device *dev)
+static void dt282x_detach(struct comedi_device *dev)
 {
 	if (dev->irq)
 		free_irq(dev->irq, dev);
@@ -1349,15 +1349,6 @@ static void free_resources(struct comedi_device *dev)
 	}
 }
 
-static int dt282x_detach(struct comedi_device *dev)
-{
-	printk(KERN_INFO "comedi%d: dt282x: remove\n", dev->minor);
-
-	free_resources(dev);
-
-	return 0;
-}
-
 static const struct dt282x_board boardtypes[] = {
 	{
 		.name		= "dt2821",
diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 6d113cd..0d27326 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -944,11 +944,10 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int dt3000_detach(struct comedi_device *dev)
+static void dt3000_detach(struct comedi_device *dev)
 {
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
 	if (devpriv) {
 		if (devpriv->pci_dev) {
 			if (devpriv->phys_addr)
@@ -958,8 +957,6 @@ static int dt3000_detach(struct comedi_device *dev)
 		if (devpriv->io_addr)
 			iounmap(devpriv->io_addr);
 	}
-
-	return 0;
 }
 
 static struct comedi_driver dt3000_driver = {
diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index cd3a44a..22cda5c 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -1111,9 +1111,9 @@ static int dt9812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int dt9812_detach(struct comedi_device *dev)
+static void dt9812_detach(struct comedi_device *dev)
 {
-	return 0;
+	/* Nothing to cleanup */
 }
 
 static struct comedi_driver dt9812_comedi_driver = {
diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 23375de..b0cec7b 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -387,14 +387,12 @@ found:
 	return 1;
 }
 
-static int dyna_pci10xx_detach(struct comedi_device *dev)
+static void dyna_pci10xx_detach(struct comedi_device *dev)
 {
 	if (devpriv && devpriv->pci_dev) {
 		comedi_pci_disable(devpriv->pci_dev);
 		mutex_destroy(&devpriv->mutex);
 	}
-
-	return 0;
 }
 
 static struct comedi_driver dyna_pci10xx_driver = {
diff --git a/drivers/staging/comedi/drivers/fl512.c b/drivers/staging/comedi/drivers/fl512.c
index 25fed75..d2381445 100644
--- a/drivers/staging/comedi/drivers/fl512.c
+++ b/drivers/staging/comedi/drivers/fl512.c
@@ -174,12 +174,10 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 1;
 }
 
-static int fl512_detach(struct comedi_device *dev)
+static void fl512_detach(struct comedi_device *dev)
 {
 	if (dev->iobase)
 		release_region(dev->iobase, FL512_SIZE);
-	printk(KERN_INFO "comedi%d: fl512: dummy i detach\n", dev->minor);
-	return 0;
 }
 
 static struct comedi_driver fl512_driver = {
diff --git a/drivers/staging/comedi/drivers/gsc_hpdi.c b/drivers/staging/comedi/drivers/gsc_hpdi.c
index 3195022..8aece08 100644
--- a/drivers/staging/comedi/drivers/gsc_hpdi.c
+++ b/drivers/staging/comedi/drivers/gsc_hpdi.c
@@ -664,12 +664,10 @@ static int hpdi_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return init_hpdi(dev);
 }
 
-static int hpdi_detach(struct comedi_device *dev)
+static void hpdi_detach(struct comedi_device *dev)
 {
 	unsigned int i;
 
-	printk(KERN_WARNING "comedi%d: gsc_hpdi: remove\n", dev->minor);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if ((priv(dev)) && (priv(dev)->hw_dev)) {
@@ -702,7 +700,6 @@ static int hpdi_detach(struct comedi_device *dev)
 			comedi_pci_disable(priv(dev)->hw_dev);
 		pci_dev_put(priv(dev)->hw_dev);
 	}
-	return 0;
 }
 
 static int dio_config_block_size(struct comedi_device *dev, unsigned int *data)
diff --git a/drivers/staging/comedi/drivers/icp_multi.c b/drivers/staging/comedi/drivers/icp_multi.c
index 0f63fc0..fdc596f 100644
--- a/drivers/staging/comedi/drivers/icp_multi.c
+++ b/drivers/staging/comedi/drivers/icp_multi.c
@@ -1007,25 +1007,19 @@ static int icp_multi_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int icp_multi_detach(struct comedi_device *dev)
+static void icp_multi_detach(struct comedi_device *dev)
 {
 	if (dev->private)
 		if (devpriv->valid)
 			icp_multi_reset(dev);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
 	if (dev->private && devpriv->io_addr)
 		iounmap(devpriv->io_addr);
-
 	if (dev->private && devpriv->card)
 		pci_card_free(devpriv->card);
-
 	if (--pci_list_builded == 0)
 		pci_card_list_cleanup(PCI_VENDOR_ID_ICP);
-
-	return 0;
 }
 
 static const struct boardtype boardtypes[] = {
diff --git a/drivers/staging/comedi/drivers/ii_pci20kc.c b/drivers/staging/comedi/drivers/ii_pci20kc.c
index 6b1b5c88..f0a579a 100644
--- a/drivers/staging/comedi/drivers/ii_pci20kc.c
+++ b/drivers/staging/comedi/drivers/ii_pci20kc.c
@@ -264,11 +264,9 @@ static int pci20xxx_attach(struct comedi_device *dev,
 	return 1;
 }
 
-static int pci20xxx_detach(struct comedi_device *dev)
+static void pci20xxx_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: pci20xxx: remove\n", dev->minor);
-
-	return 0;
+	/* Nothing to cleanup */
 }
 
 /* pci20006m */
diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index beb82d9..d536a11 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -926,7 +926,7 @@ out:
 	return result;
 }
 
-static int jr3_pci_detach(struct comedi_device *dev)
+static void jr3_pci_detach(struct comedi_device *dev)
 {
 	int i;
 	struct jr3_pci_dev_private *devpriv = dev->private;
@@ -938,16 +938,13 @@ static int jr3_pci_detach(struct comedi_device *dev)
 			for (i = 0; i < devpriv->n_channels; i++)
 				kfree(dev->subdevices[i].private);
 		}
-
 		if (devpriv->iobase)
 			iounmap((void *)devpriv->iobase);
 		if (devpriv->pci_enabled)
 			comedi_pci_disable(devpriv->pci_dev);
-
 		if (devpriv->pci_dev)
 			pci_dev_put(devpriv->pci_dev);
 	}
-	return 0;
 }
 
 static struct comedi_driver jr3_pci_driver = {
diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index 708704d..09d1918 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -219,16 +219,13 @@ found:
 	return 0;
 }
 
-static int cnt_detach(struct comedi_device *dev)
+static void cnt_detach(struct comedi_device *dev)
 {
 	if (devpriv && devpriv->pcidev) {
 		if (dev->iobase)
 			comedi_pci_disable(devpriv->pcidev);
 		pci_dev_put(devpriv->pcidev);
 	}
-	printk(KERN_INFO "comedi%d: " CNT_DRIVER_NAME " remove\n",
-	       dev->minor);
-	return 0;
 }
 
 static struct comedi_driver ke_counter_driver = {
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 879acbc..8ca1b54 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -2304,10 +2304,8 @@ static int me4000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int me4000_detach(struct comedi_device *dev)
+static void me4000_detach(struct comedi_device *dev)
 {
-	CALL_PDEBUG("In me4000_detach()\n");
-
 	if (info) {
 		if (info->pci_dev_p) {
 			reset_board(dev);
@@ -2316,8 +2314,6 @@ static int me4000_detach(struct comedi_device *dev)
 			pci_dev_put(info->pci_dev_p);
 		}
 	}
-
-	return 0;
 }
 
 static struct comedi_driver me4000_driver = {
diff --git a/drivers/staging/comedi/drivers/me_daq.c b/drivers/staging/comedi/drivers/me_daq.c
index 1f99527..ffe2512 100644
--- a/drivers/staging/comedi/drivers/me_daq.c
+++ b/drivers/staging/comedi/drivers/me_daq.c
@@ -806,7 +806,7 @@ found:
 	return 0;
 }
 
-static int me_detach(struct comedi_device *dev)
+static void me_detach(struct comedi_device *dev)
 {
 	if (dev_private) {
 		if (dev_private->me_regbase) {
@@ -818,11 +818,9 @@ static int me_detach(struct comedi_device *dev)
 		if (dev_private->pci_device) {
 			if (dev_private->plx_regbase_size)
 				comedi_pci_disable(dev_private->pci_device);
-
 			pci_dev_put(dev_private->pci_device);
 		}
 	}
-	return 0;
 }
 
 static struct comedi_driver me_daq_driver = {
diff --git a/drivers/staging/comedi/drivers/mpc624.c b/drivers/staging/comedi/drivers/mpc624.c
index 25d8553..4304e86 100644
--- a/drivers/staging/comedi/drivers/mpc624.c
+++ b/drivers/staging/comedi/drivers/mpc624.c
@@ -379,14 +379,10 @@ static int mpc624_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 1;
 }
 
-static int mpc624_detach(struct comedi_device *dev)
+static void mpc624_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: mpc624: remove\n", dev->minor);
-
 	if (dev->iobase)
 		release_region(dev->iobase, MPC624_SIZE);
-
-	return 0;
 }
 
 static struct comedi_driver mpc624_driver = {
diff --git a/drivers/staging/comedi/drivers/mpc8260cpm.c b/drivers/staging/comedi/drivers/mpc8260cpm.c
index f468775..364470e4 100644
--- a/drivers/staging/comedi/drivers/mpc8260cpm.c
+++ b/drivers/staging/comedi/drivers/mpc8260cpm.c
@@ -148,11 +148,9 @@ static int mpc8260cpm_attach(struct comedi_device *dev,
 	return 1;
 }
 
-static int mpc8260cpm_detach(struct comedi_device *dev)
+static void mpc8260cpm_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: mpc8260cpm: remove\n", dev->minor);
-
-	return 0;
+	/* Nothing to cleanup */
 }
 
 static struct comedi_driver mpc8260cpm_driver = {
diff --git a/drivers/staging/comedi/drivers/multiq3.c b/drivers/staging/comedi/drivers/multiq3.c
index 206296c..e951e73 100644
--- a/drivers/staging/comedi/drivers/multiq3.c
+++ b/drivers/staging/comedi/drivers/multiq3.c
@@ -315,16 +315,12 @@ static int multiq3_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int multiq3_detach(struct comedi_device *dev)
+static void multiq3_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: multiq3: remove\n", dev->minor);
-
 	if (dev->iobase)
 		release_region(dev->iobase, MULTIQ3_SIZE);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
-	return 0;
 }
 
 static struct comedi_driver multiq3_driver = {
diff --git a/drivers/staging/comedi/drivers/ni_6527.c b/drivers/staging/comedi/drivers/ni_6527.c
index 75c146d..b02aa0e 100644
--- a/drivers/staging/comedi/drivers/ni_6527.c
+++ b/drivers/staging/comedi/drivers/ni_6527.c
@@ -78,7 +78,7 @@ Updated: Sat, 25 Jan 2003 13:24:40 -0800
 
 static int ni6527_attach(struct comedi_device *dev,
 			 struct comedi_devconfig *it);
-static int ni6527_detach(struct comedi_device *dev);
+static void ni6527_detach(struct comedi_device *dev);
 static struct comedi_driver driver_ni6527 = {
 	.driver_name = "ni6527",
 	.module = THIS_MODULE,
@@ -449,19 +449,15 @@ static int ni6527_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int ni6527_detach(struct comedi_device *dev)
+static void ni6527_detach(struct comedi_device *dev)
 {
 	if (devpriv && devpriv->mite && devpriv->mite->daq_io_addr)
 		writeb(0x00,
 		       devpriv->mite->daq_io_addr + Master_Interrupt_Control);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
 	if (devpriv && devpriv->mite)
 		mite_unsetup(devpriv->mite);
-
-	return 0;
 }
 
 static int ni6527_find_device(struct comedi_device *dev, int bus, int slot)
diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index 4a3f54ed..0d27a93 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -111,7 +111,7 @@ static inline unsigned Filter_Enable(unsigned port)
 
 static int ni_65xx_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it);
-static int ni_65xx_detach(struct comedi_device *dev);
+static void ni_65xx_detach(struct comedi_device *dev);
 static struct comedi_driver driver_ni_65xx = {
 	.driver_name = "ni_65xx",
 	.module = THIS_MODULE,
@@ -784,7 +784,7 @@ static int ni_65xx_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int ni_65xx_detach(struct comedi_device *dev)
+static void ni_65xx_detach(struct comedi_device *dev)
 {
 	if (private(dev) && private(dev)->mite
 	    && private(dev)->mite->daq_io_addr) {
@@ -792,10 +792,8 @@ static int ni_65xx_detach(struct comedi_device *dev)
 		       private(dev)->mite->daq_io_addr +
 		       Master_Interrupt_Control);
 	}
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
 	if (private(dev)) {
 		unsigned i;
 		for (i = 0; i < dev->n_subdevices; ++i) {
@@ -805,7 +803,6 @@ static int ni_65xx_detach(struct comedi_device *dev)
 		if (private(dev)->mite)
 			mite_unsetup(private(dev)->mite);
 	}
-	return 0;
 }
 
 static int ni_65xx_find_device(struct comedi_device *dev, int bus, int slot)
diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index 21eb7fb..8c40730 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -458,7 +458,7 @@ static inline const struct ni_660x_board *board(struct comedi_device *dev)
 
 static int ni_660x_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it);
-static int ni_660x_detach(struct comedi_device *dev);
+static void ni_660x_detach(struct comedi_device *dev);
 static void init_tio_chip(struct comedi_device *dev, int chipset);
 static void ni_660x_select_pfi_output(struct comedi_device *dev,
 				      unsigned pfi_channel,
@@ -1188,14 +1188,10 @@ static int ni_660x_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int ni_660x_detach(struct comedi_device *dev)
+static void ni_660x_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: ni_660x: remove\n", dev->minor);
-
-	/* Free irq */
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
 	if (dev->private) {
 		if (private(dev)->counter_dev)
 			ni_gpct_device_destroy(private(dev)->counter_dev);
@@ -1204,7 +1200,6 @@ static int ni_660x_detach(struct comedi_device *dev)
 			mite_unsetup(private(dev)->mite);
 		}
 	}
-	return 0;
 }
 
 static int
diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index c74efc4..a9cf94f 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -111,7 +111,7 @@ struct ni_670x_private {
 
 static int ni_670x_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it);
-static int ni_670x_detach(struct comedi_device *dev);
+static void ni_670x_detach(struct comedi_device *dev);
 
 static struct comedi_driver driver_ni_670x = {
 	.driver_name = "ni_670x",
@@ -249,19 +249,13 @@ static int ni_670x_attach(struct comedi_device *dev,
 	return 1;
 }
 
-static int ni_670x_detach(struct comedi_device *dev)
+static void ni_670x_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: ni_670x: remove\n", dev->minor);
-
 	kfree(dev->subdevices[0].range_table_list);
-
 	if (dev->private && devpriv->mite)
 		mite_unsetup(devpriv->mite);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
-	return 0;
 }
 
 static int ni_670x_ao_winsn(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index 3231d10..ae896a0 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -873,17 +873,12 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 };
 
-static int a2150_detach(struct comedi_device *dev)
+static void a2150_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: %s: remove\n", dev->minor, dev->driver->driver_name);
-
-	/* only free stuff if it has been allocated by _attach */
 	if (dev->iobase) {
-		/*  put board in power-down mode */
 		outw(APD_BIT | DPD_BIT, dev->iobase + CONFIG_REG);
 		release_region(dev->iobase, A2150_SIZE);
 	}
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (devpriv) {
@@ -891,8 +886,6 @@ static int a2150_detach(struct comedi_device *dev)
 			free_dma(devpriv->dma);
 		kfree(devpriv->dma_buffer);
 	}
-
-	return 0;
 };
 
 static struct comedi_driver ni_at_a2150_driver = {
diff --git a/drivers/staging/comedi/drivers/ni_at_ao.c b/drivers/staging/comedi/drivers/ni_at_ao.c
index d7963ba..c43dd8a 100644
--- a/drivers/staging/comedi/drivers/ni_at_ao.c
+++ b/drivers/staging/comedi/drivers/ni_at_ao.c
@@ -406,14 +406,10 @@ static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int atao_detach(struct comedi_device *dev)
+static void atao_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: atao: remove\n", dev->minor);
-
 	if (dev->iobase)
 		release_region(dev->iobase, ATAO_SIZE);
-
-	return 0;
 }
 
 static const struct atao_board atao_boards[] = {
diff --git a/drivers/staging/comedi/drivers/ni_atmio.c b/drivers/staging/comedi/drivers/ni_atmio.c
index 02cf44b..6448373 100644
--- a/drivers/staging/comedi/drivers/ni_atmio.c
+++ b/drivers/staging/comedi/drivers/ni_atmio.c
@@ -497,19 +497,15 @@ static int ni_atmio_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int ni_atmio_detach(struct comedi_device *dev)
+static void ni_atmio_detach(struct comedi_device *dev)
 {
 	mio_common_detach(dev);
-
 	if (dev->iobase)
 		release_region(dev->iobase, NI_SIZE);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
 	if (devpriv->isapnp_dev)
 		pnp_device_detach(devpriv->isapnp_dev);
-
-	return 0;
 }
 
 static struct comedi_driver ni_atmio_driver = {
diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index 8044e92..4f61453 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -829,22 +829,15 @@ static int atmio16d_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int atmio16d_detach(struct comedi_device *dev)
+static void atmio16d_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: atmio16d: remove\n", dev->minor);
-
 	if (dev->subdevices && boardtype->has_8255)
 		subdev_8255_cleanup(dev, dev->subdevices + 3);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
 	reset_atmio16d(dev);
-
 	if (dev->iobase)
 		release_region(dev->iobase, ATMIO16D_SIZE);
-
-	return 0;
 }
 
 static const struct atmio16_board_t atmio16_boards[] = {
diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index e242012..75764e8 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -57,7 +57,7 @@ static struct pcmcia_device *pcmcia_cur_dev;
 
 static int dio700_attach(struct comedi_device *dev,
 			 struct comedi_devconfig *it);
-static int dio700_detach(struct comedi_device *dev);
+static void dio700_detach(struct comedi_device *dev);
 
 enum dio700_bustype { pcmcia_bustype };
 
@@ -419,19 +419,14 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 };
 
-static int dio700_detach(struct comedi_device *dev)
+static void dio700_detach(struct comedi_device *dev)
 {
-	printk(KERN_ERR "comedi%d: ni_daq_700: cs-remove\n", dev->minor);
-
 	if (dev->subdevices)
 		subdev_700_cleanup(dev, dev->subdevices + 0);
-
 	if (thisboard->bustype != pcmcia_bustype && dev->iobase)
 		release_region(dev->iobase, DIO700_SIZE);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
-	return 0;
 };
 
 static void dio700_config(struct pcmcia_device *link);
@@ -472,18 +467,12 @@ static int dio700_cs_attach(struct pcmcia_device *link)
 
 static void dio700_cs_detach(struct pcmcia_device *link)
 {
-
-	printk(KERN_INFO "ni_daq_700: cs-detach!\n");
-
-	dev_dbg(&link->dev, "dio700_cs_detach\n");
-
 	((struct local_info_t *)link->priv)->stop = 1;
 	dio700_release(link);
 
 	/* This points to the parent struct local_info_t struct */
 	kfree(link->priv);
-
-}				/* dio700_cs_detach */
+}
 
 static int dio700_pcmcia_config_loop(struct pcmcia_device *p_dev,
 				void *priv_data)
diff --git a/drivers/staging/comedi/drivers/ni_daq_dio24.c b/drivers/staging/comedi/drivers/ni_daq_dio24.c
index c0423a8..493a227 100644
--- a/drivers/staging/comedi/drivers/ni_daq_dio24.c
+++ b/drivers/staging/comedi/drivers/ni_daq_dio24.c
@@ -57,7 +57,7 @@ static struct pcmcia_device *pcmcia_cur_dev;
 #define DIO24_SIZE 4		/*  size of io region used by board */
 
 static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int dio24_detach(struct comedi_device *dev);
+static void dio24_detach(struct comedi_device *dev);
 
 enum dio24_bustype { pcmcia_bustype };
 
@@ -168,19 +168,14 @@ static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 };
 
-static int dio24_detach(struct comedi_device *dev)
+static void dio24_detach(struct comedi_device *dev)
 {
-	dev_info(dev->hw_dev, "comedi%d: ni_daq_dio24: remove\n", dev->minor);
-
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 0);
-
 	if (thisboard->bustype != pcmcia_bustype && dev->iobase)
 		release_region(dev->iobase, DIO24_SIZE);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
-	return 0;
 };
 
 static void dio24_config(struct pcmcia_device *link);
@@ -221,18 +216,12 @@ static int dio24_cs_attach(struct pcmcia_device *link)
 
 static void dio24_cs_detach(struct pcmcia_device *link)
 {
-
-	printk(KERN_INFO "ni_daq_dio24: HOLA SOY YO - cs-detach!\n");
-
-	dev_dbg(&link->dev, "dio24_cs_detach\n");
-
 	((struct local_info_t *)link->priv)->stop = 1;
 	dio24_release(link);
 
 	/* This points to the parent local_info_t struct */
 	kfree(link->priv);
-
-}				/* dio24_cs_detach */
+}
 
 static int dio24_pcmcia_config_loop(struct pcmcia_device *p_dev,
 				void *priv_data)
diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index b281fc6..5334977 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -805,13 +805,10 @@ static int labpc_find_device(struct comedi_device *dev, int bus, int slot)
 }
 #endif
 
-int labpc_common_detach(struct comedi_device *dev)
+void labpc_common_detach(struct comedi_device *dev)
 {
-	printk(KERN_ERR "comedi%d: ni_labpc: detach\n", dev->minor);
-
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
-
 #ifdef CONFIG_ISA_DMA_API
 	/* only free stuff if it has been allocated by _attach */
 	kfree(devpriv->dma_buffer);
@@ -826,8 +823,6 @@ int labpc_common_detach(struct comedi_device *dev)
 	if (devpriv->mite)
 		mite_unsetup(devpriv->mite);
 #endif
-
-	return 0;
 };
 EXPORT_SYMBOL_GPL(labpc_common_detach);
 
diff --git a/drivers/staging/comedi/drivers/ni_labpc.h b/drivers/staging/comedi/drivers/ni_labpc.h
index 422cee5..e052ed3 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.h
+++ b/drivers/staging/comedi/drivers/ni_labpc.h
@@ -103,7 +103,7 @@ struct labpc_private {
 
 int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 			unsigned int irq, unsigned int dma);
-int labpc_common_detach(struct comedi_device *dev);
+void labpc_common_detach(struct comedi_device *dev);
 
 extern const int labpc_1200_is_unipolar[];
 extern const int labpc_1200_ai_gain_bits[];
diff --git a/drivers/staging/comedi/drivers/ni_labpc_cs.c b/drivers/staging/comedi/drivers/ni_labpc_cs.c
index ff38405..dbb61b6 100644
--- a/drivers/staging/comedi/drivers/ni_labpc_cs.c
+++ b/drivers/staging/comedi/drivers/ni_labpc_cs.c
@@ -188,21 +188,13 @@ static int labpc_cs_attach(struct pcmcia_device *link)
 
 static void labpc_cs_detach(struct pcmcia_device *link)
 {
-	dev_dbg(&link->dev, "labpc_cs_detach\n");
-
-	/*
-	   If the device is currently configured and active, we won't
-	   actually delete it yet.  Instead, it is marked so that when
-	   the release() function is called, that will trigger a proper
-	   detach().
-	 */
 	((struct local_info_t *)link->priv)->stop = 1;
 	labpc_release(link);
 
 	/* This points to the parent local_info_t struct (may be null) */
 	kfree(link->priv);
 
-}				/* labpc_cs_detach */
+}
 
 static int labpc_pcmcia_config_loop(struct pcmcia_device *p_dev,
 				void *priv_data)
diff --git a/drivers/staging/comedi/drivers/ni_mio_cs.c b/drivers/staging/comedi/drivers/ni_mio_cs.c
index 53ec24bb..b85765d 100644
--- a/drivers/staging/comedi/drivers/ni_mio_cs.c
+++ b/drivers/staging/comedi/drivers/ni_mio_cs.c
@@ -227,7 +227,7 @@ static uint16_t mio_cs_win_in(struct comedi_device *dev, int addr)
 
 static int mio_cs_attach(struct comedi_device *dev,
 			 struct comedi_devconfig *it);
-static int mio_cs_detach(struct comedi_device *dev);
+static void mio_cs_detach(struct comedi_device *dev);
 static struct comedi_driver driver_ni_mio_cs = {
 	.driver_name = "ni_mio_cs",
 	.module = THIS_MODULE,
@@ -240,18 +240,11 @@ static struct comedi_driver driver_ni_mio_cs = {
 static int ni_getboardtype(struct comedi_device *dev,
 			   struct pcmcia_device *link);
 
-/* clean up allocated resources */
-/* called when driver is removed */
-static int mio_cs_detach(struct comedi_device *dev)
+static void mio_cs_detach(struct comedi_device *dev)
 {
 	mio_common_detach(dev);
-
-	/* PCMCIA layer frees the IO region */
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
-	return 0;
 }
 
 static void mio_cs_config(struct pcmcia_device *link);
@@ -276,8 +269,6 @@ static void cs_release(struct pcmcia_device *link)
 
 static void cs_detach(struct pcmcia_device *link)
 {
-	DPRINTK("cs_detach(link=%p)\n", link);
-
 	cs_release(link);
 }
 
diff --git a/drivers/staging/comedi/drivers/ni_pcidio.c b/drivers/staging/comedi/drivers/ni_pcidio.c
index ed42ee3..37b7008 100644
--- a/drivers/staging/comedi/drivers/ni_pcidio.c
+++ b/drivers/staging/comedi/drivers/ni_pcidio.c
@@ -1307,7 +1307,7 @@ static int nidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int nidio_detach(struct comedi_device *dev)
+static void nidio_detach(struct comedi_device *dev)
 {
 	int i;
 
@@ -1315,10 +1315,8 @@ static int nidio_detach(struct comedi_device *dev)
 		for (i = 0; i < this_board->n_8255; i++)
 			subdev_8255_cleanup(dev, dev->subdevices + i);
 	}
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
 	if (devpriv) {
 		if (devpriv->di_mite_ring) {
 			mite_free_ring(devpriv->di_mite_ring);
@@ -1327,7 +1325,6 @@ static int nidio_detach(struct comedi_device *dev)
 		if (devpriv->mite)
 			mite_unsetup(devpriv->mite);
 	}
-	return 0;
 }
 
 static struct comedi_driver ni_pcidio_driver = {
diff --git a/drivers/staging/comedi/drivers/ni_pcimio.c b/drivers/staging/comedi/drivers/ni_pcimio.c
index 9d0a08f..3974c0d 100644
--- a/drivers/staging/comedi/drivers/ni_pcimio.c
+++ b/drivers/staging/comedi/drivers/ni_pcimio.c
@@ -1573,13 +1573,11 @@ static void init_6143(struct comedi_device *dev)
 	ni_writew(devpriv->ai_calib_source, Calibration_Channel_6143);
 }
 
-/* cleans up allocated resources */
-static int pcimio_detach(struct comedi_device *dev)
+static void pcimio_detach(struct comedi_device *dev)
 {
 	mio_common_detach(dev);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
 	if (dev->private) {
 		mite_free_ring(devpriv->ai_mite_ring);
 		mite_free_ring(devpriv->ao_mite_ring);
@@ -1589,8 +1587,6 @@ static int pcimio_detach(struct comedi_device *dev)
 		if (devpriv->mite)
 			mite_unsetup(devpriv->mite);
 	}
-
-	return 0;
 }
 
 static int pcimio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index 6a12dca..2e7753f 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -591,17 +591,12 @@ static int pcl711_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int pcl711_detach(struct comedi_device *dev)
+static void pcl711_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: pcl711: remove\n", dev->minor);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
 	if (dev->iobase)
 		release_region(dev->iobase, PCL711_SIZE);
-
-	return 0;
 }
 
 static const struct pcl711_board boardtypes[] = {
diff --git a/drivers/staging/comedi/drivers/pcl724.c b/drivers/staging/comedi/drivers/pcl724.c
index 7562858..1f66fe1 100644
--- a/drivers/staging/comedi/drivers/pcl724.c
+++ b/drivers/staging/comedi/drivers/pcl724.c
@@ -177,23 +177,17 @@ static int pcl724_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int pcl724_detach(struct comedi_device *dev)
+static void pcl724_detach(struct comedi_device *dev)
 {
 	int i;
 
-	/* printk("comedi%d: pcl724: remove\n",dev->minor); */
-
 	for (i = 0; i < dev->n_subdevices; i++)
 		subdev_8255_cleanup(dev, dev->subdevices + i);
-
 #ifdef PCL724_IRQ
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 #endif
-
 	release_region(dev->iobase, this_board->io_range);
-
-	return 0;
 }
 
 static const struct pcl724_board boardtypes[] = {
diff --git a/drivers/staging/comedi/drivers/pcl725.c b/drivers/staging/comedi/drivers/pcl725.c
index eeac943..83a6fa5 100644
--- a/drivers/staging/comedi/drivers/pcl725.c
+++ b/drivers/staging/comedi/drivers/pcl725.c
@@ -89,14 +89,10 @@ static int pcl725_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int pcl725_detach(struct comedi_device *dev)
+static void pcl725_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: pcl725: remove\n", dev->minor);
-
 	if (dev->iobase)
 		release_region(dev->iobase, PCL725_SIZE);
-
-	return 0;
 }
 
 static struct comedi_driver pcl725_driver = {
diff --git a/drivers/staging/comedi/drivers/pcl726.c b/drivers/staging/comedi/drivers/pcl726.c
index 8e2fb36..d25c30c 100644
--- a/drivers/staging/comedi/drivers/pcl726.c
+++ b/drivers/staging/comedi/drivers/pcl726.c
@@ -350,19 +350,14 @@ static int pcl726_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int pcl726_detach(struct comedi_device *dev)
+static void pcl726_detach(struct comedi_device *dev)
 {
-/* printk("comedi%d: pcl726: remove\n",dev->minor); */
-
 #ifdef ACL6126_IRQ
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 #endif
-
 	if (dev->iobase)
 		release_region(dev->iobase, this_board->io_range);
-
-	return 0;
 }
 
 static struct comedi_driver pcl726_driver = {
diff --git a/drivers/staging/comedi/drivers/pcl730.c b/drivers/staging/comedi/drivers/pcl730.c
index 73b4394..e11704a 100644
--- a/drivers/staging/comedi/drivers/pcl730.c
+++ b/drivers/staging/comedi/drivers/pcl730.c
@@ -134,14 +134,10 @@ static int pcl730_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int pcl730_detach(struct comedi_device *dev)
+static void pcl730_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: pcl730: remove\n", dev->minor);
-
 	if (dev->iobase)
 		release_region(dev->iobase, this_board->io_range);
-
-	return 0;
 }
 
 static const struct pcl730_board boardtypes[] = {
diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 613b397..51f4ca9 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -1614,14 +1614,9 @@ no_dma:
 	return 0;
 }
 
-static int pcl812_detach(struct comedi_device *dev)
+static void pcl812_detach(struct comedi_device *dev)
 {
-
-#ifdef PCL812_EXTDEBUG
-	printk(KERN_DEBUG "comedi%d: pcl812: remove\n", dev->minor);
-#endif
 	free_resources(dev);
-	return 0;
 }
 
 static const struct pcl812_board boardtypes[] = {
diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index 1559c05..cc67b6d 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -1026,40 +1026,6 @@ static int set_rtc_irq_bit(unsigned char bit)
 }
 #endif
 
-/*
-==============================================================================
-  Free any resources that we have claimed
-*/
-static void free_resources(struct comedi_device *dev)
-{
-	/* printk("free_resource()\n"); */
-	if (dev->private) {
-		pcl816_ai_cancel(dev, devpriv->sub_ai);
-		pcl816_reset(dev);
-		if (devpriv->dma)
-			free_dma(devpriv->dma);
-		if (devpriv->dmabuf[0])
-			free_pages(devpriv->dmabuf[0], devpriv->dmapages[0]);
-		if (devpriv->dmabuf[1])
-			free_pages(devpriv->dmabuf[1], devpriv->dmapages[1]);
-#ifdef unused
-		if (devpriv->rtc_irq)
-			free_irq(devpriv->rtc_irq, dev);
-		if ((devpriv->dma_rtc) && (RTC_lock == 1)) {
-			if (devpriv->rtc_iobase)
-				release_region(devpriv->rtc_iobase,
-					       devpriv->rtc_iosize);
-		}
-#endif
-	}
-
-	if (dev->irq)
-		free_irq(dev->irq, dev);
-	if (dev->iobase)
-		release_region(dev->iobase, this_board->io_range);
-	/* printk("free_resource() end\n"); */
-}
-
 static int pcl816_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	int ret;
@@ -1285,15 +1251,35 @@ case COMEDI_SUBD_DO:
 	return 0;
 }
 
-static int pcl816_detach(struct comedi_device *dev)
+static void pcl816_detach(struct comedi_device *dev)
 {
-	DEBUG(printk(KERN_INFO "comedi%d: pcl816: remove\n", dev->minor);)
-	    free_resources(dev);
+	if (dev->private) {
+		pcl816_ai_cancel(dev, devpriv->sub_ai);
+		pcl816_reset(dev);
+		if (devpriv->dma)
+			free_dma(devpriv->dma);
+		if (devpriv->dmabuf[0])
+			free_pages(devpriv->dmabuf[0], devpriv->dmapages[0]);
+		if (devpriv->dmabuf[1])
+			free_pages(devpriv->dmabuf[1], devpriv->dmapages[1]);
+#ifdef unused
+		if (devpriv->rtc_irq)
+			free_irq(devpriv->rtc_irq, dev);
+		if ((devpriv->dma_rtc) && (RTC_lock == 1)) {
+			if (devpriv->rtc_iobase)
+				release_region(devpriv->rtc_iobase,
+					       devpriv->rtc_iosize);
+		}
+#endif
+	}
+	if (dev->irq)
+		free_irq(dev->irq, dev);
+	if (dev->iobase)
+		release_region(dev->iobase, this_board->io_range);
 #ifdef unused
 	if (devpriv->dma_rtc)
 		RTC_lock--;
 #endif
-	return 0;
 }
 
 static const struct pcl816_board boardtypes[] = {
diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 9b8a1ff..1406c97 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -1634,42 +1634,6 @@ static int rtc_setfreq_irq(int freq)
 }
 #endif
 
-/*
-==============================================================================
-  Free any resources that we have claimed
-*/
-static void free_resources(struct comedi_device *dev)
-{
-	/* printk("free_resource()\n"); */
-	if (dev->private) {
-		pcl818_ai_cancel(dev, devpriv->sub_ai);
-		pcl818_reset(dev);
-		if (devpriv->dma)
-			free_dma(devpriv->dma);
-		if (devpriv->dmabuf[0])
-			free_pages(devpriv->dmabuf[0], devpriv->dmapages[0]);
-		if (devpriv->dmabuf[1])
-			free_pages(devpriv->dmabuf[1], devpriv->dmapages[1]);
-#ifdef unused
-		if (devpriv->rtc_irq)
-			free_irq(devpriv->rtc_irq, dev);
-		if ((devpriv->dma_rtc) && (RTC_lock == 1)) {
-			if (devpriv->rtc_iobase)
-				release_region(devpriv->rtc_iobase,
-					       devpriv->rtc_iosize);
-		}
-		if (devpriv->dma_rtc)
-			RTC_lock--;
-#endif
-	}
-
-	if (dev->irq)
-		free_irq(dev->irq, dev);
-	if (dev->iobase)
-		release_region(dev->iobase, devpriv->io_range);
-	/* printk("free_resource() end\n"); */
-}
-
 static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	int ret;
@@ -1960,11 +1924,33 @@ no_dma:
 	return 0;
 }
 
-static int pcl818_detach(struct comedi_device *dev)
+static void pcl818_detach(struct comedi_device *dev)
 {
-	/*   printk("comedi%d: pcl818: remove\n", dev->minor); */
-	free_resources(dev);
-	return 0;
+	if (dev->private) {
+		pcl818_ai_cancel(dev, devpriv->sub_ai);
+		pcl818_reset(dev);
+		if (devpriv->dma)
+			free_dma(devpriv->dma);
+		if (devpriv->dmabuf[0])
+			free_pages(devpriv->dmabuf[0], devpriv->dmapages[0]);
+		if (devpriv->dmabuf[1])
+			free_pages(devpriv->dmabuf[1], devpriv->dmapages[1]);
+#ifdef unused
+		if (devpriv->rtc_irq)
+			free_irq(devpriv->rtc_irq, dev);
+		if ((devpriv->dma_rtc) && (RTC_lock == 1)) {
+			if (devpriv->rtc_iobase)
+				release_region(devpriv->rtc_iobase,
+					       devpriv->rtc_iosize);
+		}
+		if (devpriv->dma_rtc)
+			RTC_lock--;
+#endif
+	}
+	if (dev->irq)
+		free_irq(dev->irq, dev);
+	if (dev->iobase)
+		release_region(dev->iobase, devpriv->io_range);
 }
 
 static const struct pcl818_board boardtypes[] = {
diff --git a/drivers/staging/comedi/drivers/pcm3724.c b/drivers/staging/comedi/drivers/pcm3724.c
index 36c0459..7492b8f 100644
--- a/drivers/staging/comedi/drivers/pcm3724.c
+++ b/drivers/staging/comedi/drivers/pcm3724.c
@@ -273,7 +273,7 @@ static int pcm3724_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int pcm3724_detach(struct comedi_device *dev)
+static void pcm3724_detach(struct comedi_device *dev)
 {
 	int i;
 
@@ -283,8 +283,6 @@ static int pcm3724_detach(struct comedi_device *dev)
 	}
 	if (dev->iobase)
 		release_region(dev->iobase, this_board->io_range);
-
-	return 0;
 }
 
 static const struct pcm3724_board boardtypes[] = {
diff --git a/drivers/staging/comedi/drivers/pcm3730.c b/drivers/staging/comedi/drivers/pcm3730.c
index 1571b83..f8d1c64 100644
--- a/drivers/staging/comedi/drivers/pcm3730.c
+++ b/drivers/staging/comedi/drivers/pcm3730.c
@@ -133,14 +133,10 @@ static int pcm3730_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int pcm3730_detach(struct comedi_device *dev)
+static void pcm3730_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: pcm3730: remove\n", dev->minor);
-
 	if (dev->iobase)
 		release_region(dev->iobase, PCM3730_SIZE);
-
-	return 0;
 }
 
 static struct comedi_driver pcm3730_driver = {
diff --git a/drivers/staging/comedi/drivers/pcmad.c b/drivers/staging/comedi/drivers/pcmad.c
index 05a2363..1ec7d5c 100644
--- a/drivers/staging/comedi/drivers/pcmad.c
+++ b/drivers/staging/comedi/drivers/pcmad.c
@@ -139,17 +139,12 @@ static int pcmad_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int pcmad_detach(struct comedi_device *dev)
+static void pcmad_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: pcmad: remove\n", dev->minor);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
 	if (dev->iobase)
 		release_region(dev->iobase, PCMAD_SIZE);
-
-	return 0;
 }
 
 static const struct pcmad_board_struct pcmad_boards[] = {
diff --git a/drivers/staging/comedi/drivers/pcmda12.c b/drivers/staging/comedi/drivers/pcmda12.c
index aaea0e6..4786148 100644
--- a/drivers/staging/comedi/drivers/pcmda12.c
+++ b/drivers/staging/comedi/drivers/pcmda12.c
@@ -227,13 +227,10 @@ static int pcmda12_attach(struct comedi_device *dev,
 	return 1;
 }
 
-static int pcmda12_detach(struct comedi_device *dev)
+static void pcmda12_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO
-	       "comedi%d: %s: remove\n", dev->minor, dev->driver->driver_name);
 	if (dev->iobase)
 		release_region(dev->iobase, IOSIZE);
-	return 0;
 }
 
 static const struct pcmda12_board pcmda12_boards[] = {
diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index a977acb..efed168 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -1223,24 +1223,18 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 1;
 }
 
-static int pcmmio_detach(struct comedi_device *dev)
+static void pcmmio_detach(struct comedi_device *dev)
 {
 	int i;
 
-	printk(KERN_INFO "comedi%d: %s: remove\n", dev->minor,
-		dev->driver->driver_name);
 	if (dev->iobase)
 		release_region(dev->iobase, thisboard->total_iosize);
-
 	for (i = 0; i < MAX_ASICS; ++i) {
 		if (devpriv && devpriv->asics[i].irq)
 			free_irq(devpriv->asics[i].irq, dev);
 	}
-
 	if (devpriv && devpriv->sprivs)
 		kfree(devpriv->sprivs);
-
-	return 0;
 }
 
 static const struct pcmmio_board pcmmio_boards[] = {
diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index b18912a..623381d 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -908,24 +908,18 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 1;
 }
 
-static int pcmuio_detach(struct comedi_device *dev)
+static void pcmuio_detach(struct comedi_device *dev)
 {
 	int i;
 
-	dev_dbg(dev->hw_dev, "comedi%d: %s: remove\n", dev->minor,
-		dev->driver->driver_name);
 	if (dev->iobase)
 		release_region(dev->iobase, ASIC_IOSIZE * thisboard->num_asics);
-
 	for (i = 0; i < MAX_ASICS; ++i) {
 		if (devpriv->asics[i].irq)
 			free_irq(devpriv->asics[i].irq, dev);
 	}
-
 	if (devpriv && devpriv->sprivs)
 		kfree(devpriv->sprivs);
-
-	return 0;
 }
 
 static const struct pcmuio_board pcmuio_boards[] = {
diff --git a/drivers/staging/comedi/drivers/poc.c b/drivers/staging/comedi/drivers/poc.c
index 2e50c7f..e712048 100644
--- a/drivers/staging/comedi/drivers/poc.c
+++ b/drivers/staging/comedi/drivers/poc.c
@@ -181,15 +181,10 @@ static int poc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int poc_detach(struct comedi_device *dev)
+static void poc_detach(struct comedi_device *dev)
 {
-	/* only free stuff if it has been allocated by _attach */
 	if (dev->iobase)
 		release_region(dev->iobase, this_board->iosize);
-
-	printk(KERN_INFO "comedi%d: dac02: remove\n", dev->minor);
-
-	return 0;
 }
 
 static const struct boarddef_struct boards[] = {
diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index e0bb734..2f130b3 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -181,7 +181,7 @@ static const struct comedi_lrange range_daqp_ao = { 1, {BIP_RANGE(5)} };
 /* comedi interface code */
 
 static int daqp_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int daqp_detach(struct comedi_device *dev);
+static void daqp_detach(struct comedi_device *dev);
 static struct comedi_driver driver_daqp = {
 	.driver_name = "quatech_daqp_cs",
 	.module = THIS_MODULE,
@@ -922,15 +922,9 @@ static int daqp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 1;
 }
 
-/* daqp_detach (called from comedi_comdig) does nothing. If the PCMCIA
- * card is removed, daqp_cs_detach() is called by the pcmcia subsystem.
- */
-
-static int daqp_detach(struct comedi_device *dev)
+static void daqp_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: detaching daqp\n", dev->minor);
-
-	return 0;
+	/* Nothing to cleanup */
 }
 
 /*====================================================================
@@ -1010,8 +1004,6 @@ static void daqp_cs_detach(struct pcmcia_device *link)
 {
 	struct local_info_t *dev = link->priv;
 
-	dev_dbg(&link->dev, "daqp_cs_detach\n");
-
 	dev->stop = 1;
 	daqp_cs_release(link);
 
@@ -1019,7 +1011,7 @@ static void daqp_cs_detach(struct pcmcia_device *link)
 	dev_table[dev->table_index] = NULL;
 	kfree(dev);
 
-}				/* daqp_cs_detach */
+}
 
 static int daqp_pcmcia_config_loop(struct pcmcia_device *p_dev, void *priv_data)
 {
diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 32766ed..1678a0c 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1081,30 +1081,12 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 #endif
 }
 
-/*
- * _detach is called to deconfigure a device.  It should deallocate
- * resources.
- * This function is also called when _attach() fails, so it should be
- * careful not to release resources that were not necessarily
- * allocated by _attach().  dev->private and dev->subdevices are
- * deallocated automatically by the core.
- */
-static int rtd_detach(struct comedi_device *dev)
+static void rtd_detach(struct comedi_device *dev)
 {
 #ifdef USE_DMA
 	int index;
 #endif
 
-	DPRINTK("comedi%d: rtd520: removing (%ld ints)\n",
-		dev->minor, (devpriv ? devpriv->intCount : 0L));
-	if (devpriv && devpriv->lcfg) {
-		DPRINTK
-		    ("(int status 0x%x, overrun status 0x%x, fifo status 0x%x)...\n",
-		     0xffff & RtdInterruptStatus(dev),
-		     0xffff & RtdInterruptOverrunStatus(dev),
-		     (0xffff & RtdFifoStatus(dev)) ^ 0x6666);
-	}
-
 	if (devpriv) {
 		/* Shut down any board ops by resetting it */
 #ifdef USE_DMA
@@ -1141,37 +1123,24 @@ static int rtd_detach(struct comedi_device *dev)
 			devpriv->dma0Chain = NULL;
 		}
 #endif /* USE_DMA */
-
-		/* release IRQ */
 		if (dev->irq) {
-			/* disable interrupt controller */
 			RtdPlxInterruptWrite(dev, RtdPlxInterruptRead(dev)
 					     & ~(ICS_PLIE | ICS_DMA0_E |
 						 ICS_DMA1_E));
 			free_irq(dev->irq, dev);
 		}
-
-		/* release all regions that were allocated */
 		if (devpriv->las0)
 			iounmap(devpriv->las0);
-
 		if (devpriv->las1)
 			iounmap(devpriv->las1);
-
 		if (devpriv->lcfg)
 			iounmap(devpriv->lcfg);
-
 		if (devpriv->pci_dev) {
 			if (devpriv->got_regions)
 				comedi_pci_disable(devpriv->pci_dev);
-
 			pci_dev_put(devpriv->pci_dev);
 		}
 	}
-
-	printk(KERN_INFO "comedi%d: rtd520: removed.\n", dev->minor);
-
-	return 0;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/rti800.c b/drivers/staging/comedi/drivers/rti800.c
index c073bf4..f0eb52a 100644
--- a/drivers/staging/comedi/drivers/rti800.c
+++ b/drivers/staging/comedi/drivers/rti800.c
@@ -443,17 +443,12 @@ static int rti800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int rti800_detach(struct comedi_device *dev)
+static void rti800_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: rti800: remove\n", dev->minor);
-
 	if (dev->iobase)
 		release_region(dev->iobase, RTI800_SIZE);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-
-	return 0;
 }
 
 static const struct rti800_board boardtypes[] = {
diff --git a/drivers/staging/comedi/drivers/rti802.c b/drivers/staging/comedi/drivers/rti802.c
index b4980b4..09da5c2 100644
--- a/drivers/staging/comedi/drivers/rti802.c
+++ b/drivers/staging/comedi/drivers/rti802.c
@@ -129,14 +129,10 @@ static int rti802_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-static int rti802_detach(struct comedi_device *dev)
+static void rti802_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: rti802: remove\n", dev->minor);
-
 	if (dev->iobase)
 		release_region(dev->iobase, RTI802_SIZE);
-
-	return 0;
 }
 
 static struct comedi_driver rti802_driver = {
diff --git a/drivers/staging/comedi/drivers/s526.c b/drivers/staging/comedi/drivers/s526.c
index 3f86ed7..7a56434 100644
--- a/drivers/staging/comedi/drivers/s526.c
+++ b/drivers/staging/comedi/drivers/s526.c
@@ -938,14 +938,10 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 1;
 }
 
-static int s526_detach(struct comedi_device *dev)
+static void s526_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: s526: remove\n", dev->minor);
-
 	if (dev->iobase > 0)
 		release_region(dev->iobase, S526_IOSIZE);
-
-	return 0;
 }
 
 static struct comedi_driver s526_driver = {
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 56b111f..7beb8f6 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -1312,7 +1312,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 	return IRQ_HANDLED;
 }
 
-static int s626_detach(struct comedi_device *dev)
+static void s626_detach(struct comedi_device *dev)
 {
 	if (devpriv) {
 		/* stop ai_command */
@@ -1336,20 +1336,14 @@ static int s626_detach(struct comedi_device *dev)
 
 		if (dev->irq)
 			free_irq(dev->irq, dev);
-
 		if (devpriv->base_addr)
 			iounmap(devpriv->base_addr);
-
 		if (devpriv->pdev) {
 			if (devpriv->got_regions)
 				comedi_pci_disable(devpriv->pdev);
 			pci_dev_put(devpriv->pdev);
 		}
 	}
-
-	DEBUG("s626_detach: S626 detached!\n");
-
-	return 0;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index 0fbd9f9..6342bc5 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -848,18 +848,16 @@ static int serial2002_attach(struct comedi_device *dev,
 	return 1;
 }
 
-static int serial2002_detach(struct comedi_device *dev)
+static void serial2002_detach(struct comedi_device *dev)
 {
 	struct comedi_subdevice *s;
 	int i;
 
-	dev_dbg(dev->hw_dev, "comedi%d: remove\n", dev->minor);
 	for (i = 0; i < 5; i++) {
 		s = &dev->subdevices[i];
 		kfree(s->maxdata_list);
 		kfree(s->range_table_list);
 	}
-	return 0;
 }
 
 static const struct serial2002_board serial2002_boards[] = {
diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
index 19a513e..7d13ffa 100644
--- a/drivers/staging/comedi/drivers/skel.c
+++ b/drivers/staging/comedi/drivers/skel.c
@@ -156,7 +156,7 @@ struct skel_private {
  * the device code.
  */
 static int skel_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int skel_detach(struct comedi_device *dev);
+static void skel_detach(struct comedi_device *dev);
 static struct comedi_driver driver_skel = {
 	.driver_name = "dummy",
 	.module = THIS_MODULE,
@@ -295,11 +295,8 @@ static int skel_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * allocated by _attach().  dev->private and dev->subdevices are
  * deallocated automatically by the core.
  */
-static int skel_detach(struct comedi_device *dev)
+static void skel_detach(struct comedi_device *dev)
 {
-	pr_info("comedi%d: skel: remove\n", dev->minor);
-
-	return 0;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
index 25cb659..16c4f5a 100644
--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -239,20 +239,14 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 1;
 }
 
-static int dnp_detach(struct comedi_device *dev)
+static void dnp_detach(struct comedi_device *dev)
 {
-	/* configure all ports as input (default)                            */
 	outb(PAMR, CSCIR);
 	outb(0x00, CSCDR);
 	outb(PBMR, CSCIR);
 	outb(0x00, CSCDR);
 	outb(PCMR, CSCIR);
 	outb((inb(CSCDR) & 0xAA), CSCDR);
-
-	/* announce that we are finished                                     */
-	printk(KERN_INFO "comedi%d: dnp: remove\n", dev->minor);
-
-	return 0;
 }
 
 static const struct dnp_board dnp_boards[] = {
diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 2d238ae..d5f1f22 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -484,7 +484,7 @@ static int unioxx5_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int unioxx5_detach(struct comedi_device *dev)
+static void unioxx5_detach(struct comedi_device *dev)
 {
 	int i;
 	struct comedi_subdevice *subdev;
@@ -496,8 +496,6 @@ static int unioxx5_detach(struct comedi_device *dev)
 		release_region(usp->usp_iobase, UNIOXX5_SIZE);
 		kfree(subdev->private);
 	}
-
-	return 0;
 }
 
 static struct comedi_driver unioxx5_driver = {
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 3d300ef..13d9fd3 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -2823,36 +2823,17 @@ static int usbdux_attach_usb(struct comedi_device *dev,
 	return ret;
 }
 
-static int usbdux_detach(struct comedi_device *dev)
+static void usbdux_detach(struct comedi_device *dev)
 {
-	struct usbduxsub *usbduxsub_tmp;
+	struct usbduxsub *usb = dev->private;
 
-	if (!dev) {
-		printk(KERN_ERR
-		       "comedi?: usbdux: detach without dev variable...\n");
-		return -EFAULT;
-	}
-
-	usbduxsub_tmp = dev->private;
-	if (!usbduxsub_tmp) {
-		printk(KERN_ERR
-		       "comedi?: usbdux: detach without ptr to usbduxsub[]\n");
-		return -EFAULT;
+	if (usb) {
+		down(&usb->sem);
+		dev->private = NULL;
+		usb->attached = 0;
+		usb->comedidev = NULL;
+		up(&usb->sem);
 	}
-
-	dev_dbg(&usbduxsub_tmp->interface->dev, "comedi%d: detach usb device\n",
-		dev->minor);
-
-	down(&usbduxsub_tmp->sem);
-	/* Don't allow detach to free the private structure */
-	/* It's one entry of of usbduxsub[] */
-	dev->private = NULL;
-	usbduxsub_tmp->attached = 0;
-	usbduxsub_tmp->comedidev = NULL;
-	dev_dbg(&usbduxsub_tmp->interface->dev,
-		"comedi%d: detach: successfully removed\n", dev->minor);
-	up(&usbduxsub_tmp->sem);
-	return 0;
 }
 
 /* main driver struct */
diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index c672ea3..7b1d21a 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -1726,43 +1726,19 @@ static int usbduxfast_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int usbduxfast_detach(struct comedi_device *dev)
+static void usbduxfast_detach(struct comedi_device *dev)
 {
-	struct usbduxfastsub_s *udfs;
+	struct usbduxfastsub_s *usb = dev->private;
 
-	if (!dev) {
-		printk(KERN_ERR "comedi?: usbduxfast: detach without dev "
-		       "variable...\n");
-		return -EFAULT;
-	}
-#ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: usbduxfast: detach usb device\n",
-	       dev->minor);
-#endif
-
-	udfs = dev->private;
-	if (!udfs) {
-		printk(KERN_ERR "comedi?: usbduxfast: detach without ptr to "
-		       "usbduxfastsub[]\n");
-		return -EFAULT;
+	if (usb) {
+		down(&usb->sem);
+		down(&start_stop_sem);
+		dev->private = NULL;
+		usb->attached = 0;
+		usb->comedidev = NULL;
+		up(&start_stop_sem);
+		up(&usb->sem);
 	}
-
-	down(&udfs->sem);
-	down(&start_stop_sem);
-	/*
-	 * Don't allow detach to free the private structure
-	 * It's one entry of of usbduxfastsub[]
-	 */
-	dev->private = NULL;
-	udfs->attached = 0;
-	udfs->comedidev = NULL;
-#ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: usbduxfast: detach: successfully "
-	       "removed\n", dev->minor);
-#endif
-	up(&start_stop_sem);
-	up(&udfs->sem);
-	return 0;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index f21bb0d..465afbd 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -2801,37 +2801,17 @@ static int usbduxsigma_attach(struct comedi_device *dev,
 	return 0;
 }
 
-static int usbduxsigma_detach(struct comedi_device *dev)
+static void usbduxsigma_detach(struct comedi_device *dev)
 {
-	struct usbduxsub *usbduxsub_tmp;
+	struct usbduxsub *usb = dev->private;
 
-	if (!dev) {
-		printk(KERN_ERR
-		       "comedi? usbduxsigma detach: dev=NULL\n");
-		return -EFAULT;
-	}
-
-	usbduxsub_tmp = dev->private;
-	if (!usbduxsub_tmp) {
-		printk(KERN_ERR
-		       "comedi?: usbduxsigma detach: private=NULL\n");
-		return -EFAULT;
+	if (usb) {
+		down(&usb->sem);
+		dev->private = NULL;
+		usb->attached = 0;
+		usb->comedidev = NULL;
+		up(&usb->sem);
 	}
-
-	dev_dbg(&usbduxsub_tmp->interface->dev,
-		"comedi%d: detach usb device\n",
-		dev->minor);
-
-	down(&usbduxsub_tmp->sem);
-	/* Don't allow detach to free the private structure */
-	/* It's one entry of of usbduxsub[] */
-	dev->private = NULL;
-	usbduxsub_tmp->attached = 0;
-	usbduxsub_tmp->comedidev = NULL;
-	dev_info(&usbduxsub_tmp->interface->dev,
-		"comedi%d: successfully detached.\n", dev->minor);
-	up(&usbduxsub_tmp->sem);
-	return 0;
 }
 
 /* main driver struct */
diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index d0e1065..baee8d7 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -1250,32 +1250,16 @@ static int vmk80xx_attach(struct comedi_device *cdev,
 	return 0;
 }
 
-static int vmk80xx_detach(struct comedi_device *cdev)
+static void vmk80xx_detach(struct comedi_device *dev)
 {
-	struct vmk80xx_usb *dev;
-	int minor;
-
-	if (!cdev)
-		return -EFAULT;
-
-	dev = cdev->private;
-	if (!dev)
-		return -EFAULT;
-
-	down(&dev->limit_sem);
-
-	cdev->private = NULL;
-	dev->attached = 0;
+	struct vmk80xx_usb *usb = dev->private;
 
-	minor = cdev->minor;
-
-	printk(KERN_INFO
-	       "comedi%d: vmk80xx: board #%d [%s] detached from comedi\n",
-	       minor, dev->count, dev->board.name);
-
-	up(&dev->limit_sem);
-
-	return 0;
+	if (usb) {
+		down(&usb->limit_sem);
+		dev->private = NULL;
+		usb->attached = 0;
+		up(&usb->limit_sem);
+	}
 }
 
 static int vmk80xx_probe(struct usb_interface *intf,
