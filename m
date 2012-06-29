Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab2F2SDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:03:13 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:11353 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab2F2SDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:03:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-127.messagelabs.com!1340992948!7235116!37
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] staging: comedi: das_08: absorb i8254_struct into the private data
Date: Fri, 29 Jun 2012 11:02:59 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206291102.59764.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i8254_struct now only contains the iobase address used to
read/write the 8254 timer device. Move that variable into the
das08 private data struct and remove the i8254_struct.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das08.c | 22 ++++++++++------------
 drivers/staging/comedi/drivers/das08.h |  6 +-----
 2 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index 20f79b7..874e02e 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -433,13 +433,14 @@ das08ao_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	return n;
 }
 
-static void i8254_initialize(struct i8254_struct *st)
+static void i8254_initialize(struct comedi_device *dev)
 {
+	struct das08_private_struct *devpriv = dev->private;
 	unsigned int mode = I8254_MODE0 | I8254_BINARY;
 	int i;
 
 	for (i = 0; i < 3; ++i)
-		i8254_set_mode(st->iobase, 0, i, mode);
+		i8254_set_mode(devpriv->i8254_iobase, 0, i, mode);
 }
 
 static int das08_counter_read(struct comedi_device *dev,
@@ -447,10 +448,9 @@ static int das08_counter_read(struct comedi_device *dev,
 			      struct comedi_insn *insn, unsigned int *data)
 {
 	struct das08_private_struct *devpriv = dev->private;
-	struct i8254_struct *st = &devpriv->i8254;
 	int chan = insn->chanspec;
 
-	data[0] = i8254_read(st->iobase, 0, chan);
+	data[0] = i8254_read(devpriv->i8254_iobase, 0, chan);
 	return 1;
 }
 
@@ -459,10 +459,9 @@ static int das08_counter_write(struct comedi_device *dev,
 			       struct comedi_insn *insn, unsigned int *data)
 {
 	struct das08_private_struct *devpriv = dev->private;
-	struct i8254_struct *st = &devpriv->i8254;
 	int chan = insn->chanspec;
 
-	i8254_write(st->iobase, 0, chan, data[0]);
+	i8254_write(devpriv->i8254_iobase, 0, chan, data[0]);
 	return 1;
 }
 
@@ -471,7 +470,6 @@ static int das08_counter_config(struct comedi_device *dev,
 				struct comedi_insn *insn, unsigned int *data)
 {
 	struct das08_private_struct *devpriv = dev->private;
-	struct i8254_struct *st = &devpriv->i8254;
 	int chan = insn->chanspec;
 
 	if (insn->n != 2)
@@ -479,10 +477,10 @@ static int das08_counter_config(struct comedi_device *dev,
 
 	switch (data[0]) {
 	case INSN_CONFIG_SET_COUNTER_MODE:
-		i8254_set_mode(st->iobase, 0, chan, data[1]);
+		i8254_set_mode(devpriv->i8254_iobase, 0, chan, data[1]);
 		break;
 	case INSN_CONFIG_8254_READ_STATUS:
-		data[1] = i8254_status(st->iobase, 0, chan);
+		data[1] = i8254_status(devpriv->i8254_iobase, 0, chan);
 		break;
 	default:
 		return -EINVAL;
@@ -846,9 +844,9 @@ int das08_common_attach(struct comedi_device *dev, unsigned long iobase)
 		s->insn_read = das08_counter_read;
 		s->insn_write = das08_counter_write;
 		s->insn_config = das08_counter_config;
-		/* Set-up the 8254 structure */
-		devpriv->i8254.iobase = iobase + thisboard->i8254_offset;
-		i8254_initialize(&devpriv->i8254);
+
+		devpriv->i8254_iobase = iobase + thisboard->i8254_offset;
+		i8254_initialize(dev);
 	} else {
 		s->type = COMEDI_SUBD_UNUSED;
 	}
diff --git a/drivers/staging/comedi/drivers/das08.h b/drivers/staging/comedi/drivers/das08.h
index ee3cf4b..27b6d4e 100644
--- a/drivers/staging/comedi/drivers/das08.h
+++ b/drivers/staging/comedi/drivers/das08.h
@@ -49,17 +49,13 @@ struct das08_board_struct {
 	unsigned int iosize;	/*  number of ioports used */
 };
 
-struct i8254_struct {
-	unsigned int iobase;
-};
-
 struct das08_private_struct {
 	unsigned int do_mux_bits;	/*  bits for do/mux register on boards without separate do register */
 	unsigned int do_bits;	/*  bits for do register on boards with register dedicated to digital out only */
 	const unsigned int *pg_gainlist;
 	struct pci_dev *pdev;	/*  struct for pci-das08 */
 	unsigned int pci_iobase;	/*  additional base address for pci-das08 */
-	struct i8254_struct i8254;
+	unsigned int i8254_iobase;
 };
 
 #define NUM_DAS08_CS_BOARDS 2
-- 
1.7.11

