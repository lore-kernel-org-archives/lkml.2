Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab1KBOKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 10:10:19 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7408 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491Ab1KBOJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 10:09:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 02 Nov 2011 07:09:19 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v2 4/8] arm/tegra: prepare pinmux code for multiple tegra variants
Date: Wed, 2 Nov 2011 16:09:03 +0200
Message-ID: <1320242948-21061-5-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1320242948-21061-1-git-send-email-pdeschrijver@nvidia.com>
References: <1320242948-21061-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the pinmux code to be useable for multiple tegra variants.
Some tegra20 specific constants will be replaced by variables which will be
initialized to the appropriate value at runtime.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/board-harmony-pcie.c     |    1 +
 arch/arm/mach-tegra/board-harmony-pinmux.c   |    1 +
 arch/arm/mach-tegra/board-paz00-pinmux.c     |    1 +
 arch/arm/mach-tegra/board-trimslice-pinmux.c |    1 +
 arch/arm/mach-tegra/include/mach/pinmux.h    |   30 ++++----
 arch/arm/mach-tegra/pinmux-tegra20-tables.c  |   15 +++-
 arch/arm/mach-tegra/pinmux.c                 |  105 ++++++++++++++-----------
 7 files changed, 91 insertions(+), 63 deletions(-)

diff --git a/arch/arm/mach-tegra/board-harmony-pcie.c b/arch/arm/mach-tegra/board-harmony-pcie.c
index 6db7d69..bd402d0 100644
--- a/arch/arm/mach-tegra/board-harmony-pcie.c
+++ b/arch/arm/mach-tegra/board-harmony-pcie.c
@@ -23,6 +23,7 @@
 #include <asm/mach-types.h>
 
 #include <mach/pinmux.h>
+#include <mach/pinmux-tegra20.h>
 #include "board.h"
 #include "board-harmony.h"
 
diff --git a/arch/arm/mach-tegra/board-harmony-pinmux.c b/arch/arm/mach-tegra/board-harmony-pinmux.c
index e99b456..286253f 100644
--- a/arch/arm/mach-tegra/board-harmony-pinmux.c
+++ b/arch/arm/mach-tegra/board-harmony-pinmux.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/gpio.h>
 #include <mach/pinmux.h>
+#include <mach/pinmux-tegra20.h>
 
 #include "gpio-names.h"
 #include "board-harmony.h"
diff --git a/arch/arm/mach-tegra/board-paz00-pinmux.c b/arch/arm/mach-tegra/board-paz00-pinmux.c
index fb20894..484dbd6 100644
--- a/arch/arm/mach-tegra/board-paz00-pinmux.c
+++ b/arch/arm/mach-tegra/board-paz00-pinmux.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/gpio.h>
 #include <mach/pinmux.h>
+#include <mach/pinmux-tegra20.h>
 
 #include "gpio-names.h"
 #include "board-paz00.h"
diff --git a/arch/arm/mach-tegra/board-trimslice-pinmux.c b/arch/arm/mach-tegra/board-trimslice-pinmux.c
index 4969dd2..cc9d4f4 100644
--- a/arch/arm/mach-tegra/board-trimslice-pinmux.c
+++ b/arch/arm/mach-tegra/board-trimslice-pinmux.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 
 #include <mach/pinmux.h>
+#include <mach/pinmux-tegra20.h>
 
 #include "gpio-names.h"
 #include "board-trimslice.h"
diff --git a/arch/arm/mach-tegra/include/mach/pinmux.h b/arch/arm/mach-tegra/include/mach/pinmux.h
index b93df9e..fb101f5 100644
--- a/arch/arm/mach-tegra/include/mach/pinmux.h
+++ b/arch/arm/mach-tegra/include/mach/pinmux.h
@@ -17,12 +17,6 @@
 #ifndef __MACH_TEGRA_PINMUX_H
 #define __MACH_TEGRA_PINMUX_H
 
