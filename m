Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab1FQQdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 12:33:07 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54786 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab1FQQdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 12:33:05 -0400
Date: Fri, 17 Jun 2011 18:32:41 +0200
From: Borislav Petkov <bp@amd64.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH 5/8] x86, mce: introduce mce_sysdev_init()
Message-ID: <20110617163241.GE20010@aftab>
References: <4DFB1242.90404@jp.fujitsu.com>
 <4DFB1438.3030504@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFB1438.3030504@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 04:45:44AM -0400, Hidetoshi Seto wrote:
> As a one of mce_sysdev_ family, coordinate a single function that
> initializes sysfs hierarchy here.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   65 ++++++++++++++++++++-----------------
>  1 files changed, 35 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index ad0e9fb..0424299 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1953,6 +1953,39 @@ static __cpuinit void mce_sysdev_remove(unsigned int cpu)
>  	cpumask_clear_cpu(cpu, mce_sysdev_initialized);
>  }
>  
> +static __init int mce_sysdev_init(void)
> +{
> +	int err, i;
> +
> +	zalloc_cpumask_var(&mce_sysdev_initialized, GFP_KERNEL);
> +
> +	/* init attributes for each mce_banks */
> +	for (i = 0; i < banks; i++) {
> +		struct mce_bank *b = &mce_banks[i];
> +		struct sysdev_attribute *a = &b->attr;
> +
> +		sysfs_attr_init(&a->attr);
> +		a->attr.name	= b->attrname;
> +		snprintf(b->attrname, ATTR_LEN, "bank%d", i);
> +
> +		a->attr.mode	= 0644;
> +		a->show		= show_bank;
> +		a->store	= set_bank;
> +	}
> +
> +	err = sysdev_class_register(&mce_sysdev_class);
> +	if (err)
> +		return err;
> +
> +	for_each_online_cpu(i) {
> +		err = mce_sysdev_create(i);
> +		if (err)
> +			return err;
> +	}

Yeah, let's handle the error case here and unwind to a sane state:

	if (err)
		goto sysdev_unwind;
...

sysdev_unwind:
	while (--i > 0)
		mce_sysdev_remove(i);


> +
> +	return err;
> +}
> +
>  /* Make sure there are no machine checks on offlined CPUs. */
>  static void __cpuinit mce_disable_cpu(void *h)
>  {
> @@ -2025,46 +2058,18 @@ static struct notifier_block mce_cpu_notifier __cpuinitdata = {
>  	.notifier_call = mce_cpu_callback,
>  };
>  
> -static __init void mce_init_banks(void)
> -{
> -	int i;
> -
> -	for (i = 0; i < banks; i++) {
> -		struct mce_bank *b = &mce_banks[i];
> -		struct sysdev_attribute *a = &b->attr;
> -
> -		sysfs_attr_init(&a->attr);
> -		a->attr.name	= b->attrname;
> -		snprintf(b->attrname, ATTR_LEN, "bank%d", i);
> -
> -		a->attr.mode	= 0644;
> -		a->show		= show_bank;
> -		a->store	= set_bank;
> -	}
> -}
> -
>  static __init int mcheck_init_device(void)
>  {
>  	int err;
> -	int i = 0;
>  
>  	if (!mce_available(&boot_cpu_data))
>  		return -EIO;
>  
> -	zalloc_cpumask_var(&mce_sysdev_initialized, GFP_KERNEL);
> -
> -	mce_init_banks();
> -
> -	err = sysdev_class_register(&mce_sysdev_class);
> +	/* register sysfs interface */
> +	err = mce_sysdev_init();
>  	if (err)
>  		return err;
>  
> -	for_each_online_cpu(i) {
> -		err = mce_sysdev_create(i);
> -		if (err)
> -			return err;
> -	}
> -
>  	register_syscore_ops(&mce_syscore_ops);
>  	register_hotcpu_notifier(&mce_cpu_notifier);
>  
> -- 
> 1.7.1

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
