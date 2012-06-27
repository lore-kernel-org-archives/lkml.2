Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab2F0AvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:51:21 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:5548 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab2F0AvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:51:20 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1340758279!13570944!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/36] staging: comedi: cb_pcidas: remove forward declarations 8
Date: Tue, 26 Jun 2012 17:51:14 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261751.14398.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the trimpot_{7376,8402}_write functions to remove the need
for the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 91 +++++++++++++++---------------
 1 file changed, 44 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 28bcb64..9c7f24a 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -447,9 +447,6 @@ struct cb_pcidas_private {
  */
 #define devpriv ((struct cb_pcidas_private *)dev->private)
 
-static int trimpot_7376_write(struct comedi_device *dev, uint8_t value);
-static int trimpot_8402_write(struct comedi_device *dev, unsigned int channel,
-			      uint8_t value);
 static int nvram_read(struct comedi_device *dev, unsigned int address,
 		      uint8_t *data);
 
@@ -739,6 +736,50 @@ static int dac08_read_insn(struct comedi_device *dev,
 	return 1;
 }
 
+static int trimpot_7376_write(struct comedi_device *dev, uint8_t value)
+{
+	static const int bitstream_length = 7;
+	unsigned int bitstream = value & 0x7f;
+	unsigned int register_bits;
+	static const int ad7376_udelay = 1;
+
+	register_bits = cal_enable_bits(dev) | SELECT_TRIMPOT_BIT;
+	udelay(ad7376_udelay);
+	outw(register_bits, devpriv->control_status + CALIBRATION_REG);
+
+	write_calibration_bitstream(dev, register_bits, bitstream,
+				    bitstream_length);
+
+	udelay(ad7376_udelay);
+	outw(cal_enable_bits(dev), devpriv->control_status + CALIBRATION_REG);
+
+	return 0;
+}
+
+/* For 1602/16 only
+ * ch 0 : adc gain
+ * ch 1 : adc postgain offset */
+static int trimpot_8402_write(struct comedi_device *dev, unsigned int channel,
+			      uint8_t value)
+{
+	static const int bitstream_length = 10;
+	unsigned int bitstream = ((channel & 0x3) << 8) | (value & 0xff);
+	unsigned int register_bits;
+	static const int ad8402_udelay = 1;
+
+	register_bits = cal_enable_bits(dev) | SELECT_TRIMPOT_BIT;
+	udelay(ad8402_udelay);
+	outw(register_bits, devpriv->control_status + CALIBRATION_REG);
+
+	write_calibration_bitstream(dev, register_bits, bitstream,
+				    bitstream_length);
+
+	udelay(ad8402_udelay);
+	outw(cal_enable_bits(dev), devpriv->control_status + CALIBRATION_REG);
+
+	return 0;
+}
+
 static int cb_pcidas_trimpot_write(struct comedi_device *dev,
 				   unsigned int channel, unsigned int value)
 {
@@ -1502,50 +1543,6 @@ static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 	return IRQ_HANDLED;
 }
 
-static int trimpot_7376_write(struct comedi_device *dev, uint8_t value)
-{
-	static const int bitstream_length = 7;
-	unsigned int bitstream = value & 0x7f;
-	unsigned int register_bits;
-	static const int ad7376_udelay = 1;
-
-	register_bits = cal_enable_bits(dev) | SELECT_TRIMPOT_BIT;
-	udelay(ad7376_udelay);
-	outw(register_bits, devpriv->control_status + CALIBRATION_REG);
-
-	write_calibration_bitstream(dev, register_bits, bitstream,
-				    bitstream_length);
-
-	udelay(ad7376_udelay);
-	outw(cal_enable_bits(dev), devpriv->control_status + CALIBRATION_REG);
-
-	return 0;
-}
-
-/* For 1602/16 only
- * ch 0 : adc gain
- * ch 1 : adc postgain offset */
-static int trimpot_8402_write(struct comedi_device *dev, unsigned int channel,
-			      uint8_t value)
-{
-	static const int bitstream_length = 10;
-	unsigned int bitstream = ((channel & 0x3) << 8) | (value & 0xff);
-	unsigned int register_bits;
-	static const int ad8402_udelay = 1;
-
-	register_bits = cal_enable_bits(dev) | SELECT_TRIMPOT_BIT;
-	udelay(ad8402_udelay);
-	outw(register_bits, devpriv->control_status + CALIBRATION_REG);
-
-	write_calibration_bitstream(dev, register_bits, bitstream,
-				    bitstream_length);
-
-	udelay(ad8402_udelay);
-	outw(cal_enable_bits(dev), devpriv->control_status + CALIBRATION_REG);
-
-	return 0;
-}
-
 static int wait_for_nvram_ready(unsigned long s5933_base_addr)
 {
 	static const int timeout = 1000;
-- 
1.7.11

