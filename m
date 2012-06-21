Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab2FUCZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:25:40 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:10045 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab2FUCZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:25:37 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-160.messagelabs.com!1340245536!7341588!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/12] staging: comedi: s626: remove forward declarations 3
Date: Wed, 20 Jun 2012 19:25:32 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201925.32618.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the I2C functions up to remove the need for the forward
declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/s626.c | 124 +++++++++++++++++-----------------
 1 file changed, 61 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 1efa2f0..5fcb43a 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -216,8 +216,6 @@ static int s626_ns_to_timer(int *nanosec, int round_mode);
 /* internal routines */
 static void WriteTrimDAC(struct comedi_device *dev, uint8_t LogicalChan,
 			 uint8_t DacData);
-static uint8_t I2Cread(struct comedi_device *dev, uint8_t addr);
-static uint32_t I2Chandshake(struct comedi_device *dev, uint32_t val);
 static void SetDAC(struct comedi_device *dev, uint16_t chan, short dacdata);
 static void SendDAC(struct comedi_device *dev, uint32_t val);
 
@@ -493,6 +491,67 @@ static void DEBIreplace(struct comedi_device *dev, uint16_t addr, uint16_t mask,
 	DEBItransfer(dev);	/*  Execute the DEBI Write transfer. */
 }
 
+/* **************  EEPROM ACCESS FUNCTIONS  ************** */
+
+static uint32_t I2Chandshake(struct comedi_device *dev, uint32_t val)
+{
+	/*  Write I2C command to I2C Transfer Control shadow register. */
+	WR7146(P_I2CCTRL, val);
+
+	/*  Upload I2C shadow registers into working registers and wait for */
+	/*  upload confirmation. */
+
+	MC_ENABLE(P_MC2, MC2_UPLD_IIC);
+	while (!MC_TEST(P_MC2, MC2_UPLD_IIC))
+		;
+
+	/*  Wait until I2C bus transfer is finished or an error occurs. */
+	while ((RR7146(P_I2CCTRL) & (I2C_BUSY | I2C_ERR)) == I2C_BUSY)
+		;
+
+	/*  Return non-zero if I2C error occurred. */
+	return RR7146(P_I2CCTRL) & I2C_ERR;
+
+}
+
+/*  Read uint8_t from EEPROM. */
+static uint8_t I2Cread(struct comedi_device *dev, uint8_t addr)
+{
+	uint8_t rtnval;
+
+	/*  Send EEPROM target address. */
+	if (I2Chandshake(dev, I2C_B2(I2C_ATTRSTART, I2CW)
+			 /* Byte2 = I2C command: write to I2C EEPROM  device. */
+			 | I2C_B1(I2C_ATTRSTOP, addr)
+			 /* Byte1 = EEPROM internal target address. */
+			 | I2C_B0(I2C_ATTRNOP, 0))) {	/*  Byte0 = Not sent. */
+		/*  Abort function and declare error if handshake failed. */
+		DEBUG("I2Cread: error handshake I2Cread  a\n");
+		return 0;
+	}
+	/*  Execute EEPROM read. */
+	if (I2Chandshake(dev, I2C_B2(I2C_ATTRSTART, I2CR)
+
+			 /*  Byte2 = I2C */
+			 /*  command: read */
+			 /*  from I2C EEPROM */
+			 /*  device. */
+			 |I2C_B1(I2C_ATTRSTOP, 0)
+
+			 /*  Byte1 receives */
+			 /*  uint8_t from */
+			 /*  EEPROM. */
+			 |I2C_B0(I2C_ATTRNOP, 0))) {	/*  Byte0 = Not  sent. */
+
+		/*  Abort function and declare error if handshake failed. */
+		DEBUG("I2Cread: error handshake I2Cread b\n");
+		return 0;
+	}
+	/*  Return copy of EEPROM value. */
+	rtnval = (uint8_t) (RR7146(P_I2CCTRL) >> 16);
+	return rtnval;
+}
+
 static unsigned int s626_ai_reg_to_uint(int data)
 {
 	unsigned int tempdata;
@@ -1938,67 +1997,6 @@ static void WriteTrimDAC(struct comedi_device *dev, uint8_t LogicalChan,
 		| (uint32_t) DacData);	/*  Include DAC setpoint data. */
 }
 
-/* **************  EEPROM ACCESS FUNCTIONS  ************** */
-/*  Read uint8_t from EEPROM. */
-
-static uint8_t I2Cread(struct comedi_device *dev, uint8_t addr)
-{
-	uint8_t rtnval;
-
-	/*  Send EEPROM target address. */
-	if (I2Chandshake(dev, I2C_B2(I2C_ATTRSTART, I2CW)
-			 /* Byte2 = I2C command: write to I2C EEPROM  device. */
-			 | I2C_B1(I2C_ATTRSTOP, addr)
-			 /* Byte1 = EEPROM internal target address. */
-			 | I2C_B0(I2C_ATTRNOP, 0))) {	/*  Byte0 = Not sent. */
-		/*  Abort function and declare error if handshake failed. */
-		DEBUG("I2Cread: error handshake I2Cread  a\n");
-		return 0;
-	}
-	/*  Execute EEPROM read. */
-	if (I2Chandshake(dev, I2C_B2(I2C_ATTRSTART, I2CR)
-
-			 /*  Byte2 = I2C */
-			 /*  command: read */
-			 /*  from I2C EEPROM */
-			 /*  device. */
-			 |I2C_B1(I2C_ATTRSTOP, 0)
-
-			 /*  Byte1 receives */
-			 /*  uint8_t from */
-			 /*  EEPROM. */
-			 |I2C_B0(I2C_ATTRNOP, 0))) {	/*  Byte0 = Not  sent. */
-
-		/*  Abort function and declare error if handshake failed. */
-		DEBUG("I2Cread: error handshake I2Cread b\n");
-		return 0;
-	}
-	/*  Return copy of EEPROM value. */
-	rtnval = (uint8_t) (RR7146(P_I2CCTRL) >> 16);
-	return rtnval;
-}
-
-static uint32_t I2Chandshake(struct comedi_device *dev, uint32_t val)
-{
-	/*  Write I2C command to I2C Transfer Control shadow register. */
-	WR7146(P_I2CCTRL, val);
-
-	/*  Upload I2C shadow registers into working registers and wait for */
-	/*  upload confirmation. */
-
-	MC_ENABLE(P_MC2, MC2_UPLD_IIC);
-	while (!MC_TEST(P_MC2, MC2_UPLD_IIC))
-		;
-
-	/*  Wait until I2C bus transfer is finished or an error occurs. */
-	while ((RR7146(P_I2CCTRL) & (I2C_BUSY | I2C_ERR)) == I2C_BUSY)
-		;
-
-	/*  Return non-zero if I2C error occurred. */
-	return RR7146(P_I2CCTRL) & I2C_ERR;
-
-}
-
 /*  Private helper function: Write setpoint to an application DAC channel. */
 
 static void SetDAC(struct comedi_device *dev, uint16_t chan, short dacdata)
-- 
1.7.11

