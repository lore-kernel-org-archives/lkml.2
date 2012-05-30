Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab2E3K5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 06:57:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34502 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2E3K5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 06:57:07 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <paul@pwsan.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <b-cousson@ti.com>, <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: [RFC PATCH 5/5] arm: omap: ocp2scp: create omap device for ocp2scp
Date: Wed, 30 May 2012 16:26:34 +0530
Message-ID: <1338375394-16268-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1338375394-16268-1-git-send-email-kishon@ti.com>
References: <1338375394-16268-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platfrom device for ocp2scp is created using omap_device_build in
devices file. This is used for both omap4(musb) and omap5(dwc3).

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/mach-omap2/devices.c |   72 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index ae62ece..d87cf40 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/platform_data/omap4-keypad.h>
+#include <linux/platform_data/omap_ocp2scp.h>
 
 #include <mach/hardware.h>
 #include <mach/irqs.h>
@@ -659,6 +660,76 @@ void __init omap242x_init_mmc(struct omap_mmc_platform_data **mmc_data)
 
 #endif
 
+#if defined(CONFIG_OMAP_OCP2SCP) || defined(CONFIG_OMAP_OCP2SCP_MODULE)
+static int count_ocp2scp_devices(struct omap_ocp2scp_dev *ocp2scp_dev)
+{
+	int cnt	= 0;
+
+	while (ocp2scp_dev->drv_name != NULL) {
+		cnt++;
+		ocp2scp_dev++;
+	}
+
+	return cnt;
+}
+
+static void omap_init_ocp2scp(void)
+{
+	struct omap_hwmod	*oh;
+	struct platform_device	*pdev;
+	int			bus_id = -1, dev_cnt = 0, i;
+	struct omap_ocp2scp_dev	*ocp2scp_dev;
+	const char		*oh_name, *name;
+	struct omap_ocp2scp_platform_data *pdata;
+
+	oh_name = "ocp2scp_usb_phy";
+	name	= "omap-ocp2scp";
+
+	oh = omap_hwmod_lookup(oh_name);
+	if (!oh) {
+		pr_err("%s: could not find omap_hwmod for %s\n", __func__,
+								oh_name);
+		return;
+	}
+
+	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		pr_err("%s: No memory for ocp2scp pdata\n", __func__);
+		return;
+	}
+
+	ocp2scp_dev = oh->dev_attr;
+	dev_cnt = count_ocp2scp_devices(ocp2scp_dev);
+
+	if (!dev_cnt) {
+		pr_err("%s: No devices connected to ocp2scp\n", __func__);
+		return;
+	}
+
+	pdata->devices = kzalloc(sizeof(struct omap_ocp2scp_dev *)
+					* dev_cnt, GFP_KERNEL);
+	if (!pdata->devices) {
+		pr_err("%s: No memory for ocp2scp pdata devices\n", __func__);
+		return;
+	}
+
+	for (i = 0; i < dev_cnt; i++, ocp2scp_dev++)
+		pdata->devices[i] = ocp2scp_dev;
+
+	pdata->dev_cnt	= dev_cnt;
+
+	pdev = omap_device_build(name, bus_id, oh, pdata, sizeof(*pdata), NULL,
+								0, false);
+	if (IS_ERR(pdev)) {
+		pr_err("Could not build omap_device for %s %s\n",
+						name, oh_name);
+		return;
+	}
+}
+#else
+static inline void omap_init_ocp2scp(void) { }
+#endif
+
 /*-------------------------------------------------------------------------*/
 
 #if defined(CONFIG_HDQ_MASTER_OMAP) || defined(CONFIG_HDQ_MASTER_OMAP_MODULE)
@@ -745,6 +816,7 @@ static int __init omap2_init_devices(void)
 	omap_init_sham();
 	omap_init_aes();
 	omap_init_vout();
+	omap_init_ocp2scp();
 
 	return 0;
 }
-- 
1.7.5.4

