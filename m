Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab1DKDP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 23:15:56 -0400
Received: from ns.vscht.cz ([147.33.15.5]:59600 "EHLO ns.vscht.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab1DKDPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 23:15:54 -0400
Message-ID: <4DA27245.6@vscht.cz>
Date: Mon, 11 Apr 2011 05:15:17 +0200
From: =?UTF-8?B?SmnFmcOtIFBpbmthdmE=?= <Jiri.Pinkava@vscht.cz>
Organization: =?UTF-8?B?VsWgQ0hU?=
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Lanikai/3.1.9
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nand: Fix S3C NAND clock stop
References: <1302485262-8401-1-git-send-email-jiri.pinkava@vscht.cz> <4DA261DA.2050404@oracle.com>
In-Reply-To: <4DA261DA.2050404@oracle.com>
Content-Type: multipart/mixed;
	boundary="------------040301050000000004070907"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------040301050000000004070907
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit

Current implementation of s3c2410_nand_select_chip call
clk_disable every time when chip = -1 (de-select). This happend
multiple times even if chip was already de-selected. This causes
disabling clock even if they are already disabled and due to
nature of clock subsytem implementation this causes nand clock
to be disabled and newer enabled again.

Signed-off-by: Jiri Pinkava <jiri.pinkava@vscht.cz>
---
  drivers/mtd/nand/s3c2410.c |   57 
+++++++++++++++++++++++++++++++------------
  1 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index 33d832d..fbc37dc 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -54,8 +54,14 @@ static int hardware_ecc = 1;
  static int hardware_ecc = 0;
  #endif

+#define CLOCK_DISABLE	0
+#define CLOCK_ENABLE	1
+#define CLOCK_SUSPEND	2
+
+static int clock_state = CLOCK_DISABLE;
+
  #ifdef CONFIG_MTD_NAND_S3C2410_CLKSTOP
-static int clock_stop = 1;
+static const int clock_stop = 1;
  #else
  static const int clock_stop = 0;
  #endif
@@ -159,11 +165,33 @@ static struct s3c2410_platform_nand 
*to_nand_plat(struct platform_device *dev)
  	return dev->dev.platform_data;
  }

-static inline int allow_clk_stop(struct s3c2410_nand_info *info)
+static inline int allow_clk_suspend(struct s3c2410_nand_info *info)
  {
  	return clock_stop;
  }

+/**
+ * s3c2410_nand_clk_set_state - Enable, disable or suspend NAND clock.
+ * @info: The controller instance.
+ * @new_state: State to which clock should be set.
+ */
+static void s3c2410_nand_clk_set_state(struct s3c2410_nand_info *info,
+		int new_state)
+{
+	if (!allow_clk_suspend(info) && new_state == CLOCK_SUSPEND)
+		return;
+
+	if (clock_state == CLOCK_ENABLE) {
+		if (new_state != CLOCK_ENABLE)
+			clk_disable(info->clk);
+	} else {
+		if (new_state == CLOCK_ENABLE)
+			clk_enable(info->clk);
+	}
+
+	clock_state = new_state;
+}
+
  /* timing calculations */

  #define NS_IN_KHZ 1000000
@@ -333,8 +361,8 @@ static void s3c2410_nand_select_chip(struct mtd_info 
*mtd, int chip)
  	nmtd = this->priv;
  	info = nmtd->info;

-	if (chip != -1 && allow_clk_stop(info))
-		clk_enable(info->clk);
+	if (chip != -1)
+		s3c2410_nand_clk_set_state(info, CLOCK_ENABLE);

  	cur = readl(info->sel_reg);

@@ -356,8 +384,8 @@ static void s3c2410_nand_select_chip(struct mtd_info 
*mtd, int chip)

  	writel(cur, info->sel_reg);

-	if (chip == -1 && allow_clk_stop(info))
-		clk_disable(info->clk);
+	if (chip == -1)
+		s3c2410_nand_clk_set_state(info, CLOCK_SUSPEND);
  }

  /* s3c2410_nand_hwcontrol
@@ -694,8 +722,7 @@ static int s3c24xx_nand_remove(struct 
platform_device *pdev)
  	/* free the common resources */

  	if (info->clk != NULL && !IS_ERR(info->clk)) {
-		if (!allow_clk_stop(info))
-			clk_disable(info->clk);
+		s3c2410_nand_clk_set_state(info, CLOCK_DISABLE);
  		clk_put(info->clk);
  	}

