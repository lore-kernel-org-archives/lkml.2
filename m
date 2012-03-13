Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068Ab2CMIq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:46:58 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:42467 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759957Ab2CMIpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:45:23 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <s.hauer@pengutronix.de>, <shawn.guo@freescale.com>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <cjb@laptop.org>, <rdunlap@xenotime.net>,
        <vinod.koul@linux.intel.com>
Subject: [PATCH v1 5/5] ARM: mxs: add mxs dma dt support
Date: Tue, 13 Mar 2012 16:47:08 +0800
Message-ID: <1331628428-24017-6-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331628428-24017-1-git-send-email-b29396@freescale.com>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Originally the dma device will be added by default via
arch_initcall(mxs_add_mxs_dma);

Now change to call it explicitly in board file to avoid conflict
with device tree support.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 arch/arm/boot/dts/imx28.dtsi                    |   12 +++++++++++-
 arch/arm/mach-mxs/devices-mx23.h                |    2 ++
 arch/arm/mach-mxs/devices-mx28.h                |    2 ++
 arch/arm/mach-mxs/devices/platform-dma.c        |    3 +--
 arch/arm/mach-mxs/imx28-dt.c                    |    2 ++
 arch/arm/mach-mxs/include/mach/devices-common.h |    3 +++
 arch/arm/mach-mxs/mach-apx4devkit.c             |    1 +
 arch/arm/mach-mxs/mach-m28evk.c                 |    1 +
 arch/arm/mach-mxs/mach-mx23evk.c                |    1 +
 arch/arm/mach-mxs/mach-mx28evk.c                |    1 +
 arch/arm/mach-mxs/mach-stmp378x_devb.c          |    1 +
 arch/arm/mach-mxs/mach-tx28.c                   |    1 +
 12 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
index 71c7bfb..f0322e9 100644
--- a/arch/arm/boot/dts/imx28.dtsi
+++ b/arch/arm/boot/dts/imx28.dtsi
@@ -47,6 +47,11 @@
 				reg = <0x80000000 0x2000>;
 			};
 
+			dma-apbh@80004000 {
+				compatible = "fsl,mxs-dma-apbh";
+				reg = <0x80004000 2000>;
+			};
+
 			ssp@80010000 {
 				compatible = "fsl,imx28-mmc";
 				reg = <0x80010000 2000>;
@@ -79,7 +84,12 @@
 				dma_channel = <3>;
 				status = "disabled";
 			};
-		};
+
+			dma-apbx@80024000 {
+				compatible = "fsl,mxs-dma-apbx";
+				reg = <0x80024000 2000>;
+			};
+                };
 
 		apbx@80040000 {
 			compatible = "simple-bus";
diff --git a/arch/arm/mach-mxs/devices-mx23.h b/arch/arm/mach-mxs/devices-mx23.h
index 3fa651d..721c91a 100644
--- a/arch/arm/mach-mxs/devices-mx23.h
+++ b/arch/arm/mach-mxs/devices-mx23.h
@@ -31,3 +31,5 @@ struct platform_device *__init mx23_add_mxsfb(
 		const struct mxsfb_platform_data *pdata);
 
 struct platform_device *__init mx23_add_rtc_stmp3xxx(void);
+
+#define mx23_add_dma()	mxs_add_mxs_dma()
diff --git a/arch/arm/mach-mxs/devices-mx28.h b/arch/arm/mach-mxs/devices-mx28.h
index 4f50094..c0cfd4e 100644
--- a/arch/arm/mach-mxs/devices-mx28.h
+++ b/arch/arm/mach-mxs/devices-mx28.h
@@ -51,3 +51,5 @@ extern const struct mxs_saif_data mx28_saif_data[] __initconst;
 	mxs_add_saif(&mx28_saif_data[id], pdata)
 
 struct platform_device *__init mx28_add_rtc_stmp3xxx(void);
+
+#define mx28_add_dma()	mxs_add_mxs_dma()
diff --git a/arch/arm/mach-mxs/devices/platform-dma.c b/arch/arm/mach-mxs/devices/platform-dma.c
index 6a0202b..57f851e 100644
--- a/arch/arm/mach-mxs/devices/platform-dma.c
+++ b/arch/arm/mach-mxs/devices/platform-dma.c
@@ -30,7 +30,7 @@ static struct platform_device *__init mxs_add_dma(const char *devid,
 				DMA_BIT_MASK(32));
 }
 
-static int __init mxs_add_mxs_dma(void)
+int __init mxs_add_mxs_dma(void)
 {
 	char *apbh = "mxs-dma-apbh";
 	char *apbx = "mxs-dma-apbx";
@@ -47,4 +47,3 @@ static int __init mxs_add_mxs_dma(void)
 
 	return 0;
 }
