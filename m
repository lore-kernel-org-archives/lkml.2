Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab1GDLKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 07:10:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60944 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258Ab1GDLKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 07:10:18 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: paul@pwsan.com, b-cousson@ti.com, vishwanath.bs@ti.com, p-basak2@ti.com,
        peter.ujfalusi@ti.com, jhnikula@gmail.com, kishon@ti.com, charu@ti.com
Subject: [PATCH v3 2/2] OMAP: omap_device: API to modify AUTOIDLE and SMARTIDLE bits
Date: Mon, 4 Jul 2011 16:38:33 +0530
Message-ID: <1309777713-17528-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1309777713-17528-1-git-send-email-kishon@ti.com>
References: <1309777713-17528-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide APIs to be used by the driver in order to modify AUTOIDLE
and SIDLE bits. These APIs in turn call hwmod APIs to modify the
SYSCONFIG register.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Benoit Cousson <b-cousson@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/plat-omap/include/plat/omap_device.h |    6 +
 arch/arm/plat-omap/omap_device.c              |  165 +++++++++++++++++++++++++
 2 files changed, 171 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/omap_device.h b/arch/arm/plat-omap/include/plat/omap_device.h
index e4c349f..47ad0ab 100644
--- a/arch/arm/plat-omap/include/plat/omap_device.h
+++ b/arch/arm/plat-omap/include/plat/omap_device.h
@@ -110,6 +110,12 @@ struct powerdomain *omap_device_get_pwrdm(struct omap_device *od);
 u32 omap_device_get_context_loss_count(struct platform_device *pdev);
 
 /* Other */
+int omap_device_noidle(struct omap_device *od);
+int omap_device_smartidle(struct omap_device *od);
+int omap_device_forceidle(struct omap_device *od);
+int omap_device_default_idle(struct omap_device *od);
+int omap_device_enable_autoidle(struct omap_device *od);
+int omap_device_disable_autoidle(struct omap_device *od);
 
 int omap_device_idle_hwmods(struct omap_device *od);
 int omap_device_enable_hwmods(struct omap_device *od);
diff --git a/arch/arm/plat-omap/omap_device.c b/arch/arm/plat-omap/omap_device.c
index 9bbda9a..6df413d 100644
--- a/arch/arm/plat-omap/omap_device.c
+++ b/arch/arm/plat-omap/omap_device.c
@@ -742,6 +742,171 @@ void __iomem *omap_device_get_rt_va(struct omap_device *od)
 	return omap_hwmod_get_mpu_rt_va(od->hwmods[0]);
 }
 
