Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab0DNKJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 06:09:53 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:47191 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab0DNKJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:09:52 -0400
Date: Wed, 14 Apr 2010 12:09:46 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org,
       linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100414100946.GS30807@buzzloop.caiaq.de>
References: <20100412162947.GQ18855@one.firstfloor.org>
 <Pine.LNX.4.44L0.1004121252310.1702-100000@iolanthe.rowland.org>
 <20100413182233.GR30807@buzzloop.caiaq.de>
 <k2o74fd948d1004131646k1e0e1897z7594f77a580c6b9f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <k2o74fd948d1004131646k1e0e1897z7594f77a580c6b9f@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 12:46:42AM +0100, Pedro Ribeiro wrote:
> On 13 April 2010 19:22, Daniel Mack <daniel@caiaq.de> wrote:
> > Some more ideas to nail this down would be to boot the machine with
> > mem=4096M and mem=2048M to see whether this makes any difference. Also,
> > I think it would be interesting to know whether the patch below helps.
> >
> > As the real reason seems entirely obfuscated, there's unfortunately need
> > for some trial error approach. Pedro, as you're the only one who can
> > actually reproduce the problem, do you see any chance to do that?
> >
> > Thanks,
> > Daniel
> >
> >
> > diff --git a/sound/usb/caiaq/audio.c b/sound/usb/caiaq/audio.c
> > index 4328cad..26013be 100644
> > --- a/sound/usb/caiaq/audio.c
> > +++ b/sound/usb/caiaq/audio.c
> > @@ -560,7 +560,7 @@ static struct urb **alloc_urbs(struct snd_usb_caiaqdev *dev, int dir, int *ret)
> >                }
> >
> >                urbs[i]->transfer_buffer =
> > -                       kmalloc(FRAMES_PER_URB * BYTES_PER_FRAME, GFP_KERNEL);
> > +                       kmalloc(FRAMES_PER_URB * BYTES_PER_FRAME, GFP_KERNEL | GFP_DMA);
> >                if (!urbs[i]->transfer_buffer) {
> >                        log("unable to kmalloc() transfer buffer, OOM!?\n");
> >                        *ret = -ENOMEM;
> >
> >
> 
> Good news, I can't trigger the interference with either:
> - mem=2048m
> - mem=4096m
> - your patch

Thanks! So the only thing I can do for now is submit exactly this patch.
At least, it helps you and it shouldn't break anything. The question
remains whether this type of memory should be used for all
transfer_buffers.

> Any idea why is mem=4096m different than a regular boot since I have 4GB anyway?

On Fri, Apr 09, 2010 at 04:11:52PM -0600, Robert Hancock wrote:
> If you have 4GB of RAM then almost certainly you have memory located
> at addresses over 4GB. If you look at the e820 memory map printed at
> the start of dmesg on bootup and see entries with addresses of
> 100000000 or higher reported as usable, then this is the case.

Could you post the these e820 line from your dmesg when booted with
mem=4096?

Daniel

