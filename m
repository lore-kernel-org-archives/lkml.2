Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab0EGKPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 06:15:48 -0400
Received: from mx1.emlix.com ([193.175.82.87]:58325 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab0EGKPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 06:15:47 -0400
Date: Fri, 7 May 2010 12:15:44 +0200
From: Oskar Schirmer <os@emlix.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Oskar Schirmer <os@emlix.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Daniel =?utf-8?B?R2zDtmNrbmVy?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>
Subject: Re: [PATCH] ad7877: keep dma rx buffers in seperate cache lines
Message-ID: <20100507101544.GB25342@emlix.com>
References: <1273142265-11929-1-git-send-email-os@emlix.com> <1273142265-11929-2-git-send-email-os@emlix.com> <g2j8bd0f97a1005061146l2b01e45do15bf46162e38ce84@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <g2j8bd0f97a1005061146l2b01e45do15bf46162e38ce84@mail.gmail.com>
Organization: emlix GmbH
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 14:46:04 -0400, Mike Frysinger wrote:
> On Thu, May 6, 2010 at 06:37, Oskar Schirmer wrote:
> >  struct ser_req {
> > +       u16                     sample;
> > +       char                    __padalign[L1_CACHE_BYTES - sizeof(u16)];
> > +
> >        u16                     reset;
> >        u16                     ref_on;
> >        u16                     command;
> > -       u16                     sample;
> >        struct spi_message      msg;
> >        struct spi_transfer     xfer[6];
> >  };
> 
> are you sure this is necessary ?  ser_req is only ever used with
> spi_sync() and it's allocated/released on the fly, so how could
> anything be reading that memory between the start of the transmission
> and the return to adi7877 ?

msg is handed over to spi_sync, it contains the addresses
which will be used to programme the DMA: the spi master
transfer function will read these fields to start DMA.

E.g., drivers/spi/atmel_spi.c, assures cache coherency
in function atmel_spi_dma_map_xfer, one xfer at a time.
Multiple transfers are worked on in a loop in atmel_spi_transfer,
so when coherency for transfer #1 is ensured, addresses
for transfer #2 are read from the msg and xfer structs,
caching lines which have been just before invalidated.

And, citing Documentation/DMA-API.txt, Part Id:
"mapped region must begin exactly on a cache line
boundary and end exactly on one", which is our case.

> 
> >  struct ad7877 {
> > +       u16                     conversion_data[AD7877_NR_SENSE];
> > +       char                    __padalign[L1_CACHE_BYTES
> > +                                       - AD7877_NR_SENSE * sizeof(u16)];
> > +
> >        struct input_dev        *input;
> >        char                    phys[32];
> >
> > @@ -182,8 +188,6 @@ struct ad7877 {
> >        u8                      averaging;
> >        u8                      pen_down_acc_interval;
> >
> > -       u16                     conversion_data[AD7877_NR_SENSE];
> > -
> >        struct spi_transfer     xfer[AD7877_NR_SENSE + 2];
> >        struct spi_message      msg;
> 
> i can see the spi_message inside of this struct being a problem
> because the spi transfer is doing asynchronously with spi_async().
> however, i would add a comment right above these two fields with a
> short explanation as to why they're at the start and why the pad
> exists so someone down the line doesnt move it.

The code says "pad to align according to L1 cache, and
keep away other stuff by exactly the amount so it is
off the line". I'ld guess a comment would repeat just
this, so it is superfluous. But if opinions differ on
this topic, we can have a comment added, sure.

  Oskar
-- 
oskar schirmer, emlix gmbh, http://www.emlix.com
fon +49 551 30664-0, fax -11, bahnhofsallee 1b, 37081 göttingen, germany
sitz der gesellschaft: göttingen, amtsgericht göttingen hr b 3160
geschäftsführer: dr. uwe kracke, ust-idnr.: de 205 198 055

emlix - your embedded linux partner
