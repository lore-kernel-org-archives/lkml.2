Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab1CSPd1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 11:33:27 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:58186 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754237Ab1CSPdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 11:33:23 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: [RFC PATCH 3/3] es1968: add radio (tea575x tuner) support
Date: Sat, 19 Mar 2011 16:33:14 +0100
User-Agent: KMail/1.9.10
Cc: "Takashi Iwai" <tiwai@suse.de>, jirislaby@gmail.com,
        alsa-devel@alsa-project.org,
        "Kernel development list" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
References: <201103121919.05657.linux@rainbow-software.org> <201103141128.01259.linux@rainbow-software.org> <33b29bfb135fbe2ddcba88d342d67526.squirrel@webmail.xs4all.nl>
In-Reply-To: <33b29bfb135fbe2ddcba88d342d67526.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103191633.17611.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add TEA5757 radio tuner support to es1968 driver. This is found at least on 
MediaForte SF64-PCE2 sound cards.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

diff -urp linux-2.6.38-rc4-orig/sound/pci/es1968.c linux-2.6.38-rc4/sound/pci/es1968.c
--- linux-2.6.38-rc4-orig/sound/pci/es1968.c	2011-02-08 01:03:55.000000000 +0100
+++ linux-2.6.38-rc4/sound/pci/es1968.c	2011-03-18 22:51:48.000000000 +0100
@@ -112,6 +112,10 @@
 #include <sound/ac97_codec.h>
 #include <sound/initval.h>
 
+#ifdef CONFIG_SND_ES1968_RADIO
+#include <sound/tea575x-tuner.h>
+#endif
+
 #define CARD_NAME "ESS Maestro1/2"
 #define DRIVER_NAME "ES1968"
 
@@ -553,6 +557,10 @@ struct es1968 {
 	spinlock_t ac97_lock;
 	struct tasklet_struct hwvol_tq;
 #endif
+
+#ifdef CONFIG_SND_ES1968_RADIO
+	struct snd_tea575x tea;
+#endif
 };
 
 static irqreturn_t snd_es1968_interrupt(int irq, void *dev_id);
@@ -2571,6 +2579,111 @@ static int __devinit snd_es1968_input_re
 }
 #endif /* CONFIG_SND_ES1968_INPUT */
 
