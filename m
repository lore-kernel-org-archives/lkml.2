Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab2AXCoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:44:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756394Ab2AXCoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:44:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:25 2012
Message-Id: <20120124023925.017321760@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:33:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [012/129] ALSA: usb-audio - Avoid flood of frame-active debug messages
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1281
Lines: 39

From: Takashi Iwai <tiwai@suse.de>

commit 80c8a2a372599e604b04a9c568952fe39cd1851d upstream.

With some buggy devices, the usb-audio driver may give "frame xxx active"
kernel messages too often.  Better to keep it as debug-only using
snd_printdd(), and also add the rate-limit for avoiding floods.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=738681

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/endpoint.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -17,6 +17,7 @@
 
 #include <linux/gfp.h>
 #include <linux/init.h>
+#include <linux/ratelimit.h>
 #include <linux/usb.h>
 #include <linux/usb/audio.h>
 
@@ -458,8 +459,8 @@ static int retire_capture_urb(struct snd
 
 	for (i = 0; i < urb->number_of_packets; i++) {
 		cp = (unsigned char *)urb->transfer_buffer + urb->iso_frame_desc[i].offset;
-		if (urb->iso_frame_desc[i].status) {
-			snd_printd(KERN_ERR "frame %d active: %d\n", i, urb->iso_frame_desc[i].status);
+		if (urb->iso_frame_desc[i].status && printk_ratelimit()) {
+			snd_printdd("frame %d active: %d\n", i, urb->iso_frame_desc[i].status);
 			// continue;
 		}
 		bytes = urb->iso_frame_desc[i].actual_length;


