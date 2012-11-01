Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195Ab2KANWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 09:22:18 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33793 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab2KANWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 09:22:13 -0400
MIME-Version: 1.0
In-Reply-To: <874nl9tuqq.fsf@deeprootsystems.com>
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
	<874nl9tuqq.fsf@deeprootsystems.com>
Date: Thu, 1 Nov 2012 14:22:11 +0100
Message-ID: <CACRpkdarSNg1zACZKGBt1ypMzE+-KF-o594EcZ1EP484v+4HRw@mail.gmail.com>
Subject: Re: Fwd: [PATCHv2] Input: omap4-keypad: Add pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 12:42 PM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
> [Me]
>> Well, the pinctrl grabbers in these drivers are using these states also
>> for platforms that do not even select CONFIG_PM.  For example
>> mach-nomadik is quite happy that the PL011 driver is thusly
>> muxing in its pins. And would require refactoring to use PM
>> domains.
>
> If CONFIG_PM is disabled, then is it safe to assume that the pins in
> question are probably only done once at init time.  I assume during
> ->probe(). ?

Sadly no.

Consider drivers/tty/serial/amba-pl011.c

Many ARM platforms have several instances of PL011, and not all of
them have CONFIG_PM & friends, so it's a good example.

Here the driver will probe and currently fetch a pinctrl handle and
looks up two states: "default", which refers to the situation you
describe, and optionally "sleep" which will put pins into a
low-power state.

The driver will currently put the pins into the "sleep" state when
.shutdown() is called by something (userspace or in-kernel users).

So in the new suggested scheme using runtime PM, this
would have to be replaced by pm_runtime_get[_sync]()
and pm_runtime_put() hints and the current pin handling
deleted, and for each platform using this driver instead
implement a PM domain to do the same thing.

Else you loose this runtime power optimization.

This is what I refer to the all-or-nothing charcter of
runtime PM domains... but maybe it's a good thing,
I haven't quite made my mind up about it.

> (...) if what we want/need are only ways to introduce SoC-specific
> integration details into non-PM transitions (e.g. probe/remove), maybe
> bus notifiers would suffice here.  e.g. you'd get a bus notifier when
> the device is added/attached and any init-time pinctrl setup could be
> done then.  This still keeps drivers clean of SoC-specific integration
> data/code, and also allows that to happen whether or not PM features are
> enabled.

It doesn't cut it for any of our drivers as shown above,
but it would work for the patch in $SUBJECT.

It sounds like the way silicon clocks are handled on
SH am I right?

Yours,
Linus Walleij
