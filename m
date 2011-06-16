Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab1FPOJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:09:19 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57452 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab1FPOJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:09:17 -0400
Date: Thu, 16 Jun 2011 16:09:16 +0200
From: Borislav Petkov <bp@amd64.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, "x86@kernel.org" <x86@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] x86, mce: stop calling del_timer_sync() from interrupt
Message-ID: <20110616140915.GA5065@gere.osrc.amd.com>
References: <4DF9B0A3.4030904@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF9B0A3.4030904@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 04:28:35PM +0900, Hidetoshi Seto wrote:
> Use of on_each_cpu() results in calling the function passed as the
> argument on interrupt context.

	   in

> Calling del_timer_sync() from interrupt context can cause deadlock
> if it interrupts the target timer running.
> 
> MCE code has some such misuse of del_timer_sync() in parts for sysfs
> file; bank*, check_interval, cmci_disabled and ignore_ce.
> Fortunately these files are rare-used but you will be warned on write.

So, you're saying you're hitting the WARN_ON(in_irq()) in
del_timer_sync() ?

> This patch will fix it.

You could say

  "Move timer deletion outside of the interrupt context as a fix"

or something to that effect to make it much more precise what the patch
is doing.

Patch idea looks fine, see below for some nitpicking :).

> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   22 ++++++++++++++++------
>  1 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index ff1ae9b..77df54f 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1170,6 +1170,17 @@ static void mce_start_timer(unsigned long data)
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
> +
>  static void mce_do_trigger(struct work_struct *work)
>  {
>  	call_usermodehelper(mce_helper, mce_helper_argv, NULL, UMH_NO_WAIT);
> @@ -1768,7 +1779,6 @@ static struct syscore_ops mce_syscore_ops = {
>  
>  static void mce_cpu_restart(void *data)
>  {
> -	del_timer_sync(&__get_cpu_var(mce_timer));
>  	if (!mce_available(__this_cpu_ptr(&cpu_info)))
>  		return;

I'm wondering, was this actually a bug - the fact that we deleted the
timer _before_ we do the mce_available() check.

In looking at it a bit more, it looks like mce_restart() is always
executed on codepaths behind mce_available() checks so the

	if (mce_available(...))
		del_timer_sync(...);

part in mce_timer_delete_all could be done without the if-check, no?

>  	__mcheck_cpu_init_generic();
> @@ -1778,16 +1788,15 @@ static void mce_cpu_restart(void *data)
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
> @@ -1870,7 +1879,8 @@ static ssize_t set_ignore_ce(struct sys_device *s,
>  	if (mce_ignore_ce ^ !!new) {
>  		if (new) {
>  			/* disable ce features */
> -			on_each_cpu(mce_disable_ce, (void *)1, 1);
> +			mce_timer_delete_all();
> +			on_each_cpu(mce_disable_cmci, NULL, 1);
>  			mce_ignore_ce = 1;
>  		} else {
>  			/* enable ce features */
> @@ -1893,7 +1903,7 @@ static ssize_t set_cmci_disabled(struct sys_device *s,
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

Thanks.
