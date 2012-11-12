Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab2KLUVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 15:21:48 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46695 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2KLUVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 15:21:47 -0500
Message-ID: <50A15A54.3090803@wwwdotorg.org>
Date: Mon, 12 Nov 2012 13:21:40 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] RFC: pinctrl: grab default handler with bus notifiers
References: <1352636539-6318-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1352636539-6318-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2012 05:22 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This makes the pinctrl subsystem auto-grab the pinctrl handle and
> set the "default" (PINCTRL_STATE_DEFAULT) state for every device
> that is present on the platform or AMBA (PrimeCell) bus right
> before probe. This will account for the lion's share of embedded
> silicon devcies. The behaviour is achieved using bus notifiers
> on the platform and AMBA (PrimeCell) busses.

Doing this seems reasonable.

> Notice that the patch disregards deferral as per above:
...
> Another solution that was discussed was whether to move
> the default pinctrl handle and state grab to the device
> core as an optional field in struct device itself, but
> I'd like to first propose this less intrusive mechanism.

I think doing that approach makes a lot more sense; wouldn't it
completely avoid the issues with deferred probe that this notifier-based
method can't solve? It would also be very much in line with e.g.
dev_get_regmap() - if every resource that a driver required were handled
like that, then deferred probe could be significantly isolated into the
driver core rather than in every driver...

> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> index da40efb..b6c27b1 100644
> --- a/Documentation/pinctrl.txt
> +++ b/Documentation/pinctrl.txt
> @@ -972,6 +972,19 @@ pinmux core.
>  Pin control requests from drivers
>  =================================
>  
> +When a device driver is about to probe on the platform or AMBA (PrimeCell)
> +bus,

Why not make this apply to every device? I don't think the specific bus
type impacts whether pinctrl would be useful?

> @@ -1097,8 +1110,8 @@ situations that can be electrically unpleasant, you will certainly want to
> -The above can be hidden: using pinctrl hogs, the pin control driver may be
> -setting up the config and muxing for the pins when it is probing,
> +The above can be hidden: using device notifiers, the pinctrl core may be
> +setting up the config and muxing for the pins when the device is probing,
>  nevertheless orthogonal to the GPIO subsystem.

Why removing "using pinctrl hogs"; can't "it" (although I didn't check
what "it" is...) be hidden using either pinctrl hogs or device notifiers?

>  But there are also situations where it makes sense for the GPIO subsystem
> @@ -1144,6 +1157,13 @@ PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-foo", NULL /* group */, "power_func")
>  
>  This gives the exact same result as the above construction.
>  
> +This should not be used for any kind of device which is represented in
> +the device model. For platform and AMBA (PrimeCell) devices, such as found
> +in many SoC:s, the pinctrl core will listen to notifications from these
> +buses and attempt to do pinctrl_get_select_default() for these devices
> +right before their device drivers are probed, so hogging these will just
> +make the model look strange.

(re: the first sentence:) Why not? For the device tree case, that's
forcing DT authors to sprinkle the device tree across all devices
throughout the tree, rather than having a simple single "hog" table in
the pin controller itself. At least where there's no dynamic muxing
required, I don't think it makes any semantic difference whether the
pinctrl configuration is represented as a single "pinmux HW"
configuration, or split up per-device, and writing the single
centralized configuration is easier.

> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c

> @@ -684,9 +687,16 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev)
>  	if (WARN_ON(!dev))
>  		return ERR_PTR(-EINVAL);
>  
> +	/*
> +	 * See if somebody else (such as the pinctrl core, using the
> +	 * notifiers) has already obtained a handle to the pinctrl for
> +	 * this device. In that case, return another pointer to it.
> +	 */
>  	p = find_pinctrl(dev);
> -	if (p != NULL)
> -		return ERR_PTR(-EBUSY);
> +	if (p != NULL) {
> +		dev_dbg(dev, "obtain a copy of previously claimed pinctrl\n");
> +		return p;

You'd want to implement full reference-counting then; IIRC, that's why I
banned pinctrl_get() running twice in the original code.
