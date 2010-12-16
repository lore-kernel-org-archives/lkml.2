Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0LPOGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 09:06:48 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:33589 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab0LPOGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 09:06:47 -0500
Date: Thu, 16 Dec 2010 15:06:38 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Matthias Zacharias <Matthias.Zacharias@bmk-solutions.de>
Subject: [RFC] i2c-algo-bit: Disable interrupts while SCL is high
Message-ID: <20101216150638.7d3850b5@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a spinlock to every user of i2c-algo-bit, which is taken before
raising SCL and released after lowering SCL. We don't really need
the exclusion functionality, but we have to disable local interrupts.
This is needed to comply with SMBus requirements that SCL shouldn't
be high for longer than 50 us.

SMBus slaves can consider SCL being high for 50 us as a timeout
condition. This has been observed to happen reproducibly with the
Melexis MLX90614.

The drawback of this approach is that spin_lock_irqsave() and
spin_unlock_irqrestore() will be called once for each bit going on the
I2C bus in either direction. This can mean up to 100 kHz for standard
I2C and SMBus and up to 250 kHz for fast I2C. The good thing is that
this limits the latency to reasonable values (2us at 250 kHz, 5 us at
100 kHz and 50 us at 10 kHz).

An alternative would be to keep the lock held for the whole transfer
of every single byte. This would divide the number of calls to
spin_lock_irqsave() and spin_unlock_irqrestore() by 9 (i.e. up to 11
kHz for standard I2C and up to 28 kHz for fast I2C) at the price of
multiplying the latency by 18 (i.e. 36 us at 250 kHz, 90 us at 100 kHz
and 900 us at 10 kHz).

I would welcome comments on this. I sincerely have no idea what is
considered a reasonable duration during which local interrupts can be
disabled, and I have also no idea above what frequency taking and
releasing a (never busy) spinlock is considered unreasonable.

i2c-algo-bit is used by many popular I2C and SMBus controller drivers,
so this change will have an effect on virtually every Linux system out
there. So I don't want to get it wrong.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Tested-by: Matthias Zacharias <Matthias.Zacharias@bmk-solutions.de>
---
 drivers/i2c/algos/i2c-algo-bit.c |   38 ++++++++++++++++++++++++++++++++++----
 include/linux/i2c-algo-bit.h     |    4 ++++
 2 files changed, 38 insertions(+), 4 deletions(-)

--- linux-2.6.37-rc6.orig/drivers/i2c/algos/i2c-algo-bit.c	2010-12-16 11:01:39.000000000 +0100
+++ linux-2.6.37-rc6/drivers/i2c/algos/i2c-algo-bit.c	2010-12-16 13:11:12.000000000 +0100
@@ -29,6 +29,7 @@
 #include <linux/sched.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
+#include <linux/spinlock.h>
 
 
 /* ----- global defines ----------------------------------------------- */
