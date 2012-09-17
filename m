Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab2IQU3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:29:51 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:48355 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752060Ab2IQU3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:29:50 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1//eyaDO+VZnlz3EPdXp832
Date: Mon, 17 Sep 2012 13:29:44 -0700
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Walmsley <paul@pwsan.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH] mfd: Fix compile for twl-core.c by removing cpu_is_omap
 usage
Message-ID: <20120917202943.GV4521@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7d7e1eba (ARM: OMAP2+: Prepare for irqs.h removal) broke
compile for non-omap as include plat/cpu.h was added:

drivers/mfd/twl-core.c:49:22: fatal error: plat/cpu.h: No such file or directory

This header was indirectly included earlier when SPARSE_IRQ was not
set, but does not exist on most platforms.

Fix the problem by removing the cpu_is_omap usage that should
not exist in drivers at all. We can do this by adding proper
clock aliases for the twl-core.c drivers, and drop separate
handling for cases when clock framework is not available as
the behaviour will stay the same.

Note that we need to add a platform device to avoid using the
i2c provided names that may be different on various omaps.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>

---

Samuel, I'd like to queue this via arm-soc as that's where I have
the breaking patch is if this patch is OK with you.

--- a/arch/arm/mach-omap2/clock2430_data.c
+++ b/arch/arm/mach-omap2/clock2430_data.c
@@ -1856,6 +1856,7 @@ static struct omap_clk omap2430_clks[] = {
 	CLK(NULL,	"func_32k_ck",	&func_32k_ck,	CK_243X),
 	CLK(NULL,	"secure_32k_ck", &secure_32k_ck, CK_243X),
 	CLK(NULL,	"osc_ck",	&osc_ck,	CK_243X),
+	CLK("twl",	"fck",		&osc_ck,	CK_243X),
 	CLK(NULL,	"sys_ck",	&sys_ck,	CK_243X),
 	CLK(NULL,	"alt_ck",	&alt_ck,	CK_243X),
 	CLK(NULL,	"mcbsp_clks",	&mcbsp_clks,	CK_243X),
--- a/arch/arm/mach-omap2/clock3xxx_data.c
+++ b/arch/arm/mach-omap2/clock3xxx_data.c
@@ -3226,6 +3226,7 @@ static struct omap_clk omap3xxx_clks[] = {
 	CLK(NULL,	"virt_26000000_ck",	&virt_26000000_ck,	CK_3XXX),
 	CLK(NULL,	"virt_38_4m_ck", &virt_38_4m_ck, CK_3XXX),
 	CLK(NULL,	"osc_sys_ck",	&osc_sys_ck,	CK_3XXX),
+	CLK("twl",	"fck",		&osc_sys_ck,	CK_3XXX),
 	CLK(NULL,	"sys_ck",	&sys_ck,	CK_3XXX),
 	CLK(NULL,	"sys_altclk",	&sys_altclk,	CK_3XXX),
 	CLK(NULL,	"mcbsp_clks",	&mcbsp_clks,	CK_3XXX),
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -46,8 +46,6 @@
 #include <linux/i2c.h>
 #include <linux/i2c/twl.h>
 
-#include <plat/cpu.h>
-
 #include "twl-core.h"
 
 /*
@@ -1134,12 +1132,7 @@ static void clocks_init(struct device *dev,
 	u32 rate;
 	u8 ctrl = HFCLK_FREQ_26_MHZ;
 
-#if defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3)
-	if (cpu_is_omap2430())
-		osc = clk_get(dev, "osc_ck");
-	else
-		osc = clk_get(dev, "osc_sys_ck");
-
+	osc = clk_get(dev, "fck");
 	if (IS_ERR(osc)) {
 		printk(KERN_WARNING "Skipping twl internal clock init and "
 				"using bootloader value (unknown osc rate)\n");
@@ -1149,18 +1142,6 @@ static void clocks_init(struct device *dev,
 	rate = clk_get_rate(osc);
 	clk_put(osc);
 
-#else
-	/* REVISIT for non-OMAP systems, pass the clock rate from
-	 * board init code, using platform_data.
-	 */
-	osc = ERR_PTR(-EIO);
-
-	printk(KERN_WARNING "Skipping twl internal clock init and "
-	       "using bootloader value (unknown osc rate)\n");
-
-	return;
-#endif
-
 	switch (rate) {
 	case 19200000:
 		ctrl = HFCLK_FREQ_19p2_MHZ;
@@ -1222,10 +1203,23 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	struct twl4030_platform_data	*pdata = client->dev.platform_data;
 	struct device_node		*node = client->dev.of_node;
+	struct platform_device		*pdev;
 	int				irq_base = 0;
 	int				status;
 	unsigned			i, num_slaves;
 
+	pdev = platform_device_alloc(DRIVER_NAME, -1);
+	if (!pdev) {
+		dev_err(&client->dev, "can't alloc pdev\n");
+		return -ENOMEM;
+	}
+
+	status = platform_device_add(pdev);
+	if (status) {
+		platform_device_put(pdev);
+		return status;
+	}
+
 	if (node && !pdata) {
 		/*
 		 * XXX: Temporary pdata until the information is correctly
@@ -1234,23 +1228,30 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		pdata = devm_kzalloc(&client->dev,
 				     sizeof(struct twl4030_platform_data),
 				     GFP_KERNEL);
-		if (!pdata)
-			return -ENOMEM;
+		if (!pdata) {
+			status = -ENOMEM;
+			goto free;
+		}
 	}
 
 	if (!pdata) {
 		dev_dbg(&client->dev, "no platform data?\n");
-		return -EINVAL;
+		status = -EINVAL;
+		goto free;
 	}
 
+	platform_set_drvdata(pdev, pdata);
+
 	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C) == 0) {
 		dev_dbg(&client->dev, "can't talk I2C?\n");
-		return -EIO;
+		status = -EIO;
+		goto free;
 	}
 
 	if (inuse) {
 		dev_dbg(&client->dev, "driver is already in use\n");
-		return -EBUSY;
+		status = -EBUSY;
+		goto free;
 	}
 
 	if ((id->driver_data) & TWL6030_CLASS) {
@@ -1285,7 +1286,7 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	inuse = true;
 
 	/* setup clock framework */
-	clocks_init(&client->dev, pdata->clock);
+	clocks_init(&pdev->dev, pdata->clock);
 
 	/* read TWL IDCODE Register */
 	if (twl_id == TWL4030_CLASS_ID) {
@@ -1335,6 +1336,9 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 fail:
 	if (status < 0)
 		twl_remove(client);
+free:
+	if (status < 0)
+		platform_device_unregister(pdev);
 
 	return status;
 }
