Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab1EEI0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 04:26:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:40767 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1EEI0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 04:26:08 -0400
Date: Thu, 5 May 2011 10:25:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Christian Hoffmann <email@christianhoffmann.info>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
In-Reply-To: <1304558210.2943.24.camel@work-vm>
Message-ID: <alpine.LFD.2.02.1105051025290.3005@ionos>
References: <4DBEFCBA.3070501@christianhoffmann.info>  <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>  <1304372955.3226.15.camel@work-vm>  <4DBF2FB4.8000304@christianhoffmann.info>  <1304470839.3037.12.camel@work-vm> 
 <4DC100D0.1030302@christianhoffmann.info> <1304558210.2943.24.camel@work-vm>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, john stultz wrote:

> On Wed, 2011-05-04 at 09:31 +0200, Christian Hoffmann wrote:
> > In fact, switching to acpi_pm doesn't seem to work:
> > 
> > $ dmesg | grep clock
> > 
> > [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.39-rc5-ch-broken+ 
> > root=/dev/mapper/vg-root ro quiet splash vt.handoff=7 clocksource=acpi_pm
> > [    0.000000] Kernel command line: 
> > BOOT_IMAGE=/vmlinuz-2.6.39-rc5-ch-broken+ root=/dev/mapper/vg-root ro 
> > quiet splash vt.handoff=7 clocksource=acpi_pm
> > [    0.000000] hpet clockevent registered
> > [    1.413835] Switching to clocksource hpet
> > [    1.420762] Override clocksource acpi_pm is not HRT compatible. 
> > Cannot switch while in HRT/NOHZ mode
> > [  147.940143] Refined TSC clocksource calibration: 2809.409 MHz.
> > [  147.940147] Switching to clocksource tsc
> 
> So I think I've sorted this out.
> 
> The watchdog code is what enables CLOCK_SOURCE_VALID_FOR_HRES, but we
> actually end up selecting the clocksource before we enqueue it into the
> watchdog list, so that's why we see the warning.
> 
> I suspect the following will resolve this detail.

It does. Good catch!

> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> 
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index 6519cf6..0e17c10 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -685,8 +685,8 @@ int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
>  	/* Add clocksource to the clcoksource list */
>  	mutex_lock(&clocksource_mutex);
>  	clocksource_enqueue(cs);
> -	clocksource_select();
>  	clocksource_enqueue_watchdog(cs);
> +	clocksource_select();
>  	mutex_unlock(&clocksource_mutex);
>  	return 0;
>  }
> @@ -706,8 +706,8 @@ int clocksource_register(struct clocksource *cs)
>  
>  	mutex_lock(&clocksource_mutex);
>  	clocksource_enqueue(cs);
> -	clocksource_select();
>  	clocksource_enqueue_watchdog(cs);
> +	clocksource_select();
>  	mutex_unlock(&clocksource_mutex);
>  	return 0;
>  }
> 
> 
> 
