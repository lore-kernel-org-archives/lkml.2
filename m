Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab1H0PIF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 11:08:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab1H0O4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:56:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 15:04:20 2011
Message-Id: <20110826220420.157042159@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 15:03:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Mack <zonque@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [13/20] ALSA: snd_usb_caiaq: track submitted output urbs
In-Reply-To: <20110826220431.GA15382@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit da6094ea7d3c2295473d8f5134279307255d6ebf upstream.

The snd_usb_caiaq driver currently assumes that output urbs are serviced
in time and doesn't track when and whether they are given back by the
USB core. That usually works fine, but due to temporary limitations of
the XHCI stack, we faced that urbs were submitted more than once with
this approach.

As it's no good practice to fire and forget urbs anyway, this patch
introduces a proper bit mask to track which requests have been submitted
and given back.

That alone however doesn't make the driver work in case the host
controller is broken and doesn't give back urbs at all, and the output
stream will stop once all pre-allocated output urbs are consumed. But
it does prevent crashes of the controller stack in such cases.

See http://bugzilla.kernel.org/show_bug.cgi?id=40702 for more details.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-and-tested-by: Matej Laitl <matej@laitl.cz>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/caiaq/audio.c  |   31 +++++++++++++++++++++++++++----
 sound/usb/caiaq/device.h |    1 +
 2 files changed, 28 insertions(+), 4 deletions(-)

--- a/sound/usb/caiaq/audio.c
+++ b/sound/usb/caiaq/audio.c
@@ -138,8 +138,12 @@ static void stream_stop(struct snd_usb_c
 
 	for (i = 0; i < N_URBS; i++) {
 		usb_kill_urb(dev->data_urbs_in[i]);
-		usb_kill_urb(dev->data_urbs_out[i]);
+
+		if (test_bit(i, &dev->outurb_active_mask))
+			usb_kill_urb(dev->data_urbs_out[i]);
 	}
+
+	dev->outurb_active_mask = 0;
 }
 
 static int snd_usb_caiaq_substream_open(struct snd_pcm_substream *substream)
@@ -466,8 +470,8 @@ static void read_completed(struct urb *u
 {
 	struct snd_usb_caiaq_cb_info *info = urb->context;
 	struct snd_usb_caiaqdev *dev;
-	struct urb *out;
-	int frame, len, send_it = 0, outframe = 0;
+	struct urb *out = NULL;
+	int i, frame, len, send_it = 0, outframe = 0;
 	size_t offset = 0;
 
 	if (urb->status || !info)
@@ -478,7 +482,17 @@ static void read_completed(struct urb *u
 	if (!dev->streaming)
 		return;
 
-	out = dev->data_urbs_out[info->index];
+	/* find an unused output urb that is unused */
+	for (i = 0; i < N_URBS; i++)
+		if (test_and_set_bit(i, &dev->outurb_active_mask) == 0) {
+			out = dev->data_urbs_out[i];
+			break;
+		}
+
+	if (!out) {
+		log("Unable to find an output urb to use\n");
+		goto requeue;
+	}
 
 	/* read the recently received packet and send back one which has
 	 * the same layout */
@@ -509,8 +523,12 @@ static void read_completed(struct urb *u
 		out->number_of_packets = outframe;
 		out->transfer_flags = URB_ISO_ASAP;
 		usb_submit_urb(out, GFP_ATOMIC);
+	} else {
+		struct snd_usb_caiaq_cb_info *oinfo = out->context;
+		clear_bit(oinfo->index, &dev->outurb_active_mask);
 	}
 
+requeue:
 	/* re-submit inbound urb */
 	for (frame = 0; frame < FRAMES_PER_URB; frame++) {
 		urb->iso_frame_desc[frame].offset = BYTES_PER_FRAME * frame;
@@ -532,6 +550,8 @@ static void write_completed(struct urb *
 		dev->output_running = 1;
 		wake_up(&dev->prepare_wait_queue);
 	}
+
+	clear_bit(info->index, &dev->outurb_active_mask);
 }
 
 static struct urb **alloc_urbs(struct snd_usb_caiaqdev *dev, int dir, int *ret)
@@ -682,6 +702,9 @@ int snd_usb_caiaq_audio_init(struct snd_
 	if (!dev->data_cb_info)
 		return -ENOMEM;
 
+	dev->outurb_active_mask = 0;
+	BUILD_BUG_ON(N_URBS > (sizeof(dev->outurb_active_mask) * 8));
+
 	for (i = 0; i < N_URBS; i++) {
 		dev->data_cb_info[i].dev = dev;
 		dev->data_cb_info[i].index = i;
--- a/sound/usb/caiaq/device.h
+++ b/sound/usb/caiaq/device.h
@@ -92,6 +92,7 @@ struct snd_usb_caiaqdev {
 	int input_panic, output_panic, warned;
 	char *audio_in_buf, *audio_out_buf;
 	unsigned int samplerates, bpp;
+	unsigned long outurb_active_mask;
 
 	struct snd_pcm_substream *sub_playback[MAX_STREAMS];
 	struct snd_pcm_substream *sub_capture[MAX_STREAMS];