@@ -130,12 +131,17 @@ static void i2c_start(struct i2c_algo_bi
 
 static void i2c_repstart(struct i2c_algo_bit_data *adap)
 {
+	unsigned long flags;
+
 	/* assert: scl is low */
 	sdahi(adap);
+	spin_lock_irqsave(&adap->lock, flags);
 	sclhi(adap);
 	setsda(adap, 0);
 	udelay(adap->udelay);
-	scllo(adap);
+	setscl(adap, 0);
+	spin_unlock_irqrestore(&adap->lock, flags);
+	udelay(adap->udelay / 2);
 }
 
 
@@ -163,13 +169,16 @@ static int i2c_outb(struct i2c_adapter *
 	int sb;
 	int ack;
 	struct i2c_algo_bit_data *adap = i2c_adap->algo_data;
+	unsigned long flags;
 
 	/* assert: scl is low */
 	for (i = 7; i >= 0; i--) {
 		sb = (c >> i) & 1;
 		setsda(adap, sb);
 		udelay((adap->udelay + 1) / 2);
+		spin_lock_irqsave(&adap->lock, flags);
 		if (sclhi(adap) < 0) { /* timed out */
+			spin_unlock_irqrestore(&adap->lock, flags);
 			bit_dbg(1, &i2c_adap->dev, "i2c_outb: 0x%02x, "
 				"timeout at bit #%d\n", (int)c, i);
 			return -ETIMEDOUT;
@@ -180,10 +189,14 @@ static int i2c_outb(struct i2c_adapter *
 		 * Report a unique code, so higher level code can retry
 		 * the whole (combined) message and *NOT* issue STOP.
 		 */
-		scllo(adap);
+		setscl(adap, 0);
+		spin_unlock_irqrestore(&adap->lock, flags);
+		udelay(adap->udelay / 2);
 	}
 	sdahi(adap);
+	spin_lock_irqsave(&adap->lock, flags);
 	if (sclhi(adap) < 0) { /* timeout */
+		spin_unlock_irqrestore(&adap->lock, flags);
 		bit_dbg(1, &i2c_adap->dev, "i2c_outb: 0x%02x, "
 			"timeout at ack\n", (int)c);
 		return -ETIMEDOUT;
@@ -193,10 +206,13 @@ static int i2c_outb(struct i2c_adapter *
 	 * NAK (usually to report problems with the data we wrote).
 	 */
 	ack = !getsda(adap);    /* ack: sda is pulled low -> success */
+	setscl(adap, 0);
+	spin_unlock_irqrestore(&adap->lock, flags);
+	udelay(adap->udelay / 2);
+
 	bit_dbg(2, &i2c_adap->dev, "i2c_outb: 0x%02x %s\n", (int)c,
 		ack ? "A" : "NA");
 
-	scllo(adap);
 	return ack;
 	/* assert: scl is low (sda undef) */
 }
@@ -209,11 +225,14 @@ static int i2c_inb(struct i2c_adapter *i
 	int i;
 	unsigned char indata = 0;
 	struct i2c_algo_bit_data *adap = i2c_adap->algo_data;
+	unsigned long flags;
 
 	/* assert: scl is low */
 	sdahi(adap);
 	for (i = 0; i < 8; i++) {
+		spin_lock_irqsave(&adap->lock, flags);
 		if (sclhi(adap) < 0) { /* timeout */
+			spin_unlock_irqrestore(&adap->lock, flags);
 			bit_dbg(1, &i2c_adap->dev, "i2c_inb: timeout at bit "
 				"#%d\n", 7 - i);
 			return -ETIMEDOUT;
@@ -222,6 +241,7 @@ static int i2c_inb(struct i2c_adapter *i
 		if (getsda(adap))
 			indata |= 0x01;
 		setscl(adap, 0);
+		spin_unlock_irqrestore(&adap->lock, flags);
 		udelay(i == 7 ? adap->udelay / 2 : adap->udelay);
 	}
 	/* assert: scl is low */
@@ -384,16 +404,21 @@ static int sendbytes(struct i2c_adapter
 static int acknak(struct i2c_adapter *i2c_adap, int is_ack)
 {
 	struct i2c_algo_bit_data *adap = i2c_adap->algo_data;
+	unsigned long flags;
 
 	/* assert: sda is high */
 	if (is_ack)		/* send ack */
 		setsda(adap, 0);
 	udelay((adap->udelay + 1) / 2);
+	spin_lock_irqsave(&adap->lock, flags);
 	if (sclhi(adap) < 0) {	/* timeout */
+		spin_unlock_irqrestore(&adap->lock, flags);
 		dev_err(&i2c_adap->dev, "readbytes: ack/nak timeout\n");
 		return -ETIMEDOUT;
 	}
-	scllo(adap);
+	setscl(adap, 0);
+	spin_unlock_irqrestore(&adap->lock, flags);
+	udelay(adap->udelay / 2);
 	return 0;
 }
 
@@ -616,6 +641,11 @@ static int __i2c_bit_add_bus(struct i2c_
 	adap->algo = &i2c_bit_algo;
 	adap->retries = 3;
 
+	/* We use a spinlock to block interrupts while SCL is high.
+	 * Otherwise the very short SMBus SCL high timeout (50 us)
+	 * can be reached, causing SMBus slaves to stop responding. */
+	spin_lock_init(&bit_adap->lock);
+
 	ret = add_adapter(adap);
 	if (ret < 0)
 		return ret;
--- linux-2.6.37-rc6.orig/include/linux/i2c-algo-bit.h	2010-12-16 11:00:59.000000000 +0100
+++ linux-2.6.37-rc6/include/linux/i2c-algo-bit.h	2010-12-16 13:11:41.000000000 +0100
@@ -24,6 +24,8 @@
 #ifndef _LINUX_I2C_ALGO_BIT_H
 #define _LINUX_I2C_ALGO_BIT_H
 
+#include <linux/spinlock.h>
+
 /* --- Defines for bit-adapters ---------------------------------------	*/
 /*
  * This struct contains the hw-dependent functions of bit-style adapters to
@@ -39,6 +41,8 @@ struct i2c_algo_bit_data {
 	int  (*pre_xfer)  (struct i2c_adapter *);
 	void (*post_xfer) (struct i2c_adapter *);
 
+	spinlock_t lock;	/* Disable interrupts when SCL is high */
+
 	/* local settings */
 	int udelay;		/* half clock cycle time in us,
 				   minimum 2 us for fast-mode I2C,


-- 
Jean Delvare
