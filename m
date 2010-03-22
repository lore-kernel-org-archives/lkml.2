Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab0CVHXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 03:23:15 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49618 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238Ab0CVHXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 03:23:13 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-i2c@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 1/5] i2c-bfin-twi: integrate timeout timer with completion interface
Date: Mon, 22 Mar 2010 03:23:16 -0400
Message-Id: <1269242600-30147-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269242600-30147-1-git-send-email-vapier@gentoo.org>
References: <1269242600-30147-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

There isn't much point in managing our own custom timeout timer when the
completion interface already includes support for it.  This makes the
resulting code much simpler and robust.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/i2c/busses/i2c-bfin-twi.c |  125 +++++++++++++++++++-----------------
 1 files changed, 66 insertions(+), 59 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index fe3fb56..e016b1b 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -24,8 +24,6 @@
 #include <asm/portmux.h>
 #include <asm/irq.h>
 
-#define POLL_TIMEOUT       (2 * HZ)
-
 /* SMBus mode*/
 #define TWI_I2C_MODE_STANDARD		1
 #define TWI_I2C_MODE_STANDARDSUB	2
@@ -43,8 +41,6 @@ struct bfin_twi_iface {
 	int			cur_mode;
 	int			manual_stop;
 	int			result;
-	int			timeout_count;
-	struct timer_list	timeout_timer;
 	struct i2c_adapter	adap;
 	struct completion	complete;
 	struct i2c_msg 		*pmsg;
@@ -168,16 +164,13 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 			write_INT_MASK(iface, 0);
 			write_MASTER_CTL(iface, 0);
 			SSYNC();
-			/* If it is a quick transfer, only address bug no data,
+			/* If it is a quick transfer, only address without data,
 			 * not an err, return 1.
+			 * If address is acknowledged return 1.
 			 */
-			if (iface->writeNum == 0 && (mast_stat & BUFRDERR))
+			if ((iface->writeNum == 0 && (mast_stat & BUFRDERR))
+				|| !(mast_stat & ANAK))
 				iface->result = 1;
-			/* If address not acknowledged return -1,
-			 * else return 0.
-			 */
-			else if (!(mast_stat & ANAK))
-				iface->result = 0;
 		}
 		complete(&iface->complete);
 		return;
@@ -249,9 +242,9 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 			write_INT_MASK(iface, 0);
 			write_MASTER_CTL(iface, 0);
 			SSYNC();
-			complete(&iface->complete);
 		}
 	}
+	complete(&iface->complete);
 }
 
 /* Interrupt handler */
@@ -261,36 +254,15 @@ static irqreturn_t bfin_twi_interrupt_entry(int irq, void *dev_id)
 	unsigned long flags;
 
 	spin_lock_irqsave(&iface->lock, flags);
-	del_timer(&iface->timeout_timer);
 	bfin_twi_handle_interrupt(iface);
 	spin_unlock_irqrestore(&iface->lock, flags);
 	return IRQ_HANDLED;
 }
 
-static void bfin_twi_timeout(unsigned long data)
-{
-	struct bfin_twi_iface *iface = (struct bfin_twi_iface *)data;
-	unsigned long flags;
-
-	spin_lock_irqsave(&iface->lock, flags);
-	bfin_twi_handle_interrupt(iface);
-	if (iface->result == 0) {
-		iface->timeout_count--;
-		if (iface->timeout_count > 0) {
-			iface->timeout_timer.expires = jiffies + POLL_TIMEOUT;
-			add_timer(&iface->timeout_timer);
-		} else {
-			iface->result = -1;
-			complete(&iface->complete);
-		}
-	}
-	spin_unlock_irqrestore(&iface->lock, flags);
-}
-
 /*
- * Generic i2c master transfer entrypoint
+ * One i2c master transfer
  */
