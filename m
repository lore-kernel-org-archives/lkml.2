Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934613Ab1JETDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:03:43 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:59946 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934299Ab1JETDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:03:42 -0400
Message-ID: <4E8CAA05.9010200@linux.vnet.ibm.com>
Date: Thu, 06 Oct 2011 00:33:33 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, srivatsa.bhat@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <lenb@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] x86/mtrr/main.c: Ask the first online CPU to save
 mtrr
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com> <1317832759-10223-3-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1317832759-10223-3-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/05/2011 10:09 PM, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Ask the first online CPU to save mtrr instead of asking BSP. BSP can be
> offlined when mtrr_save_state() is called.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/kernel/cpu/mtrr/main.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
> index 6b96110..e18a4d3 100644
> --- a/arch/x86/kernel/cpu/mtrr/main.c
> +++ b/arch/x86/kernel/cpu/mtrr/main.c
> @@ -695,11 +695,13 @@ void mtrr_ap_init(void)
>  }
> 
>  /**
> - * Save current fixed-range MTRR state of the BSP
> + * Save current fixed-range MTRR state of the first cpu in cpu_online_mask.
>   */
>  void mtrr_save_state(void)
>  {
> -	smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1);
> +	int first_cpu = cpumask_first(cpu_online_mask);

There is a race condition here as well. What if, at this point, the cpu
represented by first_cpu is taken offline (due to a cpu hotplug operation)?

> +	smp_call_function_single(first_cpu, mtrr_save_fixed_ranges, NULL, 1);
>  }
> 
>  void set_mtrr_aps_delayed_init(void)


-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
