Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab1KATMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 15:12:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56095 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab1KATMq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 15:12:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAC=G6swE7WCqTFkJkOm_GXpVncjXrc+-jvaKHiwc9KTb6Re8hQ@mail.gmail.com>
References: <1319255194-4799-1-git-send-email-paul.s.schilling@gmail.com>
	<20111101121851.7d393277@bob.linux.org.uk>
	<CAC=G6swE7WCqTFkJkOm_GXpVncjXrc+-jvaKHiwc9KTb6Re8hQ@mail.gmail.com>
Date: Tue, 1 Nov 2011 14:12:45 -0500
Message-ID: <CAC=G6szKRbyJXTXOCyDaF3rEfaiVCktTU6y0Fwohh6qf2VD-_A@mail.gmail.com>
Subject: Re: [PATCH 02/14] ARM : SAMSUNG : Add RS485 support.
From: Paul Schilling <paul.s.schilling@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Boojin Kim <boojin.kim@samsung.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need an opinion on two issues before I resubmit the Samsung RS-485 driver.

First of all the driver works.  I have tested it on a logic analyser
and I found that it
switches from transmit to receive in token mode exactly after 1 bit of
idle time as long
as interrupts are kept enabled and nothing tries to wait or sleep
inside of an interrupt.
I found 2 maybe 3 places where this occurs up to 22 milliseconds.

The opinion part...  I needed a timer to switch from transmit to
receive after the FIFO
was empty.  I started by using the low resolution timer using jiffies
first.  I found that
wasn't high enough resolution, so I switched to the Linux HRT.
Currently I have both
versions that can be selected by conditional compile.  Should I just
remove the low
resolution timer completely or leave it in.

Second, I have a chunk of code that if it could be made to work could
off load the
receiving to DMA up to the last couple of bytes then switch back to
interrupts for
the token byte.  Should I leave that code in a #if 0 statement or
should I just delete
it.

Thanks,
Paul Schilling

On Tue, Nov 1, 2011 at 9:57 AM, Paul Schilling
<paul.s.schilling@gmail.com> wrote:
> I am working on resubmitting this stuff right now.  I have 14 patches
> that should be
> broken into more like 20 patches.  Most of them are ARM S3C and
> specifically S3C2416 patches.
> I am working on a patch right now to fix a Atomic wait in the DMA
> code.  That causes
> 20 milliseconds of no interrupts whenever a sound is played on the samsung S3C
> platform.
>
> The code below wasn't supposed to go out and I have patch that removes
> that chunk
> of code almost ready that just needs testing before I send it.
>
> On Tue, Nov 1, 2011 at 7:18 AM, Alan Cox <alan@linux.intel.com> wrote:
>>> +config SAMSUNG_HAS_RS485
>>> +     bool "Enable RS485 support for Samsung"
>>> +     depends on SERIAL_SAMSUNG && (MACH_CONDOR2440 ||
>>> MACH_CONDOR2416 || MACH_MINI2440)
>>> +     default y if (MACH_CONDOR2440 || MACH_CONDOR2416)
>>> +     default n if (MACH_MINI2440)
>>
>> There really needs to be more ARM thinking about doing this sort of
>> stuff at runtime. If you can detect the board type at runtime then you
>> need to be moving towards kicking board specifics out of the depends,
>> and treating it as an "include support for this, if the board has it"
>> so you can move towards less build time only configuration.
>>
>
> The chunk of code that says FIXME is an optimization that could be
> implemented to
> decrease interrupts by using DMA until the last byte is ready to be
> sent.  I have a new
> patch that explains in a comment what the code is for.
>
>>> +/* FIXME */
>>> +     #if 0
>>> +     if (last_state != en) {
>>> +
>>
>> So this doesn't look ready to submit either...
>>
>
> I have a patch that I haven't sent yet that fixes the code formating
> issues.  I need to compile and test it before I send it out.
>
>>
>>> +             if ((utrstat & S3C2410_UTRSTAT_TXE) ? 1 : 0) {
>>> +                     if (cfg->gpio_transmit_en > -1) {
>>> +
>>> gpio_set_value(cfg->gpio_transmit_en, 0);
>>> +                     }
>>
>> Lots of excess brackets (see CodingStyle) - removing a few of the
>> excess ones would make it easier to read later.
>>
>> The later bits become a real mess of ifdefs - much not your fault, the
>> combination of your ifdefs and existing lack of design push it beyond
>> ugly and really want addressing.
>>
>>
>
