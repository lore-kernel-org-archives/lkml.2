Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0EHWcM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 18:32:12 -0400
Received: from mx1.emlix.com ([193.175.82.87]:48547 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425Ab0EHWcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 18:32:10 -0400
Date: Sun, 9 May 2010 00:32:06 +0200
From: Johannes Weiner <jw@emlix.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Oskar Schirmer <os@emlix.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>
Subject: Re: [PATCH] ad7877: keep dma rx buffers in seperate cache lines
Message-ID: <20100508223206.GA365@emlix.com>
References: <1273142265-11929-1-git-send-email-os@emlix.com> <1273142265-11929-2-git-send-email-os@emlix.com> <g2j8bd0f97a1005061146l2b01e45do15bf46162e38ce84@mail.gmail.com> <20100507101544.GB25342@emlix.com> <w2w8bd0f97a1005071128o63fba35fl824cc997980fee03@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <w2w8bd0f97a1005071128o63fba35fl824cc997980fee03@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 02:28:16PM -0400, Mike Frysinger wrote:
> On Fri, May 7, 2010 at 06:15, Oskar Schirmer wrote:
> > On Thu, May 06, 2010 at 14:46:04 -0400, Mike Frysinger wrote:
> >> On Thu, May 6, 2010 at 06:37, Oskar Schirmer wrote:
> >> >  struct ser_req {
> >> > +       u16                     sample;
> >> > +       char                    __padalign[L1_CACHE_BYTES - sizeof(u16)];
> >> > +
> >> >        u16                     reset;
> >> >        u16                     ref_on;
> >> >        u16                     command;
> >> > -       u16                     sample;
> >> >        struct spi_message      msg;
> >> >        struct spi_transfer     xfer[6];
> >> >  };
> >>
> >> are you sure this is necessary ?  ser_req is only ever used with
> >> spi_sync() and it's allocated/released on the fly, so how could
> >> anything be reading that memory between the start of the transmission
> >> and the return to adi7877 ?
> >
> > msg is handed over to spi_sync, it contains the addresses
> > which will be used to programme the DMA: the spi master
> > transfer function will read these fields to start DMA.
> 
> so the issue is coming from the SPI master drivers and not the AD7877 driver

No, the issue is coming from ad7877 placing a transmission buffer
into the same cache line with memory locations that are accessed outside
the driver's scope.  It must assume that the SPI driver does DMA, that
cache coherency is maintained at cache line granularity, and must not
make any assumptions about how the struct spi_message members are used.

The following is about slave drivers from Documentation/spi/spi-summary:

  - Follow standard kernel rules, and provide DMA-safe buffers in
    your messages.  That way controller drivers using DMA aren't forced
    to make extra copies unless the hardware requires it (e.g. working
    around hardware errata that force the use of bounce buffering).

> >> >  struct ad7877 {
> >> > +       u16                     conversion_data[AD7877_NR_SENSE];
> >> > +       char                    __padalign[L1_CACHE_BYTES
> >> > +                                       - AD7877_NR_SENSE * sizeof(u16)];
> >> > +
> >> >        struct input_dev        *input;
> >> >        char                    phys[32];
> >> >
> >> > @@ -182,8 +188,6 @@ struct ad7877 {
> >> >        u8                      averaging;
> >> >        u8                      pen_down_acc_interval;
> >> >
> >> > -       u16                     conversion_data[AD7877_NR_SENSE];
> >> > -
> >> >        struct spi_transfer     xfer[AD7877_NR_SENSE + 2];
> >> >        struct spi_message      msg;
> >>
> >> i can see the spi_message inside of this struct being a problem
> >> because the spi transfer is doing asynchronously with spi_async().
> >> however, i would add a comment right above these two fields with a
> >> short explanation as to why they're at the start and why the pad
> >> exists so someone down the line doesnt move it.
> >
> > The code says "pad to align according to L1 cache, and
> > keep away other stuff by exactly the amount so it is
> > off the line". I'ld guess a comment would repeat just
> > this, so it is superfluous. But if opinions differ on
> > this topic, we can have a comment added, sure.
> 
> not everyone knows to read every single piece of documentation that
> may or may not be affected implicitly in the call stack.  a simple
> comment here is not superfluous.
> 
> since the other struct is also going to be changed, a comment should
> be placed there as well.

How about

  /*
   * DMA (thus cache coherency maintainance) requires the
   * transfer buffers to live in their own cache lines.
   */
   char		__padalign[...];

?  It might be obvious what the code does, but I agree with
Mike that it might not be immediately apparent why it's needed.

	Hannes
