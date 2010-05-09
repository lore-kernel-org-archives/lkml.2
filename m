Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab0EIKGW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 06:06:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61612 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab0EIKGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 06:06:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KYPRXwfBXFaOq4g7necXW8uyK+GidPAJzLH7uJ+16LINp1K1sW1FJnga5JvtyVvDML
         8WNifXnwI1DWXushb0Y3rz+uS7W6PsU68ERlUkQRC+WwlTNJpIgJ09OtcI24u4hrroUD
         tYPESsY/iiipLJORUGF7eV7JGnuA6wZ77anag=
MIME-Version: 1.0
In-Reply-To: <h2ie9c3a7c21005090047lf1157930t9a625073c87e8cea@mail.gmail.com>
References: <1272848060-28049-1-git-send-email-linus.walleij@stericsson.com>
	 <i2t63386a3d1005070213u2ad32613w694be1ecbeb46856@mail.gmail.com>
	 <20100507093256.GB19936@n2100.arm.linux.org.uk>
	 <x2j63386a3d1005070443yfadbaf3ct8686a8f7aae6412f@mail.gmail.com>
	 <j2r1b68c6791005070531u57b4b1basc56d45d0e06b1d04@mail.gmail.com>
	 <k2k63386a3d1005070910kcdb516dcga60c24043b1b44de@mail.gmail.com>
	 <m2u1b68c6791005071937s5b2bbb60p6de395a6c06a963e@mail.gmail.com>
	 <w2re9c3a7c21005081524z2a52a078nad8d316553dfde80@mail.gmail.com>
	 <l2j1b68c6791005082048j5deaf863g2887c968ff841f2f@mail.gmail.com>
	 <h2ie9c3a7c21005090047lf1157930t9a625073c87e8cea@mail.gmail.com>
Date: Sun, 9 May 2010 19:06:17 +0900
Message-ID: <l2r1b68c6791005090306ld948bebfqa1e7d22321e302aa@mail.gmail.com>
Subject: Re: [PATCH 0/7] DMAENGINE: fixes and PrimeCells
From: jassi brar <jassisinghbrar@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 9, 2010 at 4:47 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Sat, May 8, 2010 at 8:48 PM, jassi brar <jassisinghbrar@gmail.com> wrote:
>> On Sun, May 9, 2010 at 7:24 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>>> On Fri, May 7, 2010 at 7:37 PM, jassi brar <jassisinghbrar@gmail.com> wrote:
>>>>  IMHO, a DMA api should be as quick as possible - callbacks done in IRQ context.
>>>>  But since there maybe clients that need to do sleepable stuff in
>>>
>>> None of the current clients sleep in the callback, it's done in
>>> soft-irq context.  The only expectation is that hard-irqs are enabled
>>> during the callback just like timer callbacks.  I also would like to
>>> see numbers to quantify the claims of slowness.
>> The clients evolve around the API so they don't do what the API doesn't
>> allow. Any API should try to put as least contraints as possible - you never
>> know what kinda clients are gonna arise.
>
> Running a callback in hard-irq context definitely puts constraints on
> the callback implementation to be as minimal as possible... and there
> is nothing stopping you from doing that today with the existing
> dmaengine interface: see idmac_interrupt.
We must plan for SoCs that have same peripheral IPs but different
DMACs. In that case, we have one client driver and two DMAC drivers
behind the same DMA API. So, if the DMA API doesn't fix such
assumptions, we can't have the driver to work for both SoCs.

>> Lets say a protocol requires 'quick' ACK(within few usecs) on control bus after
>> xfer'ing a large packet on data bus. All the client needs is to be
>> able to toggle
>> some bit of the device controller after the DMA done, which can very well be
>> done in IRQ context but maybe too late if the callback is done from a tasklet
>> scheduled from DMAC ISR.
>> The point being, a DMA API should be able to do callbacks from the IRQ context
>> too. That is, assuming the clients know what they do.
>
> You are confusing async_tx constraints and dmaengine.  If your driver
> is providing the backend of an async_tx operation (currently only
> md-raid acceleration) then md-raid can assume that the callback is
> being performed in an irq-enabled non-sleepable context.  If you are
> not providing an async_tx backend service then those constraints are
> lifted.  I think I would like to make this explicit
> CONFIG_DMA_SUPPORTS_ASYNC_TX option to clearly mark the intended use
> model of the dma controller.
Again, the client shouldn't need to know about the backend DMAC driver.
If some client can't stand 'async' ops, there should be some way for it to
ask DMA API and know.
IMHO, DMA API should see async_tx as a special 'relaxed' case. Adding
new flags to differentiate only complicate the client drivers.

