Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab0EGHtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 03:49:05 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:36559 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab0EGHtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 03:49:01 -0400
Date: Fri, 7 May 2010 09:48:55 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Pedro Ribeiro <pedrib@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
       Chris Wright <chrisw@sous-sol.org>,
       David Woodhouse <dwmw2@infradead.org>,
       USB list <linux-usb@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       iommu@lists.linux-foundation.org,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       alsa-devel@alsa-project.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100507074855.GF30801@buzzloop.caiaq.de>
References: <g2h74fd948d1004141820ladc1941eo732d059dd678df0a@mail.gmail.com>
 <Pine.LNX.4.44L0.1004151114490.1562-100000@iolanthe.rowland.org>
 <t2r74fd948d1004191716l49dedc2p25a27da39bcc614a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <t2r74fd948d1004191716l49dedc2p25a27da39bcc614a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 01:16:58AM +0100, Pedro Ribeiro wrote:
> On 15 April 2010 16:20, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Thu, 15 Apr 2010, Pedro Ribeiro wrote:
> >
> >> I enabled  CONFIG_DMAR_BROKEN_GFX_WA=y and the result is the same. A
> >> delay in the boot process and usb devices don't work properly,
> >> including my USB mouse.
> >>
> >> Strange, since you have the same platform as me. The extra usb devices
> >> you were seeing are because of my docking station - but it makes no
> >> difference whether I'm docked or not for the purposes of the original
> >> bug or this situation right now. The dmesg I'm attaching is without
> >> the computer being docked.
> >
> > It's not possible to determine the reason for the timeout errors
> > between timestamps 16 and 53 from the small amount of debugging
> > information in the log.  Clearly something is going wrong with the
> > communication between the computer and the EHCI controller.  And
> > clearly the kernel config changes are responsible.
> >
> > But I don't know what to do to track it down any farther.
> >
> > Alan Stern
> >
> >
> 
> I guess this is pretty much a dead end until anyone else can reproduce it!

Hmm, I think I finally found the reason for all this confusion. No idea
why I didn't come up with the following explanation any earlier.

The problem is again (summarized):

On 64bit machines, with 4GB or more, the allocated buffers for USB
transfers might be beyond the 32bit boundary. In this case, the IOMMU
should take care and install DMA bounce buffer to copy over the buffer
before the transfer actually happens. The problem is, however, that this
copy mechanism takes place when the URB with its associated buffer is
submitted, not when the EHCI will actually do the transfer.

In the particular case of audio drivers, though, the contents of the
buffers are likely to change after the submission. What we do here
is that we map the audio stream buffers which are used by ALSA to
the output URBs, so they're filled asychronously. Once the buffer is
actually sent out on the bus, it is believed to contain proper audio
date. If it doesn't, that's due to too tight audio timing or other
problems. This breaks once buffers are magically bounced in the
background.

So - long story short: these audio buffers need to be DMA coherent.

The patch below does that, and Pedro excessively tested this patch for
weeks now :) It was just the final explanation _why_ it does the right
thing that was yet missing.

If nobody has objections, can we still squeeze it into .34?

Thanks,
Daniel


>From 5672ca44b9b4617f6c29c88409da13b1bf475547 Mon Sep 17 00:00:00 2001
From: Daniel Mack <daniel@caiaq.de>
Date: Wed, 7 Apr 2010 01:03:09 +0200
Subject: [PATCH] ALSA: usb/caiaq: use usb_buffer_alloc()

Use usb_buffer_alloc() and usb_buffer_free() for transfer buffers.
We need DMA-coherent memory in this case as buffer contents are likely
to be modified after the URB was submitted, because the URB buffers
are mapped to the audio streams.

On x86_64, buffers allocated with kmalloc() may be beyond the boundaries
of 32bit accessible memory, and DMA bounce buffers will live at other
locations, unaccessible by the driver, and hence outside of the audio
buffer mapping.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Tested-by: Pedro Ribeiro <pedrib@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>
Cc: iommu@lists.linux-foundation.org
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Cc: USB list <linux-usb@vger.kernel.org>
Cc: stable@kernel.org
---
 sound/usb/caiaq/audio.c |   57 ++++++++++++++++++++++++++--------------------
 1 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/sound/usb/caiaq/audio.c b/sound/usb/caiaq/audio.c
