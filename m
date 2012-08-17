Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625Ab2HQCqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:46:47 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:51525 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab2HQCqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:46:45 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-160.messagelabs.com!1345171604!5981664!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/35] staging: comedi: cb_pcimdas: remove forward declarations
Date: Thu, 16 Aug 2012 19:46:40 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161946.40864.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move a couple of the functions in order to remove the need for
the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c | 240 +++++++++++++---------------
 1 file changed, 112 insertions(+), 128 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 124478d..5a5f102 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -132,15 +132,124 @@ struct cb_pcimdas_private {
 	unsigned int ao_readback[2];
 };
 
+/*
+ * "instructions" read/write data in "one-shot" or "software-triggered"
+ * mode.
+ */
 static int cb_pcimdas_ai_rinsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
+			       struct comedi_insn *insn, unsigned int *data)
+{
+	const struct cb_pcimdas_board *thisboard = comedi_board(dev);
+	struct cb_pcimdas_private *devpriv = dev->private;
+	int n, i;
+	unsigned int d;
+	unsigned int busy;
+	int chan = CR_CHAN(insn->chanspec);
+	unsigned short chanlims;
+	int maxchans;
+
+	/*  only support sw initiated reads from a single channel */
+
+	/* check channel number */
+	if ((inb(devpriv->BADR3 + 2) & 0x20) == 0)	/* differential mode */
+		maxchans = thisboard->ai_diff_chans;
+	else
+		maxchans = thisboard->ai_se_chans;
+
+	if (chan > (maxchans - 1))
+		return -ETIMEDOUT;	/* *** Wrong error code. Fixme. */
+
+	/* configure for sw initiated read */
+	d = inb(devpriv->BADR3 + 5);
+	if ((d & 0x03) > 0) {	/* only reset if needed. */
+		d = d & 0xfd;
+		outb(d, devpriv->BADR3 + 5);
+	}
+	outb(0x01, devpriv->BADR3 + 6);	/* set bursting off, conversions on */
+	outb(0x00, devpriv->BADR3 + 7);	/* set range to 10V. UP/BP is controlled by a switch on the board */
+
+	/*
+	 * write channel limits to multiplexer, set Low (bits 0-3) and
+	 * High (bits 4-7) channels to chan.
+	 */
+	chanlims = chan | (chan << 4);
+	outb(chanlims, devpriv->BADR3 + 0);
+
+	/* convert n samples */
+	for (n = 0; n < insn->n; n++) {
+		/* trigger conversion */
+		outw(0, dev->iobase + 0);
+
+#define TIMEOUT 1000		/* typically takes 5 loops on a lightly loaded Pentium 100MHz, */
+		/* this is likely to be 100 loops on a 2GHz machine, so set 1000 as the limit. */
+
+		/* wait for conversion to end */
+		for (i = 0; i < TIMEOUT; i++) {
+			busy = inb(devpriv->BADR3 + 2) & 0x80;
+			if (!busy)
+				break;
+		}
+		if (i == TIMEOUT) {
+			printk("timeout\n");
+			return -ETIMEDOUT;
+		}
+		/* read data */
+		d = inw(dev->iobase + 0);
+
+		/* mangle the data as necessary */
+		/* d ^= 1<<(thisboard->ai_bits-1); // 16 bit data from ADC, so no mangle needed. */
+
+		data[n] = d;
+	}
+
+	/* return the number of samples read/written */
+	return n;
+}
+
 static int cb_pcimdas_ao_winsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
+			       struct comedi_insn *insn, unsigned int *data)
+{
+	struct cb_pcimdas_private *devpriv = dev->private;
+	int i;
+	int chan = CR_CHAN(insn->chanspec);
+
+	/* Writing a list of values to an AO channel is probably not
+	 * very useful, but that's how the interface is defined. */
+	for (i = 0; i < insn->n; i++) {
+		switch (chan) {
+		case 0:
+			outw(data[i] & 0x0FFF, dev->iobase + DAC0_OFFSET);
+			break;
+		case 1:
+			outw(data[i] & 0x0FFF, dev->iobase + DAC1_OFFSET);
+			break;
+		default:
+			return -1;
+		}
+		devpriv->ao_readback[chan] = data[i];
+	}
+
+	/* return the number of samples read/written */
+	return i;
+}
+
+/* AO subdevices should have a read insn as well as a write insn.
+ * Usually this means copying a value stored in devpriv. */
 static int cb_pcimdas_ao_rinsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
+			       struct comedi_insn *insn, unsigned int *data)
+{
+	struct cb_pcimdas_private *devpriv = dev->private;
+	int i;
+	int chan = CR_CHAN(insn->chanspec);
+
+	for (i = 0; i < insn->n; i++)
+		data[i] = devpriv->ao_readback[chan];
+
+	return i;
+}
 
 static struct pci_dev *cb_pcimdas_find_pci_dev(struct comedi_device *dev,
 					       struct comedi_devconfig *it)
