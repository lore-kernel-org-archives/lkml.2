Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab0IRTam (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:30:42 -0400
Received: from kroah.org ([198.145.64.141]:43416 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833Ab0IRTPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:16 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:02 2010
Message-Id: <20100918191301.992963769@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [054/129] ALSA: virtuoso: fix setting of Xonar DS line-in/mic-in controls
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit fe6ce80ae25953d95ebaf9bce27b585218cda25c upstream.

The Line and Mic inputs cannot be used at the same time, so the driver
has to automatically disable one of them if both are set.  However, it
forgot to notify userspace about this change, so the mixer state would
be inconsistent.  To fix this, check if the other control gets muted,
and send a notification event in this case.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Reported-and-tested-by: Nathan Schagen
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/oxygen/xonar_wm87x6.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/sound/pci/oxygen/xonar_wm87x6.c
+++ b/sound/pci/oxygen/xonar_wm87x6.c
@@ -53,6 +53,8 @@ struct xonar_wm87x6 {
 	struct xonar_generic generic;
 	u16 wm8776_regs[0x17];
 	u16 wm8766_regs[0x10];
+	struct snd_kcontrol *line_adcmux_control;
+	struct snd_kcontrol *mic_adcmux_control;
 	struct snd_kcontrol *lc_controls[13];
 };
 
@@ -604,6 +606,7 @@ static int wm8776_input_mux_put(struct s
 {
 	struct oxygen *chip = ctl->private_data;
 	struct xonar_wm87x6 *data = chip->model_data;
+	struct snd_kcontrol *other_ctl;
 	unsigned int mux_bit = ctl->private_value;
 	u16 reg;
 	int changed;
@@ -611,8 +614,18 @@ static int wm8776_input_mux_put(struct s
 	mutex_lock(&chip->mutex);
 	reg = data->wm8776_regs[WM8776_ADCMUX];
 	if (value->value.integer.value[0]) {
-		reg &= ~0x003;
 		reg |= mux_bit;
+		/* line-in and mic-in are exclusive */
+		mux_bit ^= 3;
+		if (reg & mux_bit) {
+			reg &= ~mux_bit;
+			if (mux_bit == 1)
+				other_ctl = data->line_adcmux_control;
+			else
+				other_ctl = data->mic_adcmux_control;
+			snd_ctl_notify(chip->card, SNDRV_CTL_EVENT_MASK_VALUE,
+				       &other_ctl->id);
+		}
 	} else
 		reg &= ~mux_bit;
 	changed = reg != data->wm8776_regs[WM8776_ADCMUX];
@@ -964,7 +977,13 @@ static int xonar_ds_mixer_init(struct ox
 		err = snd_ctl_add(chip->card, ctl);
 		if (err < 0)
 			return err;
+		if (!strcmp(ctl->id.name, "Line Capture Switch"))
+			data->line_adcmux_control = ctl;
+		else if (!strcmp(ctl->id.name, "Mic Capture Switch"))
+			data->mic_adcmux_control = ctl;
 	}
+	if (!data->line_adcmux_control || !data->mic_adcmux_control)
+		return -ENXIO;
 	BUILD_BUG_ON(ARRAY_SIZE(lc_controls) != ARRAY_SIZE(data->lc_controls));
 	for (i = 0; i < ARRAY_SIZE(lc_controls); ++i) {
 		ctl = snd_ctl_new1(&lc_controls[i], chip);


