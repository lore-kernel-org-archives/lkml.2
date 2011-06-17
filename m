Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab1FQN45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 09:56:57 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51715 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab1FQN44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 09:56:56 -0400
Date: Fri, 17 Jun 2011 15:56:34 +0200
From: Borislav Petkov <bp@amd64.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH 1/8] x86, mce: stop calling del_timer_sync() from
 interrupt
Message-ID: <20110617135634.GF18054@aftab>
References: <4DFB1242.90404@jp.fujitsu.com>
 <4DFB1304.10604@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFB1304.10604@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 04:40:36AM -0400, Hidetoshi Seto wrote:
> Function del_timer_sync() has WARN_ON(in_irq()) in it because
> calling it from interrupt context can cause deadlock if it
> interrupts the target timer running.

No need to explain the del_timer_sync() code here - just say that it's
not allowed to call it from an IRQ context.

> In MCE code, del_timer_sync() is used with on_each_cpu() in
> some parts for sysfs files:

	 ... for the following sysfs files:

>   bank*, check_interval, cmci_disabled and ignore_ce.
> 
> However use of on_each_cpu() results in calling the function
> passed as the argument in the interrupt context.  It means you
> can see a flood of warnings from del_timer_sync() by a simple
> file access, for example:
> 
>   echo 300 > /sys/devices/system/machinecheck/machinecheck0/check_interval

Good.

> 
> Fortunately these MCE specific files are rare-used and AFAIK

					  rarely used

> only few MCE geeks experience this warning on write.

MCE geeks ??? I wonder who those are :-)

> To remove the warning (for my happy hacking), move timer deletion
> outside of the interrupt context ;-)
> 
> v2: update patch description
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   22 ++++++++++++++++------
>  1 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 08363b0..42fc8d2 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1140,6 +1140,17 @@ static void mce_start_timer(unsigned long data)
>  	add_timer_on(t, smp_processor_id());
>  }
>  
> +/* Must not be called from interrupt where del_timer_sync() can deadlock */
> +static void mce_timer_delete_all(void)
> +{
> +	int cpu;
> +
> +	for_each_online_cpu(cpu) {
> +		if (mce_available(&per_cpu(cpu_info, cpu)))
> +			del_timer_sync(&per_cpu(mce_timer, cpu));
> +	}
> +}

You're adding the mce_available(..) check just to remove it in the next
patch. Since all those sysfs nodes are behind such a check, there's no
need for it here too.

>  static void mce_do_trigger(struct work_struct *work)
>  {
>  	call_usermodehelper(mce_helper, mce_helper_argv, NULL, UMH_NO_WAIT);
> @@ -1750,7 +1761,6 @@ static struct syscore_ops mce_syscore_ops = {
>  
>  static void mce_cpu_restart(void *data)
>  {
> -	del_timer_sync(&__get_cpu_var(mce_timer));
>  	if (!mce_available(__this_cpu_ptr(&cpu_info)))
>  		return;
>  	__mcheck_cpu_init_generic();
> @@ -1760,16 +1770,15 @@ static void mce_cpu_restart(void *data)
>  /* Reinit MCEs after user configuration changes */
>  static void mce_restart(void)
>  {
> +	mce_timer_delete_all();
>  	on_each_cpu(mce_cpu_restart, NULL, 1);
>  }
>  
>  /* Toggle features for corrected errors */
> -static void mce_disable_ce(void *all)
> +static void mce_disable_cmci(void *data)
>  {
>  	if (!mce_available(__this_cpu_ptr(&cpu_info)))
>  		return;
> -	if (all)
> -		del_timer_sync(&__get_cpu_var(mce_timer));
>  	cmci_clear();
>  }
>  
> @@ -1852,7 +1861,8 @@ static ssize_t set_ignore_ce(struct sys_device *s,
>  	if (mce_ignore_ce ^ !!new) {
>  		if (new) {
>  			/* disable ce features */
> -			on_each_cpu(mce_disable_ce, (void *)1, 1);
> +			mce_timer_delete_all();
> +			on_each_cpu(mce_disable_cmci, NULL, 1);
>  			mce_ignore_ce = 1;
>  		} else {
>  			/* enable ce features */
> @@ -1875,7 +1885,7 @@ static ssize_t set_cmci_disabled(struct sys_device *s,
>  	if (mce_cmci_disabled ^ !!new) {
>  		if (new) {
>  			/* disable cmci */
> -			on_each_cpu(mce_disable_ce, NULL, 1);
> +			on_each_cpu(mce_disable_cmci, NULL, 1);
>  			mce_cmci_disabled = 1;
>  		} else {
>  			/* enable cmci */
> -- 
> 1.7.1

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