+#ifdef CONFIG_SND_ES1968_RADIO
+#define GPIO_DATA	0x60
+#define IO_MASK		4      /* mask      register offset from GPIO_DATA
+				bits 1=unmask write to given bit */
+#define IO_DIR		8      /* direction register offset from GPIO_DATA
+				bits 0/1=read/write direction */
+/* mask bits for GPIO lines */
+#define STR_DATA	0x0040 /* GPIO6 */
+#define STR_CLK		0x0080 /* GPIO7 */
+#define STR_WREN	0x0100 /* GPIO8 */
+#define STR_MOST	0x0200 /* GPIO9 */
+
+static void snd_es1968_tea575x_write(struct snd_tea575x *tea, unsigned int val)
+{
+	struct es1968 *chip = tea->private_data;
+	unsigned long io = chip->io_port + GPIO_DATA;
+	u16 l, bits;
+	u16 omask, odir;
+
+	omask = inw(io + IO_MASK);
+	odir = (inw(io + IO_DIR) & ~STR_DATA) | (STR_CLK | STR_WREN);
+	outw(odir | STR_DATA, io + IO_DIR);
+	outw(~(STR_DATA | STR_CLK | STR_WREN), io + IO_MASK);
+	udelay(16);
+
+	for (l = 25; l; l--) {
+		bits = ((val >> 18) & STR_DATA) | STR_WREN;
+		val <<= 1;			/* shift data */
+		outw(bits, io);			/* start strobe */
+		udelay(2);
+		outw(bits | STR_CLK, io);	/* HI level */
+		udelay(2);
+		outw(bits, io);			/* LO level */
+		udelay(4);
+	}
+
+	if (!tea->mute)
+		outw(0, io);
+
+	udelay(4);
+	outw(omask, io + IO_MASK);
+	outw(odir, io + IO_DIR);
+	msleep(125);
+}
+
+static unsigned int snd_es1968_tea575x_read(struct snd_tea575x *tea)
+{
+	struct es1968 *chip = tea->private_data;
+	unsigned long io = chip->io_port + GPIO_DATA;
+	u16 l, rdata;
+	u32 data = 0;
+	u16 omask;
+
+	omask = inw(io + IO_MASK);
+	outw(~(STR_CLK | STR_WREN), io + IO_MASK);
+	outw(0, io);
+	udelay(16);
+
+	for (l = 24; l--;) {
+		outw(STR_CLK, io);		/* HI state */
+		udelay(2);
+		if (!l)
+			tea->tuned = inw(io) & STR_MOST ? 0 : 1;
+		outw(0, io);			/* LO state */
+		udelay(2);
+		data <<= 1;			/* shift data */
+		rdata = inw(io);
+		if (!l)
+			tea->stereo = (rdata & STR_MOST) ?  0 : 1;
+		else if (l && rdata & STR_DATA)
+			data++;
+		udelay(2);
+	}
+
+	if (tea->mute)
+		outw(STR_WREN, io);
+
+	udelay(4);
+	outw(omask, io + IO_MASK);
+
+	return data & 0x3ffe;
+}
+
+static void snd_es1968_tea575x_mute(struct snd_tea575x *tea, unsigned int mute)
+{
+	struct es1968 *chip = tea->private_data;
+	unsigned long io = chip->io_port + GPIO_DATA;
+	u16 omask;
+
+	omask = inw(io + IO_MASK);
+	outw(~STR_WREN, io + IO_MASK);
+	tea->mute = mute;
+	outw(tea->mute ? STR_WREN : 0, io);
+	udelay(4);
+	outw(omask, io + IO_MASK);
+	msleep(125);
+}
+
+static struct snd_tea575x_ops snd_es1968_tea_ops = {
+	.write = snd_es1968_tea575x_write,
+	.read  = snd_es1968_tea575x_read,
+	.mute  = snd_es1968_tea575x_mute,
+};
+#endif
+
 static int snd_es1968_free(struct es1968 *chip)
 {
 #ifdef CONFIG_SND_ES1968_INPUT
@@ -2585,6 +2698,10 @@ static int snd_es1968_free(struct es1968
 		outw(0, chip->io_port + ESM_PORT_HOST_IRQ); /* disable IRQ */
 	}
 
+#ifdef CONFIG_SND_ES1968_RADIO
+	snd_tea575x_exit(&chip->tea);
+#endif
+
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
 	snd_es1968_free_gameport(chip);
@@ -2723,6 +2840,14 @@ static int __devinit snd_es1968_create(s
 
 	snd_card_set_dev(card, &pci->dev);
 
+#ifdef CONFIG_SND_ES1968_RADIO
+	chip->tea.card = card;
+	chip->tea.freq_fixup = 10700;
+	chip->tea.private_data = chip;
+	chip->tea.ops = &snd_es1968_tea_ops;
+	snd_tea575x_init(&chip->tea);
+#endif
+
 	*chip_ret = chip;
 
 	return 0;
diff -urp linux-2.6.38-rc4-orig/sound/pci/Kconfig linux-2.6.38-rc4/sound/pci/Kconfig
--- linux-2.6.38-rc4-orig/sound/pci/Kconfig	2011-02-08 01:03:55.000000000 +0100
+++ linux-2.6.38-rc4/sound/pci/Kconfig	2011-03-13 00:01:26.000000000 +0100
@@ -528,6 +528,14 @@ config SND_ES1968_INPUT
 	  If you say N the buttons will directly control the master volume.
 	  It is recommended to say Y.
 
+config SND_ES1968_RADIO
+	bool "Enable TEA5757 radio tuner support for es1968"
+	depends on SND_ES1968
+	depends on VIDEO_V4L2=y || VIDEO_V4L2=SND_ES1968
+	help
+	  Say Y here to include support for TEA5757 radio tuner integrated on
+	  some MediaForte cards (e.g. SF64-PCE2).
+
 config SND_FM801
 	tristate "ForteMedia FM801"
 	select SND_OPL3_LIB
@@ -549,10 +557,10 @@ config SND_FM801_TEA575X_BOOL
 	  FM801 chip with a TEA5757 tuner connected to GPIO1-3 pins (Media
 	  Forte SF256-PCS-02) into the snd-fm801 driver.
 
-config SND_FM801_TEA575X
+config SND_TEA575X
 	tristate
-	depends on SND_FM801_TEA575X_BOOL
-	default SND_FM801
+	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO
+	default SND_FM801 || SND_ES1968
 
 source "sound/pci/hda/Kconfig"
 
diff -urp linux-2.6.38-rc4-orig/sound/i2c/other/Makefile linux-2.6.38-rc4/sound/i2c/other/Makefile
--- linux-2.6.38-rc4-orig/sound/i2c/other/Makefile	2011-02-08 01:03:55.000000000 +0100
+++ linux-2.6.38-rc4/sound/i2c/other/Makefile	2011-03-12 23:59:37.000000000 +0100
@@ -14,4 +14,4 @@ snd-tea575x-tuner-objs := tea575x-tuner.
 obj-$(CONFIG_SND_PDAUDIOCF) += snd-ak4117.o
 obj-$(CONFIG_SND_ICE1712) += snd-ak4xxx-adda.o
 obj-$(CONFIG_SND_ICE1724) += snd-ak4114.o snd-ak4113.o snd-ak4xxx-adda.o snd-pt2258.o
-obj-$(CONFIG_SND_FM801_TEA575X) += snd-tea575x-tuner.o
+obj-$(CONFIG_SND_TEA575X) += snd-tea575x-tuner.o


-- 
Ondrej Zary
