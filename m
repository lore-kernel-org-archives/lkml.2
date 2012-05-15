Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966288Ab2EOWbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 18:31:31 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:27657 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966243Ab2EOWbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 18:31:00 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-209.messagelabs.com!1337121047!5726842!20
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor comedi_test driver and use module_comedi_driver
Date: Tue, 15 May 2012 15:30:51 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151530.51970.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_drive to the end of the source. This is more
typical of how other drivers are written and removes the need
for the forward declarations.

Convert the driver to use the module_comedi_driver() macro
which makes the code smaller and a bit simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

 drivers/staging/comedi/drivers/comedi_test.c |  377 ++++++++++++--------------
 1 files changed, 170 insertions(+), 207 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index a804742..6594046 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -67,15 +67,6 @@ struct waveform_board {
 
 #define N_CHANS 8
 
-static const struct waveform_board waveform_boards[] = {
-	{
-	 .name = "comedi_test",
-	 .ai_chans = N_CHANS,
-	 .ai_bits = 16,
-	 .have_dio = 0,
-	 },
-};
-
 #define thisboard ((const struct waveform_board *)dev->board_ptr)
 
 /* Data unique to this driver */
@@ -94,54 +85,6 @@ struct waveform_private {
 };
 #define devpriv ((struct waveform_private *)dev->private)
 
-static int waveform_attach(struct comedi_device *dev,
-			   struct comedi_devconfig *it);
-static int waveform_detach(struct comedi_device *dev);
-static struct comedi_driver driver_waveform = {
-	.driver_name = "comedi_test",
-	.module = THIS_MODULE,
-	.attach = waveform_attach,
-	.detach = waveform_detach,
-	.board_name = &waveform_boards[0].name,
-	.offset = sizeof(struct waveform_board),
-	.num_names = ARRAY_SIZE(waveform_boards),
-};
-
-static int __init driver_waveform_init_module(void)
-{
-	return comedi_driver_register(&driver_waveform);
-}
-
-static void __exit driver_waveform_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_waveform);
-}
-
-module_init(driver_waveform_init_module);
-module_exit(driver_waveform_cleanup_module);
-
-static int waveform_ai_cmdtest(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_cmd *cmd);
-static int waveform_ai_cmd(struct comedi_device *dev,
-			   struct comedi_subdevice *s);
-static int waveform_ai_cancel(struct comedi_device *dev,
-			      struct comedi_subdevice *s);
-static int waveform_ai_insn_read(struct comedi_device *dev,
-				 struct comedi_subdevice *s,
-				 struct comedi_insn *insn, unsigned int *data);
-static int waveform_ao_insn_write(struct comedi_device *dev,
-				  struct comedi_subdevice *s,
-				  struct comedi_insn *insn, unsigned int *data);
-static short fake_sawtooth(struct comedi_device *dev, unsigned int range,
-			   unsigned long current_time);
-static short fake_squarewave(struct comedi_device *dev, unsigned int range,
-			     unsigned long current_time);
-static short fake_flatline(struct comedi_device *dev, unsigned int range,
-			   unsigned long current_time);
-static short fake_waveform(struct comedi_device *dev, unsigned int channel,
-			   unsigned int range, unsigned long current_time);
-
 /* 1000 nanosec in a microsec */
 static const int nano_per_micro = 1000;
 
@@ -154,6 +97,78 @@ static const struct comedi_lrange waveform_ai_ranges = {
 	 }
 };
 
