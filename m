Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab1CSPdR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 11:33:17 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:53407 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754523Ab1CSPdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 11:33:15 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: [RFC PATCH 1/3] tea575x-tuner: various improvements
Date: Sat, 19 Mar 2011 16:32:53 +0100
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
Message-Id: <201103191632.58347.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve tea575x-tuner with various good things from radio-maestro:
- extend frequency range to 50-150MHz
- fix querycap(): card name, CAP_RADIO
- improve g_tuner(): CAP_STEREO, stereo and tuned indication
- improve g_frequency(): tuner index checking and reading frequency from HW
- improve s_frequency(): tuner index and type checking

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.38-rc4-orig/sound/i2c/other/tea575x-tuner.c	2011-02-08 01:03:55.000000000 +0100
+++ linux-2.6.38-rc4/sound/i2c/other/tea575x-tuner.c	2011-03-19 15:40:14.000000000 +0100
@@ -37,8 +37,8 @@ static int radio_nr = -1;
 module_param(radio_nr, int, 0);
 
 #define RADIO_VERSION KERNEL_VERSION(0, 0, 2)
-#define FREQ_LO		 (87 * 16000)
-#define FREQ_HI		(108 * 16000)
+#define FREQ_LO		 (50UL * 16000)
+#define FREQ_HI		(150UL * 16000)
 
 /*
  * definitions
@@ -77,15 +77,29 @@ static struct v4l2_queryctrl radio_qctrl
  * lowlevel part
  */
 
+static void snd_tea575x_get_freq(struct snd_tea575x *tea)
+{
+	unsigned long freq;
+
+	freq = tea->ops->read(tea) & TEA575X_BIT_FREQ_MASK;
+	/* freq *= 12.5 */
+	freq *= 125;
+	freq /= 10;
+	/* crystal fixup */
+	if (tea->tea5759)
+		freq += tea->freq_fixup;
+	else
+		freq -= tea->freq_fixup;
+
+	tea->freq = freq * 16;		/* from kHz */
+}
+
 static void snd_tea575x_set_freq(struct snd_tea575x *tea)
 {
 	unsigned long freq;
 
-	freq = tea->freq / 16;		/* to kHz */
-	if (freq > 108000)
-		freq = 108000;
-	if (freq < 87000)
-		freq = 87000;
+	freq = clamp(tea->freq, FREQ_LO, FREQ_HI);
+	freq /= 16;		/* to kHz */
 	/* crystal fixup */
 	if (tea->tea5759)
 		freq -= tea->freq_fixup;
@@ -109,29 +123,33 @@ static int vidioc_querycap(struct file *
 {
 	struct snd_tea575x *tea = video_drvdata(file);
 
-	strcpy(v->card, tea->tea5759 ? "TEA5759" : "TEA5757");
 	strlcpy(v->driver, "tea575x-tuner", sizeof(v->driver));
-	strlcpy(v->card, "Maestro Radio", sizeof(v->card));
+	strlcpy(v->card, tea->tea5759 ? "TEA5759" : "TEA5757", sizeof(v->card));
 	sprintf(v->bus_info, "PCI");
 	v->version = RADIO_VERSION;
-	v->capabilities = V4L2_CAP_TUNER;
+	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	return 0;
 }
 
 static int vidioc_g_tuner(struct file *file, void *priv,
 					struct v4l2_tuner *v)
 {
+	struct snd_tea575x *tea = video_drvdata(file);
+
 	if (v->index > 0)
 		return -EINVAL;
 
+	tea->ops->read(tea);
+
 	strcpy(v->name, "FM");
 	v->type = V4L2_TUNER_RADIO;
+	v->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
 	v->rangelow = FREQ_LO;
 	v->rangehigh = FREQ_HI;
-	v->rxsubchans = V4L2_TUNER_SUB_MONO|V4L2_TUNER_SUB_STEREO;
-	v->capability = V4L2_TUNER_CAP_LOW;
-	v->audmode = V4L2_TUNER_MODE_MONO;
-	v->signal = 0xffff;
+	v->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
+	v->audmode = tea->stereo ? V4L2_TUNER_MODE_STEREO : V4L2_TUNER_MODE_MONO;
+	v->signal = tea->tuned ? 0xffff : 0;
+
 	return 0;
 }
 
@@ -148,7 +166,10 @@ static int vidioc_g_frequency(struct fil
 {
 	struct snd_tea575x *tea = video_drvdata(file);
 
+	if (f->tuner != 0)
+		return -EINVAL;
 	f->type = V4L2_TUNER_RADIO;
+	snd_tea575x_get_freq(tea);
 	f->frequency = tea->freq;
 	return 0;
 }
@@ -158,6 +179,9 @@ static int vidioc_s_frequency(struct fil
 {
 	struct snd_tea575x *tea = video_drvdata(file);
 
+	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
+		return -EINVAL;
+
 	if (f->frequency < FREQ_LO || f->frequency > FREQ_HI)
 		return -EINVAL;
 
--- linux-2.6.38-rc4-orig/include/sound/tea575x-tuner.h	2011-02-08 01:03:55.000000000 +0100
+++ linux-2.6.38-rc4/include/sound/tea575x-tuner.h	2011-03-19 14:18:06.000000000 +0100
@@ -38,8 +38,10 @@ struct snd_tea575x {
 	struct snd_card *card;
 	struct video_device *vd;	/* video device */
 	int dev_nr;			/* requested device number + 1 */
-	int tea5759;			/* 5759 chip is present */
-	int mute;			/* Device is muted? */
+	bool tea5759;			/* 5759 chip is present */
+	bool mute;			/* Device is muted? */
+	bool stereo;			/* receiving stereo */
+	bool tuned;			/* tuned to a station */
 	unsigned int freq_fixup;	/* crystal onboard */
 	unsigned int val;		/* hw value */
 	unsigned long freq;		/* frequency */


-- 
Ondrej Zary
