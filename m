Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab2ADCVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 21:21:04 -0500
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:48529 "HELO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753821Ab2ADCUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 21:20:03 -0500
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: linus.walleij@linaro.org, swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, arnd@arndb.de
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: [PATCH v4 1/3] pinctrl: enable pinmux for mmp series
Date: Wed,  4 Jan 2012 10:26:33 +0800
Message-Id: <1325643995-20745-2-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1325643995-20745-1-git-send-email-haojian.zhuang@marvell.com>
References: <1325643995-20745-1-git-send-email-haojian.zhuang@marvell.com>
X-OriginalArrivalTime: 04 Jan 2012 02:19:29.0342 (UTC) FILETIME=[49BCFDE0:01CCCA87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support PXA168/PXA910/MMP2 pinmux. Now only support function switch.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/pinctrl/Kconfig          |   22 +
 drivers/pinctrl/Makefile         |    4 +
 drivers/pinctrl/pinctrl-mmp2.c   |  723 +++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-pxa168.c |  652 ++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-pxa3xx.c |  244 +++++++++
 drivers/pinctrl/pinctrl-pxa3xx.h |  264 ++++++++++
 drivers/pinctrl/pinctrl-pxa910.c | 1008 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 2917 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pinctrl/pinctrl-mmp2.c
 create mode 100644 drivers/pinctrl/pinctrl-pxa168.c
 create mode 100644 drivers/pinctrl/pinctrl-pxa3xx.c
 create mode 100644 drivers/pinctrl/pinctrl-pxa3xx.h
 create mode 100644 drivers/pinctrl/pinctrl-pxa910.c

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index afaf885..3bea79f 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -23,6 +23,28 @@ config DEBUG_PINCTRL
 	help
 	  Say Y here to add some extra checks and diagnostics to PINCTRL calls.
 
+config PINCTRL_PXA3xx
+	bool
+	select PINMUX
+
+config PINCTRL_MMP2
+	bool "MMP2 pin controller driver"
+	depends on ARCH_MMP
+	select PINCTRL_PXA3xx
+	select PINCONF
+
+config PINCTRL_PXA168
+	bool "PXA168 pin controller driver"
+	depends on ARCH_MMP
+	select PINCTRL_PXA3xx
+	select PINCONF
+
+config PINCTRL_PXA910
+	bool "PXA910 pin controller driver"
+	depends on ARCH_MMP
+	select PINCTRL_PXA3xx
+	select PINCONF
+
 config PINCTRL_SIRF
 	bool "CSR SiRFprimaII pin controller driver"
 	depends on ARCH_PRIMA2
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 827601c..c95d91e 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -5,6 +5,10 @@ ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
 obj-$(CONFIG_PINCTRL)		+= core.o
 obj-$(CONFIG_PINMUX)		+= pinmux.o
 obj-$(CONFIG_PINCONF)		+= pinconf.o
+obj-$(CONFIG_PINCTRL_PXA3xx)	+= pinctrl-pxa3xx.o
+obj-$(CONFIG_PINCTRL_MMP2)	+= pinctrl-mmp2.o
+obj-$(CONFIG_PINCTRL_PXA168)	+= pinctrl-pxa168.o
+obj-$(CONFIG_PINCTRL_PXA910)	+= pinctrl-pxa910.o
 obj-$(CONFIG_PINCTRL_SIRF)	+= pinctrl-sirf.o
 obj-$(CONFIG_PINCTRL_U300)	+= pinctrl-u300.o
 obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
diff --git a/drivers/pinctrl/pinctrl-mmp2.c b/drivers/pinctrl/pinctrl-mmp2.c
new file mode 100644
index 0000000..55f98ff
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-mmp2.c
@@ -0,0 +1,723 @@
+/*
+ *  linux/drivers/pinctrl/pinmux-mmp2.c
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ *
+ *  Copyright (C) 2011, Marvell Technology Group Ltd.
+ *
+ *  Author: Haojian Zhuang <haojian.zhuang@marvell.com>
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include "pinctrl-pxa3xx.h"
+
+#define MMP2_DS_MASK		0x1800
+#define MMP2_DS_SHIFT		11
+#define MMP2_SLEEP_MASK		0x38
+#define MMP2_SLEEP_SELECT	(1 << 9)
+#define MMP2_SLEEP_DATA		(1 << 8)
+#define MMP2_SLEEP_DIR		(1 << 7)
+
+#define MFPR_MMP2(a, r, f0, f1, f2, f3, f4, f5, f6, f7)		\
+	{							\
+		.name = #a,					\
+		.pin = a,					\
+		.mfpr = r,					\
+		.func = {					\
+			MMP2_MUX_##f0,				\
+			MMP2_MUX_##f1,				\
+			MMP2_MUX_##f2,				\
+			MMP2_MUX_##f3,				\
+			MMP2_MUX_##f4,				\
+			MMP2_MUX_##f5,				\
+			MMP2_MUX_##f6,				\
+			MMP2_MUX_##f7,				\
+		},						\
+	}
+
+#define GRP_MMP2(a, m, p)		\
+	{ .name = a, .mux = MMP2_MUX_##m, .pins = p, .npins = ARRAY_SIZE(p), }
+
+/* 174 pins */
+enum mmp2_pin_list {
+	/* 0~168: GPIO0~GPIO168 */
+	TWSI4_SCL = 169,
+	TWSI4_SDA, /* 170 */
+	G_CLKREQ,
+	VCXO_REQ,
+	VCXO_OUT,
+};
+
+enum mmp2_mux {
+	/* PXA3xx_MUX_GPIO = 0 (predefined in pinctrl-pxa3xx.h) */
+	MMP2_MUX_GPIO = 0,
+	MMP2_MUX_G_CLKREQ,
+	MMP2_MUX_VCXO_REQ,
+	MMP2_MUX_VCXO_OUT,
+	MMP2_MUX_KP_MK,
+	MMP2_MUX_KP_DK,
+	MMP2_MUX_CCIC1,
+	MMP2_MUX_CCIC2,
+	MMP2_MUX_SPI,
+	MMP2_MUX_SSPA2,
+	MMP2_MUX_ROT,
+	MMP2_MUX_I2S,
+	MMP2_MUX_TB,
+	MMP2_MUX_CAM2,
+	MMP2_MUX_HDMI,
+	MMP2_MUX_TWSI2,
+	MMP2_MUX_TWSI3,
+	MMP2_MUX_TWSI4,
+	MMP2_MUX_TWSI5,
+	MMP2_MUX_TWSI6,
+	MMP2_MUX_UART1,
+	MMP2_MUX_UART2,
+	MMP2_MUX_UART3,
+	MMP2_MUX_UART4,
+	MMP2_MUX_SSP1_RX,
+	MMP2_MUX_SSP1_FRM,
+	MMP2_MUX_SSP1_TXRX,
+	MMP2_MUX_SSP2_RX,
+	MMP2_MUX_SSP2_FRM,
+	MMP2_MUX_SSP1,
+	MMP2_MUX_SSP2,
+	MMP2_MUX_SSP3,
+	MMP2_MUX_SSP4,
+	MMP2_MUX_MMC1,
+	MMP2_MUX_MMC2,
+	MMP2_MUX_MMC3,
+	MMP2_MUX_MMC4,
+	MMP2_MUX_ULPI,
+	MMP2_MUX_AC,
+	MMP2_MUX_CA,
+	MMP2_MUX_PWM,
+	MMP2_MUX_USIM,
+	MMP2_MUX_TIPU,
+	MMP2_MUX_PLL,
+	MMP2_MUX_NAND,
+	MMP2_MUX_FSIC,
+	MMP2_MUX_SLEEP_IND,
+	MMP2_MUX_EXT_DMA,
+	MMP2_MUX_ONE_WIRE,
+	MMP2_MUX_LCD,
+	MMP2_MUX_SMC,
+	MMP2_MUX_SMC_INT,
+	MMP2_MUX_MSP,
+	MMP2_MUX_G_CLKOUT,
+	MMP2_MUX_32K_CLKOUT,
+	MMP2_MUX_PRI_JTAG,
+	MMP2_MUX_AAS_JTAG,
+	MMP2_MUX_AAS_GPIO,
+	MMP2_MUX_AAS_SPI,
+	MMP2_MUX_AAS_TWSI,
+	MMP2_MUX_AAS_DEU_EX,
+	MMP2_MUX_NONE = 0xffff,
+};
+
+static struct pinctrl_pin_desc mmp2_pads[] = {
+	/*
+	 * The name indicates function 0 of this pin.
+	 * After reset, function 0 is the default function of pin.
+	 */
+	PINCTRL_PIN(GPIO0, "GPIO0"),
+	PINCTRL_PIN(GPIO1, "GPIO1"),
+	PINCTRL_PIN(GPIO2, "GPIO2"),
+	PINCTRL_PIN(GPIO3, "GPIO3"),
+	PINCTRL_PIN(GPIO4, "GPIO4"),
+	PINCTRL_PIN(GPIO5, "GPIO5"),
+	PINCTRL_PIN(GPIO6, "GPIO6"),
+	PINCTRL_PIN(GPIO7, "GPIO7"),
+	PINCTRL_PIN(GPIO8, "GPIO8"),
+	PINCTRL_PIN(GPIO9, "GPIO9"),
+	PINCTRL_PIN(GPIO10, "GPIO10"),
+	PINCTRL_PIN(GPIO11, "GPIO11"),
+	PINCTRL_PIN(GPIO12, "GPIO12"),
+	PINCTRL_PIN(GPIO13, "GPIO13"),
+	PINCTRL_PIN(GPIO14, "GPIO14"),
+	PINCTRL_PIN(GPIO15, "GPIO15"),
+	PINCTRL_PIN(GPIO16, "GPIO16"),
+	PINCTRL_PIN(GPIO17, "GPIO17"),
+	PINCTRL_PIN(GPIO18, "GPIO18"),
+	PINCTRL_PIN(GPIO19, "GPIO19"),
+	PINCTRL_PIN(GPIO20, "GPIO20"),
+	PINCTRL_PIN(GPIO21, "GPIO21"),
+	PINCTRL_PIN(GPIO22, "GPIO22"),
+	PINCTRL_PIN(GPIO23, "GPIO23"),
+	PINCTRL_PIN(GPIO24, "GPIO24"),
+	PINCTRL_PIN(GPIO25, "GPIO25"),
+	PINCTRL_PIN(GPIO26, "GPIO26"),
+	PINCTRL_PIN(GPIO27, "GPIO27"),
+	PINCTRL_PIN(GPIO28, "GPIO28"),
+	PINCTRL_PIN(GPIO29, "GPIO29"),
+	PINCTRL_PIN(GPIO30, "GPIO30"),
+	PINCTRL_PIN(GPIO31, "GPIO31"),
+	PINCTRL_PIN(GPIO32, "GPIO32"),
+	PINCTRL_PIN(GPIO33, "GPIO33"),
+	PINCTRL_PIN(GPIO34, "GPIO34"),
+	PINCTRL_PIN(GPIO35, "GPIO35"),
+	PINCTRL_PIN(GPIO36, "GPIO36"),
+	PINCTRL_PIN(GPIO37, "GPIO37"),
+	PINCTRL_PIN(GPIO38, "GPIO38"),
+	PINCTRL_PIN(GPIO39, "GPIO39"),
+	PINCTRL_PIN(GPIO40, "GPIO40"),
+	PINCTRL_PIN(GPIO41, "GPIO41"),
+	PINCTRL_PIN(GPIO42, "GPIO42"),
+	PINCTRL_PIN(GPIO43, "GPIO43"),
+	PINCTRL_PIN(GPIO44, "GPIO44"),
+	PINCTRL_PIN(GPIO45, "GPIO45"),
+	PINCTRL_PIN(GPIO46, "GPIO46"),
+	PINCTRL_PIN(GPIO47, "GPIO47"),
+	PINCTRL_PIN(GPIO48, "GPIO48"),
+	PINCTRL_PIN(GPIO49, "GPIO49"),
+	PINCTRL_PIN(GPIO50, "GPIO50"),
+	PINCTRL_PIN(GPIO51, "GPIO51"),
+	PINCTRL_PIN(GPIO52, "GPIO52"),
+	PINCTRL_PIN(GPIO53, "GPIO53"),
+	PINCTRL_PIN(GPIO54, "GPIO54"),
+	PINCTRL_PIN(GPIO55, "GPIO55"),
+	PINCTRL_PIN(GPIO56, "GPIO56"),
+	PINCTRL_PIN(GPIO57, "GPIO57"),
+	PINCTRL_PIN(GPIO58, "GPIO58"),
+	PINCTRL_PIN(GPIO59, "GPIO59"),
+	PINCTRL_PIN(GPIO60, "GPIO60"),
+	PINCTRL_PIN(GPIO61, "GPIO61"),
+	PINCTRL_PIN(GPIO62, "GPIO62"),
+	PINCTRL_PIN(GPIO63, "GPIO63"),
+	PINCTRL_PIN(GPIO64, "GPIO64"),
+	PINCTRL_PIN(GPIO65, "GPIO65"),
+	PINCTRL_PIN(GPIO66, "GPIO66"),
+	PINCTRL_PIN(GPIO67, "GPIO67"),
+	PINCTRL_PIN(GPIO68, "GPIO68"),
+	PINCTRL_PIN(GPIO69, "GPIO69"),
+	PINCTRL_PIN(GPIO70, "GPIO70"),
+	PINCTRL_PIN(GPIO71, "GPIO71"),
+	PINCTRL_PIN(GPIO72, "GPIO72"),
+	PINCTRL_PIN(GPIO73, "GPIO73"),
+	PINCTRL_PIN(GPIO74, "GPIO74"),
+	PINCTRL_PIN(GPIO75, "GPIO75"),
+	PINCTRL_PIN(GPIO76, "GPIO76"),
+	PINCTRL_PIN(GPIO77, "GPIO77"),
+	PINCTRL_PIN(GPIO78, "GPIO78"),
+	PINCTRL_PIN(GPIO79, "GPIO79"),
+	PINCTRL_PIN(GPIO80, "GPIO80"),
+	PINCTRL_PIN(GPIO81, "GPIO81"),
+	PINCTRL_PIN(GPIO82, "GPIO82"),
+	PINCTRL_PIN(GPIO83, "GPIO83"),
+	PINCTRL_PIN(GPIO84, "GPIO84"),
+	PINCTRL_PIN(GPIO85, "GPIO85"),
+	PINCTRL_PIN(GPIO86, "GPIO86"),
+	PINCTRL_PIN(GPIO87, "GPIO87"),
+	PINCTRL_PIN(GPIO88, "GPIO88"),
+	PINCTRL_PIN(GPIO89, "GPIO89"),
+	PINCTRL_PIN(GPIO90, "GPIO90"),
+	PINCTRL_PIN(GPIO91, "GPIO91"),
+	PINCTRL_PIN(GPIO92, "GPIO92"),
+	PINCTRL_PIN(GPIO93, "GPIO93"),
+	PINCTRL_PIN(GPIO94, "GPIO94"),
+	PINCTRL_PIN(GPIO95, "GPIO95"),
+	PINCTRL_PIN(GPIO96, "GPIO96"),
+	PINCTRL_PIN(GPIO97, "GPIO97"),
+	PINCTRL_PIN(GPIO98, "GPIO98"),
+	PINCTRL_PIN(GPIO99, "GPIO99"),
+	PINCTRL_PIN(GPIO100, "GPIO100"),
+	PINCTRL_PIN(GPIO101, "GPIO101"),
+	PINCTRL_PIN(GPIO102, "GPIO102"),
+	PINCTRL_PIN(GPIO103, "GPIO103"),
+	PINCTRL_PIN(GPIO104, "GPIO104"),
+	PINCTRL_PIN(GPIO105, "GPIO105"),
+	PINCTRL_PIN(GPIO106, "GPIO106"),
+	PINCTRL_PIN(GPIO107, "GPIO107"),
+	PINCTRL_PIN(GPIO108, "GPIO108"),
+	PINCTRL_PIN(GPIO109, "GPIO109"),
+	PINCTRL_PIN(GPIO110, "GPIO110"),
+	PINCTRL_PIN(GPIO111, "GPIO111"),
+	PINCTRL_PIN(GPIO112, "GPIO112"),
+	PINCTRL_PIN(GPIO113, "GPIO113"),
+	PINCTRL_PIN(GPIO114, "GPIO114"),
+	PINCTRL_PIN(GPIO115, "GPIO115"),
+	PINCTRL_PIN(GPIO116, "GPIO116"),
+	PINCTRL_PIN(GPIO117, "GPIO117"),
+	PINCTRL_PIN(GPIO118, "GPIO118"),
+	PINCTRL_PIN(GPIO119, "GPIO119"),
+	PINCTRL_PIN(GPIO120, "GPIO120"),
+	PINCTRL_PIN(GPIO121, "GPIO121"),
+	PINCTRL_PIN(GPIO122, "GPIO122"),
+	PINCTRL_PIN(GPIO123, "GPIO123"),
+	PINCTRL_PIN(GPIO124, "GPIO124"),
+	PINCTRL_PIN(GPIO125, "GPIO125"),
+	PINCTRL_PIN(GPIO126, "GPIO126"),
+	PINCTRL_PIN(GPIO127, "GPIO127"),
+	PINCTRL_PIN(GPIO128, "GPIO128"),
+	PINCTRL_PIN(GPIO129, "GPIO129"),
+	PINCTRL_PIN(GPIO130, "GPIO130"),
+	PINCTRL_PIN(GPIO131, "GPIO131"),
+	PINCTRL_PIN(GPIO132, "GPIO132"),
+	PINCTRL_PIN(GPIO133, "GPIO133"),
+	PINCTRL_PIN(GPIO134, "GPIO134"),
+	PINCTRL_PIN(GPIO135, "GPIO135"),
+	PINCTRL_PIN(GPIO136, "GPIO136"),
+	PINCTRL_PIN(GPIO137, "GPIO137"),
+	PINCTRL_PIN(GPIO138, "GPIO138"),
+	PINCTRL_PIN(GPIO139, "GPIO139"),
+	PINCTRL_PIN(GPIO140, "GPIO140"),
+	PINCTRL_PIN(GPIO141, "GPIO141"),
+	PINCTRL_PIN(GPIO142, "GPIO142"),
+	PINCTRL_PIN(GPIO143, "GPIO143"),
+	PINCTRL_PIN(GPIO144, "GPIO144"),
+	PINCTRL_PIN(GPIO145, "GPIO145"),
+	PINCTRL_PIN(GPIO146, "GPIO146"),
+	PINCTRL_PIN(GPIO147, "GPIO147"),
+	PINCTRL_PIN(GPIO148, "GPIO148"),
+	PINCTRL_PIN(GPIO149, "GPIO149"),
+	PINCTRL_PIN(GPIO150, "GPIO150"),
+	PINCTRL_PIN(GPIO151, "GPIO151"),
+	PINCTRL_PIN(GPIO152, "GPIO152"),
+	PINCTRL_PIN(GPIO153, "GPIO153"),
+	PINCTRL_PIN(GPIO154, "GPIO154"),
+	PINCTRL_PIN(GPIO155, "GPIO155"),
+	PINCTRL_PIN(GPIO156, "GPIO156"),
+	PINCTRL_PIN(GPIO157, "GPIO157"),
+	PINCTRL_PIN(GPIO158, "GPIO158"),
+	PINCTRL_PIN(GPIO159, "GPIO159"),
+	PINCTRL_PIN(GPIO160, "GPIO160"),
+	PINCTRL_PIN(GPIO161, "GPIO161"),
+	PINCTRL_PIN(GPIO162, "GPIO162"),
+	PINCTRL_PIN(GPIO163, "GPIO163"),
+	PINCTRL_PIN(GPIO164, "GPIO164"),
+	PINCTRL_PIN(GPIO165, "GPIO165"),
+	PINCTRL_PIN(GPIO166, "GPIO166"),
+	PINCTRL_PIN(GPIO167, "GPIO167"),
+	PINCTRL_PIN(GPIO168, "GPIO168"),
+	PINCTRL_PIN(TWSI4_SCL, "TWSI4_SCL"),
+	PINCTRL_PIN(TWSI4_SDA, "TWSI4_SDA"),
+	PINCTRL_PIN(G_CLKREQ, "G_CLKREQ"),
+	PINCTRL_PIN(VCXO_REQ, "VCXO_REQ"),
+	PINCTRL_PIN(VCXO_OUT, "VCXO_OUT"),
+};
+
+struct pxa3xx_mfp_pin mmp2_mfp[] = {
+	/*       pin         offs   f0        f1          f2          f3          f4          f5        f6        f7  */
+	MFPR_MMP2(GPIO0,     0x054, GPIO,     KP_MK,      NONE,       SPI,        NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO1,     0x058, GPIO,     KP_MK,      NONE,       SPI,        NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO2,     0x05C, GPIO,     KP_MK,      NONE,       SPI,        NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO3,     0x060, GPIO,     KP_MK,      NONE,       SPI,        NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO4,     0x064, GPIO,     KP_MK,      NONE,       NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO5,     0x068, GPIO,     KP_MK,      NONE,       SPI,        NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO6,     0x06C, GPIO,     KP_MK,      NONE,       SPI,        NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO7,     0x070, GPIO,     KP_MK,      NONE,       SPI,        NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO8,     0x074, GPIO,     KP_MK,      NONE,       NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO9,     0x078, GPIO,     KP_MK,      NONE,       NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO10,    0x07C, GPIO,     KP_MK,      NONE,       NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO11,    0x080, GPIO,     KP_MK,      NONE,       NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO12,    0x084, GPIO,     KP_MK,      NONE,       CCIC1,      NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO13,    0x088, GPIO,     KP_MK,      NONE,       CCIC1,      NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO14,    0x08C, GPIO,     KP_MK,      NONE,       CCIC1,      NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO15,    0x090, GPIO,     KP_MK,      KP_DK,      CCIC1,      NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO16,    0x094, GPIO,     KP_DK,      ROT,        CCIC1,      NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO17,    0x098, GPIO,     KP_DK,      ROT,        CCIC1,      NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO18,    0x09C, GPIO,     KP_DK,      ROT,        CCIC1,      NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO19,    0x0A0, GPIO,     KP_DK,      ROT,        CCIC1,      NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO20,    0x0A4, GPIO,     KP_DK,      TB,         CCIC1,      NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO21,    0x0A8, GPIO,     KP_DK,      TB,         CCIC1,      NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO22,    0x0AC, GPIO,     KP_DK,      TB,         CCIC1,      NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO23,    0x0B0, GPIO,     KP_DK,      TB,         CCIC1,      NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO24,    0x0B4, GPIO,     I2S,        VCXO_OUT,   NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO25,    0x0B8, GPIO,     I2S,        HDMI,       SSPA2,      NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO26,    0x0BC, GPIO,     I2S,        HDMI,       SSPA2,      NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO27,    0x0C0, GPIO,     I2S,        HDMI,       SSPA2,      NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO28,    0x0C4, GPIO,     I2S,        NONE,       SSPA2,      NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO29,    0x0C8, GPIO,     UART1,      KP_MK,      NONE,       NONE,       NONE,     AAS_SPI,  NONE),
+	MFPR_MMP2(GPIO30,    0x0CC, GPIO,     UART1,      KP_MK,      NONE,       NONE,       NONE,     AAS_SPI,  NONE),
+	MFPR_MMP2(GPIO31,    0x0D0, GPIO,     UART1,      KP_MK,      NONE,       NONE,       NONE,     AAS_SPI,  NONE),
+	MFPR_MMP2(GPIO32,    0x0D4, GPIO,     UART1,      KP_MK,      NONE,       NONE,       NONE,     AAS_SPI,  NONE),
+	MFPR_MMP2(GPIO33,    0x0D8, GPIO,     SSPA2,      I2S,        NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO34,    0x0DC, GPIO,     SSPA2,      I2S,        NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO35,    0x0E0, GPIO,     SSPA2,      I2S,        NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO36,    0x0E4, GPIO,     SSPA2,      I2S,        NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO37,    0x0E8, GPIO,     MMC2,       SSP1,       TWSI2,      UART2,      UART3,    AAS_SPI,  AAS_TWSI),
+	MFPR_MMP2(GPIO38,    0x0EC, GPIO,     MMC2,       SSP1,       TWSI2,      UART2,      UART3,    AAS_SPI,  AAS_TWSI),
+	MFPR_MMP2(GPIO39,    0x0F0, GPIO,     MMC2,       SSP1,       TWSI2,      UART2,      UART3,    AAS_SPI,  AAS_TWSI),
+	MFPR_MMP2(GPIO40,    0x0F4, GPIO,     MMC2,       SSP1,       TWSI2,      UART2,      UART3,    AAS_SPI,  AAS_TWSI),
+	MFPR_MMP2(GPIO41,    0x0F8, GPIO,     MMC2,       TWSI5,      NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO42,    0x0FC, GPIO,     MMC2,       TWSI5,      NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO43,    0x100, GPIO,     TWSI2,      UART4,      SSP1,       UART2,      UART3,    NONE,     AAS_TWSI),
+	MFPR_MMP2(GPIO44,    0x104, GPIO,     TWSI2,      UART4,      SSP1,       UART2,      UART3,    NONE,     AAS_TWSI),
+	MFPR_MMP2(GPIO45,    0x108, GPIO,     UART1,      UART4,      SSP1,       UART2,      UART3,    NONE,     NONE),
+	MFPR_MMP2(GPIO46,    0x10C, GPIO,     UART1,      UART4,      SSP1,       UART2,      UART3,    NONE,     NONE),
+	MFPR_MMP2(GPIO47,    0x110, GPIO,     UART2,      SSP2,       TWSI6,      CAM2,       AAS_SPI,  AAS_GPIO, NONE),
+	MFPR_MMP2(GPIO48,    0x114, GPIO,     UART2,      SSP2,       TWSI6,      CAM2,       AAS_SPI,  AAS_GPIO, NONE),
+	MFPR_MMP2(GPIO49,    0x118, GPIO,     UART2,      SSP2,       PWM,        CCIC2,      AAS_SPI,  NONE,     NONE),
+	MFPR_MMP2(GPIO50,    0x11C, GPIO,     UART2,      SSP2,       PWM,        CCIC2,      AAS_SPI,  NONE,     NONE),
+	MFPR_MMP2(GPIO51,    0x120, GPIO,     UART3,      ROT,        AAS_GPIO,   PWM,        NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO52,    0x124, GPIO,     UART3,      ROT,        AAS_GPIO,   PWM,        NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO53,    0x128, GPIO,     UART3,      TWSI2,      VCXO_REQ,   NONE,       PWM,      NONE,     AAS_TWSI),
+	MFPR_MMP2(GPIO54,    0x12C, GPIO,     UART3,      TWSI2,      VCXO_OUT,   HDMI,       PWM,      NONE,     AAS_TWSI),
+	MFPR_MMP2(GPIO55,    0x130, GPIO,     SSP2,       SSP1,       UART2,      ROT,        TWSI2,    SSP3,     AAS_TWSI),
+	MFPR_MMP2(GPIO56,    0x134, GPIO,     SSP2,       SSP1,       UART2,      ROT,        TWSI2,    KP_DK,    AAS_TWSI),
+	MFPR_MMP2(GPIO57,    0x138, GPIO,     SSP2_RX,    SSP1_TXRX,  SSP2_FRM,   SSP1_RX,    VCXO_REQ, KP_DK,    NONE),
+	MFPR_MMP2(GPIO58,    0x13C, GPIO,     SSP2,       SSP1_RX,    SSP1_FRM,   SSP1_TXRX,  VCXO_REQ, KP_DK,    NONE),
+	MFPR_MMP2(GPIO59,    0x280, GPIO,     CCIC1,      ULPI,       MMC3,       CCIC2,      UART3,    UART4,    NONE),
+	MFPR_MMP2(GPIO60,    0x284, GPIO,     CCIC1,      ULPI,       MMC3,       CCIC2,      UART3,    UART4,    NONE),
+	MFPR_MMP2(GPIO61,    0x288, GPIO,     CCIC1,      ULPI,       MMC3,       CCIC2,      UART3,    HDMI,     NONE),
+	MFPR_MMP2(GPIO62,    0x28C, GPIO,     CCIC1,      ULPI,       MMC3,       CCIC2,      UART3,    NONE,     NONE),
+	MFPR_MMP2(GPIO63,    0x290, GPIO,     CCIC1,      ULPI,       MMC3,       CCIC2,      MSP,      UART4,    NONE),
+	MFPR_MMP2(GPIO64,    0x294, GPIO,     CCIC1,      ULPI,       MMC3,       CCIC2,      MSP,      UART4,    NONE),
+	MFPR_MMP2(GPIO65,    0x298, GPIO,     CCIC1,      ULPI,       MMC3,       CCIC2,      MSP,      UART4,    NONE),
+	MFPR_MMP2(GPIO66,    0x29C, GPIO,     CCIC1,      ULPI,       MMC3,       CCIC2,      MSP,      UART4,    NONE),
+	MFPR_MMP2(GPIO67,    0x2A0, GPIO,     CCIC1,      ULPI,       MMC3,       CCIC2,      MSP,      NONE,     NONE),
+	MFPR_MMP2(GPIO68,    0x2A4, GPIO,     CCIC1,      ULPI,       MMC3,       CCIC2,      MSP,      LCD,      NONE),
+	MFPR_MMP2(GPIO69,    0x2A8, GPIO,     CCIC1,      ULPI,       MMC3,       CCIC2,      NONE,     LCD,      NONE),
+	MFPR_MMP2(GPIO70,    0x2AC, GPIO,     CCIC1,      ULPI,       MMC3,       CCIC2,      MSP,      LCD,      NONE),
+	MFPR_MMP2(GPIO71,    0x2B0, GPIO,     TWSI3,      NONE,       PWM,        NONE,       NONE,     LCD,      AAS_TWSI),
+	MFPR_MMP2(GPIO72,    0x2B4, GPIO,     TWSI3,      HDMI,       PWM,        NONE,       NONE,     LCD,      AAS_TWSI),
+	MFPR_MMP2(GPIO73,    0x2B8, GPIO,     VCXO_REQ,   32K_CLKOUT, PWM,        VCXO_OUT,   NONE,     LCD,      NONE),
+	MFPR_MMP2(GPIO74,    0x170, GPIO,     LCD,        SMC,        MMC4,       SSP3,       UART2,    UART4,    TIPU),
+	MFPR_MMP2(GPIO75,    0x174, GPIO,     LCD,        SMC,        MMC4,       SSP3,       UART2,    UART4,    TIPU),
+	MFPR_MMP2(GPIO76,    0x178, GPIO,     LCD,        SMC,        MMC4,       SSP3,       UART2,    UART4,    TIPU),
+	MFPR_MMP2(GPIO77,    0x17C, GPIO,     LCD,        SMC,        MMC4,       SSP3,       UART2,    UART4,    TIPU),
+	MFPR_MMP2(GPIO78,    0x180, GPIO,     LCD,        HDMI,       MMC4,       NONE,       SSP4,     AAS_SPI,  TIPU),
+	MFPR_MMP2(GPIO79,    0x184, GPIO,     LCD,        AAS_GPIO,   MMC4,       NONE,       SSP4,     AAS_SPI,  TIPU),
+	MFPR_MMP2(GPIO80,    0x188, GPIO,     LCD,        AAS_GPIO,   MMC4,       NONE,       SSP4,     AAS_SPI,  TIPU),
+	MFPR_MMP2(GPIO81,    0x18C, GPIO,     LCD,        AAS_GPIO,   MMC4,       NONE,       SSP4,     AAS_SPI,  TIPU),
+	MFPR_MMP2(GPIO82,    0x190, GPIO,     LCD,        NONE,       MMC4,       NONE,       NONE,     CCIC2,    TIPU),
+	MFPR_MMP2(GPIO83,    0x194, GPIO,     LCD,        NONE,       MMC4,       NONE,       NONE,     CCIC2,    TIPU),
+	MFPR_MMP2(GPIO84,    0x198, GPIO,     LCD,        SMC,        MMC2,       NONE,       TWSI5,    AAS_TWSI, TIPU),
+	MFPR_MMP2(GPIO85,    0x19C, GPIO,     LCD,        SMC,        MMC2,       NONE,       TWSI5,    AAS_TWSI, TIPU),
+	MFPR_MMP2(GPIO86,    0x1A0, GPIO,     LCD,        SMC,        MMC2,       NONE,       TWSI6,    CCIC2,    TIPU),
+	MFPR_MMP2(GPIO87,    0x1A4, GPIO,     LCD,        SMC,        MMC2,       NONE,       TWSI6,    CCIC2,    TIPU),
+	MFPR_MMP2(GPIO88,    0x1A8, GPIO,     LCD,        AAS_GPIO,   MMC2,       NONE,       NONE,     CCIC2,    TIPU),
+	MFPR_MMP2(GPIO89,    0x1AC, GPIO,     LCD,        AAS_GPIO,   MMC2,       NONE,       NONE,     CCIC2,    TIPU),
+	MFPR_MMP2(GPIO90,    0x1B0, GPIO,     LCD,        AAS_GPIO,   MMC2,       NONE,       NONE,     CCIC2,    TIPU),
+	MFPR_MMP2(GPIO91,    0x1B4, GPIO,     LCD,        AAS_GPIO,   MMC2,       NONE,       NONE,     CCIC2,    TIPU),
+	MFPR_MMP2(GPIO92,    0x1B8, GPIO,     LCD,        AAS_GPIO,   MMC2,       NONE,       NONE,     CCIC2,    TIPU),
+	MFPR_MMP2(GPIO93,    0x1BC, GPIO,     LCD,        AAS_GPIO,   MMC2,       NONE,       NONE,     CCIC2,    TIPU),
+	MFPR_MMP2(GPIO94,    0x1C0, GPIO,     LCD,        AAS_GPIO,   SPI,        NONE,       AAS_SPI,  CCIC2,    TIPU),
+	MFPR_MMP2(GPIO95,    0x1C4, GPIO,     LCD,        TWSI3,      SPI,        AAS_DEU_EX, AAS_SPI,  CCIC2,    TIPU),
+	MFPR_MMP2(GPIO96,    0x1C8, GPIO,     LCD,        TWSI3,      SPI,        AAS_DEU_EX, AAS_SPI,  NONE,     TIPU),
+	MFPR_MMP2(GPIO97,    0x1CC, GPIO,     LCD,        TWSI6,      SPI,        AAS_DEU_EX, AAS_SPI,  NONE,     TIPU),
+	MFPR_MMP2(GPIO98,    0x1D0, GPIO,     LCD,        TWSI6,      SPI,        ONE_WIRE,   NONE,     NONE,     TIPU),
+	MFPR_MMP2(GPIO99,    0x1D4, GPIO,     LCD,        SMC,        SPI,        TWSI5,      NONE,     NONE,     TIPU),
+	MFPR_MMP2(GPIO100,   0x1D8, GPIO,     LCD,        SMC,        SPI,        TWSI5,      NONE,     NONE,     TIPU),
+	MFPR_MMP2(GPIO101,   0x1DC, GPIO,     LCD,        SMC,        SPI,        NONE,       NONE,     NONE,     TIPU),
+	MFPR_MMP2(GPIO102,   0x000, USIM,     GPIO,       FSIC,       KP_DK,      LCD,        NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO103,   0x004, USIM,     GPIO,       FSIC,       KP_DK,      LCD,        NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO104,   0x1FC, NAND,     GPIO,       NONE,       NONE,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO105,   0x1F8, NAND,     GPIO,       NONE,       NONE,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO106,   0x1F4, NAND,     GPIO,       NONE,       NONE,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO107,   0x1F0, NAND,     GPIO,       NONE,       NONE,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO108,   0x21C, NAND,     GPIO,       NONE,       NONE,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO109,   0x218, NAND,     GPIO,       NONE,       NONE,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO110,   0x214, NAND,     GPIO,       NONE,       NONE,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO111,   0x200, NAND,     GPIO,       MMC3,       NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO112,   0x244, NAND,     GPIO,       MMC3,       SMC,        NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO113,   0x25C, SMC,      GPIO,       EXT_DMA,    MMC3,       SMC,        HDMI,     NONE,     NONE),
+	MFPR_MMP2(GPIO114,   0x164, G_CLKOUT, 32K_CLKOUT, HDMI,       NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO115,   0x260, GPIO,     NONE,       AC,         UART4,      UART3,      SSP1,     NONE,     NONE),
+	MFPR_MMP2(GPIO116,   0x264, GPIO,     NONE,       AC,         UART4,      UART3,      SSP1,     NONE,     NONE),
+	MFPR_MMP2(GPIO117,   0x268, GPIO,     NONE,       AC,         UART4,      UART3,      SSP1,     NONE,     NONE),
+	MFPR_MMP2(GPIO118,   0x26C, GPIO,     NONE,       AC,         UART4,      UART3,      SSP1,     NONE,     NONE),
+	MFPR_MMP2(GPIO119,   0x270, GPIO,     NONE,       CA,         SSP3,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO120,   0x274, GPIO,     NONE,       CA,         SSP3,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO121,   0x278, GPIO,     NONE,       CA,         SSP3,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO122,   0x27C, GPIO,     NONE,       CA,         SSP3,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO123,   0x148, GPIO,     SLEEP_IND,  ONE_WIRE,   32K_CLKOUT, NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO124,   0x00C, GPIO,     MMC1,       LCD,        MMC3,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO125,   0x010, GPIO,     MMC1,       LCD,        MMC3,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO126,   0x014, GPIO,     MMC1,       LCD,        MMC3,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO127,   0x018, GPIO,     NONE,       LCD,        MMC3,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO128,   0x01C, GPIO,     NONE,       LCD,        MMC3,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO129,   0x020, GPIO,     MMC1,       LCD,        MMC3,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO130,   0x024, GPIO,     MMC1,       LCD,        MMC3,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO131,   0x028, GPIO,     MMC1,       NONE,       MSP,        NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO132,   0x02C, GPIO,     MMC1,       PRI_JTAG,   MSP,        SSP3,       AAS_JTAG, NONE,     NONE),
+	MFPR_MMP2(GPIO133,   0x030, GPIO,     MMC1,       PRI_JTAG,   MSP,        SSP3,       AAS_JTAG, NONE,     NONE),
+	MFPR_MMP2(GPIO134,   0x034, GPIO,     MMC1,       PRI_JTAG,   MSP,        SSP3,       AAS_JTAG, NONE,     NONE),
+	MFPR_MMP2(GPIO135,   0x038, GPIO,     NONE,       LCD,        MMC3,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO136,   0x03C, GPIO,     MMC1,       PRI_JTAG,   MSP,        SSP3,       AAS_JTAG, NONE,     NONE),
+	MFPR_MMP2(GPIO137,   0x040, GPIO,     HDMI,       LCD,        MSP,        NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO138,   0x044, GPIO,     NONE,       LCD,        MMC3,       SMC,        NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO139,   0x048, GPIO,     MMC1,       PRI_JTAG,   MSP,        NONE,       AAS_JTAG, NONE,     NONE),
+	MFPR_MMP2(GPIO140,   0x04C, GPIO,     MMC1,       LCD,        NONE,       NONE,       UART2,    UART1,    NONE),
+	MFPR_MMP2(GPIO141,   0x050, GPIO,     MMC1,       LCD,        NONE,       NONE,       UART2,    UART1,    NONE),
+	MFPR_MMP2(GPIO142,   0x008, USIM,     GPIO,       FSIC,       KP_DK,      NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO143,   0x220, NAND,     GPIO,       SMC,        NONE,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO144,   0x224, NAND,     GPIO,       SMC_INT,    SMC,        NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO145,   0x228, SMC,      GPIO,       NONE,       NONE,       SMC,        NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO146,   0x22C, SMC,      GPIO,       NONE,       NONE,       SMC,        NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO147,   0x230, NAND,     GPIO,       NONE,       NONE,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO148,   0x234, NAND,     GPIO,       NONE,       NONE,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO149,   0x238, NAND,     GPIO,       NONE,       NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO150,   0x23C, NAND,     GPIO,       NONE,       NONE,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO151,   0x240, SMC,      GPIO,       MMC3,       NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO152,   0x248, SMC,      GPIO,       NONE,       NONE,       SMC,        NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO153,   0x24C, SMC,      GPIO,       NONE,       NONE,       SMC,        NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO154,   0x254, SMC_INT,  GPIO,       SMC,        NONE,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO155,   0x258, EXT_DMA,  GPIO,       SMC,        NONE,       EXT_DMA,    NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO156,   0x14C, PRI_JTAG, GPIO,       PWM,        NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO157,   0x150, PRI_JTAG, GPIO,       PWM,        NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO158,   0x154, PRI_JTAG, GPIO,       PWM,        NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO159,   0x158, PRI_JTAG, GPIO,       PWM,        NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO160,   0x250, NAND,     GPIO,       SMC,        NONE,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO161,   0x210, NAND,     GPIO,       NONE,       NONE,       NAND,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO162,   0x20C, NAND,     GPIO,       MMC3,       NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO163,   0x208, NAND,     GPIO,       MMC3,       NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO164,   0x204, NAND,     GPIO,       MMC3,       NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO165,   0x1EC, NAND,     GPIO,       MMC3,       NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO166,   0x1E8, NAND,     GPIO,       MMC3,       NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO167,   0x1E4, NAND,     GPIO,       MMC3,       NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(GPIO168,   0x1E0, NAND,     GPIO,       MMC3,       NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(TWSI4_SCL, 0x2BC, TWSI4,    LCD,        NONE,       NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(TWSI4_SDA, 0x2C0, TWSI4,    LCD,        NONE,       NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(G_CLKREQ,  0x160, G_CLKREQ, ONE_WIRE,   NONE,       NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(VCXO_REQ,  0x168, VCXO_REQ, ONE_WIRE,   PLL,        NONE,       NONE,       NONE,     NONE,     NONE),
+	MFPR_MMP2(VCXO_OUT,  0x16C, VCXO_OUT, 32K_CLKOUT, NONE,       NONE,       NONE,       NONE,     NONE,     NONE),
+};
+
+static const unsigned mmp2_uart1_pin1[] = {GPIO29, GPIO30, GPIO31, GPIO32};
+static const unsigned mmp2_uart1_pin2[] = {GPIO45, GPIO46};
+static const unsigned mmp2_uart1_pin3[] = {GPIO140, GPIO141};
+static const unsigned mmp2_uart2_pin1[] = {GPIO37, GPIO38, GPIO39, GPIO40};
+static const unsigned mmp2_uart2_pin2[] = {GPIO43, GPIO44, GPIO45, GPIO46};
+static const unsigned mmp2_uart2_pin3[] = {GPIO47, GPIO48, GPIO49, GPIO50};
+static const unsigned mmp2_uart2_pin4[] = {GPIO74, GPIO75, GPIO76, GPIO77};
+static const unsigned mmp2_uart2_pin5[] = {GPIO55, GPIO56};
+static const unsigned mmp2_uart2_pin6[] = {GPIO140, GPIO141};
+static const unsigned mmp2_uart3_pin1[] = {GPIO37, GPIO38, GPIO39, GPIO40};
+static const unsigned mmp2_uart3_pin2[] = {GPIO43, GPIO44, GPIO45, GPIO46};
+static const unsigned mmp2_uart3_pin3[] = {GPIO51, GPIO52, GPIO53, GPIO54};
+static const unsigned mmp2_uart3_pin4[] = {GPIO59, GPIO60, GPIO61, GPIO62};
+static const unsigned mmp2_uart3_pin5[] = {GPIO115, GPIO116, GPIO117, GPIO118};
+static const unsigned mmp2_uart3_pin6[] = {GPIO51, GPIO52};
+static const unsigned mmp2_uart4_pin1[] = {GPIO43, GPIO44, GPIO45, GPIO46};
+static const unsigned mmp2_uart4_pin2[] = {GPIO63, GPIO64, GPIO65, GPIO66};
+static const unsigned mmp2_uart4_pin3[] = {GPIO74, GPIO75, GPIO76, GPIO77};
+static const unsigned mmp2_uart4_pin4[] = {GPIO115, GPIO116, GPIO117, GPIO118};
+static const unsigned mmp2_uart4_pin5[] = {GPIO59, GPIO60};
+static const unsigned mmp2_kpdk_pin1[] = {GPIO16, GPIO17, GPIO18, GPIO19};
+static const unsigned mmp2_kpdk_pin2[] = {GPIO16, GPIO17};
+static const unsigned mmp2_twsi2_pin1[] = {GPIO37, GPIO38};
+static const unsigned mmp2_twsi2_pin2[] = {GPIO39, GPIO40};
+static const unsigned mmp2_twsi2_pin3[] = {GPIO43, GPIO44};
+static const unsigned mmp2_twsi2_pin4[] = {GPIO53, GPIO54};
+static const unsigned mmp2_twsi2_pin5[] = {GPIO55, GPIO56};
+static const unsigned mmp2_twsi3_pin1[] = {GPIO71, GPIO72};
+static const unsigned mmp2_twsi3_pin2[] = {GPIO95, GPIO96};
+static const unsigned mmp2_twsi4_pin1[] = {TWSI4_SCL, TWSI4_SDA};
+static const unsigned mmp2_twsi5_pin1[] = {GPIO41, GPIO42};
+static const unsigned mmp2_twsi5_pin2[] = {GPIO84, GPIO85};
+static const unsigned mmp2_twsi5_pin3[] = {GPIO99, GPIO100};
+static const unsigned mmp2_twsi6_pin1[] = {GPIO47, GPIO48};
+static const unsigned mmp2_twsi6_pin2[] = {GPIO86, GPIO87};
+static const unsigned mmp2_twsi6_pin3[] = {GPIO97, GPIO98};
+static const unsigned mmp2_ccic1_pin1[] = {GPIO12, GPIO13, GPIO14, GPIO15,
+	GPIO16, GPIO17, GPIO18, GPIO19, GPIO20, GPIO21, GPIO22, GPIO23};
+static const unsigned mmp2_ccic1_pin2[] = {GPIO59, GPIO60, GPIO61, GPIO62,
+	GPIO63, GPIO64, GPIO65, GPIO66, GPIO67, GPIO68, GPIO69, GPIO70};
+static const unsigned mmp2_ccic2_pin1[] = {GPIO59, GPIO60, GPIO61, GPIO62,
+	GPIO63, GPIO64, GPIO65, GPIO66, GPIO67, GPIO68, GPIO69, GPIO70};
+static const unsigned mmp2_ccic2_pin2[] = {GPIO82, GPIO83, GPIO86, GPIO87,
+	GPIO88, GPIO89, GPIO90, GPIO91, GPIO92, GPIO93, GPIO94, GPIO95};
+static const unsigned mmp2_ulpi_pin1[] = {GPIO59, GPIO60, GPIO61, GPIO62,
+	GPIO63, GPIO64, GPIO65, GPIO66, GPIO67, GPIO68, GPIO69, GPIO70};
+static const unsigned mmp2_ro_pin1[] = {GPIO16, GPIO17};
+static const unsigned mmp2_ro_pin2[] = {GPIO18, GPIO19};
+static const unsigned mmp2_ro_pin3[] = {GPIO51, GPIO52};
+static const unsigned mmp2_ro_pin4[] = {GPIO55, GPIO56};
+static const unsigned mmp2_i2s_pin1[] = {GPIO24, GPIO25, GPIO26, GPIO27,
+	GPIO28};
+static const unsigned mmp2_i2s_pin2[] = {GPIO33, GPIO34, GPIO35, GPIO36};
+static const unsigned mmp2_ssp1_pin1[] = {GPIO37, GPIO38, GPIO39, GPIO40};
+static const unsigned mmp2_ssp1_pin2[] = {GPIO43, GPIO44, GPIO45, GPIO46};
+static const unsigned mmp2_ssp1_pin3[] = {GPIO115, GPIO116, GPIO117, GPIO118};
+static const unsigned mmp2_ssp2_pin1[] = {GPIO47, GPIO48, GPIO49, GPIO50};
+static const unsigned mmp2_ssp3_pin1[] = {GPIO119, GPIO120, GPIO121, GPIO122};
+static const unsigned mmp2_ssp3_pin2[] = {GPIO132, GPIO133, GPIO133, GPIO136};
+static const unsigned mmp2_sspa2_pin1[] = {GPIO25, GPIO26, GPIO27, GPIO28};
+static const unsigned mmp2_sspa2_pin2[] = {GPIO33, GPIO34, GPIO35, GPIO36};
+static const unsigned mmp2_mmc1_pin1[] = {GPIO131, GPIO132, GPIO133, GPIO134,
+	GPIO136, GPIO139, GPIO140, GPIO141};
+static const unsigned mmp2_mmc2_pin1[] = {GPIO37, GPIO38, GPIO39, GPIO40,
+	GPIO41, GPIO42};
+static const unsigned mmp2_mmc3_pin1[] = {GPIO111, GPIO112, GPIO151, GPIO162,
+	GPIO163, GPIO164, GPIO165, GPIO166, GPIO167, GPIO168};
+
+static struct pxa3xx_pin_group mmp2_grps[] = {
+	GRP_MMP2("uart1 4p1", UART1, mmp2_uart1_pin1),
+	GRP_MMP2("uart1 2p2", UART1, mmp2_uart1_pin2),
+	GRP_MMP2("uart1 2p3", UART1, mmp2_uart1_pin3),
+	GRP_MMP2("uart2 4p1", UART2, mmp2_uart2_pin1),
+	GRP_MMP2("uart2 4p2", UART2, mmp2_uart2_pin2),
+	GRP_MMP2("uart2 4p3", UART2, mmp2_uart2_pin3),
+	GRP_MMP2("uart2 4p4", UART2, mmp2_uart2_pin4),
+	GRP_MMP2("uart2 2p5", UART2, mmp2_uart2_pin5),
+	GRP_MMP2("uart2 2p6", UART2, mmp2_uart2_pin6),
+	GRP_MMP2("uart3 4p1", UART3, mmp2_uart3_pin1),
+	GRP_MMP2("uart3 4p2", UART3, mmp2_uart3_pin2),
+	GRP_MMP2("uart3 4p3", UART3, mmp2_uart3_pin3),
+	GRP_MMP2("uart3 4p4", UART3, mmp2_uart3_pin4),
+	GRP_MMP2("uart3 4p5", UART3, mmp2_uart3_pin5),
+	GRP_MMP2("uart3 2p6", UART3, mmp2_uart3_pin6),
+	GRP_MMP2("uart4 4p1", UART4, mmp2_uart4_pin1),
+	GRP_MMP2("uart4 4p2", UART4, mmp2_uart4_pin2),
+	GRP_MMP2("uart4 4p3", UART4, mmp2_uart4_pin3),
+	GRP_MMP2("uart4 4p4", UART4, mmp2_uart4_pin4),
+	GRP_MMP2("uart4 2p5", UART4, mmp2_uart4_pin5),
+	GRP_MMP2("kpdk 4p1", KP_DK, mmp2_kpdk_pin1),
+	GRP_MMP2("kpdk 4p2", KP_DK, mmp2_kpdk_pin2),
+	GRP_MMP2("twsi2-1", TWSI2, mmp2_twsi2_pin1),
+	GRP_MMP2("twsi2-2", TWSI2, mmp2_twsi2_pin2),
+	GRP_MMP2("twsi2-3", TWSI2, mmp2_twsi2_pin3),
+	GRP_MMP2("twsi2-4", TWSI2, mmp2_twsi2_pin4),
+	GRP_MMP2("twsi2-5", TWSI2, mmp2_twsi2_pin5),
+	GRP_MMP2("twsi3-1", TWSI3, mmp2_twsi3_pin1),
+	GRP_MMP2("twsi3-2", TWSI3, mmp2_twsi3_pin2),
+	GRP_MMP2("twsi4", TWSI4, mmp2_twsi4_pin1),
+	GRP_MMP2("twsi5-1", TWSI5, mmp2_twsi5_pin1),
+	GRP_MMP2("twsi5-2", TWSI5, mmp2_twsi5_pin2),
+	GRP_MMP2("twsi5-3", TWSI5, mmp2_twsi5_pin3),
+	GRP_MMP2("twsi6-1", TWSI6, mmp2_twsi6_pin1),
+	GRP_MMP2("twsi6-2", TWSI6, mmp2_twsi6_pin2),
+	GRP_MMP2("twsi6-3", TWSI6, mmp2_twsi6_pin3),
+	GRP_MMP2("ccic1-1", CCIC1, mmp2_ccic1_pin1),
+	GRP_MMP2("ccic1-2", CCIC1, mmp2_ccic1_pin2),
+	GRP_MMP2("ccic2-1", CCIC2, mmp2_ccic2_pin1),
+	GRP_MMP2("ccic2-1", CCIC2, mmp2_ccic2_pin2),
+	GRP_MMP2("ulpi", ULPI, mmp2_ulpi_pin1),
+	GRP_MMP2("ro-1", ROT, mmp2_ro_pin1),
+	GRP_MMP2("ro-2", ROT, mmp2_ro_pin2),
+	GRP_MMP2("ro-3", ROT, mmp2_ro_pin3),
+	GRP_MMP2("ro-4", ROT, mmp2_ro_pin4),
+	GRP_MMP2("i2s 5p1", I2S, mmp2_i2s_pin1),
+	GRP_MMP2("i2s 4p2", I2S, mmp2_i2s_pin2),
+	GRP_MMP2("ssp1 4p1", SSP1, mmp2_ssp1_pin1),
+	GRP_MMP2("ssp1 4p2", SSP1, mmp2_ssp1_pin2),
+	GRP_MMP2("ssp1 4p3", SSP1, mmp2_ssp1_pin3),
+	GRP_MMP2("ssp2 4p1", SSP2, mmp2_ssp2_pin1),
+	GRP_MMP2("ssp3 4p1", SSP3, mmp2_ssp3_pin1),
+	GRP_MMP2("ssp3 4p2", SSP3, mmp2_ssp3_pin2),
+	GRP_MMP2("sspa2 4p1", SSPA2, mmp2_sspa2_pin1),
+	GRP_MMP2("sspa2 4p2", SSPA2, mmp2_sspa2_pin2),
+	GRP_MMP2("mmc1 8p1", MMC1, mmp2_mmc1_pin1),
+	GRP_MMP2("mmc2 6p1", MMC2, mmp2_mmc2_pin1),
+	GRP_MMP2("mmc3 10p1", MMC3, mmp2_mmc3_pin1),
+};
+
+static const char * const mmp2_uart1_grps[] = {"uart1 4p1", "uart1 2p2",
+	"uart1 2p3"};
+static const char * const mmp2_uart2_grps[] = {"uart2 4p1", "uart2 4p2",
+	"uart2 4p3", "uart2 4p4", "uart2 4p5", "uart2 4p6"};
+static const char * const mmp2_uart3_grps[] = {"uart3 4p1", "uart3 4p2",
+	"uart3 4p3", "uart3 4p4", "uart3 4p5", "uart3 2p6"};
+static const char * const mmp2_uart4_grps[] = {"uart4 4p1", "uart4 4p2",
+	"uart4 4p3", "uart4 4p4", "uart4 2p5"};
+static const char * const mmp2_kpdk_grps[] = {"kpdk 4p1", "kpdk 4p2"};
+static const char * const mmp2_twsi2_grps[] = {"twsi2-1", "twsi2-2",
+	"twsi2-3", "twsi2-4", "twsi2-5"};
+static const char * const mmp2_twsi3_grps[] = {"twsi3-1", "twsi3-2"};
+static const char * const mmp2_twsi4_grps[] = {"twsi4"};
+static const char * const mmp2_twsi5_grps[] = {"twsi5-1", "twsi5-2",
+	"twsi5-3"};
+static const char * const mmp2_twsi6_grps[] = {"twsi6-1", "twsi6-2",
+	"twsi6-3"};
+static const char * const mmp2_ccic1_grps[] = {"ccic1-1", "ccic1-2"};
+static const char * const mmp2_ccic2_grps[] = {"ccic2-1", "ccic2-2"};
+static const char * const mmp2_ulpi_grps[] = {"ulpi"};
+static const char * const mmp2_ro_grps[] = {"ro-1", "ro-2", "ro-3", "ro-4"};
+static const char * const mmp2_i2s_grps[] = {"i2s 5p1", "i2s 4p2"};
+static const char * const mmp2_ssp1_grps[] = {"ssp1 4p1", "ssp1 4p2",
+	"ssp1 4p3"};
+static const char * const mmp2_ssp2_grps[] = {"ssp2 4p1"};
+static const char * const mmp2_ssp3_grps[] = {"ssp3 4p1", "ssp3 4p2"};
+static const char * const mmp2_sspa2_grps[] = {"sspa2 4p1", "sspa2 4p2"};
+static const char * const mmp2_mmc1_grps[] = {"mmc1 8p1"};
+static const char * const mmp2_mmc2_grps[] = {"mmc2 6p1"};
+static const char * const mmp2_mmc3_grps[] = {"mmc3 10p1"};
+
+static struct pxa3xx_pmx_func mmp2_funcs[] = {
+        {"uart1",	ARRAY_AND_SIZE(mmp2_uart1_grps)},
+        {"uart2",	ARRAY_AND_SIZE(mmp2_uart2_grps)},
+        {"uart3",	ARRAY_AND_SIZE(mmp2_uart3_grps)},
+        {"uart4",	ARRAY_AND_SIZE(mmp2_uart4_grps)},
+        {"kpdk",	ARRAY_AND_SIZE(mmp2_kpdk_grps)},
+        {"twsi2",	ARRAY_AND_SIZE(mmp2_twsi2_grps)},
+        {"twsi3",	ARRAY_AND_SIZE(mmp2_twsi3_grps)},
+        {"twsi4",	ARRAY_AND_SIZE(mmp2_twsi4_grps)},
+        {"twsi5",	ARRAY_AND_SIZE(mmp2_twsi5_grps)},
+        {"twsi6",	ARRAY_AND_SIZE(mmp2_twsi6_grps)},
+        {"ccic1",	ARRAY_AND_SIZE(mmp2_ccic1_grps)},
+        {"ccic2",	ARRAY_AND_SIZE(mmp2_ccic2_grps)},
+        {"ulpi",	ARRAY_AND_SIZE(mmp2_ulpi_grps)},
+        {"ro",		ARRAY_AND_SIZE(mmp2_ro_grps)},
+        {"i2s",		ARRAY_AND_SIZE(mmp2_i2s_grps)},
+        {"ssp1",	ARRAY_AND_SIZE(mmp2_ssp1_grps)},
+        {"ssp2",	ARRAY_AND_SIZE(mmp2_ssp2_grps)},
+        {"ssp3",	ARRAY_AND_SIZE(mmp2_ssp3_grps)},
+        {"sspa2",	ARRAY_AND_SIZE(mmp2_sspa2_grps)},
+        {"mmc1",	ARRAY_AND_SIZE(mmp2_mmc1_grps)},
+        {"mmc2",	ARRAY_AND_SIZE(mmp2_mmc2_grps)},
+        {"mmc3",	ARRAY_AND_SIZE(mmp2_mmc3_grps)},
+};
+
+static struct pinctrl_desc mmp2_pctrl_desc = {
+	.name		= "mmp2-pinctrl",
+	.maxpin		= 260,
+	.owner		= THIS_MODULE,
+};
+
+static struct pxa3xx_pinmux_info mmp2_info = {
+	.mfp		= mmp2_mfp,
+	.num_mfp	= ARRAY_SIZE(mmp2_mfp),
+	.grps		= mmp2_grps,
+	.num_grps	= ARRAY_SIZE(mmp2_grps),
+	.funcs		= mmp2_funcs,
+	.num_funcs	= ARRAY_SIZE(mmp2_funcs),
+	.num_gpio	= 169,
+	.desc		= &mmp2_pctrl_desc,
+	.pads		= mmp2_pads,
+	.num_pads	= ARRAY_SIZE(mmp2_pads),
+
+	.cputype	= PINCTRL_MMP2,
+	.ds_mask	= MMP2_DS_MASK,
+	.ds_shift	= MMP2_DS_SHIFT,
+};
+
+static int __devinit mmp2_pinmux_probe(struct platform_device *pdev)
+{
+	return pxa3xx_pinctrl_register(pdev, &mmp2_info);
+}
+
+static int __devexit mmp2_pinmux_remove(struct platform_device *pdev)
+{
+	return pxa3xx_pinctrl_unregister(pdev);
+}
+
+static struct platform_driver mmp2_pinmux_driver = {
+	.driver = {
+		.name	= "mmp2-pinmux",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= mmp2_pinmux_probe,
+	.remove	= __devexit_p(mmp2_pinmux_remove),
+};
+
+static int __init mmp2_pinmux_init(void)
+{
+	return platform_driver_register(&mmp2_pinmux_driver);
+}
+core_initcall_sync(mmp2_pinmux_init);
+
+static void __exit mmp2_pinmux_exit(void)
+{
+	platform_driver_unregister(&mmp2_pinmux_driver);
+}
+module_exit(mmp2_pinmux_exit);
+
+MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
+MODULE_DESCRIPTION("PXA3xx pin control driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/pinctrl/pinctrl-pxa168.c b/drivers/pinctrl/pinctrl-pxa168.c
new file mode 100644
index 0000000..92c902e
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-pxa168.c
@@ -0,0 +1,652 @@
+/*
+ *  linux/drivers/pinctrl/pinmux-pxa168.c
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ *
+ *  Copyright (C) 2011, Marvell Technology Group Ltd.
+ *
+ *  Author: Haojian Zhuang <haojian.zhuang@marvell.com>
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include "pinctrl-pxa3xx.h"
+
+#define PXA168_DS_MASK		0x1800
+#define PXA168_DS_SHIFT		11
+#define PXA168_SLEEP_MASK	0x38
+#define PXA168_SLEEP_SELECT	(1 << 9)
+#define PXA168_SLEEP_DATA	(1 << 8)
+#define PXA168_SLEEP_DIR	(1 << 7)
+
+#define MFPR_168(a, r, f0, f1, f2, f3, f4, f5, f6, f7)		\
+	{							\
+		.name = #a,					\
+		.pin = a,					\
+		.mfpr = r,					\
+		.func = {					\
+			PXA168_MUX_##f0,			\
+			PXA168_MUX_##f1,			\
+			PXA168_MUX_##f2,			\
+			PXA168_MUX_##f3,			\
+			PXA168_MUX_##f4,			\
+			PXA168_MUX_##f5,			\
+			PXA168_MUX_##f6,			\
+			PXA168_MUX_##f7,			\
+		},						\
+	}
+
+#define GRP_168(a, m, p)		\
+	{ .name = a, .mux = PXA168_MUX_##m, .pins = p, .npins = ARRAY_SIZE(p), }
+
+/* 131 pins */
+enum pxa168_pin_list {
+	/* 0~122: GPIO0~GPIO122 */
+	PWR_SCL = 123,
+	PWR_SDA,
+	TDI,
+	TMS,
+	TCK,
+	TDO,
+	TRST,
+	WAKEUP = 130,
+};
+
+enum pxa168_mux {
+	/* PXA3xx_MUX_GPIO = 0 (predefined in pinctrl-pxa3xx.h) */
+	PXA168_MUX_GPIO = 0,
+	PXA168_MUX_DFIO,
+	PXA168_MUX_NAND,
+	PXA168_MUX_SMC,
+	PXA168_MUX_SMC_CS0,
+	PXA168_MUX_SMC_CS1,
+	PXA168_MUX_SMC_INT,
+	PXA168_MUX_SMC_RDY,
+	PXA168_MUX_MMC1,
+	PXA168_MUX_MMC2,
+	PXA168_MUX_MMC2_CMD,
+	PXA168_MUX_MMC2_CLK,
+	PXA168_MUX_MMC3,
+	PXA168_MUX_MMC3_CMD,
+	PXA168_MUX_MMC3_CLK,
+	PXA168_MUX_MMC4,
+	PXA168_MUX_MSP,
+	PXA168_MUX_MSP_DAT3,
+	PXA168_MUX_MSP_INS,
+	PXA168_MUX_I2C,
+	PXA168_MUX_PWRI2C,
+	PXA168_MUX_AC97,
+	PXA168_MUX_AC97_SYSCLK,
+	PXA168_MUX_PWM,
+	PXA168_MUX_PWM1,
+	PXA168_MUX_XD,
+	PXA168_MUX_XP,
+	PXA168_MUX_LCD,
+	PXA168_MUX_CCIC,
+	PXA168_MUX_CF,
+	PXA168_MUX_CF_RDY,
+	PXA168_MUX_CF_nINPACK,
+	PXA168_MUX_CF_nWAIT,
+	PXA168_MUX_KP_MKOUT,
+	PXA168_MUX_KP_MKIN,
+	PXA168_MUX_KP_DK,
+	PXA168_MUX_ETH,
+	PXA168_MUX_ETH_TX,
+	PXA168_MUX_ETH_RX,
+	PXA168_MUX_ONE_WIRE,
+	PXA168_MUX_UART1,
+	PXA168_MUX_UART1_TX,
+	PXA168_MUX_UART1_CTS,
+	PXA168_MUX_UART1_nRI,
+	PXA168_MUX_UART1_DTR,
+	PXA168_MUX_UART2,
+	PXA168_MUX_UART2_TX,
+	PXA168_MUX_UART3,
+	PXA168_MUX_UART3_TX,
+	PXA168_MUX_UART3_CTS,
+	PXA168_MUX_SSP1,
+	PXA168_MUX_SSP1_TX,
+	PXA168_MUX_SSP2,
+	PXA168_MUX_SSP2_TX,
+	PXA168_MUX_SSP3,
+	PXA168_MUX_SSP3_TX,
+	PXA168_MUX_SSP4,
+	PXA168_MUX_SSP4_TX,
+	PXA168_MUX_SSP5,
+	PXA168_MUX_SSP5_TX,
+	PXA168_MUX_USB,
+	PXA168_MUX_JTAG,
+	PXA168_MUX_RESET,
+	PXA168_MUX_WAKEUP,
+	PXA168_MUX_EXT_32K_IN,
+	PXA168_MUX_NONE = 0xffff,
+};
+
+static struct pinctrl_pin_desc pxa168_pads[] = {
+	PINCTRL_PIN(GPIO0, "GPIO0"),
+	PINCTRL_PIN(GPIO1, "GPIO1"),
+	PINCTRL_PIN(GPIO2, "GPIO2"),
+	PINCTRL_PIN(GPIO3, "GPIO3"),
+	PINCTRL_PIN(GPIO4, "GPIO4"),
+	PINCTRL_PIN(GPIO5, "GPIO5"),
+	PINCTRL_PIN(GPIO6, "GPIO6"),
+	PINCTRL_PIN(GPIO7, "GPIO7"),
+	PINCTRL_PIN(GPIO8, "GPIO8"),
+	PINCTRL_PIN(GPIO9, "GPIO9"),
+	PINCTRL_PIN(GPIO10, "GPIO10"),
+	PINCTRL_PIN(GPIO11, "GPIO11"),
+	PINCTRL_PIN(GPIO12, "GPIO12"),
+	PINCTRL_PIN(GPIO13, "GPIO13"),
+	PINCTRL_PIN(GPIO14, "GPIO14"),
+	PINCTRL_PIN(GPIO15, "GPIO15"),
+	PINCTRL_PIN(GPIO16, "GPIO16"),
+	PINCTRL_PIN(GPIO17, "GPIO17"),
+	PINCTRL_PIN(GPIO18, "GPIO18"),
+	PINCTRL_PIN(GPIO19, "GPIO19"),
+	PINCTRL_PIN(GPIO20, "GPIO20"),
+	PINCTRL_PIN(GPIO21, "GPIO21"),
+	PINCTRL_PIN(GPIO22, "GPIO22"),
+	PINCTRL_PIN(GPIO23, "GPIO23"),
+	PINCTRL_PIN(GPIO24, "GPIO24"),
+	PINCTRL_PIN(GPIO25, "GPIO25"),
+	PINCTRL_PIN(GPIO26, "GPIO26"),
+	PINCTRL_PIN(GPIO27, "GPIO27"),
+	PINCTRL_PIN(GPIO28, "GPIO28"),
+	PINCTRL_PIN(GPIO29, "GPIO29"),
+	PINCTRL_PIN(GPIO30, "GPIO30"),
+	PINCTRL_PIN(GPIO31, "GPIO31"),
+	PINCTRL_PIN(GPIO32, "GPIO32"),
+	PINCTRL_PIN(GPIO33, "GPIO33"),
+	PINCTRL_PIN(GPIO34, "GPIO34"),
+	PINCTRL_PIN(GPIO35, "GPIO35"),
+	PINCTRL_PIN(GPIO36, "GPIO36"),
+	PINCTRL_PIN(GPIO37, "GPIO37"),
+	PINCTRL_PIN(GPIO38, "GPIO38"),
+	PINCTRL_PIN(GPIO39, "GPIO39"),
+	PINCTRL_PIN(GPIO40, "GPIO40"),
+	PINCTRL_PIN(GPIO41, "GPIO41"),
+	PINCTRL_PIN(GPIO42, "GPIO42"),
+	PINCTRL_PIN(GPIO43, "GPIO43"),
+	PINCTRL_PIN(GPIO44, "GPIO44"),
+	PINCTRL_PIN(GPIO45, "GPIO45"),
+	PINCTRL_PIN(GPIO46, "GPIO46"),
+	PINCTRL_PIN(GPIO47, "GPIO47"),
+	PINCTRL_PIN(GPIO48, "GPIO48"),
+	PINCTRL_PIN(GPIO49, "GPIO49"),
+	PINCTRL_PIN(GPIO50, "GPIO50"),
+	PINCTRL_PIN(GPIO51, "GPIO51"),
+	PINCTRL_PIN(GPIO52, "GPIO52"),
+	PINCTRL_PIN(GPIO53, "GPIO53"),
+	PINCTRL_PIN(GPIO54, "GPIO54"),
+	PINCTRL_PIN(GPIO55, "GPIO55"),
+	PINCTRL_PIN(GPIO56, "GPIO56"),
+	PINCTRL_PIN(GPIO57, "GPIO57"),
+	PINCTRL_PIN(GPIO58, "GPIO58"),
+	PINCTRL_PIN(GPIO59, "GPIO59"),
+	PINCTRL_PIN(GPIO60, "GPIO60"),
+	PINCTRL_PIN(GPIO61, "GPIO61"),
+	PINCTRL_PIN(GPIO62, "GPIO62"),
+	PINCTRL_PIN(GPIO63, "GPIO63"),
+	PINCTRL_PIN(GPIO64, "GPIO64"),
+	PINCTRL_PIN(GPIO65, "GPIO65"),
+	PINCTRL_PIN(GPIO66, "GPIO66"),
+	PINCTRL_PIN(GPIO67, "GPIO67"),
+	PINCTRL_PIN(GPIO68, "GPIO68"),
+	PINCTRL_PIN(GPIO69, "GPIO69"),
+	PINCTRL_PIN(GPIO70, "GPIO70"),
+	PINCTRL_PIN(GPIO71, "GPIO71"),
+	PINCTRL_PIN(GPIO72, "GPIO72"),
+	PINCTRL_PIN(GPIO73, "GPIO73"),
+	PINCTRL_PIN(GPIO74, "GPIO74"),
+	PINCTRL_PIN(GPIO75, "GPIO75"),
+	PINCTRL_PIN(GPIO76, "GPIO76"),
+	PINCTRL_PIN(GPIO77, "GPIO77"),
+	PINCTRL_PIN(GPIO78, "GPIO78"),
+	PINCTRL_PIN(GPIO79, "GPIO79"),
+	PINCTRL_PIN(GPIO80, "GPIO80"),
+	PINCTRL_PIN(GPIO81, "GPIO81"),
+	PINCTRL_PIN(GPIO82, "GPIO82"),
+	PINCTRL_PIN(GPIO83, "GPIO83"),
+	PINCTRL_PIN(GPIO84, "GPIO84"),
+	PINCTRL_PIN(GPIO85, "GPIO85"),
+	PINCTRL_PIN(GPIO86, "GPIO86"),
+	PINCTRL_PIN(GPIO87, "GPIO87"),
+	PINCTRL_PIN(GPIO88, "GPIO88"),
+	PINCTRL_PIN(GPIO89, "GPIO89"),
+	PINCTRL_PIN(GPIO90, "GPIO90"),
+	PINCTRL_PIN(GPIO91, "GPIO91"),
+	PINCTRL_PIN(GPIO92, "GPIO92"),
+	PINCTRL_PIN(GPIO93, "GPIO93"),
+	PINCTRL_PIN(GPIO94, "GPIO94"),
+	PINCTRL_PIN(GPIO95, "GPIO95"),
+	PINCTRL_PIN(GPIO96, "GPIO96"),
+	PINCTRL_PIN(GPIO97, "GPIO97"),
+	PINCTRL_PIN(GPIO98, "GPIO98"),
+	PINCTRL_PIN(GPIO99, "GPIO99"),
+	PINCTRL_PIN(GPIO100, "GPIO100"),
+	PINCTRL_PIN(GPIO101, "GPIO101"),
+	PINCTRL_PIN(GPIO102, "GPIO102"),
+	PINCTRL_PIN(GPIO103, "GPIO103"),
+	PINCTRL_PIN(GPIO104, "GPIO104"),
+	PINCTRL_PIN(GPIO105, "GPIO105"),
+	PINCTRL_PIN(GPIO106, "GPIO106"),
+	PINCTRL_PIN(GPIO107, "GPIO107"),
+	PINCTRL_PIN(GPIO108, "GPIO108"),
+	PINCTRL_PIN(GPIO109, "GPIO109"),
+	PINCTRL_PIN(GPIO110, "GPIO110"),
+	PINCTRL_PIN(GPIO111, "GPIO111"),
+	PINCTRL_PIN(GPIO112, "GPIO112"),
+	PINCTRL_PIN(GPIO113, "GPIO113"),
+	PINCTRL_PIN(GPIO114, "GPIO114"),
+	PINCTRL_PIN(GPIO115, "GPIO115"),
+	PINCTRL_PIN(GPIO116, "GPIO116"),
+	PINCTRL_PIN(GPIO117, "GPIO117"),
+	PINCTRL_PIN(GPIO118, "GPIO118"),
+	PINCTRL_PIN(GPIO119, "GPIO119"),
+	PINCTRL_PIN(GPIO120, "GPIO120"),
+	PINCTRL_PIN(GPIO121, "GPIO121"),
+	PINCTRL_PIN(GPIO122, "GPIO122"),
+	PINCTRL_PIN(PWR_SCL, "PWR_SCL"),
+	PINCTRL_PIN(PWR_SDA, "PWR_SDA"),
+	PINCTRL_PIN(TDI, "TDI"),
+	PINCTRL_PIN(TMS, "TMS"),
+	PINCTRL_PIN(TCK, "TCK"),
+	PINCTRL_PIN(TDO, "TDO"),
+	PINCTRL_PIN(TRST, "TRST"),
+	PINCTRL_PIN(WAKEUP, "WAKEUP"),
+};
+
+struct pxa3xx_mfp_pin pxa168_mfp[] = {
+	/*       pin      offs   f0       f1           f2         f3           f4           f5        f6           f7  */
+	MFPR_168(GPIO0,   0x04C, DFIO,    NONE,        NONE,      MSP,         MMC3_CMD,    GPIO,     MMC3,        NONE),
+	MFPR_168(GPIO1,   0x050, DFIO,    NONE,        NONE,      MSP,         MMC3_CLK,    GPIO,     MMC3,        NONE),
+	MFPR_168(GPIO2,   0x054, DFIO,    NONE,        NONE,      MSP,         NONE,        GPIO,     MMC3,        NONE),
+	MFPR_168(GPIO3,   0x058, DFIO,    NONE,        NONE,      NONE,        NONE,        GPIO,     MMC3,        NONE),
+	MFPR_168(GPIO4,   0x05C, DFIO,    NONE,        NONE,      MSP_DAT3,    NONE,        GPIO,     MMC3,        NONE),
+	MFPR_168(GPIO5,   0x060, DFIO,    NONE,        NONE,      MSP,         NONE,        GPIO,     MMC3,        NONE),
+	MFPR_168(GPIO6,   0x064, DFIO,    NONE,        NONE,      MSP,         NONE,        GPIO,     MMC3,        NONE),
+	MFPR_168(GPIO7,   0x068, DFIO,    NONE,        NONE,      MSP,         NONE,        GPIO,     MMC3,        NONE),
+	MFPR_168(GPIO8,   0x06C, DFIO,    MMC2,        UART3_TX,  NONE,        MMC2_CMD,    GPIO,     MMC3_CLK,    NONE),
+	MFPR_168(GPIO9,   0x070, DFIO,    MMC2,        UART3,     NONE,        MMC2_CLK,    GPIO,     MMC3_CMD,    NONE),
+	MFPR_168(GPIO10,  0x074, DFIO,    MMC2,        UART3,     NONE,        NONE,        GPIO,     MSP_DAT3,    NONE),
+	MFPR_168(GPIO11,  0x078, DFIO,    MMC2,        UART3,     NONE,        NONE,        GPIO,     MSP,         NONE),
+	MFPR_168(GPIO12,  0x07C, DFIO,    MMC2,        UART3,     NONE,        NONE,        GPIO,     MSP,         NONE),
+	MFPR_168(GPIO13,  0x080, DFIO,    MMC2,        UART3,     NONE,        NONE,        GPIO,     MSP,         NONE),
+	MFPR_168(GPIO14,  0x084, DFIO,    MMC2,        NONE,      NONE,        NONE,        GPIO,     MSP,         NONE),
+	MFPR_168(GPIO15,  0x088, DFIO,    MMC2,        NONE,      NONE,        NONE,        GPIO,     MSP,         NONE),
+	MFPR_168(GPIO16,  0x08C, GPIO,    NAND,        SMC_CS0,   SMC_CS1,     NONE,        NONE,     MMC3,        NONE),
+	MFPR_168(GPIO17,  0x090, NAND,    NONE,        NONE,      NONE,        NONE,        GPIO,     MSP,         NONE),
+	MFPR_168(GPIO18,  0x094, GPIO,    NAND,        SMC_CS1,   SMC_CS0,     NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO19,  0x098, SMC_CS0, NONE,        NONE,      CF,          NONE,        GPIO,     NONE,        NONE),
+	MFPR_168(GPIO20,  0x09C, GPIO,    NONE,        SMC_CS1,   CF,          CF_RDY,      NONE,     NONE,        NONE),
+	MFPR_168(GPIO21,  0x0A0, NAND,    MMC2_CLK,    NONE,      NONE,        NONE,        GPIO,     NONE,        NONE),
+	MFPR_168(GPIO22,  0x0A4, NAND,    MMC2_CMD,    NONE,      NONE,        NONE,        GPIO,     NONE,        NONE),
+	MFPR_168(GPIO23,  0x0A8, SMC,     NAND,        NONE,      CF,          NONE,        GPIO,     NONE,        NONE),
+	MFPR_168(GPIO24,  0x0AC, NAND,    NONE,        NONE,      NONE,        NONE,        GPIO,     NONE,        NONE),
+	MFPR_168(GPIO25,  0x0B0, SMC,     NAND,        NONE,      CF,          NONE,        GPIO,     NONE,        NONE),
+	MFPR_168(GPIO26,  0x0B4, GPIO,    NAND,        NONE,      NONE,        CF,          NONE,     NONE,        NONE),
+	MFPR_168(GPIO27,  0x0B8, SMC_INT, NAND,        SMC,       NONE,        SMC_RDY,     GPIO,     NONE,        NONE),
+	MFPR_168(GPIO28,  0x0BC, SMC_RDY, MMC4,        SMC,       CF_RDY,      NONE,        GPIO,     MMC2_CMD,    NONE),
+	MFPR_168(GPIO29,  0x0C0, SMC,     MMC4,        NONE,      CF,          NONE,        GPIO,     MMC2_CLK,    KP_DK),
+	MFPR_168(GPIO30,  0x0C4, SMC,     MMC4,        UART3_TX,  CF,          NONE,        GPIO,     MMC2,        KP_DK),
+	MFPR_168(GPIO31,  0x0C8, SMC,     MMC4,        UART3,     CF,          NONE,        GPIO,     MMC2,        KP_DK),
+	MFPR_168(GPIO32,  0x0CC, SMC,     MMC4,        UART3,     CF,          NONE,        GPIO,     MMC2,        KP_DK),
+	MFPR_168(GPIO33,  0x0D0, SMC,     MMC4,        UART3,     CF,          CF_nINPACK,  GPIO,     MMC2,        KP_DK),
+	MFPR_168(GPIO34,  0x0D4, GPIO,    NONE,        SMC_CS1,   CF,          CF_nWAIT,    NONE,     MMC3,        KP_DK),
+	MFPR_168(GPIO35,  0x0D8, GPIO,    NONE,        SMC,       CF_nINPACK,  NONE,        NONE,     MMC3_CMD,    KP_DK),
+	MFPR_168(GPIO36,  0x0DC, GPIO,    NONE,        SMC,       CF_nWAIT,    NONE,        NONE,     MMC3_CLK,    KP_DK),
+	MFPR_168(GPIO37,  0x000, GPIO,    MMC1,        NONE,      KP_MKOUT,    CCIC,        XP,       KP_MKIN,     KP_DK),
+	MFPR_168(GPIO38,  0x004, GPIO,    MMC1,        NONE,      KP_MKOUT,    CCIC,        XP,       KP_MKIN,     KP_DK),
+	MFPR_168(GPIO39,  0x008, GPIO,    NONE,        NONE,      KP_MKOUT,    CCIC,        XP,       KP_MKIN,     KP_DK),
+	MFPR_168(GPIO40,  0x00C, GPIO,    MMC1,        MSP,       KP_MKOUT,    CCIC,        XP,       KP_MKIN,     KP_DK),
+	MFPR_168(GPIO41,  0x010, GPIO,    MMC1,        MSP,       NONE,        CCIC,        XP,       KP_MKIN,     KP_DK),
+	MFPR_168(GPIO42,  0x014, GPIO,    I2C,         NONE,      MSP,         CCIC,        XP,       KP_MKIN,     KP_DK),
+	MFPR_168(GPIO43,  0x018, GPIO,    MMC1,        MSP,       MSP_INS,     NONE,        NONE,     KP_MKIN,     KP_DK),
+	MFPR_168(GPIO44,  0x01C, GPIO,    MMC1,        MSP_DAT3,  MSP,         CCIC,        XP,       KP_MKIN,     KP_DK),
+	MFPR_168(GPIO45,  0x020, GPIO,    NONE,        NONE,      MSP,         CCIC,        XP,       NONE,        KP_DK),
+	MFPR_168(GPIO46,  0x024, GPIO,    MMC1,        MSP_INS,   MSP,         CCIC,        NONE,     KP_MKOUT,    KP_DK),
+	MFPR_168(GPIO47,  0x028, GPIO,    NONE,        NONE,      MSP_INS,     NONE,        XP,       NONE,        KP_DK),
+	MFPR_168(GPIO48,  0x02C, GPIO,    MMC1,        NONE,      MSP_DAT3,    CCIC,        NONE,     NONE,        KP_DK),
+	MFPR_168(GPIO49,  0x030, GPIO,    MMC1,        NONE,      MSP,         NONE,        XD,       KP_MKOUT,    NONE),
+	MFPR_168(GPIO50,  0x034, GPIO,    I2C,         NONE,      MSP,         CCIC,        XD,       KP_MKOUT,    NONE),
+	MFPR_168(GPIO51,  0x038, GPIO,    MMC1,        NONE,      MSP,         NONE,        XD,       KP_MKOUT,    NONE),
+	MFPR_168(GPIO52,  0x03C, GPIO,    MMC1,        NONE,      MSP,         NONE,        XD,       KP_MKOUT,    NONE),
+	MFPR_168(GPIO53,  0x040, GPIO,    MMC1,        NONE,      NONE,        NONE,        XD,       KP_MKOUT,    NONE),
+	MFPR_168(GPIO54,  0x044, GPIO,    MMC1,        NONE,      NONE,        CCIC,        XD,       KP_MKOUT,    NONE),
+	MFPR_168(GPIO55,  0x048, GPIO,    NONE,        NONE,      MSP,         CCIC,        XD,       KP_MKOUT,    NONE),
+	MFPR_168(GPIO56,  0x0E0, GPIO,    LCD,         NONE,      NONE,        NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO57,  0x0E4, GPIO,    LCD,         NONE,      NONE,        NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO58,  0x0E8, GPIO,    LCD,         NONE,      NONE,        NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO59,  0x0EC, GPIO,    LCD,         NONE,      NONE,        NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO60,  0x0F0, GPIO,    LCD,         NONE,      NONE,        NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO61,  0x0F4, GPIO,    LCD,         NONE,      NONE,        NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO62,  0x0F8, GPIO,    LCD,         NONE,      NONE,        NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO63,  0x0FC, GPIO,    LCD,         NONE,      NONE,        NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO64,  0x100, GPIO,    LCD,         NONE,      NONE,        NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO65,  0x104, GPIO,    LCD,         NONE,      NONE,        NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO66,  0x108, GPIO,    LCD,         NONE,      NONE,        NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO67,  0x10C, GPIO,    LCD,         NONE,      NONE,        NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO68,  0x110, GPIO,    LCD,         NONE,      XD,          NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO69,  0x114, GPIO,    LCD,         NONE,      XD,          NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO70,  0x118, GPIO,    LCD,         NONE,      XD,          NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO71,  0x11C, GPIO,    LCD,         NONE,      XD,          NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO72,  0x120, GPIO,    LCD,         NONE,      XD,          NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO73,  0x124, GPIO,    LCD,         NONE,      XD,          NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO74,  0x128, GPIO,    LCD,         PWM,       XD,          NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO75,  0x12C, GPIO,    LCD,         PWM,       XD,          ONE_WIRE,    NONE,     NONE,        NONE),
+	MFPR_168(GPIO76,  0x130, GPIO,    LCD,         PWM,       I2C,         NONE,        NONE,     MSP_INS,     NONE),
+	MFPR_168(GPIO77,  0x134, GPIO,    LCD,         PWM1,      I2C,         ONE_WIRE,    NONE,     XD,          NONE),
+	MFPR_168(GPIO78,  0x138, GPIO,    LCD,         NONE,      NONE,        NONE,        MMC4,     NONE,        NONE),
+	MFPR_168(GPIO79,  0x13C, GPIO,    LCD,         NONE,      NONE,        ONE_WIRE,    MMC4,     NONE,        NONE),
+	MFPR_168(GPIO80,  0x140, GPIO,    LCD,         NONE,      I2C,         NONE,        MMC4,     NONE,        NONE),
+	MFPR_168(GPIO81,  0x144, GPIO,    LCD,         NONE,      I2C,         ONE_WIRE,    MMC4,     NONE,        NONE),
+	MFPR_168(GPIO82,  0x148, GPIO,    LCD,         PWM,       NONE,        NONE,        MMC4,     NONE,        NONE),
+	MFPR_168(GPIO83,  0x14C, GPIO,    LCD,         PWM,       NONE,        RESET,       MMC4,     NONE,        NONE),
+	MFPR_168(GPIO84,  0x150, GPIO,    NONE,        PWM,       ONE_WIRE,    PWM1,        NONE,     NONE,        EXT_32K_IN),
+	MFPR_168(GPIO85,  0x154, GPIO,    NONE,        PWM1,      NONE,        NONE,        NONE,     NONE,        USB),
+	MFPR_168(GPIO86,  0x158, GPIO,    MMC2,        UART2,     NONE,        JTAG,        ETH_TX,   SSP5_TX,     SSP5),
+	MFPR_168(GPIO87,  0x15C, GPIO,    MMC2,        UART2,     NONE,        JTAG,        ETH_TX,   SSP5,        SSP5_TX),
+	MFPR_168(GPIO88,  0x160, GPIO,    MMC2,        UART2,     UART2_TX,    JTAG,        ETH_TX,   ETH_RX,      SSP5),
+	MFPR_168(GPIO89,  0x164, GPIO,    MMC2,        UART2_TX,  UART2,       JTAG,        ETH_TX,   ETH_RX,      SSP5),
+	MFPR_168(GPIO90,  0x168, GPIO,    MMC2,        NONE,      SSP3,        JTAG,        ETH_TX,   ETH_RX,      NONE),
+	MFPR_168(GPIO91,  0x16C, GPIO,    MMC2,        NONE,      SSP3,        SSP4,        ETH_TX,   ETH_RX,      NONE),
+	MFPR_168(GPIO92,  0x170, GPIO,    MMC2,        NONE,      SSP3,        SSP3_TX,     ETH,      NONE,        NONE),
+	MFPR_168(GPIO93,  0x174, GPIO,    MMC2,        NONE,      SSP3_TX,     SSP3,        ETH,      NONE,        NONE),
+	MFPR_168(GPIO94,  0x178, GPIO,    MMC2_CMD,    SSP3,      AC97_SYSCLK, AC97,        ETH,      NONE,        NONE),
+	MFPR_168(GPIO95,  0x17C, GPIO,    MMC2_CLK,    NONE,      NONE,        AC97,        ETH,      NONE,        NONE),
+	MFPR_168(GPIO96,  0x180, GPIO,    PWM,         NONE,      MMC2,        NONE,        ETH_RX,   ETH_TX,      NONE),
+	MFPR_168(GPIO97,  0x184, GPIO,    PWM,         ONE_WIRE,  NONE,        NONE,        ETH_RX,   ETH_TX,      NONE),
+	MFPR_168(GPIO98,  0x188, GPIO,    PWM1,        UART3_TX,  UART3,       NONE,        ETH_RX,   ETH_TX,      NONE),
+	MFPR_168(GPIO99,  0x18C, GPIO,    ONE_WIRE,    UART3,     UART3_TX,    NONE,        ETH_RX,   ETH_TX,      NONE),
+	MFPR_168(GPIO100, 0x190, GPIO,    NONE,        UART3_CTS, UART3,       NONE,        ETH,      NONE,        NONE),
+	MFPR_168(GPIO101, 0x194, GPIO,    NONE,        UART3,     UART3_CTS,   NONE,        ETH,      NONE,        NONE),
+	MFPR_168(GPIO102, 0x198, GPIO,    I2C,         UART3,     SSP4,        NONE,        NONE,     NONE,        NONE),
+	MFPR_168(GPIO103, 0x19C, GPIO,    I2C,         UART3,     SSP4,        SSP2,        ETH,      NONE,        NONE),
+	MFPR_168(GPIO104, 0x1A0, GPIO,    PWM,         UART1,     SSP4,        SSP4_TX,     AC97,     KP_MKOUT,    NONE),
+	MFPR_168(GPIO105, 0x1A4, GPIO,    I2C,         UART1,     SSP4_TX,     SSP4,        AC97,     KP_MKOUT,    NONE),
+	MFPR_168(GPIO106, 0x1A8, GPIO,    I2C,         PWM1,      AC97_SYSCLK, MMC2,        NONE,     KP_MKOUT,    NONE),
+	MFPR_168(GPIO107, 0x1AC, GPIO,    UART1_TX,    UART1,     NONE,        SSP2,        MSP_DAT3, NONE,        KP_MKIN),
+	MFPR_168(GPIO108, 0x1B0, GPIO,    UART1,       UART1_TX,  NONE,        SSP2_TX,     MSP,      NONE,        KP_MKIN),
+	MFPR_168(GPIO109, 0x1B4, GPIO,    UART1_CTS,   UART1,     NONE,        AC97_SYSCLK, MSP,      NONE,        KP_MKIN),
+	MFPR_168(GPIO110, 0x1B8, GPIO,    UART1,       UART1_CTS, NONE,        SMC_RDY,     MSP,      NONE,        KP_MKIN),
+	MFPR_168(GPIO111, 0x1BC, GPIO,    UART1_nRI,   UART1,     SSP3,        SSP2,        MSP,      XD,          KP_MKOUT),
+	MFPR_168(GPIO112, 0x1C0, GPIO,    UART1_DTR,   UART1,     ONE_WIRE,    SSP2,        MSP,      XD,          KP_MKOUT),
+	MFPR_168(GPIO113, 0x1C4, GPIO,    NONE,        NONE,      NONE,        NONE,        NONE,     AC97_SYSCLK, NONE),
+	MFPR_168(GPIO114, 0x1C8, GPIO,    SSP1,        NONE,      NONE,        NONE,        NONE,     AC97,        NONE),
+	MFPR_168(GPIO115, 0x1CC, GPIO,    SSP1,        NONE,      NONE,        NONE,        NONE,     AC97,        NONE),
+	MFPR_168(GPIO116, 0x1D0, GPIO,    SSP1_TX,     SSP1,      NONE,        NONE,        NONE,     AC97,        NONE),
+	MFPR_168(GPIO117, 0x1D4, GPIO,    SSP1,        SSP1_TX,   NONE,        MMC2_CMD,    NONE,     AC97,        NONE),
+	MFPR_168(GPIO118, 0x1D8, GPIO,    SSP2,        NONE,      NONE,        MMC2_CLK,    NONE,     AC97,        KP_MKIN),
+	MFPR_168(GPIO119, 0x1DC, GPIO,    SSP2,        NONE,      NONE,        MMC2,        NONE,     AC97,        KP_MKIN),
+	MFPR_168(GPIO120, 0x1E0, GPIO,    SSP2,        SSP2_TX,   NONE,        MMC2,        NONE,     NONE,        KP_MKIN),
+	MFPR_168(GPIO121, 0x1E4, GPIO,    SSP2_TX,     SSP2,      NONE,        MMC2,        NONE,     NONE,        KP_MKIN),
+	MFPR_168(GPIO122, 0x1E8, GPIO,    AC97_SYSCLK, SSP2,      PWM,         MMC2,        NONE,     NONE,        NONE),
+	MFPR_168(PWR_SCL, 0x1EC, PWRI2C,  NONE,        NONE,      NONE,        NONE,        NONE,     GPIO,        MMC4),
+	MFPR_168(PWR_SDA, 0x1F0, PWRI2C,  NONE,        NONE,      NONE,        NONE,        NONE,     GPIO,        NONE),
+	MFPR_168(TDI,     0x1F4, JTAG,    PWM1,        UART2,     MMC4,        SSP5,        NONE,     XD,          MMC4),
+	MFPR_168(TMS,     0x1F8, JTAG,    PWM,         UART2,     NONE,        SSP5,        NONE,     XD,          MMC4),
+	MFPR_168(TCK,     0x1FC, JTAG,    PWM,         UART2,     UART2_TX,    SSP5,        NONE,     XD,          MMC4),
+	MFPR_168(TDO,     0x200, JTAG,    PWM,         UART2_TX,  UART2,       SSP5_TX,     NONE,     XD,          MMC4),
+	MFPR_168(TRST,    0x204, JTAG,    ONE_WIRE,    SSP2,      SSP3,        AC97_SYSCLK, NONE,     XD,          MMC4),
+	MFPR_168(WAKEUP,  0x208, WAKEUP,  ONE_WIRE,    PWM1,      PWM,         SSP2,        NONE,     GPIO,        MMC4),
+};
+
+static const unsigned p168_jtag_pin1[] = {TDI, TMS, TCK, TDO, TRST};
+static const unsigned p168_wakeup_pin1[] = {WAKEUP};
+static const unsigned p168_ssp1rx_pin1[] = {GPIO114, GPIO115, GPIO116};
+static const unsigned p168_ssp1tx_pin1[] = {GPIO117};
+static const unsigned p168_ssp4rx_pin1[] = {GPIO102, GPIO103, GPIO104};
+static const unsigned p168_ssp4tx_pin1[] = {GPIO105};
+static const unsigned p168_ssp5rx_pin1[] = {GPIO86, GPIO88, GPIO89};
+static const unsigned p168_ssp5tx_pin1[] = {GPIO87};
+static const unsigned p168_i2c_pin1[] = {GPIO105, GPIO106};
+static const unsigned p168_pwri2c_pin1[] = {PWR_SCL, PWR_SDA};
+static const unsigned p168_mmc1_pin1[] = {GPIO40, GPIO41, GPIO43, GPIO46,
+	GPIO49, GPIO51, GPIO52, GPIO53};
+static const unsigned p168_mmc2_data_pin1[] = {GPIO90, GPIO91, GPIO92, GPIO93};
+static const unsigned p168_mmc2_cmd_pin1[] = {GPIO94};
+static const unsigned p168_mmc2_clk_pin1[] = {GPIO95};
+static const unsigned p168_mmc3_data_pin1[] = {GPIO0, GPIO1, GPIO2, GPIO3,
+	GPIO4, GPIO5, GPIO6, GPIO7};
+static const unsigned p168_mmc3_cmd_pin1[] = {GPIO9};
+static const unsigned p168_mmc3_clk_pin1[] = {GPIO8};
+static const unsigned p168_eth_pin1[] = {GPIO92, GPIO93, GPIO100, GPIO101,
+	GPIO103};
+static const unsigned p168_ethtx_pin1[] = {GPIO86, GPIO87, GPIO88, GPIO89,
+	GPIO90, GPIO91};
+static const unsigned p168_ethrx_pin1[] = {GPIO94, GPIO95, GPIO96, GPIO97,
+	GPIO98, GPIO99};
+static const unsigned p168_uart1rx_pin1[] = {GPIO107};
+static const unsigned p168_uart1tx_pin1[] = {GPIO108};
+static const unsigned p168_uart3rx_pin1[] = {GPIO98, GPIO100, GPIO101};
+static const unsigned p168_uart3tx_pin1[] = {GPIO99};
+static const unsigned p168_msp_pin1[] = {GPIO40, GPIO41, GPIO42, GPIO43,
+	GPIO44, GPIO50};
+static const unsigned p168_ccic_pin1[] = {GPIO37, GPIO38, GPIO39, GPIO40,
+	GPIO41, GPIO42, GPIO44, GPIO45, GPIO46, GPIO48, GPIO54, GPIO55};
+static const unsigned p168_xd_pin1[] = {GPIO37, GPIO38, GPIO39, GPIO40,
+	GPIO41, GPIO42, GPIO44, GPIO45, GPIO47, GPIO48, GPIO49, GPIO50,
+	GPIO51, GPIO52};
+static const unsigned p168_lcd_pin1[] = {GPIO56, GPIO57, GPIO58, GPIO59,
+	GPIO60, GPIO61, GPIO62, GPIO63, GPIO64, GPIO65, GPIO66, GPIO67,
+	GPIO68, GPIO69, GPIO70, GPIO71, GPIO72, GPIO73, GPIO74, GPIO75,
+	GPIO76, GPIO77, GPIO78, GPIO79, GPIO80, GPIO81, GPIO82, GPIO83};
+static const unsigned p168_dfio_pin1[] = {GPIO0, GPIO1, GPIO2, GPIO3,
+	GPIO4, GPIO5, GPIO6, GPIO7, GPIO8, GPIO9, GPIO10, GPIO11, GPIO12,
+	GPIO13, GPIO14, GPIO15};
+static const unsigned p168_nand_pin1[] = {GPIO16, GPIO17, GPIO21, GPIO22,
+	GPIO24, GPIO26};
+static const unsigned p168_smc_pin1[] = {GPIO23, GPIO25, GPIO29, GPIO35,
+	GPIO36};
+static const unsigned p168_smccs0_pin1[] = {GPIO18};
+static const unsigned p168_smccs1_pin1[] = {GPIO34};
+static const unsigned p168_smcrdy_pin1[] = {GPIO28};
+static const unsigned p168_ac97sysclk_pin1[] = {GPIO113};
+static const unsigned p168_ac97_pin1[] = {GPIO114, GPIO115, GPIO117, GPIO118,
+	GPIO119};
+static const unsigned p168_cf_pin1[] = {GPIO19, GPIO20, GPIO23, GPIO25,
+	GPIO28, GPIO29, GPIO30, GPIO31, GPIO32, GPIO33, GPIO34, GPIO35,
+	GPIO36};
+static const unsigned p168_kpmkin_pin1[] = {GPIO109, GPIO110, GPIO121};
+static const unsigned p168_kpmkout_pin1[] = {GPIO111, GPIO112};
+static const unsigned p168_gpio86_pin1[] = {WAKEUP};
+static const unsigned p168_gpio86_pin2[] = {GPIO86};
+static const unsigned p168_gpio87_pin1[] = {GPIO87};
+static const unsigned p168_gpio87_pin2[] = {PWR_SDA};
+static const unsigned p168_gpio88_pin1[] = {GPIO88};
+static const unsigned p168_gpio88_pin2[] = {PWR_SCL};
+
+static struct pxa3xx_pin_group pxa168_grps[] = {
+	GRP_168("uart1rx-1", UART1, p168_uart1rx_pin1),
+	GRP_168("uart1tx-1", UART1_TX, p168_uart1tx_pin1),
+	GRP_168("uart3rx-1", UART3, p168_uart3rx_pin1),
+	GRP_168("uart3tx-1", UART3_TX, p168_uart3tx_pin1),
+	GRP_168("ssp1rx-1", SSP1, p168_ssp1rx_pin1),
+	GRP_168("ssp1tx-1", SSP1_TX, p168_ssp1tx_pin1),
+	GRP_168("ssp4rx-1", SSP4, p168_ssp4rx_pin1),
+	GRP_168("ssp4tx-1", SSP4_TX, p168_ssp4tx_pin1),
+	GRP_168("ssp5rx-1", SSP5, p168_ssp5rx_pin1),
+	GRP_168("ssp5tx-1", SSP5_TX, p168_ssp5tx_pin1),
+	GRP_168("jtag", JTAG, p168_jtag_pin1),
+	GRP_168("wakeup", WAKEUP, p168_wakeup_pin1),
+	GRP_168("i2c", I2C, p168_i2c_pin1),
+	GRP_168("pwri2c", PWRI2C, p168_pwri2c_pin1),
+	GRP_168("mmc1 8p1", MMC1, p168_mmc1_pin1),
+	GRP_168("mmc2 4p1", MMC2, p168_mmc2_data_pin1),
+	GRP_168("mmc2 cmd1", MMC2_CMD, p168_mmc2_cmd_pin1),
+	GRP_168("mmc2 clk1", MMC2_CLK, p168_mmc2_clk_pin1),
+	GRP_168("mmc3 8p1", MMC3, p168_mmc3_data_pin1),
+	GRP_168("mmc3 cmd1", MMC3_CMD, p168_mmc3_cmd_pin1),
+	GRP_168("mmc3 clk1", MMC3_CLK, p168_mmc3_clk_pin1),
+	GRP_168("eth", ETH, p168_eth_pin1),
+	GRP_168("eth rx", ETH_RX, p168_ethrx_pin1),
+	GRP_168("eth tx", ETH_TX, p168_ethtx_pin1),
+	GRP_168("msp", MSP, p168_msp_pin1),
+	GRP_168("ccic", CCIC, p168_ccic_pin1),
+	GRP_168("xd", XD, p168_xd_pin1),
+	GRP_168("lcd", LCD, p168_lcd_pin1),
+	GRP_168("dfio", DFIO, p168_dfio_pin1),
+	GRP_168("nand", NAND, p168_nand_pin1),
+	GRP_168("smc", SMC, p168_smc_pin1),
+	GRP_168("smc cs0", SMC_CS0, p168_smccs0_pin1),
+	GRP_168("smc cs1", SMC_CS1, p168_smccs1_pin1),
+	GRP_168("smc rdy", SMC_RDY, p168_smcrdy_pin1),
+	GRP_168("ac97 sysclk", AC97_SYSCLK, p168_ac97sysclk_pin1),
+	GRP_168("ac97", AC97, p168_ac97_pin1),
+	GRP_168("cf", CF, p168_cf_pin1),
+	GRP_168("kp mkin 3p1", KP_MKIN, p168_kpmkin_pin1),
+	GRP_168("kp mkout 2p1", KP_MKOUT, p168_kpmkout_pin1),
+	GRP_168("gpio86-1", GPIO, p168_gpio86_pin1),
+	GRP_168("gpio86-2", GPIO, p168_gpio86_pin2),
+	GRP_168("gpio87-1", GPIO, p168_gpio87_pin1),
+	GRP_168("gpio87-2", GPIO, p168_gpio87_pin2),
+	GRP_168("gpio88-1", GPIO, p168_gpio88_pin1),
+	GRP_168("gpio88-2", GPIO, p168_gpio88_pin2),
+};
+
+static const char * const p168_uart1rx_grps[] = {"uart1rx-1"};
+static const char * const p168_uart1tx_grps[] = {"uart1tx-1"};
+static const char * const p168_uart3rx_grps[] = {"uart3rx-1"};
+static const char * const p168_uart3tx_grps[] = {"uart3tx-1"};
+static const char * const p168_ssp1rx_grps[] = {"ssp1rx-1"};
+static const char * const p168_ssp1tx_grps[] = {"ssp1tx-1"};
+static const char * const p168_ssp4rx_grps[] = {"ssp4rx-1"};
+static const char * const p168_ssp4tx_grps[] = {"ssp4tx-1"};
+static const char * const p168_ssp5rx_grps[] = {"ssp5rx-1"};
+static const char * const p168_ssp5tx_grps[] = {"ssp5tx-1"};
+static const char * const p168_i2c_grps[] = {"i2c"};
+static const char * const p168_pwri2c_grps[] = {"pwri2c"};
+static const char * const p168_mmc1_grps[] = {"mmc1 8p1"};
+static const char * const p168_mmc2_data_grps[] = {"mmc2 4p1"};
+static const char * const p168_mmc2_cmd_grps[] = {"mmc2 cmd1"};
+static const char * const p168_mmc2_clk_grps[] = {"mmc2 clk1"};
+static const char * const p168_mmc3_data_grps[] = {"mmc3 8p1"};
+static const char * const p168_mmc3_cmd_grps[] = {"mmc3 cmd1"};
+static const char * const p168_mmc3_clk_grps[] = {"mmc3 clk1"};
+static const char * const p168_eth_grps[] = {"eth"};
+static const char * const p168_ethrx_grps[] = {"eth rx"};
+static const char * const p168_ethtx_grps[] = {"eth tx"};
+static const char * const p168_msp_grps[] = {"msp"};
+static const char * const p168_ccic_grps[] = {"ccic"};
+static const char * const p168_xd_grps[] = {"xd"};
+static const char * const p168_lcd_grps[] = {"lcd"};
+static const char * const p168_dfio_grps[] = {"dfio"};
+static const char * const p168_nand_grps[] = {"nand"};
+static const char * const p168_smc_grps[] = {"smc"};
+static const char * const p168_smccs0_grps[] = {"smc cs0"};
+static const char * const p168_smccs1_grps[] = {"smc cs1"};
+static const char * const p168_smcrdy_grps[] = {"smc rdy"};
+static const char * const p168_ac97sysclk_grps[] = {"ac97 sysclk"};
+static const char * const p168_ac97_grps[] = {"ac97"};
+static const char * const p168_cf_grps[] = {"cf"};
+static const char * const p168_kpmkin_grps[] = {"kp mkin 3p1"};
+static const char * const p168_kpmkout_grps[] = {"kp mkout 2p1"};
+static const char * const p168_gpio86_grps[] = {"gpio86-1", "gpio86-2"};
+static const char * const p168_gpio87_grps[] = {"gpio87-1", "gpio87-2"};
+static const char * const p168_gpio88_grps[] = {"gpio88-1", "gpio88-2"};
+
+static struct pxa3xx_pmx_func pxa168_funcs[] = {
+	{"uart1 rx",	ARRAY_AND_SIZE(p168_uart1rx_grps)},
+	{"uart1 tx", 	ARRAY_AND_SIZE(p168_uart1tx_grps)},
+	{"uart3 rx",	ARRAY_AND_SIZE(p168_uart3rx_grps)},
+	{"uart3 tx", 	ARRAY_AND_SIZE(p168_uart3tx_grps)},
+	{"ssp1 rx", 	ARRAY_AND_SIZE(p168_ssp1rx_grps)},
+	{"ssp1 tx", 	ARRAY_AND_SIZE(p168_ssp1tx_grps)},
+	{"ssp4 rx", 	ARRAY_AND_SIZE(p168_ssp4rx_grps)},
+	{"ssp4 tx", 	ARRAY_AND_SIZE(p168_ssp4tx_grps)},
+	{"ssp5 rx", 	ARRAY_AND_SIZE(p168_ssp5rx_grps)},
+	{"ssp5 tx", 	ARRAY_AND_SIZE(p168_ssp5tx_grps)},
+	{"i2c", 	ARRAY_AND_SIZE(p168_i2c_grps)},
+	{"pwri2c", 	ARRAY_AND_SIZE(p168_pwri2c_grps)},
+	{"mmc1", 	ARRAY_AND_SIZE(p168_mmc1_grps)},
+	{"mmc2", 	ARRAY_AND_SIZE(p168_mmc2_data_grps)},
+	{"mmc2 cmd", 	ARRAY_AND_SIZE(p168_mmc2_cmd_grps)},
+	{"mmc2 clk", 	ARRAY_AND_SIZE(p168_mmc2_clk_grps)},
+	{"mmc3", 	ARRAY_AND_SIZE(p168_mmc3_data_grps)},
+	{"mmc3 cmd", 	ARRAY_AND_SIZE(p168_mmc3_cmd_grps)},
+	{"mmc3 clk", 	ARRAY_AND_SIZE(p168_mmc3_clk_grps)},
+	{"eth", 	ARRAY_AND_SIZE(p168_eth_grps)},
+	{"eth rx", 	ARRAY_AND_SIZE(p168_ethrx_grps)},
+	{"eth tx", 	ARRAY_AND_SIZE(p168_ethtx_grps)},
+	{"msp", 	ARRAY_AND_SIZE(p168_msp_grps)},
+	{"ccic", 	ARRAY_AND_SIZE(p168_ccic_grps)},
+	{"xd", 		ARRAY_AND_SIZE(p168_xd_grps)},
+	{"lcd", 	ARRAY_AND_SIZE(p168_lcd_grps)},
+	{"dfio", 	ARRAY_AND_SIZE(p168_dfio_grps)},
+	{"nand", 	ARRAY_AND_SIZE(p168_nand_grps)},
+	{"smc",		ARRAY_AND_SIZE(p168_smc_grps)},
+	{"smc cs0",	ARRAY_AND_SIZE(p168_smccs0_grps)},
+	{"smc cs1",	ARRAY_AND_SIZE(p168_smccs1_grps)},
+	{"smc rdy",	ARRAY_AND_SIZE(p168_smcrdy_grps)},
+	{"ac97", 	ARRAY_AND_SIZE(p168_ac97_grps)},
+	{"ac97 sysclk",	ARRAY_AND_SIZE(p168_ac97sysclk_grps)},
+	{"cf", 		ARRAY_AND_SIZE(p168_cf_grps)},
+	{"kpmkin", 	ARRAY_AND_SIZE(p168_kpmkin_grps)},
+	{"kpmkout", 	ARRAY_AND_SIZE(p168_kpmkout_grps)},
+	{"gpio86", 	ARRAY_AND_SIZE(p168_gpio86_grps)},
+	{"gpio87", 	ARRAY_AND_SIZE(p168_gpio87_grps)},
+	{"gpio88", 	ARRAY_AND_SIZE(p168_gpio88_grps)},
+};
+
+static struct pinctrl_desc pxa168_pctrl_desc = {
+	.name		= "pxa168-pinctrl",
+	.maxpin		= 260,
+	.owner		= THIS_MODULE,
+};
+
+static struct pxa3xx_pinmux_info pxa168_info = {
+	.mfp		= pxa168_mfp,
+	.num_mfp	= ARRAY_SIZE(pxa168_mfp),
+	.grps		= pxa168_grps,
+	.num_grps	= ARRAY_SIZE(pxa168_grps),
+	.funcs		= pxa168_funcs,
+	.num_funcs	= ARRAY_SIZE(pxa168_funcs),
+	.num_gpio	= 128,
+	.desc		= &pxa168_pctrl_desc,
+	.pads		= pxa168_pads,
+	.num_pads	= ARRAY_SIZE(pxa168_pads),
+
+	.cputype	= PINCTRL_PXA168,
+	.ds_mask	= PXA168_DS_MASK,
+	.ds_shift	= PXA168_DS_SHIFT,
+};
+
+static int __devinit pxa168_pinmux_probe(struct platform_device *pdev)
+{
+	return pxa3xx_pinctrl_register(pdev, &pxa168_info);
+}
+
+static int __devexit pxa168_pinmux_remove(struct platform_device *pdev)
+{
+	return pxa3xx_pinctrl_unregister(pdev);
+}
+
+static struct platform_driver pxa168_pinmux_driver = {
+	.driver = {
+		.name	= "pxa168-pinmux",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= pxa168_pinmux_probe,
+	.remove	= __devexit_p(pxa168_pinmux_remove),
+};
+
+static int __init pxa168_pinmux_init(void)
+{
+	return platform_driver_register(&pxa168_pinmux_driver);
+}
+core_initcall_sync(pxa168_pinmux_init);
+
+static void __exit pxa168_pinmux_exit(void)
+{
+	platform_driver_unregister(&pxa168_pinmux_driver);
+}
+module_exit(pxa168_pinmux_exit);
+
+MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
+MODULE_DESCRIPTION("PXA3xx pin control driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/pinctrl/pinctrl-pxa3xx.c b/drivers/pinctrl/pinctrl-pxa3xx.c
new file mode 100644
index 0000000..59c0aa4
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-pxa3xx.c
@@ -0,0 +1,244 @@
+/*
+ *  linux/drivers/pinctrl/pinctrl-pxa3xx.c
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ *
+ *  Copyright (C) 2011, Marvell Technology Group Ltd.
+ *
+ *  Author: Haojian Zhuang <haojian.zhuang@marvell.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include "pinctrl-pxa3xx.h"
+
+static struct pinctrl_gpio_range pxa3xx_pinctrl_gpio_range = {
+	.name		= "PXA3xx GPIO",
+	.id		= 0,
+	.base		= 0,
+	.pin_base	= 0,
+};
+
+static int pxa3xx_list_groups(struct pinctrl_dev *pctrldev, unsigned selector)
+{
+	struct pxa3xx_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
+	if (selector >= info->num_grps)
+		return -EINVAL;
+	return 0;
+}
+
+static const char *pxa3xx_get_group_name(struct pinctrl_dev *pctrldev,
+					 unsigned selector)
+{
+	struct pxa3xx_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
+	if (selector >= info->num_grps)
+		return NULL;
+	return info->grps[selector].name;
+}
+
+static int pxa3xx_get_group_pins(struct pinctrl_dev *pctrldev,
+				 unsigned selector,
+				 const unsigned **pins,
+				 unsigned *num_pins)
+{
+	struct pxa3xx_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
+	if (selector >= info->num_grps)
+		return -EINVAL;
+	*pins = info->grps[selector].pins;
+	*num_pins = info->grps[selector].npins;
+	return 0;
+}
+
+static struct pinctrl_ops pxa3xx_pctrl_ops = {
+	.list_groups	= pxa3xx_list_groups,
+	.get_group_name	= pxa3xx_get_group_name,
+	.get_group_pins	= pxa3xx_get_group_pins,
+};
+
+static int pxa3xx_pmx_list_func(struct pinctrl_dev *pctrldev, unsigned func)
+{
+	struct pxa3xx_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
+	if (func >= info->num_funcs)
+		return -EINVAL;
+	return 0;
+}
+
+static const char *pxa3xx_pmx_get_func_name(struct pinctrl_dev *pctrldev,
+					    unsigned func)
+{
+	struct pxa3xx_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
+	return info->funcs[func].name;
+}
+
+static int pxa3xx_pmx_get_groups(struct pinctrl_dev *pctrldev, unsigned func,
+				 const char * const **groups,
+				 unsigned * const num_groups)
+{
+	struct pxa3xx_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
+	*groups = info->funcs[func].groups;
+	*num_groups = info->funcs[func].num_groups;
+	return 0;
+}
+
+/* Return function number. If failure, return negative value. */
+static int match_mux(struct pxa3xx_mfp_pin *mfp, unsigned mux)
+{
+	int i;
+	for (i = 0; i < PXA3xx_MAX_MUX; i++) {
+		if (mfp->func[i] == mux)
+			break;
+	}
+	if (i >= PXA3xx_MAX_MUX)
+		return -EINVAL;
+	return i;
+}
+
+/* check whether current pin configuration is valid. Negative for failure */
+static int match_group_mux(struct pxa3xx_pin_group *grp,
+			   struct pxa3xx_pinmux_info *info,
+			   unsigned mux)
+{
+	int i, pin, ret = 0;
+	for (i = 0; i < grp->npins; i++) {
+		pin = grp->pins[i];
+		ret = match_mux(&info->mfp[pin], mux);
+		if (ret < 0) {
+			dev_err(info->dev, "Can't find mux %d on pin%d\n",
+				mux, pin);
+			break;
+		}
+	}
+	return ret;
+}
+
+static int pxa3xx_pmx_enable(struct pinctrl_dev *pctrldev, unsigned func,
+			     unsigned group)
+{
+	struct pxa3xx_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
+	struct pxa3xx_pin_group *pin_grp = &info->grps[group];
+	unsigned int data;
+	int i, mfpr, pin, pin_func;
+
+	if (!pin_grp->npins ||
+		(match_group_mux(pin_grp, info, pin_grp->mux) < 0)) {
+		dev_err(info->dev, "Failed to set the pin group: %d\n", group);
+		return -EINVAL;
+	}
+	for (i = 0; i < pin_grp->npins; i++) {
+		pin = pin_grp->pins[i];
+		pin_func = match_mux(&info->mfp[pin], pin_grp->mux);
+		mfpr = info->mfp[pin].mfpr;
+		data = readl_relaxed(info->virt_base + mfpr);
+	        data &= ~MFPR_FUNC_MASK;
+		data |= pin_func;
+		writel_relaxed(data, info->virt_base + mfpr);
+	}
+	return 0;
+}
+
+static void pxa3xx_pmx_disable(struct pinctrl_dev *pctrldev, unsigned func,
+			       unsigned group)
+{
+}
+
+static int pxa3xx_pmx_request_gpio(struct pinctrl_dev *pctrldev,
+				   struct pinctrl_gpio_range *range,
+				   unsigned pin)
+{
+	struct pxa3xx_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
+	unsigned int data;
+	int pin_func, mfpr;
+
+	pin_func = match_mux(&info->mfp[pin], PXA3xx_MUX_GPIO);
+	if (pin_func < 0) {
+		dev_err(info->dev, "No GPIO function on pin%d (%s)\n",
+			pin, info->pads[pin].name);
+		return -EINVAL;
+	}
+	mfpr = info->mfp[pin].mfpr;
+	/* write gpio function into mfpr register */
+	data = readl_relaxed(info->virt_base + mfpr) & ~MFPR_FUNC_MASK;
+	data |= pin_func;
+	writel_relaxed(data, info->virt_base + mfpr);
+	return 0;
+}
+
+static struct pinmux_ops pxa3xx_pmx_ops = {
+	.list_functions		= pxa3xx_pmx_list_func,
+	.get_function_name	= pxa3xx_pmx_get_func_name,
+	.get_function_groups	= pxa3xx_pmx_get_groups,
+	.enable			= pxa3xx_pmx_enable,
+	.disable		= pxa3xx_pmx_disable,
+	.gpio_request_enable	= pxa3xx_pmx_request_gpio,
+};
+
+int pxa3xx_pinctrl_register(struct platform_device *pdev,
+			    struct pxa3xx_pinmux_info *info)
+{
+	struct pinctrl_desc *desc;
+	struct resource *res;
+	int ret = 0;
+
+	if (!info || !info->cputype)
+		return -EINVAL;
+	desc = info->desc;
+	desc->pins = info->pads;
+	desc->npins = info->num_pads;
+	desc->pctlops = &pxa3xx_pctrl_ops;
+	desc->pmxops = &pxa3xx_pmx_ops;
+	info->dev = &pdev->dev;
+	pxa3xx_pinctrl_gpio_range.npins = info->num_gpio;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENOENT;
+	info->phy_base = res->start;
+	info->phy_size = resource_size(res);
+	info->virt_base = ioremap(info->phy_base, info->phy_size);
+	if (!info->virt_base)
+		return -ENOMEM;
+	info->pctrl = pinctrl_register(desc, &pdev->dev, info);
+	if (!info->pctrl) {
+		dev_err(&pdev->dev, "failed to register PXA pinmux driver\n");
+		ret = -EINVAL;
+		goto err;
+	}
+	pinctrl_add_gpio_range(info->pctrl, &pxa3xx_pinctrl_gpio_range);
+	platform_set_drvdata(pdev, info);
+	return 0;
+err:
+	iounmap(info->virt_base);
+	return ret;
+}
+
+int pxa3xx_pinctrl_unregister(struct platform_device *pdev)
+{
+	struct pxa3xx_pinmux_info *info = platform_get_drvdata(pdev);
+
+	pinctrl_unregister(info->pctrl);
+	iounmap(info->virt_base);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static int __init pxa3xx_pinctrl_init(void)
+{
+	pr_info("pxa3xx-pinctrl: PXA3xx pinctrl driver initializing\n");
+	return 0;
+}
+core_initcall_sync(pxa3xx_pinctrl_init);
+
+static void __exit pxa3xx_pinctrl_exit(void)
+{
+}
+module_exit(pxa3xx_pinctrl_exit);
+
+MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
+MODULE_DESCRIPTION("PXA3xx pin control driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/pinctrl/pinctrl-pxa3xx.h b/drivers/pinctrl/pinctrl-pxa3xx.h
new file mode 100644
index 0000000..8135744
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-pxa3xx.h
@@ -0,0 +1,264 @@
+/*
+ *  linux/drivers/pinctrl/pinctrl-pxa3xx.h
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ *
+ *  Copyright (C) 2011, Marvell Technology Group Ltd.
+ *
+ *  Author: Haojian Zhuang <haojian.zhuang@marvell.com>
+ *
+ */
+
+#ifndef __PINCTRL_PXA3XX_H
+
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+
+#define ARRAY_AND_SIZE(x)	(x), ARRAY_SIZE(x)
+
+#define PXA3xx_MUX_GPIO		0
+
+#define PXA3xx_MAX_MUX		8
+#define MFPR_FUNC_MASK		0x7
+
+enum pxa_cpu_type {
+	PINCTRL_INVALID = 0,
+	PINCTRL_PXA300,
+	PINCTRL_PXA310,
+	PINCTRL_PXA320,
+	PINCTRL_PXA168,
+	PINCTRL_PXA910,
+	PINCTRL_PXA930,
+	PINCTRL_PXA955,
+	PINCTRL_MMP2,
+	PINCTRL_MAX,
+};
+
+struct pxa3xx_mfp_pin {
+	const char *name;
+	const unsigned int pin;
+	const unsigned int mfpr;	/* register offset */
+	const unsigned short func[8];
+};
+
+struct pxa3xx_pin_group {
+	const char *name;
+	const unsigned mux;
+	const unsigned *pins;
+	const unsigned npins;
+};
+
+struct pxa3xx_pmx_func {
+	const char *name;
+	const char * const * groups;
+	const unsigned num_groups;
+};
+
+struct pxa3xx_pinmux_info {
+	struct device *dev;
+	struct pinctrl_dev *pctrl;
+	enum pxa_cpu_type cputype;
+	unsigned int phy_base;
+	unsigned int phy_size;
+	void __iomem *virt_base;
+
+	struct pxa3xx_mfp_pin *mfp;
+	unsigned int num_mfp;
+	struct pxa3xx_pin_group *grps;
+	unsigned int num_grps;
+	struct pxa3xx_pmx_func *funcs;
+	unsigned int num_funcs;
+	unsigned int num_gpio;
+	struct pinctrl_desc *desc;
+	struct pinctrl_pin_desc *pads;
+	unsigned int num_pads;
+
+	unsigned ds_mask;	/* drive strength mask */
+	unsigned ds_shift;	/* drive strength shift */
+	unsigned slp_mask;	/* sleep mask */
+	unsigned slp_input_low;
+	unsigned slp_input_high;
+	unsigned slp_output_low;
+	unsigned slp_output_high;
+	unsigned slp_float;
+};
+
+enum pxa3xx_pin_list {
+	GPIO0 = 0,
+	GPIO1,
+	GPIO2,
+	GPIO3,
+	GPIO4,
+	GPIO5,
+	GPIO6,
+	GPIO7,
+	GPIO8,
+	GPIO9,
+	GPIO10, /* 10 */
+	GPIO11,
+	GPIO12,
+	GPIO13,
+	GPIO14,
+	GPIO15,
+	GPIO16,
+	GPIO17,
+	GPIO18,
+	GPIO19,
+	GPIO20, /* 20 */
+	GPIO21,
+	GPIO22,
+	GPIO23,
+	GPIO24,
+	GPIO25,
+	GPIO26,
+	GPIO27,
+	GPIO28,
+	GPIO29,
+	GPIO30, /* 30 */
+	GPIO31,
+	GPIO32,
+	GPIO33,
+	GPIO34,
+	GPIO35,
+	GPIO36,
+	GPIO37,
+	GPIO38,
+	GPIO39,
+	GPIO40, /* 40 */
+	GPIO41,
+	GPIO42,
+	GPIO43,
+	GPIO44,
+	GPIO45,
+	GPIO46,
+	GPIO47,
+	GPIO48,
+	GPIO49,
+	GPIO50, /* 50 */
+	GPIO51,
+	GPIO52,
+	GPIO53,
+	GPIO54,
+	GPIO55,
+	GPIO56,
+	GPIO57,
+	GPIO58,
+	GPIO59,
+	GPIO60, /* 60 */
+	GPIO61,
+	GPIO62,
+	GPIO63,
+	GPIO64,
+	GPIO65,
+	GPIO66,
+	GPIO67,
+	GPIO68,
+	GPIO69,
+	GPIO70, /* 70 */
+	GPIO71,
+	GPIO72,
+	GPIO73,
+	GPIO74,
+	GPIO75,
+	GPIO76,
+	GPIO77,
+	GPIO78,
+	GPIO79,
+	GPIO80, /* 80 */
+	GPIO81,
+	GPIO82,
+	GPIO83,
+	GPIO84,
+	GPIO85,
+	GPIO86,
+	GPIO87,
+	GPIO88,
+	GPIO89,
+	GPIO90, /* 90 */
+	GPIO91,
+	GPIO92,
+	GPIO93,
+	GPIO94,
+	GPIO95,
+	GPIO96,
+	GPIO97,
+	GPIO98,
+	GPIO99,
+	GPIO100, /* 100 */
+	GPIO101,
+	GPIO102,
+	GPIO103,
+	GPIO104,
+	GPIO105,
+	GPIO106,
+	GPIO107,
+	GPIO108,
+	GPIO109,
+	GPIO110, /* 110 */
+	GPIO111,
+	GPIO112,
+	GPIO113,
+	GPIO114,
+	GPIO115,
+	GPIO116,
+	GPIO117,
+	GPIO118,
+	GPIO119,
+	GPIO120, /* 120 */
+	GPIO121,
+	GPIO122,
+	GPIO123,
+	GPIO124,
+	GPIO125,
+	GPIO126,
+	GPIO127,
+	GPIO128,
+	GPIO129,
+	GPIO130, /* 130 */
+	GPIO131,
+	GPIO132,
+	GPIO133,
+	GPIO134,
+	GPIO135,
+	GPIO136,
+	GPIO137,
+	GPIO138,
+	GPIO139,
+	GPIO140, /* 140 */
+	GPIO141,
+	GPIO142,
+	GPIO143,
+	GPIO144,
+	GPIO145,
+	GPIO146,
+	GPIO147,
+	GPIO148,
+	GPIO149,
+	GPIO150, /* 150 */
+	GPIO151,
+	GPIO152,
+	GPIO153,
+	GPIO154,
+	GPIO155,
+	GPIO156,
+	GPIO157,
+	GPIO158,
+	GPIO159,
+	GPIO160, /* 160 */
+	GPIO161,
+	GPIO162,
+	GPIO163,
+	GPIO164,
+	GPIO165,
+	GPIO166,
+	GPIO167,
+	GPIO168,
+	GPIO169,
+};
+
+extern int pxa3xx_pinctrl_register(struct platform_device *pdev,
+				   struct pxa3xx_pinmux_info *info);
+extern int pxa3xx_pinctrl_unregister(struct platform_device *pdev);
+#endif	/* __PINCTRL_PXA3XX_H */
diff --git a/drivers/pinctrl/pinctrl-pxa910.c b/drivers/pinctrl/pinctrl-pxa910.c
new file mode 100644
index 0000000..4404028
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-pxa910.c
@@ -0,0 +1,1008 @@
+/*
+ *  linux/drivers/pinctrl/pinmux-pxa910.c
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ *
+ *  Copyright (C) 2011, Marvell Technology Group Ltd.
+ *
+ *  Author: Haojian Zhuang <haojian.zhuang@marvell.com>
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include "pinctrl-pxa3xx.h"
+
+#define PXA910_DS_MASK		0x1800
+#define PXA910_DS_SHIFT		11
+#define PXA910_SLEEP_MASK	0x38
+#define PXA910_SLEEP_SELECT	(1 << 9)
+#define PXA910_SLEEP_DATA	(1 << 8)
+#define PXA910_SLEEP_DIR	(1 << 7)
+
+#define MFPR_910(a, r, f0, f1, f2, f3, f4, f5, f6, f7)		\
+	{							\
+		.name = #a,					\
+		.pin = a,					\
+		.mfpr = r,					\
+		.func = {					\
+			PXA910_MUX_##f0,			\
+			PXA910_MUX_##f1,			\
+			PXA910_MUX_##f2,			\
+			PXA910_MUX_##f3,			\
+			PXA910_MUX_##f4,			\
+			PXA910_MUX_##f5,			\
+			PXA910_MUX_##f6,			\
+			PXA910_MUX_##f7,			\
+		},						\
+	}
+
+#define GRP_910(a, m, p)		\
+	{ .name = a, .mux = PXA910_MUX_##m, .pins = p, .npins = ARRAY_SIZE(p), }
+
+/* 170 pins */
+enum pxa910_pin_list {
+	/* 0~127: GPIO0~GPIO127 */
+	ND_IO15 = 128,
+	ND_IO14,
+	ND_IO13, /* 130 */
+	ND_IO12,
+	ND_IO11,
+	ND_IO10,
+	ND_IO9,
+	ND_IO8,
+	ND_IO7,
+	ND_IO6,
+	ND_IO5,
+	ND_IO4,
+	ND_IO3, /* 140 */
+	ND_IO2,
+	ND_IO1,
+	ND_IO0,
+	ND_NCS0,
+	ND_NCS1,
+	SM_NCS0,
+	SM_NCS1,
+	ND_NWE,
+	ND_NRE,
+	ND_CLE, /* 150 */
+	ND_ALE,
+	SM_SCLK,
+	ND_RDY0,
+	SM_ADV,
+	ND_RDY1,
+	SM_ADVMUX,
+	SM_RDY,
+	MMC1_DAT7,
+	MMC1_DAT6,
+	MMC1_DAT5, /* 160 */
+	MMC1_DAT4,
+	MMC1_DAT3,
+	MMC1_DAT2,
+	MMC1_DAT1,
+	MMC1_DAT0,
+	MMC1_CMD,
+	MMC1_CLK,
+	MMC1_CD,
+	VCXO_OUT,
+};
+
+enum pxa910_mux {
+	/* PXA3xx_MUX_GPIO = 0 (predefined in pinctrl-pxa3xx.h) */
+	PXA910_MUX_GPIO = 0,
+	PXA910_MUX_NAND,
+	PXA910_MUX_USIM2,
+	PXA910_MUX_EXT_DMA,
+	PXA910_MUX_EXT_INT,
+	PXA910_MUX_MMC1,
+	PXA910_MUX_MMC2,
+	PXA910_MUX_MMC3,
+	PXA910_MUX_SM_INT,
+	PXA910_MUX_PRI_JTAG,
+	PXA910_MUX_SEC1_JTAG,
+	PXA910_MUX_SEC2_JTAG,
+	PXA910_MUX_RESET,	/* SLAVE RESET OUT */
+	PXA910_MUX_CLK_REQ,
+	PXA910_MUX_VCXO_REQ,
+	PXA910_MUX_VCXO_OUT,
+	PXA910_MUX_VCXO_REQ2,
+	PXA910_MUX_VCXO_OUT2,
+	PXA910_MUX_SPI,
+	PXA910_MUX_SPI2,
+	PXA910_MUX_GSSP,
+	PXA910_MUX_SSP0,
+	PXA910_MUX_SSP1,
+	PXA910_MUX_SSP2,
+	PXA910_MUX_DSSP2,
+	PXA910_MUX_DSSP3,
+	PXA910_MUX_UART0,
+	PXA910_MUX_UART1,
+	PXA910_MUX_UART2,
+	PXA910_MUX_TWSI,
+	PXA910_MUX_CCIC,
+	PXA910_MUX_PWM0,
+	PXA910_MUX_PWM1,
+	PXA910_MUX_PWM2,
+	PXA910_MUX_PWM3,
+	PXA910_MUX_HSL,
+	PXA910_MUX_ONE_WIRE,
+	PXA910_MUX_LCD,
+	PXA910_MUX_DAC_ST23,
+	PXA910_MUX_ULPI,
+	PXA910_MUX_TB,
+	PXA910_MUX_KP_MK,
+	PXA910_MUX_KP_DK,
+	PXA910_MUX_TCU_GPOA,
+	PXA910_MUX_TCU_GPOB,
+	PXA910_MUX_ROT,
+	PXA910_MUX_TDS,
+	PXA910_MUX_32K_CLK, /* 32KHz CLK OUT */
+	PXA910_MUX_MN_CLK, /* MN CLK OUT */
+	PXA910_MUX_SMC,
+	PXA910_MUX_SM_ADDR18,
+	PXA910_MUX_SM_ADDR19,
+	PXA910_MUX_SM_ADDR20,
+	PXA910_MUX_NONE = 0xffff,
+};
+
+
+static struct pinctrl_pin_desc pxa910_pads[] = {
+	PINCTRL_PIN(GPIO0, "GPIO0"),
+	PINCTRL_PIN(GPIO1, "GPIO1"),
+	PINCTRL_PIN(GPIO2, "GPIO2"),
+	PINCTRL_PIN(GPIO3, "GPIO3"),
+	PINCTRL_PIN(GPIO4, "GPIO4"),
+	PINCTRL_PIN(GPIO5, "GPIO5"),
+	PINCTRL_PIN(GPIO6, "GPIO6"),
+	PINCTRL_PIN(GPIO7, "GPIO7"),
+	PINCTRL_PIN(GPIO8, "GPIO8"),
+	PINCTRL_PIN(GPIO9, "GPIO9"),
+	PINCTRL_PIN(GPIO10, "GPIO10"),
+	PINCTRL_PIN(GPIO11, "GPIO11"),
+	PINCTRL_PIN(GPIO12, "GPIO12"),
+	PINCTRL_PIN(GPIO13, "GPIO13"),
+	PINCTRL_PIN(GPIO14, "GPIO14"),
+	PINCTRL_PIN(GPIO15, "GPIO15"),
+	PINCTRL_PIN(GPIO16, "GPIO16"),
+	PINCTRL_PIN(GPIO17, "GPIO17"),
+	PINCTRL_PIN(GPIO18, "GPIO18"),
+	PINCTRL_PIN(GPIO19, "GPIO19"),
+	PINCTRL_PIN(GPIO20, "GPIO20"),
+	PINCTRL_PIN(GPIO21, "GPIO21"),
+	PINCTRL_PIN(GPIO22, "GPIO22"),
+	PINCTRL_PIN(GPIO23, "GPIO23"),
+	PINCTRL_PIN(GPIO24, "GPIO24"),
+	PINCTRL_PIN(GPIO25, "GPIO25"),
+	PINCTRL_PIN(GPIO26, "GPIO26"),
+	PINCTRL_PIN(GPIO27, "GPIO27"),
+	PINCTRL_PIN(GPIO28, "GPIO28"),
+	PINCTRL_PIN(GPIO29, "GPIO29"),
+	PINCTRL_PIN(GPIO30, "GPIO30"),
+	PINCTRL_PIN(GPIO31, "GPIO31"),
+	PINCTRL_PIN(GPIO32, "GPIO32"),
+	PINCTRL_PIN(GPIO33, "GPIO33"),
+	PINCTRL_PIN(GPIO34, "GPIO34"),
+	PINCTRL_PIN(GPIO35, "GPIO35"),
+	PINCTRL_PIN(GPIO36, "GPIO36"),
+	PINCTRL_PIN(GPIO37, "GPIO37"),
+	PINCTRL_PIN(GPIO38, "GPIO38"),
+	PINCTRL_PIN(GPIO39, "GPIO39"),
+	PINCTRL_PIN(GPIO40, "GPIO40"),
+	PINCTRL_PIN(GPIO41, "GPIO41"),
+	PINCTRL_PIN(GPIO42, "GPIO42"),
+	PINCTRL_PIN(GPIO43, "GPIO43"),
+	PINCTRL_PIN(GPIO44, "GPIO44"),
+	PINCTRL_PIN(GPIO45, "GPIO45"),
+	PINCTRL_PIN(GPIO46, "GPIO46"),
+	PINCTRL_PIN(GPIO47, "GPIO47"),
+	PINCTRL_PIN(GPIO48, "GPIO48"),
+	PINCTRL_PIN(GPIO49, "GPIO49"),
+	PINCTRL_PIN(GPIO50, "GPIO50"),
+	PINCTRL_PIN(GPIO51, "GPIO51"),
+	PINCTRL_PIN(GPIO52, "GPIO52"),
+	PINCTRL_PIN(GPIO53, "GPIO53"),
+	PINCTRL_PIN(GPIO54, "GPIO54"),
+	PINCTRL_PIN(GPIO55, "GPIO55"),
+	PINCTRL_PIN(GPIO56, "GPIO56"),
+	PINCTRL_PIN(GPIO57, "GPIO57"),
+	PINCTRL_PIN(GPIO58, "GPIO58"),
+	PINCTRL_PIN(GPIO59, "GPIO59"),
+	PINCTRL_PIN(GPIO60, "GPIO60"),
+	PINCTRL_PIN(GPIO61, "GPIO61"),
+	PINCTRL_PIN(GPIO62, "GPIO62"),
+	PINCTRL_PIN(GPIO63, "GPIO63"),
+	PINCTRL_PIN(GPIO64, "GPIO64"),
+	PINCTRL_PIN(GPIO65, "GPIO65"),
+	PINCTRL_PIN(GPIO66, "GPIO66"),
+	PINCTRL_PIN(GPIO67, "GPIO67"),
+	PINCTRL_PIN(GPIO68, "GPIO68"),
+	PINCTRL_PIN(GPIO69, "GPIO69"),
+	PINCTRL_PIN(GPIO70, "GPIO70"),
+	PINCTRL_PIN(GPIO71, "GPIO71"),
+	PINCTRL_PIN(GPIO72, "GPIO72"),
+	PINCTRL_PIN(GPIO73, "GPIO73"),
+	PINCTRL_PIN(GPIO74, "GPIO74"),
+	PINCTRL_PIN(GPIO75, "GPIO75"),
+	PINCTRL_PIN(GPIO76, "GPIO76"),
+	PINCTRL_PIN(GPIO77, "GPIO77"),
+	PINCTRL_PIN(GPIO78, "GPIO78"),
+	PINCTRL_PIN(GPIO79, "GPIO79"),
+	PINCTRL_PIN(GPIO80, "GPIO80"),
+	PINCTRL_PIN(GPIO81, "GPIO81"),
+	PINCTRL_PIN(GPIO82, "GPIO82"),
+	PINCTRL_PIN(GPIO83, "GPIO83"),
+	PINCTRL_PIN(GPIO84, "GPIO84"),
+	PINCTRL_PIN(GPIO85, "GPIO85"),
+	PINCTRL_PIN(GPIO86, "GPIO86"),
+	PINCTRL_PIN(GPIO87, "GPIO87"),
+	PINCTRL_PIN(GPIO88, "GPIO88"),
+	PINCTRL_PIN(GPIO89, "GPIO89"),
+	PINCTRL_PIN(GPIO90, "GPIO90"),
+	PINCTRL_PIN(GPIO91, "GPIO91"),
+	PINCTRL_PIN(GPIO92, "GPIO92"),
+	PINCTRL_PIN(GPIO93, "GPIO93"),
+	PINCTRL_PIN(GPIO94, "GPIO94"),
+	PINCTRL_PIN(GPIO95, "GPIO95"),
+	PINCTRL_PIN(GPIO96, "GPIO96"),
+	PINCTRL_PIN(GPIO97, "GPIO97"),
+	PINCTRL_PIN(GPIO98, "GPIO98"),
+	PINCTRL_PIN(GPIO99, "GPIO99"),
+	PINCTRL_PIN(GPIO100, "GPIO100"),
+	PINCTRL_PIN(GPIO101, "GPIO101"),
+	PINCTRL_PIN(GPIO102, "GPIO102"),
+	PINCTRL_PIN(GPIO103, "GPIO103"),
+	PINCTRL_PIN(GPIO104, "GPIO104"),
+	PINCTRL_PIN(GPIO105, "GPIO105"),
+	PINCTRL_PIN(GPIO106, "GPIO106"),
+	PINCTRL_PIN(GPIO107, "GPIO107"),
+	PINCTRL_PIN(GPIO108, "GPIO108"),
+	PINCTRL_PIN(GPIO109, "GPIO109"),
+	PINCTRL_PIN(GPIO110, "GPIO110"),
+	PINCTRL_PIN(GPIO111, "GPIO111"),
+	PINCTRL_PIN(GPIO112, "GPIO112"),
+	PINCTRL_PIN(GPIO113, "GPIO113"),
+	PINCTRL_PIN(GPIO114, "GPIO114"),
+	PINCTRL_PIN(GPIO115, "GPIO115"),
+	PINCTRL_PIN(GPIO116, "GPIO116"),
+	PINCTRL_PIN(GPIO117, "GPIO117"),
+	PINCTRL_PIN(GPIO118, "GPIO118"),
+	PINCTRL_PIN(GPIO119, "GPIO119"),
+	PINCTRL_PIN(GPIO120, "GPIO120"),
+	PINCTRL_PIN(GPIO121, "GPIO121"),
+	PINCTRL_PIN(GPIO122, "GPIO122"),
+	PINCTRL_PIN(GPIO123, "GPIO123"),
+	PINCTRL_PIN(GPIO124, "GPIO124"),
+	PINCTRL_PIN(GPIO125, "GPIO125"),
+	PINCTRL_PIN(GPIO126, "GPIO126"),
+	PINCTRL_PIN(GPIO127, "GPIO127"),
+	PINCTRL_PIN(ND_IO15, "ND_IO15"),
+	PINCTRL_PIN(ND_IO14, "ND_IO14"),
+	PINCTRL_PIN(ND_IO13, "ND_IO13"),
+	PINCTRL_PIN(ND_IO12, "ND_IO12"),
+	PINCTRL_PIN(ND_IO11, "ND_IO11"),
+	PINCTRL_PIN(ND_IO10, "ND_IO10"),
+	PINCTRL_PIN(ND_IO9, "ND_IO9"),
+	PINCTRL_PIN(ND_IO8, "ND_IO8"),
+	PINCTRL_PIN(ND_IO7, "ND_IO7"),
+	PINCTRL_PIN(ND_IO6, "ND_IO6"),
+	PINCTRL_PIN(ND_IO5, "ND_IO5"),
+	PINCTRL_PIN(ND_IO4, "ND_IO4"),
+	PINCTRL_PIN(ND_IO3, "ND_IO3"),
+	PINCTRL_PIN(ND_IO2, "ND_IO2"),
+	PINCTRL_PIN(ND_IO1, "ND_IO1"),
+	PINCTRL_PIN(ND_IO0, "ND_IO0"),
+	PINCTRL_PIN(ND_NCS0, "ND_NCS0_SM_NCS2"),
+	PINCTRL_PIN(ND_NCS1, "ND_NCS1_SM_NCS3"),
+	PINCTRL_PIN(SM_NCS0, "SM_NCS0"),
+	PINCTRL_PIN(SM_NCS1, "SM_NCS1"),
+	PINCTRL_PIN(ND_NWE, "ND_NWE"),
+	PINCTRL_PIN(ND_NRE, "ND_NRE"),
+	PINCTRL_PIN(ND_CLE, "ND_CLE_SM_NOE"),
+	PINCTRL_PIN(ND_ALE, "ND_ALE_SM_NWE"),
+	PINCTRL_PIN(SM_SCLK, "SM_SCLK"),
+	PINCTRL_PIN(ND_RDY0, "ND_RDY0"),
+	PINCTRL_PIN(SM_ADV, "SM_ADV"),
+	PINCTRL_PIN(ND_RDY1, "ND_RDY1"),
+	PINCTRL_PIN(SM_RDY, "SM_RDY"),
+	PINCTRL_PIN(MMC1_DAT7, "MMC1_DAT7"),
+	PINCTRL_PIN(MMC1_DAT6, "MMC1_DAT6"),
+	PINCTRL_PIN(MMC1_DAT5, "MMC1_DAT5"),
+	PINCTRL_PIN(MMC1_DAT4, "MMC1_DAT4"),
+	PINCTRL_PIN(MMC1_DAT3, "MMC1_DAT3"),
+	PINCTRL_PIN(MMC1_DAT2, "MMC1_DAT2"),
+	PINCTRL_PIN(MMC1_DAT1, "MMC1_DAT1"),
+	PINCTRL_PIN(MMC1_DAT0, "MMC1_DAT0"),
+	PINCTRL_PIN(MMC1_CMD, "MMC1 CMD"),
+	PINCTRL_PIN(MMC1_CLK, "MMC1 CLK"),
+	PINCTRL_PIN(MMC1_CD, "MMC1 CD"),
+	PINCTRL_PIN(VCXO_OUT, "VCXO_OUT"),
+};
+
+struct pxa3xx_mfp_pin pxa910_mfp[] = {
+	/*       pin        offs   f0        f1      f2         f3         f4         f5        f6        f7  */
+	MFPR_910(GPIO0,     0x0DC, GPIO,     KP_MK,  NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO1,     0x0E0, GPIO,     KP_MK,  NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO2,     0x0E4, GPIO,     KP_MK,  NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO3,     0x0E8, GPIO,     KP_MK,  NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO4,     0x0EC, GPIO,     KP_MK,  NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO5,     0x0F0, GPIO,     KP_MK,  NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO6,     0x0F4, GPIO,     KP_MK,  NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO7,     0x0F8, GPIO,     KP_MK,  NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO8,     0x0FC, GPIO,     KP_MK,  NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO9,     0x100, GPIO,     KP_MK,  NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO10,    0x104, GPIO,     KP_MK,  NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO11,    0x108, GPIO,     KP_MK,  NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO12,    0x10C, GPIO,     KP_MK,  NONE,      NONE,      KP_DK,     NONE,     NONE,     NONE),
+	MFPR_910(GPIO13,    0x110, GPIO,     KP_MK,  NONE,      NONE,      KP_DK,     NONE,     NONE,     NONE),
+	MFPR_910(GPIO14,    0x114, GPIO,     KP_MK,  NONE,      NONE,      KP_DK,     TB,       NONE,     NONE),
+	MFPR_910(GPIO15,    0x118, GPIO,     KP_MK,  NONE,      NONE,      KP_DK,     TB,       NONE,     NONE),
+	MFPR_910(GPIO16,    0x11C, GPIO,     KP_DK,  NONE,      NONE,      NONE,      TB,       NONE,     NONE),
+	MFPR_910(GPIO17,    0x120, GPIO,     KP_DK,  NONE,      NONE,      NONE,      TB,       NONE,     NONE),
+	MFPR_910(GPIO18,    0x124, GPIO,     KP_DK,  NONE,      NONE,      ROT,       NONE,     NONE,     NONE),
+	MFPR_910(GPIO19,    0x128, GPIO,     KP_DK,  NONE,      NONE,      ROT,       NONE,     NONE,     NONE),
+	MFPR_910(GPIO20,    0x12C, GPIO,     SSP1,   NONE,      NONE,      VCXO_OUT,  NONE,     NONE,     NONE),
+	MFPR_910(GPIO21,    0x130, GPIO,     SSP1,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO22,    0x134, GPIO,     SSP1,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO23,    0x138, GPIO,     SSP1,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO24,    0x13C, GPIO,     SSP1,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO25,    0x140, GPIO,     GSSP,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO26,    0x144, GPIO,     GSSP,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO27,    0x148, GPIO,     GSSP,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO28,    0x14C, GPIO,     GSSP,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO29,    0x150, GPIO,     UART0,  NONE,      NONE,      UART1,     NONE,     NONE,     NONE),
+	MFPR_910(GPIO30,    0x154, GPIO,     UART0,  NONE,      NONE,      UART1,     NONE,     NONE,     NONE),
+	MFPR_910(GPIO31,    0x158, GPIO,     UART0,  NONE,      NONE,      UART1,     NONE,     NONE,     NONE),
+	MFPR_910(GPIO32,    0x15C, GPIO,     UART0,  DAC_ST23,  NONE,      UART1,     NONE,     NONE,     NONE),
+	MFPR_910(GPIO33,    0x160, GPIO,     MMC2,   SSP0,      SSP2,      NONE,      SPI,      NONE,     MMC3),
+	MFPR_910(GPIO34,    0x164, GPIO,     MMC2,   SSP0,      SSP2,      NONE,      SPI,      NONE,     MMC3),
+	MFPR_910(GPIO35,    0x168, GPIO,     MMC2,   SSP0,      SSP2,      NONE,      SPI,      NONE,     MMC3),
+	MFPR_910(GPIO36,    0x16C, GPIO,     MMC2,   SSP0,      SSP2,      NONE,      SPI,      NONE,     MMC3),
+	MFPR_910(GPIO37,    0x170, GPIO,     MMC2,   NONE,      NONE,      NONE,      SPI,      HSL,      NONE),
+	MFPR_910(GPIO38,    0x174, GPIO,     MMC2,   NONE,      NONE,      NONE,      NONE,     HSL,      NONE),
+	MFPR_910(GPIO39,    0x178, GPIO,     MMC2,   NONE,      NONE,      NONE,      NONE,     HSL,      NONE),
+	MFPR_910(GPIO40,    0x17C, GPIO,     MMC2,   NONE,      NONE,      NONE,      NONE,     HSL,      NONE),
+	MFPR_910(GPIO41,    0x180, GPIO,     MMC2,   NONE,      NONE,      NONE,      NONE,     HSL,      NONE),
+	MFPR_910(GPIO42,    0x184, GPIO,     MMC2,   NONE,      NONE,      NONE,      NONE,     HSL,      NONE),
+	MFPR_910(GPIO43,    0x188, GPIO,     UART1,  NONE,      DAC_ST23,  NONE,      DSSP2,    SPI,      UART2),
+	MFPR_910(GPIO44,    0x18C, GPIO,     UART1,  NONE,      EXT_INT,   NONE,      DSSP2,    SPI,      UART2),
+	MFPR_910(GPIO45,    0x190, GPIO,     UART1,  NONE,      EXT_INT,   NONE,      DSSP2,    SPI,      UART2),
+	MFPR_910(GPIO46,    0x194, GPIO,     UART1,  NONE,      EXT_INT,   NONE,      DSSP2,    SPI,      UART2),
+	MFPR_910(GPIO47,    0x198, GPIO,     SSP0,   NONE,      NONE,      NONE,      SSP2,     UART1,    NONE),
+	MFPR_910(GPIO48,    0x19C, GPIO,     SSP0,   NONE,      NONE,      NONE,      SSP2,     UART1,    NONE),
+	MFPR_910(GPIO49,    0x1A0, GPIO,     SSP0,   UART0,     VCXO_REQ,  NONE,      SSP2,     NONE,     MMC3),
+	MFPR_910(GPIO50,    0x1A4, GPIO,     SSP0,   UART0,     VCXO_OUT,  NONE,      SSP2,     NONE,     MMC3),
+	MFPR_910(GPIO51,    0x1A8, GPIO,     UART2,  PWM1,      TWSI,      SSP0,      NONE,     DSSP3,    NONE),
+	MFPR_910(GPIO52,    0x1AC, GPIO,     UART2,  DAC_ST23,  TWSI,      SSP0,      NONE,     DSSP3,    NONE),
+	MFPR_910(GPIO53,    0x1B0, GPIO,     UART2,  TWSI,      NONE,      SSP0,      NONE,     DSSP3,    NONE),
+	MFPR_910(GPIO54,    0x1B4, GPIO,     UART2,  TWSI,      SSP0,      NONE,      NONE,     DSSP3,    NONE),
+	MFPR_910(GPIO55,    0x2F0, TDS,      GPIO,   TB,        NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO56,    0x2F4, TDS,      GPIO,   TB,        NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO57,    0x2F8, TDS,      GPIO,   TB,        NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO58,    0x2FC, TDS,      GPIO,   TB,        NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO59,    0x300, TDS,      GPIO,   TCU_GPOA,  TCU_GPOB,  ONE_WIRE,  NONE,     NONE,     NONE),
+	MFPR_910(GPIO60,    0x304, GPIO,     NONE,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO61,    0x308, GPIO,     NONE,   NONE,      NONE,      NONE,      NONE,     NONE,     HSL),
+	MFPR_910(GPIO62,    0x30C, GPIO,     NONE,   NONE,      NONE,      NONE,      NONE,     NONE,     HSL),
+	MFPR_910(GPIO63,    0x310, GPIO,     NONE,   NONE,      NONE,      NONE,      NONE,     NONE,     HSL),
+	MFPR_910(GPIO64,    0x314, GPIO,     SPI2,   NONE,      NONE,      NONE,      NONE,     NONE,     HSL),
+	MFPR_910(GPIO65,    0x318, GPIO,     SPI2,   NONE,      NONE,      NONE,      NONE,     ONE_WIRE, HSL),
+	MFPR_910(GPIO66,    0x31C, GPIO,     NONE,   NONE,      NONE,      NONE,      NONE,     NONE,     HSL),
+	MFPR_910(GPIO67,    0x1B8, GPIO,     CCIC,   SPI,       NONE,      NONE,      ULPI,     NONE,     USIM2),
+	MFPR_910(GPIO68,    0x1BC, GPIO,     CCIC,   SPI,       NONE,      NONE,      ULPI,     NONE,     USIM2),
+	MFPR_910(GPIO69,    0x1C0, GPIO,     CCIC,   SPI,       NONE,      NONE,      ULPI,     NONE,     USIM2),
+	MFPR_910(GPIO70,    0x1C4, GPIO,     CCIC,   SPI,       NONE,      NONE,      ULPI,     NONE,     NONE),
+	MFPR_910(GPIO71,    0x1C8, GPIO,     CCIC,   SPI,       NONE,      NONE,      ULPI,     NONE,     NONE),
+	MFPR_910(GPIO72,    0x1CC, GPIO,     CCIC,   EXT_DMA,   NONE,      NONE,      ULPI,     NONE,     NONE),
+	MFPR_910(GPIO73,    0x1D0, GPIO,     CCIC,   EXT_DMA,   NONE,      NONE,      ULPI,     NONE,     NONE),
+	MFPR_910(GPIO74,    0x1D4, GPIO,     CCIC,   EXT_DMA,   NONE,      NONE,      ULPI,     NONE,     NONE),
+	MFPR_910(GPIO75,    0x1D8, GPIO,     CCIC,   NONE,      NONE,      NONE,      ULPI,     NONE,     NONE),
+	MFPR_910(GPIO76,    0x1DC, GPIO,     CCIC,   NONE,      NONE,      NONE,      ULPI,     NONE,     NONE),
+	MFPR_910(GPIO77,    0x1E0, GPIO,     CCIC,   NONE,      NONE,      NONE,      ULPI,     NONE,     NONE),
+	MFPR_910(GPIO78,    0x1E4, GPIO,     CCIC,   NONE,      NONE,      NONE,      ULPI,     NONE,     NONE),
+	MFPR_910(GPIO79,    0x1E8, GPIO,     TWSI,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO80,    0x1EC, GPIO,     TWSI,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO81,    0x1F0, GPIO,     LCD,    NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO82,    0x1F4, GPIO,     LCD,    NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO83,    0x1F8, GPIO,     LCD,    NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO84,    0x1FC, GPIO,     LCD,    VCXO_REQ2, NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO85,    0x200, GPIO,     LCD,    NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO86,    0x204, GPIO,     LCD,    VCXO_OUT2, NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO87,    0x208, GPIO,     LCD,    NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO88,    0x20C, GPIO,     LCD,    NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO89,    0x210, GPIO,     LCD,    NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO90,    0x214, GPIO,     LCD,    NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO91,    0x218, GPIO,     LCD,    NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO92,    0x21C, GPIO,     LCD,    NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO93,    0x220, GPIO,     LCD,    NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO94,    0x224, GPIO,     LCD,    NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO95,    0x228, GPIO,     LCD,    NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO96,    0x22C, GPIO,     LCD,    NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO97,    0x230, GPIO,     LCD,    NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO98,    0x234, GPIO,     LCD,    NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO99,    0x0B0, MMC1,     GPIO,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO100,   0x238, GPIO,     LCD,    NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO101,   0x23C, GPIO,     LCD,    NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO102,   0x240, GPIO,     LCD,    DSSP2,     SPI,       NONE,      NONE,     NONE,     SPI2),
+	MFPR_910(GPIO103,   0x244, GPIO,     LCD,    DSSP2,     SPI,       NONE,      NONE,     NONE,     SPI2),
+	MFPR_910(GPIO104,   0x248, GPIO,     LCD,    DSSP2,     SPI,       NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO105,   0x24C, GPIO,     LCD,    DSSP2,     SPI,       NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO106,   0x250, GPIO,     LCD,    DSSP3,     ONE_WIRE,  NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO107,   0x254, GPIO,     LCD,    DSSP3,     SPI,       NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO108,   0x258, GPIO,     LCD,    DSSP3,     SPI,       NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO109,   0x25C, GPIO,     LCD,    DSSP3,     SPI,       NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO110,   0x298, GPIO,     NONE,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO111,   0x29C, GPIO,     NONE,   DSSP2,     NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO112,   0x2A0, GPIO,     NONE,   DSSP2,     NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO113,   0x2A4, GPIO,     NONE,   DSSP2,     NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO114,   0x2A8, GPIO,     NONE,   DSSP3,     NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO115,   0x2AC, GPIO,     NONE,   DSSP3,     NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO116,   0x2B0, GPIO,     NONE,   DSSP3,     NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO117,   0x0B4, PRI_JTAG, GPIO,   PWM0,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO118,   0x0B8, PRI_JTAG, GPIO,   PWM1,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO119,   0x0BC, PRI_JTAG, GPIO,   PWM2,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO120,   0x0C0, PRI_JTAG, GPIO,   PWM3,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO121,   0x32C, GPIO,     NONE,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO122,   0x0C8, RESET,    GPIO,   32K_CLK,   NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO123,   0x0CC, CLK_REQ,  GPIO,   ONE_WIRE,  EXT_DMA,   NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO124,   0x0D0, GPIO,     MN_CLK, DAC_ST23,  NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO125,   0x0D4, VCXO_REQ, GPIO,   NONE,      EXT_INT,   NONE,      NONE,     NONE,     NONE),
+	MFPR_910(GPIO126,   0x06C, GPIO,     SMC,    NONE,      SM_ADDR18, NONE,      EXT_DMA,  NONE,     NONE),
+	MFPR_910(GPIO127,   0x070, GPIO,     SMC,    NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_IO15,   0x004, NAND,     GPIO,   USIM2,     EXT_DMA,   NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_IO14,   0x008, NAND,     GPIO,   USIM2,     NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_IO13,   0x00C, NAND,     GPIO,   USIM2,     EXT_INT,   NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_IO12,   0x010, NAND,     GPIO,   SSP2,      EXT_INT,   NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_IO11,   0x014, NAND,     GPIO,   SSP2,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_IO10,   0x018, NAND,     GPIO,   SSP2,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_IO9,    0x01C, NAND,     GPIO,   SSP2,      NONE,      VCXO_OUT2, NONE,     NONE,     NONE),
+	MFPR_910(ND_IO8,    0x020, NAND,     GPIO,   NONE,      NONE,      PWM3,      NONE,     NONE,     NONE),
+	MFPR_910(ND_IO7,    0x024, NAND,     MMC3,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_IO6,    0x028, NAND,     MMC3,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_IO5,    0x02C, NAND,     MMC3,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_IO4,    0x030, NAND,     MMC3,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_IO3,    0x034, NAND,     MMC3,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_IO2,    0x038, NAND,     MMC3,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_IO1,    0x03C, NAND,     MMC3,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_IO0,    0x040, NAND,     MMC3,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_NCS0,   0x044, NAND,     GPIO,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_NCS1,   0x048, NAND,     GPIO,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(SM_NCS0,   0x04C, SMC,      GPIO,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(SM_NCS1,   0x050, SMC,      GPIO,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_NWE,    0x054, GPIO,     NAND,   NONE,      SM_ADDR20, NONE,      SMC,      NONE,     NONE),
+	MFPR_910(ND_NRE,    0x058, GPIO,     NAND,   NONE,      SMC,       NONE,      EXT_DMA,  NONE,     NONE),
+	MFPR_910(ND_CLE,    0x05C, NAND,     MMC3,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_ALE,    0x060, GPIO,     NAND,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(SM_SCLK,   0x064, MMC3,     NONE,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_RDY0,   0x068, NAND,     GPIO,   NONE,      SMC,       NONE,      NONE,     NONE,     NONE),
+	MFPR_910(SM_ADV,    0x074, SMC,      GPIO,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(ND_RDY1,   0x078, NAND,     GPIO,   NONE,      SMC,       NONE,      NONE,     NONE,     NONE),
+	MFPR_910(SM_ADVMUX, 0x07C, SMC,      GPIO,   NONE,      SM_ADDR19, NONE,      NONE,     NONE,     NONE),
+	MFPR_910(SM_RDY,    0x080, SMC,      GPIO,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(MMC1_DAT7, 0x084, MMC1,     GPIO,   SEC1_JTAG, TB,        NONE,      NONE,     NONE,     NONE),
+	MFPR_910(MMC1_DAT6, 0x088, MMC1,     GPIO,   SEC1_JTAG, TB,        NONE,      NONE,     NONE,     NONE),
+	MFPR_910(MMC1_DAT5, 0x08C, MMC1,     GPIO,   SEC1_JTAG, TB,        NONE,      NONE,     NONE,     NONE),
+	MFPR_910(MMC1_DAT4, 0x090, MMC1,     GPIO,   NONE,      TB,        NONE,      NONE,     NONE,     NONE),
+	MFPR_910(MMC1_DAT3, 0x094, MMC1,     HSL,    SEC2_JTAG, SSP0,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(MMC1_DAT2, 0x098, MMC1,     HSL,    SEC2_JTAG, SSP2,      SSP0,      NONE,     NONE,     NONE),
+	MFPR_910(MMC1_DAT1, 0x09C, MMC1,     HSL,    SEC2_JTAG, SSP2,      SSP0,      NONE,     NONE,     NONE),
+	MFPR_910(MMC1_DAT0, 0x0A0, MMC1,     HSL,    SEC2_JTAG, SSP2,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(MMC1_CMD,  0x0A4, MMC1,     HSL,    SEC1_JTAG, SSP2,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(MMC1_CLK,  0x0A8, MMC1,     HSL,    SEC2_JTAG, SSP0,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(MMC1_CD,   0x0AC, MMC1,     GPIO,   SEC1_JTAG, NONE,      NONE,      NONE,     NONE,     NONE),
+	MFPR_910(VCXO_OUT,  0x0D8, VCXO_OUT, PWM3,   NONE,      NONE,      NONE,      NONE,     NONE,     NONE),
+};
+
+
+static const unsigned p910_usim2_pin1[] = {GPIO67, GPIO68, GPIO69};
+static const unsigned p910_usim2_pin2[] = {ND_IO15, ND_IO14, ND_IO13};
+static const unsigned p910_mmc1_pin1[] = {MMC1_DAT7, MMC1_DAT6, MMC1_DAT5,
+	MMC1_DAT4, MMC1_DAT3, MMC1_DAT2, MMC1_DAT1, MMC1_DAT0, MMC1_CMD,
+	MMC1_CLK, MMC1_CD, GPIO99};
+static const unsigned p910_mmc2_pin1[] = {GPIO33, GPIO34, GPIO35, GPIO36,
+	GPIO37, GPIO38, GPIO39, GPIO40, GPIO41, GPIO42};
+static const unsigned p910_mmc3_pin1[] = {GPIO33, GPIO34, GPIO35, GPIO36,
+	GPIO49, GPIO50};
+static const unsigned p910_mmc3_pin2[] = {ND_IO7, ND_IO6, ND_IO5, ND_IO4,
+	ND_IO3, ND_IO2, ND_IO1, ND_IO0, ND_CLE, SM_SCLK};
+static const unsigned p910_uart0_pin1[] = {GPIO29, GPIO30, GPIO31, GPIO32};
+static const unsigned p910_uart1_pin1[] = {GPIO47, GPIO48};
+static const unsigned p910_uart1_pin2[] = {GPIO31, GPIO32};
+static const unsigned p910_uart1_pin3[] = {GPIO45, GPIO46};
+static const unsigned p910_uart1_pin4[] = {GPIO29, GPIO30, GPIO31, GPIO32};
+static const unsigned p910_uart1_pin5[] = {GPIO43, GPIO44, GPIO45, GPIO46};
+static const unsigned p910_uart2_pin1[] = {GPIO43, GPIO44};
+static const unsigned p910_uart2_pin2[] = {GPIO51, GPIO52};
+static const unsigned p910_uart2_pin3[] = {GPIO43, GPIO44, GPIO45, GPIO46};
+static const unsigned p910_uart2_pin4[] = {GPIO51, GPIO52, GPIO53, GPIO54};
+static const unsigned p910_twsi_pin1[] = {GPIO51, GPIO52};
+static const unsigned p910_twsi_pin2[] = {GPIO53, GPIO54};
+static const unsigned p910_twsi_pin3[] = {GPIO79, GPIO80};
+static const unsigned p910_ccic_pin1[] = {GPIO67, GPIO68, GPIO69, GPIO70,
+	GPIO71, GPIO72, GPIO73, GPIO74, GPIO75, GPIO76, GPIO77, GPIO78};
+static const unsigned p910_lcd_pin1[] = {GPIO81, GPIO82, GPIO83, GPIO84,
+	GPIO85, GPIO86, GPIO87, GPIO88, GPIO89, GPIO90, GPIO91, GPIO92,
+	GPIO93, GPIO94, GPIO95, GPIO96, GPIO97, GPIO98, GPIO100, GPIO101,
+	GPIO102, GPIO103};
+static const unsigned p910_spi_pin1[] = {GPIO104, GPIO105, GPIO107, GPIO108};
+static const unsigned p910_spi_pin2[] = {GPIO43, GPIO44, GPIO45, GPIO46};
+static const unsigned p910_spi_pin3[] = {GPIO33, GPIO34, GPIO35, GPIO36,
+	GPIO37};
+static const unsigned p910_spi_pin4[] = {GPIO67, GPIO68, GPIO69, GPIO70,
+	GPIO71};
+static const unsigned p910_spi2_pin1[] = {GPIO64, GPIO65};
+static const unsigned p910_spi2_pin2[] = {GPIO102, GPIO103};
+static const unsigned p910_dssp2_pin1[] = {GPIO102, GPIO103, GPIO104, GPIO105};
+static const unsigned p910_dssp2_pin2[] = {GPIO43, GPIO44, GPIO45, GPIO46};
+static const unsigned p910_dssp2_pin3[] = {GPIO111, GPIO112, GPIO113};
+static const unsigned p910_dssp3_pin1[] = {GPIO106, GPIO107, GPIO108, GPIO109};
+static const unsigned p910_dssp3_pin2[] = {GPIO51, GPIO52, GPIO53, GPIO54};
+static const unsigned p910_dssp3_pin3[] = {GPIO114, GPIO115, GPIO116};
+static const unsigned p910_ssp0_pin1[] = {MMC1_DAT3, MMC1_DAT2, MMC1_DAT1,
+	MMC1_CLK};
+static const unsigned p910_ssp0_pin2[] = {GPIO33, GPIO34, GPIO35, GPIO36};
+static const unsigned p910_ssp0_pin3[] = {GPIO47, GPIO48, GPIO49, GPIO50};
+static const unsigned p910_ssp0_pin4[] = {GPIO51, GPIO52, GPIO53, GPIO54};
+static const unsigned p910_ssp1_pin1[] = {GPIO21, GPIO22, GPIO23, GPIO24};
+static const unsigned p910_ssp1_pin2[] = {GPIO20, GPIO21, GPIO22, GPIO23,
+	GPIO24};
+static const unsigned p910_ssp2_pin1[] = {MMC1_DAT2, MMC1_DAT1, MMC1_DAT0,
+	MMC1_CMD};
+static const unsigned p910_ssp2_pin2[] = {GPIO33, GPIO34, GPIO35, GPIO36};
+static const unsigned p910_ssp2_pin3[] = {GPIO47, GPIO48, GPIO49, GPIO50};
+static const unsigned p910_ssp2_pin4[] = {ND_IO12, ND_IO11, ND_IO10, ND_IO9};
+static const unsigned p910_gssp_pin1[] = {GPIO25, GPIO26, GPIO27, GPIO28};
+static const unsigned p910_pwm0_pin1[] = {GPIO117};
+static const unsigned p910_pwm1_pin1[] = {GPIO118};
+static const unsigned p910_pwm1_pin2[] = {GPIO51};
+static const unsigned p910_pwm2_pin1[] = {GPIO119};
+static const unsigned p910_pwm3_pin1[] = {GPIO120};
+static const unsigned p910_pwm3_pin2[] = {ND_IO8};
+static const unsigned p910_pwm3_pin3[] = {VCXO_OUT};
+static const unsigned p910_pri_jtag_pin1[] = {GPIO117, GPIO118, GPIO119,
+	GPIO120};
+static const unsigned p910_sec1_jtag_pin1[] = {MMC1_DAT7, MMC1_DAT6, MMC1_DAT5,
+	MMC1_CMD, MMC1_CD};
+static const unsigned p910_sec2_jtag_pin1[] = {MMC1_DAT3, MMC1_DAT2, MMC1_DAT1,
+	MMC1_DAT0, MMC1_CLK};
+static const unsigned p910_hsl_pin1[] = {GPIO37, GPIO38, GPIO39, GPIO40,
+	GPIO41, GPIO42};
+static const unsigned p910_hsl_pin2[] = {GPIO61, GPIO62, GPIO63, GPIO64,
+	GPIO65, GPIO66};
+static const unsigned p910_hsl_pin3[] = {MMC1_DAT3, MMC1_DAT2, MMC1_DAT1,
+	MMC1_DAT0, MMC1_CMD, MMC1_CLK};
+static const unsigned p910_w1_pin1[] = {GPIO59};
+static const unsigned p910_w1_pin2[] = {GPIO65};
+static const unsigned p910_w1_pin3[] = {GPIO106};
+static const unsigned p910_w1_pin4[] = {GPIO123};
+static const unsigned p910_kpmk_pin1[] = {GPIO0, GPIO1, GPIO2, GPIO3, GPIO4,
+	GPIO5, GPIO6, GPIO7, GPIO8, GPIO9, GPIO10, GPIO11, GPIO12, GPIO13,
+	GPIO14, GPIO15};
+static const unsigned p910_kpmk_pin2[] = {GPIO0, GPIO1, GPIO2, GPIO3, GPIO4,
+	GPIO5, GPIO6, GPIO7, GPIO8, GPIO9, GPIO12};
+static const unsigned p910_kpdk_pin1[] = {GPIO12, GPIO13, GPIO14, GPIO15,
+	GPIO16, GPIO17, GPIO18, GPIO19};
+static const unsigned p910_tds_pin1[] = {GPIO55, GPIO56, GPIO57, GPIO58,
+	GPIO59};
+static const unsigned p910_tds_pin2[] = {GPIO55, GPIO57, GPIO58, GPIO59};
+static const unsigned p910_tb_pin1[] = {GPIO14, GPIO15, GPIO16, GPIO17};
+static const unsigned p910_tb_pin2[] = {GPIO55, GPIO56, GPIO57, GPIO58};
+static const unsigned p910_tb_pin3[] = {MMC1_DAT7, MMC1_DAT6, MMC1_DAT5,
+	MMC1_DAT4};
+static const unsigned p910_ext_dma0_pin1[] = {GPIO72};
+static const unsigned p910_ext_dma0_pin2[] = {ND_IO15};
+static const unsigned p910_ext_dma0_pin3[] = {ND_NRE};
+static const unsigned p910_ext_dma1_pin1[] = {GPIO73};
+static const unsigned p910_ext_dma1_pin2[] = {GPIO123};
+static const unsigned p910_ext_dma1_pin3[] = {GPIO126};
+static const unsigned p910_ext_dma2_pin1[] = {GPIO74};
+static const unsigned p910_ext0_int_pin1[] = {GPIO44};
+static const unsigned p910_ext0_int_pin2[] = {ND_IO13};
+static const unsigned p910_ext1_int_pin1[] = {GPIO45};
+static const unsigned p910_ext1_int_pin2[] = {ND_IO12};
+static const unsigned p910_ext2_int_pin1[] = {GPIO46};
+static const unsigned p910_ext2_int_pin2[] = {GPIO125};
+static const unsigned p910_dac_st23_pin1[] = {GPIO32};
+static const unsigned p910_dac_st23_pin2[] = {GPIO43};
+static const unsigned p910_dac_st23_pin3[] = {GPIO52};
+static const unsigned p910_dac_st23_pin4[] = {GPIO124};
+static const unsigned p910_vcxo_out_pin1[] = {GPIO50};
+static const unsigned p910_vcxo_out_pin2[] = {VCXO_OUT};
+static const unsigned p910_vcxo_out_pin3[] = {GPIO20};
+static const unsigned p910_vcxo_req_pin1[] = {GPIO49};
+static const unsigned p910_vcxo_req_pin2[] = {GPIO125};
+static const unsigned p910_vcxo_out2_pin1[] = {GPIO86};
+static const unsigned p910_vcxo_out2_pin2[] = {ND_IO9};
+static const unsigned p910_vcxo_req2_pin1[] = {GPIO84};
+static const unsigned p910_ulpi_pin1[] = {GPIO67, GPIO68, GPIO69, GPIO70,
+	GPIO71, GPIO72, GPIO73, GPIO74, GPIO75, GPIO76, GPIO77, GPIO78};
+static const unsigned p910_nand_pin1[] = {ND_IO15, ND_IO14, ND_IO13, ND_IO12,
+	ND_IO11, ND_IO10, ND_IO9, ND_IO8, ND_IO7, ND_IO6, ND_IO5, ND_IO4,
+	ND_IO3, ND_IO2, ND_IO1, ND_IO0, ND_NCS0, ND_NWE, ND_NRE, ND_CLE,
+	ND_ALE, ND_RDY0};
+static const unsigned p910_gpio0_pin1[] = {GPIO0};
+static const unsigned p910_gpio0_pin2[] = {SM_ADV};
+static const unsigned p910_gpio1_pin1[] = {GPIO1};
+static const unsigned p910_gpio1_pin2[] = {ND_RDY1};
+static const unsigned p910_gpio2_pin1[] = {GPIO2};
+static const unsigned p910_gpio2_pin2[] = {SM_ADVMUX};
+static const unsigned p910_gpio3_pin1[] = {GPIO3};
+static const unsigned p910_gpio3_pin2[] = {SM_RDY};
+static const unsigned p910_gpio20_pin1[] = {GPIO20};
+static const unsigned p910_gpio20_pin2[] = {ND_IO15};
+static const unsigned p910_gpio20_pin3[] = {MMC1_DAT6};
+static const unsigned p910_gpio21_pin1[] = {GPIO21};
+static const unsigned p910_gpio21_pin2[] = {ND_IO14};
+static const unsigned p910_gpio21_pin3[] = {MMC1_DAT5};
+static const unsigned p910_gpio22_pin1[] = {GPIO22};
+static const unsigned p910_gpio22_pin2[] = {ND_IO13};
+static const unsigned p910_gpio22_pin3[] = {MMC1_DAT4};
+static const unsigned p910_gpio23_pin1[] = {GPIO23};
+static const unsigned p910_gpio23_pin2[] = {ND_IO12};
+static const unsigned p910_gpio23_pin3[] = {MMC1_CD};
+static const unsigned p910_gpio24_pin1[] = {GPIO24};
+static const unsigned p910_gpio24_pin2[] = {ND_IO11};
+static const unsigned p910_gpio24_pin3[] = {MMC1_DAT7};
+static const unsigned p910_gpio25_pin1[] = {GPIO25};
+static const unsigned p910_gpio25_pin2[] = {ND_IO10};
+static const unsigned p910_gpio26_pin1[] = {GPIO26};
+static const unsigned p910_gpio26_pin2[] = {ND_IO9};
+static const unsigned p910_gpio27_pin1[] = {GPIO27};
+static const unsigned p910_gpio27_pin2[] = {ND_IO8};
+static const unsigned p910_gpio85_pin1[] = {GPIO85};
+static const unsigned p910_gpio85_pin2[] = {ND_NCS0};
+static const unsigned p910_gpio86_pin1[] = {GPIO86};
+static const unsigned p910_gpio86_pin2[] = {ND_NCS1};
+static const unsigned p910_gpio87_pin1[] = {GPIO87};
+static const unsigned p910_gpio87_pin2[] = {SM_NCS0};
+static const unsigned p910_gpio88_pin1[] = {GPIO88};
+static const unsigned p910_gpio88_pin2[] = {SM_NCS1};
+static const unsigned p910_gpio89_pin1[] = {GPIO89};
+static const unsigned p910_gpio89_pin2[] = {ND_NWE};
+static const unsigned p910_gpio90_pin1[] = {GPIO90};
+static const unsigned p910_gpio90_pin2[] = {ND_NRE};
+static const unsigned p910_gpio91_pin1[] = {GPIO91};
+static const unsigned p910_gpio91_pin2[] = {ND_ALE};
+static const unsigned p910_gpio92_pin1[] = {GPIO92};
+static const unsigned p910_gpio92_pin2[] = {ND_RDY0};
+
+static struct pxa3xx_pin_group pxa910_grps[] = {
+	GRP_910("usim2 3p1", USIM2, p910_usim2_pin1),
+	GRP_910("usim2 3p2", USIM2, p910_usim2_pin2),
+	GRP_910("mmc1 12p", MMC1, p910_mmc1_pin1),
+	GRP_910("mmc2 10p", MMC2, p910_mmc2_pin1),
+	GRP_910("mmc3 6p", MMC3, p910_mmc3_pin1),
+	GRP_910("mmc3 10p", MMC3, p910_mmc3_pin2),
+	GRP_910("uart0 4p", UART0, p910_uart0_pin1),
+	GRP_910("uart1 2p1", UART1, p910_uart1_pin1),
+	GRP_910("uart1 2p2", UART1, p910_uart1_pin2),
+	GRP_910("uart1 2p3", UART1, p910_uart1_pin3),
+	GRP_910("uart1 4p4", UART1, p910_uart1_pin4),
+	GRP_910("uart1 4p5", UART1, p910_uart1_pin5),
+	GRP_910("uart2 2p1", UART2, p910_uart2_pin1),
+	GRP_910("uart2 2p2", UART2, p910_uart2_pin2),
+	GRP_910("uart2 4p3", UART2, p910_uart2_pin3),
+	GRP_910("uart2 4p4", UART2, p910_uart2_pin4),
+	GRP_910("twsi 2p1", TWSI, p910_twsi_pin1),
+	GRP_910("twsi 2p2", TWSI, p910_twsi_pin2),
+	GRP_910("twsi 2p3", TWSI, p910_twsi_pin3),
+	GRP_910("ccic", CCIC, p910_ccic_pin1),
+	GRP_910("lcd", LCD, p910_lcd_pin1),
+	GRP_910("spi 4p1", SPI, p910_spi_pin1),
+	GRP_910("spi 4p2", SPI, p910_spi_pin2),
+	GRP_910("spi 5p3", SPI, p910_spi_pin3),
+	GRP_910("spi 5p4", SPI, p910_spi_pin4),
+	GRP_910("dssp2 4p1", DSSP2, p910_dssp2_pin1),
+	GRP_910("dssp2 4p2", DSSP2, p910_dssp2_pin2),
+	GRP_910("dssp2 3p3", DSSP2, p910_dssp2_pin3),
+	GRP_910("dssp3 4p1", DSSP3, p910_dssp3_pin1),
+	GRP_910("dssp3 4p2", DSSP3, p910_dssp3_pin2),
+	GRP_910("dssp3 3p3", DSSP3, p910_dssp3_pin3),
+	GRP_910("ssp0 4p1", SSP0, p910_ssp0_pin1),
+	GRP_910("ssp0 4p2", SSP0, p910_ssp0_pin2),
+	GRP_910("ssp0 4p3", SSP0, p910_ssp0_pin3),
+	GRP_910("ssp0 4p4", SSP0, p910_ssp0_pin4),
+	GRP_910("ssp1 4p1", SSP1, p910_ssp1_pin1),
+	GRP_910("ssp1 5p2", SSP1, p910_ssp1_pin2),
+	GRP_910("ssp2 4p1", SSP2, p910_ssp2_pin1),
+	GRP_910("ssp2 4p2", SSP2, p910_ssp2_pin2),
+	GRP_910("ssp2 4p3", SSP2, p910_ssp2_pin3),
+	GRP_910("ssp2 4p4", SSP2, p910_ssp2_pin4),
+	GRP_910("gssp", GSSP, p910_gssp_pin1),
+	GRP_910("pwm0", PWM0, p910_pwm0_pin1),
+	GRP_910("pwm1-1", PWM1, p910_pwm1_pin1),
+	GRP_910("pwm1-2", PWM1, p910_pwm1_pin2),
+	GRP_910("pwm2", PWM2, p910_pwm2_pin1),
+	GRP_910("pwm3-1", PWM3, p910_pwm3_pin1),
+	GRP_910("pwm3-2", PWM3, p910_pwm3_pin2),
+	GRP_910("pwm3-3", PWM3, p910_pwm3_pin3),
+	GRP_910("pri jtag", PRI_JTAG, p910_pri_jtag_pin1),
+	GRP_910("sec1 jtag", SEC1_JTAG, p910_sec1_jtag_pin1),
+	GRP_910("sec2 jtag", SEC2_JTAG, p910_sec2_jtag_pin1),
+	GRP_910("hsl 6p1", HSL, p910_hsl_pin1),
+	GRP_910("hsl 6p2", HSL, p910_hsl_pin2),
+	GRP_910("hsl 6p3", HSL, p910_hsl_pin3),
+	GRP_910("w1-1", ONE_WIRE, p910_w1_pin1),
+	GRP_910("w1-2", ONE_WIRE, p910_w1_pin2),
+	GRP_910("w1-3", ONE_WIRE, p910_w1_pin3),
+	GRP_910("w1-4", ONE_WIRE, p910_w1_pin4),
+	GRP_910("kpmk 16p1", KP_MK, p910_kpmk_pin1),
+	GRP_910("kpmk 11p2", KP_MK, p910_kpmk_pin2),
+	GRP_910("kpdk 8p1", KP_DK, p910_kpdk_pin1),
+	GRP_910("tds 5p1", TDS, p910_tds_pin1),
+	GRP_910("tds 4p2", TDS, p910_tds_pin2),
+	GRP_910("tb 4p1", TB, p910_tb_pin1),
+	GRP_910("tb 4p2", TB, p910_tb_pin2),
+	GRP_910("tb 4p3", TB, p910_tb_pin3),
+	GRP_910("ext dma0-1", EXT_DMA, p910_ext_dma0_pin1),
+	GRP_910("ext dma0-2", EXT_DMA, p910_ext_dma0_pin2),
+	GRP_910("ext dma0-3", EXT_DMA, p910_ext_dma0_pin3),
+	GRP_910("ext dma1-1", EXT_DMA, p910_ext_dma1_pin1),
+	GRP_910("ext dma1-2", EXT_DMA, p910_ext_dma1_pin2),
+	GRP_910("ext dma1-3", EXT_DMA, p910_ext_dma1_pin3),
+	GRP_910("ext dma2", EXT_DMA, p910_ext_dma2_pin1),
+	GRP_910("ext0 int-1", EXT_INT, p910_ext0_int_pin1),
+	GRP_910("ext0 int-2", EXT_INT, p910_ext0_int_pin2),
+	GRP_910("ext1 int-1", EXT_INT, p910_ext1_int_pin1),
+	GRP_910("ext1 int-2", EXT_INT, p910_ext1_int_pin2),
+	GRP_910("ext2 int-1", EXT_INT, p910_ext2_int_pin1),
+	GRP_910("ext2 int-2", EXT_INT, p910_ext2_int_pin2),
+	GRP_910("dac st23-1", DAC_ST23, p910_dac_st23_pin1),
+	GRP_910("dac st23-2", DAC_ST23, p910_dac_st23_pin2),
+	GRP_910("dac st23-3", DAC_ST23, p910_dac_st23_pin3),
+	GRP_910("dac st23-4", DAC_ST23, p910_dac_st23_pin4),
+	GRP_910("vcxo out-1", VCXO_OUT, p910_vcxo_out_pin1),
+	GRP_910("vcxo out-2", VCXO_OUT, p910_vcxo_out_pin2),
+	GRP_910("vcxo out-3", VCXO_OUT, p910_vcxo_out_pin3),
+	GRP_910("vcxo req-1", VCXO_REQ, p910_vcxo_req_pin1),
+	GRP_910("vcxo req-2", VCXO_REQ, p910_vcxo_req_pin2),
+	GRP_910("vcxo out2-1", VCXO_OUT2, p910_vcxo_out2_pin1),
+	GRP_910("vcxo out2-2", VCXO_OUT2, p910_vcxo_out2_pin2),
+	GRP_910("vcxo req2", VCXO_REQ2, p910_vcxo_req2_pin1),
+	GRP_910("ulpi", ULPI, p910_ulpi_pin1),
+	GRP_910("nand", NAND, p910_nand_pin1),
+	GRP_910("gpio0-1", GPIO, p910_gpio0_pin1),
+	GRP_910("gpio0-2", GPIO, p910_gpio0_pin2),
+	GRP_910("gpio1-1", GPIO, p910_gpio1_pin1),
+	GRP_910("gpio1-2", GPIO, p910_gpio1_pin2),
+	GRP_910("gpio2-1", GPIO, p910_gpio2_pin1),
+	GRP_910("gpio2-2", GPIO, p910_gpio2_pin2),
+	GRP_910("gpio3-1", GPIO, p910_gpio3_pin1),
+	GRP_910("gpio3-2", GPIO, p910_gpio3_pin2),
+	GRP_910("gpio20-1", GPIO, p910_gpio20_pin1),
+	GRP_910("gpio20-2", GPIO, p910_gpio20_pin2),
+	GRP_910("gpio21-1", GPIO, p910_gpio21_pin1),
+	GRP_910("gpio21-2", GPIO, p910_gpio21_pin2),
+	GRP_910("gpio22-1", GPIO, p910_gpio22_pin1),
+	GRP_910("gpio22-2", GPIO, p910_gpio22_pin2),
+	GRP_910("gpio23-1", GPIO, p910_gpio23_pin1),
+	GRP_910("gpio23-2", GPIO, p910_gpio23_pin2),
+	GRP_910("gpio24-1", GPIO, p910_gpio24_pin1),
+	GRP_910("gpio24-2", GPIO, p910_gpio24_pin2),
+	GRP_910("gpio25-1", GPIO, p910_gpio25_pin1),
+	GRP_910("gpio25-2", GPIO, p910_gpio25_pin2),
+	GRP_910("gpio26-1", GPIO, p910_gpio26_pin1),
+	GRP_910("gpio26-2", GPIO, p910_gpio26_pin2),
+	GRP_910("gpio27-1", GPIO, p910_gpio27_pin1),
+	GRP_910("gpio27-2", GPIO, p910_gpio27_pin2),
+	GRP_910("gpio85-1", GPIO, p910_gpio85_pin1),
+	GRP_910("gpio85-2", GPIO, p910_gpio85_pin2),
+	GRP_910("gpio86-1", GPIO, p910_gpio86_pin1),
+	GRP_910("gpio86-2", GPIO, p910_gpio86_pin2),
+	GRP_910("gpio87-1", GPIO, p910_gpio87_pin1),
+	GRP_910("gpio87-2", GPIO, p910_gpio87_pin2),
+	GRP_910("gpio88-1", GPIO, p910_gpio88_pin1),
+	GRP_910("gpio88-2", GPIO, p910_gpio88_pin2),
+	GRP_910("gpio89-1", GPIO, p910_gpio89_pin1),
+	GRP_910("gpio89-2", GPIO, p910_gpio89_pin2),
+	GRP_910("gpio90-1", GPIO, p910_gpio90_pin1),
+	GRP_910("gpio90-2", GPIO, p910_gpio90_pin2),
+	GRP_910("gpio91-1", GPIO, p910_gpio91_pin1),
+	GRP_910("gpio91-2", GPIO, p910_gpio91_pin2),
+	GRP_910("gpio92-1", GPIO, p910_gpio92_pin1),
+	GRP_910("gpio92-2", GPIO, p910_gpio92_pin2),
+};
+
+static const char * const p910_usim2_grps[] = {"usim2 3p1", "usim2 3p2"};
+static const char * const p910_mmc1_grps[] = {"mmc1 12p"};
+static const char * const p910_mmc2_grps[] = {"mmc2 10p"};
+static const char * const p910_mmc3_grps[] = {"mmc3 6p", "mmc3 10p"};
+static const char * const p910_uart0_grps[] = {"uart0 4p"};
+static const char * const p910_uart1_grps[] = {"uart1 2p1", "uart1 2p2",
+	"uart1 2p3", "uart1 4p4", "uart1 4p5"};
+static const char * const p910_uart2_grps[] = {"uart2 2p1", "uart2 2p2",
+	"uart2 4p3", "uart2 4p4"};
+static const char * const p910_twsi_grps[] = {"twsi 2p1", "twsi 2p2",
+	"twsi 2p3"};
+static const char * const p910_ccic_grps[] = {"ccic"};
+static const char * const p910_lcd_grps[] = {"lcd"};
+static const char * const p910_spi_grps[] = {"spi 4p1", "spi 4p2", "spi 5p3",
+	"spi 5p4"};
+static const char * const p910_dssp2_grps[] = {"dssp2 4p1", "dssp2 4p2",
+	"dssp2 3p3"};
+static const char * const p910_dssp3_grps[] = {"dssp3 4p1", "dssp3 4p2",
+	"dssp3 3p3"};
+static const char * const p910_ssp0_grps[] = {"ssp0 4p1", "ssp0 4p2",
+	"ssp0 4p3", "ssp0 4p4"};
+static const char * const p910_ssp1_grps[] = {"ssp1 4p1", "ssp1 5p2"};
+static const char * const p910_ssp2_grps[] = {"ssp2 4p1", "ssp2 4p2",
+	"ssp2 4p3", "ssp2 4p4"};
+static const char * const p910_gssp_grps[] = {"gssp"};
+static const char * const p910_pwm0_grps[] = {"pwm0"};
+static const char * const p910_pwm1_grps[] = {"pwm1-1", "pwm1-2"};
+static const char * const p910_pwm2_grps[] = {"pwm2"};
+static const char * const p910_pwm3_grps[] = {"pwm3-1", "pwm3-2", "pwm3-3"};
+static const char * const p910_pri_jtag_grps[] = {"pri jtag"};
+static const char * const p910_sec1_jtag_grps[] = {"sec1 jtag"};
+static const char * const p910_sec2_jtag_grps[] = {"sec2 jtag"};
+static const char * const p910_hsl_grps[] = {"hsl 6p1", "hsl 6p2", "hsl 6p3"};
+static const char * const p910_w1_grps[] = {"w1-1", "w1-2", "w1-3", "w1-4"};
+static const char * const p910_kpmk_grps[] = {"kpmk 16p1", "kpmk 11p2"};
+static const char * const p910_kpdk_grps[] = {"kpdk 8p1"};
+static const char * const p910_tds_grps[] = {"tds 5p1", "tds 4p2"};
+static const char * const p910_tb_grps[] = {"tb 4p1", "tb 4p2", "tb 4p3"};
+static const char * const p910_dma0_grps[] = {"ext dma0-1", "ext dma0-2",
+	"ext dma0-3"};
+static const char * const p910_dma1_grps[] = {"ext dma1-1", "ext dma1-2",
+	"ext dma1-3"};
+static const char * const p910_dma2_grps[] = {"ext dma2"};
+static const char * const p910_int0_grps[] = {"ext0 int-1", "ext0 int-2"};
+static const char * const p910_int1_grps[] = {"ext1 int-1", "ext1 int-2"};
+static const char * const p910_int2_grps[] = {"ext2 int-1", "ext2 int-2"};
+static const char * const p910_dac_st23_grps[] = {"dac st23-1", "dac st23-2",
+	"dac st23-3", "dac st23-4"};
+static const char * const p910_vcxo_out_grps[] = {"vcxo out-1", "vcxo out-2",
+	"vcxo out-3"};
+static const char * const p910_vcxo_req_grps[] = {"vcxo req-1", "vcxo req-2"};
+static const char * const p910_vcxo_out2_grps[] = {"vcxo out2-1",
+	"vcxo out2-2"};
+static const char * const p910_vcxo_req2_grps[] = {"vcxo req2"};
+static const char * const p910_ulpi_grps[] = {"ulpi"};
+static const char * const p910_nand_grps[] = {"nand"};
+static const char * const p910_gpio0_grps[] = {"gpio0-1", "gpio0-2"};
+static const char * const p910_gpio1_grps[] = {"gpio1-1", "gpio1-2"};
+static const char * const p910_gpio2_grps[] = {"gpio2-1", "gpio2-2"};
+static const char * const p910_gpio3_grps[] = {"gpio3-1", "gpio3-2"};
+static const char * const p910_gpio20_grps[] = {"gpio20-1", "gpio20-2"};
+static const char * const p910_gpio21_grps[] = {"gpio21-1", "gpio21-2"};
+static const char * const p910_gpio22_grps[] = {"gpio22-1", "gpio22-2"};
+static const char * const p910_gpio23_grps[] = {"gpio23-1", "gpio23-2"};
+static const char * const p910_gpio24_grps[] = {"gpio24-1", "gpio24-2"};
+static const char * const p910_gpio25_grps[] = {"gpio25-1", "gpio25-2"};
+static const char * const p910_gpio26_grps[] = {"gpio26-1", "gpio26-2"};
+static const char * const p910_gpio27_grps[] = {"gpio27-1", "gpio27-2"};
+static const char * const p910_gpio85_grps[] = {"gpio85-1", "gpio85-2"};
+static const char * const p910_gpio86_grps[] = {"gpio86-1", "gpio86-2"};
+static const char * const p910_gpio87_grps[] = {"gpio87-1", "gpio87-2"};
+static const char * const p910_gpio88_grps[] = {"gpio88-1", "gpio88-2"};
+static const char * const p910_gpio89_grps[] = {"gpio89-1", "gpio89-2"};
+static const char * const p910_gpio90_grps[] = {"gpio90-1", "gpio90-2"};
+static const char * const p910_gpio91_grps[] = {"gpio91-1", "gpio91-2"};
+static const char * const p910_gpio92_grps[] = {"gpio92-1", "gpio92-2"};
+
+static struct pxa3xx_pmx_func pxa910_funcs[] = {
+	{"usim2",	ARRAY_AND_SIZE(p910_usim2_grps)},
+	{"mmc1",	ARRAY_AND_SIZE(p910_mmc1_grps)},
+	{"mmc2",	ARRAY_AND_SIZE(p910_mmc2_grps)},
+	{"mmc3",	ARRAY_AND_SIZE(p910_mmc3_grps)},
+	{"uart0",	ARRAY_AND_SIZE(p910_uart0_grps)},
+	{"uart1",	ARRAY_AND_SIZE(p910_uart1_grps)},
+	{"uart2",	ARRAY_AND_SIZE(p910_uart2_grps)},
+	{"twsi",	ARRAY_AND_SIZE(p910_twsi_grps)},
+	{"ccic",	ARRAY_AND_SIZE(p910_ccic_grps)},
+	{"lcd",		ARRAY_AND_SIZE(p910_lcd_grps)},
+	{"spi",		ARRAY_AND_SIZE(p910_spi_grps)},
+	{"dssp2",	ARRAY_AND_SIZE(p910_dssp2_grps)},
+	{"dssp3",	ARRAY_AND_SIZE(p910_dssp3_grps)},
+	{"ssp0",	ARRAY_AND_SIZE(p910_ssp0_grps)},
+	{"ssp1",	ARRAY_AND_SIZE(p910_ssp1_grps)},
+	{"ssp2",	ARRAY_AND_SIZE(p910_ssp2_grps)},
+	{"gssp",	ARRAY_AND_SIZE(p910_gssp_grps)},
+	{"pwm0",	ARRAY_AND_SIZE(p910_pwm0_grps)},
+	{"pwm1",	ARRAY_AND_SIZE(p910_pwm1_grps)},
+	{"pwm2",	ARRAY_AND_SIZE(p910_pwm2_grps)},
+	{"pwm3",	ARRAY_AND_SIZE(p910_pwm3_grps)},
+	{"pri_jtag",	ARRAY_AND_SIZE(p910_pri_jtag_grps)},
+	{"sec1_jtag",	ARRAY_AND_SIZE(p910_sec1_jtag_grps)},
+	{"sec2_jtag",	ARRAY_AND_SIZE(p910_sec2_jtag_grps)},
+	{"hsl",		ARRAY_AND_SIZE(p910_hsl_grps)},
+	{"w1",		ARRAY_AND_SIZE(p910_w1_grps)},
+	{"kpmk",	ARRAY_AND_SIZE(p910_kpmk_grps)},
+	{"kpdk",	ARRAY_AND_SIZE(p910_kpdk_grps)},
+	{"tds",		ARRAY_AND_SIZE(p910_tds_grps)},
+	{"tb",		ARRAY_AND_SIZE(p910_tb_grps)},
+	{"dma0",	ARRAY_AND_SIZE(p910_dma0_grps)},
+	{"dma1",	ARRAY_AND_SIZE(p910_dma1_grps)},
+	{"dma2",	ARRAY_AND_SIZE(p910_dma2_grps)},
+	{"int0",	ARRAY_AND_SIZE(p910_int0_grps)},
+	{"int1",	ARRAY_AND_SIZE(p910_int1_grps)},
+	{"int2",	ARRAY_AND_SIZE(p910_int2_grps)},
+	{"dac_st23",	ARRAY_AND_SIZE(p910_dac_st23_grps)},
+	{"vcxo_out",	ARRAY_AND_SIZE(p910_vcxo_out_grps)},
+	{"vcxo_req",	ARRAY_AND_SIZE(p910_vcxo_req_grps)},
+	{"vcxo_out2",	ARRAY_AND_SIZE(p910_vcxo_out2_grps)},
+	{"vcxo_req2",	ARRAY_AND_SIZE(p910_vcxo_req2_grps)},
+	{"ulpi",	ARRAY_AND_SIZE(p910_ulpi_grps)},
+	{"nand",	ARRAY_AND_SIZE(p910_nand_grps)},
+	{"gpio0",	ARRAY_AND_SIZE(p910_gpio0_grps)},
+	{"gpio1",	ARRAY_AND_SIZE(p910_gpio1_grps)},
+	{"gpio2",	ARRAY_AND_SIZE(p910_gpio2_grps)},
+	{"gpio3",	ARRAY_AND_SIZE(p910_gpio3_grps)},
+	{"gpio20",	ARRAY_AND_SIZE(p910_gpio20_grps)},
+	{"gpio21",	ARRAY_AND_SIZE(p910_gpio21_grps)},
+	{"gpio22",	ARRAY_AND_SIZE(p910_gpio22_grps)},
+	{"gpio23",	ARRAY_AND_SIZE(p910_gpio23_grps)},
+	{"gpio24",	ARRAY_AND_SIZE(p910_gpio24_grps)},
+	{"gpio25",	ARRAY_AND_SIZE(p910_gpio25_grps)},
+	{"gpio26",	ARRAY_AND_SIZE(p910_gpio26_grps)},
+	{"gpio27",	ARRAY_AND_SIZE(p910_gpio27_grps)},
+	{"gpio85",	ARRAY_AND_SIZE(p910_gpio85_grps)},
+	{"gpio86",	ARRAY_AND_SIZE(p910_gpio86_grps)},
+	{"gpio87",	ARRAY_AND_SIZE(p910_gpio87_grps)},
+	{"gpio88",	ARRAY_AND_SIZE(p910_gpio88_grps)},
+	{"gpio89",	ARRAY_AND_SIZE(p910_gpio89_grps)},
+	{"gpio90",	ARRAY_AND_SIZE(p910_gpio90_grps)},
+	{"gpio91",	ARRAY_AND_SIZE(p910_gpio91_grps)},
+	{"gpio92",	ARRAY_AND_SIZE(p910_gpio92_grps)},
+};
+
+static struct pinctrl_desc pxa910_pctrl_desc = {
+	.name		= "pxa910-pinctrl",
+	.maxpin		= 260,
+	.owner		= THIS_MODULE,
+};
+
+static struct pxa3xx_pinmux_info pxa910_info = {
+	.mfp		= pxa910_mfp,
+	.num_mfp	= ARRAY_SIZE(pxa910_mfp),
+	.grps		= pxa910_grps,
+	.num_grps	= ARRAY_SIZE(pxa910_grps),
+	.funcs		= pxa910_funcs,
+	.num_funcs	= ARRAY_SIZE(pxa910_funcs),
+	.num_gpio	= 128,
+	.desc		= &pxa910_pctrl_desc,
+	.pads		= pxa910_pads,
+	.num_pads	= ARRAY_SIZE(pxa910_pads),
+
+	.cputype	= PINCTRL_PXA910,
+	.ds_mask	= PXA910_DS_MASK,
+	.ds_shift	= PXA910_DS_SHIFT,
+};
+
+static int __devinit pxa910_pinmux_probe(struct platform_device *pdev)
+{
+	return pxa3xx_pinctrl_register(pdev, &pxa910_info);
+}
+
+static int __devexit pxa910_pinmux_remove(struct platform_device *pdev)
+{
+	return pxa3xx_pinctrl_unregister(pdev);
+}
+
+static struct platform_driver pxa910_pinmux_driver = {
+	.driver = {
+		.name	= "pxa910-pinmux",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= pxa910_pinmux_probe,
+	.remove	= __devexit_p(pxa910_pinmux_remove),
+};
+
+static int __init pxa910_pinmux_init(void)
+{
+	return platform_driver_register(&pxa910_pinmux_driver);
+}
+core_initcall_sync(pxa910_pinmux_init);
+
+static void __exit pxa910_pinmux_exit(void)
+{
+	platform_driver_unregister(&pxa910_pinmux_driver);
+}
+module_exit(pxa910_pinmux_exit);
+
+MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
+MODULE_DESCRIPTION("PXA3xx pin control driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.0.4

