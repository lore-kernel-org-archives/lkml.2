Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab2ILXeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:34:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49817 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab2ILXeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:34:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Daniel Mack <zonque@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 076/108] ALSA: snd-usb: fix calls to next_packet_size
Date: Wed, 12 Sep 2012 16:29:14 -0700
Message-Id: <20120912232458.479428556@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit 245baf983cc39524cce39c24d01b276e6e653c9e upstream.

In order to support devices with implicit feedback streaming models,
packet sizes are now stored with each individual urb, and the PCM
handling code which fills the buffers purely relies on the size fields
now.

However, calling snd_usb_audio_next_packet_size() for all possible
packets in an URB at once, prior to letting the PCM code do its job
does in fact not lead to the same behaviour than what the old code did:
The PCM code will break its loop once a period boundary is reached,
consequently using up less packets that it really could.

As snd_usb_audio_next_packet_size() implements a feedback mechanism to
the endpoints phase accumulator, the number of calls to that function
matters, and when called too often, the data rate runs out of bounds.

Fix this by making the next_packet function public, and call it from the
PCM code as before if the packet data sizes are not defined.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/endpoint.c |   13 +------------
 sound/usb/endpoint.h |    1 +
 sound/usb/pcm.c      |    7 ++++++-
 3 files changed, 8 insertions(+), 13 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -141,7 +141,7 @@ int snd_usb_endpoint_implict_feedback_si
  *
  * For implicit feedback, next_packet_size() is unused.
  */
-static int next_packet_size(struct snd_usb_endpoint *ep)
+int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep)
 {
 	unsigned long flags;
 	int ret;
@@ -177,15 +177,6 @@ static void retire_inbound_urb(struct sn
 		ep->retire_data_urb(ep->data_subs, urb);
 }
 
-static void prepare_outbound_urb_sizes(struct snd_usb_endpoint *ep,
-				       struct snd_urb_ctx *ctx)
-{
-	int i;
-
-	for (i = 0; i < ctx->packets; ++i)
-		ctx->packet_size[i] = next_packet_size(ep);
-}
-
 /*
  * Prepare a PLAYBACK urb for submission to the bus.
  */
@@ -370,7 +361,6 @@ static void snd_complete_urb(struct urb
 			goto exit_clear;
 		}
 
-		prepare_outbound_urb_sizes(ep, ctx);
 		prepare_outbound_urb(ep, ctx);
 	} else {
 		retire_inbound_urb(ep, ctx);
@@ -857,7 +847,6 @@ int snd_usb_endpoint_start(struct snd_us
 			goto __error;
 
 		if (usb_pipeout(ep->pipe)) {
-			prepare_outbound_urb_sizes(ep, urb->context);
 			prepare_outbound_urb(ep, urb->context);
 		} else {
 			prepare_inbound_urb(ep, urb->context);
--- a/sound/usb/endpoint.h
+++ b/sound/usb/endpoint.h
@@ -21,6 +21,7 @@ int  snd_usb_endpoint_deactivate(struct
 void snd_usb_endpoint_free(struct list_head *head);
 
 int snd_usb_endpoint_implict_feedback_sink(struct snd_usb_endpoint *ep);
+int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep);
 
 void snd_usb_handle_sync_urb(struct snd_usb_endpoint *ep,
 			     struct snd_usb_endpoint *sender,
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1029,6 +1029,7 @@ static void prepare_playback_urb(struct
 				 struct urb *urb)
 {
 	struct snd_pcm_runtime *runtime = subs->pcm_substream->runtime;
+	struct snd_usb_endpoint *ep = subs->data_endpoint;
 	struct snd_urb_ctx *ctx = urb->context;
 	unsigned int counts, frames, bytes;
 	int i, stride, period_elapsed = 0;
@@ -1040,7 +1041,11 @@ static void prepare_playback_urb(struct
 	urb->number_of_packets = 0;
 	spin_lock_irqsave(&subs->lock, flags);
 	for (i = 0; i < ctx->packets; i++) {
-		counts = ctx->packet_size[i];
+		if (ctx->packet_size[i])
+			counts = ctx->packet_size[i];
+		else
+			counts = snd_usb_endpoint_next_packet_size(ep);
+
 		/* set up descriptor */
 		urb->iso_frame_desc[i].offset = frames * stride;
 		urb->iso_frame_desc[i].length = counts * stride;


