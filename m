Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111Ab2FAJNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:13:37 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4399 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab2FAJNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:13:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 01 Jun 2012 02:11:44 -0700
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <olof@lixom.net>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, <ben-linux@fluff.org>,
        <w.sang@pengutronix.de>, <ldewangan@nvidia.com>,
        <linux-i2c@vger.kernel.org>
Subject: [PATCH 2/9] i2c: tegra: Add clk_prepare/clk_unprepare
Date: Fri, 1 Jun 2012 14:42:41 +0530
Message-ID: <1338541968-7961-3-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1338541968-7961-1-git-send-email-pgaikwad@nvidia.com>
References: <1338541968-7961-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use clk_prepare/clk_unprepare as required by the generic clk framework.

This patch should go through Tegra tree since other patches to port tegra
to generic clock framework are dependent on it. Posting here to get ack from
the maintainers.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 drivers/i2c/busses/i2c-tegra.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 8b2e555..3da7ee3 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -341,7 +341,7 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 	u32 val;
 	int err = 0;
 
-	clk_enable(i2c_dev->clk);
+	clk_prepare_enable(i2c_dev->clk);
 
 	tegra_periph_reset_assert(i2c_dev->clk);
 	udelay(2);
@@ -372,7 +372,7 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 	if (tegra_i2c_flush_fifos(i2c_dev))
 		err = -ETIMEDOUT;
 
-	clk_disable(i2c_dev->clk);
+	clk_disable_unprepare(i2c_dev->clk);
 
 	if (i2c_dev->irq_disabled) {
 		i2c_dev->irq_disabled = 0;
@@ -546,14 +546,14 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 	if (i2c_dev->is_suspended)
 		return -EBUSY;
 
-	clk_enable(i2c_dev->clk);
+	clk_prepare_enable(i2c_dev->clk);
 	for (i = 0; i < num; i++) {
 		int stop = (i == (num - 1)) ? 1  : 0;
 		ret = tegra_i2c_xfer_msg(i2c_dev, &msgs[i], stop);
 		if (ret)
 			break;
 	}
-	clk_disable(i2c_dev->clk);
+	clk_disable_unprepare(i2c_dev->clk);
 	return ret ?: i;
 }
 
@@ -666,7 +666,7 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
 		goto err_free;
 	}
 
-	clk_enable(i2c_dev->i2c_clk);
+	clk_prepare_enable(i2c_dev->i2c_clk);
 
 	i2c_set_adapdata(&i2c_dev->adapter, i2c_dev);
 	i2c_dev->adapter.owner = THIS_MODULE;
-- 
1.7.4.1