>> Also, I think it is possible to have an API that allows request submission from
>> callbacks, which will be a very useful feature.
>> Of course, assuming the clients know what they can/can't do (just like current
>> DMA API or any other API).
>
> It's a driver specific implementation detail if it supports submission
> from the callback.  As a "general" rule clients should not assume that
> all drivers support this, but in the architecture specific case you
> know which driver you are talking to, so this should not be an issue.
Again, please look at the "Same client driver for different SoCs with
different DMACs" situation. DMA API needs to take a stand.

>>>> callbacks, the API
>>>>  may do two callbacks - 'quick' in irq context and 'lazy' from
>>>> tasklets scheduled from
>>>>  the IRQ. Most clients will provide either, while some may provide
>>>> both callback functions.
>>>>
>>>> b) There seems to be no clear way of reporting failed transfers. The
>>>> device_tx_status
>>>>    can get FAIL/SUCSESS but the call is open ended and can be performed
>>>>    without any time bound after tx_submit. It is not very optimal for
>>>> DMAC drivers
>>>>    to save descriptors of all failed transactions until the channel
>>>> is released.
>>>>    IMHO, provision of status checking by two mechanisms: cookie and dma-done
>>>>   callbacks is complication more than a feature. Perhaps the dma
>>>> engine could provide
>>>>   a default callback, should the client doesn't do so, and track
>>>> done/pending xfers
>>>>  for such requests?
>>>
>>> I agree the error handling was designed around mem-to-mem assumptions
>>> where failures are due to double-bit ECC errors and other rare events.
>> well, neither have I ever seen DMA failure, but a good API shouldn't count
>> upon h/w perfection.
>>
>
> It doesn't count on perfection, it treats failures the same way the
> cpu would react to a unhandled data abort i.e. panic.  I was thinking
> of a case like sata where you might see dma errors on a daily basis.
panic'ing is extreme reaction, esp when DMA API doesn't provide any
guarantee of time-bound operations - the client or API could simply
retry after taking appropriate action.

>>>> c) Conceptually, the channels are tightly coupled with the DMACs,
>>>> there seems to be
>>>>   no way to be able to schedule a channel among more than one DMACs
>>>> in the runtime,
>>>>   that is if more then one DMAC support the same channel/peripheral.
>>>>   For example, Samsung's S5Pxxxx have many channels available on more
>>>> than 1 DMAC
>>>>   but for this dma api we have to statically assign channels to
>>>> DMACs, which may result in
>>>>   a channel acquire request rejected just because the DMAC we chose
>>>> for it is already
>>>>   fully busy while another DMAC, which also supports the channel, is idling.
>>>>   Unless we treat the same peripheral as, say, I2STX_viaDMAC1 and
>>>> I2STX_viaDMAC2
>>>>   and allocate double resources for these "mutually exclusive" channels.
>>>
>>> I am not understanding this example.  If both DMACs are registered the
>>> dma_filter function to dma_request_channel() can select between them,
>>> right?
>> Let me be precise. I2S_Tx fifo(I2S peripheral/channel) can be be reached
>> by two DMACs but, of course, the channel can only be active with
>> exactly one DMAC.
>> So, it is desirable to be able to reach the peripheral via second DMAC should
>> the first one is too busy to handle the request. Clearly this is a
>> runtime decision.
>> FWIHS, I can associate the channel with either of the DMACs and if that DMAC
>> can't handle the I2S_Tx request (say due to its all h/w threads
>> allocated to other
>> request), I can't play audio even if the DMAC might be simply idling.
>>
>
> Ah ok, you want load balancing between channels.  In that case the 1:1
> nature of dma_request_channel() is not the right interface.  We would
> need to develop something like an architecture specific implementation
> of dma_find_channel() to allow dynamic channel allocation at runtime.
> But at that point we will have written something that is very
> architecture specific, how could we implement that in a generic api?
In S3C DMA API driver for PL330 DMAC, I add all unique channels and
DMACs to system wide channel and DMAC pool. DMACs have
a capability mask to help find which channels can be reached vai that DMAC.
That way it becomes possible to do runtime mapping of channels on
DMACs.
About current DMA API? I don't know any easy way. But is sure possible
to implement a generic API to do that.

