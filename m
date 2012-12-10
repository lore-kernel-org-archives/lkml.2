Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2LJKXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:23:40 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59228 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab2LJKVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:21:45 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <paul@pwsan.com>, <keshava_mgowda@ti.com>, <sshtylyov@mvista.com>,
        <bjorn@mork.no>, <rogerq@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Rajendra Nayak <rnayak@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Mike Turquette <mturquette@gmail.com>
Subject: [PATCH v4 16/23] ARM: OMAP2+: clock data: Merge utmi_px_gfclk into usb_host_hs_utmi_px_clk
Date: Mon, 10 Dec 2012 12:20:26 +0200
Message-ID: <1355134833-5199-17-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1355134833-5199-1-git-send-email-rogerq@ti.com>
References: <1355134833-5199-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no such clock as utmi_p1_gfclk. It is only a clock selector
bit to select th the parent of usb_host_hs_utmi_p1_clk.
So we get rid of utmi_p1_gfclk and utmi_p2_gfclk by merging them into
usb_host_hs_utmi_p1_clk and usb_host_hs_utmi_p2_clk respectively.

CC: Paul Walmsley <paul@pwsan.com>
CC: Rajendra Nayak <rnayak@ti.com>
CC: Benoit Cousson <b-cousson@ti.com>
CC: Mike Turquette <mturquette@gmail.com>

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/cclock3xxx_data.c |    2 -
 arch/arm/mach-omap2/cclock44xx_data.c |   47 +++++++++++++++++++++++----------
 2 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
