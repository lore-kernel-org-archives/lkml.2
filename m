Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030397Ab2CITqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:46:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964845Ab2CITqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:46:03 -0500
Message-Id: <20120309190203.308535206@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wolfram Sang <w.sang@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Marek Vasut <marek.vasut@gmail.com>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [ 12/95] i2c: mxs: only flag completion when queue is completely done
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <w.sang@pengutronix.de>

commit 844990daa2e69a4258049ba9c2bae1180657dac3 upstream.

The hardware generates an interrupt for every completed command in the
queue while the code assumed that it will only generate one interrupt
when the queue is empty. So, explicitly check if the queue is really
empty. This patch fixed problems which occurred due to high traffic on
the bus. While we are here, move the completion-initialization after the
parameter error checking.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Lothar Waßmann <LW@KARO-electronics.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-mxs.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -72,6 +72,7 @@
 
 #define MXS_I2C_QUEUESTAT	(0x70)
 #define MXS_I2C_QUEUESTAT_RD_QUEUE_EMPTY        0x00002000
+#define MXS_I2C_QUEUESTAT_WRITE_QUEUE_CNT_MASK	0x0000001F
 
 #define MXS_I2C_QUEUECMD	(0x80)
 
@@ -219,14 +220,14 @@ static int mxs_i2c_xfer_msg(struct i2c_a
 	int ret;
 	int flags;
 
-	init_completion(&i2c->cmd_complete);
-
 	dev_dbg(i2c->dev, "addr: 0x%04x, len: %d, flags: 0x%x, stop: %d\n",
 		msg->addr, msg->len, msg->flags, stop);
 
 	if (msg->len == 0)
 		return -EINVAL;
 
+	init_completion(&i2c->cmd_complete);
+
 	flags = stop ? MXS_I2C_CTRL0_POST_SEND_STOP : 0;
 
 	if (msg->flags & I2C_M_RD)
@@ -286,6 +287,7 @@ static irqreturn_t mxs_i2c_isr(int this_
 {
 	struct mxs_i2c_dev *i2c = dev_id;
 	u32 stat = readl(i2c->regs + MXS_I2C_CTRL1) & MXS_I2C_IRQ_MASK;
+	bool is_last_cmd;
 
 	if (!stat)
 		return IRQ_NONE;
@@ -300,9 +302,14 @@ static irqreturn_t mxs_i2c_isr(int this_
 	else
 		i2c->cmd_err = 0;
 
-	complete(&i2c->cmd_complete);
+	is_last_cmd = (readl(i2c->regs + MXS_I2C_QUEUESTAT) &
+		MXS_I2C_QUEUESTAT_WRITE_QUEUE_CNT_MASK) == 0;
+
+	if (is_last_cmd || i2c->cmd_err)
+		complete(&i2c->cmd_complete);
 
 	writel(stat, i2c->regs + MXS_I2C_CTRL1_CLR);
+
 	return IRQ_HANDLED;
 }
 


