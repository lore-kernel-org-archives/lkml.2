Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab1H3OBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 10:01:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46129 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab1H3OBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 10:01:38 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <balbi@ti.com>,
        <gadiyar@ti.com>, <sameo@linux.intel.com>, <parthab@india.ti.com>,
        <tony@atomide.com>, <khilman@ti.com>, <b-cousson@ti.com>,
        <paul@pwsan.com>, <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: [PATCH 2/2] arm: omap: usb: Add mux initialization to ehci and ohci hwmods for omap3
Date: Tue, 30 Aug 2011 19:27:27 +0530
Message-ID: <1314712647-30008-3-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1314712647-30008-2-git-send-email-keshava_mgowda@ti.com>
References: <1314712647-30008-1-git-send-email-keshava_mgowda@ti.com>
 <1314712647-30008-2-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keshava Munegowda <Keshava_mgowda@ti.com>

For ehci and ohci hwmods, the omap3 mux initializations functions
are included.

Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
---
 arch/arm/mach-omap2/usb-host.c |  692 ++++++++++++++++++++++++++++++---------
 1 files changed, 532 insertions(+), 160 deletions(-)

diff --git a/arch/arm/mach-omap2/usb-host.c b/arch/arm/mach-omap2/usb-host.c
index 9ec3d01..485341f 100644
--- a/arch/arm/mach-omap2/usb-host.c
+++ b/arch/arm/mach-omap2/usb-host.c
@@ -401,151 +401,525 @@ static struct omap_device_pad port2_2pin_pads[] __initdata = {
 	},
 };
 
