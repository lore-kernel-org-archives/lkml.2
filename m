Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2HRBRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:17:54 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:21087 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab2HRBRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:17:46 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-127.messagelabs.com!1345252662!7865144!20
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/20] staging: comedi: adv_pci1723: fix initial dio subdevice state and io_bits
Date: Fri, 17 Aug 2012 18:17:38 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171817.38918.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initial state and io_bits for the dio subdevice is determined in
the pci1723_attach() but it's being saved in the wrong subdevice. Move
the code so it gets saved correctly.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci1723.c | 29 ++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index a790bb7..68ca075 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -350,6 +350,21 @@ static int pci1723_attach(struct comedi_device *dev,
 		s->insn_write = pci1723_ao_write_winsn;
 		s->insn_read = pci1723_insn_read_ao;
 
+		subdev++;
+	}
+
+	if (this_board->n_diochan) {
+		s = dev->subdevices + subdev;
+		s->type = COMEDI_SUBD_DIO;
+		s->subdev_flags =
+		    SDF_READABLE | SDF_WRITABLE | SDF_GROUND | SDF_COMMON;
+		s->n_chan = this_board->n_diochan;
+		s->maxdata = 1;
+		s->len_chanlist = this_board->n_diochan;
+		s->range_table = &range_digital;
+		s->insn_config = pci1723_dio_insn_config;
+		s->insn_bits = pci1723_dio_insn_bits;
+
 		/* read DIO config */
 		switch (inw(dev->iobase + PCI1723_DIGITAL_IO_PORT_MODE)
 								       & 0x03) {
@@ -372,20 +387,6 @@ static int pci1723_attach(struct comedi_device *dev,
 		subdev++;
 	}
 
-	if (this_board->n_diochan) {
-		s = dev->subdevices + subdev;
-		s->type = COMEDI_SUBD_DIO;
-		s->subdev_flags =
-		    SDF_READABLE | SDF_WRITABLE | SDF_GROUND | SDF_COMMON;
-		s->n_chan = this_board->n_diochan;
-		s->maxdata = 1;
-		s->len_chanlist = this_board->n_diochan;
-		s->range_table = &range_digital;
-		s->insn_config = pci1723_dio_insn_config;
-		s->insn_bits = pci1723_dio_insn_bits;
-		subdev++;
-	}
-
 	devpriv->valid = 1;
 
 	pci1723_reset(dev);
-- 
1.7.11

