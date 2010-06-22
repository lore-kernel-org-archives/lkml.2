Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab0FVIEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 04:04:07 -0400
Received: from sand.ocn.ne.jp ([122.28.30.136]:52040 "EHLO smtp.sand.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab0FVIEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 04:04:04 -0400
X-Greylist: delayed 1956 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jun 2010 04:04:04 EDT
From: Jon Povey <jon.povey@racelogic.co.uk>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: Jon Povey <jon.povey@racelogic.co.uk>,
       "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Chaithrika U S <chaithrika@ti.com>, Philby John <pjohn@in.mvista.com>,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: davinci: Fix race when setting up for TX
Date: Tue, 22 Jun 2010 16:31:03 +0900
Message-Id: <1277191864-5024-1-git-send-email-jon.povey@racelogic.co.uk>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the interrupt enable after the first byte load for TX, as it
was racing with the interrupt handler and corrupting dev->buf_len
for messages > 1 byte.

Tested on DM355.

Signed-off-by: Jon Povey <jon.povey@racelogic.co.uk>
---
The race seems to have been introduced by 869e6692d527983958216f13c3c8e095791909df

This fixes the problem for me, but someone from TI might want to comment
on the validity of starting the transfer before enabling the RDY interrupts.
Any possibility of losing interrupts?

Considered a spinlock but if this reordering is OK then it's neater.

I'm guessing not many people have been sending multi-byte messages..

 drivers/i2c/busses/i2c-davinci.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 2222c87..72df4af 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -347,14 +347,6 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg, int stop)
 		flag &= ~DAVINCI_I2C_MDR_STP;
 	}
 
-	/* Enable receive or transmit interrupts */
-	w = davinci_i2c_read_reg(dev, DAVINCI_I2C_IMR_REG);
-	if (msg->flags & I2C_M_RD)
-		w |= DAVINCI_I2C_IMR_RRDY;
-	else
-		w |= DAVINCI_I2C_IMR_XRDY;
-	davinci_i2c_write_reg(dev, DAVINCI_I2C_IMR_REG, w);
-
 	dev->terminate = 0;
 
 	/* write the data into mode register */
@@ -371,6 +363,14 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg, int stop)
 		dev->buf_len--;
 	}
 
+	/* Enable receive or transmit interrupts */
+	w = davinci_i2c_read_reg(dev, DAVINCI_I2C_IMR_REG);
+	if (msg->flags & I2C_M_RD)
+		w |= DAVINCI_I2C_IMR_RRDY;
+	else
+		w |= DAVINCI_I2C_IMR_XRDY;
+	davinci_i2c_write_reg(dev, DAVINCI_I2C_IMR_REG, w);
+
 	r = wait_for_completion_interruptible_timeout(&dev->cmd_complete,
 						      dev->adapter.timeout);
 	if (r == 0) {
-- 
1.6.3.3

