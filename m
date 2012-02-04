Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab2BDMa3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 07:30:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44843 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab2BDMa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 07:30:28 -0500
Date: Sat, 4 Feb 2012 12:30:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 0/3] clocksource: add db8500 PRCMU timer
Message-ID: <20120204123009.GA10787@n2100.arm.linux.org.uk>
References: <1307007271-1004-1-git-send-email-mattias.wallin@stericsson.com> <20110602094622.GS3660@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602094622.GS3660@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 10:46:22AM +0100, Russell King - ARM Linux wrote:
> On Thu, Jun 02, 2011 at 11:34:31AM +0200, Mattias Wallin wrote:
> > The Multi Timer Unit (MTU) is currently used as clocksource and sched_clk
> > for the u8500 machine. The MTU block loose power during cpuidle sleep states
> > so an alternate clocksource is needed and these patches adds the db8500 PRCMU
> > timer.
> 
> Why don't we just find a way of fixing sched_clock so that the value
> doesn't reset over a suspend/resume cycle?  IOW, lets fix the problem
> for _everyone_ rather than only fixing it for one platform at a time.
> 
> Could you try this patch to check whether sched_clock() behaves better
> across a suspend/resume cycle please?

I never got any hint that this patch had been tried.  However, I believe
that syncing the sched_clock() at the point of suspend is definitely the
right thing to do, because it ensures that we have fully updated our
idea of time passed at the point where the system loses power.

So, I'm going to add this patch to my tree today.

> 
>  arch/arm/kernel/sched_clock.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
> index 9a46370..4be4019 100644
> --- a/arch/arm/kernel/sched_clock.c
> +++ b/arch/arm/kernel/sched_clock.c
> @@ -10,6 +10,7 @@
>  #include <linux/jiffies.h>
>  #include <linux/kernel.h>
>  #include <linux/sched.h>
> +#include <linux/syscore_ops.h>
>  #include <linux/timer.h>
>  
>  #include <asm/sched_clock.h>
> @@ -72,3 +73,20 @@ void __init sched_clock_postinit(void)
>  {
>  	sched_clock_poll(sched_clock_timer.data);
>  }
> +
> +static int sched_clock_suspend(void)
> +{
> +	sched_clock_poll(sched_clock_timer.data);
> +	return 0;
> +}
> +
> +static struct syscore_ops sched_clock_ops = {
> +	.suspend	= sched_clock_suspend,
> +};
> +
> +static int __init sched_clock_syscore_init(void)
> +{
> +	register_syscore_ops(&sched_clock_ops);
> +	return 0;
> +}
> +device_initcall(sched_clock_syscore_init);
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
