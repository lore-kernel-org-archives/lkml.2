Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab1CXP5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:57:35 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:55540 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932458Ab1CXP5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:57:33 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18d3DFWBp8dFF3zNFvXzzo9q/AZDXUWv1wT5R+dhK
	TVlcDYo2P2qtGb
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/3] viafb: split clock and PLL code to an extra file
Date: Thu, 24 Mar 2011 16:12:59 +0000
Message-Id: <1300983180-7343-3-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1300983180-7343-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1300983180-7343-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a huge move operation with some rename and introduces
an interface to still use the functions. This should be a step in
the right direction to reuse the code whenever possible but cleanly
separate code that differs on different platform and keeping the
complexity as low as possible.
pll_config was renamed to via_pll_config to keep the naming scheme.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/Makefile    |    2 +-
 drivers/video/via/hw.c        |  288 ++---------------------------------------
 drivers/video/via/hw.h        |    6 -
 drivers/video/via/via_clock.c |  280 +++++++++++++++++++++++++++++++++++++++
 drivers/video/via/via_clock.h |   73 +++++++++++
 5 files changed, 368 insertions(+), 281 deletions(-)
 create mode 100644 drivers/video/via/via_clock.c
 create mode 100644 drivers/video/via/via_clock.h

diff --git a/drivers/video/via/Makefile b/drivers/video/via/Makefile
index 96f01ee..5108136 100644
--- a/drivers/video/via/Makefile
+++ b/drivers/video/via/Makefile
@@ -6,4 +6,4 @@ obj-$(CONFIG_FB_VIA) += viafb.o
 
 viafb-y	:=viafbdev.o hw.o via_i2c.o dvi.o lcd.o ioctl.o accel.o \
 	via_utility.o vt1636.o global.o tblDPASetting.o viamode.o \
-	via-core.o via-gpio.o via_modesetting.o
+	via-core.o via-gpio.o via_modesetting.o via_clock.o
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 712348d..f1eff0b 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -21,6 +21,7 @@
 
 #include <linux/via-core.h>
 #include "global.h"
+#include "via_clock.h"
 
 static struct pll_limit cle266_pll_limits[] = {
 	{19, 19, 4, 0},
@@ -484,6 +485,9 @@ static struct via_device_mapping device_mapping[] = {
 	{VIA_LVDS2, "LVDS2"}
 };
 
+/* structure with function pointers to support clock control */
+static struct via_clock clock;
+
 static void load_fix_bit_crtc_reg(void);
 static void __devinit init_gfx_chip_info(int chip_type);
 static void __devinit init_tmds_chip_info(void);
@@ -1409,230 +1413,10 @@ void viafb_load_FIFO_reg(int set_iga, int hor_active, int ver_active)
 
 }
 
