Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195Ab2FGWIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 18:08:38 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:39646 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab2FGWIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 18:08:35 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1339106902!7325185!9
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: cleanup alloc_subdevices
Date: Thu, 7 Jun 2012 15:08:15 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206071508.15674.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the comedi core "alloc_subdevices" fuction and it's use
in the comedi drivers.

1) Move the inline alloc_subdevices() function from comedidev.h
to drivers.c and rename it to comedi_alloc_subdevices(). The
function is large enough to warrant being an exported symbol
rather than being an inline in every driver.

2) Since dev->n_subdevices is an int variable, change the 
num_subdevices parameter from an unsigned int to an int.

3) It's possible for a couple of the comedi drivers to incorrectly
call this function with num_subdevices = 0 so add a sanity check
before doing the kcalloc.

4) It's possible for the kcalloc to fail so don't set dev->n_subdevices
until after the kcalloc has succedded. Also, remove the places in
the drivers were dev->n_subdevices was being set directly.

5) Remove all the "allocation failed" error messages.

6) Remove all the "Allocate the subdevice structures" comments from
the drivers. The function name itself provides this information.

7) When comedi_alloc_subdevices does fail, make all the drivers
properly return the error code.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

 drivers/staging/comedi/comedidev.h                 |   22 +----------------
 drivers/staging/comedi/drivers.c                   |   24 ++++++++++++++++++++
 drivers/staging/comedi/drivers/8255.c              |    8 +-----
 drivers/staging/comedi/drivers/acl7225b.c          |    6 +++-
 .../staging/comedi/drivers/addi-data/addi_common.c |    8 ++----
 .../comedi/drivers/addi-data/hwdrv_APCI1710.c      |    8 ++----
 drivers/staging/comedi/drivers/adl_pci6208.c       |    5 ++-
 drivers/staging/comedi/drivers/adl_pci7230.c       |    6 +++-
 drivers/staging/comedi/drivers/adl_pci7296.c       |    5 ++-
 drivers/staging/comedi/drivers/adl_pci7432.c       |    6 +++-
 drivers/staging/comedi/drivers/adl_pci8164.c       |    6 +++-
 drivers/staging/comedi/drivers/adl_pci9111.c       |    4 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |    4 +-
 drivers/staging/comedi/drivers/adq12b.c            |   10 +++-----
 drivers/staging/comedi/drivers/adv_pci1710.c       |    4 +-
 drivers/staging/comedi/drivers/adv_pci1723.c       |    6 +---
 drivers/staging/comedi/drivers/adv_pci_dio.c       |    4 +-
 drivers/staging/comedi/drivers/aio_aio12_8.c       |    6 +++-
 drivers/staging/comedi/drivers/aio_iiro_16.c       |    6 +++-
 drivers/staging/comedi/drivers/amplc_dio200.c      |    8 +++---
 drivers/staging/comedi/drivers/amplc_pc236.c       |    6 +---
 drivers/staging/comedi/drivers/amplc_pc263.c       |    6 +---
 drivers/staging/comedi/drivers/amplc_pci224.c      |    7 +----
 drivers/staging/comedi/drivers/amplc_pci230.c      |   11 ++++-----
 drivers/staging/comedi/drivers/c6xdigio.c          |    4 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |    5 ++-
 drivers/staging/comedi/drivers/cb_pcidas.c         |   10 +++-----
 drivers/staging/comedi/drivers/cb_pcidas64.c       |    7 +++--
 drivers/staging/comedi/drivers/cb_pcidda.c         |   10 +++-----
 drivers/staging/comedi/drivers/cb_pcidio.c         |   11 +++-----
 drivers/staging/comedi/drivers/cb_pcimdas.c        |   10 +++-----
 drivers/staging/comedi/drivers/cb_pcimdda.c        |    9 ++-----
 drivers/staging/comedi/drivers/comedi_bond.c       |   10 +++-----
 drivers/staging/comedi/drivers/comedi_parport.c    |    5 ++-
 drivers/staging/comedi/drivers/comedi_test.c       |    7 +++--
 drivers/staging/comedi/drivers/contec_pci_dio.c    |    6 +++-
 drivers/staging/comedi/drivers/daqboard2000.c      |    4 +-
 drivers/staging/comedi/drivers/das08.c             |    4 +-
 drivers/staging/comedi/drivers/das16.c             |    4 +-
 drivers/staging/comedi/drivers/das16m1.c           |    4 +-
 drivers/staging/comedi/drivers/das1800.c           |    5 ++-
 drivers/staging/comedi/drivers/das6402.c           |    4 +-
 drivers/staging/comedi/drivers/das800.c            |    6 +++-
 drivers/staging/comedi/drivers/dmm32at.c           |    9 ++-----
 drivers/staging/comedi/drivers/dt2801.c            |    4 +-
 drivers/staging/comedi/drivers/dt2811.c            |    4 +-
 drivers/staging/comedi/drivers/dt2814.c            |    4 +-
 drivers/staging/comedi/drivers/dt2815.c            |    8 ++++--
 drivers/staging/comedi/drivers/dt2817.c            |    4 +-
 drivers/staging/comedi/drivers/dt282x.c            |    4 +-
 drivers/staging/comedi/drivers/dt3000.c            |    4 +-
 drivers/staging/comedi/drivers/dt9812.c            |    8 +++---
 drivers/staging/comedi/drivers/dyna_pci10xx.c      |    8 +++---
 drivers/staging/comedi/drivers/fl512.c             |    6 +++-
 drivers/staging/comedi/drivers/gsc_hpdi.c          |    6 +++-
 drivers/staging/comedi/drivers/icp_multi.c         |    4 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c        |    4 +-
 drivers/staging/comedi/drivers/jr3_pci.c           |    4 +-
 drivers/staging/comedi/drivers/ke_counter.c        |    5 +--
 drivers/staging/comedi/drivers/me4000.c            |   10 ++-----
 drivers/staging/comedi/drivers/me_daq.c            |    5 +--
 drivers/staging/comedi/drivers/mpc624.c            |    7 +++--
 drivers/staging/comedi/drivers/multiq3.c           |    5 ++-
 drivers/staging/comedi/drivers/ni_6527.c           |    4 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |    4 +-
 drivers/staging/comedi/drivers/ni_660x.c           |    7 ++---
 drivers/staging/comedi/drivers/ni_670x.c           |    5 ++-
 drivers/staging/comedi/drivers/ni_at_a2150.c       |    7 +++--
 drivers/staging/comedi/drivers/ni_at_ao.c          |    6 +++-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |    4 +-
 drivers/staging/comedi/drivers/ni_daq_700.c        |    6 +++-
 drivers/staging/comedi/drivers/ni_daq_dio24.c      |    6 +++-
 drivers/staging/comedi/drivers/ni_labpc.c          |    7 +++--
 drivers/staging/comedi/drivers/ni_mio_common.c     |    6 +++-
 drivers/staging/comedi/drivers/ni_pcidio.c         |    4 +-
 drivers/staging/comedi/drivers/pcl711.c            |    4 +-
 drivers/staging/comedi/drivers/pcl724.c            |    4 +-
 drivers/staging/comedi/drivers/pcl725.c            |    6 +++-
 drivers/staging/comedi/drivers/pcl726.c            |    4 +-
 drivers/staging/comedi/drivers/pcl730.c            |    6 +++-
 drivers/staging/comedi/drivers/pcl812.c            |    4 +-
 drivers/staging/comedi/drivers/pcl816.c            |    4 +-
 drivers/staging/comedi/drivers/pcl818.c            |    4 +-
 drivers/staging/comedi/drivers/pcm3724.c           |    8 ++----
 drivers/staging/comedi/drivers/pcm3730.c           |    6 +++-
 drivers/staging/comedi/drivers/pcmad.c             |    4 +-
 drivers/staging/comedi/drivers/pcmda12.c           |   15 +++---------
 drivers/staging/comedi/drivers/pcmmio.c            |   16 ++++---------
 drivers/staging/comedi/drivers/pcmuio.c            |   16 ++++---------
 drivers/staging/comedi/drivers/poc.c               |    7 ++++-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |    4 +-
 drivers/staging/comedi/drivers/rtd520.c            |   10 ++-----
 drivers/staging/comedi/drivers/rti800.c            |    4 +-
 drivers/staging/comedi/drivers/rti802.c            |   13 ++++++----
 drivers/staging/comedi/drivers/s526.c              |   12 +++------
 drivers/staging/comedi/drivers/s626.c              |    5 ++-
 drivers/staging/comedi/drivers/serial2002.c        |    6 +++-
 drivers/staging/comedi/drivers/skel.c              |   11 ++++-----
 drivers/staging/comedi/drivers/ssv_dnp.c           |    9 +++----
 drivers/staging/comedi/drivers/unioxx5.c           |    8 +++---
 drivers/staging/comedi/drivers/usbdux.c            |   12 ++++-----
 drivers/staging/comedi/drivers/usbduxfast.c        |   15 +----------
 drivers/staging/comedi/drivers/usbduxsigma.c       |   12 ++++-----
 drivers/staging/comedi/drivers/vmk80xx.c           |    6 +++-
 104 files changed, 350 insertions(+), 375 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 9cd2b51..e0f3915 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -292,6 +292,8 @@ static inline struct comedi_subdevice *comedi_get_write_subdevice(
 	return info->device->write_subdev;
 }
 
