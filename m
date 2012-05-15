Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965658Ab2EOC25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:28:57 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53551 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964897Ab2EOCSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:14 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 165/179] ALSA: snd_usb_caiaq: track submitted output urbs
Date: Mon, 14 May 2012 22:14:21 -0400
Message-ID: <1337048075-6132-166-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Mack <zonque@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/usb/caiaq/audio.c  |   31 +++++++++++++++++++++++++++----
 sound/usb/caiaq/device.h |    1 +
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/sound/usb/caiaq/audio.c b/sound/usb/caiaq/audio.c
index 75c8446..155d6d7 100644
--- a/sound/usb/caiaq/audio.c
+++ b/sound/usb/caiaq/audio.c
@@ -139,8 +139,12 @@ static void stream_stop(struct snd_usb_caiaqdev *dev)
 
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
@@ -467,8 +471,8 @@ static void read_completed(struct urb *urb)
 {
 	struct snd_usb_caiaq_cb_info *info = urb->context;
 	struct snd_usb_caiaqdev *dev;
-	struct urb *out;
-	int frame, len, send_it = 0, outframe = 0;
+	struct urb *out = NULL;
+	int i, frame, len, send_it = 0, outframe = 0;
 	size_t offset = 0;
 
 	if (urb->status || !info)
@@ -479,7 +483,17 @@ static void read_completed(struct urb *urb)
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
@@ -510,8 +524,12 @@ static void read_completed(struct urb *urb)
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
@@ -533,6 +551,8 @@ static void write_completed(struct urb *urb)
 		dev->output_running = 1;
 		wake_up(&dev->prepare_wait_queue);
 	}
+
+	clear_bit(info->index, &dev->outurb_active_mask);
 }
 
 static struct urb **alloc_urbs(struct snd_usb_caiaqdev *dev, int dir, int *ret)
@@ -683,6 +703,9 @@ int snd_usb_caiaq_audio_init(struct snd_usb_caiaqdev *dev)
 	if (!dev->data_cb_info)
 		return -ENOMEM;
 
+	dev->outurb_active_mask = 0;
+	BUILD_BUG_ON(N_URBS > (sizeof(dev->outurb_active_mask) * 8));
+
 	for (i = 0; i < N_URBS; i++) {
 		dev->data_cb_info[i].dev = dev;
 		dev->data_cb_info[i].index = i;
diff --git a/sound/usb/caiaq/device.h b/sound/usb/caiaq/device.h
index 44e3edf..94c0c36 100644
--- a/sound/usb/caiaq/device.h
+++ b/sound/usb/caiaq/device.h
@@ -92,6 +92,7 @@ struct snd_usb_caiaqdev {
 	int input_panic, output_panic, warned;
 	char *audio_in_buf, *audio_out_buf;
 	unsigned int samplerates, bpp;
+	unsigned long outurb_active_mask;
 
 	struct snd_pcm_substream *sub_playback[MAX_STREAMS];
 	struct snd_pcm_substream *sub_capture[MAX_STREAMS];
-- 
1.7.9.6

