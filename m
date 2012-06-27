Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab2F0Av6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:51:58 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:51393 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab2F0Av5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:51:57 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-209.messagelabs.com!1340758315!7022383!2
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/36] staging: comedi: cb_pcidas: remove forward declarations 9
Date: Tue, 26 Jun 2012 17:51:53 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261751.53541.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the nvram_read function, and its helper, to remove the need
for the last of the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 81 ++++++++++++++----------------
 1 file changed, 39 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 9c7f24a..5c3758c 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -447,9 +447,6 @@ struct cb_pcidas_private {
  */
 #define devpriv ((struct cb_pcidas_private *)dev->private)
 
-static int nvram_read(struct comedi_device *dev, unsigned int address,
-		      uint8_t *data);
-
 static inline unsigned int cal_enable_bits(struct comedi_device *dev)
 {
 	return CAL_EN_BIT | CAL_SRC_BITS(devpriv->calibration_source);
@@ -617,6 +614,45 @@ static int cb_pcidas_ao_readback_insn(struct comedi_device *dev,
 	return 1;
 }
 
+static int wait_for_nvram_ready(unsigned long s5933_base_addr)
+{
+	static const int timeout = 1000;
+	unsigned int i;
+
+	for (i = 0; i < timeout; i++) {
+		if ((inb(s5933_base_addr +
+			 AMCC_OP_REG_MCSR_NVCMD) & MCSR_NV_BUSY)
+		    == 0)
+			return 0;
+		udelay(1);
+	}
+	return -1;
+}
+
+static int nvram_read(struct comedi_device *dev, unsigned int address,
+			uint8_t *data)
+{
+	unsigned long iobase = devpriv->s5933_config;
+
+	if (wait_for_nvram_ready(iobase) < 0)
+		return -ETIMEDOUT;
+
+	outb(MCSR_NV_ENABLE | MCSR_NV_LOAD_LOW_ADDR,
+	     iobase + AMCC_OP_REG_MCSR_NVCMD);
+	outb(address & 0xff, iobase + AMCC_OP_REG_MCSR_NVDATA);
+	outb(MCSR_NV_ENABLE | MCSR_NV_LOAD_HIGH_ADDR,
+	     iobase + AMCC_OP_REG_MCSR_NVCMD);
+	outb((address >> 8) & 0xff, iobase + AMCC_OP_REG_MCSR_NVDATA);
+	outb(MCSR_NV_ENABLE | MCSR_NV_READ, iobase + AMCC_OP_REG_MCSR_NVCMD);
+
+	if (wait_for_nvram_ready(iobase) < 0)
+		return -ETIMEDOUT;
+
+	*data = inb(iobase + AMCC_OP_REG_MCSR_NVDATA);
+
+	return 0;
+}
+
 static int eeprom_read_insn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
@@ -1543,45 +1579,6 @@ static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 	return IRQ_HANDLED;
 }
 
-static int wait_for_nvram_ready(unsigned long s5933_base_addr)
-{
-	static const int timeout = 1000;
-	unsigned int i;
-
-	for (i = 0; i < timeout; i++) {
-		if ((inb(s5933_base_addr +
-			 AMCC_OP_REG_MCSR_NVCMD) & MCSR_NV_BUSY)
-		    == 0)
-			return 0;
-		udelay(1);
-	}
-	return -1;
-}
-
-static int nvram_read(struct comedi_device *dev, unsigned int address,
-			uint8_t *data)
-{
-	unsigned long iobase = devpriv->s5933_config;
-
-	if (wait_for_nvram_ready(iobase) < 0)
-		return -ETIMEDOUT;
-
-	outb(MCSR_NV_ENABLE | MCSR_NV_LOAD_LOW_ADDR,
-	     iobase + AMCC_OP_REG_MCSR_NVCMD);
-	outb(address & 0xff, iobase + AMCC_OP_REG_MCSR_NVDATA);
-	outb(MCSR_NV_ENABLE | MCSR_NV_LOAD_HIGH_ADDR,
-	     iobase + AMCC_OP_REG_MCSR_NVCMD);
-	outb((address >> 8) & 0xff, iobase + AMCC_OP_REG_MCSR_NVDATA);
-	outb(MCSR_NV_ENABLE | MCSR_NV_READ, iobase + AMCC_OP_REG_MCSR_NVCMD);
-
-	if (wait_for_nvram_ready(iobase) < 0)
-		return -ETIMEDOUT;
-
-	*data = inb(iobase + AMCC_OP_REG_MCSR_NVDATA);
-
-	return 0;
-}
-
 static int cb_pcidas_attach(struct comedi_device *dev,
 			    struct comedi_devconfig *it)
 {
-- 
1.7.11

