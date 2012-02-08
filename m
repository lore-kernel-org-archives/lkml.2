Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab2BHNTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 08:19:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37884 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab2BHNTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 08:19:02 -0500
Date: Wed, 8 Feb 2012 13:18:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
        Venki Pallipadi <venki@google.com>, linaro-dev@lists.linaro.org,
        patches@linaro.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] sched: generalize CONFIG_IRQ_TIME_ACCOUNTING for X86
	and ARM
Message-ID: <20120208131833.GK889@n2100.arm.linux.org.uk>
References: <1328705314-20978-1-git-send-email-dmitry.antipov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328705314-20978-1-git-send-email-dmitry.antipov@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 04:48:34AM -0800, Dmitry Antipov wrote:
> Generalize CONFIG_IRQ_TIME_ACCOUNTING  between X86 and
> ARM, move "noirqtime=" option to common debugging code.
> For a bit of backward compatibility, "tsc=noirqtime"
> is preserved, but issues a warning.
> 
> Suggested-by: Venki Pallipadi <venki@google.com>
> Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
> ---
>  arch/arm/kernel/sched_clock.c |    3 +++
>  arch/x86/Kconfig              |   11 -----------
>  arch/x86/kernel/tsc.c         |    7 ++++---
>  include/linux/sched.h         |    2 ++
>  lib/Kconfig.debug             |   12 ++++++++++++
>  lib/Makefile                  |    2 ++
>  lib/irqtime.c                 |   12 ++++++++++++
>  7 files changed, 35 insertions(+), 14 deletions(-)
>  create mode 100644 lib/irqtime.c
> 
> diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
> index 5416c7c..56d2a9d 100644
> --- a/arch/arm/kernel/sched_clock.c
> +++ b/arch/arm/kernel/sched_clock.c
> @@ -162,5 +162,8 @@ void __init sched_clock_postinit(void)
>  	if (read_sched_clock == jiffy_sched_clock_read)
>  		setup_sched_clock(jiffy_sched_clock_read, 32, HZ);
>  
> +	if (!no_sched_irq_time)
> +		enable_sched_clock_irqtime();

Why are you placing this here?  sched_clock is available from the point
that it's registered, which should be before the first sched_clock()
call.

> +config IRQ_TIME_ACCOUNTING
> +	bool "Fine granularity task level IRQ time accounting"
> +	depends on (X86 || (ARM && HAVE_SCHED_CLOCK))

Even though it's not bad here, please get out of the habbit of throwing
unnecessary parens into the mix.  It can make stuff more difficult to
read and therefore confirm correctness.  (I've spent many a time
rewriting if() statements because of paren overuse.)

This could have been written:

	depends on X86 || (ARM && HAVE_SCHED_CLOCK)

However, ARM will always have HAVE_SCHED_CLOCK after the next merge window,
so this can become a much simpler:

	depends on X86 || ARM

Apart from these two points, the rest of the patch looks fine to me but
the ultimate decision about its acceptability is up to other people.
