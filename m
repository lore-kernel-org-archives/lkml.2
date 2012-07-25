Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269Ab2GYPIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:08:24 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:37677 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933160Ab2GYPIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:08:16 -0400
From: Roland Stigge <stigge@antcom.de>
To: vitalywool@gmail.com, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        jonsmirl@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 2/2] i2c: pnx: Fix read transactions of >= 2 bytes
Date: Wed, 25 Jul 2012 17:07:43 +0200
Message-Id: <1343228863-11553-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1343228863-11553-1-git-send-email-stigge@antcom.de>
References: <1343228863-11553-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On transactions with n>=2 bytes, the controller actually wrongly clocks in n+1
bytes. This is caused by the (wrong) assumption that RFE in the Status Register
is 1 iff there is no byte already ordered (via a dummy TX byte). This lead to
the implementation of synchronized byte ordering, e.g.:

Dummy-TX - RX - Dummy-TX - RX - ...

But since RFE actually stays high after some Dummy-TX, it rather looks like:

Dummy-TX - Dummy-TX - RX - Dummy-TX - RX - (RX)

The last RX byte is clocked in by the bus controller, but ignored by the kernel
when filling the userspace buffer.

This patch fixes the issue by asking for RX via Dummy-TX asynchronously.
Introducing a separate counter for TX bytes.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
Applies to v3.5

This patch for i2c-pnx applies to: PNX4008, LPC31xx, LPC32xx. Can you please
test?

Thanks in advance!

 drivers/i2c/busses/i2c-pnx.c |   48 +++++++++++++++++++++++++------------------
 include/linux/i2c-pnx.h      |    1 
 2 files changed, 29 insertions(+), 20 deletions(-)

--- linux-2.6.orig/drivers/i2c/busses/i2c-pnx.c
+++ linux-2.6/drivers/i2c/busses/i2c-pnx.c
@@ -291,31 +291,37 @@ static int i2c_pnx_master_rcv(struct i2c
 	 * or we didn't 'ask' for it yet.
 	 */
 	if (ioread32(I2C_REG_STS(alg_data)) & mstatus_rfe) {
-		dev_dbg(&alg_data->adapter.dev,
-			"%s(): Write dummy data to fill Rx-fifo...\n",
-			__func__);
+		/* 'Asking' is done asynchronously, e.g. dummy TX of several
+		 * bytes is done before the first actual RX arrives in FIFO.
+		 * Therefore, ordered bytes (via TX) are counted separately.
+		 */
+		if (alg_data->mif.order) {
+			dev_dbg(&alg_data->adapter.dev,
+				"%s(): Write dummy data to fill Rx-fifo...\n",
+				__func__);
 
-		if (alg_data->mif.len == 1) {
-			/* Last byte, do not acknowledge next rcv. */
-			val |= stop_bit;
+			if (alg_data->mif.order == 1) {
+				/* Last byte, do not acknowledge next rcv. */
+				val |= stop_bit;
+
+				/*
+				 * Enable interrupt RFDAIE (data in Rx fifo),
+				 * and disable DRMIE (need data for Tx)
+				 */
+				ctl = ioread32(I2C_REG_CTL(alg_data));
+				ctl |= mcntrl_rffie | mcntrl_daie;
+				ctl &= ~mcntrl_drmie;
+				iowrite32(ctl, I2C_REG_CTL(alg_data));
+			}
 
 			/*
-			 * Enable interrupt RFDAIE (data in Rx fifo),
-			 * and disable DRMIE (need data for Tx)
+			 * Now we'll 'ask' for data:
+			 * For each byte we want to receive, we must
+			 * write a (dummy) byte to the Tx-FIFO.
 			 */
-			ctl = ioread32(I2C_REG_CTL(alg_data));
-			ctl |= mcntrl_rffie | mcntrl_daie;
-			ctl &= ~mcntrl_drmie;
-			iowrite32(ctl, I2C_REG_CTL(alg_data));
+			iowrite32(val, I2C_REG_TX(alg_data));
+			alg_data->mif.order--;
 		}
-
-		/*
-		 * Now we'll 'ask' for data:
-		 * For each byte we want to receive, we must
-		 * write a (dummy) byte to the Tx-FIFO.
-		 */
-		iowrite32(val, I2C_REG_TX(alg_data));
-
 		return 0;
 	}
 
@@ -515,6 +521,7 @@ i2c_pnx_xfer(struct i2c_adapter *adap, s
 
 		alg_data->mif.buf = pmsg->buf;
 		alg_data->mif.len = pmsg->len;
+		alg_data->mif.order = pmsg->len;
 		alg_data->mif.mode = (pmsg->flags & I2C_M_RD) ?
 			I2C_SMBUS_READ : I2C_SMBUS_WRITE;
 		alg_data->mif.ret = 0;
@@ -567,6 +574,7 @@ i2c_pnx_xfer(struct i2c_adapter *adap, s
 	/* Cleanup to be sure... */
 	alg_data->mif.buf = NULL;
 	alg_data->mif.len = 0;
+	alg_data->mif.order = 0;
 
 	dev_dbg(&alg_data->adapter.dev, "%s(): exiting, stat = %x\n",
 		__func__, ioread32(I2C_REG_STS(alg_data)));
--- linux-2.6.orig/include/linux/i2c-pnx.h
+++ linux-2.6/include/linux/i2c-pnx.h
@@ -22,6 +22,7 @@ struct i2c_pnx_mif {
 	struct timer_list	timer;		/* Timeout */
 	u8 *			buf;		/* Data buffer */
 	int			len;		/* Length of data buffer */
+	int			order;		/* RX Bytes to order via TX */
 };
 
 struct i2c_pnx_algo_data {