+static short fake_sawtooth(struct comedi_device *dev, unsigned int range_index,
+			   unsigned long current_time)
+{
+	struct comedi_subdevice *s = dev->read_subdev;
+	unsigned int offset = s->maxdata / 2;
+	u64 value;
+	const struct comedi_krange *krange =
+	    &s->range_table->range[range_index];
+	u64 binary_amplitude;
+
+	binary_amplitude = s->maxdata;
+	binary_amplitude *= devpriv->uvolt_amplitude;
+	do_div(binary_amplitude, krange->max - krange->min);
+
+	current_time %= devpriv->usec_period;
+	value = current_time;
+	value *= binary_amplitude * 2;
+	do_div(value, devpriv->usec_period);
+	value -= binary_amplitude;	/* get rid of sawtooth's dc offset */
+
+	return offset + value;
+}
+
+static short fake_squarewave(struct comedi_device *dev,
+			     unsigned int range_index,
+			     unsigned long current_time)
+{
+	struct comedi_subdevice *s = dev->read_subdev;
+	unsigned int offset = s->maxdata / 2;
+	u64 value;
+	const struct comedi_krange *krange =
+	    &s->range_table->range[range_index];
+	current_time %= devpriv->usec_period;
+
+	value = s->maxdata;
+	value *= devpriv->uvolt_amplitude;
+	do_div(value, krange->max - krange->min);
+
+	if (current_time < devpriv->usec_period / 2)
+		value *= -1;
+
+	return offset + value;
+}
+
+static short fake_flatline(struct comedi_device *dev, unsigned int range_index,
+			   unsigned long current_time)
+{
+	return dev->read_subdev->maxdata / 2;
+}
+
+/* generates a different waveform depending on what channel is read */
+static short fake_waveform(struct comedi_device *dev, unsigned int channel,
+			   unsigned int range, unsigned long current_time)
+{
+	enum {
+		SAWTOOTH_CHAN,
+		SQUARE_CHAN,
+	};
+	switch (channel) {
+	case SAWTOOTH_CHAN:
+		return fake_sawtooth(dev, range, current_time);
+		break;
+	case SQUARE_CHAN:
+		return fake_squarewave(dev, range, current_time);
+		break;
+	default:
+		break;
+	}
+
+	return fake_flatline(dev, range, current_time);
+}
+
 /*
    This is the background routine used to generate arbitrary data.
    It should run in the background; therefore it is scheduled by
@@ -217,84 +232,6 @@ static void waveform_ai_interrupt(unsigned long arg)
 	comedi_event(dev, dev->read_subdev);
 }
 
-static int waveform_attach(struct comedi_device *dev,
-			   struct comedi_devconfig *it)
-{
-	struct comedi_subdevice *s;
-	int amplitude = it->options[0];
-	int period = it->options[1];
-	int i;
-
-	dev->board_name = thisboard->name;
-
-	if (alloc_private(dev, sizeof(struct waveform_private)) < 0)
-		return -ENOMEM;
-
-	/* set default amplitude and period */
-	if (amplitude <= 0)
-		amplitude = 1000000;	/* 1 volt */
-	if (period <= 0)
-		period = 100000;	/* 0.1 sec */
-
-	devpriv->uvolt_amplitude = amplitude;
-	devpriv->usec_period = period;
-
-	dev->n_subdevices = 2;
-	if (alloc_subdevices(dev, dev->n_subdevices) < 0)
-		return -ENOMEM;
-
-	s = dev->subdevices + 0;
-	dev->read_subdev = s;
-	/* analog input subdevice */
-	s->type = COMEDI_SUBD_AI;
-	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_CMD_READ;
-	s->n_chan = thisboard->ai_chans;
-	s->maxdata = (1 << thisboard->ai_bits) - 1;
-	s->range_table = &waveform_ai_ranges;
-	s->len_chanlist = s->n_chan * 2;
-	s->insn_read = waveform_ai_insn_read;
-	s->do_cmd = waveform_ai_cmd;
-	s->do_cmdtest = waveform_ai_cmdtest;
-	s->cancel = waveform_ai_cancel;
-
-	s = dev->subdevices + 1;
-	dev->write_subdev = s;
-	/* analog output subdevice (loopback) */
-	s->type = COMEDI_SUBD_AO;
-	s->subdev_flags = SDF_WRITEABLE | SDF_GROUND;
-	s->n_chan = thisboard->ai_chans;
-	s->maxdata = (1 << thisboard->ai_bits) - 1;
-	s->range_table = &waveform_ai_ranges;
-	s->len_chanlist = s->n_chan * 2;
-	s->insn_write = waveform_ao_insn_write;
-	s->do_cmd = NULL;
-	s->do_cmdtest = NULL;
-	s->cancel = NULL;
-
-	/* Our default loopback value is just a 0V flatline */
-	for (i = 0; i < s->n_chan; i++)
-		devpriv->ao_loopbacks[i] = s->maxdata / 2;
-
-	init_timer(&(devpriv->timer));
-	devpriv->timer.function = waveform_ai_interrupt;
-	devpriv->timer.data = (unsigned long)dev;
-
-	printk(KERN_INFO "comedi%d: comedi_test: "
-	       "%i microvolt, %li microsecond waveform attached\n", dev->minor,
-	       devpriv->uvolt_amplitude, devpriv->usec_period);
-	return 1;
-}
-
-static int waveform_detach(struct comedi_device *dev)
-{
-	printk("comedi%d: comedi_test: remove\n", dev->minor);
-
-	if (dev->private)
-		waveform_ai_cancel(dev, dev->read_subdev);
-
-	return 0;
-}
-
 static int waveform_ai_cmdtest(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_cmd *cmd)
