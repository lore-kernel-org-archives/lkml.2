Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab0D3RIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:08:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57405 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758518Ab0D3RHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:07:33 -0400
Date: Fri, 30 Apr 2010 15:51:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel Mack <daniel@caiaq.de>, Takashi Iwai <tiwai@suse.de>
Subject: linux-next: manual merge of the usb tree with the sound tree
Message-Id: <20100430155134.a35db59a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
sound/usb/usbaudio.c between commit
e5779998bf8b70e48a6cc208c8b61b33bd6117ea ("ALSA: usb-audio: refactor
code") from the sound tree and commit
3cc96f50329227fbf34de2459491901b6ee1c98c ("USB: rename usb_buffer_alloc()
and usb_buffer_free() users") from the usb tree.

The former moved the relevant code from usbaudio.c to urb.c, so I applied
the changes from the latter to that (see below).
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 30 Apr 2010 14:44:54 +1000
Subject: [PATCH] sound: fixup for usb_buffer_alloc/free rename

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 sound/usb/urb.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/usb/urb.c b/sound/usb/urb.c
index 5570a2b..de607d4 100644
--- a/sound/usb/urb.c
+++ b/sound/usb/urb.c
@@ -101,7 +101,7 @@ static void release_urb_ctx(struct snd_urb_ctx *u)
 {
 	if (u->urb) {
 		if (u->buffer_size)
-			usb_buffer_free(u->subs->dev, u->buffer_size,
+			usb_free_coherent(u->subs->dev, u->buffer_size,
 					u->urb->transfer_buffer,
 					u->urb->transfer_dma);
 		usb_free_urb(u->urb);
@@ -154,7 +154,7 @@ void snd_usb_release_substream_urbs(struct snd_usb_substream *subs, int force)
 		release_urb_ctx(&subs->dataurb[i]);
 	for (i = 0; i < SYNC_URBS; i++)
 		release_urb_ctx(&subs->syncurb[i]);
-	usb_buffer_free(subs->dev, SYNC_URBS * 4,
+	usb_free_coherent(subs->dev, SYNC_URBS * 4,
 			subs->syncbuf, subs->sync_dma);
 	subs->syncbuf = NULL;
 	subs->nurbs = 0;
@@ -308,8 +308,8 @@ int snd_usb_init_substream_urbs(struct snd_usb_substream *subs,
 		if (!u->urb)
 			goto out_of_memory;
 		u->urb->transfer_buffer =
-			usb_buffer_alloc(subs->dev, u->buffer_size, GFP_KERNEL,
-					 &u->urb->transfer_dma);
+			usb_alloc_coherent(subs->dev, u->buffer_size,
+					   GFP_KERNEL, &u->urb->transfer_dma);
 		if (!u->urb->transfer_buffer)
 			goto out_of_memory;
 		u->urb->pipe = subs->datapipe;
@@ -321,7 +321,7 @@ int snd_usb_init_substream_urbs(struct snd_usb_substream *subs,
 
 	if (subs->syncpipe) {
 		/* allocate and initialize sync urbs */
-		subs->syncbuf = usb_buffer_alloc(subs->dev, SYNC_URBS * 4,
+		subs->syncbuf = usb_alloc_coherent(subs->dev, SYNC_URBS * 4,
 						 GFP_KERNEL, &subs->sync_dma);
 		if (!subs->syncbuf)
 			goto out_of_memory;
-- 
1.7.1
