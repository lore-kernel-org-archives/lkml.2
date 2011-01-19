Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab1ASMHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 07:07:37 -0500
Received: from smtp.nokia.com ([147.243.1.48]:43202 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005Ab1ASMHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 07:07:35 -0500
From: tapio.vihuri@nokia.com
To: dmitry.torokhov@gmail.com, peter.ujfalusi@nokia.com
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, ilkka.koskinen@nokia.com,
        samu.p.onkalo@nokia.com
Subject: [PATCH v4 3/3] ECI: adding platform data for ECI driver
Date: Wed, 19 Jan 2011 14:06:56 +0200
Message-Id: <1295438816-27937-4-git-send-email-tapio.vihuri@nokia.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1295438816-27937-3-git-send-email-tapio.vihuri@nokia.com>
References: <1295438816-27937-1-git-send-email-tapio.vihuri@nokia.com>
 <1295438816-27937-2-git-send-email-tapio.vihuri@nokia.com>
 <1295438816-27937-3-git-send-email-tapio.vihuri@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tapio Vihuri <tapio.vihuri@nokia.com>

Gives platform data for ECI accessory input driver and
ECI controller driver.

Signed-off-by: Tapio Vihuri <tapio.vihuri@nokia.com>
---
 arch/x86/platform/mrst/mrst.c |   49 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index ea6529e..ac2533f 100644
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
 
@@ -807,3 +819,40 @@ static int __init pb_keys_init(void)
 	return 0;
 }
 late_initcall(pb_keys_init);
+
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
-- 
1.6.5

