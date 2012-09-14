Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab2INOfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:35:36 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53389 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147Ab2INOfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:35:33 -0400
Date: Fri, 14 Sep 2012 16:35:34 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2] pinctrl: document semantics vs GPIO
Message-ID: <20120914143534.GB25696@glitch>
Mail-Followup-To: Linus Walleij <linus.walleij@stericsson.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Stephen Warren <swarren@nvidia.com>,
	Anmar Oueja <anmar.oueja@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
References: <1347630587-31014-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347630587-31014-1-git-send-email-linus.walleij@stericsson.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 03:49:47PM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> The semantics of the interactions between GPIO and pinctrl may be
> unclear, e.g. which one do you request first? This amends the
> documentation to make this clear.
> 
> Reported-by: Domenico Andreoli <cavokz@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - Reworded a bit in accordance with Stephens feedback.
> ---
>  Documentation/pinctrl.txt | 57 +++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 55 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> index 1479aca..e2dfc85 100644
> --- a/Documentation/pinctrl.txt
> +++ b/Documentation/pinctrl.txt
> @@ -289,6 +289,11 @@ Interaction with the GPIO subsystem
>  The GPIO drivers may want to perform operations of various types on the same
>  physical pins that are also registered as pin controller pins.
>  
> +First and foremost, the two subsystems can be used as completely orthogonal,
> +see the section named "pin control requests from drivers" and
> +"drivers needing both pin control and GPIOs" below for details. But in some
> +situations a cross-subsystem mapping between pins and GPIOs is needed.
> +
>  Since the pin controller subsystem have its pinspace local to the pin
>  controller we need a mapping so that the pin control subsystem can figure out
>  which pin controller handles control of a certain GPIO pin. Since a single
> @@ -359,6 +364,7 @@ will get an pin number into its handled number range. Further it is also passed
>  the range ID value, so that the pin controller knows which range it should
>  deal with.
>  
> +
>  PINMUX interfaces
>  =================
>  
> @@ -960,8 +966,8 @@ all get selected, and they all get enabled and disable simultaneously by the
>  pinmux core.
>  
>  
> -Pinmux requests from drivers
> -============================
> +Pin control requests from drivers
> +=================================
>  
>  Generally it is discouraged to let individual drivers get and enable pin
>  control. So if possible, handle the pin control in platform code or some other
> @@ -969,6 +975,11 @@ place where you have access to all the affected struct device * pointers. In
>  some cases where a driver needs to e.g. switch between different mux mappings
>  at runtime this is not possible.
>  
> +A typical case is if a driver needs to switch bias of pins from normal
> +operation and going to sleep, moving from the PINCTRL_STATE_DEFAULT to
> +PINCTRL_STATE_SLEEP at runtime, re-biasing or even re-muxing pins to save
> +current in sleep mode.
> +
>  A driver may request a certain control state to be activated, usually just the
>  default state like this:
>  
> @@ -1058,6 +1069,48 @@ registered. Thus make sure that the error path in your driver gracefully
>  cleans up and is ready to retry the probing later in the startup process.
>  
>  
> +Drivers needing both pin control and GPIOs
> +==========================================
> +
> +Again, it is discouraged to let drivers lookup and select pin control states
> +themselves, but again sometimes this is unavoidable.
> +
> +So say that your driver is fetching its resources like this:
> +
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/gpio.h>
> +
> +struct pinctrl *pinctrl;
> +int gpio;
> +
> +pinctrl = devm_pinctrl_get_select_default(&dev);
> +gpio = devm_gpio_request(&dev, 14, "foo");
> +
> +Here we first request a certain pin state and then request GPIO 14 to be
> +used. If you're using the subsystems orthogonally like this, you should
> +nominally always get your pinctrl handle and select the desired pinctrl
> +state BEFORE requesting the GPIO. This is a semantic convention to avoid
> +situations that can be electrically unpleasant, you will certainly want to
> +mux in and bias pins in a certain way before the GPIO subsystems starts to
> +deal with them.
> +
> +The above can be hidden: using pinctrl hogs, the pin control driver may be
> +setting up the config and muxing for the pins when it is probing,
> +nevertheless orthogonal to the GPIO subsystem.
> +
> +But there are also situations where it makes sense for the GPIO subsystem
> +to communicate directly with with the pinctrl subsystem, using the latter
> +as a back-end. This is when the GPIO driver may call out to the functions
> +described in the section "Pin control interaction with the GPIO subsystem"
> +above. This only involves per-pin multiplexing, and will be completely
> +hidden behind the gpio_*() function namespace. In this case, the driver
> +need not interact with the pin control subsystem at all.
> +
> +If a pin control driver and a GPIO driver is dealing with the same pins
> +and the use cases involve multiplexing, you MUST implement the pin controller
> +as a back-end for the GPIO driver like this.
> +
> +
>  System pin control hogging
>  ==========================

Yes, this definitively clarifies the doubts I had on the pinctrl/GPIO
subsystem interaction. Thank you.

Acked-By: Domenico Andreoli <domenico.andreoli@linux.com>
