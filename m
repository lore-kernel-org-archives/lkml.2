Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab2F0WG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:06:28 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:15467 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab2F0WG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:06:27 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-131.messagelabs.com!1340834775!12736099!5
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/19] staging: comedi: adl_pci6208: cleanup pci6208_ao_winsn()
Date: Wed, 27 Jun 2012 15:06:14 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206271506.14610.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the defines for the register map to make the code a bit
clearer. Shorten or rename some of the local variables for
the same reason.

Only the last value written to the DAC needs to be cached in
the ao_readback variable.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index d15f0cb..7120878 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -82,21 +82,24 @@ static int pci6208_ao_winsn(struct comedi_device *dev,
 			    struct comedi_insn *insn, unsigned int *data)
 {
 	struct pci6208_private *devpriv = dev->private;
-	int i = 0, Data_Read;
-	unsigned short chan = CR_CHAN(insn->chanspec);
+	int chan = CR_CHAN(insn->chanspec);
 	unsigned long invert = 1 << (16 - 1);
-	unsigned long out_value;
+	unsigned long value = 0;
+	unsigned short status;
+	int i;
 
 	for (i = 0; i < insn->n; i++) {
-		out_value = data[i] ^ invert;
+		value = data[i] ^ invert;
+
 		do {
-			Data_Read = (inw(dev->iobase) & 1);
-		} while (Data_Read);
-		outw(out_value, dev->iobase + (0x02 * chan));
-		devpriv->ao_readback[chan] = out_value;
+			status = inw(dev->iobase + PCI6208_AO_STATUS);
+		} while (status & PCI6208_AO_STATUS_DATA_SEND);
+
+		outw(value, dev->iobase + PCI6208_AO_CONTROL(chan));
 	}
+	devpriv->ao_readback[chan] = value;
 
-	return i;
+	return insn->n;
 }
 
 static int pci6208_ao_rinsn(struct comedi_device *dev,
-- 
1.7.11

