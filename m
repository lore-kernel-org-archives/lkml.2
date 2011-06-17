Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab1FQEcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 00:32:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:46431 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab1FQEcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 00:32:20 -0400
Subject: Re: [RFC PATCH V1 4/7] cpuidle: (powerpc) Add cpu_idle_wait() to
 allow switching idle routines
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: linux-pm@lists.linux-foundation.org, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110607162959.6848.26918.stgit@tringupt.in.ibm.com>
References: <20110607162847.6848.44707.stgit@tringupt.in.ibm.com>
	 <20110607162959.6848.26918.stgit@tringupt.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jun 2011 14:32:08 +1000
Message-ID: <1308285128.32158.8.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 22:00 +0530, Trinabh Gupta wrote:

> diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
> index 39a2baa..932392b 100644
> --- a/arch/powerpc/kernel/idle.c
> +++ b/arch/powerpc/kernel/idle.c
> @@ -102,6 +102,24 @@ void cpu_idle(void)
>  	}
>  }
>  
> +static void do_nothing(void *unused)
> +{
> +}
> +
> +/*
> + * cpu_idle_wait - Used to ensure that all the CPUs come out of the old
> + * idle loop and start using the new idle loop.
> + * Required while changing idle handler on SMP systems.
> + * Caller must have changed idle handler to the new value before the call.
> + */
> +void cpu_idle_wait(void)
> +{
> +	smp_mb();
> +	/* kick all the CPUs so that they exit out of old idle routine */
> +	smp_call_function(do_nothing, NULL, 1);
> +}
> +EXPORT_SYMBOL_GPL(cpu_idle_wait);
> +
>  int powersave_nap;
>  
>  #ifdef CONFIG_SYSCTL

This is gross :-)

Do you need to absolutely ensure the idle task has changed or just
kicking it with a send reschedule is enough ?

Cheers,
Ben.


