Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2DATov (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 15:44:51 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:49359 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752653Ab2DATot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 15:44:49 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Subject: Re: [BAD PATCH] ice1712: Add support for Philips PSC724 Ultimate Edge
Date: Sun, 1 Apr 2012 21:44:25 +0200
User-Agent: KMail/1.9.10
Cc: Kernel development list <linux-kernel@vger.kernel.org>
References: <201203132159.19733.linux@rainbow-software.org> <201203210003.47518.linux@rainbow-software.org>
In-Reply-To: <201203210003.47518.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201204012144.28779.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 March 2012 00:03:42 Ondrej Zary wrote:
> On Tuesday 13 March 2012 21:59:16 Ondrej Zary wrote:
> > Hello,
> > I'm trying do implement support for Philips PSC724 Ultimate Edge card,
> > which is based on VT1722 + WM8776 + WM8766 chips. I've examined the
> > connections and commented them in the code. The patch is heavily based on
> > se.c.
> >
> > When trying to play a sound, the player runs but no sound comes from the
> > output, no matter what I do with alsamixer.
> >
> > The interesting thing is that recording works - I can record something
> > from e.g. line-in and play it on another machine. Recording source
> > selection in alsamixer works too (if line-in is deselected, only silence
> > is recorded). So WM8776 I2C control works.
> >
> > I'm missing something but don't know what. Any ideas?
>
> I've missed a mute-all circuit (which grounds all outputs) controlled by
> GPIO22. Now the driver works - front, rear and center/lfe outputs.
> TODO:
>  - support headphone output
>  - move WM8776 and WM8766 code out
>

New version again, this time with headphone output support.
Including (simple and broken) headphone jack detection (using GPIO14).


diff --git a/sound/pci/ice1712/Makefile b/sound/pci/ice1712/Makefile
index f7ce33f..6d6ae06 100644
--- a/sound/pci/ice1712/Makefile
+++ b/sound/pci/ice1712/Makefile
@@ -5,7 +5,7 @@
 
 snd-ice17xx-ak4xxx-objs := ak4xxx.o
 snd-ice1712-objs := ice1712.o delta.o hoontech.o ews.o
-snd-ice1724-objs := ice1724.o amp.o revo.o aureon.o vt1720_mobo.o pontis.o prodigy192.o prodigy_hifi.o juli.o phase.o wtm.o se.o maya44.o quartet.o
+snd-ice1724-objs := ice1724.o amp.o revo.o aureon.o vt1720_mobo.o pontis.o prodigy192.o prodigy_hifi.o juli.o phase.o wtm.o se.o maya44.o quartet.o psc724.o
 
 # Toplevel Module Dependency
 obj-$(CONFIG_SND_ICE1712) += snd-ice1712.o snd-ice17xx-ak4xxx.o
diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index 9236297..d19db09 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -54,6 +54,7 @@
 #include "wtm.h"
 #include "se.h"
 #include "quartet.h"
+#include "psc724.h"
 
 MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
 MODULE_DESCRIPTION("VIA ICEnsemble ICE1724/1720 (Envy24HT/PT)");
@@ -2234,6 +2235,7 @@ static struct snd_ice1712_card_info *card_tables[] __devinitdata = {
 	snd_vt1724_se_cards,
 	snd_vt1724_qtet_cards,
 	snd_vt1724_ooaoo_cards,
+	snd_vt1724_psc724_cards,
 	NULL,
 };
 
@@ -2348,7 +2350,7 @@ static int __devinit snd_vt1724_read_eeprom(struct snd_ice1712 *ice,
 		return -EIO;
 	}
 	ice->eeprom.version = snd_vt1724_read_i2c(ice, dev, 0x05);
-	if (ice->eeprom.version != 2)
+	if (ice->eeprom.version != 1 && ice->eeprom.version != 2)
 		printk(KERN_WARNING "ice1724: Invalid EEPROM version %i\n",
 		       ice->eeprom.version);
 	size = ice->eeprom.size - 6;
diff --git a/sound/pci/ice1712/psc724.c b/sound/pci/ice1712/psc724.c
new file mode 100644
index 0000000..2903af3
--- /dev/null
+++ b/sound/pci/ice1712/psc724.c
@@ -0,0 +1,755 @@
+/*
+ *   ALSA driver for ICEnsemble VT1724 (Envy24HT)
+ *
+ *   Lowlevel functions for Philips PSC724 Ultimate Edge
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
+#include <asm/io.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <sound/core.h>
+#include <sound/tlv.h>
+
+#include "ice1712.h"
+#include "envy24ht.h"
+#include "psc724.h"
+
+struct psc724_spec {
+	struct {
+		unsigned char ch1, ch2;
+	} vol[10];
+	struct snd_ice1712 *ice;
+	struct delayed_work hp_work;
+	bool hp_connected;
+};
+
+/****************************************************************************/
+/*  PHILIPS PSC724 ULTIMATE EDGE                                            */
+/****************************************************************************/
+/*
+ *  VT1722 (Envy24GT) - 6 outputs, 4 inputs (only 2 used), 24-bit/96kHz
+ *
+ *  system configuration ICE_EEP2_SYSCONF=0x42
+ *    XIN1 49.152MHz
+ *    no MPU401
+ *    one stereo ADC, no S/PDIF receiver
+ *    three stereo DACs (FRONT, REAR, CENTER+LFE)
+ *
+ *  AC-Link configuration ICE_EEP2_ACLINK=0x80
+ *    use I2S, not AC97
+ *
+ *  I2S converters feature ICE_EEP2_I2S=0x30
+ *    I2S codec has no volume/mute control feature
+ *    I2S codec does not support 96KHz or 192KHz(bug!)
+ *    I2S codec 24bits
+ *
+ *  S/PDIF configuration ICE_EEP2_SPDIF=0xc1
+ *    Enable integrated S/PDIF transmitter
+ *    internal S/PDIF out implemented
+ *    No S/PDIF input
+ *    External S/PDIF out implemented
+ *
+ *
+ * ** connected chips **
+ *
+ *  WM8776
+ *     2-channel DAC used for main output and stereo ADC (with 10-channel MUX)
+ *     AIN1: LINE IN, AIN2: CD/VIDEO, AIN3: AUX, AIN4: Front MIC, AIN5: Rear MIC
+ *     Controlled by I2C using VT1722 I2C interface:
+ *          MODE (pin16) -- GND
+ *          CE   (pin17) -- GND  I2C mode (address=0x34)
+ *          DI   (pin18) -- SDA  (VT1722 pin70)
+ *          CL   (pin19) -- SCLK (VT1722 pin71)
+ *
+ *  WM8766
+ *      6-channel DAC used for rear & center/LFE outputs (only 4 channels used)
+ *      Controlled by SPI using VT1722 GPIO pins:
+ *          MODE   (pin 1) -- GPIO19 (VT1722 pin99)
+ *          ML/I2S (pin11) -- GPIO18 (VT1722 pin98)
+ *          MC/IWL (pin12) -- GPIO17 (VT1722 pin97)
+ *          MD/DM  (pin13) -- GPIO16 (VT1722 pin96)
+ *          MUTE   (pin14) -- GPIO20 (VT1722 pin101)
+ *
+ *  GPIO14 is used as input for headphone jack detection (1 = connected)
+ *  GPIO22 is used as MUTE ALL output, grounding all 6 channels
+ *
+ * ** output pins and device names **
+ *
+ *   7.1ch name -- output connector color -- device (-D option)
+ *
+ *      FRONT 2ch                  -- green  -- plughw:0,0
+ *      CENTER(Lch) SUBWOOFER(Rch) -- orange -- plughw:0,2,0
+ *      REAR 2ch                   -- black  -- plughw:0,2,1
+ *
+ */
+
+#define GPIO_HP_JACK	(1 << 14)
+#define GPIO_MUTE_SUR	(1 << 20)
+#define GPIO_MUTE_ALL	(1 << 22)
+
+/****************************************************************************/
+/*  WM8766 interface                                                        */
+/****************************************************************************/
+
+static void psc724_WM8766_write(struct snd_ice1712 *ice,
+					unsigned int addr, unsigned int data)
+{
+	unsigned int st;
+	unsigned int bits;
+	int i;
+	const unsigned int DATA  = 0x010000;
+	const unsigned int CLOCK = 0x020000;
+	const unsigned int LOAD  = 0x040000;
+	const unsigned int ALL_MASK = (DATA | CLOCK | LOAD);
+
+	snd_ice1712_save_gpio_status(ice);
+
+	st = ((addr & 0x7f) << 9) | (data & 0x1ff);
+	snd_ice1712_gpio_set_dir(ice, ice->gpio.direction | ALL_MASK);
+	snd_ice1712_gpio_set_mask(ice, ice->gpio.write_mask & ~ALL_MASK);
+	bits = snd_ice1712_gpio_read(ice) & ~ALL_MASK;
+
+	snd_ice1712_gpio_write(ice, bits);
+	for (i = 0; i < 16; i++) {
+		udelay(1);
+		bits &= ~CLOCK;
+		st = (st << 1);
+		if (st & 0x10000)
+			bits |= DATA;
+		else
+			bits &= ~DATA;
+
+		snd_ice1712_gpio_write(ice, bits);
+
+		udelay(1);
+		bits |= CLOCK;
+		snd_ice1712_gpio_write(ice, bits);
+	}
+
+	udelay(1);
+	bits |= LOAD;
+	snd_ice1712_gpio_write(ice, bits);
+
+	udelay(1);
+	bits |= (DATA | CLOCK);
+	snd_ice1712_gpio_write(ice, bits);
+
+	snd_ice1712_restore_gpio_status(ice);
+}
+
+static void psc724_WM8766_set_volume(struct snd_ice1712 *ice, int ch,
+					unsigned int vol1, unsigned int vol2)
+{
+	switch (ch) {
+	case 0:
+		psc724_WM8766_write(ice, 0x000, vol1);
+		psc724_WM8766_write(ice, 0x001, vol2 | 0x100);
+		break;
+	case 1:
+		psc724_WM8766_write(ice, 0x004, vol1);
+		psc724_WM8766_write(ice, 0x005, vol2 | 0x100);
+		break;
+	case 2:
+		psc724_WM8766_write(ice, 0x006, vol1);
+		psc724_WM8766_write(ice, 0x007, vol2 | 0x100);
+		break;
+	}
+}
+
+static void __devinit psc724_WM8766_init(struct snd_ice1712 *ice)
+{
+	psc724_WM8766_write(ice, 0x1f, 0x000); /* RESET ALL */
+	udelay(10);
+
+	psc724_WM8766_set_volume(ice, 0, 0, 0); /* volume L=0 R=0 */
+	psc724_WM8766_set_volume(ice, 1, 0, 0); /* volume L=0 R=0 */
+	psc724_WM8766_set_volume(ice, 2, 0, 0); /* volume L=0 R=0 */
+
+	psc724_WM8766_write(ice, 0x03, 0x022); /* serial mode I2S-24bits */
+	psc724_WM8766_write(ice, 0x0a, 0x080); /* MCLK=256fs */
+	psc724_WM8766_write(ice, 0x12, 0x000); /* MDP=0 */
+	psc724_WM8766_write(ice, 0x15, 0x000); /* MDP=0 */
+	psc724_WM8766_write(ice, 0x09, 0x000); /* demp=off mute=off */
+
+	psc724_WM8766_write(ice, 0x02, 0x124); /* ch-assign L=L R=R RESET */
+	psc724_WM8766_write(ice, 0x02, 0x120); /* ch-assign L=L R=R */
+}
+
+static void psc724_WM8766_set_pro_rate(struct snd_ice1712 *ice,
+					unsigned int rate)
+{
+	if (rate > 96000)
+		psc724_WM8766_write(ice, 0x0a, 0x000); /* MCLK=128fs */
+	else
+		psc724_WM8766_write(ice, 0x0a, 0x080); /* MCLK=256fs */
+}
+
+
+/****************************************************************************/
+/*  WM8776 interface                                                        */
+/****************************************************************************/
+
+static void psc724_WM8776_write(struct snd_ice1712 *ice,
+					unsigned int addr, unsigned int data)
+{
+	unsigned int val;
+
+	val = (addr << 9) | data;
+	snd_vt1724_write_i2c(ice, 0x34, val >> 8, val & 0xff);
+}
+
+
+static void psc724_WM8776_set_output_volume(struct snd_ice1712 *ice,
+					unsigned int vol1, unsigned int vol2)
+{
+	psc724_WM8776_write(ice, 0x03, vol1);
+	psc724_WM8776_write(ice, 0x04, vol2 | 0x100);
+}
+
+static void psc724_WM8776_set_input_volume(struct snd_ice1712 *ice,
+					unsigned int vol1, unsigned int vol2)
+{
+	psc724_WM8776_write(ice, 0x0e, vol1);
+	psc724_WM8776_write(ice, 0x0f, vol2 | 0x100);
+}
+
+static const char *psc724_sel[] = {
+	"LINE-IN", "CD-IN", "AUX-IN", "FRONT-MIC-IN", "REAR-MIC-IN", "ALL-MIX", NULL
+};
+
+static void psc724_WM8776_set_input_selector(struct snd_ice1712 *ice,
+					       unsigned int sel)
+{
+	static unsigned char vals[] = {
+		/* LINE, CD, AUX, FRONT-MIC, REAR-MIC, ALL, nothing */
+		0x01, 0x02, 0x04, 0x08, 0x10, 0x1f, 0x00
+	};
+	if (sel > 6)
+		sel = 6;
+	psc724_WM8776_write(ice, 0x15, vals[sel]);
+}
+
+static void psc724_WM8776_set_afl(struct snd_ice1712 *ice, unsigned int afl)
+{
+	/* AFL -- After Fader Listening */
+	if (afl)
+		psc724_WM8776_write(ice, 0x16, 0x005);
+	else
+		psc724_WM8776_write(ice, 0x16, 0x001);
+}
+
+static const char *psc724_agc[] = {
+	"Off", "LimiterMode", "ALCMode", NULL
+};
+
+static void psc724_WM8776_set_agc(struct snd_ice1712 *ice, unsigned int agc)
+{
+	/* AGC -- Auto Gain Control of the input */
+	switch (agc) {
+	case 0:
+		psc724_WM8776_write(ice, 0x11, 0x000); /* Off */
+		break;
+	case 1:
+		psc724_WM8776_write(ice, 0x10, 0x07b);
+		psc724_WM8776_write(ice, 0x11, 0x100); /* LimiterMode */
+		break;
+	case 2:
+		psc724_WM8776_write(ice, 0x10, 0x1fb);
+		psc724_WM8776_write(ice, 0x11, 0x100); /* ALCMode */
+		break;
+	}
+}
+
+static void psc724_WM8776_set_headphone_volume(struct snd_ice1712 *ice,
+					unsigned int vol1, unsigned int vol2)
+{
+	psc724_WM8776_write(ice, 0x00, vol1);
+	psc724_WM8776_write(ice, 0x01, vol2 | 0x100);
+}
+
+static void psc724_WM8776_set_headphone_mute(struct snd_ice1712 *ice,
+					unsigned int unmute)
+{
+	if (unmute)
+		psc724_WM8776_write(ice, 0x0d, 0);
+	else
+		psc724_WM8776_write(ice, 0x0d, 1 << 3);
+}
+
+static void psc724_set_mute_all(struct snd_ice1712 *ice, unsigned int unmute)
+{
+	unsigned int bits = snd_ice1712_gpio_read(ice);
+	if (unmute)
+		snd_ice1712_gpio_write(ice, bits & ~(GPIO_MUTE_ALL | GPIO_MUTE_SUR));
+	else
+		snd_ice1712_gpio_write(ice, bits | GPIO_MUTE_ALL | GPIO_MUTE_SUR);
+}
+
+
+static void __devinit psc724_WM8776_init(struct snd_ice1712 *ice)
+{
+	int i;
+	static unsigned short __devinitdata default_values[] = {
+		0x100, 0x100, 0x100,
+		0x100, 0x100, 0x100,
+		0x000, 0x090, 0x000, 0x000,
+		0x022, 0x022, 0x022,
+		0x008, 0x0cf, 0x0cf, 0x07b, 0x000,
+		0x032, 0x000, 0x0a6, 0x001, 0x001
+	};
+
+	psc724_WM8776_write(ice, 0x17, 0x000); /* reset all */
+	/* ADC and DAC interface is I2S 24bits mode */
+ 	/* The sample-rate are automatically changed */
+	udelay(10);
+	/* BUT my board can not do reset all, so I load all by manually. */
+	for (i = 0; i < ARRAY_SIZE(default_values); i++)
+		psc724_WM8776_write(ice, i, default_values[i]);
+
+	psc724_WM8776_set_input_selector(ice, 0);
+	psc724_WM8776_set_afl(ice, 0);
+	psc724_WM8776_set_agc(ice, 0);
+	psc724_WM8776_set_input_volume(ice, 0, 0);
+	psc724_WM8776_set_output_volume(ice, 0, 0);
+
+	/* head phone mute and power down */
+	psc724_WM8776_write(ice, 0x00, 0);
+	psc724_WM8776_write(ice, 0x01, 0);
+	psc724_WM8776_write(ice, 0x02, 0x100);
+	psc724_WM8776_write(ice, 0x0d, 0x080);
+}
+
+static void psc724_WM8776_set_pro_rate(struct snd_ice1712 *ice,
+						unsigned int rate)
+{
+	/* nothing to do */
+}
+
+
+/****************************************************************************/
+/*  runtime interface                                                       */
+/****************************************************************************/
+
+static void psc724_set_pro_rate(struct snd_ice1712 *ice, unsigned int rate)
+{
+	psc724_WM8766_set_pro_rate(ice, rate);
+	psc724_WM8776_set_pro_rate(ice, rate);
+}
+
+struct psc724_control {
+	char *name;
+	enum {
+		WM8766,
+		WM8776in,
+		WM8776out,
+		WM8776sel,
+		WM8776agc,
+		WM8776afl,
+		WM8776hp,
+		WM8776hpm,
+		mute_all
+	} target;
+	enum { VOLUME1, VOLUME2, BOOLEAN, ENUM } type;
+	int ch;
+	const char **member;
+	const char *comment;
+};
+
+static const struct psc724_control psc724_cont[] = {
+	{
+		.name = "Front Playback Volume",
+		.target = WM8776out,
+		.type = VOLUME1,
+		.comment = "Front(green)"
+	},
+	{
+		.name = "Surround Playback Volume",
+		.target = WM8766,
+		.type = VOLUME1,
+		.ch = 0,
+		.comment = "Surround(black)"
+	},
+	{
+		.name = "CLFE Playback Volume",
+		.target = WM8766,
+		.type = VOLUME1,
+		.ch = 1,
+		.comment = "Center(Lch)&SubWoofer(Rch)(orange)"
+	},
+	{
+		.name = "Headphone Playback Volume",
+		.target = WM8776hp,
+		.type = VOLUME1,
+		.comment = "Front panel"
+	},
+	{
+		.name = "Headphone Playback Switch",
+		.target = WM8776hpm,
+		.type = BOOLEAN
+	},
+	{
+		.name = "Capture Volume",
+		.target = WM8776in,
+		.type = VOLUME2
+	},
+	{
+		.name = "Capture Select",
+		.target = WM8776sel,
+		.type = ENUM,
+		.member = psc724_sel
+	},
+	{
+		.name = "AGC Capture Mode",
+		.target = WM8776agc,
+		.type = ENUM,
+		.member = psc724_agc
+	},
+	{
+		.name = "AFL Bypass Playback Switch",
+		.target = WM8776afl,
+		.type = BOOLEAN
+	},
+	{
+		.name = "Master Playback Switch",
+		.target = mute_all,
+		.type = BOOLEAN
+	}
+};
+
+static int psc724_get_enum_count(int n)
+{
+	const char **member;
+	int c;
+
+	member = psc724_cont[n].member;
+	if (!member)
+		return 0;
+	for (c = 0; member[c]; c++)
+		;
+	return c;
+}
+
+static int psc724_cont_volume_info(struct snd_kcontrol *kc,
+				     struct snd_ctl_elem_info *uinfo)
+{
+	uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
+	uinfo->count = 2;
+	uinfo->value.integer.min = 0; /* mute */
+	uinfo->value.integer.max = 0xff; /* 0dB */
+	return 0;
+}
+
+#define psc724_cont_boolean_info	snd_ctl_boolean_mono_info
+
+static int psc724_cont_enum_info(struct snd_kcontrol *kc,
+				   struct snd_ctl_elem_info *uinfo)
+{
+	int n, c;
+
+	n = kc->private_value;
+	c = psc724_get_enum_count(n);
+	if (!c)
+		return -EINVAL;
+	uinfo->type = SNDRV_CTL_ELEM_TYPE_ENUMERATED;
+	uinfo->count = 1;
+	uinfo->value.enumerated.items = c;
+	if (uinfo->value.enumerated.item >= c)
+		uinfo->value.enumerated.item = c - 1;
+	strcpy(uinfo->value.enumerated.name,
+	       psc724_cont[n].member[uinfo->value.enumerated.item]);
+	return 0;
+}
+
+static int psc724_cont_volume_get(struct snd_kcontrol *kc,
+				    struct snd_ctl_elem_value *uc)
+{
+	struct snd_ice1712 *ice = snd_kcontrol_chip(kc);
+	struct psc724_spec *spec = ice->spec;
+	int n = kc->private_value;
+	uc->value.integer.value[0] = spec->vol[n].ch1;
+	uc->value.integer.value[1] = spec->vol[n].ch2;
+	return 0;
+}
+
+static int psc724_cont_boolean_get(struct snd_kcontrol *kc,
+				     struct snd_ctl_elem_value *uc)
+{
+	struct snd_ice1712 *ice = snd_kcontrol_chip(kc);
+	struct psc724_spec *spec = ice->spec;
+	int n = kc->private_value;
+	uc->value.integer.value[0] = spec->vol[n].ch1;
+	return 0;
+}
+
+static int psc724_cont_enum_get(struct snd_kcontrol *kc,
+				  struct snd_ctl_elem_value *uc)
+{
+	struct snd_ice1712 *ice = snd_kcontrol_chip(kc);
+	struct psc724_spec *spec = ice->spec;
+	int n = kc->private_value;
+	uc->value.enumerated.item[0] = spec->vol[n].ch1;
+	return 0;
+}
+
+static void psc724_cont_update(struct snd_ice1712 *ice, int n)
+{
+	struct psc724_spec *spec = ice->spec;
+	switch (psc724_cont[n].target) {
+	case WM8766:
+		psc724_WM8766_set_volume(ice,
+					   psc724_cont[n].ch,
+					   spec->vol[n].ch1,
+					   spec->vol[n].ch2);
+		break;
+
+	case WM8776in:
+		psc724_WM8776_set_input_volume(ice,
+						 spec->vol[n].ch1,
+						 spec->vol[n].ch2);
+		break;
+
+	case WM8776out:
+		psc724_WM8776_set_output_volume(ice,
+						  spec->vol[n].ch1,
+						  spec->vol[n].ch2);
+		break;
+
+	case WM8776hp:
+		psc724_WM8776_set_headphone_volume(ice,
+						  spec->vol[n].ch1,
+						  spec->vol[n].ch2);
+		break;
+
+	case WM8776hpm:
+		psc724_WM8776_set_headphone_mute(ice, spec->vol[n].ch1);
+		break;
+
+	case WM8776sel:
+		psc724_WM8776_set_input_selector(ice, spec->vol[n].ch1);
+		break;
+
+	case WM8776agc:
+		psc724_WM8776_set_agc(ice, spec->vol[n].ch1);
+		break;
+
+	case WM8776afl:
+		psc724_WM8776_set_afl(ice, spec->vol[n].ch1);
+		break;
+	case mute_all:
+		psc724_set_mute_all(ice, spec->vol[n].ch1);
+		break;
+
+	default:
+		break;
+	}
+}
+
+static int psc724_cont_volume_put(struct snd_kcontrol *kc,
+				    struct snd_ctl_elem_value *uc)
+{
+	struct snd_ice1712 *ice = snd_kcontrol_chip(kc);
+	struct psc724_spec *spec = ice->spec;
+	int n = kc->private_value;
+	unsigned int vol1, vol2;
+	int changed;
+
+	changed = 0;
+	vol1 = uc->value.integer.value[0] & 0xff;
+	vol2 = uc->value.integer.value[1] & 0xff;
+	if (spec->vol[n].ch1 != vol1) {
+		spec->vol[n].ch1 = vol1;
+		changed = 1;
+	}
+	if (spec->vol[n].ch2 != vol2) {
+		spec->vol[n].ch2 = vol2;
+		changed = 1;
+	}
+	if (changed)
+		psc724_cont_update(ice, n);
+
+	return changed;
+}
+
+static int psc724_cont_boolean_put(struct snd_kcontrol *kc,
+				     struct snd_ctl_elem_value *uc)
+{
+	struct snd_ice1712 *ice = snd_kcontrol_chip(kc);
+	struct psc724_spec *spec = ice->spec;
+	int n = kc->private_value;
+	unsigned int vol1;
+
+	vol1 = !!uc->value.integer.value[0];
+	if (spec->vol[n].ch1 != vol1) {
+		spec->vol[n].ch1 = vol1;
+		psc724_cont_update(ice, n);
+		return 1;
+	}
+	return 0;
+}
+
+static int psc724_cont_enum_put(struct snd_kcontrol *kc,
+				  struct snd_ctl_elem_value *uc)
+{
+	struct snd_ice1712 *ice = snd_kcontrol_chip(kc);
+	struct psc724_spec *spec = ice->spec;
+	int n = kc->private_value;
+	unsigned int vol1;
+
+	vol1 = uc->value.enumerated.item[0];
+	if (vol1 >= psc724_get_enum_count(n))
+		return -EINVAL;
+	if (spec->vol[n].ch1 != vol1) {
+		spec->vol[n].ch1 = vol1;
+		psc724_cont_update(ice, n);
+		return 1;
+	}
+	return 0;
+}
+
+static const DECLARE_TLV_DB_SCALE(db_scale_gain1, -12750, 50, 1);
+static const DECLARE_TLV_DB_SCALE(db_scale_gain2, -10350, 50, 1);
+
+static int __devinit psc724_add_controls(struct snd_ice1712 *ice)
+{
+	int i;
+	struct snd_kcontrol_new cont;
+	int err;
+
+	memset(&cont, 0, sizeof(cont));
+	cont.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
+	for (i = 0; i < ARRAY_SIZE(psc724_cont); i++) {
+		cont.private_value = i;
+		cont.name = psc724_cont[i].name;
+		cont.access = SNDRV_CTL_ELEM_ACCESS_READWRITE;
+		cont.tlv.p = NULL;
+		switch (psc724_cont[i].type) {
+		case VOLUME1:
+		case VOLUME2:
+			cont.info = psc724_cont_volume_info;
+			cont.get = psc724_cont_volume_get;
+			cont.put = psc724_cont_volume_put;
+			cont.access |= SNDRV_CTL_ELEM_ACCESS_TLV_READ;
+			if (psc724_cont[i].type == VOLUME1)
+				cont.tlv.p = db_scale_gain1;
+			else
+				cont.tlv.p = db_scale_gain2;
+			break;
+		case BOOLEAN:
+			cont.info = psc724_cont_boolean_info;
+			cont.get = psc724_cont_boolean_get;
+			cont.put = psc724_cont_boolean_put;
+			break;
+		case ENUM:
+			cont.info = psc724_cont_enum_info;
+			cont.get = psc724_cont_enum_get;
+			cont.put = psc724_cont_enum_put;
+			break;
+		default:
+			snd_BUG();
+			return -EINVAL;
+		}
+		err = snd_ctl_add(ice->card, snd_ctl_new1(&cont, ice));
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+static void psc724_update_hp_jack_state(struct work_struct *work)
+{
+	struct psc724_spec *spec = container_of(work, struct psc724_spec,
+						hp_work.work);
+//	printk("spec=%p\n", spec);
+	struct snd_ice1712 *ice = spec->ice;
+//	printk("dacs=%d\n", ice->num_total_dacs);
+	bool hp_connected = snd_ice1712_gpio_read(ice) & GPIO_HP_JACK;
+//	printk("hp_connected=%d\n", hp_connected);
+	schedule_delayed_work(&spec->hp_work, msecs_to_jiffies(1000));
+
+	if (hp_connected == spec->hp_connected)
+		return;
+	if (hp_connected) {
+		psc724_set_mute_all(ice, 0);
+		psc724_WM8776_set_headphone_mute(ice, 1);
+	} else {
+		psc724_set_mute_all(ice, 1);
+		psc724_WM8776_set_headphone_mute(ice, 0);
+	}
+	spec->hp_connected = hp_connected;
+}
+
+/****************************************************************************/
+/*  probe/initialize/setup                                                  */
+/****************************************************************************/
+
+static int __devinit psc724_init(struct snd_ice1712 *ice)
+{
+	struct psc724_spec *spec;
+
+	spec = kzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return -ENOMEM;
+	ice->spec = spec;
+
+	ice->num_total_dacs = 6;
+	ice->num_total_adcs = 2;
+	psc724_WM8766_init(ice);
+	psc724_WM8776_init(ice);
+	ice->gpio.set_pro_rate = psc724_set_pro_rate;
+	spec->ice = ice;
+	INIT_DELAYED_WORK(&spec->hp_work, psc724_update_hp_jack_state);
+	schedule_delayed_work(&spec->hp_work, msecs_to_jiffies(1000));
+	return 0;
+}
+
+/* PSC724 has buggy EEPROM (no 96&192kHz, all FFh GPIOs), so override it here */
+static unsigned char psc724_eeprom[] __devinitdata = {
+	[ICE_EEP2_SYSCONF]	= 0x42,	/* 49.152MHz, 1 ADC, 3 DACs */
+	[ICE_EEP2_ACLINK]	= 0x80,	/* I2S */
+	[ICE_EEP2_I2S]		= 0xf0,	/* I2S volume, 96kHz, 24bit */
+	[ICE_EEP2_SPDIF]	= 0xc1,	/* spdif out-en, out-int, no input */
+
+	[ICE_EEP2_GPIO_DIR]	= 0x00, /* not used */
+	[ICE_EEP2_GPIO_DIR1]	= 0x00, /* not used */
+	[ICE_EEP2_GPIO_DIR2]	= 0x5f, /* MUTE_ALL, WM8766 MUTE/MODE/ML/MC/MD outputs */
+
+	[ICE_EEP2_GPIO_MASK]	= 0xff, /* read-only */
+	[ICE_EEP2_GPIO_MASK1]	= 0xff, /* read-only */
+	[ICE_EEP2_GPIO_MASK2]	= 0xa0, /* MUTE_ALL, WM8766 MUTE/MODE/ML/MC/MD writable */
+
+	[ICE_EEP2_GPIO_STATE2]	= 0x24,
+//	[ICE_EEP2_GPIO_STATE2]	= 0x5f, /* muted, all WM8766 pins high */
+};
+
+struct snd_ice1712_card_info snd_vt1724_psc724_cards[] __devinitdata = {
+	{
+		.subvendor = VT1724_SUBDEVICE_PSC724,
+		.name = "Philips PSC724 Ultimate Edge",
+		.model = "psc724",
+		.chip_init = psc724_init,
+		.build_controls = psc724_add_controls,
+		.eeprom_size = sizeof(psc724_eeprom),
+		.eeprom_data = psc724_eeprom,
+	},
+	{} /*terminator*/
+};
diff --git a/sound/pci/ice1712/psc724.h b/sound/pci/ice1712/psc724.h
new file mode 100644
index 0000000..858e5fd
--- /dev/null
+++ b/sound/pci/ice1712/psc724.h
@@ -0,0 +1,13 @@
+#ifndef __SOUND_PSC724_H
+#define __SOUND_PSC724_H
+
+/* ID */
+#define PSC724_DEVICE_DESC	\
+		"{Philips,PSC724 Ultimate Edge},"
+
+#define VT1724_SUBDEVICE_PSC724		0xab170619
+
+/* entry struct */
+extern struct snd_ice1712_card_info snd_vt1724_psc724_cards[];
+
+#endif /* __SOUND_PSC724_H */



-- 
Ondrej Zary
