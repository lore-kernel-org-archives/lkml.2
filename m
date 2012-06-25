Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab2FYXgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:36:36 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:53239 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab2FYXge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:36:34 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-127.messagelabs.com!1340667384!6809785!3
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/33] staging: comedi: cb_das16_cs: refactor the comedi attach/detach
Date: Mon, 25 Jun 2012 16:36:20 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251636.21284.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the comedi_driver attach/detach functions, as well as the
probe function used during the attach. This removes the need
for all the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 275 ++++++++++++---------------
 1 file changed, 122 insertions(+), 153 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 92c774d..e0821b9 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -106,159 +106,6 @@ static const struct comedi_lrange das16cs_ai_range = { 4, {
 							   }
 };
 
-static irqreturn_t das16cs_interrupt(int irq, void *d);
-static int das16cs_ai_rinsn(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data);
-static int das16cs_ai_cmd(struct comedi_device *dev,
-			  struct comedi_subdevice *s);
-static int das16cs_ai_cmdtest(struct comedi_device *dev,
-			      struct comedi_subdevice *s,
-			      struct comedi_cmd *cmd);
-static int das16cs_ao_winsn(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data);
-static int das16cs_ao_rinsn(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data);
-static int das16cs_dio_insn_bits(struct comedi_device *dev,
-				 struct comedi_subdevice *s,
-				 struct comedi_insn *insn, unsigned int *data);
-static int das16cs_dio_insn_config(struct comedi_device *dev,
-				   struct comedi_subdevice *s,
-				   struct comedi_insn *insn,
-				   unsigned int *data);
-static int das16cs_timer_insn_read(struct comedi_device *dev,
-				   struct comedi_subdevice *s,
-				   struct comedi_insn *insn,
-				   unsigned int *data);
-static int das16cs_timer_insn_config(struct comedi_device *dev,
-				     struct comedi_subdevice *s,
-				     struct comedi_insn *insn,
-				     unsigned int *data);
-
-static const struct das16cs_board *das16cs_probe(struct comedi_device *dev,
-						 struct pcmcia_device *link)
-{
-	int i;
-
-	for (i = 0; i < n_boards; i++) {
-		if (das16cs_boards[i].device_id == link->card_id)
-			return das16cs_boards + i;
-	}
-
-	dev_dbg(dev->class_dev, "unknown board!\n");
-
-	return NULL;
-}
-
-static int das16cs_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it)
-{
-	struct pcmcia_device *link;
-	struct comedi_subdevice *s;
-	int ret;
-	int i;
-
-	dev_dbg(dev->class_dev, "cb_das16_cs: attach\n");
-
-	link = cur_dev;		/* XXX hack */
-	if (!link)
-		return -EIO;
-
-	dev->iobase = link->resource[0]->start;
-	dev_dbg(dev->class_dev, "I/O base=0x%04lx\n", dev->iobase);
-
-	dev_dbg(dev->class_dev, "fingerprint:\n");
-	for (i = 0; i < 48; i += 2)
-		dev_dbg(dev->class_dev, "%04x\n", inw(dev->iobase + i));
-
-
-	ret = request_irq(link->irq, das16cs_interrupt,
-			  IRQF_SHARED, "cb_das16_cs", dev);
-	if (ret < 0)
-		return ret;
-
-	dev->irq = link->irq;
-
-	dev_dbg(dev->class_dev, "irq=%u\n", dev->irq);
-
-	dev->board_ptr = das16cs_probe(dev, link);
-	if (!dev->board_ptr)
-		return -EIO;
-
-	dev->board_name = thisboard->name;
-
-	if (alloc_private(dev, sizeof(struct das16cs_private)) < 0)
-		return -ENOMEM;
-
-	ret = comedi_alloc_subdevices(dev, 4);
-	if (ret)
-		return ret;
-
-	s = dev->subdevices + 0;
-	dev->read_subdev = s;
-	/* analog input subdevice */
-	s->type = COMEDI_SUBD_AI;
-	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_DIFF | SDF_CMD_READ;
-	s->n_chan = 16;
-	s->maxdata = 0xffff;
-	s->range_table = &das16cs_ai_range;
-	s->len_chanlist = 16;
-	s->insn_read = das16cs_ai_rinsn;
-	s->do_cmd = das16cs_ai_cmd;
-	s->do_cmdtest = das16cs_ai_cmdtest;
-
-	s = dev->subdevices + 1;
-	/* analog output subdevice */
-	if (thisboard->n_ao_chans) {
-		s->type = COMEDI_SUBD_AO;
-		s->subdev_flags = SDF_WRITABLE;
-		s->n_chan = thisboard->n_ao_chans;
-		s->maxdata = 0xffff;
-		s->range_table = &range_bipolar10;
-		s->insn_write = &das16cs_ao_winsn;
-		s->insn_read = &das16cs_ao_rinsn;
-	}
-
-	s = dev->subdevices + 2;
-	/* digital i/o subdevice */
-	if (1) {
-		s->type = COMEDI_SUBD_DIO;
-		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-		s->n_chan = 8;
-		s->maxdata = 1;
-		s->range_table = &range_digital;
-		s->insn_bits = das16cs_dio_insn_bits;
-		s->insn_config = das16cs_dio_insn_config;
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
-
-	s = dev->subdevices + 3;
-	/* timer subdevice */
-	if (0) {
-		s->type = COMEDI_SUBD_TIMER;
-		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-		s->n_chan = 1;
-		s->maxdata = 0xff;
-		s->range_table = &range_unknown;
-		s->insn_read = das16cs_timer_insn_read;
-		s->insn_config = das16cs_timer_insn_config;
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
-
-
-	return 1;
-}
-
-static void das16cs_detach(struct comedi_device *dev)
-{
-	if (dev->irq)
-		free_irq(dev->irq, dev);
-}
-
 static irqreturn_t das16cs_interrupt(int irq, void *d)
 {
 	/* struct comedi_device *dev = d; */
@@ -613,6 +460,128 @@ static int das16cs_timer_insn_config(struct comedi_device *dev,
 	return -EINVAL;
 }
 
+static const struct das16cs_board *das16cs_probe(struct comedi_device *dev,
+						 struct pcmcia_device *link)
+{
+	int i;
+
+	for (i = 0; i < n_boards; i++) {
+		if (das16cs_boards[i].device_id == link->card_id)
+			return das16cs_boards + i;
+	}
+
+	dev_dbg(dev->class_dev, "unknown board!\n");
+
+	return NULL;
+}
+
+static int das16cs_attach(struct comedi_device *dev,
+			  struct comedi_devconfig *it)
+{
+	struct pcmcia_device *link;
+	struct comedi_subdevice *s;
+	int ret;
+	int i;
+
+	dev_dbg(dev->class_dev, "cb_das16_cs: attach\n");
+
+	link = cur_dev;		/* XXX hack */
+	if (!link)
+		return -EIO;
+
+	dev->iobase = link->resource[0]->start;
+	dev_dbg(dev->class_dev, "I/O base=0x%04lx\n", dev->iobase);
+
+	dev_dbg(dev->class_dev, "fingerprint:\n");
+	for (i = 0; i < 48; i += 2)
+		dev_dbg(dev->class_dev, "%04x\n", inw(dev->iobase + i));
+
+
+	ret = request_irq(link->irq, das16cs_interrupt,
+			  IRQF_SHARED, "cb_das16_cs", dev);
+	if (ret < 0)
+		return ret;
+
+	dev->irq = link->irq;
+
+	dev_dbg(dev->class_dev, "irq=%u\n", dev->irq);
+
+	dev->board_ptr = das16cs_probe(dev, link);
+	if (!dev->board_ptr)
+		return -EIO;
+
+	dev->board_name = thisboard->name;
+
+	if (alloc_private(dev, sizeof(struct das16cs_private)) < 0)
+		return -ENOMEM;
+
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		return ret;
+
+	s = dev->subdevices + 0;
+	dev->read_subdev = s;
+	/* analog input subdevice */
+	s->type = COMEDI_SUBD_AI;
+	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_DIFF | SDF_CMD_READ;
+	s->n_chan = 16;
+	s->maxdata = 0xffff;
+	s->range_table = &das16cs_ai_range;
+	s->len_chanlist = 16;
+	s->insn_read = das16cs_ai_rinsn;
+	s->do_cmd = das16cs_ai_cmd;
+	s->do_cmdtest = das16cs_ai_cmdtest;
+
+	s = dev->subdevices + 1;
+	/* analog output subdevice */
+	if (thisboard->n_ao_chans) {
+		s->type = COMEDI_SUBD_AO;
+		s->subdev_flags = SDF_WRITABLE;
+		s->n_chan = thisboard->n_ao_chans;
+		s->maxdata = 0xffff;
+		s->range_table = &range_bipolar10;
+		s->insn_write = &das16cs_ao_winsn;
+		s->insn_read = &das16cs_ao_rinsn;
+	}
+
+	s = dev->subdevices + 2;
+	/* digital i/o subdevice */
+	if (1) {
+		s->type = COMEDI_SUBD_DIO;
+		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+		s->n_chan = 8;
+		s->maxdata = 1;
+		s->range_table = &range_digital;
+		s->insn_bits = das16cs_dio_insn_bits;
+		s->insn_config = das16cs_dio_insn_config;
+	} else {
+		s->type = COMEDI_SUBD_UNUSED;
+	}
+
+	s = dev->subdevices + 3;
+	/* timer subdevice */
+	if (0) {
+		s->type = COMEDI_SUBD_TIMER;
+		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+		s->n_chan = 1;
+		s->maxdata = 0xff;
+		s->range_table = &range_unknown;
+		s->insn_read = das16cs_timer_insn_read;
+		s->insn_config = das16cs_timer_insn_config;
+	} else {
+		s->type = COMEDI_SUBD_UNUSED;
+	}
+
+
+	return 1;
+}
+
+static void das16cs_detach(struct comedi_device *dev)
+{
+	if (dev->irq)
+		free_irq(dev->irq, dev);
+}
+
 static struct comedi_driver driver_das16cs = {
 	.driver_name	= "cb_das16_cs",
 	.module		= THIS_MODULE,
-- 
1.7.11