@@ -465,78 +402,6 @@ static int waveform_ai_cancel(struct comedi_device *dev,
 	return 0;
 }
 
-static short fake_sawtooth(struct comedi_device *dev, unsigned int range_index,
-			   unsigned long current_time)
-{
-	struct comedi_subdevice *s = dev->read_subdev;
-	unsigned int offset = s->maxdata / 2;
-	u64 value;
-	const struct comedi_krange *krange =
-	    &s->range_table->range[range_index];
-	u64 binary_amplitude;
-
-	binary_amplitude = s->maxdata;
-	binary_amplitude *= devpriv->uvolt_amplitude;
-	do_div(binary_amplitude, krange->max - krange->min);
-
-	current_time %= devpriv->usec_period;
-	value = current_time;
-	value *= binary_amplitude * 2;
-	do_div(value, devpriv->usec_period);
-	value -= binary_amplitude;	/* get rid of sawtooth's dc offset */
-
-	return offset + value;
-}
-
-static short fake_squarewave(struct comedi_device *dev,
-			     unsigned int range_index,
-			     unsigned long current_time)
-{
-	struct comedi_subdevice *s = dev->read_subdev;
-	unsigned int offset = s->maxdata / 2;
-	u64 value;
-	const struct comedi_krange *krange =
-	    &s->range_table->range[range_index];
-	current_time %= devpriv->usec_period;
-
-	value = s->maxdata;
-	value *= devpriv->uvolt_amplitude;
-	do_div(value, krange->max - krange->min);
-
-	if (current_time < devpriv->usec_period / 2)
-		value *= -1;
-
-	return offset + value;
-}
-
-static short fake_flatline(struct comedi_device *dev, unsigned int range_index,
-			   unsigned long current_time)
-{
-	return dev->read_subdev->maxdata / 2;
-}
-
-/* generates a different waveform depending on what channel is read */
-static short fake_waveform(struct comedi_device *dev, unsigned int channel,
-			   unsigned int range, unsigned long current_time)
-{
-	enum {
-		SAWTOOTH_CHAN,
-		SQUARE_CHAN,
-	};
-	switch (channel) {
-	case SAWTOOTH_CHAN:
-		return fake_sawtooth(dev, range, current_time);
-		break;
-	case SQUARE_CHAN:
-		return fake_squarewave(dev, range, current_time);
-		break;
-	default:
-		break;
-	}
-
-	return fake_flatline(dev, range, current_time);
-}
-
 static int waveform_ai_insn_read(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
@@ -561,6 +426,104 @@ static int waveform_ao_insn_write(struct comedi_device *dev,
 	return insn->n;
 }
 
+static int waveform_attach(struct comedi_device *dev,
+			   struct comedi_devconfig *it)
+{
+	struct comedi_subdevice *s;
+	int amplitude = it->options[0];
+	int period = it->options[1];
+	int i;
+
+	dev->board_name = thisboard->name;
+
+	if (alloc_private(dev, sizeof(struct waveform_private)) < 0)
+		return -ENOMEM;
+
+	/* set default amplitude and period */
+	if (amplitude <= 0)
+		amplitude = 1000000;	/* 1 volt */
+	if (period <= 0)
+		period = 100000;	/* 0.1 sec */
+
+	devpriv->uvolt_amplitude = amplitude;
+	devpriv->usec_period = period;
+
+	dev->n_subdevices = 2;
+	if (alloc_subdevices(dev, dev->n_subdevices) < 0)
+		return -ENOMEM;
+
+	s = dev->subdevices + 0;
+	dev->read_subdev = s;
+	/* analog input subdevice */
+	s->type = COMEDI_SUBD_AI;
+	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_CMD_READ;
+	s->n_chan = thisboard->ai_chans;
+	s->maxdata = (1 << thisboard->ai_bits) - 1;
+	s->range_table = &waveform_ai_ranges;
+	s->len_chanlist = s->n_chan * 2;
+	s->insn_read = waveform_ai_insn_read;
+	s->do_cmd = waveform_ai_cmd;
+	s->do_cmdtest = waveform_ai_cmdtest;
+	s->cancel = waveform_ai_cancel;
+
+	s = dev->subdevices + 1;
+	dev->write_subdev = s;
+	/* analog output subdevice (loopback) */
+	s->type = COMEDI_SUBD_AO;
+	s->subdev_flags = SDF_WRITEABLE | SDF_GROUND;
+	s->n_chan = thisboard->ai_chans;
+	s->maxdata = (1 << thisboard->ai_bits) - 1;
+	s->range_table = &waveform_ai_ranges;
+	s->len_chanlist = s->n_chan * 2;
+	s->insn_write = waveform_ao_insn_write;
+	s->do_cmd = NULL;
+	s->do_cmdtest = NULL;
+	s->cancel = NULL;
+
+	/* Our default loopback value is just a 0V flatline */
+	for (i = 0; i < s->n_chan; i++)
+		devpriv->ao_loopbacks[i] = s->maxdata / 2;
+
+	init_timer(&(devpriv->timer));
+	devpriv->timer.function = waveform_ai_interrupt;
+	devpriv->timer.data = (unsigned long)dev;
+
+	printk(KERN_INFO "comedi%d: comedi_test: "
+	       "%i microvolt, %li microsecond waveform attached\n", dev->minor,
+	       devpriv->uvolt_amplitude, devpriv->usec_period);
+	return 1;
+}
+
+static int waveform_detach(struct comedi_device *dev)
+{
+	printk("comedi%d: comedi_test: remove\n", dev->minor);
+
+	if (dev->private)
+		waveform_ai_cancel(dev, dev->read_subdev);
+
+	return 0;
+}
+
+static const struct waveform_board waveform_boards[] = {
+	{
+		.name		= "comedi_test",
+		.ai_chans	= N_CHANS,
+		.ai_bits	= 16,
+		.have_dio	= 0,
+	},
+};
+
+static struct comedi_driver waveform_driver = {
+	.driver_name	= "comedi_test",
+	.module		= THIS_MODULE,
+	.attach		= waveform_attach,
+	.detach		= waveform_detach,
+	.board_name	= &waveform_boards[0].name,
+	.offset		= sizeof(struct waveform_board),
+	.num_names	= ARRAY_SIZE(waveform_boards),
+};
+module_comedi_driver(waveform_driver);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
