Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab1HNTrY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 15:47:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64618 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab1HNTrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 15:47:21 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: tony@atomide.com, linux@arm.linux.org.uk
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] omap2+:panda: Make hdmi_mux_init more robust.
Date: Sun, 14 Aug 2011 21:47:15 +0200
Message-Id: <1313351235-11400-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add error checking to omap4_panda_hdmi_mux_init function to
avoid problems when mux fails.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 arch/arm/mach-omap2/board-omap4panda.c |   38 +++++++++++++++++++++++--------
 1 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index 9aaa960..59fba7c 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -485,18 +485,33 @@ int __init omap4_panda_dvi_init(void)
 }
 
 
-static void omap4_panda_hdmi_mux_init(void)
+static int omap4_panda_hdmi_mux_init(void)
 {
+	int ret;
 	/* PAD0_HDMI_HPD_PAD1_HDMI_CEC */
-	omap_mux_init_signal("hdmi_hpd",
-			OMAP_PIN_INPUT_PULLUP);
-	omap_mux_init_signal("hdmi_cec",
-			OMAP_PIN_INPUT_PULLUP);
+	ret = omap_mux_init_signal("hdmi_hpd",
+				OMAP_PIN_INPUT_PULLUP);
+	if (ret)
+		goto err;
+
+	ret = omap_mux_init_signal("hdmi_cec",
+				OMAP_PIN_INPUT_PULLUP);
+	if (ret)
+		goto err;
+
 	/* PAD0_HDMI_DDC_SCL_PAD1_HDMI_DDC_SDA */
-	omap_mux_init_signal("hdmi_ddc_scl",
-			OMAP_PIN_INPUT_PULLUP);
-	omap_mux_init_signal("hdmi_ddc_sda",
-			OMAP_PIN_INPUT_PULLUP);
+	ret = omap_mux_init_signal("hdmi_ddc_scl",
+				OMAP_PIN_INPUT_PULLUP);
+	if (ret)
+		goto err;
+
+	ret = omap_mux_init_signal("hdmi_ddc_sda",
+				OMAP_PIN_INPUT_PULLUP);
+	if (ret)
+		goto err;
+	return 0;
+err:
+	return ret;
 }
 
 static struct gpio panda_hdmi_gpios[] = {
@@ -550,7 +565,10 @@ void omap4_panda_display_init(void)
 	if (r)
 		pr_err("error initializing panda DVI\n");
 
-	omap4_panda_hdmi_mux_init();
+	r = omap4_panda_hdmi_mux_init();
+	if (r)
+		pr_err("error initializing panda HDMI\n");
+
 	omap_display_init(&omap4_panda_dss_data);
 }
 
-- 
1.7.4.1

