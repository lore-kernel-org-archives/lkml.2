Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab0EIDsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 23:48:19 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36022 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab0EIDsR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 23:48:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pKRdGUf6x1h3WlDduAPhGji+UY4vbXRyC56sFXyfgTmTmSrsgYiTw3Mm+OPSxN62GF
         Ix1cqsHC+AxyqoRTYph9deyGPgUt2Xien0wqpigvwrymt5UIual6N49bPfP5v4I3LZv/
         wIXVPR44DKegcgJrFRsbRWKbC3A0gUJnzHjTY=
MIME-Version: 1.0
In-Reply-To: <w2re9c3a7c21005081524z2a52a078nad8d316553dfde80@mail.gmail.com>
References: <1272848060-28049-1-git-send-email-linus.walleij@stericsson.com>
	 <i2t63386a3d1005070213u2ad32613w694be1ecbeb46856@mail.gmail.com>
	 <20100507093256.GB19936@n2100.arm.linux.org.uk>
	 <x2j63386a3d1005070443yfadbaf3ct8686a8f7aae6412f@mail.gmail.com>
	 <j2r1b68c6791005070531u57b4b1basc56d45d0e06b1d04@mail.gmail.com>
	 <k2k63386a3d1005070910kcdb516dcga60c24043b1b44de@mail.gmail.com>
	 <m2u1b68c6791005071937s5b2bbb60p6de395a6c06a963e@mail.gmail.com>
	 <w2re9c3a7c21005081524z2a52a078nad8d316553dfde80@mail.gmail.com>
Date: Sun, 9 May 2010 12:48:16 +0900
Message-ID: <l2j1b68c6791005082048j5deaf863g2887c968ff841f2f@mail.gmail.com>
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

On Sun, May 9, 2010 at 7:24 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Fri, May 7, 2010 at 7:37 PM, jassi brar <jassisinghbrar@gmail.com> wrote:
>>  IMHO, a DMA api should be as quick as possible - callbacks done in IRQ context.
>>  But since there maybe clients that need to do sleepable stuff in
>
> None of the current clients sleep in the callback, it's done in
> soft-irq context.  The only expectation is that hard-irqs are enabled
> during the callback just like timer callbacks.  I also would like to
> see numbers to quantify the claims of slowness.
The clients evolve around the API so they don't do what the API doesn't
allow. Any API should try to put as least contraints as possible - you never
know what kinda clients are gonna arise.
Lets say a protocol requires 'quick' ACK(within few usecs) on control bus after
xfer'ing a large packet on data bus. All the client needs is to be
able to toggle
some bit of the device controller after the DMA done, which can very well be
done in IRQ context but maybe too late if the callback is done from a tasklet
scheduled from DMAC ISR.
The point being, a DMA API should be able to do callbacks from the IRQ context
too. That is, assuming the clients know what they do.

Also, I think it is possible to have an API that allows request submission from
callbacks, which will be a very useful feature.
Of course, assuming the clients know what they can/can't do (just like current
DMA API or any other API).


>> callbacks, the API
>>  may do two callbacks - 'quick' in irq context and 'lazy' from
>> tasklets scheduled from
>>  the IRQ. Most clients will provide either, while some may provide
>> both callback functions.
>>
>> b) There seems to be no clear way of reporting failed transfers. The
>> device_tx_status
>>    can get FAIL/SUCSESS but the call is open ended and can be performed
>>    without any time bound after tx_submit. It is not very optimal for
>> DMAC drivers
>>    to save descriptors of all failed transactions until the channel
>> is released.
>>    IMHO, provision of status checking by two mechanisms: cookie and dma-done
>>   callbacks is complication more than a feature. Perhaps the dma
>> engine could provide
>>   a default callback, should the client doesn't do so, and track
>> done/pending xfers
>>  for such requests?
>
> I agree the error handling was designed around mem-to-mem assumptions
> where failures are due to double-bit ECC errors and other rare events.
well, neither have I ever seen DMA failure, but a good API shouldn't count
upon h/w perfection.


>> c) Conceptually, the channels are tightly coupled with the DMACs,
>> there seems to be
>>   no way to be able to schedule a channel among more than one DMACs
>> in the runtime,
>>   that is if more then one DMAC support the same channel/peripheral.
>>   For example, Samsung's S5Pxxxx have many channels available on more
>> than 1 DMAC
>>   but for this dma api we have to statically assign channels to
>> DMACs, which may result in
>>   a channel acquire request rejected just because the DMAC we chose
>> for it is already
>>   fully busy while another DMAC, which also supports the channel, is idling.
>>   Unless we treat the same peripheral as, say, I2STX_viaDMAC1 and
>> I2STX_viaDMAC2
>>   and allocate double resources for these "mutually exclusive" channels.
>
> I am not understanding this example.  If both DMACs are registered the
> dma_filter function to dma_request_channel() can select between them,
> right?
Let me be precise. I2S_Tx fifo(I2S peripheral/channel) can be be reached
by two DMACs but, of course, the channel can only be active with
exactly one DMAC.
So, it is desirable to be able to reach the peripheral via second DMAC should
the first one is too busy to handle the request. Clearly this is a
runtime decision.
FWIHS, I can associate the channel with either of the DMACs and if that DMAC
can't handle the I2S_Tx request (say due to its all h/w threads
allocated to other
request), I can't play audio even if the DMAC might be simply idling.


>>
>> d) Something like circular-linked-request is highly desirable for one
>> of the important DMA
>>   clients i.e, audio.
>
> Is this a standing dma chain that periodically a client will say "go"
> to re-run those operations?  Please enlighten me, I've never played
> with audio drivers.
Yes, quite similar. Only alsa drivers will say "go" just once at playback start
and the submitted xfer requests(called periods) are repeatedly transfered in
circular manner.
Just a quick snd_pcm_period_elapsed is called in dma-done callback for
each request(which are usually the same length).
That way, the client neither have to re-submit requests nor need to do sleepable
stuff(allocating memory for new reqs and managing local state machine)
The minimum period size depends on audio latency, which depends on the
ability to do dma-done callbacks asap.
This is another example, where the clients wud benefit from callback from IRQ
context which is also perfectly safe.

>> e) There seems to be no ScatterGather support for Mem to Mem transfers.
>
> There has never been a use case, what did you have in mind.  If
> multiple prep_memcpy commands is too inefficient we could always add
> another operation.
Just that I believe any API should be as exhaustive and generic as possible.
I see it possible for multimedia devices/drivers to evolve to start needing
such capabilities.
Also, the way DMA API treats memcpy/memset and assume SG reqs to be
equivalent to MEM<=>DEV request is not very impressive.
IMHO, any submitted request should be a list of xfers. And an xfer is a
'memset' with 'src_len' bytes from 'src_addr' to be copied 'n' times
at 'dst_addr'.
Memcpy is just a special case of memset, where n := 1
This covers most possible use cases while being more compact and future-proof.
