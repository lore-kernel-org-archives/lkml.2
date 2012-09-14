Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499Ab2INRRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:17:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56148 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970Ab2INRRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:17:03 -0400
Message-ID: <5053668B.6020604@wwwdotorg.org>
Date: Fri, 14 Sep 2012 11:16:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2] pinctrl: document semantics vs GPIO
References: <1347630587-31014-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1347630587-31014-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 07:49 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> The semantics of the interactions between GPIO and pinctrl may be
> unclear, e.g. which one do you request first? This amends the
> documentation to make this clear.

> +If a pin control driver and a GPIO driver is dealing with the same pins
> +and the use cases involve multiplexing, you MUST implement the pin controller
> +as a back-end for the GPIO driver like this.

I might add one caveat to that:

==========
, unless your HW design is such that the GPIO controller can override
the pin controller's mux state, without the need for any such interaction.
==========

... as on Tegra for example, the GPIO controller contains a bit per GPIO
pin which forces the GPIO controller to control the pin, irrespective of
any mux setting in the pinmux controller (although the pin controller's
tri-state config overrides the GPIO controller's output-enable
config!!!). Hence, the exact same semantics can be achieved, without the
GPIO driver actually having to call into the pinctrl subsystem. That
said, Tegra's GPIO driver still does end up calling into
pinctrl_request_gpio()/pinctrl_free_gpio() so that pinctrl debugfs works
for example, just not the pinctrl_gpio_direction_*(), so I guess it's
partially following the MUST above, so perhaps there's no need for the
caveat?

Either way,
Acked-by: Stephen Warren <swarren@wwwdotorg.org>

In the future, I wonder if someone might want the following caveat,

==========
, unless you require that all boards (or device trees) define a system
hog pinmux configuration that muxes all required GPIO signals as desired.
==========

... which might be appropriate for HW where GPIO-vs-special-function
selection is performed in the pinmux controller itself, per-pin. Perhaps
this is the OMAP special case you mentioned before?
