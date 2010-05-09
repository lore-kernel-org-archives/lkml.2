Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab0EIHrX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 03:47:23 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49296 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab0EIHrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 03:47:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OYquqIqQsP8IFMWWsFrDfQgUzsKWpzbxHR5KOlWJc4/uNZWn1Dm6eWpVIG+8kBiqjd
         bEBk12D7ZwfUf02YeBTj5jBC/fi21VO6VqpE8N4cwT2JFvg/YcVmSVVBjL+PSkEeUVul
         agmJPbX4rByOPrBdDR4WMT3CT6uGehqTpOITk=
MIME-Version: 1.0
In-Reply-To: <l2j1b68c6791005082048j5deaf863g2887c968ff841f2f@mail.gmail.com>
References: <1272848060-28049-1-git-send-email-linus.walleij@stericsson.com>
	 <i2t63386a3d1005070213u2ad32613w694be1ecbeb46856@mail.gmail.com>
	 <20100507093256.GB19936@n2100.arm.linux.org.uk>
	 <x2j63386a3d1005070443yfadbaf3ct8686a8f7aae6412f@mail.gmail.com>
	 <j2r1b68c6791005070531u57b4b1basc56d45d0e06b1d04@mail.gmail.com>
	 <k2k63386a3d1005070910kcdb516dcga60c24043b1b44de@mail.gmail.com>
	 <m2u1b68c6791005071937s5b2bbb60p6de395a6c06a963e@mail.gmail.com>
	 <w2re9c3a7c21005081524z2a52a078nad8d316553dfde80@mail.gmail.com>
	 <l2j1b68c6791005082048j5deaf863g2887c968ff841f2f@mail.gmail.com>
Date: Sun, 9 May 2010 00:47:20 -0700
X-Google-Sender-Auth: 1c2edec2d790deeb
Message-ID: <h2ie9c3a7c21005090047lf1157930t9a625073c87e8cea@mail.gmail.com>
Subject: Re: [PATCH 0/7] DMAENGINE: fixes and PrimeCells
From: Dan Williams <dan.j.williams@intel.com>
To: jassi brar <jassisinghbrar@gmail.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 8, 2010 at 8:48 PM, jassi brar <jassisinghbrar@gmail.com> wrote:
> On Sun, May 9, 2010 at 7:24 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Fri, May 7, 2010 at 7:37 PM, jassi brar <jassisinghbrar@gmail.com> wrote:
>>>  IMHO, a DMA api should be as quick as possible - callbacks done in IRQ context.
>>>  But since there maybe clients that need to do sleepable stuff in
>>
>> None of the current clients sleep in the callback, it's done in
>> soft-irq context.  The only expectation is that hard-irqs are enabled
>> during the callback just like timer callbacks.  I also would like to
>> see numbers to quantify the claims of slowness.
> The clients evolve around the API so they don't do what the API doesn't
> allow. Any API should try to put as least contraints as possible - you never
> know what kinda clients are gonna arise.

Running a callback in hard-irq context definitely puts constraints on
the callback implementation to be as minimal as possible... and there
is nothing stopping you from doing that today with the existing
dmaengine interface: see idmac_interrupt.

> Lets say a protocol requires 'quick' ACK(within few usecs) on control bus after
> xfer'ing a large packet on data bus. All the client needs is to be
> able to toggle
> some bit of the device controller after the DMA done, which can very well be
> done in IRQ context but maybe too late if the callback is done from a tasklet
> scheduled from DMAC ISR.
> The point being, a DMA API should be able to do callbacks from the IRQ context
> too. That is, assuming the clients know what they do.

You are confusing async_tx constraints and dmaengine.  If your driver
is providing the backend of an async_tx operation (currently only
md-raid acceleration) then md-raid can assume that the callback is
being performed in an irq-enabled non-sleepable context.  If you are
not providing an async_tx backend service then those constraints are
lifted.  I think I would like to make this explicit
CONFIG_DMA_SUPPORTS_ASYNC_TX option to clearly mark the intended use
model of the dma controller.

> Also, I think it is possible to have an API that allows request submission from
> callbacks, which will be a very useful feature.
> Of course, assuming the clients know what they can/can't do (just like current
> DMA API or any other API).

It's a driver specific implementation detail if it supports submission
from the callback.  As a "general" rule clients should not assume that
all drivers support this, but in the architecture specific case you
know which driver you are talking to, so this should not be an issue.

>
>
>>> callbacks, the API
>>>  may do two callbacks - 'quick' in irq context and 'lazy' from
>>> tasklets scheduled from
>>>  the IRQ. Most clients will provide either, while some may provide
>>> both callback functions.
>>>
>>> b) There seems to be no clear way of reporting failed transfers. The
>>> device_tx_status
>>>    can get FAIL/SUCSESS but the call is open ended and can be performed
>>>    without any time bound after tx_submit. It is not very optimal for
>>> DMAC drivers
>>>    to save descriptors of all failed transactions until the channel
>>> is released.
>>>    IMHO, provision of status checking by two mechanisms: cookie and dma-done
>>>   callbacks is complication more than a feature. Perhaps the dma
>>> engine could provide
>>>   a default callback, should the client doesn't do so, and track
>>> done/pending xfers
>>>  for such requests?
>>
>> I agree the error handling was designed around mem-to-mem assumptions
>> where failures are due to double-bit ECC errors and other rare events.
> well, neither have I ever seen DMA failure, but a good API shouldn't count
> upon h/w perfection.
>

