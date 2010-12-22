Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab0LVMVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 07:21:00 -0500
Received: from smtp.nokia.com ([147.243.1.48]:33397 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117Ab0LVMU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 07:20:58 -0500
From: tapio.vihuri@nokia.com
To: dmitry.torokhov@gmail.com
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        ilkka.koskinen@nokia.com, samu.p.onkalo@nokia.com
Subject: [PATCH 3/3] ECI: adding platform data for ECI driver
Date: Wed, 22 Dec 2010 14:20:35 +0200
Message-Id: <1293020435-5680-4-git-send-email-tapio.vihuri@nokia.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1293020435-5680-3-git-send-email-tapio.vihuri@nokia.com>
References: <1293020435-5680-1-git-send-email-tapio.vihuri@nokia.com>
 <1293020435-5680-2-git-send-email-tapio.vihuri@nokia.com>
 <1293020435-5680-3-git-send-email-tapio.vihuri@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tapio Vihuri <tapio.vihuri@nokia.com>

Gives platform data for ECI accessory input driver and
ECI bus controller driver.

Signed-off-by: Tapio Vihuri <tapio.vihuri@nokia.com>
---
 arch/x86/platform/mrst/mrst.c |   59 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 79ae681..60dca78 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -14,6 +14,7 @@
 #include <linux/sfi.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 
 #include <asm/setup.h>
 #include <asm/mpspec_def.h>
@@ -309,3 +310,61 @@ static inline int __init setup_x86_mrst_timer(char *arg)
 	return 0;
 }
 __setup("x86_mrst_timer=", setup_x86_mrst_timer);
+
+#if defined(CONFIG_ECI) || defined(CONFIG_ECI_MODULE)
+#include <linux/input/eci.h>
+
+#define GPIO_ECI_RSTn		126	/* GP_CORE_030 + 96 */
+#define GPIO_ECI_SW_CTRL	178	/* GP_CORE_082 + 96 */
+#define GPIO_ECI_INT		16	/* GP_AON_016 */
+
+static struct ecibus_platform_data medfield_ecibus_control = {
+	.ecibus_rst_gpio = GPIO_ECI_RSTn,
+	.ecibus_sw_ctrl_gpio = GPIO_ECI_SW_CTRL,
+	.ecibus_int_gpio = GPIO_ECI_INT,
+};
+
+/*
+ * This is just example, should be used in platform audio driver
+ * hsmic_event->event(hsmic_event->private, true)
+ */
+static void medfield_register_hsmic_event_cb(struct audio_hsmic_event *event)
+{
+	struct audio_hsmic_event *hsmic_event;
+
+	hsmic_event = event;
+}
+
+static struct eci_platform_data medfield_eci_platform_data = {
+	.register_hsmic_event_cb	= medfield_register_hsmic_event_cb,
+};
+
+static struct platform_device medfield_ecibus_device = {
+	.name	= "ecibus",
+	.id	= 1,
+	.dev	= {
+		.platform_data = &medfield_ecibus_control,
+	},
+};
+
+static struct platform_device medfield_eci_device = {
+	.name	= "ECI_accessory",
+	.dev	= {
+		.platform_data = &medfield_eci_platform_data,
+	},
+};
+
+static int __init medfield_ecibus_init(void)
+{
+	int retval;
+
+	retval = platform_device_register(&medfield_ecibus_device);
+	if (retval < 0)
+		return retval;
+
+	retval = platform_device_register(&medfield_eci_device);
+
+	return retval;
+}
+device_initcall(medfield_ecibus_init);
+#endif
-- 
1.6.5

