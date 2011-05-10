Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab1EJVYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 17:24:30 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:51963 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752630Ab1EJVY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 17:24:28 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Subject: fm801: implement TEA575x tuner autodetection
Date: Tue, 10 May 2011 23:24:15 +0200
User-Agent: KMail/1.9.10
Cc: linux-media@vger.kernel.org,
        "Kernel development list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105102324.18562.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Autodetect TEA575x tuner connection type during init. This allows tuner to
work out-of-the box.

tea575x_tuner module parameter remains functional to force tuner type.

Tested with SF256-PCP and SF64-PCR.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.39-rc2-/sound/pci/fm801.c	2011-05-10 22:31:45.000000000 +0200
+++ linux-2.6.39-rc2/sound/pci/fm801.c	2011-05-10 23:21:42.000000000 +0200
@@ -53,7 +53,7 @@ static int enable[SNDRV_CARDS] = SNDRV_D
 /*
  *  Enable TEA575x tuner
  *    1 = MediaForte 256-PCS
- *    2 = MediaForte 256-PCPR
+ *    2 = MediaForte 256-PCP
  *    3 = MediaForte 64-PCR
  *   16 = setup tuner only (this is additional bit), i.e. SF64-PCR FM card
  *  High 16-bits are video (radio) device number + 1
@@ -67,7 +67,7 @@ MODULE_PARM_DESC(id, "ID string for the
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable FM801 soundcard.");
 module_param_array(tea575x_tuner, int, NULL, 0444);
-MODULE_PARM_DESC(tea575x_tuner, "TEA575x tuner access method (1 = SF256-PCS, 2=SF256-PCPR, 3=SF64-PCR, +16=tuner-only).");
+MODULE_PARM_DESC(tea575x_tuner, "TEA575x tuner access method (0 = auto, 1 = SF256-PCS, 2=SF256-PCP, 3=SF64-PCR, 8=disable, +16=tuner-only).");
 
 #define TUNER_ONLY		(1<<4)
 #define TUNER_TYPE_MASK		(~TUNER_ONLY & 0xFFFF)
@@ -720,12 +720,13 @@ static int __devinit snd_fm801_pcm(struc
 /* GPIO to TEA575x maps */
 struct snd_fm801_tea575x_gpio {
 	u8 data, clk, wren, most;
+	char *name;
 };
 
 static struct snd_fm801_tea575x_gpio snd_fm801_tea575x_gpios[] = {
-	{ .data = 1, .clk = 3, .wren = 2, .most = 0 },	/* SF256-PCS */
-	{ .data = 1, .clk = 0, .wren = 2, .most = 3 },	/* SF256-PCP */
-	{ .data = 2, .clk = 0, .wren = 1, .most = 3 },	/* SF64-PCR */
+	{ .data = 1, .clk = 3, .wren = 2, .most = 0, .name = "SF256-PCS" },
+	{ .data = 1, .clk = 0, .wren = 2, .most = 3, .name = "SF256-PCP" },
+	{ .data = 2, .clk = 0, .wren = 1, .most = 3, .name = "SF64-PCR" },
 };
 
 static void snd_fm801_tea575x_set_pins(struct snd_tea575x *tea, u8 pins)
@@ -1229,14 +1230,24 @@ static int __devinit snd_fm801_create(st
 	snd_card_set_dev(card, &pci->dev);
 
 #ifdef TEA575X_RADIO
+	chip->tea.card = card;
+	chip->tea.freq_fixup = 10700;
+	chip->tea.private_data = chip;
+	chip->tea.ops = &snd_fm801_tea_ops;
 	if ((tea575x_tuner & TUNER_TYPE_MASK) > 0 &&
 	    (tea575x_tuner & TUNER_TYPE_MASK) < 4) {
-		chip->tea.card = card;
-		chip->tea.freq_fixup = 10700;
-		chip->tea.private_data = chip;
-		chip->tea.ops = &snd_fm801_tea_ops;
-		snd_tea575x_init(&chip->tea);
-	}
+		if (snd_tea575x_init(&chip->tea))
+			snd_printk(KERN_ERR "TEA575x radio not found\n");
+	} else if ((tea575x_tuner & TUNER_TYPE_MASK) == 0)
+		/* autodetect tuner connection */
+		for (tea575x_tuner = 1; tea575x_tuner <= 3; tea575x_tuner++) {
+			chip->tea575x_tuner = tea575x_tuner;
+			if (!snd_tea575x_init(&chip->tea)) {
+				snd_printk(KERN_INFO "detected TEA575x radio type %s\n",
+					snd_fm801_tea575x_gpios[tea575x_tuner - 1].name);
+				break;
+			}
+		}
 #endif
 
 	*rchip = chip;


-- 
Ondrej Zary
