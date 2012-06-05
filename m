Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219Ab2FENTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:19:43 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16323 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934133Ab2FENS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:18:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 05 Jun 2012 06:17:47 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <khali@linux-fr.org>, <w.sang@pengutronix.de>, <ben-linux@fluff.org>,
        <swarren@wwwdotorg.org>, <olof@lixom.net>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/4] i2c: tegra: make sure register writes completes
Date: Tue, 5 Jun 2012 18:39:57 +0530
Message-ID: <1338901800-23968-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1338901800-23968-1-git-send-email-ldewangan@nvidia.com>
References: <1338901800-23968-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra PPSB (an peripheral bus) queues writes transactions.
In order to guarantee that writes have completed before a
certain time, a read transaction to a register on the same
bus must be executed.
This is necessary in situations such as when clearing an
interrupt status or enable, so that when returning from an
interrupt handler, the HW has already de-asserted its
interrupt status output, which will avoid spurious interrupts.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/i2c/busses/i2c-tegra.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 8b2e555..fa92396 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -430,6 +430,13 @@ static irqreturn_t tegra_i2c_isr(int irq, void *dev_id)
 	if (i2c_dev->is_dvc)
 		dvc_writel(i2c_dev, DVC_STATUS_I2C_DONE_INTR, DVC_STATUS);
 
+	/*
+	 * Register write get queued in the PPSB bus and write can
+	 * happen later. Read back register to make sure that register
+	 * write is completed.
+	 */
+	i2c_readl(i2c_dev, I2C_INT_STATUS);
+
 	if (status & I2C_INT_PACKET_XFER_COMPLETE) {
 		BUG_ON(i2c_dev->msg_buf_remaining);
 		complete(&i2c_dev->msg_complete);
@@ -444,6 +451,9 @@ err:
 	if (i2c_dev->is_dvc)
 		dvc_writel(i2c_dev, DVC_STATUS_I2C_DONE_INTR, DVC_STATUS);
 
+	/* Read back register to make sure that register writes completed */
+	i2c_readl(i2c_dev, I2C_INT_STATUS);
+
 	complete(&i2c_dev->msg_complete);
 	return IRQ_HANDLED;
 }
@@ -505,6 +515,9 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 	ret = wait_for_completion_timeout(&i2c_dev->msg_complete, TEGRA_I2C_TIMEOUT);
 	tegra_i2c_mask_irq(i2c_dev, int_mask);
 
+	/* Read back register to make sure that register writes completed */
+	i2c_readl(i2c_dev, I2C_INT_MASK);
+
 	if (WARN_ON(ret == 0)) {
 		dev_err(i2c_dev->dev, "i2c transfer timed out\n");
 
-- 
1.7.1.1

