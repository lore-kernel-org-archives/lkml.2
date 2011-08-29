Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab1H2McB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 08:32:01 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:58475 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037Ab1H2Mbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 08:31:55 -0400
From: Felipe Balbi <balbi@ti.com>
To: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>, clemens@ladisch.de,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2] sound: usb: mixer: increase control transfer timeout
Date: Mon, 29 Aug 2011 15:31:50 +0300
Message-Id: <1314621110-19367-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.6.396.ge0613
In-Reply-To: <20110829122320.GX13925@legolas.emea.dhcp.ti.com>
References: <20110829122320.GX13925@legolas.emea.dhcp.ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

100ms might not be enough for slower devices. Increasing
timeout to 1000ms doesn't seem like overkill.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---

Changes since v1:
 . Increase all 100ms timeout to 1000ms

 sound/usb/mixer.c        |    4 ++--
 sound/usb/mixer_quirks.c |   10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index cdd19d7..1c9d443 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -296,7 +296,7 @@ static int get_ctl_value_v1(struct usb_mixer_elem_info *cval, int request, int v
 		if (snd_usb_ctl_msg(chip->dev, usb_rcvctrlpipe(chip->dev, 0), request,
 				    USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_IN,
 				    validx, snd_usb_ctrl_intf(chip) | (cval->id << 8),
-				    buf, val_len, 100) >= val_len) {
+				    buf, val_len, 1000) >= val_len) {
 			*value_ret = convert_signed_value(cval, snd_usb_combine_bytes(buf, val_len));
 			snd_usb_autosuspend(cval->mixer->chip);
 			return 0;
@@ -445,7 +445,7 @@ int snd_usb_mixer_set_ctl_value(struct usb_mixer_elem_info *cval,
 				    usb_sndctrlpipe(chip->dev, 0), request,
 				    USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_OUT,
 				    validx, snd_usb_ctrl_intf(chip) | (cval->id << 8),
-				    buf, val_len, 100) >= 0) {
+				    buf, val_len, 1000) >= 0) {
 			snd_usb_autosuspend(chip);
 			return 0;
 		}
diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 3d0f487..7c41399 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -190,18 +190,18 @@ static int snd_audigy2nx_led_put(struct snd_kcontrol *kcontrol, struct snd_ctl_e
 		err = snd_usb_ctl_msg(mixer->chip->dev,
 			      usb_sndctrlpipe(mixer->chip->dev, 0), 0x24,
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_OTHER,
-			      !value, 0, NULL, 0, 100);
+			      !value, 0, NULL, 0, 1000);
 	/* USB X-Fi S51 Pro */
 	if (mixer->chip->usb_id == USB_ID(0x041e, 0x30df))
 		err = snd_usb_ctl_msg(mixer->chip->dev,
 			      usb_sndctrlpipe(mixer->chip->dev, 0), 0x24,
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_OTHER,
-			      !value, 0, NULL, 0, 100);
+			      !value, 0, NULL, 0, 1000);
 	else
 		err = snd_usb_ctl_msg(mixer->chip->dev,
 			      usb_sndctrlpipe(mixer->chip->dev, 0), 0x24,
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_OTHER,
-			      value, index + 2, NULL, 0, 100);
+			      value, index + 2, NULL, 0, 1000);
 	if (err < 0)
 		return err;
 	mixer->audigy2nx_leds[index] = value;
@@ -299,7 +299,7 @@ static void snd_audigy2nx_proc_read(struct snd_info_entry *entry,
 				      usb_rcvctrlpipe(mixer->chip->dev, 0),
 				      UAC_GET_MEM, USB_DIR_IN | USB_TYPE_CLASS |
 				      USB_RECIP_INTERFACE, 0,
-				      jacks[i].unitid << 8, buf, 3, 100);
+				      jacks[i].unitid << 8, buf, 3, 1000);
 		if (err == 3 && (buf[0] == 3 || buf[0] == 6))
 			snd_iprintf(buffer, "%02x %02x\n", buf[1], buf[2]);
 		else
@@ -332,7 +332,7 @@ static int snd_xonar_u1_switch_put(struct snd_kcontrol *kcontrol,
 	err = snd_usb_ctl_msg(mixer->chip->dev,
 			      usb_sndctrlpipe(mixer->chip->dev, 0), 0x08,
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_OTHER,
-			      50, 0, &new_status, 1, 100);
+			      50, 0, &new_status, 1, 1000);
 	if (err < 0)
 		return err;
 	mixer->xonar_u1_status = new_status;
-- 
1.7.6.396.ge0613

