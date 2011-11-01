Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab1KAHDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 03:03:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37331 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab1KAHDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 03:03:07 -0400
MIME-Version: 1.0
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D087B34BE8B@wm021.weinmann.com>
References: <EF2E73589CA71846A15D0B2CDF79505D087B34BE51@wm021.weinmann.com>
	<CAF8ieYXPMgUzekth7PGxC3AgYNKac-HQ21D3vvB5J3SLOatmfQ@mail.gmail.com>
	<EF2E73589CA71846A15D0B2CDF79505D087B34BE8B@wm021.weinmann.com>
Date: Tue, 1 Nov 2011 00:03:05 -0700
Message-ID: <CAF8ieYWY2RwkgPERgagvw2bby8Y+UFgrYr3zPOb27e=bfOH-vg@mail.gmail.com>
Subject: Re: [PATCH] i2c-gpio.c: correct logic of pdata->scl_is_open_drain
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 10:59 PM, Voss, Nikolaus <N.Voss@weinmann.de> wrote:
> Hi Havard,
>
>> {sda,scl}_is_open_drain indicates that the GPIO hardware is set up to
>> do open drain so the software doesn't have to, i.e.
>> gpio_set_value(pin, 1) will turn off the output driver rather than
>> drive the pin high, so the _val functions will do the right thing.
>
> gpio_set_value(pin, 1) drives the output high same as
> gpio_direction_output(pin, 1) does (documented in Documentation/gpio.txt),
> so the gpio will be changed from open-drain to push-pull.

Normally, yes. But if the pin is configured as open-drain (which is
not covered by the GPIO API because it's highly platform-specific),
gpio_set_value(pin, 1) will turn off the output driver.

> In contrast, gpio_direction_input(pin) will turn off the output driver.

Yes, but it's (usually) much more expensive.

> Open-drain io is bound to "!is_open_drain" and push-pull io is bound to
> "is_open_drain", so I still think this should be the other way round.

It is never correct to use push-pull I/O for i2c, so the flag does not
specify the desired behavior of the driver, it specifies what the
hardware has been configured to do so that the driver can choose the
cheapest way to do open-drain I/O.

And even if you could argue that the flag should be inverted, it has
had the same meaning since the driver was introduced several years
ago, so changing it now will break every single platform which
currently uses i2c-gpio.

Havard
