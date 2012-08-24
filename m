Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739Ab2HXJnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:43:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33984 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab2HXJm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:42:57 -0400
Date: Fri, 24 Aug 2012 11:42:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v7 05/12] Because x86 BIOS requires CPU0 to resume from
 sleep, suspend or hibernate can't be executed if CPU0 is detected offline.
 To make suspend or hibernate and further resume succeed, CPU0 must be
 online.
Message-ID: <20120824094254.GF3019@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Asit K Mallick <asit.k.mallick@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Arjan Dan De Ven <arjan@linux.intel.com>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Len Brown <len.brown@intel.com>,
	"Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Chen Gong <gong.chen@linux.intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
References: <1345769771-27019-1-git-send-email-fenghua.yu@intel.com>
 <1345769771-27019-6-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1345769771-27019-6-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 05:56:04PM -0700, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 

Ditto for too long Subject line and missing commit message.

> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/power/cpu.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 44 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
> index 218cdb1..3338609 100644
> --- a/arch/x86/power/cpu.c
> +++ b/arch/x86/power/cpu.c
> @@ -237,3 +237,47 @@ void restore_processor_state(void)
>  #ifdef CONFIG_X86_32
>  EXPORT_SYMBOL(restore_processor_state);
>  #endif
> +
> +/*
> + * When bsp_check() is called in hibernate and suspend, cpu hotplug
> + * is disabled already. So it's unnessary to handle race condition between
> + * cpumask query and cpu hotplug.
> + */
> +static int bsp_check(void)
> +{
> +	if (cpumask_first(cpu_online_mask) != 0) {
> +		printk(KERN_WARNING "CPU0 is offline.\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +static int bsp_pm_callback(struct notifier_block *nb, unsigned long action,
> +			   void *ptr)
> +{
> +	int ret = 0;
> +
> +	switch (action) {
> +	case PM_SUSPEND_PREPARE:
> +	case PM_HIBERNATION_PREPARE:
> +		ret = bsp_check();
> +		break;
> +	default:
> +		break;
> +	}
> +	return notifier_from_errno(ret);
> +}
> +
> +static int __init bsp_pm_check_init(void)
> +{
> +	/*
> +	 * Set this bsp_pm_callback as lower priority than
> +	 * cpu_hotplug_pm_callback. So cpu_hotplug_pm_callback will be called
> +	 * earlier to disable cpu hotplug before bsp online check.
> +	 */
> +	pm_notifier(bsp_pm_callback, -INT_MAX);
> +	return 0;
> +}
> +
> +core_initcall(bsp_pm_check_init);
> -- 
> 1.7.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
    Boris.
