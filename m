Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002Ab1LPQf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:35:57 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38388 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759587Ab1LPQfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:35:52 -0500
Date: Fri, 16 Dec 2011 17:35:49 +0100
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 5/6] x86, mce: handle "action required" errors (unjumbled
 version)
Message-ID: <20111216163549.GD12397@aftab>
References: <CA+8MBb+T_y7CHkxjRHr8VK0gk1zo1m-ib71A5k5N4NDn0PtEzw@mail.gmail.com>
 <0279870@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0279870@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 04:22:25PM -0800, Tony Luck wrote:
> All non-urgent actions (reporting low severity errors and handling
> "action-optional" errors) are now handled by a work queue. This
> means that TIF_MCE_NOTIFY can be used to block execution for a
> thread experiencing an "action-required" fault until we get all
> cpus out of the machine check handler (and the thread that hit
> the fault into mce_notify_process().
> 
> We use the new mce_{save,find,clear}_info() API to get information
> from do_machine_check() to mce_notify_process(), and then use the
> newly improved memory_failure(..., MF_ACTION_REQUIRED) to handle
> the error (possibly signalling the process).
> 
> Update some comments to make the new code flows clearer.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> 
> [Version posted earlier had the diff included in the commit comment,
>  and then the real copy of the diff - making it hard to read. Sorry.]
> 
>  arch/x86/kernel/cpu/mcheck/mce.c |   71 ++++++++++++++++++++++++--------------
>  1 files changed, 45 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 7d7303a..dfd20a6 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -982,7 +982,9 @@ void do_machine_check(struct pt_regs *regs, long error_code)
>  	barrier();
>  
>  	/*
> -	 * When no restart IP must always kill or panic.
> +	 * When no restart IP might need to kill or panic.
> +	 * Assume the worst for now, but if we find the
> +	 * severity is MCE_AR_SEVERITY we have other options.
>  	 */
>  	if (!(m.mcgstatus & MCG_STATUS_RIPV))
>  		kill_it = 1;
> @@ -1036,12 +1038,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
>  			continue;
>  		}
>  
> -		/*
> -		 * Kill on action required.
> -		 */
> -		if (severity == MCE_AR_SEVERITY)
> -			kill_it = 1;
> -
>  		mce_read_aux(&m, i);
>  
>  		/*
> @@ -1062,6 +1058,8 @@ void do_machine_check(struct pt_regs *regs, long error_code)
>  		}
>  	}
>  
> +	m = *final;
> +
>  	if (!no_way_out)
>  		mce_clear_state(toclear);
>  
> @@ -1080,7 +1078,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
>  	 * support MCE broadcasting or it has been disabled.
>  	 */
>  	if (no_way_out && tolerant < 3)
> -		mce_panic("Fatal machine check on current CPU", final, msg);
> +		mce_panic("Fatal machine check on current CPU", &m, msg);
>  
>  	/*
>  	 * If the error seems to be unrecoverable, something should be
> @@ -1089,11 +1087,13 @@ void do_machine_check(struct pt_regs *regs, long error_code)
>  	 * high, don't try to do anything at all.
>  	 */
>  
> -	if (kill_it && tolerant < 3)
> +	if (worst != MCE_AR_SEVERITY && kill_it && tolerant < 3)
>  		force_sig(SIGBUS, current);
>  
> -	/* notify userspace ASAP */
> -	set_thread_flag(TIF_MCE_NOTIFY);
> +	if (worst == MCE_AR_SEVERITY) {
> +		mce_save_info(m.addr);
> +		set_thread_flag(TIF_MCE_NOTIFY);
> +	}
>  
>  	if (worst > 0)
>  		mce_report_event(regs);
> @@ -1107,6 +1107,8 @@ EXPORT_SYMBOL_GPL(do_machine_check);
>  #ifndef CONFIG_MEMORY_FAILURE
>  int memory_failure(unsigned long pfn, int vector, int flags)
>  {
> +	if (flags & MF_ACTION_REQUIRED)
> +		return -ENXIO; /* panic? */

Yes, an AR error _is_ an uncorrectable error so in order to stay
backwards-compatible, we should panic here unconditionally IMO.

>  	printk(KERN_ERR "Uncorrected memory error in page 0x%lx ignored\n"
>  		"Rebuild kernel with CONFIG_MEMORY_FAILURE=y for smarter handling\n", pfn);
>  
> @@ -1115,27 +1117,46 @@ int memory_failure(unsigned long pfn, int vector, int flags)
>  #endif
>  
>  /*
> - * Called after mce notification in process context. This code
> - * is allowed to sleep. Call the high level VM handler to process
> - * any corrupted pages.
> - * Assume that the work queue code only calls this one at a time
> - * per CPU.
> - * Note we don't disable preemption, so this code might run on the wrong
> - * CPU. In this case the event is picked up by the scheduled work queue.
> - * This is merely a fast path to expedite processing in some common
> - * cases.
> + * Called in process context that interrupted by MCE and marked with
> + * TIF_MCE_NOTFY, just before returning to errorneous userland.

      TIF_MCE_NOTIFY


> + * This code is allowed to sleep.
> + * Attempt possible recovery such as calling the high level VM handler to
> + * process any corrupted pages, and kill/signal current process if required.
> + * Action required errors are handled here.
>   */
>  void mce_notify_process(void)
>  {
>  	unsigned long pfn;
> -	mce_notify_irq();
> -	while (mce_ring_get(&pfn))
> -		memory_failure(pfn, MCE_VECTOR, 0);
> +	struct mce_info *mi = mce_find_info();
> +
> +	if (!mi)
> +		mce_panic("Lost address", NULL, NULL);

Yeah, maybe "Lost physical address for unconsumed uncorrectable error"

> +	pfn = mi->paddr >> PAGE_SHIFT;
> +
> +	clear_thread_flag(TIF_MCE_NOTIFY);
> +
> +	pr_err("Uncorrected hardware memory error in user-access at %llx",
> +		 mi->paddr);
> +	if (memory_failure(pfn, MCE_VECTOR, MF_ACTION_REQUIRED) < 0) {
> +		pr_err("Memory error not recovered");
> +		force_sig(SIGBUS, current);
> +	} else {
> +		pr_err("Memory error recovered");

No need for that because memory_failure() is chatty enough already, due
to action_result()?

> +	}
> +	mce_clear_info(mi);
>  }
>  
> +/*
> + * Action optional processing happens here (picking up
> + * from the list of faulting pages that do_machine_check()
> + * placed into the "ring").
> + */
>  static void mce_process_work(struct work_struct *dummy)
>  {
> -	mce_notify_process();
> +	unsigned long pfn;
> +
> +	while (mce_ring_get(&pfn))
> +		memory_failure(pfn, MCE_VECTOR, 0);
>  }
>  
>  #ifdef CONFIG_X86_MCE_INTEL
> @@ -1225,8 +1246,6 @@ int mce_notify_irq(void)
>  	/* Not more than two messages every minute */
>  	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
>  
> -	clear_thread_flag(TIF_MCE_NOTIFY);
> -
>  	if (test_and_clear_bit(0, &mce_need_notify)) {
>  		/* wake processes polling /dev/mcelog */
>  		wake_up_interruptible(&mce_chrdev_wait);
> -- 

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
