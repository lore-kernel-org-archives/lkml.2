Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1CVOxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 10:53:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47769 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1CVOxF (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Mar 2011 10:53:05 -0400
Date: Tue, 22 Mar 2011 10:50:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH V4 4/5] cpuidle: driver for xen
Message-ID: <20110322145054.GB26952@dumpdata.com>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123324.28725.3131.stgit@tringupt.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322123324.28725.3131.stgit@tringupt.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D88B752.0061,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 06:03:28PM +0530, Trinabh Gupta wrote:
> This patch implements a default cpuidle driver for xen.
> Earlier pm_idle was flipped to default_idle. Maybe there
> is a better way to ensure default_idle is called
> without using this cpuidle driver.

Please also CC the Xen devel mailing list (I did this for you)

I couldn't find it in the description, but I was wondering
what is that you are trying to fix? What is the problem description?

Two, you mention in your description that it was tested on x86 systems. did
you test this with Xen? If so, what version.

> 
> Signed-off-by: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
> ---
> 
>  arch/x86/xen/setup.c |   42 +++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 41 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index a8a66a5..4fce4cd 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -9,6 +9,8 @@
>  #include <linux/mm.h>
>  #include <linux/pm.h>
>  #include <linux/memblock.h>
> +#include <linux/cpuidle.h>
> +#include <linux/slab.h>
>  
>  #include <asm/elf.h>
>  #include <asm/vdso.h>
> @@ -321,6 +323,44 @@ void __cpuinit xen_enable_syscall(void)
>  #endif /* CONFIG_X86_64 */
>  }
>  
> +static struct cpuidle_driver xen_idle_driver = {
> +	.name = "xen_idle",
> +	.owner = THIS_MODULE,
> +	.priority = 1,
> +};
> +
> +extern struct cpuidle_state state_default_state;
> +
> +static int setup_cpuidle(int cpu)
> +{
> +	struct cpuidle_device *dev = kzalloc(sizeof(struct cpuidle_device),
> +					GFP_KERNEL);

No checking to see if dev == NULL?
> +	int count = CPUIDLE_DRIVER_STATE_START;
> +	dev->cpu = cpu;
> +	dev->drv = &xen_idle_driver;
> +
> +	dev->states[count] = state_default_idle;
> +	count++;
> +
> +	dev->state_count = count;
> +
> +	if (cpuidle_register_device(dev))
> +		return -EIO; 
No cleanup of the 'dev' so that we don't leak memory?

> +	return 0;
> +}
> +
> +static int xen_idle_init(void)
> +{
> +	int retval, i;
> +	retval = cpuidle_register_driver(&xen_idle_driver);
> +
> +	for_each_online_cpu(i) {
> +		setup_cpuidle(i);
> +	}
> +
> +	return 0;
> +}
> +
>  void __init xen_arch_setup(void)
>  {
>  	xen_panic_handler_init();
> @@ -354,7 +394,7 @@ void __init xen_arch_setup(void)
>  #ifdef CONFIG_X86_32
>  	boot_cpu_data.hlt_works_ok = 1;
>  #endif
> -	pm_idle = default_idle;
> +	xen_idle_init();
>  	boot_option_idle_override = IDLE_HALT;
>  
>  	fiddle_vdso();
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
