Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab1BJGqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 01:46:49 -0500
Received: from smtp-out.google.com ([216.239.44.51]:17318 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab1BJGn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 01:43:59 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Gary King <gking@nvidia.com>, Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 06/15] ARM: tegra: pinmux: Add missing drive pingroups and fix suspend
Date: Wed,  9 Feb 2011 22:43:15 -0800
Message-Id: <1297320204-31882-7-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297320204-31882-1-git-send-email-ccross@android.com>
References: <1297320204-31882-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gary King <gking@nvidia.com>

Adds missing drive pingroups, saves all drive pingroups in
suspend, and restores the pinmux registers in the proper order.

Signed-off-by: Gary King <gking@nvidia.com>
Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/include/mach/pinmux-t2.h |   10 ++++++++++
 arch/arm/mach-tegra/pinmux-t2-tables.c       |   25 +++++++++++++++++++++----
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/pinmux-t2.h b/arch/arm/mach-tegra/include/mach/pinmux-t2.h
index e5b9d74..4c26263 100644
--- a/arch/arm/mach-tegra/include/mach/pinmux-t2.h
+++ b/arch/arm/mach-tegra/include/mach/pinmux-t2.h
@@ -167,6 +167,16 @@ enum tegra_drive_pingroup {
 	TEGRA_DRIVE_PINGROUP_XM2D,
 	TEGRA_DRIVE_PINGROUP_XM2CLK,
 	TEGRA_DRIVE_PINGROUP_MEMCOMP,
+	TEGRA_DRIVE_PINGROUP_SDIO1,
+	TEGRA_DRIVE_PINGROUP_CRT,
+	TEGRA_DRIVE_PINGROUP_DDC,
+	TEGRA_DRIVE_PINGROUP_GMA,
+	TEGRA_DRIVE_PINGROUP_GMB,
+	TEGRA_DRIVE_PINGROUP_GMC,
+	TEGRA_DRIVE_PINGROUP_GMD,
+	TEGRA_DRIVE_PINGROUP_GME,
+	TEGRA_DRIVE_PINGROUP_OWR,
+	TEGRA_DRIVE_PINGROUP_UAD,
 	TEGRA_MAX_DRIVE_PINGROUP,
 };
 
diff --git a/arch/arm/mach-tegra/pinmux-t2-tables.c b/arch/arm/mach-tegra/pinmux-t2-tables.c
index 4d97d5c..a475367 100644
--- a/arch/arm/mach-tegra/pinmux-t2-tables.c
+++ b/arch/arm/mach-tegra/pinmux-t2-tables.c
@@ -66,6 +66,16 @@ const struct tegra_drive_pingroup_desc tegra_soc_drive_pingroups[TEGRA_MAX_DRIVE
 	DRIVE_PINGROUP(XM2D,		0x8cc),
 	DRIVE_PINGROUP(XM2CLK,		0x8d0),
 	DRIVE_PINGROUP(MEMCOMP,		0x8d4),
+	DRIVE_PINGROUP(SDIO1,		0x8e0),
+	DRIVE_PINGROUP(CRT,		0x8ec),
+	DRIVE_PINGROUP(DDC,		0x8f0),
+	DRIVE_PINGROUP(GMA,		0x8f4),
+	DRIVE_PINGROUP(GMB,		0x8f8),
+	DRIVE_PINGROUP(GMC,		0x8fc),
+	DRIVE_PINGROUP(GMD,		0x900),
+	DRIVE_PINGROUP(GME,		0x904),
+	DRIVE_PINGROUP(OWR,		0x908),
+	DRIVE_PINGROUP(UAD,		0x90c),
 };
 
 #define PINGROUP(pg_name, vdd, f0, f1, f2, f3, f_safe,		\
@@ -217,7 +227,8 @@ const struct tegra_pingroup_desc tegra_soc_pingroups[TEGRA_MAX_PINGROUP] = {
 #define PULLUPDOWN_REG_NUM     5
 
 static u32 pinmux_reg[TRISTATE_REG_NUM + PIN_MUX_CTL_REG_NUM +
-		     PULLUPDOWN_REG_NUM];
+		      PULLUPDOWN_REG_NUM +
+		      ARRAY_SIZE(tegra_soc_drive_pingroups)];
 
 static inline unsigned long pg_readl(unsigned long offset)
 {
@@ -234,14 +245,17 @@ void tegra_pinmux_suspend(void)
 	unsigned int i;
 	u32 *ctx = pinmux_reg;
 
-	for (i = 0; i < TRISTATE_REG_NUM; i++)
-		*ctx++ = pg_readl(TRISTATE_REG_A + i*4);
-
 	for (i = 0; i < PIN_MUX_CTL_REG_NUM; i++)
 		*ctx++ = pg_readl(PIN_MUX_CTL_REG_A + i*4);
 
 	for (i = 0; i < PULLUPDOWN_REG_NUM; i++)
 		*ctx++ = pg_readl(PULLUPDOWN_REG_A + i*4);
+
+	for (i = 0; i < TRISTATE_REG_NUM; i++)
+		*ctx++ = pg_readl(TRISTATE_REG_A + i*4);
+
+	for (i = 0; i < ARRAY_SIZE(tegra_soc_drive_pingroups); i++)
+		*ctx++ = pg_readl(tegra_soc_drive_pingroups[i].reg);
 }
 
 void tegra_pinmux_resume(void)
@@ -257,5 +271,8 @@ void tegra_pinmux_resume(void)
 
 	for (i = 0; i < TRISTATE_REG_NUM; i++)
 		pg_writel(*ctx++, TRISTATE_REG_A + i*4);
+
+	for (i = 0; i < ARRAY_SIZE(tegra_soc_drive_pingroups); i++)
+		pg_writel(*ctx++, tegra_soc_drive_pingroups[i].reg);
 }
 #endif
-- 
1.7.3.1

