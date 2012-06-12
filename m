Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab2FLS6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:58:41 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:35497 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab2FLS6j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:58:39 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-132.messagelabs.com!1339527508!8361020!17
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/8] staging: comedi: only set dev->n_subdevices when kcalloc succeedes
Date: Tue, 12 Jun 2012 11:58:27 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201206121158.27933.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4a741286f60e27ac7dd59eeb36ef49c5937d7fa2 Mon Sep 17 00:00:00 2001
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Date: Tue, 12 Jun 2012 10:07:03 -0700
Subject: [PATCH 4/8] staging: comedi: only set dev->n_subdevices when kcalloc
 succeedes

It's possible for the kcalloc in comedi_alloc_subdevices to fail.
Only set the dev->n_subdevices variable if the allocation is
successful.

Since the core sets dev->n_subdevices, remove all the places in the
drivers where this variable was getting set.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbott@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers.c             |    2 +-
 drivers/staging/comedi/drivers/comedi_test.c |    3 +--
 drivers/staging/comedi/drivers/ni_660x.c     |    4 +---
 drivers/staging/comedi/drivers/s526.c        |    3 +--
 drivers/staging/comedi/drivers/usbdux.c      |    7 ++++---
 drivers/staging/comedi/drivers/usbduxfast.c  |   10 +---------
 drivers/staging/comedi/drivers/usbduxsigma.c |    7 ++++---
 7 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 4d5da37..238c29d 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -62,12 +62,12 @@ int comedi_alloc_subdevices(struct comedi_device *dev, int num_subdevices)
 
 	if (num_subdevices < 1)
 		return -EINVAL;
-	dev->n_subdevices = num_subdevices;
 	dev->subdevices =
 	    kcalloc(num_subdevices, sizeof(struct comedi_subdevice),
 		    GFP_KERNEL);
 	if (!dev->subdevices)
 		return -ENOMEM;
+	dev->n_subdevices = num_subdevices;
 	for (i = 0; i < num_subdevices; ++i) {
 		dev->subdevices[i].device = dev;
 		dev->subdevices[i].async_dma_dir = DMA_NONE;
diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index cd43c0d..004da30 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -447,8 +447,7 @@ static int waveform_attach(struct comedi_device *dev,
 	devpriv->uvolt_amplitude = amplitude;
 	devpriv->usec_period = period;
 
-	dev->n_subdevices = 2;
-	if (comedi_alloc_subdevices(dev, dev->n_subdevices) < 0)
+	if (comedi_alloc_subdevices(dev, 2) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index 5827deb..8c6a6ba 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -1093,9 +1093,7 @@ static int ni_660x_attach(struct comedi_device *dev,
 
 	printk(KERN_INFO " %s ", dev->board_name);
 
-	dev->n_subdevices = 2 + NI_660X_MAX_NUM_COUNTERS;
-
-	if (comedi_alloc_subdevices(dev, dev->n_subdevices) < 0)
+	if (comedi_alloc_subdevices(dev, 2 + NI_660X_MAX_NUM_COUNTERS) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/s526.c b/drivers/staging/comedi/drivers/s526.c
index 17d581b..dbbff70 100644
--- a/drivers/staging/comedi/drivers/s526.c
+++ b/drivers/staging/comedi/drivers/s526.c
@@ -778,8 +778,7 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * Allocate the subdevice structures.  alloc_subdevice() is a
  * convenient macro defined in comedidev.h.
  */
-	dev->n_subdevices = 4;
-	if (comedi_alloc_subdevices(dev, dev->n_subdevices) < 0)
+	if (comedi_alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index ca8b3e1..3819663 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -2624,6 +2624,7 @@ static int usbdux_attach_common(struct comedi_device *dev,
 {
 	int ret;
 	struct comedi_subdevice *s = NULL;
+	int n_subdevs;
 
 	down(&udev->sem);
 	/* pointer back to the corresponding comedi device */
@@ -2638,14 +2639,14 @@ static int usbdux_attach_common(struct comedi_device *dev,
 	/* set number of subdevices */
 	if (udev->high_speed) {
 		/* with pwm */
-		dev->n_subdevices = 5;
+		n_subdevs = 5;
 	} else {
 		/* without pwm */
-		dev->n_subdevices = 4;
+		n_subdevs = 4;
 	}
 
 	/* allocate space for the subdevices */
-	ret = comedi_alloc_subdevices(dev, dev->n_subdevices);
+	ret = comedi_alloc_subdevices(dev, n_subdevs);
 	if (ret < 0) {
 		dev_err(&udev->interface->dev,
 			"comedi%d: error alloc space for subdev\n", dev->minor);
diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index b2f7350..262556e 100644
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
@@ -1671,11 +1666,8 @@ static int usbduxfast_attach(struct comedi_device *dev,
 
 	dev->board_name = BOARDNAME;
 
-	/* set number of subdevices */
-	dev->n_subdevices = N_SUBDEVICES;
-
 	/* allocate space for the subdevices */
-	ret = comedi_alloc_subdevices(dev, N_SUBDEVICES);
+	ret = comedi_alloc_subdevices(dev, 1);
 	if (ret < 0) {
 		printk(KERN_ERR "comedi%d: usbduxfast: error alloc space for "
 		       "subdev\n", dev->minor);
diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index 00faf4a..87c613e 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -2642,6 +2642,7 @@ static int usbduxsigma_attach(struct comedi_device *dev,
 	int index;
 	int i;
 	struct usbduxsub *udev;
+	int n_subdevs;
 
 	int offset;
 
@@ -2683,14 +2684,14 @@ static int usbduxsigma_attach(struct comedi_device *dev,
 	/* set number of subdevices */
 	if (udev->high_speed) {
 		/* with pwm */
-		dev->n_subdevices = 4;
+		n_subdevs = 4;
 	} else {
 		/* without pwm */
-		dev->n_subdevices = 3;
+		n_subdevs = 3;
 	}
 
 	/* allocate space for the subdevices */
-	ret = comedi_alloc_subdevices(dev, dev->n_subdevices);
+	ret = comedi_alloc_subdevices(dev, n_subdevs);
 	if (ret < 0) {
 		dev_err(&udev->interface->dev,
 			"comedi%d: no space for subdev\n", dev->minor);
-- 
1.7.7

