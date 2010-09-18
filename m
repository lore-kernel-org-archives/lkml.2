Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab0IRT3y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:29:54 -0400
Received: from kroah.org ([198.145.64.141]:43457 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756840Ab0IRTPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:21 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:02 2010
Message-Id: <20100918191302.503093195@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Mack <daniel@caiaq.de>, Takashi Iwai <tiwai@suse.de>
Subject: [060/129] ALSA: usb-audio: Assume first control interface is for audio
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel Mack <daniel@caiaq.de>

commit 7b6717e144de6592e614fd7fc3b914b6bf686a9d upstream.

For devices with more than one control interface, let's assume the first
one contains the audio controls. Unfortunately, there is no field in any
of the descriptors to tell us whether a control interface is for audio
or MIDI controls, so a better check is not easy to implement.

On a composite device with audio and MIDI functions, for example, the
code currently overwrites chip->ctrl_intf, causing operations on the
control interface to fail if they are issued after the device probe.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/card.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -466,7 +466,13 @@ static void *snd_usb_audio_probe(struct
 			goto __error;
 	}
 
-	chip->ctrl_intf = alts;
+	/*
+	 * For devices with more than one control interface, we assume the
+	 * first contains the audio controls. We might need a more specific
+	 * check here in the future.
+	 */
+	if (!chip->ctrl_intf)
+		chip->ctrl_intf = alts;
 
 	if (err > 0) {
 		/* create normal USB audio interfaces */


