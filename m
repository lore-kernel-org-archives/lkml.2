Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab1BPArY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:47:24 -0500
Received: from kroah.org ([198.145.64.141]:45132 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757478Ab1BPArU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:47:20 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:20:59 2011
Message-Id: <20110216002059.568355401@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:19:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Karsten Wiese <fzu@wemgehoertderstaat.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [patch 005/176] ALSA: snd-usb-us122l: Fix MIDI output
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Karsten Wiese <fzu@wemgehoertderstaat.de>

commit 921eebdc18c82268eab446592191b39e35d031d6 upstream.

The US-122L always reads 9 bytes per urb unless they are set to 0xFD.

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/midi.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -843,8 +843,8 @@ static void snd_usbmidi_us122l_output(st
 		return;
 	}
 
-	memset(urb->transfer_buffer + count, 0xFD, 9 - count);
-	urb->transfer_buffer_length = count;
+	memset(urb->transfer_buffer + count, 0xFD, ep->max_transfer - count);
+	urb->transfer_buffer_length = ep->max_transfer;
 }
 
 static struct usb_protocol_ops snd_usbmidi_122l_ops = {
@@ -1288,6 +1288,13 @@ static int snd_usbmidi_out_endpoint_crea
 	case USB_ID(0x1a86, 0x752d): /* QinHeng CH345 "USB2.0-MIDI" */
 		ep->max_transfer = 4;
 		break;
+		/*
+		 * Some devices only work with 9 bytes packet size:
+		 */
+	case USB_ID(0x0644, 0x800E): /* Tascam US-122L */
+	case USB_ID(0x0644, 0x800F): /* Tascam US-144 */
+		ep->max_transfer = 9;
+		break;
 	}
 	for (i = 0; i < OUTPUT_URBS; ++i) {
 		buffer = usb_alloc_coherent(umidi->dev,


