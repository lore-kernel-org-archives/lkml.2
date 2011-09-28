Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab1I1Wsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:48:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933257Ab1I1Wse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:48:34 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:47 2011
Message-Id: <20110928220147.172559458@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Pfaff <tpfaff@gmx.net>, Takashi Iwai <tiwai@suse.de>
Subject: [207/244] ALSA: usb-audio - clear chip->probing on error exit
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Pfaff <tpfaff@gmx.net>

commit 362e4e49abe53e89d87455dfcd7c1bbaf08a839d upstream.

The Terratec Aureon 5.1 USB sound card support is broken since kernel
2.6.39.
2.6.39 introduced power management support for USB sound cards that added
a probing flag in struct snd_usb_audio.

During the probe of the card it gives following error message :

usb 7-2: new full speed USB device number 2 using uhci_hcd
cannot find UAC_HEADER
snd-usb-audio: probe of 7-2:1.3 failed with error -5
input: USB Audio as
/devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.3/input/input6
generic-usb 0003:0CCD:0028.0001: input: USB HID v1.00 Device [USB Audio]
on usb-0000:00:1d.1-2/input3

I can not comment about that "cannot find UAC_HEADER" error, but until
2.6.38 the card worked anyway.
With 2.6.39 chip->probing remains 1 on error exit, and any later ioctl
stops in snd_usb_autoresume with -ENODEV.

Signed-off-by: Thomas Pfaff <tpfaff@gmx.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/card.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -531,6 +531,7 @@ static void *snd_usb_audio_probe(struct
  __error:
 	if (chip && !chip->num_interfaces)
 		snd_card_free(chip->card);
+	chip->probing = 0;
 	mutex_unlock(&register_mutex);
  __err_val:
 	return NULL;