@@ -947,7 +974,7 @@ static int s3c24xx_nand_probe(struct platform_device 
*pdev)
  		goto exit_error;
  	}

-	clk_enable(info->clk);
+	s3c2410_nand_clk_set_state(info, CLOCK_ENABLE);

  	/* allocate and map the resource */

@@ -1026,9 +1053,9 @@ static int s3c24xx_nand_probe(struct 
platform_device *pdev)
  		goto exit_error;
  	}

-	if (allow_clk_stop(info)) {
+	if (allow_clk_suspend(info)) {
  		dev_info(&pdev->dev, "clock idle support enabled\n");
-		clk_disable(info->clk);
+		s3c2410_nand_clk_set_state(info, CLOCK_SUSPEND);
  	}

  	pr_debug("initialised ok\n");
@@ -1059,8 +1086,7 @@ static int s3c24xx_nand_suspend(struct 
platform_device *dev, pm_message_t pm)

  		writel(info->save_sel | info->sel_bit, info->sel_reg);

-		if (!allow_clk_stop(info))
-			clk_disable(info->clk);
+		s3c2410_nand_clk_set_state(info, CLOCK_DISABLE);
  	}

  	return 0;
@@ -1072,7 +1098,7 @@ static int s3c24xx_nand_resume(struct 
platform_device *dev)
  	unsigned long sel;

  	if (info) {
-		clk_enable(info->clk);
+		s3c2410_nand_clk_set_state(info, CLOCK_ENABLE);
  		s3c2410_nand_inithw(info);

  		/* Restore the state of the nFCE line. */
@@ -1082,8 +1108,7 @@ static int s3c24xx_nand_resume(struct 
platform_device *dev)
  		sel |= info->save_sel & info->sel_bit;
  		writel(sel, info->sel_reg);

-		if (allow_clk_stop(info))
-			clk_disable(info->clk);
+		s3c2410_nand_clk_set_state(info, CLOCK_SUSPEND);
  	}

  	return 0;
-- 
1.7.4.4



--------------040301050000000004070907
Content-Type: text/x-patch; name="0001-nand-Fix-S3C-NAND-clock-stop.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-nand-Fix-S3C-NAND-clock-stop.patch"

>From 4fd7086f28d6452f1edafa903e7becd5a0f017c6 Mon Sep 17 00:00:00 2001
From: Jiri Pinkava <jiri.pinkava@vscht.cz>
Date: Mon, 11 Apr 2011 03:20:33 +0200
Subject: [PATCH] nand: Fix S3C NAND clock stop

Current implementation of s3c2410_nand_select_chip call
clk_disable every time when chip = -1 (de-select). This happend
multiple times even if chip was already de-selected. This causes
disabling clock even if they are already disabled and due to
nature of clock subsytem implementation this causes nand clock
to be disabled and newer enabled again.

Signed-off-by: Jiri Pinkava <jiri.pinkava@vscht.cz>
---
 drivers/mtd/nand/s3c2410.c |   57 +++++++++++++++++++++++++++++++------------
 1 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index 33d832d..fbc37dc 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -54,8 +54,14 @@ static int hardware_ecc = 1;
 static int hardware_ecc = 0;
 #endif
 
+#define CLOCK_DISABLE	0
+#define CLOCK_ENABLE	1
+#define CLOCK_SUSPEND	2
+
+static int clock_state = CLOCK_DISABLE;
+
 #ifdef CONFIG_MTD_NAND_S3C2410_CLKSTOP
-static int clock_stop = 1;
+static const int clock_stop = 1;
 #else
 static const int clock_stop = 0;
 #endif
@@ -159,11 +165,33 @@ static struct s3c2410_platform_nand *to_nand_plat(struct platform_device *dev)
 	return dev->dev.platform_data;
 }
 
-static inline int allow_clk_stop(struct s3c2410_nand_info *info)
+static inline int allow_clk_suspend(struct s3c2410_nand_info *info)
 {
 	return clock_stop;
 }
 
