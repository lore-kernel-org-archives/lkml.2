Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab1CDWwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 17:52:14 -0500
Received: from mail-vx0-f206.google.com ([209.85.220.206]:38697 "EHLO
	mail-vx0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520Ab1CDWwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 17:52:13 -0500
X-Greylist: delayed 40158 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Mar 2011 17:52:13 EST
MIME-Version: 1.0
Reply-To: dudl@cypress.com, ccross@android.com, konkers@android.com,
        olof@lixom.net, linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        micahc@google.com, chromium-os-reviews@chromium.org, msb@chromium.org,
        olofj@chromium.org, vbendeb+kernel@chromium.org
X-Google-Appengine-App-Id: chromiumcodereview
Message-ID: <20cf3005123492db71049da6a54a@google.com>
Date: Fri, 04 Mar 2011 11:42:54 +0000
Subject: CHROMIUM: arm: tegra: Add platfrom devices for Cypress trackpad (issue6623011)
From: dudl@cypress.com
To: ccross@android.com, konkers@android.com, olof@lixom.net,
        linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        micahc@google.com, dudl@cypress.com
Cc: chromium-os-reviews@chromium.org, msb@chromium.org, olofj@chromium.org,
        vbendeb+kernel@chromium.org
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewers: ccross_android.com, konkers_android.com, olof_lixom.net,  
linux_arm.linux.org.uk, linux-tegra_vger.kernel.org,  
linux-arm-kernel_lists.infradead.org, linux-kernel_vger.kernel.org, Micah  
C, dudl,

Description:
CHROMIUM: arm: tegra: Add platfrom devices for Cypress trackpad

1. Add platfrom data strcuture cyapa_platfrom_data.
2. Add trackpad device into platfrom I2C bus 0.
3. Initialize platfrom data for cyapa_platfrom_data.
4. This code is merged based kernel version 2.7.37-rc5.


Change-Id: I3591317ac9c3b7d5328a9c617d662ad6be6065a2
Signed-off-by: Du, Dudley <dudl@cypress.com>

BUG=None
TEST=Test on arm tegra2 seaborad and kaen platform

Please review this at http://codereview.chromium.org/6623011/

SVN Base: http://git.chromium.org/git/kernel-next.git@chromeos-2.6.37-rc5

Affected files:
   M arch/arm/mach-tegra/board-seaboard.h
   M arch/arm/mach-tegra/board-seaboard.c


Index: arch/arm/mach-tegra/board-seaboard.c
diff --git a/arch/arm/mach-tegra/board-seaboard.c  
b/arch/arm/mach-tegra/board-seaboard.c
index  
75fbab68ef61c0c117bb8dafa2aaca90947a860b..de272cc73794c6600994af3c0e834dd884f6b56b  
100644
--- a/arch/arm/mach-tegra/board-seaboard.c
+++ b/arch/arm/mach-tegra/board-seaboard.c
@@ -303,6 +303,36 @@ static struct tegra_i2c_platform_data  
seaboard_dvc_platform_data = {
  	.is_dvc		= true,
  };

+/* for Cypress Trackpad. */
+#include <linux/cyapa.h>
+
+static int cyapa_i2c_platform_init(void)
+{
+	return 0;
+}
+
+static int cyapa_i2c_platform_wakeup(void)
+{
+	return 0;
+}
+
+static struct cyapa_platform_data cyapa_i2c_platform_data = {
+	.flag = 0,
+	.gen = CYAPA_GEN2,
+	.power_state = CYAPA_PWR_ACTIVE,
+	.use_absolute_mode = false,
+	.use_polling_mode = false,
+	.polling_interval_time_active = CYAPA_ACTIVE_POLLING_INTVAL_TIME,
+	.polling_interval_time_lowpower = CYAPA_LOWPOWER_POLLING_INTVAL_TIME,
+	.active_touch_timeout = CYAPA_ACTIVE_TOUCH_TIMEOUT,
+	.name = CYAPA_I2C_NAME,
+	.irq_gpio = TEGRA_GPIO_CYTP_INT,
+	.report_rate = CYAPA_REPORT_RATE,
+
+	.wakeup = cyapa_i2c_platform_wakeup,
+	.init = cyapa_i2c_platform_init,
+};
+
  static struct i2c_board_info __initdata seaboard_i2c0_devices[] = {
  	{
  		I2C_BOARD_INFO("wm8903", 0x1a),
@@ -311,6 +341,11 @@ static struct i2c_board_info __initdata  
seaboard_i2c0_devices[] = {
  		I2C_BOARD_INFO("isl29018", 0x44),
  		.irq = TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_ISL29018_IRQ),
  	},
+	{
+		I2C_BOARD_INFO(CYAPA_I2C_NAME, 0x67),
+		.irq = TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_CYTP_INT),
+		.platform_data = &cyapa_i2c_platform_data,
+	},
  };

  static struct i2c_board_info __initdata seaboard_i2c4_devices[] = {
@@ -549,6 +584,11 @@ static void __init tegra_seaboard_init(void)

  	tegra_gpio_enable(TEGRA_GPIO_LIDSWITCH);
  	tegra_gpio_enable(TEGRA_GPIO_POWERKEY);
+
+	/* for Cypress trackpad. */
+	tegra_gpio_enable(TEGRA_GPIO_CYTP_INT);
+	gpio_request(TEGRA_GPIO_CYTP_INT, "gpio_cytp_int");
+	gpio_direction_input(TEGRA_GPIO_CYTP_INT);
  }

  MACHINE_START(SEABOARD, "seaboard")
Index: arch/arm/mach-tegra/board-seaboard.h
diff --git a/arch/arm/mach-tegra/board-seaboard.h  
b/arch/arm/mach-tegra/board-seaboard.h
index  
5e1fc48bfa940056f2fd8e4c3bee5124d1398da4..4a38c4163ac338e90433a95afb90ec57a456ed1b  
100644
--- a/arch/arm/mach-tegra/board-seaboard.h
+++ b/arch/arm/mach-tegra/board-seaboard.h
@@ -28,6 +28,9 @@
  #define TEGRA_GPIO_ISL29018_IRQ		TEGRA_GPIO_PZ2
  #define TEGRA_GPIO_AC_ONLINE		TEGRA_GPIO_PV3

+/* for Cypress Trackpad gpio interrupt. */
+#define TEGRA_GPIO_CYTP_INT		TEGRA_GPIO_PW2
+
  void seaboard_pinmux_init(void);
  int seaboard_panel_init(void);
  int seaboard_sdhci_init(void);