-arch_initcall(mxs_add_mxs_dma);
diff --git a/arch/arm/mach-mxs/imx28-dt.c b/arch/arm/mach-mxs/imx28-dt.c
index 429b88e..1c4d317 100644
--- a/arch/arm/mach-mxs/imx28-dt.c
+++ b/arch/arm/mach-mxs/imx28-dt.c
@@ -25,6 +25,8 @@ static const struct of_dev_auxdata imx28_auxdata_lookup[] __initconst = {
 	OF_DEV_AUXDATA("fsl,imx28-fec", MX28_ENET_MAC1_BASE_ADDR, "imx28-fec.1", NULL),
 	OF_DEV_AUXDATA("fsl,imx28-mmc", MX28_SSP0_BASE_ADDR, "mxs-mmc.0", NULL),
 	OF_DEV_AUXDATA("fsl,imx28-mmc", MX28_SSP1_BASE_ADDR, "mxs-mmc.1", NULL),
+	OF_DEV_AUXDATA("fsl,mxs-dma-apbh", MX28_APBH_DMA_BASE_ADDR, "mxs-dma-apbh", NULL),
+	OF_DEV_AUXDATA("fsl,mxs-dma-apbx", MX28_APBX_DMA_BASE_ADDR, "mxs-dma-apbx", NULL),
 	{ /* sentinel */ }
 };
 
diff --git a/arch/arm/mach-mxs/include/mach/devices-common.h b/arch/arm/mach-mxs/include/mach/devices-common.h
index dc369c1..87939a2 100644
--- a/arch/arm/mach-mxs/include/mach/devices-common.h
+++ b/arch/arm/mach-mxs/include/mach/devices-common.h
@@ -106,3 +106,6 @@ struct mxs_saif_data {
 struct platform_device *__init mxs_add_saif(
 		const struct mxs_saif_data *data,
 		const struct mxs_saif_platform_data *pdata);
+
+/* dma */
+int __init mxs_add_mxs_dma(void);
diff --git a/arch/arm/mach-mxs/mach-apx4devkit.c b/arch/arm/mach-mxs/mach-apx4devkit.c
index 48a7fab..92f47e9 100644
--- a/arch/arm/mach-mxs/mach-apx4devkit.c
+++ b/arch/arm/mach-mxs/mach-apx4devkit.c
@@ -210,6 +210,7 @@ static void __init apx4devkit_init(void)
 	mxs_iomux_setup_multiple_pads(apx4devkit_pads,
 			ARRAY_SIZE(apx4devkit_pads));
 
+	mx28_add_dma();
 	mx28_add_duart();
 	mx28_add_auart0();
 	mx28_add_auart1();
diff --git a/arch/arm/mach-mxs/mach-m28evk.c b/arch/arm/mach-mxs/mach-m28evk.c
index 06d7996..9a74ce6 100644
--- a/arch/arm/mach-mxs/mach-m28evk.c
+++ b/arch/arm/mach-mxs/mach-m28evk.c
@@ -321,6 +321,7 @@ static void __init m28evk_init(void)
 {
 	mxs_iomux_setup_multiple_pads(m28evk_pads, ARRAY_SIZE(m28evk_pads));
 
+	mx28_add_dma();
 	mx28_add_duart();
 	mx28_add_auart0();
 	mx28_add_auart3();
diff --git a/arch/arm/mach-mxs/mach-mx23evk.c b/arch/arm/mach-mxs/mach-mx23evk.c
index 5ea1c57..cabc884 100644
--- a/arch/arm/mach-mxs/mach-mx23evk.c
+++ b/arch/arm/mach-mxs/mach-mx23evk.c
@@ -143,6 +143,7 @@ static void __init mx23evk_init(void)
 
 	mxs_iomux_setup_multiple_pads(mx23evk_pads, ARRAY_SIZE(mx23evk_pads));
 
+	mx23_add_dma();
 	mx23_add_duart();
 	mx23_add_auart0();
 
diff --git a/arch/arm/mach-mxs/mach-mx28evk.c b/arch/arm/mach-mxs/mach-mx28evk.c
index e386c14..4b645eb 100644
--- a/arch/arm/mach-mxs/mach-mx28evk.c
+++ b/arch/arm/mach-mxs/mach-mx28evk.c
@@ -415,6 +415,7 @@ static void __init mx28evk_init(void)
 
 	mxs_iomux_setup_multiple_pads(mx28evk_pads, ARRAY_SIZE(mx28evk_pads));
 
+	mx28_add_dma();
 	mx28_add_duart();
 	mx28_add_auart0();
 	mx28_add_auart3();
diff --git a/arch/arm/mach-mxs/mach-stmp378x_devb.c b/arch/arm/mach-mxs/mach-stmp378x_devb.c
index a626c07..a391b9e 100644
--- a/arch/arm/mach-mxs/mach-stmp378x_devb.c
+++ b/arch/arm/mach-mxs/mach-stmp378x_devb.c
@@ -88,6 +88,7 @@ static void __init stmp378x_dvb_init(void)
 	mxs_iomux_setup_multiple_pads(stmp378x_dvb_pads,
 			ARRAY_SIZE(stmp378x_dvb_pads));
 
+	mx23_add_dma();
 	mx23_add_duart();
 	mx23_add_auart0();
 	mx23_add_rtc_stmp3xxx();
diff --git a/arch/arm/mach-mxs/mach-tx28.c b/arch/arm/mach-mxs/mach-tx28.c
index 2c0862e..e17e262 100644
--- a/arch/arm/mach-mxs/mach-tx28.c
+++ b/arch/arm/mach-mxs/mach-tx28.c
@@ -149,6 +149,7 @@ static void __init tx28_stk5v3_init(void)
 	mxs_iomux_setup_multiple_pads(tx28_stk5v3_pads,
 			ARRAY_SIZE(tx28_stk5v3_pads));
 
+	mx28_add_dma();
 	mx28_add_duart(); /* UART1 */
 	mx28_add_auart(1); /* UART2 */
 
-- 
1.7.0.4


