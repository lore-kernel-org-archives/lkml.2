Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab2DQJH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 05:07:57 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:57446 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755750Ab2DQJHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 05:07:55 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <w.sang@pengutronix.de>, <ben-linux@fluff.org>
Cc: <spear-devel@list.st.com>, <viresh.linux@gmail.com>, <khali@linux-fr.org>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH] i2c: designware: Add clk_{un}prepare() support
Date: Tue, 17 Apr 2012 14:23:09 +0530
Message-ID: <caa4a0645f80f199b31ec16de37a5c4c9c67a6fa.1334652570.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.9
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_{un}prepare is mandatory for platforms using common clock framework. Since
this driver is used by SPEAr platform, which supports common clock framework,
add clk_{un}prepare() support for designware i2c.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/i2c/busses/i2c-designware-platdrv.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 76bf108..7b50eec 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -97,13 +97,20 @@ static int __devinit dw_i2c_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, dev);
 
 	dev->clk = clk_get(&pdev->dev, NULL);
-	dev->get_clk_rate_khz = i2c_dw_get_clk_rate_khz;
-
 	if (IS_ERR(dev->clk)) {
 		r = -ENODEV;
 		goto err_free_mem;
 	}
-	clk_enable(dev->clk);
+
+	r = clk_prepare(dev->clk);
+	if (r)
+		goto err_put_clk;
+
+	r = clk_enable(dev->clk);
+	if (r)
+		goto err_unprepare_clk;
+
+	dev->get_clk_rate_khz = i2c_dw_get_clk_rate_khz;
 
 	dev->functionality =
 		I2C_FUNC_I2C |
@@ -181,6 +188,9 @@ err_iounmap:
 	iounmap(dev->base);
 err_unuse_clocks:
 	clk_disable(dev->clk);
+err_unprepare_clk:
+	clk_unprepare(dev->clk);
+err_put_clk:
 	clk_put(dev->clk);
 	dev->clk = NULL;
 err_free_mem:
@@ -203,6 +213,7 @@ static int __devexit dw_i2c_remove(struct platform_device *pdev)
 	put_device(&pdev->dev);
 
 	clk_disable(dev->clk);
+	clk_unprepare(dev->clk);
 	clk_put(dev->clk);
 	dev->clk = NULL;
 
@@ -230,6 +241,7 @@ static int dw_i2c_suspend(struct device *dev)
 	struct dw_i2c_dev *i_dev = platform_get_drvdata(pdev);
 
 	clk_disable(i_dev->clk);
+	clk_unprepare(i_dev->clk);
 
 	return 0;
 }
@@ -239,6 +251,7 @@ static int dw_i2c_resume(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct dw_i2c_dev *i_dev = platform_get_drvdata(pdev);
 
+	clk_prepare(i_dev->clk);
 	clk_enable(i_dev->clk);
 	i2c_dw_init(i_dev);
 
-- 
1.7.9

