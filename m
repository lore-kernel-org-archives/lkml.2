Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab2KTTbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 14:31:19 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:57207 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2KTTbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 14:31:17 -0500
Date: Tue, 20 Nov 2012 20:31:05 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Josh Cartwright <josh.cartwright@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V3 1/2] clocksource: add common of_clksrc_init()
 function
Message-ID: <20121120203105.3c54e49f@skate>
In-Reply-To: <1353439206-1654-1-git-send-email-swarren@wwwdotorg.org>
References: <1353439206-1654-1-git-send-email-swarren@wwwdotorg.org>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Tue, 20 Nov 2012 12:20:05 -0700, Stephen Warren wrote:

> It is desirable to move all clocksource drivers to drivers/clocksource,
> yet each requires its own initialization function. We'd rather not
> pollute <linux/> with a header for each function. Instead, create a
> single of_clksrc_init() function which will determine which clocksource
> driver to initialize based on device tree.

Sounds great!

I'm still planning to send irqchip soon, but I've been busy preparing
things for the merge window in the mvebu architecture, which has been
quite active during this cycle.

> +#include <linux/init.h>
> +#include <linux/of.h>
> +
> +extern struct of_device_id *__start_clksrc_of_match_tables[];
> +extern struct of_device_id *__stop_clksrc_of_match_tables[];
> +
> +void __init clocksource_of_init(void)
> +{
> +	struct of_device_id **table;
> +	struct of_device_id **stop;
> +	struct device_node *np;
> +	const struct of_device_id *match;
> +	void (*init_func)(void);
> +
> +	table = __start_clksrc_of_match_tables;
> +	stop = __stop_clksrc_of_match_tables;
> +
> +	for ( ; table < stop; table++) {
> +		for_each_matching_node(np, *table) {
> +			match = of_match_node(*table, np);
> +			init_func = match->data;
> +			init_func();
> +		}
> +	}
> +}

The way I did things for irqchip is a bit different: I used the
standard of_irq_init(), which requires a table that is terminated by a
sentinel. In order to guarantee that I have a sentinel, I did:

#define IRQCHIP_DECLARE(compstr,fn)                             \
        static const struct of_device_id irqchip_of_match       \
        __used __section(.init.irqchip)                         \
        = { .compatible = compstr, .data = fn }

which is used to declare all irq drivers. But then in the main
irqchip.c file, I did:

static const struct of_device_id
irqchip_of_match_end __used __section(.init.irqchip.end);

and my linker script looks like:

        .init.irqchip : {
                __irqchip_begin = .;
                *(.init.irqchip)
                *(.init.irqchip.end)
        }

So I gather all the of_device_id definitions and then the special
sentinel of_device_id. I don't know if it is better than your solution,
or even if my solution is good at all.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
