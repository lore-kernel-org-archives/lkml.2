Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab3ABMXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 07:23:24 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:41006 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752134Ab3ABMXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 07:23:22 -0500
Date: Wed, 2 Jan 2013 13:23:19 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: [GIT PULL REQUEST] watchdog - v3.8-rc1 Fixes
Message-ID: <20130102122319.GA10667@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

It fixes some small errors in the new da9055 driver, eliminates a compiler warning
and adds DT support for the twl4030_wdt driver (so that we can have multiple watchdogs
with DT on the omap platforms).

This will update the following files:

 Documentation/devicetree/bindings/watchdog/twl4030-wdt.txt |   10 +++++++
 arch/arm/boot/dts/twl4030.dtsi                             |    4 +++
 drivers/watchdog/da9055_wdt.c                              |   17 ++++---------
 drivers/watchdog/omap_wdt.c                                |    1 
 drivers/watchdog/twl4030_wdt.c                             |   11 ++++++--
 5 files changed, 29 insertions(+), 14 deletions(-)

with these Changes:

commit 8899b8d93ec64b7a8e54807a68a958e1206535e2
Author: Aaro Koskinen <aaro.koskinen@iki.fi>
Date:   Sun Dec 23 22:03:37 2012 +0200

    watchdog: twl4030_wdt: add DT support
    
    Add DT support for twl4030_wdt. This is needed to get twl4030_wdt to
    probe when booting with DT.
    
    Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 412b3729dd0234771c67452b8999191f1e8d8630
Author: Aaro Koskinen <aaro.koskinen@iki.fi>
Date:   Sun Dec 23 22:03:36 2012 +0200

    watchdog: omap_wdt: eliminate unused variable and a compiler warning
    
    We forgot to delete this in the commit 4f4753d9 (watchdog: omap_wdt:
    convert to devm_ functions), and as a result the following compilation
    warning was introduced:
    
    drivers/watchdog/omap_wdt.c: In function 'omap_wdt_remove':
    drivers/watchdog/omap_wdt.c:299:19: warning: unused variable 'res' [-Wunused-variable]
    
    Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
    Reviewed-by: Paul Walmsley <paul@pwsan.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 98e4a293895dda2b74476ac3a9f79c58b5d0155a
Author: Axel Lin <axel.lin@ingics.com>
Date:   Sat Dec 22 11:07:01 2012 +0800

    watchdog: da9055: Don't update wdt_dev->timeout in da9055_wdt_set_timeout error path
    
    Otherwise, WDIOC_GETTIMEOUT returns wrong value if set_timeout fails.
    This patch also removes unnecessary ret variable in da9055_wdt_ping function.
    
    Signed-off-by: Axel Lin <axel.lin@ingics.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit ee8c94adff9bd8609e70fb2ecdfaa71f561ed40d
Author: Axel Lin <axel.lin@ingics.com>
Date:   Fri Dec 21 21:09:06 2012 +0800

    watchdog: da9055: Fix invalid free of devm_ allocated data
    
    It is not required to free devm_ allocated data. Since kref_put
    needs a valid release function, da9055_wdt_release_resources()
    is not deleted.
    
    Signed-off-by: Axel Lin <axel.lin@ingics.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/devicetree/bindings/watchdog/twl4030-wdt.txt b/Documentation/devicetree/bindings/watchdog/twl4030-wdt.txt
new file mode 100644
index 0000000..80a3719
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/twl4030-wdt.txt
@@ -0,0 +1,10 @@
+Device tree bindings for twl4030-wdt driver (TWL4030 watchdog)
+
+Required properties:
+	compatible = "ti,twl4030-wdt";
+
+Example:
+
+watchdog {
+	compatible = "ti,twl4030-wdt";
+};
diff --git a/arch/arm/boot/dts/twl4030.dtsi b/arch/arm/boot/dts/twl4030.dtsi
index 63411b0..ed0bc95 100644
--- a/arch/arm/boot/dts/twl4030.dtsi
+++ b/arch/arm/boot/dts/twl4030.dtsi
@@ -19,6 +19,10 @@
 		interrupts = <11>;
 	};
 
