Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab1LVKld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 05:41:33 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1176 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab1LVKlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 05:41:32 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 22 Dec 2011 02:41:31 -0800
From: Alok Chauhan <alokc@nvidia.com>
To: khali@linux-fr.org, ben-linux@fluff.org, swarren@nvidia.com,
        olof@lixom.net, bones@secretlab.ca, paul.gortmaker@windriver.com
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alok Chauhan <alokc@nvidia.com>
Subject: [PATCH] i2c: tegra: Add delay before reset the controller
Date: Thu, 22 Dec 2011 16:11:20 +0530
Message-Id: <1324550480-26308-1-git-send-email-alokc@nvidia.com>
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

Added worst case delay of 1 ms (assuming lowest
clock frequency will be 1 KHZ) before reset the
controller in case of NACK error.

Signed-off-by: Alok Chauhan <alokc@nvidia.com>
---
 drivers/i2c/busses/i2c-tegra.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 6381604..b731499 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -517,6 +517,15 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 	if (likely(i2c_dev->msg_err == I2C_ERR_NONE))
 		return 0;
 
+	/*
+	 * In NACK error condition resetting of I2C controller happens
+	 * before STOP condition is properly completed by I2C controller,
+	 * so wait for worst case delay of 1 ms (assuming lowest clock
+	 * frequency will be 1 KHz) to complete STOP condition.
+	 */
+	if (i2c_dev->msg_err == I2C_ERR_NO_ACK)
+		mdelay(1);
+
 	tegra_i2c_init(i2c_dev);
 	if (i2c_dev->msg_err == I2C_ERR_NO_ACK) {
 		if (msg->flags & I2C_M_IGNORE_NAK)
-- 
1.7.4.1

