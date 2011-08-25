Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1HYHKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 03:10:46 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51164 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab1HYHKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 03:10:42 -0400
MIME-Version: 1.0
In-Reply-To: <20110824092147.GS9232@opensource.wolfsonmicro.com>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
	<1772239.ndMLD9ec3r@wuerfel>
	<20110817080327.GD13460@opensource.wolfsonmicro.com>
	<201108171242.24918.arnd@arndb.de>
	<1313586241.19990.94.camel@finisterre.wolfsonmicro.main>
	<CACRpkdbSVF1FxpuocoXkDFH3vDQc4OoTwjU+9iqj0=vVs3R3dQ@mail.gmail.com>
	<1313636407.19990.102.camel@finisterre.wolfsonmicro.main>
	<CACRpkdbSQWej3iZF7qww1q5KW6kQTW6bqrVs4+rkLvhP5qu5fA@mail.gmail.com>
	<20110824092147.GS9232@opensource.wolfsonmicro.com>
Date: Thu, 25 Aug 2011 09:10:41 +0200
Message-ID: <CACRpkda+Yx1GCD_sUywRjXsxWa0611rt8Sd+BazTe93RVnbt7g@mail.gmail.com>
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kenneth Heitke <kheitke@codeaurora.org>,
        sdharia@codeaurora.org, David Brown <davidb@codeaurora.org>,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        rdunlap@xenotime.net, rmk+kernel@arm.linux.org.uk,
        john.stultz@linaro.org, akpm@linux-foundation.org, ohad@wizery.com,
        gregkh@suse.de, stefanr@s5r6.in-berlin.de, lethal@linux-sh.org,
        linville@tuxdriver.com, zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 11:21 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Aug 24, 2011 at 11:15:56AM +0200, Linus Walleij wrote:
>
>> That means that the regulators handling the slimbus devices
>> will need to be enabled before the drivers issue regulator_get()
>> and regulator_enable() on them.
>
> What makes you say that?  We've been discussing how we register Slimbus
> devices other than via hotplug.

OK it's founded in Arnd's remarks that the "Linux model" is to
use auto-detection as much as possible, which means hotplug
*and* coldplug, i.e. auto-discovery at boot, by probing the bus
for devices.

If the device is not powered on boot I understand that it
cannot be auto-discovered.

So then you need platform data or device tree or similar to
register the device. Which is frowned upon, if there exist
other ways to detect the hardware.

>> Does the regulator constraint .always_on have this semantic
>> effect, so the regulator framework can power up the devices
>> without their drivers claiming the regulators first?
>
> It does have that effect but it would (as one might expect) force the
> regulators to always be on which is unacceptable for actual systems.

Aha, no good. :-(

>> Or would we need a new .boot_enable flag to handle that?
>
> There is such a flag already.

I really mean .boot_enable, not .boot_on.

.boot_enable would turn on the regulator at boot no matter
whether it was on or not at boot, and make it possible for
devcie drivers to turn it off later by regulator disable.
Probably by turning it on but leaving the use_count at zero
so that it'd be disabled after the initlevels if no device claimed
it and explictly enabled it before that.

This would power the device during init so the bus could
be probed for devices (coldplugged).

But maybe this is a misunderstanding on my side: maybe
slimbus devices can be hotplugged and discovered, so the
bus driver will tell you that a new device arrived, whereas
it cannot be coldplugged, i.e. you cannot ask the bus to
enumerate and say deliver the addresses to the devices
on it?

>> OK so if we can just power the device the bus can probably
>> autodetect all devices on it, it seems.
>
> Should be able to, yes, though we'll still need to bind
> platform/OF data to them.

OK so what you're saying is that it can never be made to
have self-contained drivers without any accompanying platform
data or device tree info?

Thanks,
Linus Walleij
