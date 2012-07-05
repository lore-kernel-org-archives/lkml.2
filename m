Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab2GEI4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 04:56:00 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:43122 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2GEIz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 04:55:58 -0400
MIME-Version: 1.0
In-Reply-To: <1341412452-3808-1-git-send-email-lee.jones@linaro.org>
References: <1341412452-3808-1-git-send-email-lee.jones@linaro.org>
Date: Thu, 5 Jul 2012 10:55:57 +0200
Message-ID: <CACRpkdb1rZQWpuUxQoxqg2eYanf4tnm0SmFkQQBwvSuyYV00Gw@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: Register pinctrl from platform code until
 it's been DT:ed
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        Stephen Warren <swarren@wwwdotorg.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        Patrice CHOTARD <patrice.chotard@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 4:34 PM, Lee Jones <lee.jones@linaro.org> wrote:

> There are some inconsistencies with the way pinctrl devices are named
> when registered from platform code to the ones registered by Device
> Tree. Platform devices look like 'pinctrl-db8500', whereas the ones
> registered from Device Tree look more like 'pinctrl.2'. This leads to
> failure when carrying out name-based searches for known devices.
>
> Until the correct DT bindings have been applied to the pinctrl driver
> it will fail to function correctly. For instance, during a Device
> Tree boot on Snowball no bootlog is visible due to a UART port probe
> failure. Regulators fail in a similar way.

The problem is *NOT* any missing device tree bindings. The place
where the problem appear is in the pin control mapping table, which
uses the string "pinctrl-db8500"

The bindings to pass in the pinctrl mapping from the devcie tree
is generic and already exist:
Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt

The stuff in the file:
arch/arm/mach-ux500/board-mop500-pins.c

Need to be moved over to the device tree. There are plenty of
examples of how to do this in for example:
arch/arm/boot/dts/tegra-seaboard.dts

So what is needed is that someone augment the device tree
with the pinctrl data and disable the registration of the static
maps from the above file if the node exists.

> This patch prevents Device Tree from probing the pinctrl driver and
> ensures registration is completed from platform code instead.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Is the DT machinery really incapable of specifying
the device name to anything else than the bus name?
Can't you do this with AUX_DATA()? I've seen that done in the
past. For example you do:

OF_DEV_AUXDATA("st,nomadik-gpio", 0x8012e000, "gpio.0", NULL),

Can't you just:
OF_DEV_AUXDATA("stericsson,nmk_pinctrl", 0, "pinctrl-db8500", NULL),

And it will happily assign the "pinctrl-db8500" name to it's instantiated
device?

?

Yours,
Linus Walleij
