Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab1BVFnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 00:43:21 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46793 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1BVFnU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 00:43:20 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298342392-21236-8-git-send-email-ccross@android.com>
References: <1298342392-21236-1-git-send-email-ccross@android.com>
	<1298342392-21236-8-git-send-email-ccross@android.com>
Date: Mon, 21 Feb 2011 21:43:19 -0800
Message-ID: <AANLkTikNSEyjdL0Lchmm-bFxD00omkGLq6Q6Yyjy51Ov@mail.gmail.com>
Subject: Re: [PATCH 7/7] ARM: tegra: clock: Disable clocks left on by bootloader
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, konkers@android.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mike@compulab.co.il, Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 21, 2011 at 6:39 PM, Colin Cross <ccross@android.com> wrote:
> Iterates through all clocks, disabling any for which the
> refcount is 0 but the clock init detected the bootloader
> left the clock on.  Can be disabled with command line
> tegra_clock.disable_boot_clocks=N
>
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  arch/arm/mach-tegra/clock.c |   44 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 44 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
> index e028320..6d686ff 100644
> --- a/arch/arm/mach-tegra/clock.c
> +++ b/arch/arm/mach-tegra/clock.c
> @@ -33,6 +33,9 @@
>  #include "board.h"
>  #include "clock.h"
>
> +#undef MODULE_PARAM_PREFIX
> +#define MODULE_PARAM_PREFIX "tegra_clock."
> +
>  /*
>  * Locking:
>  *
> @@ -416,6 +419,47 @@ void tegra_sdmmc_tap_delay(struct clk *c, int delay)
>        spin_unlock_irqrestore(&c->spinlock, flags);
>  }
>
> +static bool tegra_disable_boot_clocks = true;
> +module_param_named(disable_boot_clocks, tegra_disable_boot_clocks, bool,
> +       S_IRUGO | S_IWUSR | S_IWGRP);

I suggest doing this as an early_param instead. I know it's not truly
an early param, but it's the easier way to do non-module bootargs,
i.e. by not requiring a (fake) module prefix. It'd be a little
cleaner, in my opinion. The variable name itself is unique enough to
not need a module prefix for namespace reasons.

Also, Documentation/kernel-parameters.txt should be updated with it.


-Olof
