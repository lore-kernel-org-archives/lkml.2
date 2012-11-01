Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934406Ab2KALmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 07:42:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58340 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab2KALm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 07:42:29 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: Re: Fwd: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Organization: Deep Root Systems, LLC
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
	<20121024161429.GA16350@core.coreip.homeip.net>
	<CACRpkdai3NocZQnW6YRF+k6GXUSx3P_Ge=F-tkuivrFm6tBbLg@mail.gmail.com>
	<4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
	<CACRpkdaiLXVeUg1quuw3XPTenbKOjn+aWbGQezpcyvzQCtCWow@mail.gmail.com>
	<20121030113407.GA24335@sirena.org.uk>
	<CACRpkdapQJY0aoam741O0fb8EeM9BLk_Psq5TaPG84J7wEvCLw@mail.gmail.com>
	<87obji8kta.fsf@deeprootsystems.com>
	<CACRpkdbCk9+HSBPtfT-1dO8paSRYJ5VXX_0SxiyxgrObnJEvmQ@mail.gmail.com>
	<CACRpkdaBmg7wtX0WsaxMw=n1sKDN5YphK=y8tzAx_CF=JnUqvw@mail.gmail.com>
Date: Thu, 01 Nov 2012 12:42:21 +0100
In-Reply-To: <CACRpkdaBmg7wtX0WsaxMw=n1sKDN5YphK=y8tzAx_CF=JnUqvw@mail.gmail.com>
	(Linus Walleij's message of "Thu, 1 Nov 2012 09:56:48 +0100")
Message-ID: <874nl9tuqq.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij <linus.walleij@linaro.org> writes:

> On Wed, Oct 31, 2012 at 9:10 PM, Kevin Hilman
> <khilman@deeprootsystems.com> wrote:
>
>> Linus Walleij <linus.walleij@linaro.org> writes:
>
>
>>
>> > piece of hardware, this would be the right thing to do,
>> > and I think the in-kernel examples are all "simple",
>> > e.g. arch/arm/mach-omap2/powerdomain* is all about
>> > power domains and nothing else,
>>
>> FYI... that code isn't the same as PM domain.
>
>
> This sort of points to a core problem here. Our terminologies are
> ambiguous that we cannot understand each others code. As long
> as <linux/pm_domain.h> begins:
>
> /*
>  * pm_domain.h - Definitions and headers related to device power domains.
>  *
>
> But arguably that should just be patched (I think there are a few
> remnants in the code still implying that these things are only about
> power).

Agreed.  The terminology is confusing, and any situations like this in
the code/comments/docs should be patched.

When PM domains were introduced, I was the first to complain that we
shouldn't use the term power domain so as not to be confused with HW
concepts, so we settled on the term 'PM domain.'  Ultimately, it's just
a configurable grouping of devices whose callbacks happen during PM
transitions.

>>
>>  That code is for the
>> *hardware* powerdomains, not the software concept of "PM domain."  In
>> OMAP, PM domain is implmented at the omap_device level.  And omap_device
>> is the abstraction of an IP block that knows about all the PM related
>> register settings, clocks, HW powerdomain, voltage domain, PM related
>> pin-muxing etc. etc.    All of these things are abstracted in an
>> omap_device, so that the PM domain implementation for OMAP looks rather
>> simple (c.f. omap_device_pm_domain in arch/arm/plat-omap/omap_device.c.)
>
>
> OK following now...
>
>>
>> > I think the lesser of two evils is the distributed approach,
>>
>> The pinctrl examples I've seen mentioned so far are all PM related
>>
>> (sleep, idle, wakeup, etc.) so to me I think they still belong in
>> PM domains (and that's how we handle the PM related pins in OMAP.)
>
>
> Well, the pinctrl grabbers in these drivers are using these states also
> for platforms that do not even select CONFIG_PM.  For example
> mach-nomadik is quite happy that the PL011 driver is thusly
> muxing in its pins. And would require refactoring to use PM
> domains.

If CONFIG_PM is disabled, then is it safe to assume that the pins in
question are probably only done once at init time.  I assume during
->probe(). ?

>
> So basically this requirement comes down to:
>
> - When dealing with a SoC IP block driver
>
> - That need to multiplex pins
>
> - Then your SoC must select CONFIG_PM and
>   CONFIG_PM_RUNTIME andb
>   CONFIG_PM_GENERIC_DOMAINS and implement
>   proper domain handling hooks.
>
> Is this correct? 

I would say yes.  Currently, PM domains are the way to hook SoC-specific
integration details into PM transitions.

However, if what we want/need are only ways to introduce SoC-specific
integration details into non-PM transitions (e.g. probe/remove), maybe
bus notifiers would suffice here.  e.g. you'd get a bus notifier when
the device is added/attached and any init-time pinctrl setup could be
done then.  This still keeps drivers clean of SoC-specific integration
data/code, and also allows that to happen whether or not PM features are
enabled.

Kevin
