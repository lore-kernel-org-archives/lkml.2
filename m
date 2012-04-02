Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab2DBFxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 01:53:22 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8912 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab2DBFxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 01:53:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 01 Apr 2012 22:53:20 -0700
From: Alok Chauhan <alokc@nvidia.com>
To: <swarren@wwwdotorg.org>, <khali@linux-fr.org>, <ben-linux@fluff.org>,
        <w.sang@pengutronix.de>, <swarren@nvidia.com>, <olof@lixom.net>,
        <bones@secretlab.ca>, <omaplinuxkernel@gmail.com>,
        <ccross@android.com>, <ldewangan@nvidia.com>,
        <linux-tegra@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <dgreid@chromium.org>
CC: <alokc@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] i2c: tegra: Add delay before reset the controller
Date: Mon, 2 Apr 2012 11:23:02 +0530
Message-ID: <1333345982-16595-1-git-send-email-alokc@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NACK interrupt generated before I2C controller generates
the STOP condition on bus. In Software, because of this
reset of controller is happening before I2C controller could
complete STOP condition. So wait for some time before resetting
the controller so that STOP condition has delivered properly on bus.

Added delay of 2 clock period before reset the
controller in case of NACK error.

Signed-off-by: Alok Chauhan <alokc@nvidia.com>
---
Added the more descriptive commit message about issue in case
of NACK error condition. Changed the comment in code also

 drivers/i2c/busses/i2c-tegra.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index e978635..dfb850a8 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -516,6 +516,14 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 	if (likely(i2c_dev->msg_err == I2C_ERR_NONE))
 		return 0;
 
+	/*
+	 * NACK interrupt generated before I2C controller generates the STOP
+	 * condition on bus. So wait for some time before reset the controller
+	 * so that STOP condition has delivered properly on bus.
+	 */
+	if (i2c_dev->msg_err == I2C_ERR_NO_ACK)
+		udelay(DIV_ROUND_UP(2 * 1000000, i2c_dev->bus_clk_rate));
+
 	tegra_i2c_init(i2c_dev);
 	if (i2c_dev->msg_err == I2C_ERR_NO_ACK) {
 		if (msg->flags & I2C_M_IGNORE_NAK)
-- 
1.7.4.1

