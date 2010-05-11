Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab0EKGhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 02:37:46 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:56310 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933010Ab0EKGhl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 02:37:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=YYktNsiQukvJESHLH6l1XiGfjG5s+j23gnakOV1bAPsLIvjmr+xL0GQNajqiDmyCkg
         3nSYu9TsNTp/VmGY0ICg339lGlAgpS9b4d5W/tFG0PB67vM/HK7iFKT0UDd6sGsKaS9+
         iHdsEb+Cklk9h6CopHmH8jKYmMUQMqN8wzcW4=
MIME-Version: 1.0
In-Reply-To: <20100511063309.GC9644@core.coreip.homeip.net>
References: <1273487642-2169-1-git-send-email-os@emlix.com> 
	<1273488154-2993-1-git-send-email-os@emlix.com> <20100510142225.4bf215ef.akpm@linux-foundation.org> 
	<20100511060547.GA9644@core.coreip.homeip.net> <AANLkTikA9s6lpO2uDuIup8BwGOYYHQ9yQxS36PBSIttX@mail.gmail.com> 
	<20100511062110.GB9644@core.coreip.homeip.net> <AANLkTiktu7N5IXknkkJ9D5L4z5plhuGvD45IVqJm9zG1@mail.gmail.com> 
	<20100511063309.GC9644@core.coreip.homeip.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 11 May 2010 02:37:21 -0400
Message-ID: <AANLkTimgZTNi6eevEAJw1BdbAJwkyCfgYe7srqmHVrUX@mail.gmail.com>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?UTF-8?Q?Daniel_Gl=C3=B6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 02:33, Dmitry Torokhov wrote:
> On Tue, May 11, 2010 at 02:23:34AM -0400, Mike Frysinger wrote:
>> On Tue, May 11, 2010 at 02:21, Dmitry Torokhov wrote:
>> > On Tue, May 11, 2010 at 02:11:41AM -0400, Mike Frysinger wrote:
>> >> On Tue, May 11, 2010 at 02:05, Dmitry Torokhov wrote:
>> >> > Dmitry
>> >> >
>> >> > Input: ad7877 - keep dma rx buffers in seperate cache lines
>> >> >
>> >> > From: Oskar Schirmer <os@emlix.com>
>> >> >
>> >> > With dma based spi transmission, data corruption is observed
>> >> > occasionally. With dma buffers located right next to msg and
>> >> > xfer fields, cache lines correctly flushed in preparation for
>> >> > dma usage may be polluted again when writing to fields in the
>> >> > same cache line.
>> >> >
>> >> > Make sure cache fields used with dma do not share cache lines
>> >> > with fields changed during dma handling. As both fields are part
>> >> > of a struct that is allocated via kzalloc, thus cache aligned,
>> >> > moving the fields to the 1st position and insert padding for
>> >> > alignment does the job.
>> >> >
>> >> > Signed-off-by: Oskar Schirmer <os@emlix.com>
>> >> > Signed-off-by: Daniel Glöckner <dg@emlix.com>
>> >> > Signed-off-by: Oliver Schneidewind <osw@emlix.com>
>> >> > Signed-off-by: Johannes Weiner <jw@emlix.com>
>> >> > Acked-by: Mike Frysinger <vapier@gentoo.org>
>> >> > [dtor@mail.ru - changed to use ___cacheline_aligned at suggestion
>> >> >  of akpm]
>> >> > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
>> >> > ---
>> >> >
>> >> >  drivers/input/touchscreen/ad7877.c |   15 ++++++++++++---
>> >> >  1 files changed, 12 insertions(+), 3 deletions(-)
>> >> >
>> >> >
>> >> > diff --git a/drivers/input/touchscreen/ad7877.c b/drivers/input/touchscreen/ad7877.c
>> >> > index e019d53..0d2d7e5 100644
>> >> > --- a/drivers/input/touchscreen/ad7877.c
>> >> > +++ b/drivers/input/touchscreen/ad7877.c
>> >> > @@ -156,9 +156,14 @@ struct ser_req {
>> >> >        u16                     reset;
>> >> >        u16                     ref_on;
>> >> >        u16                     command;
>> >> > -       u16                     sample;
>> >> >        struct spi_message      msg;
>> >> >        struct spi_transfer     xfer[6];
>> >> > +
>> >> > +       /*
>> >> > +        * DMA (thus cache coherency maintenance) requires the
>> >> > +        * transfer buffers to live in their own cache lines.
>> >> > +        */
>> >> > +       u16 sample ____cacheline_aligned;
>> >> >  };
>> >> >
>> >> >  struct ad7877 {
>> >> > @@ -182,8 +187,6 @@ struct ad7877 {
>> >> >        u8                      averaging;
>> >> >        u8                      pen_down_acc_interval;
>> >> >
>> >> > -       u16                     conversion_data[AD7877_NR_SENSE];
>> >> > -
>> >> >        struct spi_transfer     xfer[AD7877_NR_SENSE + 2];
>> >> >        struct spi_message      msg;
>> >> >
>> >> > @@ -195,6 +198,12 @@ struct ad7877 {
>> >> >        spinlock_t              lock;
>> >> >        struct timer_list       timer;          /* P: lock */
>> >> >        unsigned                pending:1;      /* P: lock */
>> >> > +
>> >> > +       /*
>> >> > +        * DMA (thus cache coherency maintenance) requires the
>> >> > +        * transfer buffers to live in their own cache lines.
>> >> > +        */
>> >> > +       u16 conversion_data[AD7877_NR_SENSE] ____cacheline_aligned;
>> >> >  };
>> >>
>> >> i'm not sure this is correct.  the cached_aligned attribute makes sure
>> >> it starts on a cache boundary, but it doesnt make sure it pads out to
>> >> one.  so it might work more of the time, but i dont think it's
>> >> guaranteed.
>> >
>> > The buffers are moved to the end of the structure - there is nothing
>> > else there.
>>
>> what guarantee exactly do you have for that statement ?
>
> The data is kmalloced, kmalloc aligns on cacheline boundary AFAIK which
> means that next kmalloc data chunk will not share "our" cacheline.

so obvious once you say it out loud.  as long as kmalloc() guarantees
it, your patch sounds fine to me.  once Oskar double checks, ship it!

thanks :)
-mike