index bdf3948..5655414 100644
--- a/arch/arm/mach-omap2/cclock3xxx_data.c
+++ b/arch/arm/mach-omap2/cclock3xxx_data.c
@@ -3392,8 +3392,6 @@ static struct omap_clk omap3xxx_clks[] = {
 	CLK(NULL,	"usbhost_48m_fck", &usbhost_48m_fck, CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
 	CLK(NULL,	"usbhost_ick",	&usbhost_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
 	CLK("usbhs_omap",	"usbhost_ick",	&usbhost_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
-	CLK(NULL,	"utmi_p1_gfclk",	&dummy_ck,	CK_3XXX),
-	CLK(NULL,	"utmi_p2_gfclk",	&dummy_ck,	CK_3XXX),
 	CLK(NULL,	"xclk60mhsp1_ck",	&dummy_ck,	CK_3XXX),
 	CLK(NULL,	"xclk60mhsp2_ck",	&dummy_ck,	CK_3XXX),
 	CLK(NULL,	"usb_host_hs_utmi_p1_clk",	&dummy_ck,	CK_3XXX),
diff --git a/arch/arm/mach-omap2/cclock44xx_data.c b/arch/arm/mach-omap2/cclock44xx_data.c
index aa56c3e..74535fe 100644
--- a/arch/arm/mach-omap2/cclock44xx_data.c
+++ b/arch/arm/mach-omap2/cclock44xx_data.c
@@ -1366,31 +1366,52 @@ static struct clk_hw_omap usb_host_fs_fck_hw = {
 DEFINE_STRUCT_CLK(usb_host_fs_fck, usb_host_fs_fck_parent_names,
 		  usb_host_fs_fck_ops);
 
+static const struct clk_ops utmi_clk_ops = {
+	.enable		= &omap2_dflt_clk_enable,
+	.disable	= &omap2_dflt_clk_disable,
+	.is_enabled	= &omap2_dflt_clk_is_enabled,
+	.recalc_rate	= &omap2_clksel_recalc,
+	.get_parent	= &omap2_clksel_find_parent_index,
+	.set_parent	= &omap2_clksel_set_parent,
+};
+
 static const char *utmi_p1_gfclk_parents[] = {
 	"init_60m_fclk", "xclk60mhsp1_ck",
 };
 
-DEFINE_CLK_MUX(utmi_p1_gfclk, utmi_p1_gfclk_parents, NULL, 0x0,
-	       OMAP4430_CM_L3INIT_USB_HOST_CLKCTRL,
-	       OMAP4430_CLKSEL_UTMI_P1_SHIFT, OMAP4430_CLKSEL_UTMI_P1_WIDTH,
-	       0x0, NULL);
+static const struct clksel utmi_p1_clk_mux_sel[] = {
+	{ .parent = &init_60m_fclk, .rates = div_1_0_rates },
+	{ .parent = &xclk60mhsp1_ck, .rates = div_1_1_rates },
+	{ .parent = NULL },
+};
 
-DEFINE_CLK_GATE(usb_host_hs_utmi_p1_clk, "utmi_p1_gfclk", &utmi_p1_gfclk, 0x0,
+/* Merged utmi_p1_gfclk into usb_host_hs_utmi_p1_clk */
+DEFINE_CLK_OMAP_MUX_GATE(usb_host_hs_utmi_p1_clk, "l3_init_clkdm",
+		utmi_p1_clk_mux_sel,
+		OMAP4430_CM_L3INIT_USB_HOST_CLKCTRL,
+		OMAP4430_CLKSEL_UTMI_P1_MASK,
 		OMAP4430_CM_L3INIT_USB_HOST_CLKCTRL,
-		OMAP4430_OPTFCLKEN_UTMI_P1_CLK_SHIFT, 0x0, NULL);
+		OMAP4430_OPTFCLKEN_UTMI_P1_CLK_SHIFT, NULL,
+		utmi_p1_gfclk_parents, utmi_clk_ops);
 
 static const char *utmi_p2_gfclk_parents[] = {
 	"init_60m_fclk", "xclk60mhsp2_ck",
 };
 
-DEFINE_CLK_MUX(utmi_p2_gfclk, utmi_p2_gfclk_parents, NULL, 0x0,
-	       OMAP4430_CM_L3INIT_USB_HOST_CLKCTRL,
-	       OMAP4430_CLKSEL_UTMI_P2_SHIFT, OMAP4430_CLKSEL_UTMI_P2_WIDTH,
-	       0x0, NULL);
+static const struct clksel utmi_p2_clk_mux_sel[] = {
+	{ .parent = &init_60m_fclk, .rates = div_1_0_rates },
+	{ .parent = &xclk60mhsp2_ck, .rates = div_1_1_rates },
+	{ .parent = NULL },
+};
 
-DEFINE_CLK_GATE(usb_host_hs_utmi_p2_clk, "utmi_p2_gfclk", &utmi_p2_gfclk, 0x0,
+/* Merged utmi_p2_gfclk into usb_host_hs_utmi_p2_clk */
+DEFINE_CLK_OMAP_MUX_GATE(usb_host_hs_utmi_p2_clk, "l3_init_clkdm",
+		utmi_p2_clk_mux_sel,
+		OMAP4430_CM_L3INIT_USB_HOST_CLKCTRL,
+		OMAP4430_CLKSEL_UTMI_P2_MASK,
 		OMAP4430_CM_L3INIT_USB_HOST_CLKCTRL,
-		OMAP4430_OPTFCLKEN_UTMI_P2_CLK_SHIFT, 0x0, NULL);
+		OMAP4430_OPTFCLKEN_UTMI_P2_CLK_SHIFT, NULL,
+		utmi_p2_gfclk_parents, utmi_clk_ops);
 
 DEFINE_CLK_GATE(usb_host_hs_utmi_p3_clk, "init_60m_fclk", &init_60m_fclk, 0x0,
 		OMAP4430_CM_L3INIT_USB_HOST_CLKCTRL,
@@ -1838,9 +1859,7 @@ static struct omap_clk omap44xx_clks[] = {
 	CLK(NULL,	"uart4_fck",			&uart4_fck,	CK_443X),
 	CLK(NULL,	"usb_host_fs_fck",		&usb_host_fs_fck,	CK_443X),
 	CLK("usbhs_omap",	"fs_fck",		&usb_host_fs_fck,	CK_443X),
-	CLK(NULL,	"utmi_p1_gfclk",		&utmi_p1_gfclk,	CK_443X),
 	CLK(NULL,	"usb_host_hs_utmi_p1_clk",	&usb_host_hs_utmi_p1_clk,	CK_443X),
-	CLK(NULL,	"utmi_p2_gfclk",		&utmi_p2_gfclk,	CK_443X),
 	CLK(NULL,	"usb_host_hs_utmi_p2_clk",	&usb_host_hs_utmi_p2_clk,	CK_443X),
 	CLK(NULL,	"usb_host_hs_utmi_p3_clk",	&usb_host_hs_utmi_p3_clk,	CK_443X),
 	CLK(NULL,	"usb_host_hs_hsic480m_p1_clk",	&usb_host_hs_hsic480m_p1_clk,	CK_443X),
-- 
1.7.4.1