+	watchdog {
+		compatible = "ti,twl4030-wdt";
+	};
+
 	vdac: regulator-vdac {
 		compatible = "ti,twl4030-vdac";
 		regulator-min-microvolt = <1800000>;
diff --git a/drivers/watchdog/da9055_wdt.c b/drivers/watchdog/da9055_wdt.c
index 709ea1a..f5ad105 100644
--- a/drivers/watchdog/da9055_wdt.c
+++ b/drivers/watchdog/da9055_wdt.c
@@ -72,20 +72,21 @@ static int da9055_wdt_set_timeout(struct watchdog_device *wdt_dev,
 					DA9055_TWDSCALE_MASK,
 					da9055_wdt_maps[i].reg_val <<
 					DA9055_TWDSCALE_SHIFT);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(da9055->dev,
 			"Failed to update timescale bit, %d\n", ret);
+		return ret;
+	}
 
 	wdt_dev->timeout = timeout;
 
-	return ret;
+	return 0;
 }
 
 static int da9055_wdt_ping(struct watchdog_device *wdt_dev)
 {
 	struct da9055_wdt_data *driver_data = watchdog_get_drvdata(wdt_dev);
 	struct da9055 *da9055 = driver_data->da9055;
-	int ret;
 
 	/*
 	 * We have a minimum time for watchdog window called TWDMIN. A write
@@ -94,18 +95,12 @@ static int da9055_wdt_ping(struct watchdog_device *wdt_dev)
 	mdelay(DA9055_TWDMIN);
 
 	/* Reset the watchdog timer */
-	ret = da9055_reg_update(da9055, DA9055_REG_CONTROL_E,
-				DA9055_WATCHDOG_MASK, 1);
-
-	return ret;
+	return da9055_reg_update(da9055, DA9055_REG_CONTROL_E,
+				 DA9055_WATCHDOG_MASK, 1);
 }
 
 static void da9055_wdt_release_resources(struct kref *r)
 {
-	struct da9055_wdt_data *driver_data =
-		container_of(r, struct da9055_wdt_data, kref);
-
-	kfree(driver_data);
 }
 
 static void da9055_wdt_ref(struct watchdog_device *wdt_dev)
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 34ed61e..b0e541d 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -296,7 +296,6 @@ static int omap_wdt_remove(struct platform_device *pdev)
 {
 	struct watchdog_device *wdog = platform_get_drvdata(pdev);
 	struct omap_wdt_dev *wdev = watchdog_get_drvdata(wdog);
-	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	pm_runtime_disable(wdev->dev);
 	watchdog_unregister_device(wdog);
diff --git a/drivers/watchdog/twl4030_wdt.c b/drivers/watchdog/twl4030_wdt.c
index 81918cf..0f03106 100644
--- a/drivers/watchdog/twl4030_wdt.c
+++ b/drivers/watchdog/twl4030_wdt.c
@@ -131,14 +131,21 @@ static int twl4030_wdt_resume(struct platform_device *pdev)
 #define twl4030_wdt_resume         NULL
 #endif
 
+static const struct of_device_id twl_wdt_of_match[] = {
+	{ .compatible = "ti,twl4030-wdt", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, twl_wdt_of_match);
+
 static struct platform_driver twl4030_wdt_driver = {
 	.probe		= twl4030_wdt_probe,
 	.remove		= twl4030_wdt_remove,
 	.suspend	= twl4030_wdt_suspend,
 	.resume		= twl4030_wdt_resume,
 	.driver		= {
-		.owner	= THIS_MODULE,
-		.name	= "twl4030_wdt",
+		.owner		= THIS_MODULE,
+		.name		= "twl4030_wdt",
+		.of_match_table	= twl_wdt_of_match,
 	},
 };
 
