Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab2HPMkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 08:40:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46846 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab2HPMkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 08:40:07 -0400
MIME-Version: 1.0
In-Reply-To: <1344966752-16102-29-git-send-email-catalin.marinas@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
	<1344966752-16102-29-git-send-email-catalin.marinas@arm.com>
Date: Thu, 16 Aug 2012 14:40:06 +0200
Message-ID: <CACRpkdYJngvG92BJ_jMyx5KZcr2WmMwGtat6=wKsq+RLk3ECgA@mail.gmail.com>
Subject: Re: [PATCH v2 28/31] arm64: Generic timers support
From: Linus Walleij <linus.walleij@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 7:52 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:

> From: Marc Zyngier <marc.zyngier@arm.com>
(...)
> +static void __init arch_timer_calibrate(void)

I think you wrot in the last review thread that this should be renamed
"arch_timer_get_freq()".

> +{
> +       if (arch_timer_rate == 0) {
> +               arch_timer_reg_write(ARCH_TIMER_REG_CTRL, 0);
> +               arch_timer_rate = arch_timer_reg_read(ARCH_TIMER_REG_FREQ);
> +
> +               /* Check the timer frequency. */
> +               if (arch_timer_rate == 0)
> +                       panic("Architected timer frequency is set to zero.\n"
> +                             "You must set this in your .dts file\n");

This comment about the .dts file is completely out-of-place.
The error message should be about the register containing 0, right?

Also, at this very point in the code, I think you should convert that panic()
to pr_err() and insert:

#include <linux/clk.h>

struct clk *clk;

clk = clk_get_sys("arm_generic_timer", NULL);
if (IS_ERR(clk))
               panic("Not even a clk to get freq off! Giving up.\n");
err = clk_prepare_enable(clk);
if (err) {
           pr_err("smp_twd: clock failed to prepare: %d\n", err);
           clk_put(clk);
           panic("Not even a clk to get freq off! Giving up.\n");
}
arch_timer_rate = clk_get_rate(clk);

Possibly the clk should even be able to override the register value,
then it's the other way around.

> +       }
> +
> +       /* Cache the sched_clock multiplier to save a divide in the hot path. */
> +
> +       sched_clock_mult = NSEC_PER_SEC / arch_timer_rate;
> +
> +       pr_info("Architected local timer running at %u.%02uMHz.\n",
> +                arch_timer_rate / 1000000, (arch_timer_rate / 10000) % 100);

This multiplier and print should be moved below the call site since
the DT frequency
overrides it and then you get no print which is sad, and incorrect
sched_clock_mult
which is a bug.

> +}

(...)
> +       /* Try to determine the frequency from the device tree or CNTFRQ */
> +       if (!of_property_read_u32(np, "clock-frequency", &freq))
> +               arch_timer_rate = freq;
> +       arch_timer_calibrate();

rename arch_timer_get_freq()

And move that print here.

Yours,
Linus Walleij
