Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329Ab2C3MG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:06:57 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17759 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933847Ab2C3MGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:06:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 30 Mar 2012 05:06:50 -0700
From: Alok Chauhan <alokc@nvidia.com>
To: <khali@linux-fr.org>, <ben-linux@fluff.org>, <w.sang@pengutronix.de>,
        <swarren@nvidia.com>, <olof@lixom.net>, <bones@secretlab.ca>,
        <omaplinuxkernel@gmail.com>, <ccross@android.com>,
        <ldewangan@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <dgreid@chromium.org>
CC: <alokc@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] i2c: tegra: Add delay before reset the controller
Date: Fri, 30 Mar 2012 17:36:19 +0530
Message-ID: <1333109179-12445-1-git-send-email-alokc@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In NACK error condition, I2C controller violates
clock-to-data setup time before stop. In Software,
because of this reset of controller is happening
before I2C controller could complete STOP condition.

Added delay of 2 clock period before reset the
controller in case of NACK error.

Signed-off-by: Alok Chauhan <alokc@nvidia.com>
---
delay will be calculated based on clock frequency of the bus.
 drivers/i2c/busses/i2c-tegra.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index e978635..344282e 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -516,6 +516,14 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 	if (likely(i2c_dev->msg_err == I2C_ERR_NONE))
 		return 0;
 
+	/*
+	 * In NACK error condition resetting of I2C controller happens
+	 * before STOP condition is properly completed by I2C controller,
+	 * so wait for 2 clock cycle to complete STOP condition.
+	 */
+	if (i2c_dev->msg_err == I2C_ERR_NO_ACK)
+		udelay(DIV_ROUND_UP(2 * 1000000, i2c_dev->bus_clk_rate));
+
 	tegra_i2c_init(i2c_dev);
 	if (i2c_dev->msg_err == I2C_ERR_NO_ACK) {
 		if (msg->flags & I2C_M_IGNORE_NAK)
-- 
1.7.4.1

