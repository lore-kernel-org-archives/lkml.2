Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab0EKGVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 02:21:22 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49802 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932765Ab0EKGVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 02:21:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=tvq4758zv9OUsQJjZeHS7yNVfSY7hAj5HBEmr1yCzLH/SEmoCkGO+X4t+IMiYt92lL
         jTI0x46ZQeoI0vTl/feMOt0KsYP5yaqN+8SmEYeP1E7nOaVUoWSMJHKnL6Jl/j0tPbkz
         jhcf7+FW0CWFhMxAPYfIUUbN/J+tuF9rIg9NU=
Date: Mon, 10 May 2010 23:21:10 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
Message-ID: <20100511062110.GB9644@core.coreip.homeip.net>
References: <1273487642-2169-1-git-send-email-os@emlix.com>
 <1273488154-2993-1-git-send-email-os@emlix.com>
 <20100510142225.4bf215ef.akpm@linux-foundation.org>
 <20100511060547.GA9644@core.coreip.homeip.net>
 <AANLkTikA9s6lpO2uDuIup8BwGOYYHQ9yQxS36PBSIttX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikA9s6lpO2uDuIup8BwGOYYHQ9yQxS36PBSIttX@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 02:11:41AM -0400, Mike Frysinger wrote:
> On Tue, May 11, 2010 at 02:05, Dmitry Torokhov wrote:
> > On Mon, May 10, 2010 at 02:22:25PM -0700, Andrew Morton wrote:
> >> On Mon, 10 May 2010 12:42:34 +0200 Oskar Schirmer wrote:
> >> > With dma based spi transmission, data corruption
> >> > is observed occasionally. With dma buffers located
> >> > right next to msg and xfer fields, cache lines
> >> > correctly flushed in preparation for dma usage
> >> > may be polluted again when writing to fields
> >> > in the same cache line.
> >> >
> >> > Make sure cache fields used with dma do not
> >> > share cache lines with fields changed during
> >> > dma handling. As both fields are part of a
> >> > struct that is allocated via kzalloc, thus
> >> > cache aligned, moving the fields to the 1st
> >> > position and insert padding for alignment
> >> > does the job.
> >>
> >> This sounds odd.  Doesn't it imply that some code somewhere is missing
> >> some DMA synchronisation actions?
> >>
> >> >
> >> > v2: add a comment to explain why alignment is needed
> >> >
> >> > v3: fix the typo in comment and layout (- to end of line)
> >> >
> >> > diff --git a/drivers/input/touchscreen/ad7877.c b/drivers/input/touchscreen/ad7877.c
> >> > index 885354c..9ebb1b4 100644
> >> > --- a/drivers/input/touchscreen/ad7877.c
> >> > +++ b/drivers/input/touchscreen/ad7877.c
> >> > @@ -153,15 +153,29 @@ enum {
> >> >   */
> >> >
> >> >  struct ser_req {
> >> > +   u16                     sample;
> >> > +   /*
> >> > +    * DMA (thus cache coherency maintenance) requires the
> >> > +    * transfer buffers to live in their own cache lines.
> >> > +    */
> >> > +   char                    __padalign[L1_CACHE_BYTES - sizeof(u16)];
> >>
> >> It would be better to use __cacheline_aligned, rather than open-coding
> >> things in this manner.
> >>
> >
> > OK, then I have the following which I will apply unless someone shouts.
> >
> > --
> > Dmitry
> >
> > Input: ad7877 - keep dma rx buffers in seperate cache lines
> >
> > From: Oskar Schirmer <os@emlix.com>
> >
> > With dma based spi transmission, data corruption is observed
> > occasionally. With dma buffers located right next to msg and
> > xfer fields, cache lines correctly flushed in preparation for
> > dma usage may be polluted again when writing to fields in the
> > same cache line.
> >
> > Make sure cache fields used with dma do not share cache lines
> > with fields changed during dma handling. As both fields are part
> > of a struct that is allocated via kzalloc, thus cache aligned,
> > moving the fields to the 1st position and insert padding for
> > alignment does the job.
> >
> > Signed-off-by: Oskar Schirmer <os@emlix.com>
> > Signed-off-by: Daniel Glöckner <dg@emlix.com>
> > Signed-off-by: Oliver Schneidewind <osw@emlix.com>
> > Signed-off-by: Johannes Weiner <jw@emlix.com>
> > Acked-by: Mike Frysinger <vapier@gentoo.org>
> > [dtor@mail.ru - changed to use ___cacheline_aligned at suggestion
> >  of akpm]
> > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> > ---
> >
> >  drivers/input/touchscreen/ad7877.c |   15 ++++++++++++---
> >  1 files changed, 12 insertions(+), 3 deletions(-)
> >
> >
> > diff --git a/drivers/input/touchscreen/ad7877.c b/drivers/input/touchscreen/ad7877.c
> > index e019d53..0d2d7e5 100644
> > --- a/drivers/input/touchscreen/ad7877.c
> > +++ b/drivers/input/touchscreen/ad7877.c
> > @@ -156,9 +156,14 @@ struct ser_req {
> >        u16                     reset;
> >        u16                     ref_on;
> >        u16                     command;
> > -       u16                     sample;
> >        struct spi_message      msg;
> >        struct spi_transfer     xfer[6];
> > +
> > +       /*
> > +        * DMA (thus cache coherency maintenance) requires the
> > +        * transfer buffers to live in their own cache lines.
> > +        */
> > +       u16 sample ____cacheline_aligned;
> >  };
> >
> >  struct ad7877 {
> > @@ -182,8 +187,6 @@ struct ad7877 {
> >        u8                      averaging;
> >        u8                      pen_down_acc_interval;
> >
> > -       u16                     conversion_data[AD7877_NR_SENSE];
> > -
> >        struct spi_transfer     xfer[AD7877_NR_SENSE + 2];
> >        struct spi_message      msg;
> >
> > @@ -195,6 +198,12 @@ struct ad7877 {
> >        spinlock_t              lock;
> >        struct timer_list       timer;          /* P: lock */
> >        unsigned                pending:1;      /* P: lock */
> > +
> > +       /*
> > +        * DMA (thus cache coherency maintenance) requires the
> > +        * transfer buffers to live in their own cache lines.
> > +        */
> > +       u16 conversion_data[AD7877_NR_SENSE] ____cacheline_aligned;
> >  };
> 
> i'm not sure this is correct.  the cached_aligned attribute makes sure
> it starts on a cache boundary, but it doesnt make sure it pads out to
> one.  so it might work more of the time, but i dont think it's
> guaranteed.

The buffers are moved to the end of the structure - there is nothing
else there.

-- 
Dmitry
