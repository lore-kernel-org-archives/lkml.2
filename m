Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2GPTVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 15:21:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62138 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab2GPTVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 15:21:43 -0400
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Paul Walmsley <paul@pwsan.com>
Cc: Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Kevin Hilman <khilman@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.luna@linaro.org>
Subject: [PATCH 3/3] ARM: OMAP: omap_device: expose hwmod assert/deassert to omap devices
Date: Mon, 16 Jul 2012 14:21:25 -0500
Message-Id: <1342466485-1050-4-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1342466485-1050-1-git-send-email-omar.luna@linaro.org>
References: <1342466485-1050-1-git-send-email-omar.luna@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This APIs are meant to be an interface to hwmod assert/deassert
function, omap devices can call them through their platform data
to control their reset lines, they are expected to know the name
of the reset line they are trying to control.

Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
---
 arch/arm/plat-omap/include/plat/omap_device.h |    4 ++
 arch/arm/plat-omap/omap_device.c              |   45 +++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/omap_device.h b/arch/arm/plat-omap/include/plat/omap_device.h
index 4327b2c..27bcc24 100644
--- a/arch/arm/plat-omap/include/plat/omap_device.h
+++ b/arch/arm/plat-omap/include/plat/omap_device.h
@@ -118,6 +118,10 @@ int omap_device_get_context_loss_count(struct platform_device *pdev);
 
 /* Other */
 
+int omap_device_assert_hardreset(struct platform_device *pdev,
+				 const char *name);
+int omap_device_deassert_hardreset(struct platform_device *pdev,
+				 const char *name);
 int omap_device_idle_hwmods(struct omap_device *od);
 int omap_device_enable_hwmods(struct omap_device *od);
 
diff --git a/arch/arm/plat-omap/omap_device.c b/arch/arm/plat-omap/omap_device.c
index c490240..8883074 100644
--- a/arch/arm/plat-omap/omap_device.c
+++ b/arch/arm/plat-omap/omap_device.c
@@ -925,6 +925,51 @@ int omap_device_shutdown(struct platform_device *pdev)
 }
 
 /**
+ * omap_device_assert_hardreset - set a device's reset line
+ * @pdev: struct platform_device * to reset
+ * @name: const char * with the name of the reset line
+ *
+ * According to @name, set the reset line of the hwmods associated
+ * with this @pdev deivce.
+ */
+int omap_device_assert_hardreset(struct platform_device *pdev, const char *name)
+{
+	int i, ret = 0;
+	struct omap_device *od = to_omap_device(pdev);
+
+	for (i = 0; i < od->hwmods_cnt; i++) {
+		ret = omap_hwmod_assert_hardreset(od->hwmods[i], name);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+/**
+ * omap_device_deassert_hardreset - lift a device's reset line
+ * @pdev: struct platform_device * to reset
+ * @name: const char * with the name of the reset line
+ *
+ * According to @name, lift the reset line of the hwmods associated
+ * with this @pdev deivce.
+ */
+int omap_device_deassert_hardreset(struct platform_device *pdev,
+				const char *name)
+{
+	int i, ret = 0;
+	struct omap_device *od = to_omap_device(pdev);
+
+	for (i = 0; i < od->hwmods_cnt; i++) {
+		ret = omap_hwmod_deassert_hardreset(od->hwmods[i], name);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+/**
  * omap_device_align_pm_lat - activate/deactivate device to match wakeup lat lim
  * @od: struct omap_device *
  *
-- 
1.7.4.1