+/**
+ * s3c2410_nand_clk_set_state - Enable, disable or suspend NAND clock.
+ * @info: The controller instance.
+ * @new_state: State to which clock should be set.
+ */
+static void s3c2410_nand_clk_set_state(struct s3c2410_nand_info *info,
+		int new_state)
+{
+	if (!allow_clk_suspend(info) && new_state == CLOCK_SUSPEND)
+		return;
+
+	if (clock_state == CLOCK_ENABLE) {
+		if (new_state != CLOCK_ENABLE)
+			clk_disable(info->clk);
+	} else {
+		if (new_state == CLOCK_ENABLE)
+			clk_enable(info->clk);
+	}
+
+	clock_state = new_state;
+}
+
 /* timing calculations */
 
 #define NS_IN_KHZ 1000000
@@ -333,8 +361,8 @@ static void s3c2410_nand_select_chip(struct mtd_info *mtd, int chip)
 	nmtd = this->priv;
 	info = nmtd->info;
 
-	if (chip != -1 && allow_clk_stop(info))
-		clk_enable(info->clk);
+	if (chip != -1)
+		s3c2410_nand_clk_set_state(info, CLOCK_ENABLE);
 
 	cur = readl(info->sel_reg);
 
@@ -356,8 +384,8 @@ static void s3c2410_nand_select_chip(struct mtd_info *mtd, int chip)
 
 	writel(cur, info->sel_reg);
 
-	if (chip == -1 && allow_clk_stop(info))
-		clk_disable(info->clk);
+	if (chip == -1)
+		s3c2410_nand_clk_set_state(info, CLOCK_SUSPEND);
 }
 
 /* s3c2410_nand_hwcontrol
@@ -694,8 +722,7 @@ static int s3c24xx_nand_remove(struct platform_device *pdev)
 	/* free the common resources */
 
 	if (info->clk != NULL && !IS_ERR(info->clk)) {
-		if (!allow_clk_stop(info))
-			clk_disable(info->clk);
+		s3c2410_nand_clk_set_state(info, CLOCK_DISABLE);
 		clk_put(info->clk);
 	}
 
@@ -947,7 +974,7 @@ static int s3c24xx_nand_probe(struct platform_device *pdev)
 		goto exit_error;
 	}
 
-	clk_enable(info->clk);
+	s3c2410_nand_clk_set_state(info, CLOCK_ENABLE);
 
 	/* allocate and map the resource */
 
@@ -1026,9 +1053,9 @@ static int s3c24xx_nand_probe(struct platform_device *pdev)
 		goto exit_error;
 	}
 
-	if (allow_clk_stop(info)) {
+	if (allow_clk_suspend(info)) {
 		dev_info(&pdev->dev, "clock idle support enabled\n");
-		clk_disable(info->clk);
+		s3c2410_nand_clk_set_state(info, CLOCK_SUSPEND);
 	}
 
 	pr_debug("initialised ok\n");
@@ -1059,8 +1086,7 @@ static int s3c24xx_nand_suspend(struct platform_device *dev, pm_message_t pm)
 
 		writel(info->save_sel | info->sel_bit, info->sel_reg);
 
-		if (!allow_clk_stop(info))
-			clk_disable(info->clk);
+		s3c2410_nand_clk_set_state(info, CLOCK_DISABLE);
 	}
 
 	return 0;
@@ -1072,7 +1098,7 @@ static int s3c24xx_nand_resume(struct platform_device *dev)
 	unsigned long sel;
 
 	if (info) {
-		clk_enable(info->clk);
+		s3c2410_nand_clk_set_state(info, CLOCK_ENABLE);
 		s3c2410_nand_inithw(info);
 
 		/* Restore the state of the nFCE line. */
@@ -1082,8 +1108,7 @@ static int s3c24xx_nand_resume(struct platform_device *dev)
 		sel |= info->save_sel & info->sel_bit;
 		writel(sel, info->sel_reg);
 
-		if (allow_clk_stop(info))
-			clk_disable(info->clk);
+		s3c2410_nand_clk_set_state(info, CLOCK_SUSPEND);
 	}
 
 	return 0;
-- 
1.7.4.4


--------------040301050000000004070907--
