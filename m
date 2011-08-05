Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab1HEVcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:32:18 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51049 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070Ab1HEVcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:32:17 -0400
MIME-Version: 1.0
Date: Fri, 5 Aug 2011 23:25:12 +0200
Message-ID: <CAN=yz1i6KN=J=N0Gd-NDhKNAWs6ut5dLuWbXRLFQ54VBNFtRpQ@mail.gmail.com>
Subject: [PATCH 2.6.38 1/1] scx200_acb.c: Add plain i2c (master_xfer / I2C_FUNC_I2C)
From: Tomas <tomasamot@googlemail.com>
To: jim.cromie@gmail.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomas Menzl <tomasamot@gmail.com>

Add master_xfer / I2C_FUNC_I2C by simply reusing existing FSM
scx200_acb_machine.
This adds possibility to do direct read/write on an i2c device or use
I2C_RDWR ioctl
in addition to existing SM Bus API.
Signed-off-by: Tomas Menzl <tomasamot@gmail.com>
----
Added plain I2C interface so that one can use plain read/write (among
others). Needed plain I2C multibyte read which is not possible with SM
bus.
Tested on Voyage Linux 0.75 (http://linux.voyage.hk/, based on Debian
Squeeze, 2.6.38, this module is original/vanilla - i.e. patch
applicable to any current version) on PC Engine WRAP 2C with Microchip
ADC MCP3421.
SM BUS interface intact, read/write worked for me (only tested single
message transactions, do not have HW to test combined transaction but
they are there...).

--- linux-source-2.6.38-voyage/drivers/i2c/busses/scx200_acb.c	2011-08-05
19:44:11.000000000 +0200
+++ linux-source-2.6.38-voyage.new/drivers/i2c/busses/scx200_acb.c	2011-08-05
22:06:18.000000000 +0200
@@ -86,6 +86,7 @@ struct scx200_acb_iface {
 	u8 *ptr;
 	char needs_reset;
 	unsigned len;
+	char skip_stop;
 };

 /* Register Definitions */
@@ -130,6 +131,7 @@ static void scx200_acb_machine(struct sc
 			scx200_acb_state_name[iface->state]);

 		iface->state = state_idle;
+		iface->skip_stop = 0;
 		iface->result = -ENXIO;

 		outb(inb(ACBCTL1) | ACBCTL1_STOP, ACBCTL1);
