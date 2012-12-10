Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab2LJSap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 13:30:45 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47769 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2LJSao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 13:30:44 -0500
MIME-Version: 1.0
In-Reply-To: <1355120784-31118-4-git-send-email-a.kesavan@samsung.com>
References: <1355120784-31118-1-git-send-email-a.kesavan@samsung.com>
	<1355120784-31118-2-git-send-email-a.kesavan@samsung.com>
	<1355120784-31118-3-git-send-email-a.kesavan@samsung.com>
	<1355120784-31118-4-git-send-email-a.kesavan@samsung.com>
Date: Mon, 10 Dec 2012 10:30:42 -0800
X-Google-Sender-Auth: vlcrvj5_NJ-WRpT43uPGWDUAa6E
Message-ID: <CAD=FV=Wte=n8=nheTPuSVMDgAuzmsQ09PFNafS3BOAXUAvO_vg@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] dt: Document: Add optional MAX77686 operating
 mode bindings
From: Doug Anderson <dianders@chromium.org>
To: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, olof@lixom.net,
        grant.likely@secretlab.ca, thomas.abraham@linaro.org,
        kgene.kim@samsung.com, sameo@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhilash,

Thanks for posting up these patches.  Just going to do my commenting
directly on the documentation patch since they are high-level
comments.

On Sun, Dec 9, 2012 at 10:26 PM, Abhilash Kesavan <a.kesavan@samsung.com> wrote:
> Add documenatation for various operating mode capabilities of
> the MAX77686 PMIC.
>
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/max77686.txt |    6 ++++++

This should probably be squashed with PATCH 2/3.  It seems to be best
to introduce documentation in the same patch as first usage.


>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/mfd/max77686.txt b/Documentation/devicetree/bindings/mfd/max77686.txt
> index c6a3469..f2867a9 100644
> --- a/Documentation/devicetree/bindings/mfd/max77686.txt
> +++ b/Documentation/devicetree/bindings/mfd/max77686.txt
> @@ -13,6 +13,12 @@ Required properties:
>  - interrupts : This i2c device has an IRQ line connected to the main SoC.
>  - interrupt-parent : The parent interrupt controller.
>
> +optional properties:
> +- max77686-opmode : The regulators of max77686 have various operating mode
> +  capabilities such as low power mode, standby mode (controlled by PWRREQ
> +  signal) etc. Check the regulator CTRL register for the bits setting these
> +  modes.

I have a feeling we're going to want something a little more generic
than just whacking a register value straight into the device tree.

I would propose the following for LDOs to match the generic regulator
define, but someone with more device tree experience may have a better
idea.  The idea is to map to the generic set_suspend_mode() /
set_mode():
  regulator-suspend-mode = <REGULATOR_MODE_XXX constant>
  regulator-mode = <REGULATOR_MODE_XXX constant>

The max77686 appears to support NORMAL and IDLE mode for most LDOs, so
the only reasonable values for these two would be 2 and 4.  It appears
that it would also be nonsensical (impossible to map to a register
value) to have REGULATOR_MODE_NORMAL for suspend and
REGULATOR_MODE_IDLE for the normal running mode.


For bucks 1-3, you'd just have a boolean property mapping to
set_suspend_disable().  Perhaps:
  regulator-suspend-en;

That wouldn't allow access to the "Forced low power mode" of bucks
1-3, but I don't think there's any code to support that now so nobody
must be using it.


Given that all of the above maps nicely into regulator constants and
regulator functions, I'd imagine that support could be added straight
into the generic regulator code and you won't have to touch max77686
at all (unless you wanted to add support for set_mode(), which doesn't
seem to be there).


All of the above would set _defaults_ for regulators.  If device-tree
people think it's wise, we could add "-default" into the names.

> +
>  Optional node:
>  - voltage-regulators : The regulators of max77686 have to be instantiated
>    under subnode named "voltage-regulators" using the following format.
> --
> 1.7.8.6
>

-Doug
