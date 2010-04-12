Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab0DLMyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 08:54:31 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:50159 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab0DLMy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 08:54:29 -0400
Date: Mon, 12 Apr 2010 14:54:21 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Pedro Ribeiro <pedrib@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org,
       linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100412125421.GX30801@buzzloop.caiaq.de>
References: <20100407090623.GN30807@buzzloop.caiaq.de>
 <Pine.LNX.4.44L0.1004071036060.1779-100000@iolanthe.rowland.org>
 <87sk719hbm.fsf@basil.nowhere.org>
 <20100412111439.GU30801@buzzloop.caiaq.de>
 <20100412115300.GM18855@one.firstfloor.org>
 <q2z74fd948d1004120511hebf19eaauc41ee9ed25dea19e@mail.gmail.com>
 <20100412121243.GN18855@one.firstfloor.org>
 <20100412123238.GW30801@buzzloop.caiaq.de>
 <20100412124708.GO18855@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100412124708.GO18855@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 02:47:08PM +0200, Andi Kleen wrote:
> On Mon, Apr 12, 2010 at 02:32:38PM +0200, Daniel Mack wrote:
> > Another detail I can't explain is that on his machine, the kernel oopses
> > when kmalloc() with GFP_DMA32 is used. The patch to try this also only
> > touched the allocation in sound/usb/caiaq/audio.c.
> 
> Where did it oops?

Pedro sent me an image:

  http://caiaq.de/download/tmp/GFP_DMA32.JPG

The patch I sent him for testing and that lead to this Oops was:

> diff --git a/sound/usb/caiaq/audio.c b/sound/usb/caiaq/audio.c                                                                              
> index 4328cad..26013be 100644                                                                                                               
> --- a/sound/usb/caiaq/audio.c                                                                                                               
> +++ b/sound/usb/caiaq/audio.c                                                                                                               
> @@ -560,7 +560,7 @@ static struct urb **alloc_urbs(struct snd_usb_caiaqdev *dev, int dir, int *ret)                                         
>                }                                                                                                                            
>                                                                                                                                             
>                urbs[i]->transfer_buffer =                                                                                                   
> -                       kmalloc(FRAMES_PER_URB * BYTES_PER_FRAME, GFP_KERNEL);                                                              
> +                       kmalloc(FRAMES_PER_URB * BYTES_PER_FRAME, GFP_KERNEL | GFP_DMA32);                                                  
>                if (!urbs[i]->transfer_buffer) {                                                                                             
>                        log("unable to kmalloc() transfer buffer, OOM!?\n");                                                                 
>                        *ret = -ENOMEM;                                                                                                      
>                                                                                                                                             


> >   http://caiaq.de/download/tmp/pedro-dmesg
> 
> The system seems to set up the soft iotlb correctly.
> 
> [    0.468472] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.468539] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
> [    0.468610] software IO TLB at phys 0x20000000 - 0x24000000
> 
> Also if that was wrong a lot more things would go wrong.
> 
> I would suspect the driver. Are you sure:
> 
> - it sets up it's dma_masks correctly?
> - it uses pci_map_single/sg correctly for all transferred data?

Well, the sound driver itself doesn't care for any of those things, just
like any other USB driver doesn't. The USB core itself of the host
controller driver should do, and as far as I can see, it does that, yes.

Daniel

