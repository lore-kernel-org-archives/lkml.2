Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab2DPVT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 17:19:28 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:50401 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754955Ab2DPVTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 17:19:25 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] Add Wolfson Microelectronics WM8766 codec ALSA driver
Date: Mon, 16 Apr 2012 23:18:36 +0200
Message-Id: <1334611118-10301-3-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1334611118-10301-1-git-send-email-linux@rainbow-software.org>
References: <1334611118-10301-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed by Philips PSC724 subdriver. The code does not contain any
card-specific bits so it can be used by any other ALSA driver.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 include/sound/wm8766.h   |  160 ++++++++++++++++++++
 sound/i2c/other/Makefile |    3 +-
 sound/i2c/other/wm8766.c |  374 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 536 insertions(+), 1 deletions(-)
 create mode 100644 include/sound/wm8766.h
 create mode 100644 sound/i2c/other/wm8766.c

diff --git a/include/sound/wm8766.h b/include/sound/wm8766.h
new file mode 100644
index 0000000..7d1df7f
--- /dev/null
+++ b/include/sound/wm8766.h
@@ -0,0 +1,160 @@
+#ifndef __SOUND_WM8766_H
+#define __SOUND_WM8766_H
+
+/*
+ *   ALSA driver for WM8766 codecs
+ *
+ *	Copyright (c) 2012 Ondrej Zary <linux@rainbow-software.org>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ */
+
+#define WM8766_REG_DACL1	0x00
+#define WM8766_REG_DACR1	0x01
+#define WM8766_VOL_MASK			0x1ff		/* incl. update bit */
+#define WM8766_VOL_UPDATE		(1 << 8)	/* update volume */
+#define WM8766_REG_DACCTRL1	0x02
+#define WM8766_DAC_MUTEALL		(1 << 0)
+#define WM8766_DAC_DEEMPALL		(1 << 1)
+#define WM8766_DAC_PDWN			(1 << 2)
+#define WM8766_DAC_ATC			(1 << 3)
+#define WM8766_DAC_IZD			(1 << 4)
+#define WM8766_DAC_PL_MASK		0x1e0
+#define WM8766_DAC_PL_LL		(1 << 5)	/* L chan: L signal */
+#define WM8766_DAC_PL_LR		(2 << 5)	/* L chan: R signal */
+#define WM8766_DAC_PL_LB		(3 << 5)	/* L chan: both */
+#define WM8766_DAC_PL_RL		(1 << 7)	/* R chan: L signal */
+#define WM8766_DAC_PL_RR		(2 << 7)	/* R chan: R signal */
+#define WM8766_DAC_PL_RB		(3 << 7)	/* R chan: both */
+#define WM8766_REG_IFCTRL	0x03
+#define WM8766_IF_FMT_RIGHTJ		(0 << 0)
+#define WM8766_IF_FMT_LEFTJ		(1 << 0)
+#define WM8766_IF_FMT_I2S		(2 << 0)
+#define WM8766_IF_FMT_DSP		(3 << 0)
+#define WM8766_IF_DSP_LATE		(1 << 2)	/* in DSP mode */
+#define WM8766_IF_LRC_INVERTED		(1 << 2)	/* in other modes */
+#define WM8766_IF_BCLK_INVERTED		(1 << 3)
+#define WM8766_IF_IWL_16BIT		(0 << 4)
+#define WM8766_IF_IWL_20BIT		(1 << 4)
+#define WM8766_IF_IWL_24BIT		(2 << 4)
+#define WM8766_IF_IWL_32BIT		(3 << 4)
+#define WM8766_IF_MASK			0x3f
+#define WM8766_PHASE_INVERT1		(1 << 6)
+#define WM8766_PHASE_INVERT2		(1 << 7)
+#define WM8766_PHASE_INVERT3		(1 << 8)
+#define WM8766_REG_DACL2	0x04
+#define WM8766_REG_DACR2	0x05
+#define WM8766_REG_DACL3	0x06
+#define WM8766_REG_DACR3	0x07
+#define WM8766_REG_MASTDA	0x08
+#define WM8766_REG_DACCTRL2	0x09
+#define WM8766_DAC2_ZCD			(1 << 0)
+#define WM8766_DAC2_ZFLAG_ALL		(0 << 1)
+#define WM8766_DAC2_ZFLAG_1		(1 << 1)
+#define WM8766_DAC2_ZFLAG_2		(2 << 1)
+#define WM8766_DAC2_ZFLAG_3		(3 << 1)
+#define WM8766_DAC2_MUTE1		(1 << 3)
+#define WM8766_DAC2_MUTE2		(1 << 4)
+#define WM8766_DAC2_MUTE3		(1 << 5)
+#define WM8766_DAC2_DEEMP1		(1 << 6)
+#define WM8766_DAC2_DEEMP2		(1 << 7)
+#define WM8766_DAC2_DEEMP3		(1 << 8)
+#define WM8766_REG_DACCTRL3	0x0a
+#define WM8766_DAC3_DACPD1		(1 << 1)
+#define WM8766_DAC3_DACPD2		(1 << 2)
+#define WM8766_DAC3_DACPD3		(1 << 3)
+#define WM8766_DAC3_PWRDNALL		(1 << 4)
+#define WM8766_DAC3_POWER_MASK		0x1e
+#define WM8766_DAC3_MASTER		(1 << 5)
+#define WM8766_DAC3_DAC128FS		(0 << 6)
+#define WM8766_DAC3_DAC192FS		(1 << 6)
+#define WM8766_DAC3_DAC256FS		(2 << 6)
+#define WM8766_DAC3_DAC384FS		(3 << 6)
+#define WM8766_DAC3_DAC512FS		(4 << 6)
+#define WM8766_DAC3_DAC768FS		(5 << 6)
+#define WM8766_DAC3_MSTR_MASK		0x1e0
+#define WM8766_REG_MUTE1	0x0c
+#define WM8766_MUTE1_MPD		(1 << 6)
+#define WM8766_REG_MUTE2	0x0f
+#define WM8766_MUTE2_MPD		(1 << 5)
+#define WM8766_REG_RESET	0x1f
+
+#define WM8766_REG_COUNT	0x10	/* don't cache the RESET register */
+
+struct snd_wm8766;
+
+struct snd_wm8766_ops {
+	void (*write)(struct snd_wm8766 *wm, u16 addr, u16 data);
+};
+
+enum snd_wm8766_ctl_id {
+	WM8766_CTL_CH1_VOL,
+	WM8766_CTL_CH2_VOL,
+	WM8766_CTL_CH3_VOL,
+	WM8766_CTL_CH1_SW,
+	WM8766_CTL_CH2_SW,
+	WM8766_CTL_CH3_SW,
+	WM8766_CTL_PHASE1_SW,
+	WM8766_CTL_PHASE2_SW,
+	WM8766_CTL_PHASE3_SW,
+	WM8766_CTL_DEEMPH1_SW,
+	WM8766_CTL_DEEMPH2_SW,
+	WM8766_CTL_DEEMPH3_SW,
+	WM8766_CTL_IZD_SW,
+	WM8766_CTL_ZC_SW,
+
+	WM8766_CTL_COUNT,
+};
+
+#define WM8766_ENUM_MAX		16
+
+#define WM8766_FLAG_STEREO	(1 << 0)
+#define WM8766_FLAG_VOL_UPDATE	(1 << 1)
+#define WM8766_FLAG_INVERT	(1 << 2)
+#define WM8766_FLAG_LIM		(1 << 3)
+#define WM8766_FLAG_ALC		(1 << 4)
+
+struct snd_wm8766_ctl {
+	struct snd_kcontrol *kctl;
+	char *name;
+	snd_ctl_elem_type_t type;
+	const char *const enum_names[WM8766_ENUM_MAX];
+	const unsigned int *tlv;
+	u16 reg1, reg2, mask1, mask2, min, max, flags;
+	void (*set)(struct snd_wm8766 *wm, u16 ch1, u16 ch2);
+	void (*get)(struct snd_wm8766 *wm, u16 *ch1, u16 *ch2);
+};
+
+enum snd_wm8766_agc_mode { WM8766_AGC_OFF, WM8766_AGC_LIM, WM8766_AGC_ALC };
+
+struct snd_wm8766 {
+	struct snd_card *card;
+	struct snd_wm8766_ctl ctl[WM8766_CTL_COUNT];
+	enum snd_wm8766_agc_mode agc_mode;
+	struct snd_wm8766_ops ops;
+	u16 regs[WM8766_REG_COUNT];	/* 9-bit registers */
+};
+
+
+
+void snd_wm8766_init(struct snd_wm8766 *wm);
+void snd_wm8766_set_if(struct snd_wm8766 *wm, u16 dac);
+void snd_wm8766_set_master_mode(struct snd_wm8766 *wm, u16 mode);
+void snd_wm8766_set_power(struct snd_wm8766 *wm, u16 power);
+void snd_wm8766_volume_restore(struct snd_wm8766 *wm);
+int snd_wm8766_build_controls(struct snd_wm8766 *wm);
+
+#endif /* __SOUND_WM8766_H */
diff --git a/sound/i2c/other/Makefile b/sound/i2c/other/Makefile
index c95d8f1..93406f7 100644
--- a/sound/i2c/other/Makefile
+++ b/sound/i2c/other/Makefile
@@ -9,9 +9,10 @@ snd-ak4113-objs := ak4113.o
 snd-ak4xxx-adda-objs := ak4xxx-adda.o
 snd-pt2258-objs := pt2258.o
 snd-tea575x-tuner-objs := tea575x-tuner.o
