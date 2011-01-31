Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab1AaOEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:04:09 -0500
Received: from smtp.nokia.com ([147.243.1.48]:28870 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755493Ab1AaOEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:04:07 -0500
From: tapio.vihuri@nokia.com
To: dmitry.torokhov@gmail.com
Cc: peter.ujfalusi@nokia.com, randy.dunlap@oracle.com,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        ilkka.koskinen@nokia.com, samu.p.onkalo@nokia.com
Subject: [PATCH v6 3/3] ECI: adding platform data for ECI driver
Date: Mon, 31 Jan 2011 16:03:54 +0200
Message-Id: <1296482634-31666-4-git-send-email-tapio.vihuri@nokia.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1296482634-31666-3-git-send-email-tapio.vihuri@nokia.com>
References: <1296482634-31666-1-git-send-email-tapio.vihuri@nokia.com>
 <1296482634-31666-2-git-send-email-tapio.vihuri@nokia.com>
 <1296482634-31666-3-git-send-email-tapio.vihuri@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tapio Vihuri <tapio.vihuri@nokia.com>

Gives platform data for ECI accessory input driver and
ECI controller driver.

Signed-off-by: Tapio Vihuri <tapio.vihuri@nokia.com>
---
 arch/x86/platform/mrst/mrst.c |   48 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index ea6529e..8189029 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -24,6 +24,7 @@
 #include <linux/platform_device.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/input/eci.h>
 
 #include <asm/setup.h>
 #include <asm/mpspec_def.h>
@@ -478,6 +479,16 @@ static void __init *no_platform_data(void *info)
 	return NULL;
 }
 
+static void *eci_ctrl_platform_data_init(void *info)
+{
+	static struct eci_ctrl_platform_data mrst_eci_ctrl_data = {
+		.eci_ctrl_rst_gpio = GPIO_ECI_RSTn,
+		.eci_ctrl_sw_ctrl_gpio = GPIO_ECI_SW_CTRL,
+		.eci_ctrl_int_gpio = GPIO_ECI_INT,
+	};
+	return &mrst_eci_ctrl_data;
+}
+
 static const struct devs_id __initconst device_ids[] = {
 	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data},
 	{"spi_max3111", SFI_DEV_TYPE_SPI, 0, &max3111_platform_data},
@@ -487,6 +498,7 @@ static const struct devs_id __initconst device_ids[] = {
 	{"i2c_accel", SFI_DEV_TYPE_I2C, 0, &lis331dl_platform_data},
 	{"pmic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data},
 	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data},
+	{"eci_ctrl", SFI_DEV_TYPE_I2C, 0, &eci_ctrl_platform_data_init},
 	{},
 };
 
@@ -659,6 +671,42 @@ static void __init sfi_handle_i2c_dev(int bus, struct i2c_board_info *i2c_info)
 		i2c_register_board_info(bus, i2c_info, 1);
  }
 
+/*
+ * This is just example, should be used in platform audio driver
+ * hsmic_event->event(hsmic_event->private, true)
+ */
+static void mrst_register_hsmic_event_cb(struct audio_hsmic_event *event)
+{
+	struct audio_hsmic_event *hsmic_event;
+
+	hsmic_event = event;
+}
+
+static struct eci_platform_data mrst_eci_data = {
+	.register_hsmic_event_cb	= mrst_register_hsmic_event_cb,
+};
+
+static struct platform_device mrst_eci_device = {
+	.name	= "ECI_accessory",
+	.dev	= {
+		.platform_data = &mrst_eci_data,
+	},
+};
+
+static int __init mrst_eci_init(void)
+{
+	int retval;
+
+	retval = platform_device_register(&mrst_eci_device);
+	if (retval < 0)
+		return retval;
+
+	/* Turn on vprog2 */
+	intel_scu_ipc_iowrite8(AvP_MSIC_VPROG2, AvP_MSIC_VPROG2_2V5_ON);
+
+	return retval;
+}
+device_initcall(mrst_eci_init);
 
 static int __init sfi_parse_devs(struct sfi_table_header *table)
 {
-- 
1.6.5

