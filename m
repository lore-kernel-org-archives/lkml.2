Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934225Ab2FENSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:18:44 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16328 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934196Ab2FENSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:18:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 05 Jun 2012 06:17:53 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <khali@linux-fr.org>, <w.sang@pengutronix.de>, <ben-linux@fluff.org>,
        <swarren@wwwdotorg.org>, <olof@lixom.net>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/4] i2c: tegra: support for I2C_M_NOSTART functionality
Date: Tue, 5 Jun 2012 18:39:59 +0530
Message-ID: <1338901800-23968-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1338901800-23968-1-git-send-email-ldewangan@nvidia.com>
References: <1338901800-23968-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for functionality I2C_M_NOSTART.
When multiple message transfer request made through i2c
and if any message is flagged with I2C_M_NOSTART then
it will not send the start/repeat-start and address of
that message i.e. sends data directly.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This is rebased of earlier patch on same support.
At this time using the new flag I2C_FUNC_NOSTART.

 drivers/i2c/busses/i2c-tegra.c |   31 ++++++++++++++++++++++++++-----
 1 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 36d8725..4cc9594 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -97,8 +97,21 @@
 #define I2C_HEADER_10BIT_ADDR			(1<<18)
 #define I2C_HEADER_IE_ENABLE			(1<<17)
 #define I2C_HEADER_REPEAT_START			(1<<16)
+#define I2C_HEADER_CONTINUE_XFER		(1<<15)
 #define I2C_HEADER_MASTER_ADDR_SHIFT		12
 #define I2C_HEADER_SLAVE_ADDR_SHIFT		1
+/*
+ * msg_end_type: The bus control which need to be send at end of transfer.
+ * @MSG_END_STOP: Send stop pulse at end of transfer.
+ * @MSG_END_REPEAT_START: Send repeat start at end of transfer.
+ * @MSG_END_CONTINUE: The following on message is coming and so do not send
+ *		stop or repeat start.
+ */
+enum msg_end_type {
+	MSG_END_STOP,
+	MSG_END_REPEAT_START,
+	MSG_END_CONTINUE,
+};
 
 /**
  * struct tegra_i2c_dev	- per device i2c context
@@ -459,7 +472,7 @@ err:
 }
 
 static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
-	struct i2c_msg *msg, int stop)
+	struct i2c_msg *msg, enum msg_end_type end_state)
 {
 	u32 packet_header;
 	u32 int_mask;
@@ -486,7 +499,9 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 	i2c_writel(i2c_dev, packet_header, I2C_TX_FIFO);
 
 	packet_header = I2C_HEADER_IE_ENABLE;
-	if (!stop)
+	if (end_state == MSG_END_CONTINUE)
+		packet_header |= I2C_HEADER_CONTINUE_XFER;
+	else if (end_state == MSG_END_REPEAT_START)
 		packet_header |= I2C_HEADER_REPEAT_START;
 	if (msg->flags & I2C_M_TEN) {
 		packet_header |= msg->addr;
@@ -561,8 +576,14 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 
 	clk_enable(i2c_dev->clk);
 	for (i = 0; i < num; i++) {
-		int stop = (i == (num - 1)) ? 1  : 0;
-		ret = tegra_i2c_xfer_msg(i2c_dev, &msgs[i], stop);
+		enum msg_end_type end_type = MSG_END_STOP;
+		if (i < (num - 1)) {
+			if (msgs[i + 1].flags & I2C_M_NOSTART)
+				end_type = MSG_END_CONTINUE;
+			else
+				end_type = MSG_END_REPEAT_START;
+		}
+		ret = tegra_i2c_xfer_msg(i2c_dev, &msgs[i], end_type);
 		if (ret)
 			break;
 	}
@@ -573,7 +594,7 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 static u32 tegra_i2c_func(struct i2c_adapter *adap)
 {
 	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL | I2C_FUNC_10BIT_ADDR |
-		I2C_FUNC_PROTOCOL_MANGLING;
+		I2C_FUNC_PROTOCOL_MANGLING | I2C_FUNC_NOSTART;
 }
 
 static const struct i2c_algorithm tegra_i2c_algo = {
-- 
1.7.1.1

