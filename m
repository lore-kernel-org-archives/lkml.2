Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab1ELUSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 16:18:10 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:60874 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757573Ab1ELUSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 16:18:08 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Subject: [PATCH 1/3] tea575x: remove freq_fixup from struct
Date: Thu, 12 May 2011 22:17:56 +0200
User-Agent: KMail/1.9.10
Cc: linux-media@vger.kernel.org,
        "Kernel development list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105122217.58872.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

freq_fixup is a constant, no need to hold it in struct snd_tea575x and set in
each driver.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.39-rc2-/include/sound/tea575x-tuner.h	2011-05-10 22:31:40.000000000 +0200
+++ linux-2.6.39-rc2/include/sound/tea575x-tuner.h	2011-05-12 21:00:50.000000000 +0200
@@ -26,6 +26,8 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
 
+#define TEA575X_FMIF	10700
+
 #define TEA575X_DATA	(1 << 0)
 #define TEA575X_CLK	(1 << 1)
 #define TEA575X_WREN	(1 << 2)
@@ -46,7 +48,6 @@ struct snd_tea575x {
 	bool mute;			/* Device is muted? */
 	bool stereo;			/* receiving stereo */
 	bool tuned;			/* tuned to a station */
-	unsigned int freq_fixup;	/* crystal onboard */
 	unsigned int val;		/* hw value */
 	unsigned long freq;		/* frequency */
 	unsigned long in_use;		/* set if the device is in use */
--- linux-2.6.39-rc2-/sound/i2c/other/tea575x-tuner.c	2011-05-10 22:31:40.000000000 +0200
+++ linux-2.6.39-rc2/sound/i2c/other/tea575x-tuner.c	2011-05-12 21:00:37.000000000 +0200
@@ -141,9 +141,9 @@ static void snd_tea575x_get_freq(struct
 	freq /= 10;
 	/* crystal fixup */
 	if (tea->tea5759)
-		freq += tea->freq_fixup;
+		freq += TEA575X_FMIF;
 	else
-		freq -= tea->freq_fixup;
+		freq -= TEA575X_FMIF;
 
 	tea->freq = freq * 16;		/* from kHz */
 }
@@ -156,9 +156,9 @@ static void snd_tea575x_set_freq(struct
 	freq /= 16;		/* to kHz */
 	/* crystal fixup */
 	if (tea->tea5759)
-		freq -= tea->freq_fixup;
+		freq -= TEA575X_FMIF;
 	else
-		freq += tea->freq_fixup;
+		freq += TEA575X_FMIF;
 	/* freq /= 12.5 */
 	freq *= 10;
 	freq /= 125;
--- linux-2.6.39-rc2-/sound/pci/es1968.c	2011-05-10 22:31:43.000000000 +0200
+++ linux-2.6.39-rc2/sound/pci/es1968.c	2011-05-10 23:47:32.000000000 +0200
@@ -2794,7 +2794,6 @@ static int __devinit snd_es1968_create(s
 
 #ifdef CONFIG_SND_ES1968_RADIO
 	chip->tea.card = card;
-	chip->tea.freq_fixup = 10700;
 	chip->tea.private_data = chip;
 	chip->tea.ops = &snd_es1968_tea_ops;
 	if (!snd_tea575x_init(&chip->tea))
--- linux-2.6.39-rc2-/sound/pci/fm801.c	2011-05-10 23:24:39.000000000 +0200
+++ linux-2.6.39-rc2/sound/pci/fm801.c	2011-05-10 23:47:43.000000000 +0200
@@ -1231,7 +1231,6 @@ static int __devinit snd_fm801_create(st
 
 #ifdef TEA575X_RADIO
 	chip->tea.card = card;
-	chip->tea.freq_fixup = 10700;
 	chip->tea.private_data = chip;
 	chip->tea.ops = &snd_fm801_tea_ops;
 	if ((tea575x_tuner & TUNER_TYPE_MASK) > 0 &&


-- 
Ondrej Zary
