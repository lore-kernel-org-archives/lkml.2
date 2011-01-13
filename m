Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab1AMWq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:46:28 -0500
Received: from kroah.org ([198.145.64.141]:45748 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266Ab1AMWqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:46:15 -0500
Date: Thu, 13 Jan 2011 14:44:50 -0800
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] x86: Add safe_udelay() and safe_msleep()
Message-ID: <20110113224450.GA14918@kroah.com>
References: <20110111010714.GB32585@kroah.com>
 <4D2BB048.2050509@kernel.org>
 <1294723290.17779.349.camel@pasglop>
 <4D2BF9F3.5080709@kernel.org>
 <1294731467.17779.352.camel@pasglop>
 <AANLkTika_bZxXO3PKek+BHoYqgYGPBPER-H9KJJXjJzn@mail.gmail.com>
 <20110111135655.GA6901@kroah.com>
 <4D2CFEAD.6070206@kernel.org>
 <1294799565.9586.13.camel@pasglop>
 <4D2F7AE9.2000809@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2F7AE9.2000809@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 02:21:29PM -0800, Yinghai Lu wrote:
> On 01/11/2011 06:32 PM, Benjamin Herrenschmidt wrote:
> > On Tue, 2011-01-11 at 17:06 -0800, Yinghai Lu wrote:
> >> We need to use those function in early-quirk stage with code that is shared with
> >> later stage.
> >>
> >> for x86, normal udelay() will need to wait per_cpu(cpu_info) is allocated... that i
> >> after smp_prepare_cpus(), because it need to use percpu.loops_per_jiffy.
> >>
> >> Also msleep() will need to wait schedular is ready.
> >>
> >> Try to have one early version udelay that use loops_per_jiffy directly.
> >> and early msleep is just early delay.
> >>
> >> This patch will set safe_udelay to early in x86 early arch code, and then init/main.c
> >> will set them back.
> > 
> > I still think it's better to just make msleep() work with and without
> > scheduler and avoid having to bother with a new API
> 
> please check if you are happy with this one.
> 
> [PATCH] x86: Make udelay() and msleep() can be used early
> 
> We need to use those functions in early-quirk stage with code that is shared with
> later stage.
> 
> For x86, normal udelay need to use percpu.loops_per_jiffy
> will need to wait per_cpu(cpu_info) is allocated and copied
> from boot_cpu_data, after it is in smp_prepare_cpus()
> boot_cpu_data.loops_per_jiffy get set in identify_boot_cpu from check_bugs.
> 
> Also msleep() will need to wait schedular is ready.
> 
> Try to have one early version udelay that use loops_per_jiffy directly.
> and early msleep is just early delay.
> 
> -v2: use function pointer and keep old udelay() and msleep() API as requested from BenH
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/lib/delay.c  |   28 +++++++++++++++++++++++++++-
>  include/linux/delay.h |    2 ++
>  init/main.c           |    3 +++
>  kernel/timer.c        |   28 +++++++++++++++++++++++-----
>  4 files changed, 55 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6/arch/x86/lib/delay.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/lib/delay.c
> +++ linux-2.6/arch/x86/lib/delay.c
> @@ -113,7 +113,7 @@ void __delay(unsigned long loops)
>  }
>  EXPORT_SYMBOL(__delay);
>  
> -inline void __const_udelay(unsigned long xloops)
> +static void __normal_const_udelay(unsigned long xloops)
>  {
>  	int d0;
>  
> @@ -125,8 +125,34 @@ inline void __const_udelay(unsigned long
>  
>  	__delay(++xloops);
>  }
> +
> +/* before percpu cpu_info.loops_per_jiffy is set */
> +static void __init __early_const_udelay(unsigned long xloops)
> +{
> +	int d0;
> +
> +	xloops *= 4;
> +	asm("mull %%edx"
> +		: "=d" (xloops), "=&a" (d0)
> +		: "1" (xloops), "0"
> +		(loops_per_jiffy * (HZ/4)));
> +
> +	delay_loop(++xloops);
> +}
> +
> +static void (*__const_udelay_fn)(unsigned long) = __early_const_udelay;
> +
> +void __const_udelay(unsigned long usecs)
> +{
> +	__const_udelay_fn(usecs);
> +}
>  EXPORT_SYMBOL(__const_udelay);
>  
> +void __init use_normal_delay(void)
> +{
> +	__const_udelay_fn = __normal_const_udelay;
> +}
> +
>  void __udelay(unsigned long usecs)
>  {
>  	__const_udelay(usecs * 0x000010c7); /* 2**32 / 1000000 (rounded up) */
> Index: linux-2.6/include/linux/delay.h
> ===================================================================
> --- linux-2.6.orig/include/linux/delay.h
> +++ linux-2.6/include/linux/delay.h
> @@ -52,4 +52,6 @@ static inline void ssleep(unsigned int s
>  	msleep(seconds * 1000);
>  }
>  
> +extern void use_normal_delay(void);
> +extern void use_normal_sleep(void);
>  #endif /* defined(_LINUX_DELAY_H) */
> Index: linux-2.6/init/main.c
> ===================================================================
> --- linux-2.6.orig/init/main.c
> +++ linux-2.6/init/main.c
> @@ -879,6 +879,9 @@ static int __init kernel_init(void * unu
>  	cad_pid = task_pid(current);
>  
>  	smp_prepare_cpus(setup_max_cpus);
> +	/* set them back, x86 use it for early delay*/
> +	use_normal_delay();
> +	use_normal_sleep();

Ick, I really don't like this.

And, most importantly, I'm still not sure it's needed at all, as I don't
agree with your previous patches that you say this one is needed for.

So, how about we work on the original root problem here before worrying
about changing the main usleep logic for the whole kernel?

thanks,

greg k-h
