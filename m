Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab2F0Auo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:50:44 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:33785 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab2F0Aun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:50:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-132.messagelabs.com!1340758242!12303810!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/36] staging: comedi: cb_pcidas: remove forward declarations 7
Date: Tue, 26 Jun 2012 17:50:36 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261750.36944.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the caldac_8800_write function, and it's helper, to remove
the need for the forward declaration.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 98 +++++++++++++++---------------
 1 file changed, 48 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 1e5616e..28bcb64 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -447,8 +447,6 @@ struct cb_pcidas_private {
  */
 #define devpriv ((struct cb_pcidas_private *)dev->private)
 
-static int caldac_8800_write(struct comedi_device *dev, unsigned int address,
-			     uint8_t value);
 static int trimpot_7376_write(struct comedi_device *dev, uint8_t value);
 static int trimpot_8402_write(struct comedi_device *dev, unsigned int channel,
 			      uint8_t value);
@@ -638,6 +636,54 @@ static int eeprom_read_insn(struct comedi_device *dev,
 	return 1;
 }
 
+static void write_calibration_bitstream(struct comedi_device *dev,
+					unsigned int register_bits,
+					unsigned int bitstream,
+					unsigned int bitstream_length)
+{
+	static const int write_delay = 1;
+	unsigned int bit;
+
+	for (bit = 1 << (bitstream_length - 1); bit; bit >>= 1) {
+		if (bitstream & bit)
+			register_bits |= SERIAL_DATA_IN_BIT;
+		else
+			register_bits &= ~SERIAL_DATA_IN_BIT;
+		udelay(write_delay);
+		outw(register_bits, devpriv->control_status + CALIBRATION_REG);
+	}
+}
+
+static int caldac_8800_write(struct comedi_device *dev, unsigned int address,
+			     uint8_t value)
+{
+	static const int num_caldac_channels = 8;
+	static const int bitstream_length = 11;
+	unsigned int bitstream = ((address & 0x7) << 8) | value;
+	static const int caldac_8800_udelay = 1;
+
+	if (address >= num_caldac_channels) {
+		comedi_error(dev, "illegal caldac channel");
+		return -1;
+	}
+
+	if (value == devpriv->caldac_value[address])
+		return 1;
+
+	devpriv->caldac_value[address] = value;
+
+	write_calibration_bitstream(dev, cal_enable_bits(dev), bitstream,
+				    bitstream_length);
+
+	udelay(caldac_8800_udelay);
+	outw(cal_enable_bits(dev) | SELECT_8800_BIT,
+	     devpriv->control_status + CALIBRATION_REG);
+	udelay(caldac_8800_udelay);
+	outw(cal_enable_bits(dev), devpriv->control_status + CALIBRATION_REG);
+
+	return 1;
+}
+
 static int caldac_write_insn(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
 			     struct comedi_insn *insn, unsigned int *data)
@@ -1456,54 +1502,6 @@ static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 	return IRQ_HANDLED;
 }
 
-static void write_calibration_bitstream(struct comedi_device *dev,
-					unsigned int register_bits,
-					unsigned int bitstream,
-					unsigned int bitstream_length)
-{
-	static const int write_delay = 1;
-	unsigned int bit;
-
-	for (bit = 1 << (bitstream_length - 1); bit; bit >>= 1) {
-		if (bitstream & bit)
-			register_bits |= SERIAL_DATA_IN_BIT;
-		else
-			register_bits &= ~SERIAL_DATA_IN_BIT;
-		udelay(write_delay);
-		outw(register_bits, devpriv->control_status + CALIBRATION_REG);
-	}
-}
-
-static int caldac_8800_write(struct comedi_device *dev, unsigned int address,
-			     uint8_t value)
-{
-	static const int num_caldac_channels = 8;
-	static const int bitstream_length = 11;
-	unsigned int bitstream = ((address & 0x7) << 8) | value;
-	static const int caldac_8800_udelay = 1;
-
-	if (address >= num_caldac_channels) {
-		comedi_error(dev, "illegal caldac channel");
-		return -1;
-	}
-
-	if (value == devpriv->caldac_value[address])
-		return 1;
-
-	devpriv->caldac_value[address] = value;
-
-	write_calibration_bitstream(dev, cal_enable_bits(dev), bitstream,
-				    bitstream_length);
-
-	udelay(caldac_8800_udelay);
-	outw(cal_enable_bits(dev) | SELECT_8800_BIT,
-	     devpriv->control_status + CALIBRATION_REG);
-	udelay(caldac_8800_udelay);
-	outw(cal_enable_bits(dev), devpriv->control_status + CALIBRATION_REG);
-
-	return 1;
-}
-
 static int trimpot_7376_write(struct comedi_device *dev, uint8_t value)
 {
 	static const int bitstream_length = 7;
-- 
1.7.11