@@ -191,7 +193,8 @@ static void scx200_acb_machine(struct sc
 		if (iface->len == 1) {
 			iface->result = 0;
 			iface->state = state_idle;
-			outb(inb(ACBCTL1) | ACBCTL1_STOP, ACBCTL1);
+			if (!iface->skip_stop)
+				outb(inb(ACBCTL1) | ACBCTL1_STOP, ACBCTL1);
 		}

 		*iface->ptr++ = inb(ACBSDA);
@@ -203,7 +206,8 @@ static void scx200_acb_machine(struct sc
 		if (iface->len == 0) {
 			iface->result = 0;
 			iface->state = state_idle;
-			outb(inb(ACBCTL1) | ACBCTL1_STOP, ACBCTL1);
+			if (!iface->skip_stop)
+				outb(inb(ACBCTL1) | ACBCTL1_STOP, ACBCTL1);
 			break;
 		}

@@ -222,6 +226,7 @@ static void scx200_acb_machine(struct sc
 		iface->len, status);

 	iface->state = state_idle;
+	iface->skip_stop = 0;
 	iface->result = -EIO;
 	iface->needs_reset = 1;
 }
@@ -277,6 +282,104 @@ static void scx200_acb_reset(struct scx2
 	outb(inb(ACBCST) | ACBCST_BB, ACBCST);
 }

+/*
+ * Generic i2c master transfer entrypoint.
+ *
+ * Basically copy of part of scx200_acb_smbus_xfer where we use existing
+ * scx200_acb_machine which already supports simple i2c with any data length
+ * (not only 0 and 1 as used by smbus) by using:
+ *
+ *         state_quick -> ( state_read | state_write )+ -> state_idle
+ *
+ * Added flag skip_stop to support multimessage ops in scx200_acb_machine
+ * to be able skip stop bit between messages in state_read/state_write:
+ *
+ *       S Addr Rd [A] [Data] NA S Addr Wr [A] Data [A] P
+ *                              ^--- no stop bit!       ^--- stop bit
+ *
+ * Still missing 10b address, pec, etc...
+ */
+static int scx200_acb_i2c_master_xfer(struct i2c_adapter *adapter,
+				       struct i2c_msg *msgs,
+				       int num)
+{
+	struct scx200_acb_iface *iface = i2c_get_adapdata(adapter);
+	int   rc = 0;
+	char  rw;
+	int   len;
+	u8   *buffer;
+	u16   address;
+
+	mutex_lock(&iface->mutex);
+	while (num > 0) {
+		if (msgs->flags & I2C_M_TEN) {
+			dev_err(&adapter->dev,
+			"10b i2c address supported\n");
+			rc = -EINVAL;
+			break;
+		}
+
+		rw = (msgs->flags & I2C_M_RD) != 0;
+		address = (msgs->addr << 1) | rw;
+		len = msgs->len;
+		buffer = msgs->buf;
+
+		dev_dbg(&adapter->dev,
+			"address=0x%x, len=%d, read=%d\n", msgs->addr, len, rw);
+
+		if (!len && rw == I2C_SMBUS_READ) {
+			dev_dbg(&adapter->dev, "zero length read\n");
+			rc = -EINVAL;
+			break;
+		}
+
+		iface->address_byte = address;
+		iface->command = 0;
+		iface->ptr = buffer;
+		iface->len = len;
+		iface->result = -EINVAL;
+		iface->needs_reset = 0;
+		if (num > 1)
+			iface->skip_stop = 1;
+		else
+			iface->skip_stop = 0;
+
+		/* send start */
+		outb(inb(ACBCTL1) | ACBCTL1_START, ACBCTL1);
+
+		/* no command */
+		iface->state = state_quick;
+
+		while (iface->state != state_idle)
+			scx200_acb_poll(iface);
+
+		if (iface->needs_reset)
+			scx200_acb_reset(iface);
+
+		if (iface->result)
+			break;
+
+#ifdef DEBUG
+		dev_dbg(&adapter->dev, "transfer done, result: %d", rc);
+		if (buffer) {
+			int i;
+			printk(KERN_DEBUG " data:");
+			for (i = 0; i < len; ++i)
+				printk(KERN_DEBUG " %02x", buffer[i]);
+		}
+		printk(KERN_DEBUG "\n");
+#endif
+		++rc;
+		--num;
+		++msgs;
+	}
+	mutex_unlock(&iface->mutex);
+
+	iface->skip_stop = 0;
+	return rc;
+}
+
+
 static s32 scx200_acb_smbus_xfer(struct i2c_adapter *adapter,
 				 u16 address, unsigned short flags,
 				 char rw, u8 command, int size,
@@ -338,6 +441,7 @@ static s32 scx200_acb_smbus_xfer(struct
 	iface->len = len;
 	iface->result = -EINVAL;
 	iface->needs_reset = 0;
+	iface->skip_stop = 0;

 	outb(inb(ACBCTL1) | ACBCTL1_START, ACBCTL1);

@@ -377,12 +481,13 @@ static u32 scx200_acb_func(struct i2c_ad
 {
 	return I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE |
 	       I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA |
-	       I2C_FUNC_SMBUS_I2C_BLOCK;
+	       I2C_FUNC_SMBUS_I2C_BLOCK | I2C_FUNC_I2C;
 }

 /* For now, we only handle combined mode (smbus) */
 static const struct i2c_algorithm scx200_acb_algorithm = {
 	.smbus_xfer	= scx200_acb_smbus_xfer,
+	.master_xfer    = scx200_acb_i2c_master_xfer,
 	.functionality	= scx200_acb_func,
 };
