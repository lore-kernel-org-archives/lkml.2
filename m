Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab2GEJgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 05:36:47 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43065 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2GEJgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 05:36:45 -0400
Message-ID: <4FF56029.2060007@linaro.org>
Date: Thu, 05 Jul 2012 10:36:41 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        Stephen Warren <swarren@wwwdotorg.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        Patrice CHOTARD <patrice.chotard@stericsson.com>
Subject: Re: [PATCH] ARM: ux500: Register pinctrl from platform code until
 it's been DT:ed
References: <1341412452-3808-1-git-send-email-lee.jones@linaro.org> <CACRpkdb1rZQWpuUxQoxqg2eYanf4tnm0SmFkQQBwvSuyYV00Gw@mail.gmail.com>
In-Reply-To: <CACRpkdb1rZQWpuUxQoxqg2eYanf4tnm0SmFkQQBwvSuyYV00Gw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/12 09:55, Linus Walleij wrote:
> On Wed, Jul 4, 2012 at 4:34 PM, Lee Jones <lee.jones@linaro.org> wrote:
>
>> There are some inconsistencies with the way pinctrl devices are named
>> when registered from platform code to the ones registered by Device
>> Tree. Platform devices look like 'pinctrl-db8500', whereas the ones
>> registered from Device Tree look more like 'pinctrl.2'. This leads to
>> failure when carrying out name-based searches for known devices.
>>
>> Until the correct DT bindings have been applied to the pinctrl driver
>> it will fail to function correctly. For instance, during a Device
>> Tree boot on Snowball no bootlog is visible due to a UART port probe
>> failure. Regulators fail in a similar way.
>
> The problem is *NOT* any missing device tree bindings. The place
> where the problem appear is in the pin control mapping table, which
> uses the string "pinctrl-db8500"
>
> The bindings to pass in the pinctrl mapping from the devcie tree
> is generic and already exist:
> Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt

Yes I saw these, but that still doesn't help our situation. A way to 
link the mapping tables registered with a platform device to the driver 
started with Device Tree is missing. This can be over-come by several 
methods:

a) Create a binding which takes a device name to tag onto a mapping. 
This can be used in the name based searches currently employed by 
pinctrl. This is the binding I was talking about in the commit log. In 
retrospect, I can see that this is not the correct solution.

b) Continue using Device Tree and force the 'pinctrl-db8500' device name 
which any string based searches will be expecting with AUXDATA(). We do 
similar things for clock-names already. However, this must be seen as a 
hacky work-around and it to be removed after full enablement has been 
taken place.

c) Prevent the pinctrl driver from being started by Device Tree and 
allow platform code to register the device until we can populate the 
device tree with all of the mappings. This is the way you advised me to 
do it [see below] and it's what this patch tries to achieve.

Linus said:
> In my eyes the problem is introduced by that commit ["pinctrl-nomadik:
> Allow Device Tree driver probing"]. So I'll revert it and go for a
> complete approach for v3.6

Hopefully now you can see where I'm coming from.

> The stuff in the file:
> arch/arm/mach-ux500/board-mop500-pins.c
>
> Need to be moved over to the device tree.

Agreed, but this patch aims to fix an -rc bug. The full Device Tree 
implementation isn't likely to reach Mainline until at least v3.6, as 
you already mentioned.

 > There are plenty of
> examples of how to do this in for example:
> arch/arm/boot/dts/tegra-seaboard.dts

I don't see this file anywhere?

> So what is needed is that someone augment the device tree
> with the pinctrl data and disable the registration of the static
> maps from the above file if the node exists.

Right, future work.

>> This patch prevents Device Tree from probing the pinctrl driver and
>> ensures registration is completed from platform code instead.
>>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>
> Is the DT machinery really incapable of specifying
> the device name to anything else than the bus name?
> Can't you do this with AUX_DATA()? I've seen that done in the
> past. For example you do:
>
> OF_DEV_AUXDATA("st,nomadik-gpio", 0x8012e000, "gpio.0", NULL),
>
> Can't you just:
> OF_DEV_AUXDATA("stericsson,nmk_pinctrl", 0, "pinctrl-db8500", NULL),
>
> And it will happily assign the "pinctrl-db8500" name to it's instantiated
> device?

Yes, this will work, see option 'b' above.

I'll submit another patch.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


