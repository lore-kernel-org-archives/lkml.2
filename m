Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab2DUL6d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 07:58:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45851 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab2DUL6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 07:58:32 -0400
From: Viresh Kumar <viresh.linux@gmail.com>
To: akpm@linux-foundation.org
Cc: spear-devel@list.st.com, viresh.linux@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mturquette@linaro.org, sshtylyov@mvista.com, jgarzik@redhat.com,
        Viresh Kumar <viresh.kumar@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 11/13] usb/host/r8a66597: Remove conditional compilation of clk code
Date: Sat, 21 Apr 2012 17:17:38 +0530
Message-Id: <6966bd9e614697a1525bae6344c66baffbbb3003.1335008617.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1335008617.git.viresh.kumar@st.com>
References: <cover.1335008617.git.viresh.kumar@st.com>
In-Reply-To: <cover.1335008617.git.viresh.kumar@st.com>
References: <cover.1335008617.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With addition of dummy clk_*() calls for non CONFIG_HAVE_CLK cases in clk.h,
there is no need to have clk code enclosed in #ifdef CONFIG_HAVE_CLK, #endif
macros.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/host/r8a66597-hcd.c |   28 +++++++++-------------------
 drivers/usb/host/r8a66597.h     |    5 -----
 2 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/host/r8a66597-hcd.c b/drivers/usb/host/r8a66597-hcd.c
index 2bf1320..6d11553 100644
--- a/drivers/usb/host/r8a66597-hcd.c
+++ b/drivers/usb/host/r8a66597-hcd.c
@@ -95,9 +95,9 @@ static int r8a66597_clock_enable(struct r8a66597 *r8a66597)
 	int i = 0;
 
 	if (r8a66597->pdata->on_chip) {
-#ifdef CONFIG_HAVE_CLK
-		clk_enable(r8a66597->clk);
-#endif
+		if (!IS_ERR(r8a66597->clk))
+			clk_enable(r8a66597->clk);
+
 		do {
 			r8a66597_write(r8a66597, SCKE, SYSCFG0);
 			tmp = r8a66597_read(r8a66597, SYSCFG0);
@@ -141,9 +141,8 @@ static void r8a66597_clock_disable(struct r8a66597 *r8a66597)
 	udelay(1);
 
 	if (r8a66597->pdata->on_chip) {
-#ifdef CONFIG_HAVE_CLK
-		clk_disable(r8a66597->clk);
-#endif
+		if (!IS_ERR(r8a66597->clk))
+			clk_disable(r8a66597->clk);
 	} else {
 		r8a66597_bclr(r8a66597, PLLC, SYSCFG0);
 		r8a66597_bclr(r8a66597, XCKE, SYSCFG0);
@@ -2406,19 +2405,16 @@ static int __devexit r8a66597_remove(struct platform_device *pdev)
 	del_timer_sync(&r8a66597->rh_timer);
 	usb_remove_hcd(hcd);
 	iounmap(r8a66597->reg);
-#ifdef CONFIG_HAVE_CLK
-	if (r8a66597->pdata->on_chip)
+	if (r8a66597->pdata->on_chip && !IS_ERR(r8a66597->clk))
 		clk_put(r8a66597->clk);
-#endif
+
 	usb_put_hcd(hcd);
 	return 0;
 }
 
 static int __devinit r8a66597_probe(struct platform_device *pdev)
 {
-#ifdef CONFIG_HAVE_CLK
 	char clk_name[8];
-#endif
 	struct resource *res = NULL, *ires;
 	int irq = -1;
 	void __iomem *reg = NULL;
@@ -2482,16 +2478,12 @@ static int __devinit r8a66597_probe(struct platform_device *pdev)
 	r8a66597->irq_sense_low = irq_trigger == IRQF_TRIGGER_LOW;
 
 	if (r8a66597->pdata->on_chip) {
-#ifdef CONFIG_HAVE_CLK
 		snprintf(clk_name, sizeof(clk_name), "usb%d", pdev->id);
 		r8a66597->clk = clk_get(&pdev->dev, clk_name);
 		if (IS_ERR(r8a66597->clk)) {
 			dev_err(&pdev->dev, "cannot get clock \"%s\"\n",
 				clk_name);
-			ret = PTR_ERR(r8a66597->clk);
-			goto clean_up2;
 		}
-#endif
 		r8a66597->max_root_hub = 1;
 	} else
 		r8a66597->max_root_hub = 2;
@@ -2531,11 +2523,9 @@ static int __devinit r8a66597_probe(struct platform_device *pdev)
 	return 0;
 
 clean_up3:
-#ifdef CONFIG_HAVE_CLK
-	if (r8a66597->pdata->on_chip)
+	if (r8a66597->pdata->on_chip && !IS_ERR(r8a66597->clk))
 		clk_put(r8a66597->clk);
-clean_up2:
-#endif
+
 	usb_put_hcd(hcd);
 
 clean_up:
diff --git a/drivers/usb/host/r8a66597.h b/drivers/usb/host/r8a66597.h
index f28782d..672cea3 100644
--- a/drivers/usb/host/r8a66597.h
+++ b/drivers/usb/host/r8a66597.h
@@ -26,10 +26,7 @@
 #ifndef __R8A66597_H__
 #define __R8A66597_H__
 
-#ifdef CONFIG_HAVE_CLK
 #include <linux/clk.h>
-#endif
-
 #include <linux/usb/r8a66597.h>
 
 #define R8A66597_MAX_NUM_PIPE		10
@@ -113,9 +110,7 @@ struct r8a66597_root_hub {
 struct r8a66597 {
 	spinlock_t lock;
 	void __iomem *reg;
-#ifdef CONFIG_HAVE_CLK
 	struct clk *clk;
-#endif
 	struct r8a66597_platdata	*pdata;
 	struct r8a66597_device		device0;
 	struct r8a66597_root_hub	root_hub[R8A66597_MAX_ROOT_HUB];
-- 
1.7.9

