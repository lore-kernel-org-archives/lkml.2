Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab0DIXiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 19:38:16 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:50149 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab0DIXiO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 19:38:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GDdBkhbnxj554omlBi84bdf2n6M1TgKx5AVXOnxvycf9gmK5GjV4dfgQEJwyVMY4IN
         5gYZ8mKSQL3ECYUeXu4e2bakBba5YJr8M6Xkbt6hqaQ4yI9PLikT36I5u4wS5256pvd1
         FrOLVfoxbKZ3n8jmgzM69ViyXej8UzX1At5TE=
MIME-Version: 1.0
In-Reply-To: <20100409165014.GC5184@xanatos>
References: <s5hhbnncflj.wl%tiwai@suse.de>
	 <Pine.LNX.4.44L0.1004071452560.5760-100000@iolanthe.rowland.org>
	 <20100408003313.GE4365@kroah.com> <4BBE6E57.6020600@gmail.com>
	 <20100409165014.GC5184@xanatos>
Date: Fri, 9 Apr 2010 17:38:13 -0600
Message-ID: <g2u51f3faa71004091638nc383aa0ei899777c869273a22@mail.gmail.com>
Subject: Re: USB transfer_buffer allocations on 64bit systems
From: Robert Hancock <hancockrwd@gmail.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       alsa-devel@alsa-project.org, linux-usb@vger.kernel.org,
       Takashi Iwai <tiwai@suse.de>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Pedro Ribeiro <pedrib@gmail.com>,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 9, 2010 at 10:50 AM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
>> >>I don't know if the comment is still true, but until the "#if 0" is
>> >>removed, ehci-hcd won't make use of 64-bit DMA.
>> >
>> >I think someone tried to remove it recently, but I wouldn't let them :)
>> >
>> >What a mess, hopefully xhci will just take over and save the world from
>> >this whole thing...
>
> I hate to break it to you, but 64-bit DMA support is optional for an
> xHCI implementation.  There's a bit in HCCPARAMS that tells whether the
> host supports it (see the HCC_64BIT_ADDR macro in xhci.h).  The xHCI
> driver currently doesn't do anything with that bit, although it should.
> All the implementations I've seen do 64-bit DMA.
>
>> True.. except for the fact that the xhci driver currently doesn't do
>> 64-bit DMA either
>
> What makes you think that?  I've seen URB buffers with 64-bit DMA
> addresses.  I can tell when the debug polling loop runs and I look at
> the DMA addresses the xHCI driver is feeding to the hardware:
>
> Dev 1 endpoint ring 0:
> xhci_hcd 0000:05:00.0: @71a49800 01000680 00080000 00000008 00000841
>
> So the TRB at address 71a49800 is pointing to a buffer at address
> 0x0008000001000680.

I'm not sure why the address would be that huge, unless it's not
actually a physical address, or there's some kind of remapping going
on?

>
> If I'm setting a DMA mask wrong somewhere, or doing something else to
> limit the DMA to 32-bit, then please let me know.

The DMA mask for the controller isn't being set anywhere (in the
version that's in Linus' current git anyway). In that case it'll
default to 32-bit and any DMA mappings above 4GB will need to be
remapped. The controller driver doesn't do the mapping itself but the
USB core does, passing in the controller device as the one doing the
DMA, so if the controller's DMA mask is set to 32-bit then the buffers
passed in will get remapped/bounced accordingly.

You should likely be setting the DMA mask for the controller device to
64-bit if the HCC_64BIT_ADDR flag is set, similar to the code in
ehci-hcd.c which is currently #if 0'ed out.

You can see the currently set mask in sysfs under
/sys/devices/pci(whatever)/dma_mask_bits.

>
>> nor does it support MSI even though the HW
>> supports it (surprisingly enough the NEC Windows driver does, MSI-X
>> even).
>
> There's a patch from AMD to enable MSI-X.  The code was there, just
> commented out because the early prototypes didn't do MSI-X.

Ah, I see it. That could presumably be tested now (the NEC D720200F1
chip on the Asus U3S6 card I have seems to support MSI-X with 8
vectors).

>
>> At this point only Intel likely knows how to do this
>> properly, though, since AFAICS the spec isn't publicly available
>> yet.
>
> I have tried very hard to fix this, and will continue to do so.
>
> Sarah Sharp
>
