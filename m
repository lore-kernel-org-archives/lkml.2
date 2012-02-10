Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261Ab2BJVoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 16:44:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759185Ab2BJVoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 16:44:14 -0500
Date: Fri, 10 Feb 2012 16:43:50 -0500
From: Don Zickus <dzickus@redhat.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jack Steiner <steiner@sgi.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] UV Update NMI handlers
Message-ID: <20120210214350.GA6397@redhat.com>
References: <20120202235650.563029146@gulag1.americas.sgi.com>
 <20120202235651.025794606@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202235651.025794606@gulag1.americas.sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 05:56:53PM -0600, Mike Travis wrote:
> These changes update the UV NMI handler to be compatible with the new
> NMI processing.

Sorry for just noticing this now...

> -int uv_handle_nmi(unsigned int reason, struct pt_regs *regs)
> +int uv_handle_nmi(unsigned int cmd, struct pt_regs *regs)
>  {
> -	unsigned long real_uv_nmi;
> -	int bid;
> +	static int in_uv_nmi = -1;
> +	static atomic_t nr_nmi_cpus;
> +	int bid, handled = 0;
> +
> +	if (cmd != NMI_LOCAL && cmd != NMI_UNKNOWN)
> +		return NMI_DONE;

This shouldn't be necessary, you register on a list, either NMI_LOCAL or
NMI_UNKNOWN.  The reason for passing the command is in case you register
on both and need to separate the code paths.

If your handler is entered and the above if-statement is true, then the
code did something wrong with registering and should be fix.

For the most part that if-statement should never be needed now.

> +
> +	if (in_crash_kexec)
> +		/* do nothing if entering the crash kernel */
> +		return NMI_DONE;

This should also be not needed.  This was only necessary because the
priorities were screwed up and the kdump NMI handler was being called
after this handler.  Now the kdump handler is registered as the highest
priority and this one should never be called.  Again making this piece
unnecessary.

And if you do notice this in the future, then it is a bug and please let
me know so I can fix it.

> +
> +	/* note which NMI this one is */
> +	__this_cpu_inc(cpu_nmi_count);
>  
>  	/*
>  	 * Each blade has an MMR that indicates when an NMI has been sent
> -	 * to cpus on the blade. If an NMI is detected, atomically
> -	 * clear the MMR and update a per-blade NMI count used to
> -	 * cause each cpu on the blade to notice a new NMI.
> +	 * to cpus on the blade.  We optimize accesses to the MMR as the
> +	 * read operation is expensive and only the first CPU to enter this
> +	 * function needs to read the register and set a flag indicating
> +	 * we are indeed servicing an external BMC NMI.  Once it's determined
> +	 * whether or not this is a real NMI, the last responding CPU clears
> +	 * the flag for the next NMI.
>  	 */
> -	bid = uv_numa_blade_id();
> -	real_uv_nmi = (uv_read_local_mmr(UVH_NMI_MMR) & UV_NMI_PENDING_MASK);
> +	if (in_uv_nmi < 0) {
> +		spin_lock(&uv_nmi_reason_lock);
> +		if (in_uv_nmi < 0) {
> +			int nc = num_online_cpus();
> +			atomic_set(&nr_nmi_cpus, nc);
> +			in_uv_nmi = check_nmi_mmr();
> +		}
> +		spin_unlock(&uv_nmi_reason_lock);
> +	}
> +
> +	if (likely(in_uv_nmi == 0)) {
> +		if (atomic_sub_and_test(1, &nr_nmi_cpus) == 0)
> +			in_uv_nmi = -1;
> +		return NMI_DONE;
> +	}

I'm a little confused on this part.  Originally you had one NMI sent to
the system and it was an issue.  You guys changed the code so on UV
systems an external NMI went to _all_ cpus.  Now you are kinda converting
it back to one NMI.  

How about changing the x86_ops to only send one NMI to a cpu and then use
arch_trigger_all_cpu_backtrace() to generate a backtrace (through an NMI
IPI) to all cpus.  This would elminiate all the spinlock magic you are
doing here and still generate the backtrace you wanted (if that is still
the main reason for this NMI, IIRC).

> +
> +	/* If we are here, we are processing a real BMC NMI */
> +
> +#ifdef CONFIG_KGDB_KDB_NOT_YET
> +#include <linux/kdb.h>
> +
> +	/* Here we want to call KDB with reason == NMI */
> +	if (kdb_on) {
> +		static int controlling_cpu = -1;
> +
> +		spin_lock(&uv_nmi_lock);
> +		if (controlling_cpu == -1) {
> +			controlling_cpu = smp_processor_id();
> +			spin_unlock(&uv_nmi_lock);
> +			(void)kdb(LKDB_REASON_NMI, reason, regs);
> +			controlling_cpu = -1;
> +		} else {
> +			spin_unlock(&uv_nmi_lock);
> +			(void)kdb(LKDB_REASON_ENTER_SLAVE, reason, regs);
> +			while (controlling_cpu != -1)
> +				cpu_relax();
> +		}
> +		handled = 1;	/* handled by KDB */
> +	}
> +#endif

Would it just be easier to register another NMI handler for this case? I
don't think you need to access the BMC for this NMI? I believe it is an
artificial one and you can just register on NMI_UNKNOWN.  I think the
arch/x86/kernel/kgdb.c does this currently.

>  
> -	if (unlikely(real_uv_nmi)) {
> +	/* Only one cpu per blade needs to clear the MMR BMC NMI flag */
> +	bid = uv_numa_blade_id();
> +	if (uv_blade_info[bid].nmi_count < __get_cpu_var(cpu_nmi_count)) {
>  		spin_lock(&uv_blade_info[bid].nmi_lock);
> -		real_uv_nmi = (uv_read_local_mmr(UVH_NMI_MMR) & UV_NMI_PENDING_MASK);
> -		if (real_uv_nmi) {
> -			uv_blade_info[bid].nmi_count++;
> -			uv_write_local_mmr(UVH_NMI_MMR_CLEAR, UV_NMI_PENDING_MASK);
> +		if (uv_blade_info[bid].nmi_count <
> +						__get_cpu_var(cpu_nmi_count)) {
> +			uv_blade_info[bid].nmi_count =
> +						__get_cpu_var(cpu_nmi_count);
> +			clear_nmi_mmr();
>  		}
>  		spin_unlock(&uv_blade_info[bid].nmi_lock);
>  	}

Using one NMI I think elminates all this stuff too.

>  
> -	if (likely(__get_cpu_var(cpu_last_nmi_count) == uv_blade_info[bid].nmi_count))
> -		return NMI_DONE;
> +	/* If not handled by KDB, then print a process trace for each cpu */
> +	if (!handled) {
> +		int saved_console_loglevel = console_loglevel;
>  
> -	__get_cpu_var(cpu_last_nmi_count) = uv_blade_info[bid].nmi_count;
> +		/*
> +		 * Use a lock so only one cpu prints at a time.
> +		 * This prevents intermixed output.  We can reuse the
> +		 * uv_nmi_lock since if KDB was called, then all the
> +		 * CPUs have exited KDB, and if it was not called,
> +		 * then the lock was not used.
> +		 */
> +		spin_lock(&uv_nmi_lock);
> +		pr_err("== UV NMI process trace NMI %lu: ==\n",
> +						__get_cpu_var(cpu_nmi_count));
> +		console_loglevel = 15;
> +		show_regs(regs);
> +		console_loglevel = saved_console_loglevel;
> +		spin_unlock(&uv_nmi_lock);
> +	}

This sort of mimics what arch_trigger_all_cpu_backtrace_handler is doing.

>  
> -	/*
> -	 * Use a lock so only one cpu prints at a time.
> -	 * This prevents intermixed output.
> -	 */
> -	spin_lock(&uv_nmi_lock);
> -	pr_info("UV NMI stack dump cpu %u:\n", smp_processor_id());
> -	dump_stack();
> -	spin_unlock(&uv_nmi_lock);
> +	/* last cpu resets the "in nmi" flag */
> +	if (atomic_sub_and_test(1, &nr_nmi_cpus) == 0)
> +		in_uv_nmi = -1;
>  
>  	return NMI_HANDLED;
>  }
>  
>  void uv_register_nmi_notifier(void)
>  {
> -	if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv"))
> +	if (register_nmi_handler(NMI_LOCAL, uv_handle_nmi, 0, "uv"))
>  		printk(KERN_WARNING "UV NMI handler failed to register\n");

Right.  And then perhaps a second one for NMI_UNKNOWN for kgdb?

Cheers,
Don
