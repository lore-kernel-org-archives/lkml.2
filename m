Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966215Ab2EOS26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:28:58 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:55110 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936Ab2EOS24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:28:56 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-209.messagelabs.com!1337106535!5682229!2
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor unioxx5 driver to remove forward declarations
Date: Tue, 15 May 2012 11:28:43 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151128.43479.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor of the unioxx5 comedi driver to remove all the forward
declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

 drivers/staging/comedi/drivers/unioxx5.c |  390 ++++++++++++++----------------
 1 files changed, 181 insertions(+), 209 deletions(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 0eaca68..2d238ae 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -83,26 +83,189 @@ struct unioxx5_subd_priv {
 	unsigned char usp_prev_cn_val[3];	/* previous channel value */
 };
 
-static int unioxx5_subdev_write(struct comedi_device *dev,
-				struct comedi_subdevice *subdev,
-				struct comedi_insn *insn, unsigned int *data);
-static int unioxx5_subdev_read(struct comedi_device *dev,
-			       struct comedi_subdevice *subdev,
-			       struct comedi_insn *insn, unsigned int *data);
-static int unioxx5_insn_config(struct comedi_device *dev,
-			       struct comedi_subdevice *subdev,
-			       struct comedi_insn *insn, unsigned int *data);
-static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
-				   unsigned int *data, int channel, int minor);
+static int __unioxx5_define_chan_offset(int chan_num)
+{
+
+	if (chan_num < 0 || chan_num > 23)
+		return -1;
+
+	return (chan_num >> 3) + 1;
+}
+
+#if 0				/* not used? */
+static void __unioxx5_digital_config(struct unioxx5_subd_priv *usp, int mode)
+{
+	int i, mask;
+
+	mask = (mode == ALL_2_OUTPUT) ? 0xFF : 0x00;
+	printk("COMEDI: mode = %d\n", mask);
+
+	outb(1, usp->usp_iobase + 0);
+
+	for (i = 0; i < 3; i++)
+		outb(mask, usp->usp_iobase + i);
+
+	outb(0, usp->usp_iobase + 0);
+}
+#endif
+
+/* configure channels for analog i/o (even to output, odd to input) */
+static void __unioxx5_analog_config(struct unioxx5_subd_priv *usp, int channel)
+{
+	int chan_a, chan_b, conf, channel_offset;
+
+	channel_offset = __unioxx5_define_chan_offset(channel);
+	conf = usp->usp_prev_cn_val[channel_offset - 1];
+	chan_a = chan_b = 1;
+
+	/* setting channel A and channel B mask */
+	if (channel % 2 == 0) {
+		chan_a <<= channel & 0x07;
+		chan_b <<= (channel + 1) & 0x07;
+	} else {
+		chan_a <<= (channel - 1) & 0x07;
+		chan_b <<= channel & 0x07;
+	}
+
+	conf |= chan_a;		/* even channel ot output */
+	conf &= ~chan_b;	/* odd channel to input */
+
+	outb(1, usp->usp_iobase + 0);
+	outb(conf, usp->usp_iobase + channel_offset);
+	outb(0, usp->usp_iobase + 0);
+
+	usp->usp_prev_cn_val[channel_offset - 1] = conf;
+}
+
 static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
-				  unsigned int *data, int channel, int minor);
-/* static void __unioxx5_digital_config(struct unioxx5_subd_priv* usp, int mode); */
-static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
-				  unsigned int *data, int channel, int minor);
+				  unsigned int *data, int channel, int minor)
+{
+	int channel_offset, mask = 1 << (channel & 0x07);
+
+	channel_offset = __unioxx5_define_chan_offset(channel);
+	if (channel_offset < 0) {
+		printk(KERN_ERR
+		       "comedi%d: undefined channel %d. channel range is 0 .. 23\n",
+		       minor, channel);
+		return 0;
+	}
+
+	*data = inb(usp->usp_iobase + channel_offset);
+	*data &= mask;
+
+	/* correct the read value to 0 or 1 */
+	if (channel_offset > 1)
+		channel -= 2 << channel_offset;
+	*data >>= channel;
+	return 1;
+}
+
 static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
