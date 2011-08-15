Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1HOSuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 14:50:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27892 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab1HOSuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 14:50:23 -0400
From: Doug Anderson <dianders@chromium.org>
To: Ben Dooks <ben-linux@fluff.org>, Stephen Warren <swarren@nvidia.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>
Cc: Jean Delvare <khali@linux-fr.org>, Rakesh Iyer <riyer@nvidia.com>,
        Doug Anderson <dianders@chromium.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] i2c: tegra: Check for overflow errors with BUG_ON.
Date: Mon, 15 Aug 2011 11:49:32 -0700
Message-Id: <1313434172-18319-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change doesn't fix any known problems but turns
on the overflow detection feature of the i2c controller
in the hopes of flushing out any current (or future)
bugs in the i2c driver.

Inspired by a change on nvidia's git server:
  http://nv-tegra.nvidia.com/gitweb/?p=linux-2.6.git;a=commit;h=266d1b7397284505e55d06254b497cb32be07b69

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/i2c/busses/i2c-tegra.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 2440b74..4dbba23 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -367,7 +367,8 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 static irqreturn_t tegra_i2c_isr(int irq, void *dev_id)
 {
 	u32 status;
-	const u32 status_err = I2C_INT_NO_ACK | I2C_INT_ARBITRATION_LOST;
+	const u32 status_err = I2C_INT_NO_ACK | I2C_INT_ARBITRATION_LOST |
+		I2C_INT_TX_FIFO_OVERFLOW;
 	struct tegra_i2c_dev *i2c_dev = dev_id;
 
 	status = i2c_readl(i2c_dev, I2C_INT_STATUS);
@@ -389,6 +390,9 @@ static irqreturn_t tegra_i2c_isr(int irq, void *dev_id)
 	}
 
 	if (unlikely(status & status_err)) {
+		/* Don't pass this back--it can only happen due to a bug. */
+		BUG_ON(status & I2C_INT_TX_FIFO_OVERFLOW);
+
 		if (status & I2C_INT_NO_ACK)
 			i2c_dev->msg_err |= I2C_ERR_NO_ACK;
 		if (status & I2C_INT_ARBITRATION_LOST)
@@ -423,7 +427,7 @@ err:
 	/* An error occurred, mask all interrupts */
 	tegra_i2c_mask_irq(i2c_dev, I2C_INT_NO_ACK | I2C_INT_ARBITRATION_LOST |
 		I2C_INT_PACKET_XFER_COMPLETE | I2C_INT_TX_FIFO_DATA_REQ |
-		I2C_INT_RX_FIFO_DATA_REQ);
+		I2C_INT_RX_FIFO_DATA_REQ | I2C_INT_TX_FIFO_OVERFLOW);
 	i2c_writel(i2c_dev, status, I2C_INT_STATUS);
 	if (i2c_dev->is_dvc)
 		dvc_writel(i2c_dev, DVC_STATUS_I2C_DONE_INTR, DVC_STATUS);
@@ -473,7 +477,8 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 	if (!(msg->flags & I2C_M_RD))
 		tegra_i2c_fill_tx_fifo(i2c_dev);
 
-	int_mask = I2C_INT_NO_ACK | I2C_INT_ARBITRATION_LOST;
+	int_mask = I2C_INT_NO_ACK | I2C_INT_ARBITRATION_LOST |
+		I2C_INT_TX_FIFO_OVERFLOW;
 	if (msg->flags & I2C_M_RD)
 		int_mask |= I2C_INT_RX_FIFO_DATA_REQ;
 	else if (i2c_dev->msg_buf_remaining)
-- 
1.7.3.1

