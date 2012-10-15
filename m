Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab2JOUq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:46:27 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:47977 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746Ab2JOUq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:46:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
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
Subject: Re: [PATCH v9 05/12] x86, hotplug, suspend: Online CPU0 for suspend or hibernate
Date: Mon, 15 Oct 2012 22:50:06 +0200
Message-ID: <10020874.9eDCB3ZAkx@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1350058189-6769-6-git-send-email-fenghua.yu@intel.com>
References: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com> <1350058189-6769-6-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 of October 2012 09:09:42 Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Because x86 BIOS requires CPU0 to resume from sleep, suspend or hibernate can't
> be executed if CPU0 is detected offline. To make suspend or hibernate and
> further resume succeed, CPU0 must be online.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/power/cpu.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 44 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
> index 218cdb1..adde775 100644
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
> +		pr_warn("CPU0 is offline.\n");
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

I wonder if there's anything preventing CPU0 from becoming offline after you've
done this check and before user space is frozen?

Rafael


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
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