It doesn't count on perfection, it treats failures the same way the
cpu would react to a unhandled data abort i.e. panic.  I was thinking
of a case like sata where you might see dma errors on a daily basis.

>
>>> c) Conceptually, the channels are tightly coupled with the DMACs,
>>> there seems to be
>>>   no way to be able to schedule a channel among more than one DMACs
>>> in the runtime,
>>>   that is if more then one DMAC support the same channel/peripheral.
>>>   For example, Samsung's S5Pxxxx have many channels available on more
>>> than 1 DMAC
>>>   but for this dma api we have to statically assign channels to
>>> DMACs, which may result in
>>>   a channel acquire request rejected just because the DMAC we chose
>>> for it is already
>>>   fully busy while another DMAC, which also supports the channel, is idling.
>>>   Unless we treat the same peripheral as, say, I2STX_viaDMAC1 and
>>> I2STX_viaDMAC2
>>>   and allocate double resources for these "mutually exclusive" channels.
>>
>> I am not understanding this example.  If both DMACs are registered the
>> dma_filter function to dma_request_channel() can select between them,
>> right?
> Let me be precise. I2S_Tx fifo(I2S peripheral/channel) can be be reached
> by two DMACs but, of course, the channel can only be active with
> exactly one DMAC.
> So, it is desirable to be able to reach the peripheral via second DMAC should
> the first one is too busy to handle the request. Clearly this is a
> runtime decision.
> FWIHS, I can associate the channel with either of the DMACs and if that DMAC
> can't handle the I2S_Tx request (say due to its all h/w threads
> allocated to other
> request), I can't play audio even if the DMAC might be simply idling.
>

Ah ok, you want load balancing between channels.  In that case the 1:1
nature of dma_request_channel() is not the right interface.  We would
need to develop something like an architecture specific implementation
of dma_find_channel() to allow dynamic channel allocation at runtime.
But at that point we will have written something that is very
architecture specific, how could we implement that in a generic api?

Basically if the driver does not want to present resources to generic
clients, does want to use any of the existing generic channel
allocation mechanisms, and has narrow platform-specific needs then why
code to/extend a generic api?

For example the ppe440 dma driver had architecture specific allocation
requirements (see arch/powerpc/include/asm/async_tx.h), but it still
wanted to service generic clients.

>>> d) Something like circular-linked-request is highly desirable for one
>>> of the important DMA
>>>   clients i.e, audio.
>>
>> Is this a standing dma chain that periodically a client will say "go"
>> to re-run those operations?  Please enlighten me, I've never played
>> with audio drivers.
> Yes, quite similar. Only alsa drivers will say "go" just once at playback start
> and the submitted xfer requests(called periods) are repeatedly transfered in
> circular manner.
> Just a quick snd_pcm_period_elapsed is called in dma-done callback for
> each request(which are usually the same length).
> That way, the client neither have to re-submit requests nor need to do sleepable
> stuff(allocating memory for new reqs and managing local state machine)
> The minimum period size depends on audio latency, which depends on the
> ability to do dma-done callbacks asap.
> This is another example, where the clients wud benefit from callback from IRQ
> context which is also perfectly safe.

Ok, thanks for the explanation.

>
>>> e) There seems to be no ScatterGather support for Mem to Mem transfers.
>>
>> There has never been a use case, what did you have in mind.  If
>> multiple prep_memcpy commands is too inefficient we could always add
>> another operation.
> Just that I believe any API should be as exhaustive and generic as possible.
> I see it possible for multimedia devices/drivers to evolve to start needing
> such capabilities.
> Also, the way DMA API treats memcpy/memset and assume SG reqs to be
> equivalent to MEM<=>DEV request is not very impressive.
> IMHO, any submitted request should be a list of xfers. And an xfer is a
> 'memset' with 'src_len' bytes from 'src_addr' to be copied 'n' times
> at 'dst_addr'.
> Memcpy is just a special case of memset, where n := 1
> This covers most possible use cases while being more compact and future-proof.

No, memset is an operation that does not have a source address and
instead writes a pattern.  As for the sg support for mem-to-mem
operations... like most things in Linux it was designed around its
users and none of the users at the time (md-raid, net-dma) required
scatter gather support.

Without seeing code its hard to make a judgment on what can and cannot
fit in dmaengine, but it needs to be judged on what fits in a generic
api and the feasibility of forcing mem-to-mem device-to-mem and
device-to-device dma into one api.  I am skeptical we can address all
those concerns, but we at least have something passably functional for
the first two.  On the other hand, it's perfectly sane for subarchs
like pxa to have their own dma api.  If at the end of the day all that
matters is $arch-specific-dma then why mess around with a generic api?

--
Dan
