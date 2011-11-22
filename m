Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab1KVNyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 08:54:09 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:37410 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab1KVNyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 08:54:08 -0500
Date: Tue, 22 Nov 2011 08:46:12 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: len.brown@intel.com, jeremy@goop.org, xen-devel@lists.xensource.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, trenn@suse.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tj@kernel.org,
        tglx@linutronix.de, stable@kernel.org
Subject: Re: [Xen-devel] Re: [PATCH 1/3] cpuidle: If disable_cpuidle() is
 called, set pm_idle to default_idle.
Message-ID: <20111122134612.GA29668@phenom.dumpdata.com>
References: <1320786914-10541-1-git-send-email-konrad.wilk@oracle.com>
 <1320786914-10541-2-git-send-email-konrad.wilk@oracle.com>
 <4EBA53C5.9040603@linux.vnet.ibm.com>
 <20111109144440.GB8410@phenom.dumpdata.com>
 <4EBD09FF.4030002@linux.vnet.ibm.com>
 <20111115144004.GE22675@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115144004.GE22675@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4ECBA953.0141,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 09:40:04AM -0500, Konrad Rzeszutek Wilk wrote:
> > Well I was with a view that if cpuidle is disabled, mwait and arm_e400
> > would take precedence over default_idle. But if is ok to have default_idle instead,
> > then go ahead. 
> > 
> > > Perhaps there is another way do this is:
> > > 
> > > diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> > > index becd6d9..04b10a4 100644
> > > --- a/drivers/cpuidle/cpuidle.c
> > > +++ b/drivers/cpuidle/cpuidle.c
> > > @@ -38,6 +38,7 @@ int cpuidle_disabled(void)
> > >  void disable_cpuidle(void)
> > >  {
> > >  	off = 1;
> > > +	pm_idle = default_idle;
> > >  }
> > > 
> > Brining pm_idle pointer back to cpuidle code is going a step back coz
> > we wanted to complete remove using pm_idle going forward. As having 
> > a pointer exported into various files is not a good thing. That's the 
> > reason we started the clean up in the first place :) 
> 
> Perhaps then something along these lines, where we still set default_idle
> but don't fiddle with the pm_idle (and can still rip out the
> EXPORT_SYMBOL_GPL(default_idle) in 2012):
> 
> (Hadn't tested this yet).

Now have tested it.

> 
> diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
> index c2ff2a1..2d2f01c 100644
> --- a/arch/x86/include/asm/system.h
> +++ b/arch/x86/include/asm/system.h
> @@ -401,6 +401,7 @@ extern unsigned long arch_align_stack(unsigned long sp);
>  extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
>  
>  void default_idle(void);
> +bool set_pm_idle_to_default(void);
>  
>  void stop_this_cpu(void *dummy);
>  
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index e7e3b01..bfb113f 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -403,6 +403,14 @@ void default_idle(void)
>  EXPORT_SYMBOL(default_idle);
>  #endif
>  
> +bool set_pm_idle_to_default()
> +{
> +	if (!pm_idle) {
> +		pm_idle = default_idle;
> +		return true;
> +	}
> +	return false;
> +}
>  void stop_this_cpu(void *dummy)
>  {
>  	local_irq_disable();
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 46d6d21..7506181 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -448,6 +448,6 @@ void __init xen_arch_setup(void)
>  #endif
>  	disable_cpuidle();
>  	boot_option_idle_override = IDLE_HALT;
> -
> +	WARN_ON(!set_pm_idle_to_default());
>  	fiddle_vdso();
>  }
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
