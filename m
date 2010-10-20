Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab0JTANN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 20:13:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53828 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab0JTANM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 20:13:12 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Felipe Balbi <me@felipebalbi.com>, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
Organization: Deep Root Systems, LLC
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
	<1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
	<20101019103234.GI31170@legolas.emea.dhcp.ti.com>
	<AANLkTinXzMQXoyyu+anSCvSuE9w3FWAP5HswDS0kfpzE@mail.gmail.com>
	<20101019111613.GJ31170@legolas.emea.dhcp.ti.com>
	<AANLkTikkMphKa2DGGtWxy-3LpFX0kn92UEYPj==Euzok@mail.gmail.com>
	<20101019115236.GL31170@legolas.emea.dhcp.ti.com>
	<AANLkTim3NsgjC3Nh8VCCrx4cV1Y+kn38=30=en0KCft6@mail.gmail.com>
	<6ea089ac75d4d15d88698468eacb7fe3@secure211.sgcpanel.com>
	<AANLkTinYM5aavk9_jcTTymff=OY+Yyv8T6C+dmMih0p_@mail.gmail.com>
	<20101019234414.GB30991@atomide.com>
Date: Tue, 19 Oct 2010 17:13:07 -0700
In-Reply-To: <20101019234414.GB30991@atomide.com> (Tony Lindgren's message of
	"Tue, 19 Oct 2010 16:44:14 -0700")
Message-ID: <87fww1u3fw.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Lindgren <tony@atomide.com> writes:

> * Felipe Contreras <felipe.contreras@gmail.com> [101019 13:43]:
>> On Tue, Oct 19, 2010 at 6:05 PM, Felipe Balbi <me@felipebalbi.com> wrote:
>> > On Tue, 19 Oct 2010 17:32:07 +0300, Felipe Contreras
>> > <felipe.contreras@gmail.com> wrote:
>> >> There are two parts, one part is to fix the Kconfigs, and another was
>> >> to come up with a way to replace the horrible defconfigs. Part two is
>> >> mostly fixed thanks to 'make savedefconfig', since the defconfigs are
>> >> not so horrible any more, but part one is a continued effort.
>> >>
>> >> For part two Linus had the idea to use Kconfigs instead of defconfigs,
>> >> but they would mostly look very similar to the current ones generated
>> >> by 'make savedefconfig'.
>> >>
>> >> I don't know what makes you think Linus didn't want part one to be
>> >> done. He wanted the Kconfig.rx51 to be human readable, and you are
>> >> proposing that TWL4030_USB should be manually added there... I don't
>> >> think TWL4030_USB says anything to human beings.
>> >
>> > I don't read anywhere Linus saying we should clutter drivers/*/Kconfig
>> > with defaults. I think you're inverting things, it's much better
>> > to select TWL4030_USB when you enable MACH_OMAP_RX51 then default y
>> > if MACH_OMAP_RX51.
>> 
>> So say, if you have 100 board defconfigs with OMAP3 chips and TWL4030,
>> each and every one of them should select both USB_MUSB_HDRC and
>> TWL4030_USB?
>> 
>> And you are saying if somebody is doing 'make menuconfig', that person
>> should somehow know that _obviously_ he needs TWL4030_USB in order to
>> use USB_MUSB_HDRC, or USB_G_NOKIA?
>
> Hey we're already dealing with stuff like this :)
>
> See ARCH_OMAP2PLUS_TYPICAL in arch/arm/mach-omap2/Kconfig:
>
> config ARCH_OMAP2PLUS_TYPICAL
>         bool "Typical OMAP configuration"
>         default y
>         select AEABI
>         select REGULATOR
>         select PM
>         select PM_RUNTIME
>         select VFP
>         select NEON if ARCH_OMAP3 || ARCH_OMAP4
>         select SERIAL_OMAP
>         select SERIAL_OMAP_CONSOLE
>         select I2C
>         select I2C_OMAP
>         select MFD
>         select MENELAUS if ARCH_OMAP2
>         select TWL4030_CORE if ARCH_OMAP3 || ARCH_OMAP4
>         select TWL4030_POWER if ARCH_OMAP3 || ARCH_OMAP4
>         help
>           Compile a kernel suitable for booting most boards
>
> This actually produces a booting omap2+ kernel with no .config
> at all. I've tested it with:
>
> $ echo CONFIG_ARCH_OMAP=y > .config
> $ yes "" | ARCH=arm make oldconfig
>
> So if you have something that's needed on almost every omap,
> you can select it there.

One thing I don't like about this is that there is currently no way to
'select' as a module.

In order to get to a minimal kernel, in theory, we don't need regulator,
i2c, MFD, or twl4030* built in.  They should all be built as modules.
Yes, there are some assumptions made today that some of these things are
built in, and then are used from init code, but that is broken.

If someone is looking for a good omap-kernel-janitors project, I would
suggest getting to a *really* minimal OMAP2+ kernel with everything
possible built as modules to be a very good project.

Kevin
