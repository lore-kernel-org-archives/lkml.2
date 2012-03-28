Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab2C1WJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:09:28 -0400
Received: from smtp.tele.fi ([192.89.123.25]:39964 "EHLO
	vulpes-int.media.sonera.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758287Ab2C1WJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:09:27 -0400
X-Greylist: delayed 2975 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Mar 2012 18:09:27 EDT
X-Originating-Ip: [194.89.68.22]
Date: Thu, 29 Mar 2012 00:19:47 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>, mjg@redhat.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] Stop the continuous flood of (XEN) traps.c:2432:d0
	Domain attempted WRMSR ..
Message-ID: <20120328211947.GT12984@reaktio.net>
References: <20120203180952.GP12984@reaktio.net> <20120203185527.GA9290@phenom.dumpdata.com> <20120205194413.GR12984@reaktio.net> <20120209212147.GE14007@andromeda.dapyr.net> <20120209132715.2d1c0c9f@jbarnes-desktop> <20120328202907.GA1784@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328202907.GA1784@phenom.dumpdata.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 04:29:07PM -0400, Konrad Rzeszutek Wilk wrote:
> > > 
> > > Jesse, and Matthew,
> > > 
> > > Is there a way to make the intel_ips.c driver be in a "low-power" state?
> > > 
> > > My first thought about fixing this was that we could allow the
> > > hypervisor to allow those RDMSR but the Linux kernel has no power to
> > > actually influence the power management (as the hypervisor is in charge
> > > of that) - so would the driver be capable of just sitting back and
> > > not influencing the CPU?
> > 
> > Yeah it's easy enough to turn off or disable.  But it doesn't currently
> > export any knobs for controlling behavior.  I don't have any issue with
> > exposing some though...
> 
> Pasi,
> 
> Could you test the two patches independetly of each other? Meaning
> test the Linux one without the Xen one, and vice-versa.
> 

Sure, I'll give it a try during the weekend when I'm able to access the box in question.

Thanks! 

-- Pasi




> diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
> index 88a98cf..7276831 100644
> --- a/drivers/platform/x86/intel_ips.c
> +++ b/drivers/platform/x86/intel_ips.c
> @@ -1407,6 +1407,10 @@ static struct ips_mcp_limits *ips_detect_cpu(struct ips_driver *ips)
>  	}
>  
>  	rdmsrl(TURBO_POWER_CURRENT_LIMIT, turbo_power);
> +	if (turbo_power == 0) {
> +		ips->turbo_toggle_allowed = false;
> +		return NULL;
> +	}
>  	tdp = turbo_power & TURBO_TDP_MASK;
>  
>  	/* Sanity check TDP against CPU */

> diff -r 8e2690dbec49 xen/arch/x86/traps.c
> --- a/xen/arch/x86/traps.c	Sat Mar 24 13:13:49 2012 -0400
> +++ b/xen/arch/x86/traps.c	Wed Mar 28 16:27:31 2012 -0400
> @@ -1746,7 +1746,8 @@ void (*pv_post_outb_hook)(unsigned int p
>  static inline uint64_t guest_misc_enable(uint64_t val)
>  {
>      val &= ~(MSR_IA32_MISC_ENABLE_PERF_AVAIL |
> -             MSR_IA32_MISC_ENABLE_MONITOR_ENABLE);
> +             MSR_IA32_MISC_ENABLE_MONITOR_ENABLE |
> +             MSR_IA32_MISC_ENABLE_TURBO);
>      val |= MSR_IA32_MISC_ENABLE_BTS_UNAVAIL |
>             MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL |
>             MSR_IA32_MISC_ENABLE_XTPR_DISABLE;
> diff -r 8e2690dbec49 xen/include/asm-x86/msr-index.h
> --- a/xen/include/asm-x86/msr-index.h	Sat Mar 24 13:13:49 2012 -0400
> +++ b/xen/include/asm-x86/msr-index.h	Wed Mar 28 16:27:31 2012 -0400
> @@ -327,6 +327,7 @@
>  #define MSR_IA32_MISC_ENABLE_MONITOR_ENABLE (1<<18)
>  #define MSR_IA32_MISC_ENABLE_LIMIT_CPUID  (1<<22)
>  #define MSR_IA32_MISC_ENABLE_XTPR_DISABLE (1<<23)
> +#define MSR_IA32_MISC_ENABLE_TURBO        (1<<38)
>  
>  #define MSR_IA32_TSC_DEADLINE		0x000006E0
>  #define MSR_IA32_ENERGY_PERF_BIAS	0x000001b0

