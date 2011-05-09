Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab1EIVjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:39:51 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:50004 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752937Ab1EIVju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:39:50 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Subject: [PATCH 2/3] es1968: convert TEA575x support to new interface
Date: Mon, 9 May 2011 23:39:37 +0200
User-Agent: KMail/1.9.10
Cc: linux-media@vger.kernel.org,
        "Kernel development list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105092339.42319.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common functions to access TEA575x tuner - remove original read/write
functions and provide new pin manipulation functions instead.

Tested with SF64-PCE2 card.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.39-rc2-/sound/pci/es1968.c	2011-05-06 22:46:24.000000000 +0200
+++ linux-2.6.39-rc2/sound/pci/es1968.c	2011-05-09 23:25:06.000000000 +0200
@@ -2591,96 +2591,48 @@ static int __devinit snd_es1968_input_re
 #define STR_WREN	0x0100 /* GPIO8 */
 #define STR_MOST	0x0200 /* GPIO9 */
 
-static void snd_es1968_tea575x_write(struct snd_tea575x *tea, unsigned int val)
+static void snd_es1968_tea575x_set_pins(struct snd_tea575x *tea, u8 pins)
 {
 	struct es1968 *chip = tea->private_data;
 	unsigned long io = chip->io_port + GPIO_DATA;
-	u16 l, bits;
-	u16 omask, odir;
+	u16 val = 0;
 
-	omask = inw(io + IO_MASK);
-	odir = (inw(io + IO_DIR) & ~STR_DATA) | (STR_CLK | STR_WREN);
-	outw(odir | STR_DATA, io + IO_DIR);
-	outw(~(STR_DATA | STR_CLK | STR_WREN), io + IO_MASK);
-	udelay(16);
-
-	for (l = 25; l; l--) {
-		bits = ((val >> 18) & STR_DATA) | STR_WREN;
-		val <<= 1;			/* shift data */
-		outw(bits, io);			/* start strobe */
-		udelay(2);
-		outw(bits | STR_CLK, io);	/* HI level */
-		udelay(2);
-		outw(bits, io);			/* LO level */
-		udelay(4);
-	}
-
-	if (!tea->mute)
-		outw(0, io);
+	val |= (pins & TEA575X_DATA) ? STR_DATA : 0;
+	val |= (pins & TEA575X_CLK)  ? STR_CLK  : 0;
+	val |= (pins & TEA575X_WREN) ? STR_WREN : 0;
 
-	udelay(4);
-	outw(omask, io + IO_MASK);
-	outw(odir, io + IO_DIR);
-	msleep(125);
+	outw(val, io);
 }
 
-static unsigned int snd_es1968_tea575x_read(struct snd_tea575x *tea)
+static u8 snd_es1968_tea575x_get_pins(struct snd_tea575x *tea)
 {
 	struct es1968 *chip = tea->private_data;
 	unsigned long io = chip->io_port + GPIO_DATA;
-	u16 l, rdata;
-	u32 data = 0;
-	u16 omask;
-
-	omask = inw(io + IO_MASK);
-	outw(~(STR_CLK | STR_WREN), io + IO_MASK);
-	outw(0, io);
-	udelay(16);
-
-	for (l = 24; l--;) {
-		outw(STR_CLK, io);		/* HI state */
-		udelay(2);
-		if (!l)
-			tea->tuned = inw(io) & STR_MOST ? 0 : 1;
-		outw(0, io);			/* LO state */
-		udelay(2);
-		data <<= 1;			/* shift data */
-		rdata = inw(io);
-		if (!l)
-			tea->stereo = (rdata & STR_MOST) ?  0 : 1;
-		else if (l && rdata & STR_DATA)
-			data++;
-		udelay(2);
-	}
+	u16 val = inw(io);
 
-	if (tea->mute)
-		outw(STR_WREN, io);
-
-	udelay(4);
-	outw(omask, io + IO_MASK);
-
-	return data & 0x3ffe;
+	return  (val & STR_DATA) ? TEA575X_DATA : 0 |
+		(val & STR_MOST) ? TEA575X_MOST : 0;
 }
 
-static void snd_es1968_tea575x_mute(struct snd_tea575x *tea, unsigned int mute)
+static void snd_es1968_tea575x_set_direction(struct snd_tea575x *tea, bool output)
 {
 	struct es1968 *chip = tea->private_data;
 	unsigned long io = chip->io_port + GPIO_DATA;
-	u16 omask;
+	u16 odir = inw(io + IO_DIR);
 
-	omask = inw(io + IO_MASK);
-	outw(~STR_WREN, io + IO_MASK);
-	tea->mute = mute;
-	outw(tea->mute ? STR_WREN : 0, io);
-	udelay(4);
-	outw(omask, io + IO_MASK);
-	msleep(125);
+	if (output) {
+		outw(~(STR_DATA | STR_CLK | STR_WREN), io + IO_MASK);
+		outw(odir | STR_DATA | STR_CLK | STR_WREN, io + IO_DIR);
+	} else {
+		outw(~(STR_CLK | STR_WREN | STR_DATA | STR_MOST), io + IO_MASK);
+		outw((odir & ~(STR_DATA | STR_MOST)) | STR_CLK | STR_WREN, io + IO_DIR);
+	}
 }
 
 static struct snd_tea575x_ops snd_es1968_tea_ops = {
-	.write = snd_es1968_tea575x_write,
-	.read  = snd_es1968_tea575x_read,
-	.mute  = snd_es1968_tea575x_mute,
+	.set_pins = snd_es1968_tea575x_set_pins,
+	.get_pins = snd_es1968_tea575x_get_pins,
+	.set_direction = snd_es1968_tea575x_set_direction,
 };
 #endif
 
@@ -2845,7 +2797,8 @@ static int __devinit snd_es1968_create(s
 	chip->tea.freq_fixup = 10700;
 	chip->tea.private_data = chip;
 	chip->tea.ops = &snd_es1968_tea_ops;
-	snd_tea575x_init(&chip->tea);
+	if (!snd_tea575x_init(&chip->tea))
+		printk(KERN_INFO "es1968: detected TEA575x radio\n");
 #endif
 
 	*chip_ret = chip;


-- 
Ondrej Zary
