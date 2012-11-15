Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992994Ab2KOELl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:11:41 -0500
Received: from mail.kernel.org ([198.145.19.201]:49239 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933367Ab2KOELj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Matthieu CASTET <matthieu.castet@parrot.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 40/66] ALSA: usb-audio: Fix races at disconnection in mixer_quirks.c
Date: Wed, 14 Nov 2012 20:10:45 -0800
Message-Id: <20121115040941.885518446@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 888ea7d5ac6815ba16b3b3a20f665a92c7af6724 upstream.

Similar like the previous commit, cover with chip->shutdown_rwsem
and chip->shutdown checks.

Reported-by: Matthieu CASTET <matthieu.castet@parrot.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |   58 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 51 insertions(+), 7 deletions(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -283,6 +283,11 @@ static int snd_audigy2nx_led_put(struct
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
@@ -299,6 +304,8 @@ static int snd_audigy2nx_led_put(struct
 			      usb_sndctrlpipe(mixer->chip->dev, 0), 0x24,
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_OTHER,
 			      value, index + 2, NULL, 0);
+ out:
+	up_read(&mixer->chip->shutdown_rwsem);
 	if (err < 0)
 		return err;
 	mixer->audigy2nx_leds[index] = value;
@@ -392,11 +399,16 @@ static void snd_audigy2nx_proc_read(stru
 
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
@@ -426,10 +438,15 @@ static int snd_xonar_u1_switch_put(struc
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
@@ -468,11 +485,17 @@ static int snd_nativeinstruments_control
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
@@ -493,11 +516,17 @@ static int snd_nativeinstruments_control
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
@@ -656,11 +685,16 @@ static int snd_ftu_eff_switch_get(struct
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
 
@@ -703,11 +737,16 @@ static int snd_ftu_eff_switch_put(struct
 
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
 
@@ -719,11 +758,16 @@ static int snd_ftu_eff_switch_put(struct
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
 


