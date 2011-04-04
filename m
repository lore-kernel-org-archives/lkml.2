Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab1DDPdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:33:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28684 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab1DDPdx (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 4 Apr 2011 11:33:53 -0400
Date: Mon, 4 Apr 2011 11:33:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 09/18] cpuidle: replace xen access to x86
 pm_idle and default_idle
Message-ID: <20110404153335.GA19168@dumpdata.com>
References: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
 <e2f656a28f548ed19c829563e5168ce48026570b.1301724243.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2f656a28f548ed19c829563e5168ce48026570b.1301724243.git.len.brown@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D99E4D3.00A8:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 02, 2011 at 02:22:51AM -0400, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> When a Xen Dom0 kernel boots on a hypervisor, it gets access
> to the raw-hardware ACPI tables.  While it parses the idle tables
> for the hypervisor's beneift, it uses HLT for its own idle.
> 
> Rather than have xen scribble on pm_idle and access default_idle,
> have it simply disable_cpuidle() so acpi_idle will not load and
> architecture default HLT will be used.
Hey Len,

Looks good to me. I've also tested this on the affected Intel machine and
your patchset works fine.

> 
> cc: xen-devel@lists.xensource.com
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  arch/x86/xen/setup.c      |    3 ++-
>  drivers/cpuidle/cpuidle.c |    4 ++++
>  include/linux/cpuidle.h   |    2 ++
>  3 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index a8a66a5..aa02cce 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -9,6 +9,7 @@
>  #include <linux/mm.h>
>  #include <linux/pm.h>
>  #include <linux/memblock.h>
> +#include <linux/cpuidle.h>
>  
>  #include <asm/elf.h>
>  #include <asm/vdso.h>
> @@ -354,7 +355,7 @@ void __init xen_arch_setup(void)
>  #ifdef CONFIG_X86_32
>  	boot_cpu_data.hlt_works_ok = 1;
>  #endif
> -	pm_idle = default_idle;
> +	disable_cpuidle();
>  	boot_option_idle_override = IDLE_HALT;
>  
>  	fiddle_vdso();
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index faae2c3..041df0b 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -34,6 +34,10 @@ int cpuidle_disabled(void)
>  {
>  	return off;
>  }
> +void disable_cpuidle(void)
> +{
> +	off = 1;
> +}
>  
>  #if defined(CONFIG_ARCH_HAS_CPU_IDLE_WAIT)
>  static void cpuidle_kick_cpus(void)
> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> index 36719ea..b89f67d 100644
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -122,6 +122,7 @@ struct cpuidle_driver {
>  };
>  
>  #ifdef CONFIG_CPU_IDLE
> +extern void disable_cpuidle(void);
>  
>  extern int cpuidle_register_driver(struct cpuidle_driver *drv);
>  struct cpuidle_driver *cpuidle_get_driver(void);
> @@ -135,6 +136,7 @@ extern int cpuidle_enable_device(struct cpuidle_device *dev);
>  extern void cpuidle_disable_device(struct cpuidle_device *dev);
>  
>  #else
> +static inline void disable_cpuidle(void) { }
>  
>  static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
>  {return -ENODEV; }
> -- 
> 1.7.5.rc0
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