-				 unsigned int *data, int channel, int minor);
-static int __unioxx5_define_chan_offset(int chan_num);
-static void __unioxx5_analog_config(struct unioxx5_subd_priv *usp, int channel);
+				 unsigned int *data, int channel, int minor)
+{
+	int module_no, read_ch;
+	char control;
+
+	module_no = channel / 2;
+	read_ch = channel % 2;	/* depend on type of channel (A or B) */
+
+	/* defining if given module can work on input */
+	if (usp->usp_module_type[module_no] & MODULE_OUTPUT_MASK) {
+		printk(KERN_ERR
+		       "comedi%d: module in position %d with id 0x%02x is for output only",
+		       minor, module_no, usp->usp_module_type[module_no]);
+		return 0;
+	}
+
+	__unioxx5_analog_config(usp, channel);
+	/* sends module number to card(1 .. 12) */
+	outb(module_no + 1, usp->usp_iobase + 5);
+	outb('V', usp->usp_iobase + 6);	/* sends to module (V)erify command */
+	control = inb(usp->usp_iobase);	/* get control register byte */
+
+	/* waits while reading four bytes will be allowed */
+	while (!((control = inb(usp->usp_iobase + 0)) & Rx4CA))
+		;
+
+	/* if four bytes readding error occurs - return 0(false) */
+	if ((control & Rx4CA_ERR_MASK)) {
+		printk("COMEDI: 4 bytes error\n");
+		return 0;
+	}
+
+	if (read_ch)
+		*data = inw(usp->usp_iobase + 6);	/* channel B */
+	else
+		*data = inw(usp->usp_iobase + 4);	/* channel A */
+
+	return 1;
+}
+
+static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
+				   unsigned int *data, int channel, int minor)
+{
+	int channel_offset, val;
+	int mask = 1 << (channel & 0x07);
+
+	channel_offset = __unioxx5_define_chan_offset(channel);
+	if (channel_offset < 0) {
+		printk(KERN_ERR
+		       "comedi%d: undefined channel %d. channel range is 0 .. 23\n",
+		       minor, channel);
+		return 0;
+	}
+
+	/* getting previous written value */
+	val = usp->usp_prev_wr_val[channel_offset - 1];
+
+	if (*data)
+		val |= mask;
+	else
+		val &= ~mask;
+
+	outb(val, usp->usp_iobase + channel_offset);
+	/* saving new written value */
+	usp->usp_prev_wr_val[channel_offset - 1] = val;
+
+	return 1;
+}
+
+static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
+				  unsigned int *data, int channel, int minor)
+{
+	int module, i;
+
+	module = channel / 2;	/* definig module number(0 .. 11) */
+	i = (channel % 2) << 1;	/* depends on type of channel (A or B) */
+
+	/* defining if given module can work on output */
+	if (!(usp->usp_module_type[module] & MODULE_OUTPUT_MASK)) {
+		printk(KERN_ERR
+		       "comedi%d: module in position %d with id 0x%0x is for input only!\n",
+		       minor, module, usp->usp_module_type[module]);
+		return 0;
+	}
+
+	__unioxx5_analog_config(usp, channel);
+	/* saving minor byte */
+	usp->usp_extra_data[module][i++] = (unsigned char)(*data & 0x00FF);
+	/* saving major byte */
+	usp->usp_extra_data[module][i] = (unsigned char)((*data & 0xFF00) >> 8);
+
+	/* while(!((inb(usp->usp_iobase + 0)) & TxBE)); */
+	/* sending module number to card(1 .. 12) */
+	outb(module + 1, usp->usp_iobase + 5);
+	outb('W', usp->usp_iobase + 6);	/* sends (W)rite command to module */
+
+	/* sending for bytes to module(one byte per cycle iteration) */
+	for (i = 0; i < 4; i++) {
+		while (!((inb(usp->usp_iobase + 0)) & TxBE))
+			;	/* waits while writting will be allowed */
+		outb(usp->usp_extra_data[module][i], usp->usp_iobase + 6);
+	}
+
+	return 1;
+}
 
 static int unioxx5_subdev_read(struct comedi_device *dev,
 			       struct comedi_subdevice *subdev,
@@ -275,197 +438,6 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 	return 0;
 }
 
