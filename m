Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab1FOORV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 10:17:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38045 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab1FOORR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 10:17:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xySBIj3HcmUd5sCgvIowEinKCkjt993yjw30QpT4bkxkUCQt6k3AzzrlreNSRIEONc
         vMoIlAScKKs7LOEfyUIvnj42GS/kAwdxUXMS3iVDa3JBwWyPOH/oWgDd12BKV492Nyry
         BxHM5rx4oI/3ldIl/mEOy+Sk+bhfHnTFpgsKQ=
MIME-Version: 1.0
In-Reply-To: <201106142316.02812.rjw@sisk.pl>
References: <201106112223.04972.rjw@sisk.pl>
	<201106112240.11621.rjw@sisk.pl>
	<BANLkTi=-1Fpp9L17T7CwxoO9JfSes4FeKg@mail.gmail.com>
	<201106142316.02812.rjw@sisk.pl>
Date: Wed, 15 Jun 2011 23:17:15 +0900
Message-ID: <BANLkTi=u_eyGZt9e0CuVpyz9B08HarEyVw@mail.gmail.com>
Subject: Re: [PATCH 8/8] ARM / shmobile: Support for I/O PM domains for SH7372 (v5)
From: Magnus Damm <magnus.damm@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 6:16 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, June 14, 2011, Magnus Damm wrote:
>> On Sun, Jun 12, 2011 at 5:40 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > From: Rafael J. Wysocki <rjw@sisk.pl>
>> >
>> > Use the generic power domains support introduced by the previous
>> > patch to implement support for power domains on SH7372.
>> >
>> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>> > ---
>>
>> Thanks for your work on this. I just tried this on my Mackerel board,
>> but I can't seem to get the pd_power_up() and pd_power_down()
>> callbacks to be executed. It is probably a misconfiguration from my
>> side.
>
> They trigger for me e.g. after doing
>
> # echo 3 > /sys/devices/platform/sh_mobile_lcdc_fb.0/graphics/fb0/blank
>
> Attached is the .config I've been using.

Thanks, I can trigger using sysfs and your kernel configuration.

However, I assumed it also would work when the sceen saver kicked in.
I recall it being fbcon that controls the screen save, perhaps
something else. So just wait a bit and see if you also can reproduce
it. The console gets black but the power is still on...

Also forcing to go back to powered-on state (see below) doesn't work that well:
# echo 0 > /sys/devices/platform/sh_mobile_lcdc_fb.0/graphics/fb0/blank

It looks like we loose the panning information somehow. Most likely a
LCDC driver bug. Unless the driver callbacks are not being invoked as
expected.

Also, there is garbage in on the screen if FB_SH_MOBILE_MERAM is
enabled. The MERAM hardware is a 1.5 MiB memory block that can be used
as a LCD cache. It sits in the same hardware power domain as the
LCDCs. I don't think the MERAM software supports power down
unfortunately. Disabling MERAM support removes the garbage on the
screen.

>> Here's some feedback on the sh7372-specific code:
>>
>> > --- linux-2.6.orig/arch/arm/mach-shmobile/Kconfig
>> > +++ linux-2.6/arch/arm/mach-shmobile/Kconfig
>> > @@ -19,6 +19,7 @@ config ARCH_SH7372
>> >        select CPU_V7
>> >        select SH_CLK_CPG
>> >        select ARCH_WANT_OPTIONAL_GPIOLIB
>> > +       select PM_GENERIC_DOMAINS
>>
>> We want to support a single ARM binary for multiple boards,
>
> Surely CONFIG_ARCH_SH7372 will be set in that binary?
>
>> so this should be enabled for all SoCs in mach-shmobile as a whole.
>
> OK, where exactly do you want me to move it?

Ideally to ARCH_SHMOBILE in arch/arm/Kconfig.

>> > --- linux-2.6.orig/arch/arm/mach-shmobile/pm-sh7372.c
>> > +++ linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
>> > @@ -15,16 +15,97 @@
>> >  #include <linux/list.h>
>> >  #include <linux/err.h>
>> >  #include <linux/slab.h>
>> > +#include <linux/pm_runtime.h>
>> > +#include <linux/platform_device.h>
>> >  #include <asm/system.h>
>> >  #include <asm/io.h>
>> >  #include <asm/tlbflush.h>
>> >  #include <mach/common.h>
>> > +#include <mach/sh7372.h>
>> >
>> >  #define SMFRAM 0xe6a70000
>> >  #define SYSTBCR 0xe6150024
>> >  #define SBAR 0xe6180020
>> >  #define APARMBAREA 0xe6f10020
>> >
>> > +#define SPDCR 0xe6180008
>> > +#define SWUCR 0xe6180014
>> > +#define PSTR 0xe6180080
>> > +
>> > +struct sh7372_domain_data {
>> > +       unsigned int bit_shift;
>> > +};
>>
>> Is it possible to make struct sh7372_domain_data include struct
>> generic_pm_domain?
>
> It should be possible to do that.
>
> Do I understand it correctly that you want one structure definition per
> power domain instead of the two?

Yes, at least that's what I would do to keep the data together. I
don't care that much though, so feel free to implement it however
you'd like.

>> > +core_initcall(sh7372_power_domains_init);
>>
>> This initcall is going to be executed regardless which SoC we're
>> running on. We only want it called for sh7372 though.
>
> OK
>
>> If you look at other SoC-specific code then you will notice that
>> initcalls are only used for functions in mach-shmobile/ that are
>> common for all SoCs implemented under mach-shmobile.
>>
>> You most likely want to initialize from sh7372_pm_init(), but for that
>> to work you probably have to reorder your code inside mackerel_init().
>
> OK, I'll figure out how to do the initialization correctly.

Please do!

Thanks,

/ magnus
