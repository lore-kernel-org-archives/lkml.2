Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316Ab2EWAvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 20:51:47 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:24973 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab2EWAvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 20:51:46 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1337734304!13413161!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove this_board macro in the pcmuio driver
Date: Tue, 22 May 2012 17:51:35 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221751.36177.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'thisboard' macro depends on having a local variable with
a magic name. The CodingStyle document suggests not doing this
to avoid confusion. Remove the macro and use the comedi_board()
inline helper to get the dev->board_ptr information.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index 623381d..b1a9bed 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -155,11 +155,6 @@ struct pcmuio_board {
 	const int num_ports;
 };
 
-/*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct pcmuio_board *)dev->board_ptr)
-
 /* this structure is for data unique to this subdevice.  */
 struct pcmuio_subdev_private {
 	/* mapping of halfwords (bytes) in port/chanarray to iobase */
@@ -354,7 +349,9 @@ static int pcmuio_dio_insn_config(struct comedi_device *dev,
 
 static void switch_page(struct comedi_device *dev, int asic, int page)
 {
-	if (asic < 0 || asic >= thisboard->num_asics)
+	const struct pcmuio_board *board = comedi_board(dev);
+
+	if (asic < 0 || asic >= board->num_asics)
 		return;		/* paranoia */
 	if (page < 0 || page >= NUM_PAGES)
 		return;		/* more paranoia */
@@ -370,9 +367,10 @@ static void switch_page(struct comedi_device *dev, int asic, int page)
 static void init_asics(struct comedi_device *dev)
 {				/* sets up an
 				   ASIC chip to defaults */
+	const struct pcmuio_board *board = comedi_board(dev);
 	int asic;
 
-	for (asic = 0; asic < thisboard->num_asics; ++asic) {
+	for (asic = 0; asic < board->num_asics; ++asic) {
 		int port, page;
 		unsigned long baseaddr = dev->iobase + asic * ASIC_IOSIZE;
 
@@ -407,7 +405,9 @@ static void init_asics(struct comedi_device *dev)
 #ifdef notused
 static void lock_port(struct comedi_device *dev, int asic, int port)
 {
-	if (asic < 0 || asic >= thisboard->num_asics)
+	const struct pcmuio_board *board = comedi_board(dev);
+
+	if (asic < 0 || asic >= board->num_asics)
 		return;		/* paranoia */
 	if (port < 0 || port >= PORTS_PER_ASIC)
 		return;		/* more paranoia */
@@ -420,7 +420,9 @@ static void lock_port(struct comedi_device *dev, int asic, int port)
 
 static void unlock_port(struct comedi_device *dev, int asic, int port)
 {
-	if (asic < 0 || asic >= thisboard->num_asics)
+	const struct pcmuio_board *board = comedi_board(dev);
+
+	if (asic < 0 || asic >= board->num_asics)
 		return;		/* paranoia */
 	if (port < 0 || port >= PORTS_PER_ASIC)
 		return;		/* more paranoia */
@@ -747,6 +749,7 @@ pcmuio_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 
 static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct pcmuio_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 	int sdev_no, chans_left, n_subdevs, port, asic, thisasic_chanct = 0;
 	unsigned long iobase;
@@ -762,17 +765,13 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->iobase = iobase;
 
 	if (!iobase || !request_region(iobase,
-				       thisboard->num_asics * ASIC_IOSIZE,
+				       board->num_asics * ASIC_IOSIZE,
 				       dev->driver->driver_name)) {
 		dev_err(dev->hw_dev, "I/O port conflict\n");
 		return -EIO;
 	}
 
-/*
- * Initialize dev->board_name.  Note that we can use the "thisboard"
- * macro now, since we just initialized it in the last line.
- */
-	dev->board_name = thisboard->name;
+	dev->board_name = board->name;
 
 /*
  * Allocate the private structure area.  alloc_private() is a
@@ -792,7 +791,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		spin_lock_init(&devpriv->asics[asic].spinlock);
 	}
 
-	chans_left = CHANS_PER_ASIC * thisboard->num_asics;
+	chans_left = CHANS_PER_ASIC * board->num_asics;
 	n_subdevs = CALC_N_SUBDEVS(chans_left);
 	devpriv->sprivs =
 	    kcalloc(n_subdevs, sizeof(struct pcmuio_subdev_private),
@@ -881,7 +880,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	for (asic = 0; irq[0] && asic < MAX_ASICS; ++asic) {
 		if (irq[asic]
 		    && request_irq(irq[asic], interrupt_pcmuio,
-				   IRQF_SHARED, thisboard->name, dev)) {
+				   IRQF_SHARED, board->name, dev)) {
 			int i;
 			/* unroll the allocated irqs.. */
 			for (i = asic - 1; i >= 0; --i) {
@@ -898,7 +897,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	if (irq[0]) {
 		dev_dbg(dev->hw_dev, "irq: %u\n", irq[0]);
-		if (irq[1] && thisboard->num_asics == 2)
+		if (irq[1] && board->num_asics == 2)
 			dev_dbg(dev->hw_dev, "second ASIC irq: %u\n", irq[1]);
 	} else {
 		dev_dbg(dev->hw_dev, "(IRQ mode disabled)\n");
@@ -910,10 +909,11 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void pcmuio_detach(struct comedi_device *dev)
 {
+	const struct pcmuio_board *board = comedi_board(dev);
 	int i;
 
 	if (dev->iobase)
-		release_region(dev->iobase, ASIC_IOSIZE * thisboard->num_asics);
+		release_region(dev->iobase, ASIC_IOSIZE * board->num_asics);
 	for (i = 0; i < MAX_ASICS; ++i) {
 		if (devpriv->asics[i].irq)
 			free_irq(devpriv->asics[i].irq, dev);