-static int bfin_twi_master_xfer(struct i2c_adapter *adap,
+static int bfin_twi_do_master_xfer(struct i2c_adapter *adap,
 				struct i2c_msg *msgs, int num)
 {
 	struct bfin_twi_iface *iface = adap->algo_data;
@@ -318,7 +290,6 @@ static int bfin_twi_master_xfer(struct i2c_adapter *adap,
 	iface->transPtr = pmsg->buf;
 	iface->writeNum = iface->readNum = pmsg->len;
 	iface->result = 0;
-	iface->timeout_count = 10;
 	init_completion(&(iface->complete));
 	/* Set Transmit device address */
 	write_MASTER_ADDR(iface, pmsg->addr);
@@ -357,30 +328,49 @@ static int bfin_twi_master_xfer(struct i2c_adapter *adap,
 		iface->manual_stop = 1;
 	}
 
-	iface->timeout_timer.expires = jiffies + POLL_TIMEOUT;
-	add_timer(&iface->timeout_timer);
-
 	/* Master enable */
 	write_MASTER_CTL(iface, read_MASTER_CTL(iface) | MEN |
 		((iface->read_write == I2C_SMBUS_READ) ? MDIR : 0) |
 		((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ > 100) ? FAST : 0));
 	SSYNC();
 
-	wait_for_completion(&iface->complete);
-
-	rc = iface->result;
+	while (!iface->result) {
+		if (!wait_for_completion_timeout(&iface->complete,
+			adap->timeout)) {
+			iface->result = -1;
+			dev_err(&adap->dev, "master transfer timeout\n");
+		}
+	}
 
-	if (rc == 1)
-		return num;
+	if (iface->result == 1)
+		rc = iface->cur_msg + 1;
 	else
-		return rc;
+		rc = iface->result;
+
+	return rc;
 }
 
 /*
- * SMBus type transfer entrypoint
+ * Generic i2c master transfer entrypoint
  */
+static int bfin_twi_master_xfer(struct i2c_adapter *adap,
+				struct i2c_msg *msgs, int num)
+{
+	int i, ret = 0;
 
-int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
+	for (i = 0; i < adap->retries; i++) {
+		ret = bfin_twi_do_master_xfer(adap, msgs, num);
+		if (ret > 0)
+			break;
+	}
+
+	return ret;
+}
+
+/*
+ * One I2C SMBus transfer
+ */
+int bfin_twi_do_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 			unsigned short flags, char read_write,
 			u8 command, int size, union i2c_smbus_data *data)
 {
@@ -468,7 +458,6 @@ int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 	iface->manual_stop = 0;
 	iface->read_write = read_write;
 	iface->command = command;
-	iface->timeout_count = 10;
 	init_completion(&(iface->complete));
 
 	/* FIFO Initiation. Data in FIFO should be discarded before
@@ -485,9 +474,6 @@ int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 	write_MASTER_ADDR(iface, addr);
 	SSYNC();
 
-	iface->timeout_timer.expires = jiffies + POLL_TIMEOUT;
-	add_timer(&iface->timeout_timer);
-
 	switch (iface->cur_mode) {
 	case TWI_I2C_MODE_STANDARDSUB:
 		write_XMT_DATA8(iface, iface->command);
@@ -549,10 +535,8 @@ int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 				else if (iface->readNum > 255) {
 					write_MASTER_CTL(iface, 0xff << 6);
 					iface->manual_stop = 1;
-				} else {
-					del_timer(&iface->timeout_timer);
+				} else
 					break;
-				}
 			}
 		}
 		write_INT_MASK(iface, MCOMP | MERR |
@@ -568,7 +552,13 @@ int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 	}
 	SSYNC();
 
-	wait_for_completion(&iface->complete);
+	while (!iface->result) {
+		if (!wait_for_completion_timeout(&iface->complete,
+			adap->timeout)) {
+			iface->result = -1;
+			dev_err(&adap->dev, "smbus transfer timeout\n");
+		}
+	}
 
 	rc = (iface->result >= 0) ? 0 : -1;
 
@@ -576,6 +566,25 @@ int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 }
 
 /*
+ * Generic I2C SMBus transfer entrypoint
+ */
+int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
+			unsigned short flags, char read_write,
+			u8 command, int size, union i2c_smbus_data *data)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < adap->retries; i++) {
+		ret = bfin_twi_do_smbus_xfer(adap, addr, flags,
+			read_write, command, size, data);
+		if (ret == 0)
+			break;
+	}
+
+	return ret;
+}
+
+/*
  * Return what the adapter supports
  */
 static u32 bfin_twi_functionality(struct i2c_adapter *adap)
@@ -666,10 +675,6 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
 		goto out_error_no_irq;
 	}
 
-	init_timer(&(iface->timeout_timer));
-	iface->timeout_timer.function = bfin_twi_timeout;
-	iface->timeout_timer.data = (unsigned long)iface;
-
 	p_adap = &iface->adap;
 	p_adap->nr = pdev->id;
 	strlcpy(p_adap->name, pdev->name, sizeof(p_adap->name));
@@ -677,6 +682,8 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
 	p_adap->algo_data = iface;
 	p_adap->class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
 	p_adap->dev.parent = &pdev->dev;
+	p_adap->timeout = 5 * HZ;
+	p_adap->retries = 3;
 
 	rc = peripheral_request_list(pin_req[pdev->id], "i2c-bfin-twi");
 	if (rc) {
-- 
1.7.0.2

