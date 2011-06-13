Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab1FMWAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 18:00:33 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24705 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab1FMWAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 18:00:31 -0400
Date: Mon, 13 Jun 2011 23:52:02 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: alsa-devel@alsa-project.org, Daniel Mack <zonque@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Torsten Schenk <torsten.schenk@zoho.com>, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH] Sound, 6Fire USB: Fix double-free bug in
 usb6fire_fw_ezusb_upload()
Message-ID: <alpine.LNX.2.00.1106132346370.30934@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a double-free bug in 
sound/usb/6fire/firmware.c::usb6fire_fw_ezusb_upload().
We already call release_firmware(fw) on line 258, so when we then do it 
again after usb6fire_fw_ezusb_write() returns <0, we have a double-free.
Easily fixed by just removing the last call to release_firmware().

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 firmware.c |    1 -
 1 file changed, 1 deletion(-)

  Patch against Linus' tree (head at 40779859de0f73b40390c6401a024d06cf024290).

diff --git a/sound/usb/6fire/firmware.c b/sound/usb/6fire/firmware.c
index a91719d..1e3ae33 100644
--- a/sound/usb/6fire/firmware.c
+++ b/sound/usb/6fire/firmware.c
@@ -270,7 +270,6 @@ static int usb6fire_fw_ezusb_upload(
 	data = 0x00; /* resume ezusb cpu */
 	ret = usb6fire_fw_ezusb_write(device, 0xa0, 0xe600, &data, 1);
 	if (ret < 0) {
-		release_firmware(fw);
 		snd_printk(KERN_ERR PREFIX "unable to upload ezusb "
 				"firmware %s: end message.\n", fwname);
 		return ret;


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