+/*
+ * OMAP3 pad confs
+ */
+static struct omap_device_pad omap3_port1_phy_pads[] __initdata = {
+	{
+		.name = "etk_clk.hsusb1_stp",
+		.enable = OMAP_PIN_OUTPUT | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "etk_ctl.hsusb1_clk",
+		.enable = OMAP_PIN_OUTPUT | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "etk_d8.hsusb1_dir",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "etk_d9.hsusb1_nxt",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "etk_d0.hsusb1_data0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "etk_d1.hsusb1_data1",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "etk_d2.hsusb1_data2",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "etk_d7.hsusb1_data3",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "etk_d4.hsusb1_data4",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "etk_d5.hsusb1_data5",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "etk_d6.hsusb1_data6",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "etk_d3.hsusb1_data7",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+};
+
+static struct omap_device_pad omap3_port1_tll_pads[] __initdata = {
+	{
+		.name = "etk_clk.hsusb1_tll_stp",
+		.enable = OMAP_PIN_INPUT_PULLUP | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "etk_ctl.hsusb1_tll_clk",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "etk_d8.hsusb1_tll_dir",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "etk_d9.hsusb1_tll_nxt",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "etk_d0.hsusb1_tll_data0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "etk_d1.hsusb1_tll_data1",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "etk_d2.hsusb1_tll_data2",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "etk_d7.hsusb1_tll_data3",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "etk_d4.hsusb1_tll_data4",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "etk_d5.hsusb1_tll_data5",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "etk_d6.hsusb1_tll_data6",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "etk_d3.hsusb1_tll_data7",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+};
+
+static struct omap_device_pad omap3_port2_phy_pads[] __initdata = {
+	{
+		.name = "etk_d11.hsusb2_stp",
+		.enable = OMAP_PIN_OUTPUT | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "etk_d10.hsusb2_clk",
+		.enable = OMAP_PIN_OUTPUT | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "etk_d12.hsusb2_dir",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "etk_d13.hsusb2_nxt",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "etk_d14.hsusb2_data0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "etk_d15.hsusb2_data1",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "mcspi1_cs3.hsusb2_data2",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "mcspi2_cs1.hsusb2_data3",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "mcspi2_simo.hsusb2_data4",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "mcspi2_somi.hsusb2_data5",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "mcspi2_cs0.hsusb2_data6",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+	{
+		.name = "mcspi2_clk.hsusb2_data7",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+	},
+};
+
+static struct omap_device_pad omap3_port2_tll_pads[] __initdata = {
+	{
+		.name = "etk_d11.hsusb2_tll_stp",
+		.enable = OMAP_PIN_INPUT_PULLUP | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "etk_d10.hsusb2_tll_clk",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "etk_d12.hsusb2_tll_dir",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "etk_d13.hsusb2_tll_nxt",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "etk_d14.hsusb2_tll_data0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "etk_d15.hsusb2_tll_data1",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "mcspi1_cs3.hsusb2_tll_data2",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE2,
+	},
+	{
+		.name = "mcspi2_cs1.hsusb2_tll_data3",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE2,
+	},
+	{
+		.name = "mcspi2_simo.hsusb2_tll_data4",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE2,
+	},
+	{
+		.name = "mcspi2_somi.hsusb2_tll_data5",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE2,
+	},
+	{
+		.name = "mcspi2_cs0.hsusb2_tll_data6",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE2,
+	},
+	{
+		.name = "mcspi2_clk.hsusb2_tll_data7",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE2,
+	},
+};
+
+static struct omap_device_pad omap3_port3_tll_pads[] __initdata = {
+	{
+		.name = "sdmmc2_dat5.hsusb3_tll_stp",
+		.enable = OMAP_PIN_INPUT_PULLUP | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "uart1_cts.hsusb3_tll_clk",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "sdmmc2_dat6.hsusb3_tll_dir",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "sdmmc2_dat7.hsusb3_tll_nxt",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "mcbsp4_dr.hsusb3_tll_data0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "mcbsp4_clkx.hsusb3_tll_data1",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "mcbsp4_dx.hsusb3_tll_data2",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "mcbsp4_fsx.hsusb3_tll_data3",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "mcbsp3_dx.hsusb3_tll_data4",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "mcbsp3_dr.hsusb3_tll_data5",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "mcbsp3_clkx.hsusb3_tll_data6",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "mcbsp3_fsx.hsusb3_tll_data7",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+};
+
+static struct omap_device_pad omap3_port1_6pin_pads[] __initdata = {
+	{
+		.name = "etk_clk.mm1_rxdp",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "etk_d9.mm1_rxdm",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "etk_d0.mm1_rxrcv",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "etk_d7.mm1_txen_n",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "etk_d2.mm1_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "etk_d1.mm1_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+};
+
+static struct omap_device_pad omap3_port1_4pin_pads[] __initdata = {
+	{
+		.name = "etk_d0.mm1_rxrcv",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "etk_d7.mm1_txen_n",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "etk_d2.mm1_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "etk_d1.mm1_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+};
+
+static struct omap_device_pad omap3_port1_3pin_pads[] __initdata = {
+	{
+		.name = "etk_d7.mm1_txen_n",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "etk_d2.mm1_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "etk_d1.mm1_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+};
+
+static struct omap_device_pad omap3_port1_2pin_pads[] __initdata = {
+	{
+		.name = "etk_d2.mm1_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "etk_d1.mm1_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+};
+
+static struct omap_device_pad omap3_port2_6pin_pads[] __initdata = {
+	{
+		.name = "etk_d11.mm2_rxdp",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "etk_d13.mm2_rxdm",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "etk_d14.mm2_rxrcv",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "mcspi2_cs1.mm2_txen_n",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "etk_d15.mm2_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "mcspi1_cs3.mm2_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+};
+
+static struct omap_device_pad omap3_port2_4pin_pads[] __initdata = {
+	{
+		.name = "etk_d14.mm2_rxrcv",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "mcspi2_cs1.mm2_txen_n",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "etk_d15.mm2_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "mcspi1_cs3.mm2_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+};
+
+static struct omap_device_pad omap3_port2_3pin_pads[] __initdata = {
+	{
+		.name = "mcspi2_cs1.mm2_txen_n",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "etk_d15.mm2_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "mcspi1_cs3.mm2_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+};
+
+static struct omap_device_pad omap3_port2_2pin_pads[] __initdata = {
+	{
+		.name = "etk_d15.mm2_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "mcspi1_cs3.mm2_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+};
+
+static struct omap_device_pad omap3_port3_6pin_pads[] __initdata = {
+	{
+		.name = "sdmmc2_dat5.mm3_rxdp",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "sdmmc2_dat7.mm3_rxdm",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "mcbsp4_dr.mm3_rxrcv",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "mcbsp4_fsx.mm3_txen_n",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "mcbsp4_clkx.mm3_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "mcbsp4_dx.mm3_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+};
+
+static struct omap_device_pad omap3_port3_4pin_pads[] __initdata = {
+	{
+		.name = "mcbsp4_dr.mm3_rxrcv",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "mcbsp4_fsx.mm3_txen_n",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "mcbsp4_clkx.mm3_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "mcbsp4_dx.mm3_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+};
+
+static struct omap_device_pad omap3_port3_3pin_pads[] __initdata = {
+	{
+		.name = "mcbsp4_fsx.mm3_txen_n",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "mcbsp4_clkx.mm3_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "mcbsp4_dx.mm3_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+};
+
+static struct omap_device_pad omap3_port3_2pin_pads[] __initdata = {
+	{
+		.name = "mcbsp4_clkx.mm3_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+	{
+		.name = "mcbsp4_dx.mm3_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+	},
+};
+
 /* MUX settings for EHCI pins */
 /*
  * setup_ehci_io_mux - initialize IO pad mux for USBHOST
  */
-static void setup_ehci_io_mux(const enum usbhs_omap_port_mode *port_mode)
+static void setup_ehci_io_mux(const enum usbhs_omap_port_mode *port_mode,
+				struct omap_board_data *bdata)
 {
 	switch (port_mode[0]) {
 	case OMAP_EHCI_PORT_MODE_PHY:
-		omap_mux_init_signal("hsusb1_stp", OMAP_PIN_OUTPUT);
-		omap_mux_init_signal("hsusb1_clk", OMAP_PIN_OUTPUT);
-		omap_mux_init_signal("hsusb1_dir", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_nxt", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_data0", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_data1", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_data2", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_data3", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_data4", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_data5", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_data6", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_data7", OMAP_PIN_INPUT_PULLDOWN);
+		bdata->pads = omap3_port1_phy_pads;
+		bdata->pads_cnt = ARRAY_SIZE(omap3_port1_phy_pads);
 		break;
 	case OMAP_EHCI_PORT_MODE_TLL:
-		omap_mux_init_signal("hsusb1_tll_stp",
-			OMAP_PIN_INPUT_PULLUP);
-		omap_mux_init_signal("hsusb1_tll_clk",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_dir",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_nxt",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_data0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_data1",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_data2",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_data3",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_data4",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_data5",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_data6",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_data7",
-			OMAP_PIN_INPUT_PULLDOWN);
+		bdata->pads = omap3_port1_tll_pads;
+		bdata->pads_cnt = ARRAY_SIZE(omap3_port1_tll_pads);
 		break;
 	case OMAP_USBHS_PORT_MODE_UNUSED:
-		/* FALLTHROUGH */
 	default:
 		break;
 	}
-
 	switch (port_mode[1]) {
 	case OMAP_EHCI_PORT_MODE_PHY:
-		omap_mux_init_signal("hsusb2_stp", OMAP_PIN_OUTPUT);
-		omap_mux_init_signal("hsusb2_clk", OMAP_PIN_OUTPUT);
-		omap_mux_init_signal("hsusb2_dir", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_nxt", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_data0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_data1",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_data2",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_data3",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_data4",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_data5",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_data6",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_data7",
-			OMAP_PIN_INPUT_PULLDOWN);
+		bdata->pads = omap3_port2_phy_pads;
+		bdata->pads_cnt = ARRAY_SIZE(omap3_port2_phy_pads);
 		break;
 	case OMAP_EHCI_PORT_MODE_TLL:
-		omap_mux_init_signal("hsusb2_tll_stp",
-			OMAP_PIN_INPUT_PULLUP);
-		omap_mux_init_signal("hsusb2_tll_clk",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_dir",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_nxt",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_data0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_data1",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_data2",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_data3",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_data4",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_data5",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_data6",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_data7",
-			OMAP_PIN_INPUT_PULLDOWN);
+		bdata->pads = omap3_port2_tll_pads;
+		bdata->pads_cnt = ARRAY_SIZE(omap3_port2_tll_pads);
 		break;
 	case OMAP_USBHS_PORT_MODE_UNUSED:
-		/* FALLTHROUGH */
 	default:
 		break;
 	}
-
 	switch (port_mode[2]) {
 	case OMAP_EHCI_PORT_MODE_PHY:
 		printk(KERN_WARNING "Port3 can't be used in PHY mode\n");
 		break;
 	case OMAP_EHCI_PORT_MODE_TLL:
-		omap_mux_init_signal("hsusb3_tll_stp",
-			OMAP_PIN_INPUT_PULLUP);
-		omap_mux_init_signal("hsusb3_tll_clk",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_dir",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_nxt",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_data0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_data1",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_data2",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_data3",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_data4",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_data5",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_data6",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_data7",
-			OMAP_PIN_INPUT_PULLDOWN);
+		bdata->pads = omap3_port3_tll_pads;
+		bdata->pads_cnt = ARRAY_SIZE(omap3_port3_tll_pads);
 		break;
 	case OMAP_USBHS_PORT_MODE_UNUSED:
-		/* FALLTHROUGH */
 	default:
 		break;
 	}
-
-	return;
 }
 
 static void setup_4430ehci_io_mux(const enum usbhs_omap_port_mode *port_mode,
@@ -579,98 +953,92 @@ static void setup_4430ehci_io_mux(const enum usbhs_omap_port_mode *port_mode,
 	}
 }
 
-static void setup_ohci_io_mux(const enum usbhs_omap_port_mode *port_mode)
+static void setup_ohci_io_mux(const enum usbhs_omap_port_mode *port_mode,
+				struct omap_board_data *bdata)
 {
 	switch (port_mode[0]) {
 	case OMAP_OHCI_PORT_MODE_PHY_6PIN_DATSE0:
 	case OMAP_OHCI_PORT_MODE_PHY_6PIN_DPDM:
 	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DATSE0:
 	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DPDM:
-		omap_mux_init_signal("mm1_rxdp",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("mm1_rxdm",
-			OMAP_PIN_INPUT_PULLDOWN);
-		/* FALLTHROUGH */
+		bdata->pads = omap3_port1_6pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(omap3_port1_6pin_pads);
+		break;
 	case OMAP_OHCI_PORT_MODE_PHY_4PIN_DPDM:
 	case OMAP_OHCI_PORT_MODE_TLL_4PIN_DPDM:
-		omap_mux_init_signal("mm1_rxrcv",
-			OMAP_PIN_INPUT_PULLDOWN);
-		/* FALLTHROUGH */
+		bdata->pads = omap3_port1_4pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(omap3_port1_4pin_pads);
+		break;
 	case OMAP_OHCI_PORT_MODE_PHY_3PIN_DATSE0:
 	case OMAP_OHCI_PORT_MODE_TLL_3PIN_DATSE0:
-		omap_mux_init_signal("mm1_txen_n", OMAP_PIN_OUTPUT);
-		/* FALLTHROUGH */
+		bdata->pads = omap3_port1_3pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(omap3_port1_3pin_pads);
+		break;
 	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DATSE0:
 	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM:
-		omap_mux_init_signal("mm1_txse0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("mm1_txdat",
-			OMAP_PIN_INPUT_PULLDOWN);
+		bdata->pads = omap3_port1_2pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(omap3_port1_2pin_pads);
 		break;
+
 	case OMAP_USBHS_PORT_MODE_UNUSED:
-		/* FALLTHROUGH */
 	default:
 		break;
 	}
+
 	switch (port_mode[1]) {
 	case OMAP_OHCI_PORT_MODE_PHY_6PIN_DATSE0:
 	case OMAP_OHCI_PORT_MODE_PHY_6PIN_DPDM:
 	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DATSE0:
 	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DPDM:
-		omap_mux_init_signal("mm2_rxdp",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("mm2_rxdm",
-			OMAP_PIN_INPUT_PULLDOWN);
-		/* FALLTHROUGH */
+		bdata->pads = omap3_port2_6pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(omap3_port2_6pin_pads);
+		break;
 	case OMAP_OHCI_PORT_MODE_PHY_4PIN_DPDM:
 	case OMAP_OHCI_PORT_MODE_TLL_4PIN_DPDM:
-		omap_mux_init_signal("mm2_rxrcv",
-			OMAP_PIN_INPUT_PULLDOWN);
-		/* FALLTHROUGH */
+		bdata->pads = omap3_port2_4pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(omap3_port2_4pin_pads);
+		break;
 	case OMAP_OHCI_PORT_MODE_PHY_3PIN_DATSE0:
 	case OMAP_OHCI_PORT_MODE_TLL_3PIN_DATSE0:
-		omap_mux_init_signal("mm2_txen_n", OMAP_PIN_OUTPUT);
-		/* FALLTHROUGH */
+		bdata->pads = omap3_port2_3pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(omap3_port2_3pin_pads);
+		break;
 	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DATSE0:
 	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM:
-		omap_mux_init_signal("mm2_txse0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("mm2_txdat",
-			OMAP_PIN_INPUT_PULLDOWN);
+		bdata->pads = omap3_port2_2pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(omap3_port2_3pin_pads);
 		break;
+
 	case OMAP_USBHS_PORT_MODE_UNUSED:
-		/* FALLTHROUGH */
 	default:
 		break;
 	}
+
 	switch (port_mode[2]) {
 	case OMAP_OHCI_PORT_MODE_PHY_6PIN_DATSE0:
 	case OMAP_OHCI_PORT_MODE_PHY_6PIN_DPDM:
 	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DATSE0:
 	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DPDM:
-		omap_mux_init_signal("mm3_rxdp",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("mm3_rxdm",
-			OMAP_PIN_INPUT_PULLDOWN);
-		/* FALLTHROUGH */
+		bdata->pads = omap3_port3_6pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(omap3_port3_6pin_pads);
+		break;
 	case OMAP_OHCI_PORT_MODE_PHY_4PIN_DPDM:
 	case OMAP_OHCI_PORT_MODE_TLL_4PIN_DPDM:
-		omap_mux_init_signal("mm3_rxrcv",
-			OMAP_PIN_INPUT_PULLDOWN);
-		/* FALLTHROUGH */
+		bdata->pads = omap3_port3_4pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(omap3_port3_4pin_pads);
+		break;
 	case OMAP_OHCI_PORT_MODE_PHY_3PIN_DATSE0:
 	case OMAP_OHCI_PORT_MODE_TLL_3PIN_DATSE0:
-		omap_mux_init_signal("mm3_txen_n", OMAP_PIN_OUTPUT);
-		/* FALLTHROUGH */
+		bdata->pads = omap3_port3_3pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(omap3_port3_3pin_pads);
+		break;
 	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DATSE0:
 	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM:
-		omap_mux_init_signal("mm3_txse0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("mm3_txdat",
-			OMAP_PIN_INPUT_PULLDOWN);
+		bdata->pads = omap3_port3_2pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(omap3_port3_2pin_pads);
 		break;
+
 	case OMAP_USBHS_PORT_MODE_UNUSED:
-		/* FALLTHROUGH */
 	default:
 		break;
 	}
@@ -785,8 +1153,12 @@ void __init usbhs_init(const struct usbhs_omap_board_data *pdata)
 	}
 
 	if (cpu_is_omap34xx()) {
-		setup_ehci_io_mux(pdata->port_mode);
-		setup_ohci_io_mux(pdata->port_mode);
+		setup_ehci_io_mux(pdata->port_mode, &bdata);
+		oh[2]->mux = omap_hwmod_mux_init((&bdata)->pads,
+						bdata.pads_cnt);
+		setup_ohci_io_mux(pdata->port_mode, &bdata);
+		oh[1]->mux = omap_hwmod_mux_init((&bdata)->pads,
+						bdata.pads_cnt);
 	} else if (cpu_is_omap44xx()) {
 		setup_4430ehci_io_mux(pdata->port_mode, &bdata);
 		oh[2]->mux = omap_hwmod_mux_init((&bdata)->pads,
-- 
1.6.0.4