@@ -173,12 +282,6 @@ static struct pci_dev *cb_pcimdas_find_pci_dev(struct comedi_device *dev,
 	return NULL;
 }
 
-/*
- * Attach is called by the Comedi core to configure the driver
- * for a particular board.  If you specified a board_name array
- * in the driver structure, dev->board_ptr contains that
- * address.
- */
 static int cb_pcimdas_attach(struct comedi_device *dev,
 			     struct comedi_devconfig *it)
 {
@@ -282,125 +385,6 @@ static void cb_pcimdas_detach(struct comedi_device *dev)
 	}
 }
 
-/*
- * "instructions" read/write data in "one-shot" or "software-triggered"
- * mode.
- */
-static int cb_pcimdas_ai_rinsn(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data)
-{
-	const struct cb_pcimdas_board *thisboard = comedi_board(dev);
-	struct cb_pcimdas_private *devpriv = dev->private;
-	int n, i;
-	unsigned int d;
-	unsigned int busy;
-	int chan = CR_CHAN(insn->chanspec);
-	unsigned short chanlims;
-	int maxchans;
-
-	/*  only support sw initiated reads from a single channel */
-
-	/* check channel number */
-	if ((inb(devpriv->BADR3 + 2) & 0x20) == 0)	/* differential mode */
-		maxchans = thisboard->ai_diff_chans;
-	else
-		maxchans = thisboard->ai_se_chans;
-
-	if (chan > (maxchans - 1))
-		return -ETIMEDOUT;	/* *** Wrong error code. Fixme. */
-
-	/* configure for sw initiated read */
-	d = inb(devpriv->BADR3 + 5);
-	if ((d & 0x03) > 0) {	/* only reset if needed. */
-		d = d & 0xfd;
-		outb(d, devpriv->BADR3 + 5);
-	}
-	outb(0x01, devpriv->BADR3 + 6);	/* set bursting off, conversions on */
-	outb(0x00, devpriv->BADR3 + 7);	/* set range to 10V. UP/BP is controlled by a switch on the board */
-
-	/*
-	 * write channel limits to multiplexer, set Low (bits 0-3) and
-	 * High (bits 4-7) channels to chan.
-	 */
-	chanlims = chan | (chan << 4);
-	outb(chanlims, devpriv->BADR3 + 0);
-
-	/* convert n samples */
-	for (n = 0; n < insn->n; n++) {
-		/* trigger conversion */
-		outw(0, dev->iobase + 0);
-
-#define TIMEOUT 1000		/* typically takes 5 loops on a lightly loaded Pentium 100MHz, */
-		/* this is likely to be 100 loops on a 2GHz machine, so set 1000 as the limit. */
-
-		/* wait for conversion to end */
-		for (i = 0; i < TIMEOUT; i++) {
-			busy = inb(devpriv->BADR3 + 2) & 0x80;
-			if (!busy)
-				break;
-		}
-		if (i == TIMEOUT) {
-			printk("timeout\n");
-			return -ETIMEDOUT;
-		}
-		/* read data */
-		d = inw(dev->iobase + 0);
-
-		/* mangle the data as necessary */
-		/* d ^= 1<<(thisboard->ai_bits-1); // 16 bit data from ADC, so no mangle needed. */
-
-		data[n] = d;
-	}
-
-	/* return the number of samples read/written */
-	return n;
-}
-
-static int cb_pcimdas_ao_winsn(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data)
-{
-	struct cb_pcimdas_private *devpriv = dev->private;
-	int i;
-	int chan = CR_CHAN(insn->chanspec);
-
-	/* Writing a list of values to an AO channel is probably not
-	 * very useful, but that's how the interface is defined. */
-	for (i = 0; i < insn->n; i++) {
-		switch (chan) {
-		case 0:
-			outw(data[i] & 0x0FFF, dev->iobase + DAC0_OFFSET);
-			break;
-		case 1:
-			outw(data[i] & 0x0FFF, dev->iobase + DAC1_OFFSET);
-			break;
-		default:
-			return -1;
-		}
-		devpriv->ao_readback[chan] = data[i];
-	}
-
-	/* return the number of samples read/written */
-	return i;
-}
-
-/* AO subdevices should have a read insn as well as a write insn.
- * Usually this means copying a value stored in devpriv. */
-static int cb_pcimdas_ao_rinsn(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data)
-{
-	struct cb_pcimdas_private *devpriv = dev->private;
-	int i;
-	int chan = CR_CHAN(insn->chanspec);
-
-	for (i = 0; i < insn->n; i++)
-		data[i] = devpriv->ao_readback[chan];
-
-	return i;
-}
-
 static struct comedi_driver cb_pcimdas_driver = {
 	.driver_name	= "cb_pcimdas",
 	.module		= THIS_MODULE,
-- 
1.7.11

