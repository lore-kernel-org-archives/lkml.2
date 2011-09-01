Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab1IAJdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 05:33:54 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:58105 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756502Ab1IAJdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:33:46 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Cc: Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>, Barry Song <21cnbao@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/4 v6] amba: request muxing for PrimeCell devices
Date: Thu, 1 Sep 2011 11:32:53 +0200
Message-ID: <1314869573-5569-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This makes the AMBA PrimeCell drivers request padmuxing for
themselves in the same manner as clocks and voltage is currently
requested.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/amba/bus.c       |   49 ++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/amba/bus.h |    2 +
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index d74926e..bd0516c 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -474,6 +474,40 @@ static void amba_put_disable_vcore(struct amba_device *pcdev)
 	}
 }
 
+static int amba_get_enable_pinmux(struct amba_device *pcdev)
+{
+	struct pinmux *pmx = pinmux_get(&pcdev->dev, NULL);
+	int ret;
+
+	pcdev->pmx = pmx;
+
+	if (IS_ERR(pmx)) {
+		/* It is OK not to supply a pinmux regulator */
+		if (PTR_ERR(pmx) == -ENODEV)
+			return 0;
+		return PTR_ERR(pmx);
+	}
+
+	ret = pinmux_enable(pmx);
+	if (ret) {
+		pinmux_put(pmx);
+		pcdev->pmx = ERR_PTR(-ENODEV);
+	}
+
+	return ret;
+}
+
+static void amba_put_disable_pinmux(struct amba_device *pcdev)
+{
+	struct pinmux *pmx = pcdev->pmx;
+
+	if (!IS_ERR(pmx)) {
+		pinmux_disable(pmx);
+		pinmux_put(pmx);
+	}
+}
+
+
 /*
  * These are the device model conversion veneers; they convert the
  * device model structures to our more specific structures.
@@ -486,13 +520,22 @@ static int amba_probe(struct device *dev)
 	int ret;
 
 	do {
-		ret = amba_get_enable_vcore(pcdev);
+		ret = amba_get_enable_pinmux(pcdev);
 		if (ret)
 			break;
 
+		ret = amba_get_enable_vcore(pcdev);
+		if (ret) {
+			amba_put_disable_pinmux(pcdev);
+			break;
+		}
+
 		ret = amba_get_enable_pclk(pcdev);
-		if (ret)
+		if (ret) {
+			amba_put_disable_pinmux(pcdev);
+			amba_put_disable_vcore(pcdev);
 			break;
+		}
 
 		ret = pcdrv->probe(pcdev, id);
 		if (ret == 0)
@@ -500,6 +543,7 @@ static int amba_probe(struct device *dev)
 
 		amba_put_disable_pclk(pcdev);
 		amba_put_disable_vcore(pcdev);
+		amba_put_disable_pinmux(pcdev);
 	} while (0);
 
 	return ret;
@@ -513,6 +557,7 @@ static int amba_remove(struct device *dev)
 
 	amba_put_disable_pclk(pcdev);
 	amba_put_disable_vcore(pcdev);
+	amba_put_disable_pinmux(pcdev);
 
 	return ret;
 }
diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index fcbbe71..35f1193 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -19,6 +19,7 @@
 #include <linux/err.h>
 #include <linux/resource.h>
 #include <linux/regulator/consumer.h>
+#include <linux/pinctrl/pinmux.h>
 
 #define AMBA_NR_IRQS	2
 #define AMBA_CID	0xb105f00d
@@ -30,6 +31,7 @@ struct amba_device {
 	struct resource		res;
 	struct clk		*pclk;
 	struct regulator	*vcore;
+	struct pinmux		*pmx;
 	u64			dma_mask;
 	unsigned int		periphid;
 	unsigned int		irq[AMBA_NR_IRQS];
-- 
1.7.3.2

