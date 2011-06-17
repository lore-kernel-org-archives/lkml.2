Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab1FQRAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 13:00:22 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57589 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab1FQRAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 13:00:18 -0400
Date: Fri, 17 Jun 2011 18:59:55 +0200
From: Borislav Petkov <bp@amd64.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH 6/8] x86, mce: introduce mce_memory_failure_process()
Message-ID: <20110617165955.GG20010@aftab>
References: <4DFB1242.90404@jp.fujitsu.com>
 <4DFB1476.40804@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFB1476.40804@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 04:46:46AM -0400, Hidetoshi Seto wrote:
> And relocate related functions to near by mce_ring* routines.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   26 +++++++++++++++++---------
>  1 files changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 0424299..a118496 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -395,6 +395,8 @@ static inline void mce_gather_info(struct mce *m, struct pt_regs *regs)
>  }
>  
>  /*
> + * mce_ring, mce_memory_failure: Support for Memory errors
> + *
>   * Simple lockless ring to communicate PFNs from the exception handler with the
>   * process context work function. This is vastly simplified because there's
>   * only a single reader and a single writer.
> @@ -449,6 +451,20 @@ static int mce_ring_add(unsigned long pfn)
>  	return 0;
>  }
>  
> +/* dummy to break dependency. actual code is in mm/memory-failure.c */
> +void __attribute__((weak)) memory_failure(unsigned long pfn, int vector)
> +{
> +	pr_err("Action optional memory failure at %lx ignored\n", pfn);
> +}
> +
> +static inline void mce_memory_failure_process(void)
> +{
> +	unsigned long pfn;
> +
> +	while (mce_ring_get(&pfn))
> +		memory_failure(pfn, MCE_VECTOR);
> +}
> +

Frankly, I don't see the need to carve out two lines of code into a
function to avoid duplication and causing needless churn for this.

Just do the

	while (..)
		memory_failure(..)

in the next patch and that's it. mce.c is already cluttered with too
much stuff anyway.

>  static int mce_available(struct cpuinfo_x86 *c)
>  {
>  	if (mce_disabled)
> @@ -1049,12 +1065,6 @@ out:
>  }
>  EXPORT_SYMBOL_GPL(do_machine_check);
>  
> -/* dummy to break dependency. actual code is in mm/memory-failure.c */
> -void __attribute__((weak)) memory_failure(unsigned long pfn, int vector)
> -{
> -	printk(KERN_ERR "Action optional memory failure at %lx ignored\n", pfn);
> -}
> -
>  /*
>   * Called after mce notification in process context. This code
>   * is allowed to sleep. Call the high level VM handler to process
> @@ -1068,10 +1078,8 @@ void __attribute__((weak)) memory_failure(unsigned long pfn, int vector)
>   */
>  void mce_notify_process(void)
>  {
> -	unsigned long pfn;
>  	mce_notify_irq();
> -	while (mce_ring_get(&pfn))
> -		memory_failure(pfn, MCE_VECTOR);
> +	mce_memory_failure_process();
>  }
>  
>  static void mce_process_work(struct work_struct *dummy)
> -- 
> 1.7.1
> 
> 
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
