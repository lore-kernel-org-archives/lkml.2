Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab2FYJRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 05:17:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59740 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab2FYJRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 05:17:39 -0400
Date: Mon, 25 Jun 2012 11:17:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: ShuoX Liu <shuox.liu@intel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v7 2/2] x86 mce: use new printk recursion disabling
 interface
Message-ID: <20120625091734.GA25839@gmail.com>
References: <20120605081448.GA7097@liondog.tnic>
 <4FCDD72A.9030701@intel.com>
 <4FCDD78A.3070106@intel.com>
 <20120605151542.GA10669@x1.osrc.amd.com>
 <1338942965.14538.233.camel@ymzhang.sh.intel.com>
 <4FCF155B.3090705@intel.com>
 <4FCF160D.8010404@intel.com>
 <20120606152238.GA3874@x1.osrc.amd.com>
 <4FD01896.1010506@intel.com>
 <4FD01933.7070000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD01933.7070000@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* ShuoX Liu <shuox.liu@intel.com> wrote:

> From: ShuoX Liu <shuox.liu@intel.com>
> 
> On x86 machines, some times MCE happens just when kernel calls printk
> to output some log info to serial console, while usually MCE module in
> kernel is used to print out some hardware error information, such like
> bad cache or bad memory bank. That causes printk recursion and printk
> would omit MCE printk output.
> 
> We hit it when running MTBF testing on Android ATOM mobiles.
> 
> Here in print_mce, we choose to disable printk recursion to make sure
> MCE logs printed out.
> 
> Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
> Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 2afcbd2..6056e94 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -242,6 +242,7 @@ static void print_mce(struct mce *m)
>  {
>  	int ret = 0;
>  
> +	printk_recursion_check_disable();
>  	pr_emerg(HW_ERR "CPU %d: Machine Check Exception: %Lx Bank %d: %016Lx\n",
>  	       m->extcpu, m->mcgstatus, m->bank, m->status);
>  
> @@ -275,10 +276,13 @@ static void print_mce(struct mce *m)
>  	 * (if the CPU has an implementation for that)
>  	 */
>  	ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
> -	if (ret == NOTIFY_STOP)
> +	if (ret == NOTIFY_STOP) {
> +		printk_recursion_check_enable();
>  		return;
> +	}
>  
>  	pr_emerg_ratelimited(HW_ERR "Run the above through 'mcelog --ascii'\n");
> +	printk_recursion_check_enable();

Ok, this looks useful and it solves a real problem, but I'd 
prefer a better interface: instead of exposing the guts of 
printk to drivers in an unsafe manner (and allowing them to keep 
printk in an unsafe state indefinitely), shouldn't we instead 
introduce printk_emergency() (and variants) that just disable 
the recursion check, do the printk and then enable them?

That way drivers cannot possibly leave the recursion check 
disabled permanently and it would also be much more obvious 
*which* actual printk sites are affected by this exception.

In theory this could be achieved via a new, super-high-prio 
printk level: KERN_CRASH or so, which the core printk code could 
check - without introducing a new side-facility.

Thanks,

	Ingo