+/**
+ * omap_device_noidle - set the device's slave idlemode to no idle
+ * @od: struct omap_device *
+ *
+ * Sets the IP block's OCP slave idlemode in hardware to no idle.
+ * Intended to be used by drivers that have some erratum that requires direct
+ * manipulation of the SIDLEMODE bits.  Returns -EINVAL if @od is in invalid
+ * state, or passes along the return value from
+ * omap_hwmod_noidle().
+ */
+int omap_device_noidle(struct omap_device *od)
+{
+	int retval = 0, i;
+
+	if (od->_state != OMAP_DEVICE_STATE_ENABLED) {
+		WARN(1, "omap_device: %s.%d: %s() called from invalid state "
+			"%d\n", od->pdev.name, od->pdev.id, __func__,
+			od->_state);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < od->hwmods_cnt; i++)
+		retval |= omap_hwmod_noidle(od->hwmods[i]);
+
+	return retval;
+}
+
+
+/**
+ * omap_device_smartidle - set the device's slave idlemode to smart idle
+ * @od: struct omap_device *
+ *
+ * Sets the IP block's OCP slave idlemode in hardware to smart idle.
+ * Intended to be used by drivers that have some erratum that requires direct
+ * manipulation of the SIDLEMODE bits.  Returns -EINVAL if @od is in invalid
+ * state, or passes along the return value from
+ * omap_hwmod_smartidle().
+ */
+int omap_device_smartidle(struct omap_device *od)
+{
+	int retval = 0, i;
+
+	if (od->_state != OMAP_DEVICE_STATE_ENABLED) {
+		WARN(1, "omap_device: %s.%d: %s() called from invalid state "
+			"%d\n", od->pdev.name, od->pdev.id, __func__,
+			od->_state);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < od->hwmods_cnt; i++)
+		retval |= omap_hwmod_smartidle(od->hwmods[i]);
+
+	return retval;
+}
+
+
+/**
+ * omap_device_forceidle - set the device's slave idlemode to force idle
+ * @od: struct omap_device *
+ *
+ * Sets the IP block's OCP slave idlemode in hardware to force idle.
+ * Intended to be used by drivers that have some erratum that requires direct
+ * manipulation of the SIDLEMODE bits.  Returns -EINVAL if @od is in invalid
+ * state, or passes along the return value from
+ * omap_hwmod_forceidle().
+ */
+int omap_device_forceidle(struct omap_device *od)
+{
+	int retval = 0, i;
+
+	if (od->_state != OMAP_DEVICE_STATE_ENABLED) {
+		WARN(1, "omap_device: %s.%d: %s() called from invalid state "
+			"%d\n", od->pdev.name, od->pdev.id, __func__,
+			od->_state);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < od->hwmods_cnt; i++)
+		retval |= omap_hwmod_forceidle(od->hwmods[i]);
+
+	return retval;
+}
+
+/**
+ * omap_device_default_idle - set the device's slave idlemode to no idle or
+ * smart idle
+ * @od: struct omap_device *
+ *
+ * Sets the IP block's OCP slave idlemode in hardware to no idle or smart idle
+ * Intended to be used by drivers that have some erratum that requires direct
+ * manipulation of the SIDLEMODE bits.  Returns -EINVAL if @od is in invalid
+ * state, or passes along the return value from
+ * omap_hwmod_default_idle().
+ */
+int omap_device_default_idle(struct omap_device *od)
+{
+	int retval = 0, i;
+
+	if (od->_state != OMAP_DEVICE_STATE_ENABLED) {
+		WARN(1, "omap_device: %s.%d: %s() called from invalid state "
+			"%d\n", od->pdev.name, od->pdev.id, __func__,
+		od->_state);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < od->hwmods_cnt; i++)
+		retval |= omap_hwmod_default_idle(od->hwmods[i]);
+
+	return retval;
+}
+
+/*
+ * omap_device_enable_autoidle - enable the device's OCP slave autoidle
+ * @od: struct omap_device *
+ *
+ * Sets the IP block's OCP slave autoidle in hardware.
+ * Intended to be used by drivers that have some erratum that requires direct
+ * manipulation of the AUTOIDLE bits.  Returns -EINVAL if @od is in invalid
+ * state, or passes along the return value from
+ * omap_hwmod_set_ocp_autoidle().
+ */
+int omap_device_enable_autoidle(struct omap_device *od)
+{
+	int retval = 0, i;
+
+	if (od->_state != OMAP_DEVICE_STATE_ENABLED) {
+		WARN(1, "omap_device: %s.%d: %s() called from invalid state "
+			"%d\n", od->pdev.name, od->pdev.id, __func__,
+			od->_state);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < od->hwmods_cnt; i++)
+		retval |= omap_hwmod_enable_autoidle(od->hwmods[i]);
+
+	return retval;
+}
+
+/*
+ * omap_device_disable_autoidle - disable the device's OCP slave autoidle
+ * @od: struct omap_device *
+ *
+ * Disables the IP block's OCP slave autoidle in hardware.
+ * Intended to be used by drivers that have some erratum that requires direct
+ * manipulation of the AUTOIDLE bits.  Returns -EINVAL if @od is in invalid
+ * state, or passes along the return value from
+ * omap_hwmod_set_ocp_autoidle().
+ */
+int omap_device_disable_autoidle(struct omap_device *od)
+{
+	int retval = 0, i;
+
+	if (od->_state != OMAP_DEVICE_STATE_ENABLED) {
+		WARN(1, "omap_device: %s.%d: %s() called from invalid state "
+			"%d\n", od->pdev.name, od->pdev.id, __func__,
+			od->_state);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < od->hwmods_cnt; i++)
+		retval |= omap_hwmod_disable_autoidle(od->hwmods[i]);
+
+	return retval;
+}
+
 /*
  * Public functions intended for use in omap_device_pm_latency
  * .activate_func and .deactivate_func function pointers
-- 
1.7.0.4

