Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536Ab0JAMAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:00:16 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:36444 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932243Ab0JAMAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 08:00:08 -0400
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Viresh Kumar <viresh.kumar@st.com>, shiraz.hashim@st.com,
        vipin.kumar@st.com, deepak.sikri@st.com, armando.visconti@st.com,
        vipulkumar.samar@st.com, rajeev-dlh.kumar@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com
Subject: [PATCH V2 66/69] ST SPEAr13xx: Pass default padmux settings as parameter to spear13**_init routine
Date: Fri,  1 Oct 2010 17:26:26 +0530
Message-Id: <8f1014d21b888fac4aea1778c1032e5d02079329.1285933332.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes pmx_driver static to spear1300.c and spear1310.c, also now
default setting of padmux are sent to spear1300_init and spear1310_init routines

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/mach-spear13xx/include/mach/generic.h |    8 ++++----
 arch/arm/mach-spear13xx/spear1300.c            |    9 +++++++--
 arch/arm/mach-spear13xx/spear1300_evb.c        |    7 +------
 arch/arm/mach-spear13xx/spear1310.c            |    9 +++++++--
 arch/arm/mach-spear13xx/spear1310_evb.c        |    7 +------
 5 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/arm/mach-spear13xx/include/mach/generic.h b/arch/arm/mach-spear13xx/include/mach/generic.h
index f619b70..e005936 100644
--- a/arch/arm/mach-spear13xx/include/mach/generic.h
+++ b/arch/arm/mach-spear13xx/include/mach/generic.h
@@ -220,8 +220,6 @@ extern struct pmx_dev pmx_uart1_modem;
 #define SPEAR_GPT0_CHAN0_IRQ	IRQ_GPT0_TMR0
 #define SPEAR_GPT0_CHAN1_IRQ	IRQ_GPT0_TMR1
 
-extern struct pmx_driver pmx_driver;
-
 /* Add spear13xx family device structure declarations here */
 extern struct amba_device spear13xx_gpio_device[];
 extern struct amba_device spear13xx_ssp_device;
@@ -255,7 +253,8 @@ void spear13xx_secondary_startup(void);
 /* spear1300 declarations */
 #ifdef CONFIG_MACH_SPEAR1300
 /* Add spear1300 machine function declarations here */
-void __init spear1300_init(void);
+void __init spear1300_init(struct pmx_mode *pmx_mode, struct pmx_dev **pmx_devs,
+		u8 pmx_dev_count);
 
 #endif /* CONFIG_MACH_SPEAR1300 */
 
@@ -266,7 +265,8 @@ extern struct platform_device spear1310_can0_device;
 extern struct platform_device spear1310_can1_device;
 
 /* Add spear1310 machine function declarations here */
-void __init spear1310_init(void);
+void __init spear1310_init(struct pmx_mode *pmx_mode, struct pmx_dev **pmx_devs,
+		u8 pmx_dev_count);
 
 #endif /* CONFIG_MACH_SPEAR1310 */
 
diff --git a/arch/arm/mach-spear13xx/spear1300.c b/arch/arm/mach-spear13xx/spear1300.c
index 28822a3..b10f7a0 100644
--- a/arch/arm/mach-spear13xx/spear1300.c
+++ b/arch/arm/mach-spear13xx/spear1300.c
@@ -15,11 +15,12 @@
 #include <mach/spear.h>
 
 /* pmx driver structure */
-struct pmx_driver pmx_driver;
+static struct pmx_driver pmx_driver;
 
 /* Add spear1300 specific devices here */
 
