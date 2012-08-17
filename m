Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686Ab2HQCyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:54:43 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:28791 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933607Ab2HQCyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:54:40 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-127.messagelabs.com!1345172078!7774065!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 32/35] staging: comedi: cb_pcimdda: cleanup the analog out read/write
Date: Thu, 16 Aug 2012 19:54:32 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161954.33194.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the register map define to work out the i/o address.

Cleanup the comments about the simultaneous transfer mode for
the analog outputs.

Change the return to 'insn->n', the comedi core expects the return
to be the number of data elements used. Technically the 'i' value
is correct but 'insn->n' just makes it clearer.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 63 ++++++++++++-----------------
 1 file changed, 26 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index a5e055f..350c807 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -110,62 +110,51 @@ static int cb_pcimdda_ao_winsn(struct comedi_device *dev,
 			       unsigned int *data)
 {
 	struct cb_pcimdda_private *devpriv = dev->private;
+	unsigned int chan = CR_CHAN(insn->chanspec);
+	unsigned long offset = dev->iobase + PCIMDDA_DA_CHAN(chan);
+	unsigned int val = 0;
 	int i;
-	int chan = CR_CHAN(insn->chanspec);
-	unsigned long offset = dev->iobase + chan * 2;
 
-	/* Writing a list of values to an AO channel is probably not
-	 * very useful, but that's how the interface is defined. */
 	for (i = 0; i < insn->n; i++) {
-		/*  first, load the low byte */
-		outb((char)(data[i] & 0x00ff), offset);
-		/*  next, write the high byte -- only after this is written is
-		   the channel voltage updated in the DAC, unless
-		   we're in simultaneous xfer mode (jumper on card)
-		   then a rinsn is necessary to actually update the DAC --
-		   see cb_pcimdda_ao_rinsn() below... */
-		outb((char)(data[i] >> 8 & 0x00ff), offset + 1);
-
-		/* for testing only.. the actual rinsn SHOULD do an inw!
-		   (see the stuff about simultaneous XFER mode on this board) */
-		devpriv->ao_readback[chan] = data[i];
+		val = data[i];
+
+		/*
+		 * Write the LSB then MSB.
+		 *
+		 * If the simultaneous xfer mode is selected by the
+		 * jumper on the card, a read instruction is needed
+		 * in order to initiate the simultaneous transfer.
+		 * Otherwise, the DAC will be updated when the MSB
+		 * is written.
+		 */
+		outb(val & 0x00ff, offset);
+		outb((val >> 8) & 0x00ff, offset + 1);
 	}
 
-	/* return the number of samples read/written */
-	return i;
-}
+	/* Cache the last value for readback */
+	devpriv->ao_readback[chan] = val;
 
-/* AO subdevices should have a read insn as well as a write insn.
+	return insn->n;
+}
 
-   Usually this means copying a value stored in devpriv->ao_readback.
-   However, since this board has this jumper setting called "Simultaneous
-   Xfer mode" (off by default), we will support it.  Simultaneaous xfer
-   mode is accomplished by loading ALL the values you want for AO in all the
-   channels, then READing off one of the AO registers to initiate the
-   instantaneous simultaneous update of all DAC outputs, which makes
-   all AO channels update simultaneously.  This is useful for some control
-   applications, I would imagine.
-*/
 static int cb_pcimdda_ao_rinsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn,
 			       unsigned int *data)
 {
 	struct cb_pcimdda_private *devpriv = dev->private;
-	int i;
 	int chan = CR_CHAN(insn->chanspec);
+	unsigned long offset = dev->iobase + PCIMDDA_DA_CHAN(chan);
+	int i;
 
 	for (i = 0; i < insn->n; i++) {
-		inw(dev->iobase + chan * 2);
-		/*
-		 * should I set data[i] to the result of the actual read
-		 * on the register or the cached unsigned int in
-		 * devpriv->ao_readback[]?
-		 */
+		/* Initiate the simultaneous transfer */
+		inw(offset);
+
 		data[i] = devpriv->ao_readback[chan];
 	}
 
-	return i;
+	return insn->n;
 }
 
 static struct pci_dev *cb_pcimdda_probe(struct comedi_device *dev,
-- 
1.7.11