> Basically if the driver does not want to present resources to generic
> clients, does want to use any of the existing generic channel
> allocation mechanisms, and has narrow platform-specific needs then why
> code to/extend a generic api?
Sometimes there is limit on the number of concurrrent channels that
the DMAC can handle. For ex, PL330 can have only 8 h/w threads but
32 possible peripherals/channels, allowing only max. 8 channels to be active
at any time. In such situations, the DMAC may refuse channel allocation
until some other client releases a channel thereby freeing up a h/w thread.

>>>> e) There seems to be no ScatterGather support for Mem to Mem transfers.
>>>
>>> There has never been a use case, what did you have in mind.  If
>>> multiple prep_memcpy commands is too inefficient we could always add
>>> another operation.
>> Just that I believe any API should be as exhaustive and generic as possible.
>> I see it possible for multimedia devices/drivers to evolve to start needing
>> such capabilities.
>> Also, the way DMA API treats memcpy/memset and assume SG reqs to be
>> equivalent to MEM<=>DEV request is not very impressive.
>> IMHO, any submitted request should be a list of xfers. And an xfer is a
>> 'memset' with 'src_len' bytes from 'src_addr' to be copied 'n' times
>> at 'dst_addr'.
>> Memcpy is just a special case of memset, where n := 1
>> This covers most possible use cases while being more compact and future-proof.
>
> No, memset is an operation that does not have a source address and
> instead writes a pattern.
That sounds like assuming memset to be writing a value multiple times.

Most DMACs come with optional SRC/DST increment bit to control the
copy operation. That makes memset nicely blend with memcpy requests.

Memset might not have source address, but for most DMACs the driver
would have to allocate 4 dma coherent bytes(if memset unit is int) and
treat it most likely as memcpy request with src_inc := 0 and dst_inc := 1
For DMACs that does support direct memset operation, there wud be a
limit on size of the pattern, making them 'lesser' flexible than those without
direct memset support.

So, IMHO, memset is better seen as writing a data pattern multiple times rather
than writing a value multiple times.
Because with clients and over time, the unit size may vary.
Lets not put limit on unit size for memset operation.
What if i want to set 1800 bytes of memory with a pattern of 9bytes?
200 memcpy requests OR allocate 9 dma coherent bytes and do 1 memset?

>  As for the sg support for mem-to-mem
> operations... like most things in Linux it was designed around its
> users and none of the users at the time (md-raid, net-dma) required
> scatter gather support.
Yes, but if a request is defined as a 'SG list of memset ops', we pay
no extra price for having capability for Mem to Mem SG. And one
doesn't need to look at the potential users for the API.
All DMAC drivers would have had just one 'prepare' rather than three.

> Without seeing code its hard to make a judgment on what can and cannot
> fit in dmaengine, but it needs to be judged on what fits in a generic
> api and the feasibility of forcing mem-to-mem device-to-mem and
> device-to-device dma into one api.  I am skeptical we can address all
> those concerns, but we at least have something passably functional for
> the first two.
I admit I have little idea about Dev->Dev implementation, but the other two
should be possible to implement in a generic way.
This discussion is purely about what the current DMA API misses and what
a generic DMA API should do. So, that the current DMA API fills up those
gap, if possible. I would love to get started implementing the generic
DMA API for reference but my priorities are decided by my employer.

>  On the other hand, it's perfectly sane for subarchs
> like pxa to have their own dma api.  If at the end of the day all that
> matters is $arch-specific-dma then why mess around with a generic api?
This is unlikely to hold for long. SoCs are more and more becoming a
cocktail of off-the-shelf third party device IPs, where the device IPs may
be same but different DMAC IP.

Regards.
