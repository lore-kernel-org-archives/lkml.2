Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab1IWMsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 08:48:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52899 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928Ab1IWMsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 08:48:00 -0400
thread-index: Acx57wNqnbcPx0XtTj+CHwuNPGyvwA==
Content-Transfer-Encoding: 8BIT
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4657
From: Tero Kristo <t-kristo@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "R, Govindraj" <govindraj.raja@ti.com>
Subject: [PATCHv9 01/18] OMAP2+: hwmod: Add API to enable IO ring wakeup.
Date: Fri, 23 Sep 2011 15:46:09 +0300
Message-ID: <1316781986-30642-2-git-send-email-t-kristo@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316781986-30642-1-git-send-email-t-kristo@ti.com>
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: R, Govindraj <govindraj.raja@ti.com>

Add API to enable IO pad wakeup capability based on mux dynamic pad and
wake_up enable flag available from hwmod_mux initialization.

Use the wakeup_enable flag and enable wakeup capability
for the given pads. Wakeup capability will be enabled/disabled
during hwmod idle transition based on whether wakeup_flag is
set or cleared.

Map the enable/disable pad wakeup API's to hwmod_wakeup_enable/disable.

Signed-off-by: Govindraj.R <govindraj.raja@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod.c |   59 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 84cc0bd..e751dd9 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -2062,6 +2062,34 @@ static int __init omap_hwmod_setup_all(void)
 core_initcall(omap_hwmod_setup_all);
 
 /**
+ * omap_hwmod_set_ioring_wakeup - enable io pad wakeup flag.
+ * @oh: struct omap_hwmod *
+ * @set: bool value indicating to set or clear wakeup status.
+ *
+ * Set or Clear wakeup flag for the io_pad.
+ */
+static int omap_hwmod_set_ioring_wakeup(struct omap_hwmod *oh, bool set_wake)
+{
+	struct omap_device_pad *pad;
+	int ret = -EINVAL, j;
+
+	if (oh->mux && oh->mux->enabled) {
+		for (j = 0; j < oh->mux->nr_pads_dynamic; j++) {
+			pad = oh->mux->pads_dynamic[j];
+			if (pad->flags & OMAP_DEVICE_PAD_WAKEUP) {
+				if (set_wake)
+					pad->idle |= OMAP_WAKEUP_EN;
+				else
+					pad->idle &= ~OMAP_WAKEUP_EN;
+				ret = 0;
+			}
+		}
+	}
+
+	return ret;
+}
+
+/**
  * omap_hwmod_enable - enable an omap_hwmod
  * @oh: struct omap_hwmod *
  *
@@ -2393,6 +2421,35 @@ int omap_hwmod_del_initiator_dep(struct omap_hwmod *oh,
 {
 	return _del_initiator_dep(oh, init_oh);
 }
+/**
+ * omap_hwmod_enable_ioring_wakeup - Set wakeup flag for iopad.
+ * @oh: struct omap_hwmod *
+ *
+ * Traverse through dynamic pads, if pad is enabled then
+ * set wakeup enable bit flag for the mux pin. Wakeup pad bit
+ * will be set during hwmod idle transistion.
+ * Return error if pads are not enabled or not available.
+ */
+int omap_hwmod_enable_ioring_wakeup(struct omap_hwmod *oh)
+{
+	/* Enable pad wake-up capability */
+	return omap_hwmod_set_ioring_wakeup(oh, true);
+}
+
+/**
+ * omap_hwmod_disable_ioring_wakeup - Clear wakeup flag for iopad.
+ * @oh: struct omap_hwmod *
+ *
+ * Traverse through dynamic pads, if pad is enabled then
+ * clear wakeup enable bit flag for the mux pin. Wakeup pad bit
+ * will be set during hwmod idle transistion.
+ * Return error if pads are not enabled or not available.
+ */
+int omap_hwmod_disable_ioring_wakeup(struct omap_hwmod *oh)
+{
+	/* Disable pad wakeup capability */
+	return omap_hwmod_set_ioring_wakeup(oh, false);
+}
 
 /**
  * omap_hwmod_enable_wakeup - allow device to wake up the system
@@ -2419,6 +2476,7 @@ int omap_hwmod_enable_wakeup(struct omap_hwmod *oh)
 	v = oh->_sysc_cache;
 	_enable_wakeup(oh, &v);
 	_write_sysconfig(v, oh);
+	omap_hwmod_enable_ioring_wakeup(oh);
 	spin_unlock_irqrestore(&oh->_lock, flags);
 
 	return 0;
@@ -2449,6 +2507,7 @@ int omap_hwmod_disable_wakeup(struct omap_hwmod *oh)
 	v = oh->_sysc_cache;
 	_disable_wakeup(oh, &v);
 	_write_sysconfig(v, oh);
+	omap_hwmod_disable_ioring_wakeup(oh);
 	spin_unlock_irqrestore(&oh->_lock, flags);
 
 	return 0;
-- 
1.7.4.1


Texas Instruments Oy, Tekniikantie 12, 02150 Espoo. Y-tunnus: 0115040-6. Kotipaikka: Helsinki
 