index 4328cad..adbeefd 100644
--- a/sound/usb/caiaq/audio.c
+++ b/sound/usb/caiaq/audio.c
@@ -552,46 +552,47 @@ static struct urb **alloc_urbs(struct snd_usb_caiaqdev *dev, int dir, int *ret)
 	}
 
 	for (i = 0; i < N_URBS; i++) {
-		urbs[i] = usb_alloc_urb(FRAMES_PER_URB, GFP_KERNEL);
-		if (!urbs[i]) {
+		struct urb *u = usb_alloc_urb(FRAMES_PER_URB, GFP_KERNEL);
+		if (!u) {
 			log("unable to usb_alloc_urb(), OOM!?\n");
 			*ret = -ENOMEM;
 			return urbs;
 		}
 
-		urbs[i]->transfer_buffer =
-			kmalloc(FRAMES_PER_URB * BYTES_PER_FRAME, GFP_KERNEL);
-		if (!urbs[i]->transfer_buffer) {
-			log("unable to kmalloc() transfer buffer, OOM!?\n");
+		urbs[i] = u;
+		u->dev = usb_dev;
+		u->pipe = pipe;
+		u->transfer_buffer_length =
+				FRAMES_PER_URB * BYTES_PER_FRAME;
+		u->context = &dev->data_cb_info[i];
+		u->interval = 1;
+		u->transfer_flags = URB_ISO_ASAP;
+		u->number_of_packets = FRAMES_PER_URB;
+		u->complete = (dir == SNDRV_PCM_STREAM_CAPTURE) ?
+					read_completed : write_completed;
+		u->transfer_buffer = usb_alloc_coherent(usb_dev,
+							u->transfer_buffer_length,
+							GFP_KERNEL, &u->transfer_dma);
+		if (!u->transfer_buffer) {
+			log("usb_alloc_coherent() failed, OOM!?\n");
 			*ret = -ENOMEM;
 			return urbs;
 		}
 
 		for (frame = 0; frame < FRAMES_PER_URB; frame++) {
 			struct usb_iso_packet_descriptor *iso =
-				&urbs[i]->iso_frame_desc[frame];
+					&u->iso_frame_desc[frame];
 
 			iso->offset = BYTES_PER_FRAME * frame;
 			iso->length = BYTES_PER_FRAME;
 		}
-
-		urbs[i]->dev = usb_dev;
-		urbs[i]->pipe = pipe;
-		urbs[i]->transfer_buffer_length = FRAMES_PER_URB
-						* BYTES_PER_FRAME;
-		urbs[i]->context = &dev->data_cb_info[i];
-		urbs[i]->interval = 1;
-		urbs[i]->transfer_flags = URB_ISO_ASAP;
-		urbs[i]->number_of_packets = FRAMES_PER_URB;
-		urbs[i]->complete = (dir == SNDRV_PCM_STREAM_CAPTURE) ?
-					read_completed : write_completed;
 	}
 
 	*ret = 0;
 	return urbs;
 }
 
-static void free_urbs(struct urb **urbs)
+static void free_urbs(struct usb_device *usb_dev, struct urb **urbs)
 {
 	int i;
 
@@ -603,7 +604,10 @@ static void free_urbs(struct urb **urbs)
 			continue;
 
 		usb_kill_urb(urbs[i]);
-		kfree(urbs[i]->transfer_buffer);
+		usb_free_coherent(usb_dev,
+				  urbs[i]->transfer_buffer_length,
+				  urbs[i]->transfer_buffer,
+				  urbs[i]->transfer_dma);
 		usb_free_urb(urbs[i]);
 	}
 
@@ -613,6 +617,7 @@ static void free_urbs(struct urb **urbs)
 int snd_usb_caiaq_audio_init(struct snd_usb_caiaqdev *dev)
 {
 	int i, ret;
+	struct usb_device *usb_dev = dev->chip.dev;
 
 	dev->n_audio_in  = max(dev->spec.num_analog_audio_in,
 			       dev->spec.num_digital_audio_in) /
@@ -689,15 +694,15 @@ int snd_usb_caiaq_audio_init(struct snd_usb_caiaqdev *dev)
 	dev->data_urbs_in = alloc_urbs(dev, SNDRV_PCM_STREAM_CAPTURE, &ret);
 	if (ret < 0) {
 		kfree(dev->data_cb_info);
-		free_urbs(dev->data_urbs_in);
+		free_urbs(usb_dev, dev->data_urbs_in);
 		return ret;
 	}
 
 	dev->data_urbs_out = alloc_urbs(dev, SNDRV_PCM_STREAM_PLAYBACK, &ret);
 	if (ret < 0) {
 		kfree(dev->data_cb_info);
-		free_urbs(dev->data_urbs_in);
-		free_urbs(dev->data_urbs_out);
+		free_urbs(usb_dev, dev->data_urbs_in);
+		free_urbs(usb_dev, dev->data_urbs_out);
 		return ret;
 	}
 
@@ -706,10 +711,12 @@ int snd_usb_caiaq_audio_init(struct snd_usb_caiaqdev *dev)
 
 void snd_usb_caiaq_audio_free(struct snd_usb_caiaqdev *dev)
 {
+	struct usb_device *usb_dev = dev->chip.dev;
+
 	debug("%s(%p)\n", __func__, dev);
 	stream_stop(dev);
-	free_urbs(dev->data_urbs_in);
-	free_urbs(dev->data_urbs_out);
+	free_urbs(usb_dev, dev->data_urbs_in);
+	free_urbs(usb_dev, dev->data_urbs_out);
 	kfree(dev->data_cb_info);
 }
 
-- 
1.7.1

