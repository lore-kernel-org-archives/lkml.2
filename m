Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936297Ab1KJEHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:07:38 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:53468 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935071Ab1KJEHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 23:07:33 -0500
Date: Wed, 9 Nov 2011 23:06:44 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, len.brown@intel.com,
        tglx@linutronix.de, jeremy@goop.org, hpa@zytor.com, bp@alien8.de,
        tj@kernel.org, trenn@suse.de
Cc: stable@kernel.org, mingo@redhat.com, xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [PATCH 1/3] cpuidle: If disable_cpuidle() is called,
 set pm_idle to default_idle.
Message-ID: <20111110040644.GA5434@phenom.dumpdata.com>
References: <1320786914-10541-1-git-send-email-konrad.wilk@oracle.com>
 <1320786914-10541-2-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320786914-10541-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4EBB4DE6.000A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 04:15:12PM -0500, Konrad Rzeszutek Wilk wrote:
> . however we ignore the disable_cpuidle() directive and
> in select_idle_routine() set it to type preferred by the CPU.
> 
> This is a regression introduced by
> 
>  commit a0bfa1373859e9d11dc92561a8667588803e42d8
>  Author: Len Brown <len.brown@intel.com>
>  Date:   Fri Apr 1 19:34:59 2011 -0400
> 
>      cpuidle: stop depending on pm_idle
> 
> specifically this patch:
> 
>  commit d91ee5863b71e8c90eaf6035bff3078a85e2e7b5
>  Author: Len Brown <len.brown@intel.com>
>  Date:   Fri Apr 1 18:28:35 2011 -0400
> 
>      cpuidle: replace xen access to x86 pm_idle and default_idle
> 
>      ..scribble on pm_idle and access default_idle,
>     have it simply disable_cpuidle() so acpi_idle will not load and
>     architecture default HLT will be used.
> 
> .. but the default HLT does not get used. Instead we end up in the
> situation that select_idle_routine() is called from arch/x86/kernel/cpu/common.c
> and if we called cpuidle_disable(), then the pm_idle is not set, and
> we end up setting pm_idle to mwait_idle or amd_e400_idle.
> 
> This patch uses the cpuidle_disabled() functionality and
> makes select_idle_routine() adhere to that.
> 
> Reported-by: Stefan Bader <stefan.bader@canonical.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

And just found that there is a BZ for this as well:
https://bugzilla.redhat.com/show_bug.cgi?id=739499

And this patch fixes the Linux kernel to boot under Amazon EC2.

Another option which I played with today was to do this instead:

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 46d6d21..45136f2 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -448,6 +448,6 @@ void __init xen_arch_setup(void)
 #endif
        disable_cpuidle();
        boot_option_idle_override = IDLE_HALT;
-
+       pm_idle = default_idle;
        fiddle_vdso();
 }


But that defeats the whole purpose of the patch series that Len developed
where we would _not_ scribble on the pm_idle. <sigh>

Thoughts?
> 
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: x86@kernel.org
> CC: Len Brown <len.brown@intel.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: Tejun Heo <tj@kernel.org>
> CC: Thomas Renninger <trenn@suse.de>
> CC: stable@kernel.org
> ---
>  arch/x86/kernel/process.c |    5 +++++
>  include/linux/cpuidle.h   |    2 ++
>  2 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index e7e3b01..1f7f8c8 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -14,6 +14,7 @@
>  #include <linux/utsname.h>
>  #include <trace/events/power.h>
>  #include <linux/hw_breakpoint.h>
> +#include <linux/cpuidle.h>
>  #include <asm/cpu.h>
>  #include <asm/system.h>
>  #include <asm/apic.h>
> @@ -587,6 +588,10 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
>  	if (pm_idle)
>  		return;
>  
> +	if (cpuidle_disabled()) {
> +		pm_idle = default_idle;
> +		return;
> +	}
>  	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
>  		/*
>  		 * One CPU supports mwait => All CPUs supports mwait
> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> index b51629e..123fe9e 100644
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -122,6 +122,7 @@ struct cpuidle_driver {
>  };
>  
>  #ifdef CONFIG_CPU_IDLE
> +extern int cpuidle_disabled(void);
>  extern void disable_cpuidle(void);
>  extern int cpuidle_idle_call(void);
>  
> @@ -137,6 +138,7 @@ extern int cpuidle_enable_device(struct cpuidle_device *dev);
>  extern void cpuidle_disable_device(struct cpuidle_device *dev);
>  
>  #else
> +static inline int cpuidle_disabled(void) { return 1; }
>  static inline void disable_cpuidle(void) { }
>  static inline int cpuidle_idle_call(void) { return -ENODEV; }
>  
> -- 
> 1.7.7.1
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
