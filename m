Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992854Ab2KOErB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:47:01 -0500
Received: from mail.kernel.org ([198.145.19.201]:48492 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992708Ab2KOEK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:10:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Matthieu CASTET <matthieu.castet@parrot.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 21/38] ALSA: usb-audio: Fix races at disconnection in mixer_quirks.c
Date: Wed, 14 Nov 2012 20:10:18 -0800
Message-Id: <20121115040934.206075713@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040932.918082372@linuxfoundation.org>
References: <20121115040932.918082372@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Takashi Iwai <tiwai@suse.de>

commit 888ea7d5ac6815ba16b3b3a20f665a92c7af6724 upstream.

Similar like the previous commit, cover with chip->shutdown_rwsem
and chip->shutdown checks.

Reported-by: Matthieu CASTET <matthieu.castet@parrot.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |   37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -186,6 +186,11 @@ static int snd_audigy2nx_led_put(struct
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
@@ -202,6 +207,8 @@ static int snd_audigy2nx_led_put(struct
 			      usb_sndctrlpipe(mixer->chip->dev, 0), 0x24,
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_OTHER,
 			      value, index + 2, NULL, 0, 100);
+ out:
+	up_read(&mixer->chip->shutdown_rwsem);
 	if (err < 0)
 		return err;
 	mixer->audigy2nx_leds[index] = value;
@@ -295,11 +302,16 @@ static void snd_audigy2nx_proc_read(stru
 
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
 				      jacks[i].unitid << 8, buf, 3, 100);
+		up_read(&mixer->chip->shutdown_rwsem);
 		if (err == 3 && (buf[0] == 3 || buf[0] == 6))
 			snd_iprintf(buffer, "%02x %02x\n", buf[1], buf[2]);
 		else
@@ -329,10 +341,15 @@ static int snd_xonar_u1_switch_put(struc
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
 			      50, 0, &new_status, 1, 100);
+	up_read(&mixer->chip->shutdown_rwsem);
 	if (err < 0)
 		return err;
 	mixer->xonar_u1_status = new_status;
@@ -371,11 +388,17 @@ static int snd_nativeinstruments_control
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
@@ -396,11 +419,17 @@ static int snd_nativeinstruments_control
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


