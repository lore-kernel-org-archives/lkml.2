Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab0DMSWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:22:51 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:37512 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab0DMSWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:22:48 -0400
Date: Tue, 13 Apr 2010 20:22:33 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andi Kleen <andi@firstfloor.org>, Pedro Ribeiro <pedrib@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org,
       linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100413182233.GR30807@buzzloop.caiaq.de>
References: <20100412162947.GQ18855@one.firstfloor.org>
 <Pine.LNX.4.44L0.1004121252310.1702-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.1004121252310.1702-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 12:57:16PM -0400, Alan Stern wrote:
> On Mon, 12 Apr 2010, Andi Kleen wrote:
> > On Mon, Apr 12, 2010 at 12:17:22PM -0400, Alan Stern wrote:
> > > On Mon, 12 Apr 2010, Andi Kleen wrote:
> > >
> > > > > Well, the sound driver itself doesn't care for any of those things, just
> > > > > like any other USB driver doesn't. The USB core itself of the host
> > > > > controller driver should do, and as far as I can see, it does that, yes.
> > > >
> > > > Hmm, still things must go wrong somewhere. Perhaps need some instrumentation
> > > > to see if all the transfer buffers really hit the PCI mapping functions.
> > >
> > > Such a test has already been carried out earlier in this thread:
> > >
> > > 	http://marc.info/?l=linux-usb&m=127074587029353&w=2
> > > 	http://marc.info/?l=linux-usb&m=127076841801051&w=2
> > > 	http://marc.info/?l=linux-usb&m=127082890510415&w=2
> >
> > Hmm, thanks. But things must still go wrong somewhere, otherwise
> > the GFP_DMA32 wouldn't be needed?
>
> Indeed, something must go wrong somewhere.  Since Daniel's patch fixed
> the problem by changing the buffer from a streaming mapping to a
> coherent mapping, it's logical to assume that bad DMA addresses have
> something to do with it.  But we don't really know for certain.

Some more ideas to nail this down would be to boot the machine with
mem=4096M and mem=2048M to see whether this makes any difference. Also,
I think it would be interesting to know whether the patch below helps.

As the real reason seems entirely obfuscated, there's unfortunately need
for some trial error approach. Pedro, as you're the only one who can
actually reproduce the problem, do you see any chance to do that?

Thanks,
Daniel


diff --git a/sound/usb/caiaq/audio.c b/sound/usb/caiaq/audio.c
index 4328cad..26013be 100644
--- a/sound/usb/caiaq/audio.c
+++ b/sound/usb/caiaq/audio.c
@@ -560,7 +560,7 @@ static struct urb **alloc_urbs(struct snd_usb_caiaqdev *dev, int dir, int *ret)
               }

               urbs[i]->transfer_buffer =
-                       kmalloc(FRAMES_PER_URB * BYTES_PER_FRAME, GFP_KERNEL);
+                       kmalloc(FRAMES_PER_URB * BYTES_PER_FRAME, GFP_KERNEL | GFP_DMA);
               if (!urbs[i]->transfer_buffer) {
                       log("unable to kmalloc() transfer buffer, OOM!?\n");
                       *ret = -ENOMEM;

