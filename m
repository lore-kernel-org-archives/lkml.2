Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab2F2R73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 13:59:29 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:47306 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2F2R72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 13:59:28 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1340992758!6736726!19
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] staging: comedi: das_08: unwind the 8254 timer support
Date: Fri, 29 Jun 2012 10:59:21 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206291059.21640.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the 8254 timer support by removing the various functions
that handle the io and consolidating the logic into the initialize,
read, write, and config functions used by the driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das08.c | 76 +++++++---------------------------
 1 file changed, 15 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index 036953e..78c3314 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -433,64 +433,12 @@ das08ao_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	return n;
 }
 
-static unsigned int i8254_read_channel_low(unsigned int base, int chan)
-{
-	return i8254_read(base, 0, chan);
-}
-
-static void i8254_write_channel_low(unsigned int base, int chan,
-				    unsigned int value)
-{
-	i8254_write(base, 0, chan, value);
-}
-
-static unsigned int i8254_read_channel(struct i8254_struct *st, int channel)
-{
-	int chan = st->logic2phys[channel];
-
-	return i8254_read_channel_low(st->iobase, chan);
-}
-
-static void i8254_write_channel(struct i8254_struct *st, int channel,
-				unsigned int value)
-{
-	int chan = st->logic2phys[channel];
-
-	i8254_write_channel_low(st->iobase, chan, value);
-}
-
-static void i8254_set_mode_low(unsigned int base, int channel,
-			       unsigned int mode)
-{
-	i8254_set_mode(base, 0, channel, mode);
-}
-
-static void __i8254_set_mode(struct i8254_struct *st, int channel,
-			   unsigned int mode)
-{
-	int chan = st->logic2phys[channel];
-
-	st->mode[chan] = mode;
-	return i8254_set_mode_low(st->iobase, chan, mode);
-}
-
-static unsigned int i8254_read_status_low(unsigned int base, int channel)
-{
-	return i8254_status(base, 0, channel);
-}
-
-static unsigned int i8254_read_status(struct i8254_struct *st, int channel)
-{
-	int chan = st->logic2phys[channel];
-
-	return i8254_read_status_low(st->iobase, chan);
-}
-
 static void i8254_initialize(struct i8254_struct *st)
 {
 	int i;
+
 	for (i = 0; i < 3; ++i)
-		i8254_set_mode_low(st->iobase, i, st->mode[i]);
+		i8254_set_mode(st->iobase, 0, i, st->mode[i]);
 }
 
 static int das08_counter_read(struct comedi_device *dev,
@@ -498,8 +446,10 @@ static int das08_counter_read(struct comedi_device *dev,
 			      struct comedi_insn *insn, unsigned int *data)
 {
 	struct das08_private_struct *devpriv = dev->private;
-	int chan = insn->chanspec;
-	data[0] = i8254_read_channel(&devpriv->i8254, chan);
+	struct i8254_struct *st = &devpriv->i8254;
+	int chan = st->logic2phys[insn->chanspec];
+
+	data[0] = i8254_read(st->iobase, 0, chan);
 	return 1;
 }
 
@@ -508,8 +458,10 @@ static int das08_counter_write(struct comedi_device *dev,
 			       struct comedi_insn *insn, unsigned int *data)
 {
 	struct das08_private_struct *devpriv = dev->private;
-	int chan = insn->chanspec;
-	i8254_write_channel(&devpriv->i8254, chan, data[0]);
+	struct i8254_struct *st = &devpriv->i8254;
+	int chan = st->logic2phys[insn->chanspec];
+
+	i8254_write(st->iobase, 0, chan, data[0]);
 	return 1;
 }
 
@@ -518,17 +470,19 @@ static int das08_counter_config(struct comedi_device *dev,
 				struct comedi_insn *insn, unsigned int *data)
 {
 	struct das08_private_struct *devpriv = dev->private;
-	int chan = insn->chanspec;
+	struct i8254_struct *st = &devpriv->i8254;
+	int chan = st->logic2phys[insn->chanspec];
 
 	if (insn->n != 2)
 		return -EINVAL;
 
 	switch (data[0]) {
 	case INSN_CONFIG_SET_COUNTER_MODE:
-		__i8254_set_mode(&devpriv->i8254, chan, data[1]);
+		st->mode[chan] = data[1];
+		i8254_set_mode(st->iobase, 0, chan, data[1]);
 		break;
 	case INSN_CONFIG_8254_READ_STATUS:
-		data[1] = i8254_read_status(&devpriv->i8254, chan);
+		data[1] = i8254_status(st->iobase, 0, chan);
 		break;
 	default:
 		return -EINVAL;
-- 
1.7.11

