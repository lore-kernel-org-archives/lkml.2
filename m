Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab0EGXyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 19:54:47 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:63816 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab0EGXyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 19:54:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lEVYbbKCWIt8mfdE8JKVMCMv3ZXVIlB1erCLPq+YSxsKZlOdC2M9Pkc/l7QbDzqkoK
         /csjx4H+ib/QMwa0yOWbZyUZo2/tXbXo9lahcGtDJ4xm6gv0IcG9Dzi9P9i91GWDP891
         +ztDbSucxu/2UP0bfHtol7ndj1AkeWlxtoAUI=
MIME-Version: 1.0
In-Reply-To: <x2j63386a3d1005070443yfadbaf3ct8686a8f7aae6412f@mail.gmail.com>
References: <1272848060-28049-1-git-send-email-linus.walleij@stericsson.com>
	 <i2t63386a3d1005070213u2ad32613w694be1ecbeb46856@mail.gmail.com>
	 <20100507093256.GB19936@n2100.arm.linux.org.uk>
	 <x2j63386a3d1005070443yfadbaf3ct8686a8f7aae6412f@mail.gmail.com>
Date: Fri, 7 May 2010 16:54:40 -0700
X-Google-Sender-Auth: fb9ee64ca74e765b
Message-ID: <x2se9c3a7c21005071654hb73e7314racd1e8ab432aff4a@mail.gmail.com>
Subject: Re: [PATCH 0/7] DMAENGINE: fixes and PrimeCells
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 7, 2010 at 4:43 AM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> 2010/5/7 Russell King - ARM Linux <linux@arm.linux.org.uk>:
>
>> I would have thought given the concerns that I stated, merely running
>> the drivers in PIO mode would not address those concerns.  So no, I'm
>> not satisfied.
>
> Sorry didn't get it, I understood it as it should be tested on the Versatile
> without regressions.
>
> So now I understand that you want the drivers to be tested in DMA mode
> on the ARM reference HW. Right?

Maybe I am also misunderstanding, but I think the concern is less
about "does the dma driver work" and more about exposing an api to dma
clients that is not expressive enough to handle architecture specific
quirks.  The dma provider can always be fixed up.  The "boxed in"
effect happens when there is non-trivial pile of dma client device
drivers using an api that is not expressive enough for a new ARM
platform

That being said I think the interface tweaks for device_control and
channel_status were relatively painless, and the one architecture
specific call we added seems like something that could never be
reconciled in a cross-architecture generic api.

> So in order for this to be accepted, I also have to implement
> support for the DMA controller found in the reference platforms from
> ARM, PL080 and PL081, since there is only this S3C-tilted driver
> in the kernel so far:
> arch/arm/mach-s3c64xx/dma.c
>
> This is hard for me to do since I have to try to lend a device to
> test it on.

I do not think this is a fair burden for you to carry, but it does
sound like Russell will come looking for you when he finds a
counter-example architecture that breaks the api assumptions.  The
multiplexing case seems to be the most challenging to the existing
model.  The idea to oversubscribe struct dma_chan's versus physical
channels seems workable... Russell is this the implementation you
would like to see pre-merge, or is a hand-wavy plan to address it
enough to let this initial implementation through?

> Anyway, I will see if I can lend the RealView machine again and
> play around a bit with patching up Bens driver to work with the
> DMAengine and show that it runs, in DMA mode, on the RealView,
> as a proof of concept. Would that be OK then?
>
>> As I've said, I don't want the ARM platforms to be boxed into a corner
>> such that they can never have DMA support because this stuff hasn't been
>> properly thought out.
>
> I'm thinking all I can, I promise. Perhaps I'm not smart enough all the
> time, it's a known problem, I'm working on it.
>
>> Or let me put it another way - if people are happy for Linux to support
>> new ARM CPU architectures, but with very little attention given to DMA
>> support on those architectures, then feel free to box the ARM platforms
>> into a corner on DMA support - but on the understanding that _you_ will
>> have to deal with the DMA API breakage on those architectures yourself.
>> Because with ARM platforms not having DMA support, there's absolutely
>> no way to run any checks what so ever on DMA when the CPU architecture
>> support is created.
>
> I'm doing the best I can to meet exactly this goal. The changes done in
> the DMA engine were done towards the end of making the DMA
> engine support *any* DMA controller for the PrimeCells, and I've proven
> it to be possible for two different architectures: U300 and U8500. These
> are totally different even though they're coming out of the same
> company (we *weren't* the same company when they were created!).
> One is ARM9 the other is Cortex A9 dualcore. One use a DMA silicon
> called COH901318 the other use a DMA silicon named DMA40.
>
> So now I guess I have to make it tick on the block known as PL080/PL081
> as well, and I'll have a try at it.
>
>> This is why people like the OMAP folk end up doing a lot of the DMA
>> debugging; they tend to be the first group to pick up new architectures
>> with fully functional platforms.
>
> Yep it seems we're going to have the same issue with Cortex A9 for
> U8500.
>
> Right now we're doing DMA debugging and testing on U300 and
> U8500 to make sure neither break as a result of these patches,
> and defining the API for the DMA engine.
>

Very reasonable and I am not seeing a merge blocking issue from the
dmaengine perspective at this point.  The dma_request_channel()
interface seems sufficient for all the needs to date as it basically
allows architectures to develop their own dma-provider-to-client
matching interface to override the generic memory-to-memory client
matching interface.  The 'slave' interface and the ->private parameter
of dma_chan (pending Jassi's recent fix) has proven sufficient for
handling association specific data.  These new patches establish a
model whereby once you know you are talking to your $ARCH dma driver
you can make driver specific calls to pass information that would be
too ugly to pass in a generic fashion.  I do not pretend that this is
an elegant arrangement, but it has proven to be functional.

I do have concerns about mapping device-to-device dma into a generic
api.  That's a whole new level of platform-specific crazy, but that is
not what these patches are about.

At the end of the day I still need Russell's ack/acceptance of the
platform_data infrastructure to move forward, but I'll get the
dmaengine bits queued into -next so it's at least ready to be pulled.

--
Dan
