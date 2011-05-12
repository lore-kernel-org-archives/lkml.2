Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab1ELUSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 16:18:34 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:54161 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758572Ab1ELUSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 16:18:32 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Subject: [PATCH 3/3] tea575x: use better card and bus names
Date: Thu, 12 May 2011 22:18:22 +0200
User-Agent: KMail/1.9.10
Cc: linux-media@vger.kernel.org,
        "Kernel development list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105122218.24910.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide real card and bus_info instead of hardcoded values.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.39-rc2-/include/sound/tea575x-tuner.h	2011-05-12 21:53:43.000000000 +0200
+++ linux-2.6.39-rc2/include/sound/tea575x-tuner.h	2011-05-12 21:37:40.000000000 +0200
@@ -52,6 +52,8 @@ struct snd_tea575x {
 	unsigned long in_use;		/* set if the device is in use */
 	struct snd_tea575x_ops *ops;
 	void *private_data;
+	u8 card[32];
+	u8 bus_info[32];
 };
 
 int snd_tea575x_init(struct snd_tea575x *tea);
--- linux-2.6.39-rc2-/sound/i2c/other/tea575x-tuner.c	2011-05-12 21:22:35.000000000 +0200
+++ linux-2.6.39-rc2/sound/i2c/other/tea575x-tuner.c	2011-05-12 21:41:11.000000000 +0200
@@ -178,8 +178,9 @@ static int vidioc_querycap(struct file *
 	struct snd_tea575x *tea = video_drvdata(file);
 
 	strlcpy(v->driver, "tea575x-tuner", sizeof(v->driver));
-	strlcpy(v->card, tea->tea5759 ? "TEA5759" : "TEA5757", sizeof(v->card));
-	sprintf(v->bus_info, "PCI");
+	strlcpy(v->card, tea->card, sizeof(v->card));
+	strlcat(v->card, tea->tea5759 ? " TEA5759" : " TEA5757", sizeof(v->card));
+	strlcpy(v->bus_info, tea->bus_info, sizeof(v->bus_info));
 	v->version = RADIO_VERSION;
 	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	return 0;
--- linux-2.6.39-rc2-/sound/pci/es1968.c	2011-05-12 21:53:43.000000000 +0200
+++ linux-2.6.39-rc2/sound/pci/es1968.c	2011-05-12 21:45:59.000000000 +0200
@@ -2795,6 +2795,8 @@ static int __devinit snd_es1968_create(s
 #ifdef CONFIG_SND_ES1968_RADIO
 	chip->tea.private_data = chip;
 	chip->tea.ops = &snd_es1968_tea_ops;
+	strlcpy(chip->tea.card, "SF64-PCE2", sizeof(chip->tea.card));
+	sprintf(chip->tea.bus_info, "PCI:%s", pci_name(pci));
 	if (!snd_tea575x_init(&chip->tea))
 		printk(KERN_INFO "es1968: detected TEA575x radio\n");
 #endif
--- linux-2.6.39-rc2-/sound/pci/fm801.c	2011-05-12 21:53:43.000000000 +0200
+++ linux-2.6.39-rc2/sound/pci/fm801.c	2011-05-12 21:50:19.000000000 +0200
@@ -1232,6 +1232,7 @@ static int __devinit snd_fm801_create(st
 #ifdef TEA575X_RADIO
 	chip->tea.private_data = chip;
 	chip->tea.ops = &snd_fm801_tea_ops;
+	sprintf(chip->tea.bus_info, "PCI:%s", pci_name(pci));
 	if ((tea575x_tuner & TUNER_TYPE_MASK) > 0 &&
 	    (tea575x_tuner & TUNER_TYPE_MASK) < 4) {
 		if (snd_tea575x_init(&chip->tea))
@@ -1246,6 +1247,7 @@ static int __devinit snd_fm801_create(st
 				break;
 			}
 		}
+	strlcpy(chip->tea.card, snd_fm801_tea575x_gpios[(tea575x_tuner & TUNER_TYPE_MASK) - 1].name, sizeof(chip->tea.card));
 #endif
 
 	*rchip = chip;


-- 
Ondrej Zary