+snd-wm8766-objs := wm8766.o
 
 # Module Dependency
 obj-$(CONFIG_SND_PDAUDIOCF) += snd-ak4117.o
 obj-$(CONFIG_SND_ICE1712) += snd-ak4xxx-adda.o
-obj-$(CONFIG_SND_ICE1724) += snd-ak4114.o snd-ak4113.o snd-ak4xxx-adda.o snd-pt2258.o
+obj-$(CONFIG_SND_ICE1724) += snd-ak4114.o snd-ak4113.o snd-ak4xxx-adda.o snd-pt2258.o snd-wm8766.o
 obj-$(CONFIG_SND_TEA575X) += snd-tea575x-tuner.o
diff --git a/sound/i2c/other/wm8766.c b/sound/i2c/other/wm8766.c
new file mode 100644
index 0000000..deed3a3
--- /dev/null
+++ b/sound/i2c/other/wm8766.c
@@ -0,0 +1,374 @@
+/*
+ *   ALSA driver for WM8766 codecs
+ *
+ *	Copyright (c) 2012 Ondrej Zary <linux@rainbow-software.org>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <sound/control.h>
+#include <sound/tlv.h>
+#include <sound/wm8766.h>
+
+MODULE_AUTHOR("Ondrej Zary <linux@rainbow-software.org>");
+MODULE_DESCRIPTION("Routines for control of WM8766 codecs");
+MODULE_LICENSE("GPL");
+
+/* low-level access */
+
+void snd_wm8766_write(struct snd_wm8766 *wm, u16 addr, u16 data)
+{
+	if (addr < WM8766_REG_RESET)
+		wm->regs[addr] = data;
+	wm->ops.write(wm, addr, data);
+}
+
+/* mixer controls */
+
+static const DECLARE_TLV_DB_SCALE(wm8766_tlv, -12750, 50, 1);
+
+static struct snd_wm8766_ctl default_ctl[WM8766_CTL_COUNT] = {
+	[WM8766_CTL_CH1_VOL] = {
+		.name = "Channel 1 Playback Volume",
+		.type = SNDRV_CTL_ELEM_TYPE_INTEGER,
+		.tlv = wm8766_tlv,
+		.reg1 = WM8766_REG_DACL1,
+		.reg2 = WM8766_REG_DACR1,
+		.mask1 = WM8766_VOL_MASK,
+		.mask2 = WM8766_VOL_MASK,
+		.max = 0xff,
+		.flags = WM8766_FLAG_STEREO | WM8766_FLAG_VOL_UPDATE,
+	},
+	[WM8766_CTL_CH2_VOL] = {
+		.name = "Channel 2 Playback Volume",
+		.type = SNDRV_CTL_ELEM_TYPE_INTEGER,
+		.tlv = wm8766_tlv,
+		.reg1 = WM8766_REG_DACL2,
+		.reg2 = WM8766_REG_DACR2,
+		.mask1 = WM8766_VOL_MASK,
+		.mask2 = WM8766_VOL_MASK,
+		.max = 0xff,
+		.flags = WM8766_FLAG_STEREO | WM8766_FLAG_VOL_UPDATE,
+	},
+	[WM8766_CTL_CH3_VOL] = {
+		.name = "Channel 3 Playback Volume",
+		.type = SNDRV_CTL_ELEM_TYPE_INTEGER,
+		.tlv = wm8766_tlv,
+		.reg1 = WM8766_REG_DACL3,
+		.reg2 = WM8766_REG_DACR3,
+		.mask1 = WM8766_VOL_MASK,
+		.mask2 = WM8766_VOL_MASK,
+		.max = 0xff,
+		.flags = WM8766_FLAG_STEREO | WM8766_FLAG_VOL_UPDATE,
+	},
+	[WM8766_CTL_CH1_SW] = {
+		.name = "Channel 1 Playback Switch",
+		.type = SNDRV_CTL_ELEM_TYPE_BOOLEAN,
+		.reg1 = WM8766_REG_DACCTRL2,
+		.mask1 = WM8766_DAC2_MUTE1,
+		.flags = WM8766_FLAG_INVERT,
+	},
+	[WM8766_CTL_CH2_SW] = {
+		.name = "Channel 2 Playback Switch",
+		.type = SNDRV_CTL_ELEM_TYPE_BOOLEAN,
+		.reg1 = WM8766_REG_DACCTRL2,
+		.mask1 = WM8766_DAC2_MUTE2,
+		.flags = WM8766_FLAG_INVERT,
+	},
+	[WM8766_CTL_CH3_SW] = {
+		.name = "Channel 3 Playback Switch",
+		.type = SNDRV_CTL_ELEM_TYPE_BOOLEAN,
+		.reg1 = WM8766_REG_DACCTRL2,
+		.mask1 = WM8766_DAC2_MUTE3,
+		.flags = WM8766_FLAG_INVERT,
+	},
+	[WM8766_CTL_PHASE1_SW] = {
+		.name = "Channel 1 Phase Invert Playback Switch",
+		.type = SNDRV_CTL_ELEM_TYPE_BOOLEAN,
+		.reg1 = WM8766_REG_IFCTRL,
+		.mask1 = WM8766_PHASE_INVERT1,
+	},
+	[WM8766_CTL_PHASE2_SW] = {
+		.name = "Channel 2 Phase Invert Playback Switch",
+		.type = SNDRV_CTL_ELEM_TYPE_BOOLEAN,
+		.reg1 = WM8766_REG_IFCTRL,
+		.mask1 = WM8766_PHASE_INVERT2,
+	},
+	[WM8766_CTL_PHASE3_SW] = {
+		.name = "Channel 3 Phase Invert Playback Switch",
+		.type = SNDRV_CTL_ELEM_TYPE_BOOLEAN,
+		.reg1 = WM8766_REG_IFCTRL,
+		.mask1 = WM8766_PHASE_INVERT3,
+	},
+	[WM8766_CTL_DEEMPH1_SW] = {
+		.name = "Channel 1 Deemphasis Playback Switch",
+		.type = SNDRV_CTL_ELEM_TYPE_BOOLEAN,
+		.reg1 = WM8766_REG_DACCTRL2,
+		.mask1 = WM8766_DAC2_DEEMP1,
+	},
+	[WM8766_CTL_DEEMPH2_SW] = {
+		.name = "Channel 2 Deemphasis Playback Switch",
+		.type = SNDRV_CTL_ELEM_TYPE_BOOLEAN,
+		.reg1 = WM8766_REG_DACCTRL2,
+		.mask1 = WM8766_DAC2_DEEMP2,
+	},
+	[WM8766_CTL_DEEMPH3_SW] = {
+		.name = "Channel 3 Deemphasis Playback Switch",
+		.type = SNDRV_CTL_ELEM_TYPE_BOOLEAN,
+		.reg1 = WM8766_REG_DACCTRL2,
+		.mask1 = WM8766_DAC2_DEEMP3,
+	},
+	[WM8766_CTL_IZD_SW] = {
+		.name = "Infinite Zero Detect Playback Switch",
+		.type = SNDRV_CTL_ELEM_TYPE_BOOLEAN,
+		.reg1 = WM8766_REG_DACCTRL1,
+		.mask1 = WM8766_DAC_IZD,
+	},
+	[WM8766_CTL_ZC_SW] = {
+		.name = "Zero Cross Detect Playback Switch",
+		.type = SNDRV_CTL_ELEM_TYPE_BOOLEAN,
+		.reg1 = WM8766_REG_DACCTRL2,
+		.mask1 = WM8766_DAC2_ZCD,
+		.flags = WM8766_FLAG_INVERT,
+	},
+};
+
+/* exported functions */
+
+void snd_wm8766_init(struct snd_wm8766 *wm)
+{
+	int i;
+	static const u16 default_values[] = {
+		0x000, 0x100,
+		0x120, 0x000,
+		0x000, 0x100, 0x000, 0x100, 0x000,
+		0x000, 0x080,
+	};
+
+	memcpy(wm->ctl, default_ctl, sizeof(wm->ctl));
+
+	snd_wm8766_write(wm, WM8766_REG_RESET, 0x00); /* reset */
+	udelay(10);
+	/* load defaults */
+	for (i = 0; i < ARRAY_SIZE(default_values); i++)
+		snd_wm8766_write(wm, i, default_values[i]);
+}
+EXPORT_SYMBOL(snd_wm8766_init);
+
+void snd_wm8766_set_if(struct snd_wm8766 *wm, u16 dac)
+{
+	u16 val = wm->regs[WM8766_REG_IFCTRL] & ~WM8766_IF_MASK;
+
+	dac &= WM8766_IF_MASK;
+	snd_wm8766_write(wm, WM8766_REG_IFCTRL, val | dac);
+}
+EXPORT_SYMBOL(snd_wm8766_set_if);
+
+void snd_wm8766_set_master_mode(struct snd_wm8766 *wm, u16 mode)
+{
+	u16 val = wm->regs[WM8766_REG_DACCTRL3] & ~WM8766_DAC3_MSTR_MASK;
+
+	mode &= WM8766_DAC3_MSTR_MASK;
+	snd_wm8766_write(wm, WM8766_REG_DACCTRL3, val | mode);
+}
+EXPORT_SYMBOL(snd_wm8766_set_master_mode);
+
+void snd_wm8766_set_power(struct snd_wm8766 *wm, u16 power)
+{
+	u16 val = wm->regs[WM8766_REG_DACCTRL3] & ~WM8766_DAC3_POWER_MASK;
+
+	power &= WM8766_DAC3_POWER_MASK;
+	snd_wm8766_write(wm, WM8766_REG_DACCTRL3, val | power);
+}
+EXPORT_SYMBOL(snd_wm8766_set_power);
+
+void snd_wm8766_volume_restore(struct snd_wm8766 *wm)
+{
+	u16 val = wm->regs[WM8766_REG_DACR1];
+	/* restore volume after MCLK stopped */
+	snd_wm8766_write(wm, WM8766_REG_DACR1, val | WM8766_VOL_UPDATE);
+}
+EXPORT_SYMBOL(snd_wm8766_volume_restore);
+
+/* mixer callbacks */
+
+static int snd_wm8766_volume_info(struct snd_kcontrol *kcontrol,
+				   struct snd_ctl_elem_info *uinfo)
+{
+	struct snd_wm8766 *wm = snd_kcontrol_chip(kcontrol);
+	int n = kcontrol->private_value;
+
+	uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
+	uinfo->count = (wm->ctl[n].flags & WM8766_FLAG_STEREO) ? 2 : 1;
+	uinfo->value.integer.min = wm->ctl[n].min;
+	uinfo->value.integer.max = wm->ctl[n].max;
+
+	return 0;
+}
+
+static int snd_wm8766_enum_info(struct snd_kcontrol *kcontrol,
+				      struct snd_ctl_elem_info *uinfo)
+{
+	struct snd_wm8766 *wm = snd_kcontrol_chip(kcontrol);
+	int n = kcontrol->private_value;
+
+	return snd_ctl_enum_info(uinfo, 1, wm->ctl[n].max,
+						wm->ctl[n].enum_names);
+}
+
+static int snd_wm8766_ctl_get(struct snd_kcontrol *kcontrol,
+				  struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_wm8766 *wm = snd_kcontrol_chip(kcontrol);
+	int n = kcontrol->private_value;
+	u16 val1, val2;
+
+	if (wm->ctl[n].get)
+		wm->ctl[n].get(wm, &val1, &val2);
+	else {
+		val1 = wm->regs[wm->ctl[n].reg1] & wm->ctl[n].mask1;
+		val1 >>= __ffs(wm->ctl[n].mask1);
+		if (wm->ctl[n].flags & WM8766_FLAG_STEREO) {
+			val2 = wm->regs[wm->ctl[n].reg2] & wm->ctl[n].mask2;
+			val2 >>= __ffs(wm->ctl[n].mask2);
+			if (wm->ctl[n].flags & WM8766_FLAG_VOL_UPDATE)
+				val2 &= ~WM8766_VOL_UPDATE;
+		}
+	}
+	if (wm->ctl[n].flags & WM8766_FLAG_INVERT) {
+		val1 = wm->ctl[n].max - (val1 - wm->ctl[n].min);
+		val2 = wm->ctl[n].max - (val2 - wm->ctl[n].min);
+	}
+	ucontrol->value.integer.value[0] = val1;
+	if (wm->ctl[n].flags & WM8766_FLAG_STEREO)
+		ucontrol->value.integer.value[1] = val2;
+
+	return 0;
+}
+
+static int snd_wm8766_ctl_put(struct snd_kcontrol *kcontrol,
+				  struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_wm8766 *wm = snd_kcontrol_chip(kcontrol);
+	int n = kcontrol->private_value;
+	u16 val, regval1, regval2;
+
+	/* this also works for enum because value is an union */
+	regval1 = ucontrol->value.integer.value[0];
+	regval2 = ucontrol->value.integer.value[1];
+	if (wm->ctl[n].flags & WM8766_FLAG_INVERT) {
+		regval1 = wm->ctl[n].max - (regval1 - wm->ctl[n].min);
+		regval2 = wm->ctl[n].max - (regval2 - wm->ctl[n].min);
+	}
+	if (wm->ctl[n].set)
+		wm->ctl[n].set(wm, regval1, regval2);
+	else {
+		val = wm->regs[wm->ctl[n].reg1] & ~wm->ctl[n].mask1;
+		val |= regval1 << __ffs(wm->ctl[n].mask1);
+		/* both stereo controls in one register */
+		if (wm->ctl[n].flags & WM8766_FLAG_STEREO &&
+				wm->ctl[n].reg1 == wm->ctl[n].reg2) {
+			val &= ~wm->ctl[n].mask2;
+			val |= regval2 << __ffs(wm->ctl[n].mask2);
+		}
+		snd_wm8766_write(wm, wm->ctl[n].reg1, val);
+		/* stereo controls in different registers */
+		if (wm->ctl[n].flags & WM8766_FLAG_STEREO &&
+				wm->ctl[n].reg1 != wm->ctl[n].reg2) {
+			val = wm->regs[wm->ctl[n].reg2] & ~wm->ctl[n].mask2;
+			val |= regval2 << __ffs(wm->ctl[n].mask2);
+			if (wm->ctl[n].flags & WM8766_FLAG_VOL_UPDATE)
+				val |= WM8766_VOL_UPDATE;
+			snd_wm8766_write(wm, wm->ctl[n].reg2, val);
+		}
+	}
+
+	return 0;
+}
+
+int snd_wm8766_add_control(struct snd_wm8766 *wm, int num)
+{
+	struct snd_kcontrol_new cont;
+	struct snd_kcontrol *ctl;
+
+	memset(&cont, 0, sizeof(cont));
+	cont.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
+	cont.private_value = num;
+	cont.name = wm->ctl[num].name;
+	cont.access = SNDRV_CTL_ELEM_ACCESS_READWRITE;
+	if (wm->ctl[num].flags & WM8766_FLAG_LIM ||
+	    wm->ctl[num].flags & WM8766_FLAG_ALC)
+		cont.access |= SNDRV_CTL_ELEM_ACCESS_INACTIVE;
+	cont.tlv.p = NULL;
+	cont.get = snd_wm8766_ctl_get;
+	cont.put = snd_wm8766_ctl_put;
+
+	switch (wm->ctl[num].type) {
+	case SNDRV_CTL_ELEM_TYPE_INTEGER:
+		cont.info = snd_wm8766_volume_info;
+		cont.access |= SNDRV_CTL_ELEM_ACCESS_TLV_READ;
+		cont.tlv.p = wm->ctl[num].tlv;
+		break;
+	case SNDRV_CTL_ELEM_TYPE_BOOLEAN:
+		wm->ctl[num].max = 1;
+		if (wm->ctl[num].flags & WM8766_FLAG_STEREO)
+			cont.info = snd_ctl_boolean_stereo_info;
+		else
+			cont.info = snd_ctl_boolean_mono_info;
+		break;
+	case SNDRV_CTL_ELEM_TYPE_ENUMERATED:
+		cont.info = snd_wm8766_enum_info;
+		break;
+	default:
+		return -EINVAL;
+	}
+	ctl = snd_ctl_new1(&cont, wm);
+	if (!ctl)
+		return -ENOMEM;
+	wm->ctl[num].kctl = ctl;
+
+	return snd_ctl_add(wm->card, ctl);
+}
+
+int snd_wm8766_build_controls(struct snd_wm8766 *wm)
+{
+	int err, i;
+
+	for (i = 0; i < WM8766_CTL_COUNT; i++)
+		if (wm->ctl[i].name) {
+			err = snd_wm8766_add_control(wm, i);
+			if (err < 0)
+				return err;
+		}
+
+	return 0;
+}
+EXPORT_SYMBOL(snd_wm8766_build_controls);
+
+static int __init alsa_wm8766_module_init(void)
+{
+	return 0;
+}
+
+static void __exit alsa_wm8766_module_exit(void)
+{
+}
+
+module_init(alsa_wm8766_module_init)
+module_exit(alsa_wm8766_module_exit)
-- 
Ondrej Zary

