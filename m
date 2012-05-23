Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab2EWA1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 20:27:17 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:4760 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061Ab2EWA1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 20:27:15 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-127.messagelabs.com!1337732778!6287824!21
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove this_board macro in the pcm3724 driver
Date: Tue, 22 May 2012 17:26:43 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221726.43550.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'this_board' macro depends on having a local variable with
a magic name. The CodingStyle document suggests not doing this
to avoid confusion. Remove the macro and use the comedi_board()
inline helper to get the dev->board_ptr information.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/pcm3724.c b/drivers/staging/comedi/drivers/pcm3724.c
index 7492b8f..9eee708 100644
--- a/drivers/staging/comedi/drivers/pcm3724.c
+++ b/drivers/staging/comedi/drivers/pcm3724.c
@@ -76,10 +76,6 @@ struct priv_pcm3724 {
 	int dio_2;
 };
 
-#define this_board ((const struct pcm3724_board *)dev->board_ptr)
-
-/* (setq c-basic-offset 8) */
-
 static int subdev_8255_cb(int dir, int port, int data, unsigned long arg)
 {
 	unsigned long iobase = arg;
@@ -234,12 +230,13 @@ static int subdev_3724_insn_config(struct comedi_device *dev,
 static int pcm3724_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	const struct pcm3724_board *board = comedi_board(dev);
 	unsigned long iobase;
 	unsigned int iorange;
 	int ret, i, n_subdevices;
 
 	iobase = it->options[0];
-	iorange = this_board->io_range;
+	iorange = board->io_range;
 
 	ret = alloc_private(dev, sizeof(struct priv_pcm3724));
 	if (ret < 0)
@@ -249,17 +246,17 @@ static int pcm3724_attach(struct comedi_device *dev,
 	((struct priv_pcm3724 *)(dev->private))->dio_2 = 0;
 
 	printk(KERN_INFO "comedi%d: pcm3724: board=%s, 0x%03lx ", dev->minor,
-	       this_board->name, iobase);
+	       board->name, iobase);
 	if (!iobase || !request_region(iobase, iorange, "pcm3724")) {
 		printk("I/O port conflict\n");
 		return -EIO;
 	}
 
 	dev->iobase = iobase;
-	dev->board_name = this_board->name;
+	dev->board_name = board->name;
 	printk(KERN_INFO "\n");
 
-	n_subdevices = this_board->numofports;
+	n_subdevices = board->numofports;
 
 	ret = alloc_subdevices(dev, n_subdevices);
 	if (ret < 0)
@@ -275,6 +272,7 @@ static int pcm3724_attach(struct comedi_device *dev,
 
 static void pcm3724_detach(struct comedi_device *dev)
 {
+	const struct pcm3724_board *board = comedi_board(dev);
 	int i;
 
 	if (dev->subdevices) {
@@ -282,7 +280,7 @@ static void pcm3724_detach(struct comedi_device *dev)
 			subdev_8255_cleanup(dev, dev->subdevices + i);
 	}
 	if (dev->iobase)
-		release_region(dev->iobase, this_board->io_range);
+		release_region(dev->iobase, board->io_range);
 }
 
 static const struct pcm3724_board boardtypes[] = {
