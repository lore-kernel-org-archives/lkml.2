Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab0KKKQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 05:16:49 -0500
Received: from www.tglx.de ([62.245.132.106]:50920 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424Ab0KKKQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 05:16:47 -0500
Date: Thu, 11 Nov 2010 11:16:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Walleij <linus.walleij@stericsson.com>
cc: linux-kernel@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        linux-arm-kernel@lists.infradead.org, Colin Cross <ccross@google.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] RFC: nomadik: expand timesource to 63 bits
In-Reply-To: <1289466356-16697-1-git-send-email-linus.walleij@stericsson.com>
Message-ID: <alpine.LFD.2.00.1011111054010.2900@localhost6.localdomain6>
References: <1289466356-16697-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010, Linus Walleij wrote:

> After wraparound-problems in sched_clock() we expand the 32bit
> timer in the MTU from 32 to 63 bits so the scheduling and
> timeline is more stable. At current max operating frequency for
> the MTU, 133 MHz, this should be sufficient for rougly 2200
> years.
> 
> Cc: Colin Cross <ccross@google.com>
> Cc: Rabin Vincent <rabin.vincent@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
> tglx, nico: can you help out on reviewing this?
> 
> The solution in this patch is based on the similar approach
> taken by the Tegra platform in arch/arm/mach-tegra/timer.c.
> 
> Orion on the other hand will only expand the timer to 63
> bits in the sched_clock() function in arch/arm/plat-orion/time.c
> 
> What we need to know is whether it's OK to simply blow up
> clocksource to 63 bits like this. In that case this
> simplification should also apply to Orion, meaning that it
> would base it's sched_clock() on the clocksource, using
> simply clocksource_cyc2ns() cutting down the code
> significantly.
> 
> My main obstacle is that I cannot really determine whether
> clocksource.read() will be called often enough for the
> cnt32_to_63 algorithm.

We talk about 16 seconds here. If we wouldn't read out the 32bit
clocksource at least once in that time we'd run into wrap issues as
well.

There is only one caveat. When nohz is on and you sleep longer than 16
seconds then the limitation we have in place does not work anymore, as
it would say that the long sleep time is less than the 63bit
wraparound time. With 32bit clocksource it limits the sleep correclty
to avoid the clocksource wrap issue.

Aside of that you are trading a bit less source code with extra code
in the clock read() function, which is called pretty frequently.

Thanks,

	tglx
