Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab2LLVyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:54:19 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64448 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab2LLVyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:54:14 -0500
Date: Wed, 12 Dec 2012 13:54:04 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2] drivers/pinctrl: grab default handles from device core
Message-ID: <20121212215404.GA18555@kroah.com>
References: <1355343907-11535-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355343907-11535-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 09:25:07PM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This makes the device core auto-grab the pinctrl handle and set
> the "default" (PINCTRL_STATE_DEFAULT) state for every device
> that is present in the device model right before probe. This will
> account for the lion's share of embedded silicon devcies.
> 
> A modification of the semantics for pinctrl_get() is also done:
> previously if the pinctrl handle for a certain device was already
> taken, the pinctrl core would return an error. Now, since the
> core may have already default-grabbed the handle and set its
> state to "default", if the handle was already taken, this will
> be disregarded and the located, previously instanitated handle
> will be returned to the caller.
> 
> This way all code in drivers explicitly requesting their pinctrl
> handlers will still be functional, and drivers that want to
> explicitly retrieve and switch their handles can still do that.
> But if the desired functionality is just boilerplate of this
> type in the probe() function:
> 
> struct pinctrl  *p;
> 
> p = devm_pinctrl_get_select_default(&dev);
> if (IS_ERR(p)) {
>    if (PTR_ERR(p) == -EPROBE_DEFER)
>         return -EPROBE_DEFER;
>         dev_warn(&dev, "no pinctrl handle\n");
> }
> 
> The discussion began with the addition of such boilerplate
> to the omap4 keypad driver:
> http://marc.info/?l=linux-input&m=135091157719300&w=2
> 
> A previous approach using notifiers was discussed:
> http://marc.info/?l=linux-kernel&m=135263661110528&w=2
> This failed because it could not handle deferred probes.
> 
> This patch alone does not solve the entire dilemma faced:
> whether code should be distributed into the drivers or
> if it should be centralized to e.g. a PM domain. But it
> solves the immediate issue of the addition of boilerplate
> to a lot of drivers that just want to grab the default
> state. As mentioned, they can later explicitly retrieve
> the handle and set different states, and this could as
> well be done by e.g. PM domains as it is only related
> to a certain struct device * pointer.
> 
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Mitch Bradley <wmb@firmworks.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: Rickard Andersson <rickard.andersson@stericsson.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - Only store a pointer in the device struct, and only allocate
>   this if it's really used by the device.
> - Seeking ACK on this from Greg (and others who like it) so I
>   can merge it through the pinctrl subsystem.

It looks ok, but this can't go in for 3.8, sorry, please wait for 3.9.

greg k-h
