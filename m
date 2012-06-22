Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab2FVXMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:12:55 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:50842 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab2FVXMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:12:54 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1340406772!20618276!2
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/31] staging: comedi: ni_daq_700: remove exported symbols
Date: Fri, 22 Jun 2012 16:12:42 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221612.42993.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver exports a number of functions with EXPORT_SYMBOL()
but nothing actually uses them. They also are not declared in
any header for use outside this module.

As stated in the comments, this driver was based on the 8255
driver so these exports are most likely the result of cut-and-
paste from the 8255 driver.

Remove all the EXPORT_SYMBOL() lines. If the exported function
is not used in the driver, remove the entire function as well.
If the function is used, make it static.

Also, make the dio700_cs_driver variable static since it's only
referenced in this file.

This quiets the following sparse warnings:

warning: symbol 'subdev_700_interrupt' was not declared. Should it be static?
warning: symbol 'subdev_700_init' was not declared. Should it be static?
warning: symbol 'subdev_700_init_irq' was not declared. Should it be static?
warning: symbol 'subdev_700_cleanup' was not declared. Should it be static?
warning: symbol 'dio700_cs_driver' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 137 ++--------------------------
 1 file changed, 7 insertions(+), 130 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 4b42809..fd1acf0 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -132,19 +132,6 @@ struct subdev_700_struct {
 
 static void do_config(struct comedi_device *dev, struct comedi_subdevice *s);
 
-void subdev_700_interrupt(struct comedi_device *dev, struct comedi_subdevice *s)
-{
-	short d;
-
-	d = CALLBACK_FUNC(0, _700_DATA, 0, CALLBACK_ARG);
-
-	comedi_buf_put(s->async, d);
-	s->async->events |= COMEDI_CB_EOS;
-
-	comedi_event(dev, s);
-}
-EXPORT_SYMBOL(subdev_700_interrupt);
-
 static int subdev_700_cb(int dir, int port, int data, unsigned long arg)
 {
 	/* port is always A for output and B for input (8255 emu) */
@@ -206,99 +193,10 @@ static void do_config(struct comedi_device *dev, struct comedi_subdevice *s)
 	return;
 }
 
-static int subdev_700_cmdtest(struct comedi_device *dev,
-			      struct comedi_subdevice *s,
-			      struct comedi_cmd *cmd)
-{
-	int err = 0;
-	unsigned int tmp;
-
-	/* step 1 */
-
-	tmp = cmd->start_src;
-	cmd->start_src &= TRIG_NOW;
-	if (!cmd->start_src || tmp != cmd->start_src)
-		err++;
-
-	tmp = cmd->scan_begin_src;
-	cmd->scan_begin_src &= TRIG_EXT;
-	if (!cmd->scan_begin_src || tmp != cmd->scan_begin_src)
-		err++;
-
-	tmp = cmd->convert_src;
-	cmd->convert_src &= TRIG_FOLLOW;
-	if (!cmd->convert_src || tmp != cmd->convert_src)
-		err++;
-
-	tmp = cmd->scan_end_src;
-	cmd->scan_end_src &= TRIG_COUNT;
-	if (!cmd->scan_end_src || tmp != cmd->scan_end_src)
-		err++;
-
-	tmp = cmd->stop_src;
-	cmd->stop_src &= TRIG_NONE;
-	if (!cmd->stop_src || tmp != cmd->stop_src)
-		err++;
-
-	if (err)
-		return 1;
-
-	/* step 2 */
-
-	if (err)
-		return 2;
-
-	/* step 3 */
-
-	if (cmd->start_arg != 0) {
-		cmd->start_arg = 0;
-		err++;
-	}
-	if (cmd->scan_begin_arg != 0) {
-		cmd->scan_begin_arg = 0;
-		err++;
-	}
-	if (cmd->convert_arg != 0) {
-		cmd->convert_arg = 0;
-		err++;
-	}
-	if (cmd->scan_end_arg != 1) {
-		cmd->scan_end_arg = 1;
-		err++;
-	}
-	if (cmd->stop_arg != 0) {
-		cmd->stop_arg = 0;
-		err++;
-	}
-
-	if (err)
-		return 3;
-
-	/* step 4 */
-
-	if (err)
-		return 4;
-
-	return 0;
-}
-
-static int subdev_700_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
-{
-	/* FIXME */
-
-	return 0;
-}
-
-static int subdev_700_cancel(struct comedi_device *dev,
-			     struct comedi_subdevice *s)
-{
-	/* FIXME */
-
-	return 0;
-}
-
-int subdev_700_init(struct comedi_device *dev, struct comedi_subdevice *s,
-		    int (*cb) (int, int, int, unsigned long), unsigned long arg)
+static int subdev_700_init(struct comedi_device *dev,
+			   struct comedi_subdevice *s,
+			   int (*cb) (int, int, int, unsigned long),
+			   unsigned long arg)
 {
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
@@ -325,36 +223,15 @@ int subdev_700_init(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	return 0;
 }
-EXPORT_SYMBOL(subdev_700_init);
-
-int subdev_700_init_irq(struct comedi_device *dev, struct comedi_subdevice *s,
-			int (*cb) (int, int, int, unsigned long),
-			unsigned long arg)
-{
-	int ret;
-
-	ret = subdev_700_init(dev, s, cb, arg);
-	if (ret < 0)
-		return ret;
-
-	s->do_cmdtest = subdev_700_cmdtest;
-	s->do_cmd = subdev_700_cmd;
-	s->cancel = subdev_700_cancel;
-
-	subdevpriv->have_irq = 1;
-
-	return 0;
-}
-EXPORT_SYMBOL(subdev_700_init_irq);
 
-void subdev_700_cleanup(struct comedi_device *dev, struct comedi_subdevice *s)
+static void subdev_700_cleanup(struct comedi_device *dev,
+			       struct comedi_subdevice *s)
 {
 	if (s->private)
 		if (subdevpriv->have_irq)
 
 			kfree(s->private);
 }
-EXPORT_SYMBOL(subdev_700_cleanup);
 
 static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
@@ -556,7 +433,7 @@ MODULE_DESCRIPTION("Comedi driver for National Instruments "
 		   "PCMCIA DAQCard-700 DIO");
 MODULE_LICENSE("GPL");
 
-struct pcmcia_driver dio700_cs_driver = {
+static struct pcmcia_driver dio700_cs_driver = {
 	.probe = dio700_cs_attach,
 	.remove = dio700_cs_detach,
 	.suspend = dio700_cs_suspend,
-- 
1.7.11