-#if defined(CONFIG_ARCH_TEGRA_2x_SOC)
-#include "pinmux-tegra20.h"
-#else
-#error "Undefined Tegra architecture"
-#endif
-
 enum tegra_mux_func {
 	TEGRA_MUX_RSVD = 0x8000,
 	TEGRA_MUX_RSVD1 = 0x8000,
@@ -118,7 +112,7 @@ enum tegra_vddio {
 };
 
 struct tegra_pingroup_config {
-	enum tegra_pingroup	pingroup;
+	int pingroup;
 	enum tegra_mux_func	func;
 	enum tegra_pullupdown	pupd;
 	enum tegra_tristate	tristate;
@@ -187,7 +181,7 @@ enum tegra_schmitt {
 };
 
 struct tegra_drive_pingroup_config {
-	enum tegra_drive_pingroup pingroup;
+	int pingroup;
 	enum tegra_hsm hsm;
 	enum tegra_schmitt schmitt;
 	enum tegra_drive drive;
@@ -219,13 +213,20 @@ struct tegra_pingroup_desc {
 	s8 pupd_bit;	/* offset into the PULL_UPDOWN_REG_* register bit */
 };
 
-extern const struct tegra_pingroup_desc tegra_soc_pingroups[];
-extern const struct tegra_drive_pingroup_desc tegra_soc_drive_pingroups[];
+struct tegra_pinmux_pm {
+	void (*suspend)(void);
+	void (*resume)(void);
+};
+
+typedef void (*pinmux_init) (const struct tegra_pingroup_desc **pg,
+	int *pg_max, const struct tegra_drive_pingroup_desc **pgdrive,
+	int *pgdrive_max);
+
+void tegra20_pinmux_init(const struct tegra_pingroup_desc **pg, int *pg_max,
+	const struct tegra_drive_pingroup_desc **pgdrive, int *pgdrive_max);
 
-int tegra_pinmux_set_tristate(enum tegra_pingroup pg,
-	enum tegra_tristate tristate);
-int tegra_pinmux_set_pullupdown(enum tegra_pingroup pg,
-	enum tegra_pullupdown pupd);
+int tegra_pinmux_set_tristate(int pg, enum tegra_tristate tristate);
+int tegra_pinmux_set_pullupdown(int pg, enum tegra_pullupdown pupd);
 
 void tegra_pinmux_config_table(const struct tegra_pingroup_config *config,
 	int len);
@@ -241,4 +242,3 @@ void tegra_pinmux_config_tristate_table(const struct tegra_pingroup_config *conf
 void tegra_pinmux_config_pullupdown_table(const struct tegra_pingroup_config *config,
 	int len, enum tegra_pullupdown pupd);
 #endif
-
diff --git a/arch/arm/mach-tegra/pinmux-tegra20-tables.c b/arch/arm/mach-tegra/pinmux-tegra20-tables.c
index 88642a5..de9d0df 100644
--- a/arch/arm/mach-tegra/pinmux-tegra20-tables.c
+++ b/arch/arm/mach-tegra/pinmux-tegra20-tables.c
@@ -44,7 +44,7 @@
 		.reg = ((r) - PINGROUP_REG_A)			\
 	}
 
-const struct tegra_drive_pingroup_desc tegra_soc_drive_pingroups[TEGRA_MAX_DRIVE_PINGROUP] = {
+static const struct tegra_drive_pingroup_desc tegra_soc_drive_pingroups[TEGRA_MAX_DRIVE_PINGROUP] = {
 	DRIVE_PINGROUP(AO1,		0x868),
 	DRIVE_PINGROUP(AO2,		0x86c),
 	DRIVE_PINGROUP(AT1,		0x870),
@@ -108,7 +108,7 @@ const struct tegra_drive_pingroup_desc tegra_soc_drive_pingroups[TEGRA_MAX_DRIVE
 		.pupd_bit = pupd_b,				\
 	}
 
-const struct tegra_pingroup_desc tegra_soc_pingroups[TEGRA_MAX_PINGROUP] = {
+static const struct tegra_pingroup_desc tegra_soc_pingroups[TEGRA_MAX_PINGROUP] = {
 	PINGROUP(ATA,   NAND,  IDE,       NAND,      GMI,       RSVD,          IDE,       0x14, 0,  0x80, 24, 0xA0, 0),
 	PINGROUP(ATB,   NAND,  IDE,       NAND,      GMI,       SDIO4,         IDE,       0x14, 1,  0x80, 16, 0xA0, 2),
 	PINGROUP(ATC,   NAND,  IDE,       NAND,      GMI,       SDIO4,         IDE,       0x14, 2,  0x80, 22, 0xA0, 4),
@@ -227,3 +227,14 @@ const struct tegra_pingroup_desc tegra_soc_pingroups[TEGRA_MAX_PINGROUP] = {
 	PINGROUP(XM2C,  DDR,   RSVD,      RSVD,      RSVD,      RSVD,          RSVD,      -1,   -1, -1,   -1, 0xA8, 30),
 	PINGROUP(XM2D,  DDR,   RSVD,      RSVD,      RSVD,      RSVD,          RSVD,      -1,   -1, -1,   -1, 0xA8, 28),
 };
+
+void __init tegra20_pinmux_init(const struct tegra_pingroup_desc **pg,
+		int *pg_max, const struct tegra_drive_pingroup_desc **pgdrive,
+		int *pgdrive_max) 
+{
+	*pg = tegra_soc_pingroups;
+	*pg_max = TEGRA_MAX_PINGROUP;
+	*pgdrive = tegra_soc_drive_pingroups;
+	*pgdrive_max = TEGRA_MAX_DRIVE_PINGROUP;
+}
+
diff --git a/arch/arm/mach-tegra/pinmux.c b/arch/arm/mach-tegra/pinmux.c
index 1d20165..c8d93e2 100644
--- a/arch/arm/mach-tegra/pinmux.c
+++ b/arch/arm/mach-tegra/pinmux.c
@@ -21,6 +21,9 @@
 #include <linux/spinlock.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
+#ifdef CONFIG_OF
+#include <linux/of_platform.h>
+#endif
 
 #include <mach/iomap.h>
 #include <mach/pinmux.h>
@@ -33,8 +36,10 @@
 #define SLWR(reg)	(((reg) >> 28) & 0x3)
 #define SLWF(reg)	(((reg) >> 30) & 0x3)
 
-static const struct tegra_pingroup_desc *const pingroups = tegra_soc_pingroups;
-static const struct tegra_drive_pingroup_desc *const drive_pingroups = tegra_soc_drive_pingroups;
+static const struct tegra_pingroup_desc *pingroups;
+static const struct tegra_drive_pingroup_desc *drive_pingroups;
+static int pingroup_max;
+static int drive_max;
 
 static char *tegra_mux_names[TEGRA_MAX_MUX] = {
 	[TEGRA_MUX_AHB_CLK] = "AHB_CLK",
@@ -116,9 +121,9 @@ static const char *tegra_slew_names[TEGRA_MAX_SLEW] = {
 
 static DEFINE_SPINLOCK(mux_lock);
 
-static const char *pingroup_name(enum tegra_pingroup pg)
+static const char *pingroup_name(int pg)
 {
-	if (pg < 0 || pg >=  TEGRA_MAX_PINGROUP)
+	if (pg < 0 || pg >=  pingroup_max)
 		return "<UNKNOWN>";
 
 	return pingroups[pg].name;
@@ -189,10 +194,10 @@ static int tegra_pinmux_set_func(const struct tegra_pingroup_config *config)
 	int i;
 	unsigned long reg;
 	unsigned long flags;
-	enum tegra_pingroup pg = config->pingroup;
+	int pg = config->pingroup;
 	enum tegra_mux_func func = config->func;
 
-	if (pg < 0 || pg >=  TEGRA_MAX_PINGROUP)
+	if (pg < 0 || pg >=  pingroup_max)
 		return -ERANGE;
 
 	if (pingroups[pg].mux_reg < 0)
@@ -230,13 +235,12 @@ static int tegra_pinmux_set_func(const struct tegra_pingroup_config *config)
 	return 0;
 }
 
-int tegra_pinmux_set_tristate(enum tegra_pingroup pg,
-	enum tegra_tristate tristate)
+int tegra_pinmux_set_tristate(int pg, enum tegra_tristate tristate)
 {
 	unsigned long reg;
 	unsigned long flags;
 
-	if (pg < 0 || pg >=  TEGRA_MAX_PINGROUP)
+	if (pg < 0 || pg >=  pingroup_max)
 		return -ERANGE;
 
 	if (pingroups[pg].tri_reg < 0)
@@ -255,13 +259,12 @@ int tegra_pinmux_set_tristate(enum tegra_pingroup pg,
 	return 0;
 }
 
-int tegra_pinmux_set_pullupdown(enum tegra_pingroup pg,
-	enum tegra_pullupdown pupd)
+int tegra_pinmux_set_pullupdown(int pg, enum tegra_pullupdown pupd)
 {
 	unsigned long reg;
 	unsigned long flags;
 
-	if (pg < 0 || pg >=  TEGRA_MAX_PINGROUP)
+	if (pg < 0 || pg >=  pingroup_max)
 		return -ERANGE;
 
 	if (pingroups[pg].pupd_reg < 0)
@@ -287,7 +290,7 @@ int tegra_pinmux_set_pullupdown(enum tegra_pingroup pg,
 
 static void tegra_pinmux_config_pingroup(const struct tegra_pingroup_config *config)
 {
-	enum tegra_pingroup pingroup = config->pingroup;
+	int pingroup = config->pingroup;
 	enum tegra_mux_func func     = config->func;
 	enum tegra_pullupdown pupd   = config->pupd;
 	enum tegra_tristate tristate = config->tristate;
@@ -323,9 +326,9 @@ void tegra_pinmux_config_table(const struct tegra_pingroup_config *config, int l
 		tegra_pinmux_config_pingroup(&config[i]);
 }
 
-static const char *drive_pinmux_name(enum tegra_drive_pingroup pg)
+static const char *drive_pinmux_name(int pg)
 {
-	if (pg < 0 || pg >=  TEGRA_MAX_DRIVE_PINGROUP)
+	if (pg < 0 || pg >=  drive_max)
 		return "<UNKNOWN>";
 
 	return drive_pingroups[pg].name;
@@ -352,12 +355,11 @@ static const char *slew_name(unsigned long val)
 	return tegra_slew_names[val];
 }
 
-static int tegra_drive_pinmux_set_hsm(enum tegra_drive_pingroup pg,
-	enum tegra_hsm hsm)
+static int tegra_drive_pinmux_set_hsm(int pg, enum tegra_hsm hsm)
 {
 	unsigned long flags;
 	u32 reg;
-	if (pg < 0 || pg >=  TEGRA_MAX_DRIVE_PINGROUP)
+	if (pg < 0 || pg >=  drive_max)
 		return -ERANGE;
 
 	if (hsm != TEGRA_HSM_ENABLE && hsm != TEGRA_HSM_DISABLE)
@@ -377,12 +379,11 @@ static int tegra_drive_pinmux_set_hsm(enum tegra_drive_pingroup pg,
 	return 0;
 }
 
-static int tegra_drive_pinmux_set_schmitt(enum tegra_drive_pingroup pg,
-	enum tegra_schmitt schmitt)
+static int tegra_drive_pinmux_set_schmitt(int pg, enum tegra_schmitt schmitt)
 {
 	unsigned long flags;
 	u32 reg;
-	if (pg < 0 || pg >=  TEGRA_MAX_DRIVE_PINGROUP)
+	if (pg < 0 || pg >=  drive_max)
 		return -ERANGE;
 
 	if (schmitt != TEGRA_SCHMITT_ENABLE && schmitt != TEGRA_SCHMITT_DISABLE)
@@ -402,12 +403,11 @@ static int tegra_drive_pinmux_set_schmitt(enum tegra_drive_pingroup pg,
 	return 0;
 }
 
-static int tegra_drive_pinmux_set_drive(enum tegra_drive_pingroup pg,
-	enum tegra_drive drive)
+static int tegra_drive_pinmux_set_drive(int pg, enum tegra_drive drive)
 {
 	unsigned long flags;
 	u32 reg;
-	if (pg < 0 || pg >=  TEGRA_MAX_DRIVE_PINGROUP)
+	if (pg < 0 || pg >=  drive_max)
 		return -ERANGE;
 
 	if (drive < 0 || drive >= TEGRA_MAX_DRIVE)
@@ -425,12 +425,12 @@ static int tegra_drive_pinmux_set_drive(enum tegra_drive_pingroup pg,
 	return 0;
 }
 
-static int tegra_drive_pinmux_set_pull_down(enum tegra_drive_pingroup pg,
+static int tegra_drive_pinmux_set_pull_down(int pg,
 	enum tegra_pull_strength pull_down)
 {
 	unsigned long flags;
 	u32 reg;
-	if (pg < 0 || pg >=  TEGRA_MAX_DRIVE_PINGROUP)
+	if (pg < 0 || pg >=  drive_max)
 		return -ERANGE;
 
 	if (pull_down < 0 || pull_down >= TEGRA_MAX_PULL)
@@ -448,12 +448,12 @@ static int tegra_drive_pinmux_set_pull_down(enum tegra_drive_pingroup pg,
 	return 0;
 }
 
-static int tegra_drive_pinmux_set_pull_up(enum tegra_drive_pingroup pg,
+static int tegra_drive_pinmux_set_pull_up(int pg,
 	enum tegra_pull_strength pull_up)
 {
 	unsigned long flags;
 	u32 reg;
-	if (pg < 0 || pg >=  TEGRA_MAX_DRIVE_PINGROUP)
+	if (pg < 0 || pg >=  drive_max)
 		return -ERANGE;
 
 	if (pull_up < 0 || pull_up >= TEGRA_MAX_PULL)
@@ -471,12 +471,12 @@ static int tegra_drive_pinmux_set_pull_up(enum tegra_drive_pingroup pg,
 	return 0;
 }
 
-static int tegra_drive_pinmux_set_slew_rising(enum tegra_drive_pingroup pg,
+static int tegra_drive_pinmux_set_slew_rising(int pg,
 	enum tegra_slew slew_rising)
 {
 	unsigned long flags;
 	u32 reg;
-	if (pg < 0 || pg >=  TEGRA_MAX_DRIVE_PINGROUP)
+	if (pg < 0 || pg >=  drive_max)
 		return -ERANGE;
 
 	if (slew_rising < 0 || slew_rising >= TEGRA_MAX_SLEW)
@@ -494,12 +494,12 @@ static int tegra_drive_pinmux_set_slew_rising(enum tegra_drive_pingroup pg,
 	return 0;
 }
 
-static int tegra_drive_pinmux_set_slew_falling(enum tegra_drive_pingroup pg,
+static int tegra_drive_pinmux_set_slew_falling(int pg,
 	enum tegra_slew slew_falling)
 {
 	unsigned long flags;
 	u32 reg;
-	if (pg < 0 || pg >=  TEGRA_MAX_DRIVE_PINGROUP)
+	if (pg < 0 || pg >=  drive_max)
 		return -ERANGE;
 
 	if (slew_falling < 0 || slew_falling >= TEGRA_MAX_SLEW)
@@ -517,7 +517,7 @@ static int tegra_drive_pinmux_set_slew_falling(enum tegra_drive_pingroup pg,
 	return 0;
 }
 
-static void tegra_drive_pinmux_config_pingroup(enum tegra_drive_pingroup pingroup,
+static void tegra_drive_pinmux_config_pingroup(int pingroup,
 					  enum tegra_hsm hsm,
 					  enum tegra_schmitt schmitt,
 					  enum tegra_drive drive,
@@ -596,7 +596,7 @@ void tegra_pinmux_set_safe_pinmux_table(const struct tegra_pingroup_config *conf
 	for (i = 0; i < len; i++) {
 		int err;
 		c = config[i];
-		if (c.pingroup < 0 || c.pingroup >= TEGRA_MAX_PINGROUP) {
+		if (c.pingroup < 0 || c.pingroup >= pingroup_max) {
 			WARN_ON(1);
 			continue;
 		}
@@ -617,7 +617,7 @@ void tegra_pinmux_config_pinmux_table(const struct tegra_pingroup_config *config
 	for (i = 0; i < len; i++) {
 		int err;
 		if (config[i].pingroup < 0 ||
-		    config[i].pingroup >= TEGRA_MAX_PINGROUP) {
+		    config[i].pingroup >= pingroup_max) {
 			WARN_ON(1);
 			continue;
 		}
@@ -635,7 +635,7 @@ void tegra_pinmux_config_tristate_table(const struct tegra_pingroup_config *conf
 {
 	int i;
 	int err;
-	enum tegra_pingroup pingroup;
+	int pingroup;
 
 	for (i = 0; i < len; i++) {
 		pingroup = config[i].pingroup;
@@ -654,7 +654,7 @@ void tegra_pinmux_config_pullupdown_table(const struct tegra_pingroup_config *co
 {
 	int i;
 	int err;
-	enum tegra_pingroup pingroup;
+	int pingroup;
 
 	for (i = 0; i < len; i++) {
 		pingroup = config[i].pingroup;
@@ -668,11 +668,29 @@ void tegra_pinmux_config_pullupdown_table(const struct tegra_pingroup_config *co
 	}
 }
 
+static struct of_device_id tegra_pinmux_of_match[] __devinitdata = {
+	{ .compatible = "nvidia,tegra20-pinmux", tegra20_pinmux_init },
+	{ },
+};
+
 static int __devinit tegra_pinmux_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	int i;
 	int config_bad = 0;
+	const struct of_device_id *match = NULL;
+
+#ifdef CONFIG_OF
+	match = of_match_device(tegra_pinmux_of_match, &pdev->dev);
+#endif
+
+	if (match)
+		((pinmux_init)(match->data))(&pingroups, &pingroup_max,
+			&drive_pingroups, &drive_max);
+	else
+		/* no device tree available, so we must be on tegra20 */
+		tegra20_pinmux_init(&pingroups, &pingroup_max,
+					&drive_pingroups, &drive_max);
 
 	for (i = 0; ; i++) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
@@ -681,7 +699,7 @@ static int __devinit tegra_pinmux_probe(struct platform_device *pdev)
 	}
 	nbanks = i;
 
-	for (i = 0; i < TEGRA_MAX_PINGROUP; i++) {
+	for (i = 0; i < pingroup_max; i++) {
 		if (pingroups[i].tri_bank >= nbanks) {
 			dev_err(&pdev->dev, "pingroup %d: bad tri_bank\n", i);
 			config_bad = 1;
@@ -698,7 +716,7 @@ static int __devinit tegra_pinmux_probe(struct platform_device *pdev)
 		}
 	}
 
-	for (i = 0; i < TEGRA_MAX_DRIVE_PINGROUP; i++) {
+	for (i = 0; i < drive_max; i++) {
 		if (drive_pingroups[i].reg_bank >= nbanks) {
 			dev_err(&pdev->dev,
 				"drive pingroup %d: bad reg_bank\n", i);
@@ -741,11 +759,6 @@ static int __devinit tegra_pinmux_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id tegra_pinmux_of_match[] __devinitdata = {
-	{ .compatible = "nvidia,tegra20-pinmux", },
-	{ },
-};
-
 static struct platform_driver tegra_pinmux_driver = {
 	.driver		= {
 		.name	= "tegra-pinmux",
@@ -779,7 +792,7 @@ static int dbg_pinmux_show(struct seq_file *s, void *unused)
 	int i;
 	int len;
 
-	for (i = 0; i < TEGRA_MAX_PINGROUP; i++) {
+	for (i = 0; i < pingroup_max; i++) {
 		unsigned long reg;
 		unsigned long tri;
 		unsigned long mux;
@@ -850,7 +863,7 @@ static int dbg_drive_pinmux_show(struct seq_file *s, void *unused)
 	int i;
 	int len;
 
-	for (i = 0; i < TEGRA_MAX_DRIVE_PINGROUP; i++) {
+	for (i = 0; i < drive_max; i++) {
 		u32 reg;
 
 		seq_printf(s, "\t{TEGRA_DRIVE_PINGROUP_%s",
-- 
1.7.7.rc0.72.g4b5ea.dirty