-static void set_primary_clock_state(u8 state)
-{
-	u8 value;
-
-	switch (state) {
-	case VIA_STATE_ON:
-		value = 0x20;
-		break;
-	case VIA_STATE_OFF:
-		value = 0x00;
-		break;
-	default:
-		return;
-	}
-
-	via_write_reg_mask(VIASR, 0x1B, value, 0x30);
-}
-
-static void set_secondary_clock_state(u8 state)
-{
-	u8 value;
-
-	switch (state) {
-	case VIA_STATE_ON:
-		value = 0x80;
-		break;
-	case VIA_STATE_OFF:
-		value = 0x00;
-		break;
-	default:
-		return;
-	}
-
-	via_write_reg_mask(VIASR, 0x1B, value, 0xC0);
-}
-
-static void set_primary_pll_state(u8 state)
-{
-	u8 value;
-
-	switch (state) {
-	case VIA_STATE_ON:
-		value = 0x20;
-		break;
-	case VIA_STATE_OFF:
-		value = 0x00;
-		break;
-	default:
-		return;
-	}
-
-	via_write_reg_mask(VIASR, 0x2D, value, 0x30);
-}
-
-static void set_secondary_pll_state(u8 state)
-{
-	u8 value;
-
-	switch (state) {
-	case VIA_STATE_ON:
-		value = 0x08;
-		break;
-	case VIA_STATE_OFF:
-		value = 0x00;
-		break;
-	default:
-		return;
-	}
-
-	via_write_reg_mask(VIASR, 0x2D, value, 0x0C);
-}
-
-static u32 cle266_encode_pll(struct pll_config pll)
-{
-	return (pll.multiplier << 8)
-		| (pll.rshift << 6)
-		| pll.divisor;
-}
-
-static u32 k800_encode_pll(struct pll_config pll)
-{
-	return ((pll.divisor - 2) << 16)
-		| (pll.rshift << 10)
-		| (pll.multiplier - 2);
-}
-
-static u32 vx855_encode_pll(struct pll_config pll)
-{
-	return (pll.divisor << 16)
-		| (pll.rshift << 10)
-		| pll.multiplier;
-}
-
-static inline void cle266_set_primary_pll_encoded(u32 data)
-{
-	via_write_reg_mask(VIASR, 0x40, 0x02, 0x02); /* enable reset */
-	via_write_reg(VIASR, 0x46, data & 0xFF);
-	via_write_reg(VIASR, 0x47, (data >> 8) & 0xFF);
-	via_write_reg_mask(VIASR, 0x40, 0x00, 0x02); /* disable reset */
-}
-
-static inline void k800_set_primary_pll_encoded(u32 data)
-{
-	via_write_reg_mask(VIASR, 0x40, 0x02, 0x02); /* enable reset */
-	via_write_reg(VIASR, 0x44, data & 0xFF);
-	via_write_reg(VIASR, 0x45, (data >> 8) & 0xFF);
-	via_write_reg(VIASR, 0x46, (data >> 16) & 0xFF);
-	via_write_reg_mask(VIASR, 0x40, 0x00, 0x02); /* disable reset */
-}
-
-static inline void cle266_set_secondary_pll_encoded(u32 data)
-{
-	via_write_reg_mask(VIASR, 0x40, 0x04, 0x04); /* enable reset */
-	via_write_reg(VIASR, 0x44, data & 0xFF);
-	via_write_reg(VIASR, 0x45, (data >> 8) & 0xFF);
-	via_write_reg_mask(VIASR, 0x40, 0x00, 0x04); /* disable reset */
-}
-
-static inline void k800_set_secondary_pll_encoded(u32 data)
-{
-	via_write_reg_mask(VIASR, 0x40, 0x04, 0x04); /* enable reset */
-	via_write_reg(VIASR, 0x4A, data & 0xFF);
-	via_write_reg(VIASR, 0x4B, (data >> 8) & 0xFF);
-	via_write_reg(VIASR, 0x4C, (data >> 16) & 0xFF);
-	via_write_reg_mask(VIASR, 0x40, 0x00, 0x04); /* disable reset */
-}
-
-static void cle266_set_primary_pll(struct pll_config config)
-{
-	cle266_set_primary_pll_encoded(cle266_encode_pll(config));
-}
-
-static void k800_set_primary_pll(struct pll_config config)
-{
-	k800_set_primary_pll_encoded(k800_encode_pll(config));
-}
-
-static void vx855_set_primary_pll(struct pll_config config)
-{
-	k800_set_primary_pll_encoded(vx855_encode_pll(config));
-}
-
-static void cle266_set_secondary_pll(struct pll_config config)
-{
-	cle266_set_secondary_pll_encoded(cle266_encode_pll(config));
-}
-
-static void k800_set_secondary_pll(struct pll_config config)
-{
-	k800_set_secondary_pll_encoded(k800_encode_pll(config));
-}
-
-static void vx855_set_secondary_pll(struct pll_config config)
-{
-	k800_set_secondary_pll_encoded(vx855_encode_pll(config));
-}
-
-enum via_clksrc {
-	VIA_CLKSRC_X1 = 0,
-	VIA_CLKSRC_TVX1,
-	VIA_CLKSRC_TVPLL,
-	VIA_CLKSRC_DVP1TVCLKR,
-	VIA_CLKSRC_CAP0,
-	VIA_CLKSRC_CAP1,
-};
-
-static inline u8 set_clock_source_common(enum via_clksrc source, bool use_pll)
-{
-	u8 data = 0;
-
-	switch (source) {
-	case VIA_CLKSRC_X1:
-		data = 0x00;
-		break;
-	case VIA_CLKSRC_TVX1:
-		data = 0x02;
-		break;
-	case VIA_CLKSRC_TVPLL:
-		data = 0x04; /* 0x06 should be the same */
-		break;
-	case VIA_CLKSRC_DVP1TVCLKR:
-		data = 0x0A;
-		break;
-	case VIA_CLKSRC_CAP0:
-		data = 0xC;
-		break;
-	case VIA_CLKSRC_CAP1:
-		data = 0x0E;
-		break;
-	}
-
-	if (!use_pll)
-		data |= 1;
-
-	return data;
-}
-
-static void set_primary_clock_source(enum via_clksrc source, bool use_pll)
-{
-	u8 data = set_clock_source_common(source, use_pll) << 4;
-	via_write_reg_mask(VIACR, 0x6C, data, 0xF0);
-}
-
-static void set_secondary_clock_source(enum via_clksrc source, bool use_pll)
-{
-	u8 data = set_clock_source_common(source, use_pll);
-	via_write_reg_mask(VIACR, 0x6C, data, 0x0F);
-}
-
-static inline u32 get_pll_internal_frequency(u32 ref_freq,
-	struct pll_config pll)
-{
-	return ref_freq / pll.divisor * pll.multiplier;
-}
-
-static inline u32 get_pll_output_frequency(u32 ref_freq, struct pll_config pll)
-{
-	return get_pll_internal_frequency(ref_freq, pll)>>pll.rshift;
-}
-
-static struct pll_config get_pll_config(struct pll_limit *limits, int size,
+static struct via_pll_config get_pll_config(struct pll_limit *limits, int size,
 	int clk)
 {
-	struct pll_config cur, up, down, best = {0, 1, 0};
+	struct via_pll_config cur, up, down, best = {0, 1, 0};
 	const u32 f0 = 14318180; /* X1 frequency */
 	int i, f;
 
@@ -1662,9 +1446,9 @@ static struct pll_config get_pll_config(struct pll_limit *limits, int size,
 	return best;
 }
 
-static struct pll_config get_best_pll_config(int clk)
+static struct via_pll_config get_best_pll_config(int clk)
 {
-	struct pll_config config;
+	struct via_pll_config config;
 
 	switch (viaparinfo->chip_info->gfx_chip_name) {
 	case UNICHROME_CLE266:
@@ -1700,57 +1484,12 @@ static struct pll_config get_best_pll_config(int clk)
 /* Set VCLK*/
 void viafb_set_vclock(u32 clk, int set_iga)
 {
-	struct pll_config config = get_best_pll_config(clk);
+	struct via_pll_config config = get_best_pll_config(clk);
 
-	if (set_iga == IGA1) {
-		/* Change D,N FOR VCLK */
-		switch (viaparinfo->chip_info->gfx_chip_name) {
-		case UNICHROME_CLE266:
-		case UNICHROME_K400:
-			cle266_set_primary_pll(config);
-			break;
-		case UNICHROME_K800:
-		case UNICHROME_PM800:
-		case UNICHROME_CN700:
-		case UNICHROME_CX700:
-		case UNICHROME_CN750:
-		case UNICHROME_K8M890:
-		case UNICHROME_P4M890:
-		case UNICHROME_P4M900:
-		case UNICHROME_VX800:
-			k800_set_primary_pll(config);
-			break;
-		case UNICHROME_VX855:
-		case UNICHROME_VX900:
-			vx855_set_primary_pll(config);
-			break;
-		}
-	}
-
-	if (set_iga == IGA2) {
-		/* Change D,N FOR LCK */
-		switch (viaparinfo->chip_info->gfx_chip_name) {
-		case UNICHROME_CLE266:
-		case UNICHROME_K400:
-			cle266_set_secondary_pll(config);
-			break;
-		case UNICHROME_K800:
-		case UNICHROME_PM800:
-		case UNICHROME_CN700:
-		case UNICHROME_CX700:
-		case UNICHROME_CN750:
-		case UNICHROME_K8M890:
-		case UNICHROME_P4M890:
-		case UNICHROME_P4M900:
-		case UNICHROME_VX800:
-			k800_set_secondary_pll(config);
-			break;
-		case UNICHROME_VX855:
-		case UNICHROME_VX900:
-			vx855_set_secondary_pll(config);
-			break;
-		}
-	}
+	if (set_iga == IGA1)
+		clock.set_primary_pll(config);
+	if (set_iga == IGA2)
+		clock.set_secondary_pll(config);
 
 	/* Fire! */
 	via_write_misc_reg_mask(0x0C, 0x0C); /* select external clock */
@@ -2059,6 +1798,7 @@ void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
 
 void __devinit viafb_init_chip_info(int chip_type)
 {
+	via_clock_init(&clock, chip_type);
 	init_gfx_chip_info(chip_type);
 	init_tmds_chip_info();
 	init_lvds_chip_info();
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index 2cdce9b..7e9f51a 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -732,12 +732,6 @@ struct _lcd_scaling_factor {
 	struct _lcd_ver_scaling_factor lcd_ver_scaling_factor;
 };
 
-struct pll_config {
-	u16 multiplier;
-	u8 divisor;
-	u8 rshift;
-};
-
 struct pll_limit {
 	u16 multiplier_min;
 	u16 multiplier_max;
diff --git a/drivers/video/via/via_clock.c b/drivers/video/via/via_clock.c
new file mode 100644
index 0000000..29afe4c
--- /dev/null
+++ b/drivers/video/via/via_clock.c
@@ -0,0 +1,280 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+ * Copyright 2011 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+/*
+ * clock and PLL management functions
+ */
+
+#include <linux/kernel.h>
+#include <linux/via-core.h>
+#include "via_clock.h"
+#include "global.h"
+#include "debug.h"
+
+static inline u32 cle266_encode_pll(struct via_pll_config pll)
+{
+	return (pll.multiplier << 8)
+		| (pll.rshift << 6)
+		| pll.divisor;
+}
+
+static inline u32 k800_encode_pll(struct via_pll_config pll)
+{
+	return ((pll.divisor - 2) << 16)
+		| (pll.rshift << 10)
+		| (pll.multiplier - 2);
+}
+
+static inline u32 vx855_encode_pll(struct via_pll_config pll)
+{
+	return (pll.divisor << 16)
+		| (pll.rshift << 10)
+		| pll.multiplier;
+}
+
+static inline void cle266_set_primary_pll_encoded(u32 data)
+{
+	via_write_reg_mask(VIASR, 0x40, 0x02, 0x02); /* enable reset */
+	via_write_reg(VIASR, 0x46, data & 0xFF);
+	via_write_reg(VIASR, 0x47, (data >> 8) & 0xFF);
+	via_write_reg_mask(VIASR, 0x40, 0x00, 0x02); /* disable reset */
+}
+
+static inline void k800_set_primary_pll_encoded(u32 data)
+{
+	via_write_reg_mask(VIASR, 0x40, 0x02, 0x02); /* enable reset */
+	via_write_reg(VIASR, 0x44, data & 0xFF);
+	via_write_reg(VIASR, 0x45, (data >> 8) & 0xFF);
+	via_write_reg(VIASR, 0x46, (data >> 16) & 0xFF);
+	via_write_reg_mask(VIASR, 0x40, 0x00, 0x02); /* disable reset */
+}
+
+static inline void cle266_set_secondary_pll_encoded(u32 data)
+{
+	via_write_reg_mask(VIASR, 0x40, 0x04, 0x04); /* enable reset */
+	via_write_reg(VIASR, 0x44, data & 0xFF);
+	via_write_reg(VIASR, 0x45, (data >> 8) & 0xFF);
+	via_write_reg_mask(VIASR, 0x40, 0x00, 0x04); /* disable reset */
+}
+
+static inline void k800_set_secondary_pll_encoded(u32 data)
+{
+	via_write_reg_mask(VIASR, 0x40, 0x04, 0x04); /* enable reset */
+	via_write_reg(VIASR, 0x4A, data & 0xFF);
+	via_write_reg(VIASR, 0x4B, (data >> 8) & 0xFF);
+	via_write_reg(VIASR, 0x4C, (data >> 16) & 0xFF);
+	via_write_reg_mask(VIASR, 0x40, 0x00, 0x04); /* disable reset */
+}
+
+static void cle266_set_primary_pll(struct via_pll_config config)
+{
+	cle266_set_primary_pll_encoded(cle266_encode_pll(config));
+}
+
+static void k800_set_primary_pll(struct via_pll_config config)
+{
+	k800_set_primary_pll_encoded(k800_encode_pll(config));
+}
+
+static void vx855_set_primary_pll(struct via_pll_config config)
+{
+	k800_set_primary_pll_encoded(vx855_encode_pll(config));
+}
+
+static void cle266_set_secondary_pll(struct via_pll_config config)
+{
+	cle266_set_secondary_pll_encoded(cle266_encode_pll(config));
+}
+
+static void k800_set_secondary_pll(struct via_pll_config config)
+{
+	k800_set_secondary_pll_encoded(k800_encode_pll(config));
+}
+
+static void vx855_set_secondary_pll(struct via_pll_config config)
+{
+	k800_set_secondary_pll_encoded(vx855_encode_pll(config));
+}
+
+static void set_primary_pll_state(u8 state)
+{
+	u8 value;
+
+	switch (state) {
+	case VIA_STATE_ON:
+		value = 0x20;
+		break;
+	case VIA_STATE_OFF:
+		value = 0x00;
+		break;
+	default:
+		return;
+	}
+
+	via_write_reg_mask(VIASR, 0x2D, value, 0x30);
+}
+
+static void set_secondary_pll_state(u8 state)
+{
+	u8 value;
+
+	switch (state) {
+	case VIA_STATE_ON:
+		value = 0x08;
+		break;
+	case VIA_STATE_OFF:
+		value = 0x00;
+		break;
+	default:
+		return;
+	}
+
+	via_write_reg_mask(VIASR, 0x2D, value, 0x0C);
+}
+
+static void set_primary_clock_state(u8 state)
+{
+	u8 value;
+
+	switch (state) {
+	case VIA_STATE_ON:
+		value = 0x20;
+		break;
+	case VIA_STATE_OFF:
+		value = 0x00;
+		break;
+	default:
+		return;
+	}
+
+	via_write_reg_mask(VIASR, 0x1B, value, 0x30);
+}
+
+static void set_secondary_clock_state(u8 state)
+{
+	u8 value;
+
+	switch (state) {
+	case VIA_STATE_ON:
+		value = 0x80;
+		break;
+	case VIA_STATE_OFF:
+		value = 0x00;
+		break;
+	default:
+		return;
+	}
+
+	via_write_reg_mask(VIASR, 0x1B, value, 0xC0);
+}
+
+static inline u8 set_clock_source_common(enum via_clksrc source, bool use_pll)
+{
+	u8 data = 0;
+
+	switch (source) {
+	case VIA_CLKSRC_X1:
+		data = 0x00;
+		break;
+	case VIA_CLKSRC_TVX1:
+		data = 0x02;
+		break;
+	case VIA_CLKSRC_TVPLL:
+		data = 0x04; /* 0x06 should be the same */
+		break;
+	case VIA_CLKSRC_DVP1TVCLKR:
+		data = 0x0A;
+		break;
+	case VIA_CLKSRC_CAP0:
+		data = 0xC;
+		break;
+	case VIA_CLKSRC_CAP1:
+		data = 0x0E;
+		break;
+	}
+
+	if (!use_pll)
+		data |= 1;
+
+	return data;
+}
+
+static void set_primary_clock_source(enum via_clksrc source, bool use_pll)
+{
+	u8 data = set_clock_source_common(source, use_pll) << 4;
+	via_write_reg_mask(VIACR, 0x6C, data, 0xF0);
+}
+
+static void set_secondary_clock_source(enum via_clksrc source, bool use_pll)
+{
+	u8 data = set_clock_source_common(source, use_pll);
+	via_write_reg_mask(VIACR, 0x6C, data, 0x0F);
+}
+
+void via_clock_init(struct via_clock *clock, int gfx_chip)
+{
+	switch (gfx_chip) {
+	case UNICHROME_CLE266:
+	case UNICHROME_K400:
+		clock->set_primary_clock_state = NULL;
+		clock->set_primary_clock_source = NULL;
+		clock->set_primary_pll_state = NULL;
+		clock->set_primary_pll = cle266_set_primary_pll;
+
+		clock->set_secondary_clock_state = NULL;
+		clock->set_secondary_clock_source = NULL;
+		clock->set_secondary_pll_state = NULL;
+		clock->set_secondary_pll = cle266_set_secondary_pll;
+		break;
+	case UNICHROME_K800:
+	case UNICHROME_PM800:
+	case UNICHROME_CN700:
+	case UNICHROME_CX700:
+	case UNICHROME_CN750:
+	case UNICHROME_K8M890:
+	case UNICHROME_P4M890:
+	case UNICHROME_P4M900:
+	case UNICHROME_VX800:
+		clock->set_primary_clock_state = set_primary_clock_state;
+		clock->set_primary_clock_source = set_primary_clock_source;
+		clock->set_primary_pll_state = set_primary_pll_state;
+		clock->set_primary_pll = k800_set_primary_pll;
+
+		clock->set_secondary_clock_state = set_secondary_clock_state;
+		clock->set_secondary_clock_source = set_secondary_clock_source;
+		clock->set_secondary_pll_state = set_secondary_pll_state;
+		clock->set_secondary_pll = k800_set_secondary_pll;
+		break;
+	case UNICHROME_VX855:
+	case UNICHROME_VX900:
+		clock->set_primary_clock_state = set_primary_clock_state;
+		clock->set_primary_clock_source = set_primary_clock_source;
+		clock->set_primary_pll_state = set_primary_pll_state;
+		clock->set_primary_pll = vx855_set_primary_pll;
+
+		clock->set_secondary_clock_state = set_secondary_clock_state;
+		clock->set_secondary_clock_source = set_secondary_clock_source;
+		clock->set_secondary_pll_state = set_secondary_pll_state;
+		clock->set_secondary_pll = vx855_set_secondary_pll;
+		break;
+
+	}
+}
diff --git a/drivers/video/via/via_clock.h b/drivers/video/via/via_clock.h
new file mode 100644
index 0000000..f213a7a
--- /dev/null
+++ b/drivers/video/via/via_clock.h
@@ -0,0 +1,73 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+ * Copyright 2011 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+/*
+ * clock and PLL management functions
+ */
+
+#ifndef __VIA_CLOCK_H__
+#define __VIA_CLOCK_H__
+
+#include <linux/types.h>
+
+enum via_clksrc {
+	VIA_CLKSRC_X1 = 0,
+	VIA_CLKSRC_TVX1,
+	VIA_CLKSRC_TVPLL,
+	VIA_CLKSRC_DVP1TVCLKR,
+	VIA_CLKSRC_CAP0,
+	VIA_CLKSRC_CAP1,
+};
+
+struct via_pll_config {
+	u16 multiplier;
+	u8 divisor;
+	u8 rshift;
+};
+
+struct via_clock {
+	void (*set_primary_clock_state)(u8 state);
+	void (*set_primary_clock_source)(enum via_clksrc src, bool use_pll);
+	void (*set_primary_pll_state)(u8 state);
+	void (*set_primary_pll)(struct via_pll_config config);
+
+	void (*set_secondary_clock_state)(u8 state);
+	void (*set_secondary_clock_source)(enum via_clksrc src, bool use_pll);
+	void (*set_secondary_pll_state)(u8 state);
+	void (*set_secondary_pll)(struct via_pll_config config);
+};
+
+
+static inline u32 get_pll_internal_frequency(u32 ref_freq,
+	struct via_pll_config pll)
+{
+	return ref_freq / pll.divisor * pll.multiplier;
+}
+
+static inline u32 get_pll_output_frequency(u32 ref_freq,
+	struct via_pll_config pll)
+{
+	return get_pll_internal_frequency(ref_freq, pll) >> pll.rshift;
+}
+
+void via_clock_init(struct via_clock *clock, int gfx_chip);
+
+#endif /* __VIA_CLOCK_H__ */
-- 
1.6.3.2

