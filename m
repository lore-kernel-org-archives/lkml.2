Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab2F3AgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 20:36:20 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:43035 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab2F3AgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 20:36:19 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1341016577!21335980!3
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/10] staging: comedi: ni_670x: remove forward declarations
Date: Fri, 29 Jun 2012 17:36:09 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206291736.10041.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the attach and detach functions to remove the need for the
forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_670x.c | 182 ++++++++++++++-----------------
 1 file changed, 83 insertions(+), 99 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index cea43de..e9270af 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -103,105 +103,6 @@ struct ni_670x_private {
 
 static struct comedi_lrange range_0_20mA = { 1, {RANGE_mA(0, 20)} };
 
-static int ni_670x_find_device(struct comedi_device *dev, int bus, int slot);
-
-static int ni_670x_ao_winsn(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data);
-static int ni_670x_ao_rinsn(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data);
-static int ni_670x_dio_insn_bits(struct comedi_device *dev,
-				 struct comedi_subdevice *s,
-				 struct comedi_insn *insn, unsigned int *data);
-static int ni_670x_dio_insn_config(struct comedi_device *dev,
-				   struct comedi_subdevice *s,
-				   struct comedi_insn *insn,
-				   unsigned int *data);
-
-static int ni_670x_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it)
-{
-	struct comedi_subdevice *s;
-	int ret;
-	int i;
-
-	printk(KERN_INFO "comedi%d: ni_670x: ", dev->minor);
-
-	ret = alloc_private(dev, sizeof(struct ni_670x_private));
-	if (ret < 0)
-		return ret;
-
-	ret = ni_670x_find_device(dev, it->options[0], it->options[1]);
-	if (ret < 0)
-		return ret;
-
-	ret = mite_setup(devpriv->mite);
-	if (ret < 0) {
-		printk(KERN_WARNING "error setting up mite\n");
-		return ret;
-	}
-	dev->board_name = thisboard->name;
-	dev->irq = mite_irq(devpriv->mite);
-	printk(KERN_INFO " %s", dev->board_name);
-
-	ret = comedi_alloc_subdevices(dev, 2);
-	if (ret)
-		return ret;
-
-	s = dev->subdevices + 0;
-	/* analog output subdevice */
-	s->type = COMEDI_SUBD_AO;
-	s->subdev_flags = SDF_WRITABLE;
-	s->n_chan = thisboard->ao_chans;
-	s->maxdata = 0xffff;
-	if (s->n_chan == 32) {
-		const struct comedi_lrange **range_table_list;
-
-		range_table_list = kmalloc(sizeof(struct comedi_lrange *) * 32,
-					   GFP_KERNEL);
-		if (!range_table_list)
-			return -ENOMEM;
-		s->range_table_list = range_table_list;
-		for (i = 0; i < 16; i++) {
-			range_table_list[i] = &range_bipolar10;
-			range_table_list[16 + i] = &range_0_20mA;
-		}
-	} else {
-		s->range_table = &range_bipolar10;
-	}
-	s->insn_write = &ni_670x_ao_winsn;
-	s->insn_read = &ni_670x_ao_rinsn;
-
-	s = dev->subdevices + 1;
-	/* digital i/o subdevice */
-	s->type = COMEDI_SUBD_DIO;
-	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-	s->n_chan = 8;
-	s->maxdata = 1;
-	s->range_table = &range_digital;
-	s->insn_bits = ni_670x_dio_insn_bits;
-	s->insn_config = ni_670x_dio_insn_config;
-
-	/* Config of misc registers */
-	writel(0x10, devpriv->mite->daq_io_addr + MISC_CONTROL_OFFSET);
-	/* Config of ao registers */
-	writel(0x00, devpriv->mite->daq_io_addr + AO_CONTROL_OFFSET);
-
-	printk(KERN_INFO "attached\n");
-
-	return 1;
-}
-
-static void ni_670x_detach(struct comedi_device *dev)
-{
-	kfree(dev->subdevices[0].range_table_list);
-	if (dev->private && devpriv->mite)
-		mite_unsetup(devpriv->mite);
-	if (dev->irq)
-		free_irq(dev->irq, dev);
-}
-
 static int ni_670x_ao_winsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
@@ -320,6 +221,89 @@ static int ni_670x_find_device(struct comedi_device *dev, int bus, int slot)
 	return -EIO;
 }
 
+static int ni_670x_attach(struct comedi_device *dev,
+			  struct comedi_devconfig *it)
+{
+	struct comedi_subdevice *s;
+	int ret;
+	int i;
+
+	printk(KERN_INFO "comedi%d: ni_670x: ", dev->minor);
+
+	ret = alloc_private(dev, sizeof(struct ni_670x_private));
+	if (ret < 0)
+		return ret;
+
+	ret = ni_670x_find_device(dev, it->options[0], it->options[1]);
+	if (ret < 0)
+		return ret;
+
+	ret = mite_setup(devpriv->mite);
+	if (ret < 0) {
+		printk(KERN_WARNING "error setting up mite\n");
+		return ret;
+	}
+	dev->board_name = thisboard->name;
+	dev->irq = mite_irq(devpriv->mite);
+	printk(KERN_INFO " %s", dev->board_name);
+
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
+
+	s = dev->subdevices + 0;
+	/* analog output subdevice */
+	s->type = COMEDI_SUBD_AO;
+	s->subdev_flags = SDF_WRITABLE;
+	s->n_chan = thisboard->ao_chans;
+	s->maxdata = 0xffff;
+	if (s->n_chan == 32) {
+		const struct comedi_lrange **range_table_list;
+
+		range_table_list = kmalloc(sizeof(struct comedi_lrange *) * 32,
+					   GFP_KERNEL);
+		if (!range_table_list)
+			return -ENOMEM;
+		s->range_table_list = range_table_list;
+		for (i = 0; i < 16; i++) {
+			range_table_list[i] = &range_bipolar10;
+			range_table_list[16 + i] = &range_0_20mA;
+		}
+	} else {
+		s->range_table = &range_bipolar10;
+	}
+	s->insn_write = &ni_670x_ao_winsn;
+	s->insn_read = &ni_670x_ao_rinsn;
+
+	s = dev->subdevices + 1;
+	/* digital i/o subdevice */
+	s->type = COMEDI_SUBD_DIO;
+	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+	s->n_chan = 8;
+	s->maxdata = 1;
+	s->range_table = &range_digital;
+	s->insn_bits = ni_670x_dio_insn_bits;
+	s->insn_config = ni_670x_dio_insn_config;
+
+	/* Config of misc registers */
+	writel(0x10, devpriv->mite->daq_io_addr + MISC_CONTROL_OFFSET);
+	/* Config of ao registers */
+	writel(0x00, devpriv->mite->daq_io_addr + AO_CONTROL_OFFSET);
+
+	printk(KERN_INFO "attached\n");
+
+	return 1;
+}
+
+static void ni_670x_detach(struct comedi_device *dev)
+{
+	kfree(dev->subdevices[0].range_table_list);
+	if (dev->private && devpriv->mite)
+		mite_unsetup(devpriv->mite);
+	if (dev->irq)
+		free_irq(dev->irq, dev);
+}
+
 static struct comedi_driver ni_670x_driver = {
 	.driver_name	= "ni_670x",
 	.module		= THIS_MODULE,
-- 
1.7.11

