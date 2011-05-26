Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab1EZPSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:18:15 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59589 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905Ab1EZPSN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:18:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=n0Q5jcrHgoZfLakMnGgC4eyP90El/jUJDO3djMvlLdjIxdvD2xLTAWKAj+dFSHJYRN
         5e3v0Pz659AFled22cCPWd7kD4L+FyG4HT28GFtCRI8MyALQ+dgnBgTTP39gG6wC4hul
         y6S4VMJ/CtWFNJsHrUyfbbhFSPJp1U3vlu6Jk=
MIME-Version: 1.0
In-Reply-To: <201105250851.03665.arnd@arndb.de>
References: <BANLkTikfje67KyyD+7Pn0D=afTyEde0euw@mail.gmail.com> <201105250851.03665.arnd@arndb.de>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 26 May 2011 23:17:52 +0800
Message-ID: <BANLkTikOyo9g1GD_dOxb5As2Yr0rBc+hyA@mail.gmail.com>
Subject: Re: CSR ARM SoC Subarchitecture preview
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

2011/5/25 Arnd Bergmann <arnd@arndb.de>:
> On Wednesday 25 May 2011 04:15:12 Barry Song wrote:
>
>> >>  mach-prima2/include/mach/system.h                            |    5
>> >>  mach-prima2/include/mach/timex.h                             |    5
>> >>  mach-prima2/include/mach/uncompress.h                        |   45
>> >>  mach-prima2/include/mach/vmalloc.h                           |   19
>> >>  mach-prima2/lcdinit.c                                        |  136
>> >>  mach-prima2/mach-prima2cb.c                                  |  226 +
>> >>  mach-prima2/padmode.c                                        |  139
>> >>  mach-prima2/prima2.c                                         |   81
>> >>  mach-prima2/prima2cb-keypad.c                                |  136
>> >>  mach-prima2/pwrc.c                                           |  286 +
>> >>  mach-prima2/tsc2100_dev.c                                    |  137
>> >
>> > Any drivers in here should get moved to a proper place in drivers/*/
>> > eventually, out of the subarchitecture code.
>>
>> things related with driver framework/callbacks will be moved out.
>> platform_device data/hardware-related callbacks will be kept. but if
>> device tree supports platform_device data/callbacks good, i will take
>> a look whether we can delete as many as possible.
>
> Regarding platform data, the ideal case would be to not pass any,
> and have the driver itself enquire the settings by looking at device
> tree properties. There may be a few cases where that is not possible,
> or where a callback into platform code ends up simplifying things
> significantly, but that should stay the exception.
really. some hardware-related callbacks are now in arch and make
driver codes simpler and better to cross platform without considering
trivial hardware details.
if they are moved to drivers, the drivers will be very ugly with things like:
#ifdef BOARD_X
....
#elif defined(BOARD_Y)
...
#endif
that is not what people want.

so a temp way is maybe providing funtions in arch as exported symbols
which will be called by drivers. different boards implement them in
different codes.

>
>> > It's not clear yet what will happen in the long run to the split between
>> > mach-* and plat-* directories. Ideally, we would not need them to be
>> > separate if we can completely abstract the SoCs within their broader
>> > families, but we might not get that far before you merge your platform.
>>
>> before prima2 SoC, we have mach-atlas4,  mach-atlas5 and mach-prima.
>> after prima2, we will have mach-atlas6. many ip cores are shared
>> between these SoCs, then there is a plat.
>> but we will not maintain old mach-atlas4,  mach-atlas5 and mach-prima
>> for the current and future kernel. the new mach-atlas6 is the coming
>> SoC we will upstream after mach-prima2.
>
> Ok, makes sense. It may be possible that after you have done all the
> work to convert prima2 to device tree, it will become trivial to support
> the older SoCs as well, but starting with prima2 as you say makes a lot
> of sense.

debugging device tree in prima2 now.

>
>> > What other mach-* do you expect to see in the future using plat-sirfsoc,
>> > and how similar are they to prima2?
>>
>> plat-sirfsoc should be things shared by mach-prima2/mach-atlas6 and
>> other future SoCs.
>
> I see. Note that in the long run, we definitely want to have the option
> to build kernel binaries across different SoC families. It would be
> good to make sure you don't have arbitrary differences in the mach-*
> implementation that get in the way of that later. If prima2 and atlas6
> turn out very similar in the end, it may be best to fold all them together
> with plat-sirfsoc into a single directory. E.g. the TI omap2/3/4
> platforms have all been merged into mach-omap2, despite being
> rather different.

most components of prima2 and atlas6 are similar. i agree we can begin
by a mach-prima2 dir to cover both and delete plat-sirfsoc. looking
whether some day we need a plat-sirfsoc.

>
>> >> for drivers/:
>> >>  Kconfig                             |    2
>> >>  Makefile                            |    1
>> >>  char/sirfsoc_gps.c                  |  878 +++++++++++++
>> >>  char/sirfsoc_gpsdrv.h               |  134 +
>> >>  input/misc/gpio_event.c             |  253 +++
>> >
>> > A new user space interface is always hard to establish. If you want these
>> > to get in, you should start way ahead of the other drivers that simply
>> > implement an existing interface.
>> >
>> > If the gps driver is just a tty device like a serial port, it should
>> > now be moved into drivers/tty.
>>
>> most GPS are /dev/ttySn to userspace, they are connected to SoC by
>> uart.  DSP is one of CSR's main product lines. An internal DSP in SoC
>> handles GPS and we use this driver to communicate with the DSP. i will
>> take a look whether we can have better framework than a simple char
>> device.
>
> From the little I know about GPS, the controllers have a fairly standardized
> serial port interface even across vendors. It would be good to be
> compatible with the existing ones there, e.g. bluetooth or serial GPS that
> all provide a tty interface. If your's is very different and has a
> high-level API, you might want to create a new drivers/gps/ subsystem
> with an architected user interface that works with both your own
> implementation and the serial ones.
> Turning a tty into a high-level interface is normally done using a new tty
> line discipline, similar to how PPP or CAN work over serial lines.

yes. gps generally is an external module connected to SoC's uart.
actually, the char device we are talking is more like firmware inside
a common gps module. it is in lower level than an external interface.
anyway, csr is a company with gps technology. i'd like to figure out
whether we can provide a generic framework.

>
>> >>  nanddisk/Kconfig                    |   17
>> >>  nanddisk/Makefile                   |    5
>> >>  nanddisk/nand.c                     |  937 +++++++++++++
>> >>  nanddisk/nanddisk.h                 |  702 ++++++++++
>> >
>> > How does this relate to drivers/mtd?
>>
>> that is a big issue to upstream. CSR built a NTFL supporting both
>> WINCE/Linux with good performance and proved reliable products. the
>> NTFL is a binary. NAND disk is a up level block driver to call API in
>> the NTFL binary.
>
> Ok, no need to forward port or submit that driver for inclusion then.
>
>> that makes the NAND related codes very difficult to be accepted since
>> it is completely not based on MTD. i hope we can also have a MTD based
>> driver and compare the performance of  UBI on MTD and current
>> solution.
>
> Right, an MTD driver would be required for anyone to build products
> with the mainline kernel, so that sounds like an important thing to
> do. Comparing performance is also always good, so if you find that
> UBI or the FTL in the kernel are lacking there, the MTD maintainers
> will definitely want to know about that.

sure.

>
>> >>  video/Kconfig                       |   24
>> >>  video/Makefile                      |    2
>> >>  video/backlight/Makefile            |    1
>> >>  video/sirfsoc_clcdc.h               |  269 ++++
>> >>  video/sirfsoc_fb.c                  | 2369 +++++++++++++++++++++++++++++++++++
>> >>  video/sirfsoc_vpp.c                 | 1166 +++++++++++++++++
>> >
>> > Have you considered doing a KMS device driver instead of an old-style
>> > frame buffer?
>>
>> it depends on the whole schedule and resources of the related teams.
>> i'd like to see the stronger KMS driver.
>
> There is definitely a trend towards KMS drivers, but no clear mandate yet.
> If you wait long enough, you may not have the choice any more as soon
> as KMS becomes a requirement for new display drivers.

thanks!  definitely that's what we want to follow.

>
>        Arnd
>

-barry
