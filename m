Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab0DVUUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:20:52 -0400
Received: from kroah.org ([198.145.64.141]:59751 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758005Ab0DVUAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:31 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:11 2010
Message-Id: <20100422195411.102308909@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [063/139] ALSA: usb - Fix Oops after usb-midi disconnection
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 29aac005ff4dc8a5f50b80f4e5c4f59b21c0fb50 upstream.

usb-midi causes sometimes Oops at snd_usbmidi_output_drain() after
disconnection.  This is due to the access to the endpoints which have
been already released at disconnection while the files are still alive.

This patch fixes the problem by checking disconnection state at
snd_usbmidi_output_drain() and by releasing urbs but keeping the
endpoint instances until really all freed.

Tested-by: Tvrtko Ursulin <tvrtko@ursulin.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/usbmidi.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/sound/usb/usbmidi.c
+++ b/sound/usb/usbmidi.c
@@ -984,6 +984,8 @@ static void snd_usbmidi_output_drain(str
 	DEFINE_WAIT(wait);
 	long timeout = msecs_to_jiffies(50);
 
+	if (ep->umidi->disconnected)
+		return;
 	/*
 	 * The substream buffer is empty, but some data might still be in the
 	 * currently active URBs, so we have to wait for those to complete.
@@ -1121,14 +1123,21 @@ static int snd_usbmidi_in_endpoint_creat
  * Frees an output endpoint.
  * May be called when ep hasn't been initialized completely.
  */
-static void snd_usbmidi_out_endpoint_delete(struct snd_usb_midi_out_endpoint* ep)
+static void snd_usbmidi_out_endpoint_clear(struct snd_usb_midi_out_endpoint *ep)
 {
 	unsigned int i;
 
 	for (i = 0; i < OUTPUT_URBS; ++i)
-		if (ep->urbs[i].urb)
+		if (ep->urbs[i].urb) {
 			free_urb_and_buffer(ep->umidi, ep->urbs[i].urb,
 					    ep->max_transfer);
+			ep->urbs[i].urb = NULL;
+		}
+}
+
+static void snd_usbmidi_out_endpoint_delete(struct snd_usb_midi_out_endpoint *ep)
+{
+	snd_usbmidi_out_endpoint_clear(ep);
 	kfree(ep);
 }
 
@@ -1260,15 +1269,18 @@ void snd_usbmidi_disconnect(struct list_
 				usb_kill_urb(ep->out->urbs[j].urb);
 			if (umidi->usb_protocol_ops->finish_out_endpoint)
 				umidi->usb_protocol_ops->finish_out_endpoint(ep->out);
+			ep->out->active_urbs = 0;
+			if (ep->out->drain_urbs) {
+				ep->out->drain_urbs = 0;
+				wake_up(&ep->out->drain_wait);
+			}
 		}
 		if (ep->in)
 			for (j = 0; j < INPUT_URBS; ++j)
 				usb_kill_urb(ep->in->urbs[j]);
 		/* free endpoints here; later call can result in Oops */
-		if (ep->out) {
-			snd_usbmidi_out_endpoint_delete(ep->out);
-			ep->out = NULL;
-		}
+		if (ep->out)
+			snd_usbmidi_out_endpoint_clear(ep->out);
 		if (ep->in) {
 			snd_usbmidi_in_endpoint_delete(ep->in);
 			ep->in = NULL;


