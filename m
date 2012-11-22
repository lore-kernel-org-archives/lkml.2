Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab2KVS2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:28:43 -0500
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:55217
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974Ab2KVS2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:28:38 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1de0h1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <kernel@pengutronix.de>
CC: <javier.martin@vista-silicon.com>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v4 3/3] ARM: mx27: Add VPU support
Date: Thu, 22 Nov 2012 14:12:49 -0200
Message-ID: <1353600769-28693-3-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353600769-28693-1-git-send-email-fabio.estevam@freescale.com>
References: <1353600769-28693-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mx27 has a VPU (Video Processing Unit) block that allows doing H264/MPEG4
decoding and encoding in hardware.

Add support for it in a common SoC file instead of per board file.

Also make sure to not register the VPU driver for the MX27Lite version as this
one does not contain the VPU controller.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v3:
- Use a shorter name for VPU disabled fuse bit.
Changes since v2:
- Do not register VPU for mx27lite version
Changes since v1:
- Call imx27_add_coda() on a common mx27 location instead of per board
 arch/arm/mach-imx/iim.h                     |    2 ++
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c |    1 -
 arch/arm/mach-imx/mm-imx27.c                |   21 ++++++++++++++++++++-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-imx/iim.h b/arch/arm/mach-imx/iim.h
index d1d6f35..4ac1de9 100644
--- a/arch/arm/mach-imx/iim.h
+++ b/arch/arm/mach-imx/iim.h
@@ -74,4 +74,6 @@
 #define MXC_IIMHWV2_BP_SDMA             (0x1 << 6)
 #define MXC_IIMHWV2_SCM_DCM             (0x1 << 5)
 
+#define MX27_VPU_DISABLE		(0x1 << 7)
+
 #endif /* __ASM_ARCH_MXC_IIM_H__ */
diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
index 914b2f8..d228d09 100644
--- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
+++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
@@ -489,7 +489,6 @@ static void __init visstrim_m10_board_init(void)
 	gpio_led_register_device(0, &visstrim_m10_led_data);
 	platform_device_register(&visstrim_deinterlace);
 	visstrim_camera_init();
-	imx27_add_coda();
 }
 
 static void __init visstrim_m10_timer_init(void)
diff --git a/arch/arm/mach-imx/mm-imx27.c b/arch/arm/mach-imx/mm-imx27.c
index 4f1be65..cf65792 100644
--- a/arch/arm/mach-imx/mm-imx27.c
+++ b/arch/arm/mach-imx/mm-imx27.c
@@ -25,9 +25,10 @@
 #include <asm/mach/map.h>
 
 #include "common.h"
-#include "devices/devices-common.h"
+#include "devices-imx27.h"
 #include "hardware.h"
 #include "iomux-v1.h"
+#include "iim.h"
 
 /* MX27 memory map definition */
 static struct map_desc imx27_io_desc[] __initdata = {
@@ -80,6 +81,20 @@ static const struct resource imx27_audmux_res[] __initconst = {
 	DEFINE_RES_MEM(MX27_AUDMUX_BASE_ADDR, SZ_4K),
 };
 
+static int cpu_is_mx27l(void)
+{
+	int fuse;
+	fuse = __raw_readl(MX27_IO_ADDRESS(MX27_IIM_BASE_ADDR +
+							MXC_IIMWORD3_BANK0));
+
+	fuse &= MX27_VPU_DISABLE;
+
+	if (fuse)
+		return 1;
+	else
+		return 0;
+}
+
 void __init imx27_soc_init(void)
 {
 	mxc_device_init();
@@ -98,4 +113,8 @@ void __init imx27_soc_init(void)
 	/* imx27 has the imx21 type audmux */
 	platform_device_register_simple("imx21-audmux", 0, imx27_audmux_res,
 					ARRAY_SIZE(imx27_audmux_res));
+
+	/* MX27L variant does not have VPU, so do not register VPU for it */
+	if (!cpu_is_mx27l())
+		imx27_add_coda();
 }
-- 
1.7.9.5


