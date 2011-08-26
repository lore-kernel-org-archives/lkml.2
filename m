Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1H0O4X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:56:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab1H0O4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:56:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 15:01:20 2011
Message-Id: <20110826220120.313375814@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:58:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Mack <zonque@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [07/19] ALSA: snd-usb-caiaq: Correct offset fields of outbound iso_frame_desc
In-Reply-To: <20110826220137.GA14059@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit 15439bde3af7ff88459ea2b5520b77312e958df2 upstream.

This fixes faulty outbount packets in case the inbound packets
received from the hardware are fragmented and contain bogus input
iso frames. The bug has been there for ages, but for some strange
reasons, it was only triggered by newer machines in 64bit mode.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-and-tested-by: William Light <wrl@illest.net>
Reported-by: Pedro Ribeiro <pedrib@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/caiaq/audio.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/usb/caiaq/audio.c
+++ b/sound/usb/caiaq/audio.c
@@ -468,6 +468,7 @@ static void read_completed(struct urb *u
 	struct snd_usb_caiaqdev *dev;
 	struct urb *out;
 	int frame, len, send_it = 0, outframe = 0;
+	size_t offset = 0;
 
 	if (urb->status || !info)
 		return;
@@ -488,7 +489,8 @@ static void read_completed(struct urb *u
 		len = urb->iso_frame_desc[outframe].actual_length;
 		out->iso_frame_desc[outframe].length = len;
 		out->iso_frame_desc[outframe].actual_length = 0;
-		out->iso_frame_desc[outframe].offset = BYTES_PER_FRAME * frame;
+		out->iso_frame_desc[outframe].offset = offset;
+		offset += len;
 
 		if (len > 0) {
 			spin_lock(&dev->spinlock);
@@ -504,7 +506,7 @@ static void read_completed(struct urb *u
 	}
 
 	if (send_it) {
-		out->number_of_packets = FRAMES_PER_URB;
+		out->number_of_packets = outframe;
 		out->transfer_flags = URB_ISO_ASAP;
 		usb_submit_urb(out, GFP_ATOMIC);
 	}


