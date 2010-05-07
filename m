Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab0EGS2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:28:40 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:49920 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab0EGS2i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:28:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ScngZ5VYvQ0WIqP4jKZEjrN43gjVOfdCZ2VfXgiPwtQhwUcRu7xAnonRBCMo1ty08L
         zRrIwaxYXOxQeMjzB5iGf6mf1i3Q2xB+5fWGmeLpWeAoFRLKHroRYYNqegmnc9ybY9S8
         HX4IQWzhJ/cSbRF7Ny4HvUsCUjSpXO+1SGnCY=
MIME-Version: 1.0
In-Reply-To: <20100507101544.GB25342@emlix.com>
References: <1273142265-11929-1-git-send-email-os@emlix.com> 
	<1273142265-11929-2-git-send-email-os@emlix.com> <g2j8bd0f97a1005061146l2b01e45do15bf46162e38ce84@mail.gmail.com> 
	<20100507101544.GB25342@emlix.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 7 May 2010 14:28:16 -0400
Message-ID: <w2w8bd0f97a1005071128o63fba35fl824cc997980fee03@mail.gmail.com>
Subject: Re: [PATCH] ad7877: keep dma rx buffers in seperate cache lines
To: Oskar Schirmer <os@emlix.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       =?UTF-8?Q?Daniel_Gl=C3=B6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 7, 2010 at 06:15, Oskar Schirmer wrote:
> On Thu, May 06, 2010 at 14:46:04 -0400, Mike Frysinger wrote:
>> On Thu, May 6, 2010 at 06:37, Oskar Schirmer wrote:
>> >  struct ser_req {
>> > +       u16                     sample;
>> > +       char                    __padalign[L1_CACHE_BYTES - sizeof(u16)];
>> > +
>> >        u16                     reset;
>> >        u16                     ref_on;
>> >        u16                     command;
>> > -       u16                     sample;
>> >        struct spi_message      msg;
>> >        struct spi_transfer     xfer[6];
>> >  };
>>
>> are you sure this is necessary ?  ser_req is only ever used with
>> spi_sync() and it's allocated/released on the fly, so how could
>> anything be reading that memory between the start of the transmission
>> and the return to adi7877 ?
>
> msg is handed over to spi_sync, it contains the addresses
> which will be used to programme the DMA: the spi master
> transfer function will read these fields to start DMA.

so the issue is coming from the SPI master drivers and not the AD7877 driver

>> >  struct ad7877 {
>> > +       u16                     conversion_data[AD7877_NR_SENSE];
>> > +       char                    __padalign[L1_CACHE_BYTES
>> > +                                       - AD7877_NR_SENSE * sizeof(u16)];
>> > +
>> >        struct input_dev        *input;
>> >        char                    phys[32];
>> >
>> > @@ -182,8 +188,6 @@ struct ad7877 {
>> >        u8                      averaging;
>> >        u8                      pen_down_acc_interval;
>> >
>> > -       u16                     conversion_data[AD7877_NR_SENSE];
>> > -
>> >        struct spi_transfer     xfer[AD7877_NR_SENSE + 2];
>> >        struct spi_message      msg;
>>
>> i can see the spi_message inside of this struct being a problem
>> because the spi transfer is doing asynchronously with spi_async().
>> however, i would add a comment right above these two fields with a
>> short explanation as to why they're at the start and why the pad
>> exists so someone down the line doesnt move it.
>
> The code says "pad to align according to L1 cache, and
> keep away other stuff by exactly the amount so it is
> off the line". I'ld guess a comment would repeat just
> this, so it is superfluous. But if opinions differ on
> this topic, we can have a comment added, sure.

not everyone knows to read every single piece of documentation that
may or may not be affected implicitly in the call stack.  a simple
comment here is not superfluous.

since the other struct is also going to be changed, a comment should
be placed there as well.
-mike
