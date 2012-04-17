Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab2DQLsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:48:55 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:55427 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523Ab2DQLsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:48:53 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <w.sang@pengutronix.de>, <ben-linux@fluff.org>
Cc: <spear-devel@list.st.com>, <viresh.linux@gmail.com>, <khali@linux-fr.org>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2] i2c: designware: Add clk_{un}prepare() support
Date: Tue, 17 Apr 2012 17:04:31 +0530
Message-ID: <b562073871c8c3c13a1f59698f69cfdf65db3b5a.1334662366.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <caa4a0645f80f199b31ec16de37a5c4c9c67a6fa.1334652570.git.viresh.kumar@st.com>
References: <caa4a0645f80f199b31ec16de37a5c4c9c67a6fa.1334652570.git.viresh.kumar@st.com>
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
V1->V2:
- Use clk_prepare_enable and clk_disable_unprepare

 drivers/i2c/busses/i2c-designware-platdrv.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 76bf108..3a7a4e8 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -103,7 +103,7 @@ static int __devinit dw_i2c_probe(struct platform_device *pdev)
 		r = -ENODEV;
 		goto err_free_mem;
 	}
-	clk_enable(dev->clk);
+	clk_prepare_enable(dev->clk);
 
 	dev->functionality =
 		I2C_FUNC_I2C |
@@ -180,7 +180,7 @@ err_free_irq:
 err_iounmap:
 	iounmap(dev->base);
 err_unuse_clocks:
-	clk_disable(dev->clk);
+	clk_disable_unprepare(dev->clk);
 	clk_put(dev->clk);
 	dev->clk = NULL;
 err_free_mem:
@@ -202,7 +202,7 @@ static int __devexit dw_i2c_remove(struct platform_device *pdev)
 	i2c_del_adapter(&dev->adapter);
 	put_device(&pdev->dev);
 
-	clk_disable(dev->clk);
+	clk_disable_unprepare(dev->clk);
 	clk_put(dev->clk);
 	dev->clk = NULL;
 
@@ -229,7 +229,7 @@ static int dw_i2c_suspend(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct dw_i2c_dev *i_dev = platform_get_drvdata(pdev);
 
-	clk_disable(i_dev->clk);
+	clk_disable_unprepare(i_dev->clk);
 
 	return 0;
 }
@@ -239,7 +239,7 @@ static int dw_i2c_resume(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct dw_i2c_dev *i_dev = platform_get_drvdata(pdev);
 
-	clk_enable(i_dev->clk);
+	clk_prepare_enable(i_dev->clk);
 	i2c_dw_init(i_dev);
 
 	return 0;
-- 
1.7.9