-void __init spear1300_init(void)
+void __init spear1300_init(struct pmx_mode *pmx_mode, struct pmx_dev **pmx_devs,
+		u8 pmx_dev_count)
 {
 	int ret;
 
@@ -27,6 +28,10 @@ void __init spear1300_init(void)
 	spear13xx_init();
 
 	/* pmx initialization */
+	pmx_driver.mode = pmx_mode;
+	pmx_driver.devs = pmx_devs;
+	pmx_driver.devs_count = pmx_dev_count;
+
 	ret = pmx_register(&pmx_driver);
 	if (ret)
 		pr_err("padmux: registeration failed. err no: %d\n", ret);
diff --git a/arch/arm/mach-spear13xx/spear1300_evb.c b/arch/arm/mach-spear13xx/spear1300_evb.c
index ceb3bd0..4c8365b 100644
--- a/arch/arm/mach-spear13xx/spear1300_evb.c
+++ b/arch/arm/mach-spear13xx/spear1300_evb.c
@@ -122,11 +122,6 @@ static void __init spear1300_evb_init(void)
 {
 	unsigned int i;
 
-	/* padmux initialization, must be done before spear1300_init */
-	pmx_driver.mode = NULL;
-	pmx_driver.devs = pmx_devs;
-	pmx_driver.devs_count = ARRAY_SIZE(pmx_devs);
-
 	/* set keyboard plat data */
 	kbd_set_plat_data(&spear13xx_kbd_device, &kbd_data);
 
@@ -136,7 +131,7 @@ static void __init spear1300_evb_init(void)
 	nand_mach_init(FSMC_NAND_BW8);
 
 	/* call spear1300 machine init function */
-	spear1300_init();
+	spear1300_init(NULL, pmx_devs, ARRAY_SIZE(pmx_devs));
 
 	/* Register slave devices on the I2C buses */
 	i2c_register_board_devices();
diff --git a/arch/arm/mach-spear13xx/spear1310.c b/arch/arm/mach-spear13xx/spear1310.c
index 39ea491..375f5b2 100644
--- a/arch/arm/mach-spear13xx/spear1310.c
+++ b/arch/arm/mach-spear13xx/spear1310.c
@@ -17,7 +17,7 @@
 #include <mach/hardware.h>
 
 /* pmx driver structure */
-struct pmx_driver pmx_driver;
+static struct pmx_driver pmx_driver;
 
 /* Pad multiplexing for uart1_modem device */
 static struct pmx_mux_reg pmx_uart1_modem_mux[] = {
@@ -393,7 +393,8 @@ struct platform_device spear1310_can1_device = {
 	.resource = can1_resources,
 };
 
-void __init spear1310_init(void)
+void __init spear1310_init(struct pmx_mode *pmx_mode, struct pmx_dev **pmx_devs,
+		u8 pmx_dev_count)
 {
 	int ret;
 
@@ -401,6 +402,10 @@ void __init spear1310_init(void)
 	spear13xx_init();
 
 	/* pmx initialization */
+	pmx_driver.mode = pmx_mode;
+	pmx_driver.devs = pmx_devs;
+	pmx_driver.devs_count = pmx_dev_count;
+
 	ret = pmx_register(&pmx_driver);
 	if (ret)
 		pr_err("padmux: registeration failed. err no: %d\n", ret);
diff --git a/arch/arm/mach-spear13xx/spear1310_evb.c b/arch/arm/mach-spear13xx/spear1310_evb.c
index c4b83b2..a263b40 100644
--- a/arch/arm/mach-spear13xx/spear1310_evb.c
+++ b/arch/arm/mach-spear13xx/spear1310_evb.c
@@ -133,11 +133,6 @@ static void __init spear1310_evb_init(void)
 {
 	unsigned int i;
 
-	/* padmux initialization, must be done before spear1300_init */
-	pmx_driver.mode = NULL;
-	pmx_driver.devs = pmx_devs;
-	pmx_driver.devs_count = ARRAY_SIZE(pmx_devs);
-
 	/* set keyboard plat data */
 	kbd_set_plat_data(&spear13xx_kbd_device, &kbd_data);
 
@@ -147,7 +142,7 @@ static void __init spear1310_evb_init(void)
 	nand_mach_init(FSMC_NAND_BW8);
 
 	/* call spear1310 machine init function */
-	spear1310_init();
+	spear1310_init(NULL, pmx_devs, ARRAY_SIZE(pmx_devs));
 
 	/* Register slave devices on the I2C buses */
 	i2c_register_board_devices();
-- 
1.7.2.2

