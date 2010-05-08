Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab0EHWYL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 18:24:11 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52597 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab0EHWYJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 18:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sFT16e7wHk4mHzdOVAem1rtDs4k53YSIXGhb/eV0Rl+zkN+4+kPoYWGJXu6BWwnlNG
         tpgTS55+HE3ArwKEOq3qWFqwtgv2VSOWtQM2LrbalIui1Aa3Ra2hU3JslLWGwMyqNX4u
         UCID2DdSB5hdmh/PlIHcsIaq13x+haLJe9mqI=
MIME-Version: 1.0
In-Reply-To: <m2u1b68c6791005071937s5b2bbb60p6de395a6c06a963e@mail.gmail.com>
References: <1272848060-28049-1-git-send-email-linus.walleij@stericsson.com>
	 <i2t63386a3d1005070213u2ad32613w694be1ecbeb46856@mail.gmail.com>
	 <20100507093256.GB19936@n2100.arm.linux.org.uk>
	 <x2j63386a3d1005070443yfadbaf3ct8686a8f7aae6412f@mail.gmail.com>
	 <j2r1b68c6791005070531u57b4b1basc56d45d0e06b1d04@mail.gmail.com>
	 <k2k63386a3d1005070910kcdb516dcga60c24043b1b44de@mail.gmail.com>
	 <m2u1b68c6791005071937s5b2bbb60p6de395a6c06a963e@mail.gmail.com>
Date: Sat, 8 May 2010 15:24:08 -0700
X-Google-Sender-Auth: 16058f5e4c3b725f
Message-ID: <w2re9c3a7c21005081524z2a52a078nad8d316553dfde80@mail.gmail.com>
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

On Fri, May 7, 2010 at 7:37 PM, jassi brar <jassisinghbrar@gmail.com> wrote:
> On Sat, May 8, 2010 at 1:10 AM, Linus Walleij
> <linus.ml.walleij@gmail.com> wrote:
>> Surely circular linked buffers and other goodies can be retrofitted into the
>> DMAengine without a complete redesign? I only see a new slave call
>> to support that really, in addition to the existing sglist interface.
> well, before taking up the PL330 dma api driver, 'async' character of it
> was the only concern I had in mind. That still is, but I came across a
> a few more peculiarities while implementing the driver.
>
> a) Async:- For lazy transfers of mem to mem this may be ok.
>  But there might be devices the employ DMA to do extensive M2M transfers
>  (say dedicated multimedia oriented devices) the 'async' nature might be
>  a bottleneck. So too for M<=>D with a fast device with shallow FIFO.
>  There may be clients that don't wanna do much upon DMA done, but they
>  do need notifications ASAP.  By definition, this API forbids such
> expectations.

It is not forbidden by definition.  What is needed is a way for
drivers to opt-out of the async_tx expectations.  I have started down
this path with CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH for the ioatdma
driver, but the idea could be extended further to disable
CONFIG_ASYNC_TX_DMA and NET_DMA entirely to allow the device to
operate in a more device-dma friendly mode.

>  IMHO, a DMA api should be as quick as possible - callbacks done in IRQ context.
>  But since there maybe clients that need to do sleepable stuff in

None of the current clients sleep in the callback, it's done in
soft-irq context.  The only expectation is that hard-irqs are enabled
during the callback just like timer callbacks.  I also would like to
see numbers to quantify the claims of slowness.  When Steven Rostedt
was proposing his "move tasklets to process context" patches I ran a
throughput test on iop13xx and did not measure any degradation.

> callbacks, the API
>  may do two callbacks - 'quick' in irq context and 'lazy' from
> tasklets scheduled from
>  the IRQ. Most clients will provide either, while some may provide
> both callback functions.
>
> b) There seems to be no clear way of reporting failed transfers. The
> device_tx_status
>    can get FAIL/SUCSESS but the call is open ended and can be performed
>    without any time bound after tx_submit. It is not very optimal for
> DMAC drivers
>    to save descriptors of all failed transactions until the channel
> is released.
>    IMHO, provision of status checking by two mechanisms: cookie and dma-done
>   callbacks is complication more than a feature. Perhaps the dma
> engine could provide
>   a default callback, should the client doesn't do so, and track
> done/pending xfers
>  for such requests?

I agree the error handling was designed around mem-to-mem assumptions
where failures are due to double-bit ECC errors and other rare events.

>
> c) Conceptually, the channels are tightly coupled with the DMACs,
> there seems to be
>   no way to be able to schedule a channel among more than one DMACs
> in the runtime,
>   that is if more then one DMAC support the same channel/peripheral.
>   For example, Samsung's S5Pxxxx have many channels available on more
> than 1 DMAC
>   but for this dma api we have to statically assign channels to
> DMACs, which may result in
>   a channel acquire request rejected just because the DMAC we chose
> for it is already
>   fully busy while another DMAC, which also supports the channel, is idling.
>   Unless we treat the same peripheral as, say, I2STX_viaDMAC1 and
> I2STX_viaDMAC2
>   and allocate double resources for these "mutually exclusive" channels.

I am not understanding this example.  If both DMACs are registered the
dma_filter function to dma_request_channel() can select between them,
right?

>
> d) Something like circular-linked-request is highly desirable for one
> of the important DMA
>   clients i.e, audio.

Is this a standing dma chain that periodically a client will say "go"
to re-run those operations?  Please enlighten me, I've never played
with audio drivers.

>
> e) There seems to be no ScatterGather support for Mem to Mem transfers.

There has never been a use case, what did you have in mind.  If
multiple prep_memcpy commands is too inefficient we could always add
another operation.

> Or these are just due to my cursory understanding of the DMA Engine core?...

No, it's a good review and points out some places where the API can evolve.

--
Dan