-static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
-				   unsigned int *data, int channel, int minor)
-{
-	int channel_offset, val;
-	int mask = 1 << (channel & 0x07);
-
-	channel_offset = __unioxx5_define_chan_offset(channel);
-	if (channel_offset < 0) {
-		printk(KERN_ERR
-		       "comedi%d: undefined channel %d. channel range is 0 .. 23\n",
-		       minor, channel);
-		return 0;
-	}
-
-	/* getting previous written value */
-	val = usp->usp_prev_wr_val[channel_offset - 1];
-
-	if (*data)
-		val |= mask;
-	else
-		val &= ~mask;
-
-	outb(val, usp->usp_iobase + channel_offset);
-	/* saving new written value */
-	usp->usp_prev_wr_val[channel_offset - 1] = val;
-
-	return 1;
-}
-
-/* function for digital reading */
-static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
-				  unsigned int *data, int channel, int minor)
-{
-	int channel_offset, mask = 1 << (channel & 0x07);
-
-	channel_offset = __unioxx5_define_chan_offset(channel);
-	if (channel_offset < 0) {
-		printk(KERN_ERR
-		       "comedi%d: undefined channel %d. channel range is 0 .. 23\n",
-		       minor, channel);
-		return 0;
-	}
-
-	*data = inb(usp->usp_iobase + channel_offset);
-	*data &= mask;
-
-	if (channel_offset > 1)
-		channel -= 2 << channel_offset;	/* this operation is created for correct readed value to 0 or 1 */
-	*data >>= channel;
-	return 1;
-}
-
-#if 0				/* not used? */
-static void __unioxx5_digital_config(struct unioxx5_subd_priv *usp, int mode)
-{
-	int i, mask;
-
-	mask = (mode == ALL_2_OUTPUT) ? 0xFF : 0x00;
-	printk("COMEDI: mode = %d\n", mask);
-
-	outb(1, usp->usp_iobase + 0);
-
-	for (i = 0; i < 3; i++)
-		outb(mask, usp->usp_iobase + i);
-
-	outb(0, usp->usp_iobase + 0);
-}
-#endif
-
-static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
-				  unsigned int *data, int channel, int minor)
-{
-	int module, i;
-
-	module = channel / 2;	/* definig module number(0 .. 11) */
-	i = (channel % 2) << 1;	/* depends on type of channel (A or B) */
-
-	/* defining if given module can work on output */
-	if (!(usp->usp_module_type[module] & MODULE_OUTPUT_MASK)) {
-		printk(KERN_ERR
-		       "comedi%d: module in position %d with id 0x%0x is for input only!\n",
-		       minor, module, usp->usp_module_type[module]);
-		return 0;
-	}
-
-	__unioxx5_analog_config(usp, channel);
-	/* saving minor byte */
-	usp->usp_extra_data[module][i++] = (unsigned char)(*data & 0x00FF);
-	/* saving major byte */
-	usp->usp_extra_data[module][i] = (unsigned char)((*data & 0xFF00) >> 8);
-
-	/* while(!((inb(usp->usp_iobase + 0)) & TxBE)); */
-	/* sending module number to card(1 .. 12) */
-	outb(module + 1, usp->usp_iobase + 5);
-	outb('W', usp->usp_iobase + 6);	/* sends (W)rite command to module */
-
-	/* sending for bytes to module(one byte per cycle iteration) */
-	for (i = 0; i < 4; i++) {
-		while (!((inb(usp->usp_iobase + 0)) & TxBE))
-			;	/* waits while writting will be allowed */
-		outb(usp->usp_extra_data[module][i], usp->usp_iobase + 6);
-	}
-
-	return 1;
-}
-
-static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
-				 unsigned int *data, int channel, int minor)
-{
-	int module_no, read_ch;
-	char control;
-
-	module_no = channel / 2;
-	read_ch = channel % 2;	/* depend on type of channel (A or B) */
-
-	/* defining if given module can work on input */
-	if (usp->usp_module_type[module_no] & MODULE_OUTPUT_MASK) {
-		printk(KERN_ERR
-		       "comedi%d: module in position %d with id 0x%02x is for output only",
-		       minor, module_no, usp->usp_module_type[module_no]);
-		return 0;
-	}
-
-	__unioxx5_analog_config(usp, channel);
-	/* sends module number to card(1 .. 12) */
-	outb(module_no + 1, usp->usp_iobase + 5);
-	outb('V', usp->usp_iobase + 6);	/* sends to module (V)erify command */
-	control = inb(usp->usp_iobase);	/* get control register byte */
-
-	/* waits while reading four bytes will be allowed */
-	while (!((control = inb(usp->usp_iobase + 0)) & Rx4CA))
-		;
-
-	/* if four bytes readding error occurs - return 0(false) */
-	if ((control & Rx4CA_ERR_MASK)) {
-		printk("COMEDI: 4 bytes error\n");
-		return 0;
-	}
-
-	if (read_ch)
-		*data = inw(usp->usp_iobase + 6);	/* channel B */
-	else
-		*data = inw(usp->usp_iobase + 4);	/* channel A */
-
-	return 1;
-}
-
-/* configure channels for analog i/o (even to output, odd to input) */
-static void __unioxx5_analog_config(struct unioxx5_subd_priv *usp, int channel)
-{
-	int chan_a, chan_b, conf, channel_offset;
-
-	channel_offset = __unioxx5_define_chan_offset(channel);
-	conf = usp->usp_prev_cn_val[channel_offset - 1];
-	chan_a = chan_b = 1;
-
-	/* setting channel A and channel B mask */
-	if (channel % 2 == 0) {
-		chan_a <<= channel & 0x07;
-		chan_b <<= (channel + 1) & 0x07;
-	} else {
-		chan_a <<= (channel - 1) & 0x07;
-		chan_b <<= channel & 0x07;
-	}
-
-	conf |= chan_a;		/* even channel ot output */
-	conf &= ~chan_b;	/* odd channel to input */
-
-	outb(1, usp->usp_iobase + 0);
-	outb(conf, usp->usp_iobase + channel_offset);
-	outb(0, usp->usp_iobase + 0);
-
-	usp->usp_prev_cn_val[channel_offset - 1] = conf;
-}
-
-/*                                                    *\
- * this function defines if the given channel number  *
- * enters in default numeric interspace(from 0 to 23) *
- * and it returns address offset for usage needed     *
- * channel.                                           *
-\*                                                    */
-
-static int __unioxx5_define_chan_offset(int chan_num)
-{
-
-	if (chan_num < 0 || chan_num > 23)
-		return -1;
-
-	return (chan_num >> 3) + 1;
-}
-
 static int unioxx5_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
