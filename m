Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab2LMPHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:07:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44055 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab2LMOCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:02:13 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 024/241] ALSA: usb-audio: Fix races at disconnection in mixer_quirks.c
Date: Thu, 13 Dec 2012 11:56:29 -0200
Message-Id: <1355407206-17100-25-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 888ea7d5ac6815ba16b3b3a20f665a92c7af6724 upstream.

Similar like the previous commit, cover with chip->shutdown_rwsem
and chip->shutdown checks.

Reported-by: Matthieu CASTET <matthieu.castet@parrot.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/usb/mixer_quirks.c |   58 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 51 insertions(+), 7 deletions(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 41f4b69..e4c808d 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -257,6 +257,11 @@ static int snd_audigy2nx_led_put(struct snd_kcontrol *kcontrol, struct snd_ctl_e
 	if (value > 1)
 		return -EINVAL;
 	changed = value != mixer->audigy2nx_leds[index];
+	down_read(&mixer->chip->shutdown_rwsem);
+	if (mixer->chip->shutdown) {
+		err = -ENODEV;
+		goto out;
+	}
 	if (mixer->chip->usb_id == USB_ID(0x041e, 0x3042))
 		err = snd_usb_ctl_msg(mixer->chip->dev,
 			      usb_sndctrlpipe(mixer->chip->dev, 0), 0x24,
@@ -273,6 +278,8 @@ static int snd_audigy2nx_led_put(struct snd_kcontrol *kcontrol, struct snd_ctl_e
 			      usb_sndctrlpipe(mixer->chip->dev, 0), 0x24,
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_OTHER,
 			      value, index + 2, NULL, 0);
+ out:
+	up_read(&mixer->chip->shutdown_rwsem);
 	if (err < 0)
 		return err;
 	mixer->audigy2nx_leds[index] = value;
@@ -366,11 +373,16 @@ static void snd_audigy2nx_proc_read(struct snd_info_entry *entry,
 
 	for (i = 0; jacks[i].name; ++i) {
 		snd_iprintf(buffer, "%s: ", jacks[i].name);
-		err = snd_usb_ctl_msg(mixer->chip->dev,
+		down_read(&mixer->chip->shutdown_rwsem);
+		if (mixer->chip->shutdown)
+			err = 0;
+		else
+			err = snd_usb_ctl_msg(mixer->chip->dev,
 				      usb_rcvctrlpipe(mixer->chip->dev, 0),
 				      UAC_GET_MEM, USB_DIR_IN | USB_TYPE_CLASS |
 				      USB_RECIP_INTERFACE, 0,
 				      jacks[i].unitid << 8, buf, 3);
+		up_read(&mixer->chip->shutdown_rwsem);
 		if (err == 3 && (buf[0] == 3 || buf[0] == 6))
 			snd_iprintf(buffer, "%02x %02x\n", buf[1], buf[2]);
 		else
@@ -400,10 +412,15 @@ static int snd_xonar_u1_switch_put(struct snd_kcontrol *kcontrol,
 	else
 		new_status = old_status & ~0x02;
 	changed = new_status != old_status;
-	err = snd_usb_ctl_msg(mixer->chip->dev,
+	down_read(&mixer->chip->shutdown_rwsem);
+	if (mixer->chip->shutdown)
+		err = -ENODEV;
+	else
+		err = snd_usb_ctl_msg(mixer->chip->dev,
 			      usb_sndctrlpipe(mixer->chip->dev, 0), 0x08,
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_OTHER,
 			      50, 0, &new_status, 1);
+	up_read(&mixer->chip->shutdown_rwsem);
 	if (err < 0)
 		return err;
 	mixer->xonar_u1_status = new_status;
@@ -442,11 +459,17 @@ static int snd_nativeinstruments_control_get(struct snd_kcontrol *kcontrol,
 	u8 bRequest = (kcontrol->private_value >> 16) & 0xff;
 	u16 wIndex = kcontrol->private_value & 0xffff;
 	u8 tmp;
+	int ret;
 
-	int ret = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), bRequest,
+	down_read(&mixer->chip->shutdown_rwsem);
+	if (mixer->chip->shutdown)
+		ret = -ENODEV;
+	else
+		ret = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), bRequest,
 				  USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
 				  0, cpu_to_le16(wIndex),
 				  &tmp, sizeof(tmp), 1000);
+	up_read(&mixer->chip->shutdown_rwsem);
 
 	if (ret < 0) {
 		snd_printk(KERN_ERR
@@ -467,11 +490,17 @@ static int snd_nativeinstruments_control_put(struct snd_kcontrol *kcontrol,
 	u8 bRequest = (kcontrol->private_value >> 16) & 0xff;
 	u16 wIndex = kcontrol->private_value & 0xffff;
 	u16 wValue = ucontrol->value.integer.value[0];
+	int ret;
 
-	int ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0), bRequest,
+	down_read(&mixer->chip->shutdown_rwsem);
+	if (mixer->chip->shutdown)
+		ret = -ENODEV;
+	else
+		ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0), bRequest,
 				  USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
 				  cpu_to_le16(wValue), cpu_to_le16(wIndex),
 				  NULL, 0, 1000);
+	up_read(&mixer->chip->shutdown_rwsem);
 
 	if (ret < 0) {
 		snd_printk(KERN_ERR
@@ -630,11 +659,16 @@ static int snd_ftu_eff_switch_get(struct snd_kcontrol *kctl,
 		return -EINVAL;
 
 
-	err = snd_usb_ctl_msg(chip->dev,
+	down_read(&mixer->chip->shutdown_rwsem);
+	if (mixer->chip->shutdown)
+		err = -ENODEV;
+	else
+		err = snd_usb_ctl_msg(chip->dev,
 			usb_rcvctrlpipe(chip->dev, 0), UAC_GET_CUR,
 			USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_IN,
 			validx << 8, snd_usb_ctrl_intf(chip) | (id << 8),
 			value, val_len);
+	up_read(&mixer->chip->shutdown_rwsem);
 	if (err < 0)
 		return err;
 
@@ -677,11 +711,16 @@ static int snd_ftu_eff_switch_put(struct snd_kcontrol *kctl,
 
 	if (!pval->is_cached) {
 		/* Read current value */
-		err = snd_usb_ctl_msg(chip->dev,
+		down_read(&mixer->chip->shutdown_rwsem);
+		if (mixer->chip->shutdown)
+			err = -ENODEV;
+		else
+			err = snd_usb_ctl_msg(chip->dev,
 				usb_rcvctrlpipe(chip->dev, 0), UAC_GET_CUR,
 				USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_IN,
 				validx << 8, snd_usb_ctrl_intf(chip) | (id << 8),
 				value, val_len);
+		up_read(&mixer->chip->shutdown_rwsem);
 		if (err < 0)
 			return err;
 
@@ -693,11 +732,16 @@ static int snd_ftu_eff_switch_put(struct snd_kcontrol *kctl,
 	if (cur_val != new_val) {
 		value[0] = new_val;
 		value[1] = 0;
-		err = snd_usb_ctl_msg(chip->dev,
+		down_read(&mixer->chip->shutdown_rwsem);
+		if (mixer->chip->shutdown)
+			err = -ENODEV;
+		else
+			err = snd_usb_ctl_msg(chip->dev,
 				usb_sndctrlpipe(chip->dev, 0), UAC_SET_CUR,
 				USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_OUT,
 				validx << 8, snd_usb_ctrl_intf(chip) | (id << 8),
 				value, val_len);
+		up_read(&mixer->chip->shutdown_rwsem);
 		if (err < 0)
 			return err;
 
-- 
1.7.9.5