+int comedi_alloc_subdevices(struct comedi_device *, int);
+
 void comedi_device_detach(struct comedi_device *dev);
 int comedi_device_attach(struct comedi_device *dev,
 			 struct comedi_devconfig *it);
@@ -413,26 +415,6 @@ struct comedi_lrange {
 
 /* some silly little inline functions */
 
-static inline int alloc_subdevices(struct comedi_device *dev,
-				   unsigned int num_subdevices)
-{
-	unsigned i;
-
-	dev->n_subdevices = num_subdevices;
-	dev->subdevices =
-	    kcalloc(num_subdevices, sizeof(struct comedi_subdevice),
-		    GFP_KERNEL);
-	if (!dev->subdevices)
-		return -ENOMEM;
-	for (i = 0; i < num_subdevices; ++i) {
-		dev->subdevices[i].device = dev;
-		dev->subdevices[i].async_dma_dir = DMA_NONE;
-		spin_lock_init(&dev->subdevices[i].spin_lock);
-		dev->subdevices[i].minor = -1;
-	}
-	return 0;
-}
-
 static inline int alloc_private(struct comedi_device *dev, int size)
 {
 	dev->private = kzalloc(size, GFP_KERNEL);
diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 9d2b206..e7bfbd8 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -56,6 +56,30 @@ static int poll_invalid(struct comedi_device *dev, struct comedi_subdevice *s);
 
 struct comedi_driver *comedi_drivers;
 
+int comedi_alloc_subdevices(struct comedi_device *dev, int num_subdevices)
+{
+	struct comedi_subdevice *s;
+	unsigned i;
+
+	if (num_subdevices < 1)
+		return -EINVAL;
+
+	dev->subdevices = kcalloc(num_subdevices, sizeof(*s), GFP_KERNEL);
+	if (!dev->subdevices)
+		return -ENOMEM;
+	dev->n_subdevices = num_subdevices;
+
+	for (i = 0; i < num_subdevices; ++i) {
+		s = dev->subdevices + i;
+		s->device = dev;
+		s->async_dma_dir = DMA_NONE;
+		spin_lock_init(&s->spin_lock);
+		s->minor = -1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(comedi_alloc_subdevices);
+
 static void cleanup_device(struct comedi_device *dev)
 {
 	int i;
diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index 27e39e4..502bde8 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -388,13 +388,9 @@ static int dev_8255_attach(struct comedi_device *dev,
 		return -EINVAL;
 	}
 
-	ret = alloc_subdevices(dev, i);
-	if (ret < 0) {
-		/* FIXME this printk call should give a proper message, the
-		 * below line just maintains previous functionality */
-		printk("comedi%d: 8255:", dev->minor);
+	ret = comedi_alloc_subdevices(dev, i);
+	if (ret)
 		return ret;
-	}
 
 	printk(KERN_INFO "comedi%d: 8255:", dev->minor);
 
diff --git a/drivers/staging/comedi/drivers/acl7225b.c b/drivers/staging/comedi/drivers/acl7225b.c
index c1963ad..0bf5525 100644
--- a/drivers/staging/comedi/drivers/acl7225b.c
+++ b/drivers/staging/comedi/drivers/acl7225b.c
@@ -68,6 +68,7 @@ static int acl7225b_attach(struct comedi_device *dev,
 	const struct boardtype *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 	int iobase, iorange;
+	int ret;
 
 	iobase = it->options[0];
 	iorange = board->io_range;
@@ -82,8 +83,9 @@ static int acl7225b_attach(struct comedi_device *dev,
 	dev->iobase = iobase;
 	dev->irq = 0;
 
-	if (alloc_subdevices(dev, 3) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* Relays outputs */
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.c b/drivers/staging/comedi/drivers/addi-data/addi_common.c
index 44aaf83..5c933b5 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.c
@@ -1496,7 +1496,7 @@ module_exit(driver_addi_cleanup_module);
 static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
-	int ret, pages, i, n_subdevices;
+	int ret, pages, i;
 	unsigned int dw_Dummy;
 	resource_size_t io_addr[5];
 	unsigned int irq;
@@ -1686,10 +1686,8 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		devpriv->s_BoardInfos.ui_Address = io_addr[2];
 #endif
 	} else {
-		/* Update-0.7.57->0.7.68dev->n_subdevices = 7; */
-		n_subdevices = 7;
-		ret = alloc_subdevices(dev, n_subdevices);
-		if (ret < 0)
+		ret = comedi_alloc_subdevices(dev, 7);
+		if (ret)
 			return ret;
 
 		/*  Allocate and Initialise AI Subdevice Structures */
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
index a76ed25..2118d58 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
@@ -59,12 +59,10 @@ You should also find the complete GPL in the COPYING file accompanying this sour
 void i_ADDI_AttachPCI1710(struct comedi_device *dev)
 {
 	struct comedi_subdevice *s;
-	int ret = 0;
-	int n_subdevices = 9;
+	int ret;
 
-	/* Update-0.7.57->0.7.68dev->n_subdevices = 9; */
-	ret = alloc_subdevices(dev, n_subdevices);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 9);
+	if (ret)
 		return;
 
 	/*  Allocate and Initialise Timer Subdevice Structures */
diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 2f48dc7..98b3730 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -301,8 +301,9 @@ static int pci6208_attach(struct comedi_device *dev,
 	dev->iobase = io_base;
 	dev->board_name = thisboard->name;
 
-	if (alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
+	retval = comedi_alloc_subdevices(dev, 2);
+	if (retval)
+		return retval;
 
 	s = dev->subdevices + 0;
 	/* analog output subdevice */
diff --git a/drivers/staging/comedi/drivers/adl_pci7230.c b/drivers/staging/comedi/drivers/adl_pci7230.c
index 2c83492..62fdf7f 100644
--- a/drivers/staging/comedi/drivers/adl_pci7230.c
+++ b/drivers/staging/comedi/drivers/adl_pci7230.c
@@ -108,6 +108,7 @@ static int adl_pci7230_attach(struct comedi_device *dev,
 	struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
+	int ret;
 
 	printk(KERN_INFO "comedi%d: adl_pci7230\n", dev->minor);
 
@@ -116,8 +117,9 @@ static int adl_pci7230_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct adl_pci7230_private)) < 0)
 		return -ENOMEM;
 
-	if (alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
 	devpriv->pci_dev = adl_pci7230_find_pci(dev, it);
 	if (!devpriv->pci_dev)
diff --git a/drivers/staging/comedi/drivers/adl_pci7296.c b/drivers/staging/comedi/drivers/adl_pci7296.c
index 0b8b279..58deb60 100644
--- a/drivers/staging/comedi/drivers/adl_pci7296.c
+++ b/drivers/staging/comedi/drivers/adl_pci7296.c
@@ -92,8 +92,9 @@ static int adl_pci7296_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct adl_pci7296_private)) < 0)
 		return -ENOMEM;
 
-	if (alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		return ret;
 
 	devpriv->pci_dev = adl_pci7296_find_pci(dev, it);
 	if (!devpriv->pci_dev)
diff --git a/drivers/staging/comedi/drivers/adl_pci7432.c b/drivers/staging/comedi/drivers/adl_pci7432.c
index dd818f1..aabf418 100644
--- a/drivers/staging/comedi/drivers/adl_pci7432.c
+++ b/drivers/staging/comedi/drivers/adl_pci7432.c
@@ -117,6 +117,7 @@ static int adl_pci7432_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
+	int ret;
 
 	printk(KERN_INFO "comedi%d: attach adl_pci7432\n", dev->minor);
 
@@ -125,8 +126,9 @@ static int adl_pci7432_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct adl_pci7432_private)) < 0)
 		return -ENOMEM;
 
-	if (alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
 	devpriv->pci_dev = adl_pci7432_find_pci(dev, it);
 	if (!devpriv->pci_dev)
diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c b/drivers/staging/comedi/drivers/adl_pci8164.c
index 3447548..1811375 100644
--- a/drivers/staging/comedi/drivers/adl_pci8164.c
+++ b/drivers/staging/comedi/drivers/adl_pci8164.c
@@ -252,6 +252,7 @@ static int adl_pci8164_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
+	int ret;
 
 	printk(KERN_INFO "comedi: attempt to attach...\n");
 	printk(KERN_INFO "comedi%d: adl_pci8164\n", dev->minor);
@@ -261,8 +262,9 @@ static int adl_pci8164_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct adl_pci8164_private)) < 0)
 		return -ENOMEM;
 
-	if (alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		return ret;
 
 	devpriv->pci_dev = adl_pci8164_find_pci(dev, it);
 	if (!devpriv->pci_dev)
diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 410bbf9..4f2cea8 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -1317,8 +1317,8 @@ static int pci9111_attach(struct comedi_device *dev,
 
 	/*  TODO: Add external multiplexer setup (according to option[2]). */
 
-	error = alloc_subdevices(dev, 4);
-	if (error < 0)
+	error = comedi_alloc_subdevices(dev, 4);
+	if (error)
 		return error;
 
 	subdevice = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 3670ebd..e1958e3 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -2268,8 +2268,8 @@ static int pci9118_attach(struct comedi_device *dev,
 	pci_write_config_word(devpriv->pcidev, PCI_COMMAND, u16w | 64);
 				/* Enable parity check for parity error */
 
-	ret = alloc_subdevices(dev, 4);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/adq12b.c b/drivers/staging/comedi/drivers/adq12b.c
index 1da2989..f7bb145 100644
--- a/drivers/staging/comedi/drivers/adq12b.c
+++ b/drivers/staging/comedi/drivers/adq12b.c
@@ -224,6 +224,7 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 	int unipolar, differential;
+	int ret;
 
 	iobase = it->options[0];
 	unipolar = it->options[1];
@@ -267,12 +268,9 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	devpriv->last_channel = -1;
 	devpriv->last_range = -1;
 
-/*
- * Allocate the subdevice structures.  alloc_subdevice() is a
- * convenient macro defined in comedidev.h.
- */
-	if (alloc_subdevices(dev, 3) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* analog input subdevice */
diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index db9f0a5..60a50ad 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -1433,8 +1433,8 @@ static int pci1710_attach(struct comedi_device *dev,
 	if (this_board->n_counter)
 		n_subdevices++;
 
-	ret = alloc_subdevices(dev, n_subdevices);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, n_subdevices);
+	if (ret)
 		return ret;
 
 	pci1710_reset(dev);
diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index b8768b5..d37c14d 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -365,11 +365,9 @@ static int pci1723_attach(struct comedi_device *dev,
 	if (this_board->n_diochan)
 		n_subdevices++;
 
-	ret = alloc_subdevices(dev, n_subdevices);
-	if (ret < 0) {
-		printk(" - Allocation failed!\n");
+	ret = comedi_alloc_subdevices(dev, n_subdevices);
+	if (ret)
 		return ret;
-	}
 
 	pci1723_reset(dev);
 	subdev = 0;
diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index df8236c..942dc77 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -1156,8 +1156,8 @@ static int pci_dio_attach(struct comedi_device *dev,
 				n_subdevices++;
 	}
 
-	ret = alloc_subdevices(dev, n_subdevices);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, n_subdevices);
+	if (ret)
 		return ret;
 
 	subdev = 0;
diff --git a/drivers/staging/comedi/drivers/aio_aio12_8.c b/drivers/staging/comedi/drivers/aio_aio12_8.c
index d215ae1..f7d453f 100644
--- a/drivers/staging/comedi/drivers/aio_aio12_8.c
+++ b/drivers/staging/comedi/drivers/aio_aio12_8.c
@@ -168,6 +168,7 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 	const struct aio12_8_boardtype *board = comedi_board(dev);
 	int iobase;
 	struct comedi_subdevice *s;
+	int ret;
 
 	iobase = it->options[0];
 	if (!request_region(iobase, 24, "aio_aio12_8")) {
@@ -182,8 +183,9 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct aio12_8_private)) < 0)
 		return -ENOMEM;
 
-	if (alloc_subdevices(dev, 3) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
+		return ret;
 
 	s = &dev->subdevices[0];
 	s->type = COMEDI_SUBD_AI;
diff --git a/drivers/staging/comedi/drivers/aio_iiro_16.c b/drivers/staging/comedi/drivers/aio_iiro_16.c
index 5c1548b..8059cef 100644
--- a/drivers/staging/comedi/drivers/aio_iiro_16.c
+++ b/drivers/staging/comedi/drivers/aio_iiro_16.c
@@ -107,6 +107,7 @@ static int aio_iiro_16_attach(struct comedi_device *dev,
 	const struct aio_iiro_16_board *board = comedi_board(dev);
 	int iobase;
 	struct comedi_subdevice *s;
+	int ret;
 
 	printk(KERN_INFO "comedi%d: aio_iiro_16: ", dev->minor);
 
@@ -124,8 +125,9 @@ static int aio_iiro_16_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct aio_iiro_16_private)) < 0)
 		return -ENOMEM;
 
-	if (alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	s->type = COMEDI_SUBD_DIO;
diff --git a/drivers/staging/comedi/drivers/amplc_dio200.c b/drivers/staging/comedi/drivers/amplc_dio200.c
index 3afebb2..c67b09f 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200.c
@@ -1273,11 +1273,11 @@ static int dio200_common_attach(struct comedi_device *dev, unsigned long iobase,
 	devpriv->intr_sd = -1;
 	dev->iobase = iobase;
 	dev->board_name = thisboard->name;
-	ret = alloc_subdevices(dev, layout->n_subdevs);
-	if (ret < 0) {
-		dev_err(dev->class_dev, "error! out of memory!\n");
+
+	ret = comedi_alloc_subdevices(dev, layout->n_subdevs);
+	if (ret)
 		return ret;
-	}
+
 	for (n = 0; n < dev->n_subdevices; n++) {
 		s = &dev->subdevices[n];
 		switch (layout->sdtype[n]) {
diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 9cf514e..e55321e 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -455,11 +455,9 @@ static int pc236_common_attach(struct comedi_device *dev, unsigned long iobase,
 	dev->board_name = thisboard->name;
 	dev->iobase = iobase;
 
-	ret = alloc_subdevices(dev, 2);
-	if (ret < 0) {
-		dev_err(dev->class_dev, "error! out of memory!\n");
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
 		return ret;
-	}
 
 	s = dev->subdevices + 0;
 	/* digital i/o subdevice (8255) */
diff --git a/drivers/staging/comedi/drivers/amplc_pc263.c b/drivers/staging/comedi/drivers/amplc_pc263.c
index 7020907..4f15bfd 100644
--- a/drivers/staging/comedi/drivers/amplc_pc263.c
+++ b/drivers/staging/comedi/drivers/amplc_pc263.c
@@ -227,11 +227,9 @@ static int pc263_common_attach(struct comedi_device *dev, unsigned long iobase)
 	dev->board_name = thisboard->name;
 	dev->iobase = iobase;
 
-	ret = alloc_subdevices(dev, 1);
-	if (ret < 0) {
-		dev_err(dev->class_dev, "error! out of memory!\n");
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
 		return ret;
-	}
 
 	s = dev->subdevices + 0;
 	/* digital output subdevice */
diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 43f07f8..600aeee 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -1382,12 +1382,9 @@ static int pci224_attach_common(struct comedi_device *dev,
 	outw(devpriv->daccon | PCI224_DACCON_FIFORESET,
 	     dev->iobase + PCI224_DACCON);
 
-	/* Allocate subdevices.  There is only one!  */
-	ret = alloc_subdevices(dev, 1);
-	if (ret < 0) {
-		dev_err(dev->class_dev, "error! out of memory!\n");
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
 		return ret;
-	}
 
 	s = dev->subdevices + 0;
 	/* Analog output subdevice. */
diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 30487be..9f7e115 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -2840,12 +2840,11 @@ static int pci230_attach_common(struct comedi_device *dev,
 		dev_dbg(dev->class_dev, "registered irq %u\n",
 			devpriv->pci_dev->irq);
 	}
-	/*
-	 * Allocate the subdevice structures.  alloc_subdevice() is a
-	 * convenient macro defined in comedidev.h.
-	 */
-	if (alloc_subdevices(dev, 3) < 0)
-		return -ENOMEM;
+
+	rc = comedi_alloc_subdevices(dev, 3);
+	if (rc)
+		return rc;
+
 	s = dev->subdevices + 0;
 	/* analog input subdevice */
 	s->type = COMEDI_SUBD_AI;
diff --git a/drivers/staging/comedi/drivers/c6xdigio.c b/drivers/staging/comedi/drivers/c6xdigio.c
index fb9951a..41ed857 100644
--- a/drivers/staging/comedi/drivers/c6xdigio.c
+++ b/drivers/staging/comedi/drivers/c6xdigio.c
@@ -433,8 +433,8 @@ static int c6xdigio_attach(struct comedi_device *dev,
 	dev->iobase = iobase;
 	dev->board_name = "c6xdigio";
 
-	result = alloc_subdevices(dev, 2);	/*  3 with encoder_init write */
-	if (result < 0)
+	result = comedi_alloc_subdevices(dev, 2);
+	if (result)
 		return result;
 
 	/*  Make sure that PnP ports get activated */
diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 3515923..0310077 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -195,8 +195,9 @@ static int das16cs_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct das16cs_private)) < 0)
 		return -ENOMEM;
 
-	if (alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	dev->read_subdev = s;
diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 074feee..718102c 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -532,7 +532,7 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 	struct pci_dev *pcidev = NULL;
 	int index;
-	int i;
+	int ret, i;
 
 /*
  * Allocate the private structure area.
@@ -614,11 +614,9 @@ found:
 	/* Initialize dev->board_name */
 	dev->board_name = thisboard->name;
 
-/*
- * Allocate the subdevice structures.
- */
-	if (alloc_subdevices(dev, 7) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 7);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* analog input subdevice */
diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 5bcadcb..c567fe6 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1343,10 +1343,11 @@ static int setup_subdevices(struct comedi_device *dev)
 {
 	struct comedi_subdevice *s;
 	void __iomem *dio_8255_iobase;
-	int i;
+	int ret, i;
 
-	if (alloc_subdevices(dev, 10) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 10);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* analog input subdevice */
diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index dc4cf0b..0572dc6 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -265,7 +265,7 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 	struct pci_dev *pcidev = NULL;
 	int index;
-
+	int ret;
 
 /*
  * Allocate the private structure area.
@@ -333,11 +333,9 @@ found:
  */
 	dev->board_name = thisboard->name;
 
-/*
- * Allocate the subdevice structures.
- */
-	if (alloc_subdevices(dev, 3) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* analog output subdevice */
diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 58d5a3d..402aa49 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -115,7 +115,7 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct pci_dev *pcidev = NULL;
 	int index;
-	int i;
+	int ret, i;
 
 /*
  * Allocate the private structure area.  alloc_private() is a
@@ -177,12 +177,9 @@ found:
 	    pci_resource_start(devpriv->pci_dev,
 			       pcidio_boards[index].dioregs_badrindex);
 
-/*
- * Allocate the subdevice structures.  alloc_subdevice() is a
- * convenient macro defined in comedidev.h.
- */
-	if (alloc_subdevices(dev, thisboard->n_8255) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, thisboard->n_8255);
+	if (ret)
+		return ret;
 
 	for (i = 0; i < thisboard->n_8255; i++) {
 		subdev_8255_init(dev, dev->subdevices + i,
diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index a06b67a..b99a451b 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -187,6 +187,7 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 	struct pci_dev *pcidev = NULL;
 	int index;
+	int ret;
 	/* int i; */
 
 /*
@@ -269,12 +270,9 @@ found:
 	/* Initialize dev->board_name */
 	dev->board_name = thisboard->name;
 
-/*
- * Allocate the subdevice structures.  alloc_subdevice() is a
- * convenient macro defined in comedidev.h.
- */
-	if (alloc_subdevices(dev, 3) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* dev->read_subdev=s; */
diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index bec250b..a801461 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -236,12 +236,9 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
  */
 	dev->board_name = thisboard->name;
 
-/*
- * Allocate the subdevice structures.  alloc_subdevice() is a
- * convenient macro defined in comedidev.h.
- */
-	if (alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
+	err = comedi_alloc_subdevices(dev, 2);
+	if (err)
+		return err;
 
 	s = dev->subdevices + 0;
 
diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 29412de..0260ddc 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -336,6 +336,7 @@ static int bonding_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
+	int ret;
 
 	LOG_MSG("comedi%d\n", dev->minor);
 
@@ -358,12 +359,9 @@ static int bonding_attach(struct comedi_device *dev,
 	 */
 	dev->board_name = devpriv->name;
 
-	/*
-	 * Allocate the subdevice structures.  alloc_subdevice() is a
-	 * convenient macro defined in comedidev.h.
-	 */
-	if (alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	s->type = COMEDI_SUBD_DIO;
diff --git a/drivers/staging/comedi/drivers/comedi_parport.c b/drivers/staging/comedi/drivers/comedi_parport.c
index bff5dcd..589d12f 100644
--- a/drivers/staging/comedi/drivers/comedi_parport.c
+++ b/drivers/staging/comedi/drivers/comedi_parport.c
@@ -315,9 +315,10 @@ static int parport_attach(struct comedi_device *dev,
 	}
 	dev->board_name = "parport";
 
-	ret = alloc_subdevices(dev, 4);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
 		return ret;
+
 	ret = alloc_private(dev, sizeof(struct parport_private));
 	if (ret < 0)
 		return ret;
diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index 9f3c3d5..523a809 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -432,6 +432,7 @@ static int waveform_attach(struct comedi_device *dev,
 	int amplitude = it->options[0];
 	int period = it->options[1];
 	int i;
+	int ret;
 
 	dev->board_name = board->name;
 
@@ -447,9 +448,9 @@ static int waveform_attach(struct comedi_device *dev,
 	devpriv->uvolt_amplitude = amplitude;
 	devpriv->usec_period = period;
 
-	dev->n_subdevices = 2;
-	if (alloc_subdevices(dev, dev->n_subdevices) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	dev->read_subdev = s;
diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 2cd7407..79854b1 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -107,6 +107,7 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct pci_dev *pcidev = NULL;
 	struct comedi_subdevice *s;
+	int ret;
 
 	printk("comedi%d: contec: ", dev->minor);
 
@@ -115,8 +116,9 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (alloc_private(dev, sizeof(struct contec_private)) < 0)
 		return -ENOMEM;
 
-	if (alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
 	for_each_pci_dev(pcidev) {
 		if (pcidev->vendor == PCI_VENDOR_ID_CONTEC &&
diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index d84794c..c2246d8 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -772,8 +772,8 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	if (!devpriv->plx || !devpriv->daq)
 		return -ENOMEM;
 
-	result = alloc_subdevices(dev, 3);
-	if (result < 0)
+	result = comedi_alloc_subdevices(dev, 3);
+	if (result)
 		goto out;
 
 	readl(devpriv->plx + 0x6c);
diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index fa2784d..18426f1 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -842,8 +842,8 @@ int das08_common_attach(struct comedi_device *dev, unsigned long iobase)
 
 	dev->board_name = thisboard->name;
 
-	ret = alloc_subdevices(dev, 6);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 6);
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index 6170536..0c6ad10 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -1264,8 +1264,8 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 	devpriv->timer_mode = timer_mode ? 1 : 0;
 
-	ret = alloc_subdevices(dev, 5);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 5);
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index e468ff1..f3fba13 100644
--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -646,8 +646,8 @@ static int das16m1_attach(struct comedi_device *dev,
 		return -EINVAL;
 	}
 
-	ret = alloc_subdevices(dev, 4);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index 079fb06..af60e5d5 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -1644,8 +1644,9 @@ static int das1800_attach(struct comedi_device *dev,
 			return -ENOMEM;
 	}
 
-	if (alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
+	retval = comedi_alloc_subdevices(dev, 4);
+	if (retval)
+		return retval;
 
 	/* analog input subdevice */
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
index 881f392..22a9b34 100644
--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -307,8 +307,8 @@ static int das6402_attach(struct comedi_device *dev,
 	if (ret < 0)
 		return ret;
 
-	ret = alloc_subdevices(dev, 1);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
 		return ret;
 
 	/* ai subdevice */
diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/comedi/drivers/das800.c
index 4e33b2a..81698b1 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -465,6 +465,7 @@ static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned int irq = it->options[1];
 	unsigned long irq_flags;
 	int board;
+	int ret;
 
 	dev_info(dev->hw_dev, "comedi%d: das800: io 0x%lx\n", dev->minor,
 		 iobase);
@@ -510,8 +511,9 @@ static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->board_name = thisboard->name;
 
-	if (alloc_subdevices(dev, 3) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
+		return ret;
 
 	/* analog input subdevice */
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index 5be99b5..2b60cf8 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -371,12 +371,9 @@ static int dmm32at_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct dmm32at_private)) < 0)
 		return -ENOMEM;
 
-/*
- * Allocate the subdevice structures.  alloc_subdevice() is a
- * convenient macro defined in comedidev.h.
- */
-	if (alloc_subdevices(dev, 3) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	dev->read_subdev = s;
diff --git a/drivers/staging/comedi/drivers/dt2801.c b/drivers/staging/comedi/drivers/dt2801.c
index 625bd61..ef378ab 100644
--- a/drivers/staging/comedi/drivers/dt2801.c
+++ b/drivers/staging/comedi/drivers/dt2801.c
@@ -628,8 +628,8 @@ havetype:
 	n_ai_chans = probe_number_of_ai_chans(dev);
 	printk(" (ai channels = %d)", n_ai_chans);
 
-	ret = alloc_subdevices(dev, 4);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
 		goto out;
 
 	ret = alloc_private(dev, sizeof(struct dt2801_private));
diff --git a/drivers/staging/comedi/drivers/dt2811.c b/drivers/staging/comedi/drivers/dt2811.c
index 727da9e..91fbf4a 100644
--- a/drivers/staging/comedi/drivers/dt2811.c
+++ b/drivers/staging/comedi/drivers/dt2811.c
@@ -465,8 +465,8 @@ static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 #endif
 
-	ret = alloc_subdevices(dev, 4);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
 		return ret;
 
 	ret = alloc_private(dev, sizeof(struct dt2811_private));
diff --git a/drivers/staging/comedi/drivers/dt2814.c b/drivers/staging/comedi/drivers/dt2814.c
index fa4ade6..2e39ebe 100644
--- a/drivers/staging/comedi/drivers/dt2814.c
+++ b/drivers/staging/comedi/drivers/dt2814.c
@@ -338,8 +338,8 @@ static int dt2814_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 #endif
 	}
 
-	ret = alloc_subdevices(dev, 1);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
 		return ret;
 
 	ret = alloc_private(dev, sizeof(struct dt2814_private));
diff --git a/drivers/staging/comedi/drivers/dt2815.c b/drivers/staging/comedi/drivers/dt2815.c
index bbab712..7ced76b 100644
--- a/drivers/staging/comedi/drivers/dt2815.c
+++ b/drivers/staging/comedi/drivers/dt2815.c
@@ -163,7 +163,7 @@ static int dt2815_ao_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 static int dt2815_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
-	int i;
+	int ret, i;
 	const struct comedi_lrange *current_range_type, *voltage_range_type;
 	unsigned long iobase;
 
@@ -177,8 +177,10 @@ static int dt2815_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->iobase = iobase;
 	dev->board_name = "dt2815";
 
-	if (alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
+
 	if (alloc_private(dev, sizeof(struct dt2815_private)) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/dt2817.c b/drivers/staging/comedi/drivers/dt2817.c
index 1ee10e7b..9282ca5 100644
--- a/drivers/staging/comedi/drivers/dt2817.c
+++ b/drivers/staging/comedi/drivers/dt2817.c
@@ -137,8 +137,8 @@ static int dt2817_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->iobase = iobase;
 	dev->board_name = "dt2817";
 
-	ret = alloc_subdevices(dev, 1);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index eefda3c..9c0a0df 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -1268,8 +1268,8 @@ static int dt282x_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret < 0)
 		return ret;
 
-	ret = alloc_subdevices(dev, 3);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index af02024..9828fb1 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -882,8 +882,8 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 	dev->irq = devpriv->pci_dev->irq;
 
-	ret = alloc_subdevices(dev, 4);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
 		return ret;
 
 	s = dev->subdevices;
diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index 22cda5c..e20cfb4 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -1019,7 +1019,7 @@ static int dt9812_ao_winsn(struct comedi_device *dev,
 
 static int dt9812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
-	int i;
+	int ret, i;
 	struct comedi_subdevice *s;
 
 	dev->board_name = "dt9812";
@@ -1035,9 +1035,9 @@ static int dt9812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	devpriv->serial = it->options[0];
 
-	/* Allocate subdevices */
-	if (alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		return ret;
 
 	/* digital input subdevice */
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 367a7c8..9c855e2 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -246,6 +246,7 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 	struct pci_dev *pcidev;
 	unsigned int opt_bus, opt_slot;
 	int board_index, i;
+	int ret;
 
 	mutex_lock(&start_stop_sem);
 
@@ -329,11 +330,10 @@ found:
 	devpriv->BADR4 = pci_resource_start(pcidev, 4);
 	devpriv->BADR5 = pci_resource_start(pcidev, 5);
 
-	if (alloc_subdevices(dev, 4) < 0) {
-		printk(KERN_ERR "comedi: dyna_pci10xx: "
-			"failed allocating subdevices\n");
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret) {
 		mutex_unlock(&start_stop_sem);
-		return -ENOMEM;
+		return ret;
 	}
 
 	/* analog input */
diff --git a/drivers/staging/comedi/drivers/fl512.c b/drivers/staging/comedi/drivers/fl512.c
index d2381445..d1da809 100644
--- a/drivers/staging/comedi/drivers/fl512.c
+++ b/drivers/staging/comedi/drivers/fl512.c
@@ -111,6 +111,7 @@ static int fl512_ao_insn_readback(struct comedi_device *dev,
 static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	unsigned long iobase;
+	int ret;
 
 	/* pointer to the subdevice: Analog in, Analog out,
 	   (not made ->and Digital IO) */
@@ -131,8 +132,9 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk(KERN_DEBUG "malloc ok\n");
 #endif
 
-	if (alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
 	/*
 	 * this if the definitions of the supdevices, 2 have been defined
diff --git a/drivers/staging/comedi/drivers/gsc_hpdi.c b/drivers/staging/comedi/drivers/gsc_hpdi.c
index fe1fd2f..79f5808 100644
--- a/drivers/staging/comedi/drivers/gsc_hpdi.c
+++ b/drivers/staging/comedi/drivers/gsc_hpdi.c
@@ -430,9 +430,11 @@ static void init_plx9080(struct comedi_device *dev)
 static int setup_subdevices(struct comedi_device *dev)
 {
 	struct comedi_subdevice *s;
+	int ret;
 
-	if (alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* analog input subdevice */
diff --git a/drivers/staging/comedi/drivers/icp_multi.c b/drivers/staging/comedi/drivers/icp_multi.c
index 1f254f4..544bed8 100644
--- a/drivers/staging/comedi/drivers/icp_multi.c
+++ b/drivers/staging/comedi/drivers/icp_multi.c
@@ -903,8 +903,8 @@ static int icp_multi_attach(struct comedi_device *dev,
 	if (this_board->n_ctrs)
 		n_subdevices++;
 
-	ret = alloc_subdevices(dev, n_subdevices);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, n_subdevices);
+	if (ret)
 		return ret;
 
 	icp_multi_reset(dev);
diff --git a/drivers/staging/comedi/drivers/ii_pci20kc.c b/drivers/staging/comedi/drivers/ii_pci20kc.c
index 6f69476..bea3d03 100644
--- a/drivers/staging/comedi/drivers/ii_pci20kc.c
+++ b/drivers/staging/comedi/drivers/ii_pci20kc.c
@@ -202,8 +202,8 @@ static int pci20xxx_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 	union pci20xxx_subdev_private *sdp;
 
-	ret = alloc_subdevices(dev, 1 + PCI20000_MODULES);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 1 + PCI20000_MODULES);
+	if (ret)
 		return ret;
 
 	ret = alloc_private(dev, sizeof(struct pci20xxx_private));
diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index e8dfc36..bc63ab3 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -826,8 +826,8 @@ static int jr3_pci_attach(struct comedi_device *dev,
 	if (!devpriv->iobase)
 		return -ENOMEM;
 
-	result = alloc_subdevices(dev, devpriv->n_channels);
-	if (result < 0)
+	result = comedi_alloc_subdevices(dev, devpriv->n_channels);
+	if (result)
 		goto out;
 
 	dev->open = jr3_pci_open;
diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index 9f92420..019e91a 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -189,9 +189,8 @@ found:
 	io_base = pci_resource_start(pci_device, 0);
 	dev->iobase = io_base;
 
-	/* allocate the subdevice structures */
-	error = alloc_subdevices(dev, 1);
-	if (error < 0)
+	error = comedi_alloc_subdevices(dev, 1);
+	if (error)
 		return error;
 
 	subdevice = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index cb6bf8c..c8ee22d 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -2190,13 +2190,9 @@ static int me4000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (result)
 		return result;
 
-	/*
-	 * Allocate the subdevice structures.  alloc_subdevice() is a
-	 * convenient macro defined in comedidev.h.  It relies on
-	 * n_subdevices being set correctly.
-	 */
-	if (alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
+	result = comedi_alloc_subdevices(dev, 4);
+	if (result)
+		return result;
 
     /*=========================================================================
       Analog input subdevice
diff --git a/drivers/staging/comedi/drivers/me_daq.c b/drivers/staging/comedi/drivers/me_daq.c
index fcadb0f..ae3b046 100644
--- a/drivers/staging/comedi/drivers/me_daq.c
+++ b/drivers/staging/comedi/drivers/me_daq.c
@@ -761,9 +761,8 @@ found:
 
 	me_reset(dev);
 
-	/* device driver capabilities */
-	error = alloc_subdevices(dev, 3);
-	if (error < 0)
+	error = comedi_alloc_subdevices(dev, 3);
+	if (error)
 		return error;
 
 	subdevice = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/mpc624.c b/drivers/staging/comedi/drivers/mpc624.c
index 4304e86..b928b67 100644
--- a/drivers/staging/comedi/drivers/mpc624.c
+++ b/drivers/staging/comedi/drivers/mpc624.c
@@ -285,6 +285,7 @@ static int mpc624_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
 	unsigned long iobase;
+	int ret;
 
 	iobase = it->options[0];
 	printk(KERN_INFO "comedi%d: mpc624 [0x%04lx, ", dev->minor, iobase);
@@ -348,9 +349,9 @@ static int mpc624_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		devpriv->ulConvertionRate = MPC624_SPEED_3_52_kHz;
 	}
 
-	/*  Subdevices structures */
-	if (alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	s->type = COMEDI_SUBD_AI;
diff --git a/drivers/staging/comedi/drivers/multiq3.c b/drivers/staging/comedi/drivers/multiq3.c
index e951e73..b1bbd02 100644
--- a/drivers/staging/comedi/drivers/multiq3.c
+++ b/drivers/staging/comedi/drivers/multiq3.c
@@ -255,8 +255,9 @@ static int multiq3_attach(struct comedi_device *dev,
 	else
 		printk(KERN_WARNING "comedi%d: no irq\n", dev->minor);
 	dev->board_name = "multiq3";
-	result = alloc_subdevices(dev, 5);
-	if (result < 0)
+
+	result = comedi_alloc_subdevices(dev, 5);
+	if (result)
 		return result;
 
 	result = alloc_private(dev, sizeof(struct multiq3_private));
diff --git a/drivers/staging/comedi/drivers/ni_6527.c b/drivers/staging/comedi/drivers/ni_6527.c
index b02aa0e..b60ab48 100644
--- a/drivers/staging/comedi/drivers/ni_6527.c
+++ b/drivers/staging/comedi/drivers/ni_6527.c
@@ -397,8 +397,8 @@ static int ni6527_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk(KERN_INFO "comedi board: %s, ID=0x%02x\n", dev->board_name,
 		readb(devpriv->mite->daq_io_addr + ID_Register));
 
-	ret = alloc_subdevices(dev, 3);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index 0d27a93..ac7c74b 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -678,8 +678,8 @@ static int ni_65xx_attach(struct comedi_device *dev,
 	printk(KERN_INFO " ID=0x%02x",
 	       readb(private(dev)->mite->daq_io_addr + ID_Register));
 
-	ret = alloc_subdevices(dev, 4);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index 8c40730..5391a39 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -1093,10 +1093,9 @@ static int ni_660x_attach(struct comedi_device *dev,
 
 	printk(KERN_INFO " %s ", dev->board_name);
 
-	dev->n_subdevices = 2 + NI_660X_MAX_NUM_COUNTERS;
-
-	if (alloc_subdevices(dev, dev->n_subdevices) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 2 + NI_660X_MAX_NUM_COUNTERS);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* Old GENERAL-PURPOSE COUNTER/TIME (GPCT) subdevice, no longer used */
diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index a9cf94f..5dffe6c 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -202,8 +202,9 @@ static int ni_670x_attach(struct comedi_device *dev,
 	dev->irq = mite_irq(devpriv->mite);
 	printk(KERN_INFO " %s", dev->board_name);
 
-	if (alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* analog output subdevice */
diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index ae896a0..bdeb3c2 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -754,7 +754,7 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned int irq = it->options[1];
 	unsigned int dma = it->options[2];
 	static const int timeout = 2000;
-	int i;
+	int ret, i;
 
 	printk("comedi%d: %s: io 0x%lx", dev->minor, dev->driver->driver_name,
 	       iobase);
@@ -826,8 +826,9 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->board_ptr = a2150_boards + a2150_probe(dev);
 	dev->board_name = thisboard->name;
 
-	if (alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
 
 	/* analog input subdevice */
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/ni_at_ao.c b/drivers/staging/comedi/drivers/ni_at_ao.c
index bfe7fb7..1c3f322 100644
--- a/drivers/staging/comedi/drivers/ni_at_ao.c
+++ b/drivers/staging/comedi/drivers/ni_at_ao.c
@@ -337,6 +337,7 @@ static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 	int ao_unipolar;
+	int ret;
 
 	iobase = it->options[0];
 	if (iobase == 0)
@@ -356,8 +357,9 @@ static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (alloc_private(dev, sizeof(struct atao_private)) < 0)
 		return -ENOMEM;
 
-	if (alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* analog output subdevice */
diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index a0890ee..95bee84 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -709,8 +709,8 @@ static int atmio16d_attach(struct comedi_device *dev,
 
 	dev->board_name = board->name;
 
-	ret = alloc_subdevices(dev, 4);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
 		return ret;
 
 	ret = alloc_private(dev, sizeof(struct atmio16d_private));
diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 75764e8..53b0173 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -364,6 +364,7 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned int irq = 0;
 #endif
 	struct pcmcia_device *link;
+	int ret;
 
 	/* allocate and initialize dev->private */
 	if (alloc_private(dev, sizeof(struct dio700_private)) < 0)
@@ -409,8 +410,9 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->board_name = thisboard->name;
 
-	if (alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
 
 	/* DAQCard-700 dio */
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/ni_daq_dio24.c b/drivers/staging/comedi/drivers/ni_daq_dio24.c
index 493a227..e27cae0 100644
--- a/drivers/staging/comedi/drivers/ni_daq_dio24.c
+++ b/drivers/staging/comedi/drivers/ni_daq_dio24.c
@@ -116,6 +116,7 @@ static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned int irq = 0;
 #endif
 	struct pcmcia_device *link;
+	int ret;
 
 	/* allocate and initialize dev->private */
 	if (alloc_private(dev, sizeof(struct dio24_private)) < 0)
@@ -158,8 +159,9 @@ static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->board_name = thisboard->name;
 
-	if (alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
 
 	/* 8255 dio */
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 5334977..121f8cb 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -530,7 +530,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 			unsigned int irq, unsigned int dma_chan)
 {
 	struct comedi_subdevice *s;
-	int i;
+	int ret, i;
 	unsigned long isr_flags;
 #ifdef CONFIG_ISA_DMA_API
 	unsigned long dma_flags;
@@ -622,8 +622,9 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 
 	dev->board_name = thisboard->name;
 
-	if (alloc_subdevices(dev, 5) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 5);
+	if (ret)
+		return ret;
 
 	/* analog input subdevice */
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index fd232bc..1f796b9 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -4406,14 +4406,16 @@ static int ni_E_init(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_subdevice *s;
 	unsigned j;
 	enum ni_gpct_variant counter_variant;
+	int ret;
 
 	if (boardtype.n_aochan > MAX_N_AO_CHAN) {
 		printk("bug! boardtype.n_aochan > MAX_N_AO_CHAN\n");
 		return -EINVAL;
 	}
 
-	if (alloc_subdevices(dev, NI_NUM_SUBDEVICES) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, NI_NUM_SUBDEVICES);
+	if (ret)
+		return ret;
 
 	/* analog input subdevice */
 
diff --git a/drivers/staging/comedi/drivers/ni_pcidio.c b/drivers/staging/comedi/drivers/ni_pcidio.c
index 37b7008..cba0459 100644
--- a/drivers/staging/comedi/drivers/ni_pcidio.c
+++ b/drivers/staging/comedi/drivers/ni_pcidio.c
@@ -1248,8 +1248,8 @@ static int nidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	else
 		n_subdevices = 1;
 
-	ret = alloc_subdevices(dev, n_subdevices);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, n_subdevices);
+	if (ret)
 		return ret;
 
 	if (!this_board->is_diodaq) {
diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index e943b52..d5fa6f2 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -518,8 +518,8 @@ static int pcl711_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 	dev->irq = irq;
 
-	ret = alloc_subdevices(dev, 4);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
 		return ret;
 
 	ret = alloc_private(dev, sizeof(struct pcl711_private));
diff --git a/drivers/staging/comedi/drivers/pcl724.c b/drivers/staging/comedi/drivers/pcl724.c
index 4136a03..c8fe23c 100644
--- a/drivers/staging/comedi/drivers/pcl724.c
+++ b/drivers/staging/comedi/drivers/pcl724.c
@@ -156,8 +156,8 @@ static int pcl724_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 					 || (it->options[1] == 96)))
 		n_subdevices = 4;	/*  PCL-724 in 96 DIO configuration */
 
-	ret = alloc_subdevices(dev, n_subdevices);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, n_subdevices);
+	if (ret)
 		return ret;
 
 	for (i = 0; i < dev->n_subdevices; i++) {
diff --git a/drivers/staging/comedi/drivers/pcl725.c b/drivers/staging/comedi/drivers/pcl725.c
index 83a6fa5..8edbefd 100644
--- a/drivers/staging/comedi/drivers/pcl725.c
+++ b/drivers/staging/comedi/drivers/pcl725.c
@@ -52,6 +52,7 @@ static int pcl725_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
 	unsigned long iobase;
+	int ret;
 
 	iobase = it->options[0];
 	printk(KERN_INFO "comedi%d: pcl725: 0x%04lx ", dev->minor, iobase);
@@ -63,8 +64,9 @@ static int pcl725_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->iobase = iobase;
 	dev->irq = 0;
 
-	if (alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* do */
diff --git a/drivers/staging/comedi/drivers/pcl726.c b/drivers/staging/comedi/drivers/pcl726.c
index e9449bb..b2e73cd 100644
--- a/drivers/staging/comedi/drivers/pcl726.c
+++ b/drivers/staging/comedi/drivers/pcl726.c
@@ -292,8 +292,8 @@ static int pcl726_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	printk("\n");
 
-	ret = alloc_subdevices(dev, 3);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/pcl730.c b/drivers/staging/comedi/drivers/pcl730.c
index 02a4386..3cba79a 100644
--- a/drivers/staging/comedi/drivers/pcl730.c
+++ b/drivers/staging/comedi/drivers/pcl730.c
@@ -72,6 +72,7 @@ static int pcl730_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 	unsigned int iorange;
+	int ret;
 
 	iobase = it->options[0];
 	iorange = board->io_range;
@@ -85,8 +86,9 @@ static int pcl730_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->iobase = iobase;
 	dev->irq = 0;
 
-	if (alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* Isolated do */
diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 28780ed..0a4074a 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -1382,8 +1382,8 @@ no_dma:
 	if (board->n_dochan > 0)
 		n_subdevices++;
 
-	ret = alloc_subdevices(dev, n_subdevices);
-	if (ret < 0) {
+	ret = comedi_alloc_subdevices(dev, n_subdevices);
+	if (ret) {
 		free_resources(dev);
 		return ret;
 	}
diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index 277a23e..68ad759 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -1194,8 +1194,8 @@ no_dma:
     subdevs[3] = COMEDI_SUBD_DO;
 */
 
-	ret = alloc_subdevices(dev, 1);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 6c84b29..66b2570 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -1778,8 +1778,8 @@ no_rtc:
 
 no_dma:
 
-	ret = alloc_subdevices(dev, 4);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/pcm3724.c b/drivers/staging/comedi/drivers/pcm3724.c
index 9eee708..3381d29 100644
--- a/drivers/staging/comedi/drivers/pcm3724.c
+++ b/drivers/staging/comedi/drivers/pcm3724.c
@@ -233,7 +233,7 @@ static int pcm3724_attach(struct comedi_device *dev,
 	const struct pcm3724_board *board = comedi_board(dev);
 	unsigned long iobase;
 	unsigned int iorange;
-	int ret, i, n_subdevices;
+	int ret, i;
 
 	iobase = it->options[0];
 	iorange = board->io_range;
@@ -256,10 +256,8 @@ static int pcm3724_attach(struct comedi_device *dev,
 	dev->board_name = board->name;
 	printk(KERN_INFO "\n");
 
-	n_subdevices = board->numofports;
-
-	ret = alloc_subdevices(dev, n_subdevices);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, board->numofports);
+	if (ret)
 		return ret;
 
 	for (i = 0; i < dev->n_subdevices; i++) {
diff --git a/drivers/staging/comedi/drivers/pcm3730.c b/drivers/staging/comedi/drivers/pcm3730.c
index f8d1c64..b48f7aa 100644
--- a/drivers/staging/comedi/drivers/pcm3730.c
+++ b/drivers/staging/comedi/drivers/pcm3730.c
@@ -59,6 +59,7 @@ static int pcm3730_attach(struct comedi_device *dev,
 {
 	struct comedi_subdevice *s;
 	unsigned long iobase;
+	int ret;
 
 	iobase = it->options[0];
 	printk(KERN_INFO "comedi%d: pcm3730: 0x%04lx ", dev->minor, iobase);
@@ -71,8 +72,9 @@ static int pcm3730_attach(struct comedi_device *dev,
 	dev->iobase = dev->iobase;
 	dev->irq = 0;
 
-	if (alloc_subdevices(dev, 6) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 6);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	s->type = COMEDI_SUBD_DO;
diff --git a/drivers/staging/comedi/drivers/pcmad.c b/drivers/staging/comedi/drivers/pcmad.c
index 2ec0b2e..54d19c9 100644
--- a/drivers/staging/comedi/drivers/pcmad.c
+++ b/drivers/staging/comedi/drivers/pcmad.c
@@ -117,8 +117,8 @@ static int pcmad_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk(KERN_CONT "\n");
 	dev->iobase = iobase;
 
-	ret = alloc_subdevices(dev, 1);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
 		return ret;
 
 	ret = alloc_private(dev, sizeof(struct pcmad_priv_struct));
diff --git a/drivers/staging/comedi/drivers/pcmda12.c b/drivers/staging/comedi/drivers/pcmda12.c
index f49c66a..291ce7c 100644
--- a/drivers/staging/comedi/drivers/pcmda12.c
+++ b/drivers/staging/comedi/drivers/pcmda12.c
@@ -165,6 +165,7 @@ static int pcmda12_attach(struct comedi_device *dev,
 	const struct pcmda12_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 	unsigned long iobase;
+	int ret;
 
 	iobase = it->options[0];
 	printk(KERN_INFO
@@ -190,17 +191,9 @@ static int pcmda12_attach(struct comedi_device *dev,
 
 	devpriv->simultaneous_xfer_mode = it->options[1];
 
-	/*
-	 * Allocate the subdevice structures.  alloc_subdevice() is a
-	 * convenient macro defined in comedidev.h.
-	 *
-	 * Allocate 2 subdevs (32 + 16 DIO lines) or 3 32 DIO subdevs for the
-	 * 96-channel version of the board.
-	 */
-	if (alloc_subdevices(dev, 1) < 0) {
-		printk(KERN_ERR "cannot allocate subdevice data structures\n");
-		return -ENOMEM;
-	}
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices;
 	s->private = NULL;
diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index c4482ae..0e64d84 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -1020,6 +1020,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	    thisasic_chanct = 0;
 	unsigned long iobase;
 	unsigned int irq[MAX_ASICS];
+	int ret;
 
 	iobase = it->options[0];
 	irq[0] = it->options[1];
@@ -1071,17 +1072,10 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				dev->minor);
 		return -ENOMEM;
 	}
-	/*
-	 * Allocate the subdevice structures.  alloc_subdevice() is a
-	 * convenient macro defined in comedidev.h.
-	 *
-	 * Allocate 1 AI + 1 AO + 2 DIO subdevs (24 lines per DIO)
-	 */
-	if (alloc_subdevices(dev, n_subdevs) < 0) {
-		printk(KERN_ERR "comedi%d: cannot allocate subdevice data structures\n",
-				dev->minor);
-		return -ENOMEM;
-	}
+
+	ret = comedi_alloc_subdevices(dev, n_subdevs);
+	if (ret)
+		return ret;
 
 	/* First, AI */
 	sdev_no = 0;
diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index b1a9bed..48565fe 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -754,6 +754,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int sdev_no, chans_left, n_subdevs, port, asic, thisasic_chanct = 0;
 	unsigned long iobase;
 	unsigned int irq[MAX_ASICS];
+	int ret;
 
 	iobase = it->options[0];
 	irq[0] = it->options[1];
@@ -800,17 +801,10 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		dev_warn(dev->hw_dev, "cannot allocate subdevice private data structures\n");
 		return -ENOMEM;
 	}
-	/*
-	 * Allocate the subdevice structures.  alloc_subdevice() is a
-	 * convenient macro defined in comedidev.h.
-	 *
-	 * Allocate 2 subdevs (32 + 16 DIO lines) or 3 32 DIO subdevs for the
-	 * 96-channel version of the board.
-	 */
-	if (alloc_subdevices(dev, n_subdevs) < 0) {
-		dev_dbg(dev->hw_dev, "cannot allocate subdevice data structures\n");
-		return -ENOMEM;
-	}
+
+	ret = comedi_alloc_subdevices(dev, n_subdevs);
+	if (ret)
+		return ret;
 
 	port = 0;
 	asic = 0;
diff --git a/drivers/staging/comedi/drivers/poc.c b/drivers/staging/comedi/drivers/poc.c
index 95e348f..a129ccac 100644
--- a/drivers/staging/comedi/drivers/poc.c
+++ b/drivers/staging/comedi/drivers/poc.c
@@ -139,6 +139,7 @@ static int poc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 	unsigned int iosize;
+	int ret;
 
 	iobase = it->options[0];
 	printk(KERN_INFO "comedi%d: poc: using %s iobase 0x%lx\n", dev->minor,
@@ -160,8 +161,10 @@ static int poc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 	dev->iobase = iobase;
 
-	if (alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
+
 	if (alloc_private(dev, sizeof(unsigned int) * board->n_chan) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index 2f130b3..a029147 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -871,8 +871,8 @@ static int daqp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->iobase = local->link->resource[0]->start;
 
-	ret = alloc_subdevices(dev, 4);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
 		return ret;
 
 	printk(KERN_INFO "comedi%d: attaching daqp%d (io 0x%04lx)\n",
diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 84b28b6..c3c8097 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1999,13 +1999,9 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* Show board configuration */
 	printk(KERN_INFO "%s:", dev->board_name);
 
-	/*
-	 * Allocate the subdevice structures.  alloc_subdevice() is a
-	 * convenient macro defined in comedidev.h.
-	 */
-	if (alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
-
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	dev->read_subdev = s;
diff --git a/drivers/staging/comedi/drivers/rti800.c b/drivers/staging/comedi/drivers/rti800.c
index 04a2368..966ac2cc 100644
--- a/drivers/staging/comedi/drivers/rti800.c
+++ b/drivers/staging/comedi/drivers/rti800.c
@@ -348,8 +348,8 @@ static int rti800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->board_name = board->name;
 
-	ret = alloc_subdevices(dev, 4);
-	if (ret < 0)
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
 		return ret;
 
 	ret = alloc_private(dev, sizeof(struct rti800_private));
diff --git a/drivers/staging/comedi/drivers/rti802.c b/drivers/staging/comedi/drivers/rti802.c
index 09da5c2..d34f711 100644
--- a/drivers/staging/comedi/drivers/rti802.c
+++ b/drivers/staging/comedi/drivers/rti802.c
@@ -90,7 +90,7 @@ static int rti802_ao_insn_write(struct comedi_device *dev,
 static int rti802_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
-	int i;
+	int ret, i;
 	unsigned long iobase;
 
 	iobase = it->options[0];
@@ -103,10 +103,13 @@ static int rti802_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->board_name = "rti802";
 
-	if (alloc_subdevices(dev, 1) < 0
-	    || alloc_private(dev, sizeof(struct rti802_private))) {
-		return -ENOMEM;
-	}
+	ret = alloc_private(dev, sizeof(struct rti802_private));
+	if (ret)
+		return ret;
+
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices;
 	/* ao subdevice */
diff --git a/drivers/staging/comedi/drivers/s526.c b/drivers/staging/comedi/drivers/s526.c
index 3c8e979..1283030 100644
--- a/drivers/staging/comedi/drivers/s526.c
+++ b/drivers/staging/comedi/drivers/s526.c
@@ -742,7 +742,7 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	const struct s526_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 	int iobase;
-	int i, n;
+	int ret, i, n;
 /* short value; */
 /* int subdev_channel = 0; */
 	union cmReg cmReg;
@@ -774,13 +774,9 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (alloc_private(dev, sizeof(struct s526_private)) < 0)
 		return -ENOMEM;
 
-/*
- * Allocate the subdevice structures.  alloc_subdevice() is a
- * convenient macro defined in comedidev.h.
- */
-	dev->n_subdevices = 4;
-	if (alloc_subdevices(dev, dev->n_subdevices) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* GENERAL-PURPOSE COUNTER/TIME (GPCT) */
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index d6dc338..32e03bc 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -595,8 +595,9 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->board_ptr = s626_boards;
 	dev->board_name = thisboard->name;
 
-	if (alloc_subdevices(dev, 6) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 6);
+	if (ret)
+		return ret;
 
 	dev->iobase = (unsigned long)devpriv->base_addr;
 	dev->irq = devpriv->pdev->irq;
diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index 9200310..439fb50 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -780,6 +780,7 @@ static int serial2002_attach(struct comedi_device *dev,
 {
 	const struct serial2002_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
+	int ret;
 
 	dev_dbg(dev->hw_dev, "comedi%d: attached\n", dev->minor);
 	dev->board_name = board->name;
@@ -792,8 +793,9 @@ static int serial2002_attach(struct comedi_device *dev,
 	dev_dbg(dev->hw_dev, "/dev/ttyS%d @ %d\n", devpriv->port,
 		devpriv->speed);
 
-	if (alloc_subdevices(dev, 5) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 5);
+	if (ret)
+		return ret;
 
 	/* digital input subdevice */
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
index 7d13ffa..9d17ad1 100644
--- a/drivers/staging/comedi/drivers/skel.c
+++ b/drivers/staging/comedi/drivers/skel.c
@@ -210,6 +210,7 @@ static int skel_ns_to_timer(unsigned int *ns, int round);
 static int skel_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
+	int ret;
 
 	pr_info("comedi%d: skel: ", dev->minor);
 
@@ -233,12 +234,10 @@ static int skel_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (alloc_private(dev, sizeof(struct skel_private)) < 0)
 		return -ENOMEM;
 
-/*
- * Allocate the subdevice structures.  alloc_subdevice() is a
- * convenient macro defined in comedidev.h.
- */
-	if (alloc_subdevices(dev, 3) < 0)
-		return -ENOMEM;
+	/* Allocate the subdevice structures */
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* dev->read_subdev=s; */
diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
index de58095..b12bafe 100644
--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -187,6 +187,7 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct dnp_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
+	int ret;
 
 	printk(KERN_INFO "comedi%d: dnp: ", dev->minor);
 
@@ -197,11 +198,9 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (alloc_private(dev, sizeof(struct dnp_private_data)) < 0)
 		return -ENOMEM;
 
-	/* Allocate the subdevice structures. alloc_subdevice() is a         */
-	/* convenient macro defined in comedidev.h.                          */
-
-	if (alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* digital i/o subdevice                                             */
diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index d5f1f22..9f1fdec 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -443,6 +443,7 @@ static int unioxx5_attach(struct comedi_device *dev,
 {
 	int iobase, i, n_subd;
 	int id, num, ba;
+	int ret;
 
 	iobase = it->options[0];
 
@@ -468,10 +469,9 @@ static int unioxx5_attach(struct comedi_device *dev,
 		return -1;
 	}
 
-	if (alloc_subdevices(dev, n_subd) < 0) {
-		printk(KERN_ERR "out of memory\n");
-		return -ENOMEM;
-	}
+	ret = comedi_alloc_subdevices(dev, n_subd);
+	if (ret)
+		return ret;
 
 	/* initializing each of for same subdevices */
 	for (i = 0; i < n_subd; i++, iobase += UNIOXX5_SUBDEV_ODDS) {
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 13d9fd3..864f07a 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -2622,6 +2622,7 @@ static int usbdux_attach_common(struct comedi_device *dev,
 				struct usbduxsub *udev,
 				void *aux_data, int aux_len)
 {
+	int n_subdevices;
 	int ret;
 	struct comedi_subdevice *s = NULL;
 
@@ -2638,17 +2639,14 @@ static int usbdux_attach_common(struct comedi_device *dev,
 	/* set number of subdevices */
 	if (udev->high_speed) {
 		/* with pwm */
-		dev->n_subdevices = 5;
+		n_subdevices = 5;
 	} else {
 		/* without pwm */
-		dev->n_subdevices = 4;
+		n_subdevices = 4;
 	}
 
-	/* allocate space for the subdevices */
-	ret = alloc_subdevices(dev, dev->n_subdevices);
-	if (ret < 0) {
-		dev_err(&udev->interface->dev,
-			"comedi%d: error alloc space for subdev\n", dev->minor);
+	ret = comedi_alloc_subdevices(dev, n_subdevices);
+	if (ret) {
 		up(&udev->sem);
 		return ret;
 	}
diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 7b1d21a..2ee9ecd 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -127,11 +127,6 @@
 #define NUMUSBDUXFAST	16
 
 /*
- * number of subdevices
- */
-#define N_SUBDEVICES	1
-
-/*
  * analogue in subdevice
  */
 #define SUBDEV_AD	0
@@ -1671,14 +1666,8 @@ static int usbduxfast_attach(struct comedi_device *dev,
 
 	dev->board_name = BOARDNAME;
 
-	/* set number of subdevices */
-	dev->n_subdevices = N_SUBDEVICES;
-
-	/* allocate space for the subdevices */
-	ret = alloc_subdevices(dev, N_SUBDEVICES);
-	if (ret < 0) {
-		printk(KERN_ERR "comedi%d: usbduxfast: error alloc space for "
-		       "subdev\n", dev->minor);
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret) {
 		up(&(usbduxfastsub[index].sem));
 		up(&start_stop_sem);
 		return ret;
diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index 441ccef..27e440e 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -2638,6 +2638,7 @@ static void usbduxsigma_disconnect(struct usb_interface *intf)
 static int usbduxsigma_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
 {
+	int n_subdevices;
 	int ret;
 	int index;
 	int i;
@@ -2683,17 +2684,14 @@ static int usbduxsigma_attach(struct comedi_device *dev,
 	/* set number of subdevices */
 	if (udev->high_speed) {
 		/* with pwm */
-		dev->n_subdevices = 4;
+		n_subdevices = 4;
 	} else {
 		/* without pwm */
-		dev->n_subdevices = 3;
+		n_subdevices = 3;
 	}
 
-	/* allocate space for the subdevices */
-	ret = alloc_subdevices(dev, dev->n_subdevices);
-	if (ret < 0) {
-		dev_err(&udev->interface->dev,
-			"comedi%d: no space for subdev\n", dev->minor);
+	ret = comedi_alloc_subdevices(dev, n_subdevices);
+	if (ret) {
 		up(&udev->sem);
 		up(&start_stop_sem);
 		return ret;
diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index baee8d7..69402da 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -1135,6 +1135,7 @@ static int vmk80xx_attach(struct comedi_device *cdev,
 	int n_subd;
 	struct comedi_subdevice *s;
 	int minor;
+	int ret;
 
 	mutex_lock(&glb_mutex);
 
@@ -1159,10 +1160,11 @@ static int vmk80xx_attach(struct comedi_device *cdev,
 	else
 		n_subd = 6;
 
-	if (alloc_subdevices(cdev, n_subd) < 0) {
+	ret = comedi_alloc_subdevices(cdev, n_subd);
+	if (ret) {
 		up(&dev->limit_sem);
 		mutex_unlock(&glb_mutex);
-		return -ENOMEM;
+		return ret;
 	}
 
 	/* Analog input subdevice */
