Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab1LZLPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 06:15:07 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19474 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab1LZLPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 06:15:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 26 Dec 2011 03:15:05 -0800
From: Alok Chauhan <alokc@nvidia.com>
To: khali@linux-fr.org, ben-linux@fluff.org, swarren@nvidia.com,
        olof@lixom.net, bones@secretlab.ca, paul.gortmaker@windriver.com,
        dgreid@google.com, ldewangan@nvidia.com
Cc: linux-tegra@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alok Chauhan <alokc@nvidia.com>
Subject: [PATCH v2] i2c: tegra: Add delay before reset the controller
Date: Mon, 26 Dec 2011 16:44:41 +0530
Message-Id: <1324898081-10308-1-git-send-email-alokc@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alok Chauhan <alokc@nvidia.com>

In NACK error condition, I2C controller violates
clock-to-data setup time before stop. In Software,
because of this reset of controller is happening
before I2C controller could complete STOP condition.

Added delay of 2 clock period before reset the
controller in case of NACK error.

Signed-off-by: Alok Chauhan <alokc@nvidia.com>
---
Instead of setting constant value for delay as was in previous patch, now in
the current modification delay will be calculated based on clock frequency of the bus.
 drivers/i2c/busses/i2c-tegra.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 6381604..62e197c 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -517,6 +517,14 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
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

