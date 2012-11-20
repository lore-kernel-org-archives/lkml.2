Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab2KTTp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 14:45:56 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40810 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab2KTTpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 14:45:55 -0500
Message-ID: <50ABDDEF.10403@wwwdotorg.org>
Date: Tue, 20 Nov 2012 12:45:51 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Josh Cartwright <josh.cartwright@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V3 1/2] clocksource: add common of_clksrc_init() function
References: <1353439206-1654-1-git-send-email-swarren@wwwdotorg.org> <20121120203105.3c54e49f@skate>
In-Reply-To: <20121120203105.3c54e49f@skate>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 12:31 PM, Thomas Petazzoni wrote:
> Stephen,
> 
> On Tue, 20 Nov 2012 12:20:05 -0700, Stephen Warren wrote:
> 
>> It is desirable to move all clocksource drivers to drivers/clocksource,
>> yet each requires its own initialization function. We'd rather not
>> pollute <linux/> with a header for each function. Instead, create a
>> single of_clksrc_init() function which will determine which clocksource
>> driver to initialize based on device tree.
...
> The way I did things for irqchip is a bit different: I used the
> standard of_irq_init(), which requires a table that is terminated by a
> sentinel. In order to guarantee that I have a sentinel, I did:
> 
> #define IRQCHIP_DECLARE(compstr,fn)                             \
>         static const struct of_device_id irqchip_of_match       \
>         __used __section(.init.irqchip)                         \
>         = { .compatible = compstr, .data = fn }
> 
> which is used to declare all irq drivers. But then in the main
> irqchip.c file, I did:
> 
> static const struct of_device_id
> irqchip_of_match_end __used __section(.init.irqchip.end);
> 
> and my linker script looks like:
> 
>         .init.irqchip : {
>                 __irqchip_begin = .;
>                 *(.init.irqchip)
>                 *(.init.irqchip.end)
>         }
> 
> So I gather all the of_device_id definitions and then the special
> sentinel of_device_id. I don't know if it is better than your solution,
> or even if my solution is good at all.

That does have the advantage of constructing a single table for all
irqchips, rather than the approach in my patch was to construct an array
of pointers to those tables. Your approach is one less loop at runtime,
and one less sentinel and pointer data item per irqchip. Perhaps I
should convert mine to do the same thing, unless anyone gives feedback
against it.
