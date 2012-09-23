Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2IWB5r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 21:57:47 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46963 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab2IWB5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 21:57:45 -0400
Date: Sat, 22 Sep 2012 18:56:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: "Bruce, Becky" <bbruce@ti.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-omap@vger.kernel.org>" <linux-omap@vger.kernel.org>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Hunter, Jon" <jon-hunter@ti.com>,
        "<snijsure@grid-net.com>" <snijsure@grid-net.com>, fweisbec@gmail.com
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
Message-ID: <20120923015645.GJ2934@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120920232114.GO2449@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209211803290.8839@utopia.booyaka.com>
 <20120921185827.GC2454@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209211900520.8839@utopia.booyaka.com>
 <20120921195717.GD2454@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209221836070.10663@utopia.booyaka.com>
 <20120922201043.GE2934@linux.vnet.ibm.com>
 <20120922215923.GA13161@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209222223080.22590@utopia.booyaka.com>
 <alpine.DEB.2.00.1209230136320.28806@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209230136320.28806@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092301-6148-0000-0000-000009E8A2CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2012 at 01:42:10AM +0000, Paul Walmsley wrote:
> Hi Paul
> 
> On Sat, 22 Sep 2012, Paul Walmsley wrote:
> 
> > On Sat, 22 Sep 2012, Paul E. McKenney wrote:
> > 
> > > And here is a patch.  I am still having trouble reproducing the problem,
> > > but figured that I should avoid serializing things.
> > 
> > Thanks, testing this now on v3.6-rc6.
> 
> Looks like you solved it!
> 
> Tested v3.6-rc6 + your stall diagnostic patch:
> 
>     http://marc.info/?l=linux-arm-kernel&m=134827237215882&w=2
> 
> on OMAP4430ES2 Pandaboard using omap2plus_defconfig and 
> CONFIG_RCU_CPU_STALL_INFO=y; got the stall warnings.
> 
> Then added "rcu: Fix day-one dyntick-idle stall-warning bug" from:
> 
>     http://marc.info/?l=linux-arm-kernel&m=134835120600590&w=2
> 
> Booted that, and the stall warnings did not appear within 30 minutes.

Very cool, thank you for your testing efforts!!!

May I apply your Tested-by to this patch?

And good show on the debugging patch -- it is quite good to have such
solid evidence that the bug that the fix was intended for was actually
occurring.

						Thanx, Paul

> To confirm that the problem being solved matched your hypothesis, the
> debugging patch below[1] was added to the RCU idle entry/exit code.
> 
> Without the bugfix patch, a boot log transcript was obtained
> indicating that the idle loop was entered with tick_nohz_enabled=1
> during a grace period with no callbacks present:
> 
>     http://www.pwsan.com/omap/transcripts/20120922-rcu-stall-debug-pre-fix.txt
> 
> The debugging events started to appear at 1.867370 seconds into the
> boot.  ENTER was pressed about 464 seconds in; this triggered the
> rcu_sched stall traceback.
> 
> With the bugfix patch, a boot log transcript was obtained that
> indicated that the condition under test never occurred after waiting
> about 20 minutes:
> 
>     http://www.pwsan.com/omap/transcripts/20120922-rcu-stall-debug-post-fix.txt
> 
> Thanks for being so willing to root-cause the issue, Paul; it's 
> appreciated, and it's been quite instructive as well.  Will address some 
> remaining loose ends in follow-up E-mails.
> 
> 
> - Paul
> 
> 
> [1] Debugging patch to printk() if the previous idle loop entry occurred 
> with tick_nohz_enabled=1 during a grace period with no RCU callbacks 
> present:
> 
> 
> ---
>  kernel/rcutree.c |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index f1eb7ad..f42941b 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -60,6 +60,9 @@
> 
>  /* Data structures. */
> 
> +extern int tick_nohz_enabled;
> +static int no_cbs_idle_entry_count;
> +
>  static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
> 
>  #define RCU_STATE_INITIALIZER(sname, cr) { \
> @@ -400,8 +403,12 @@ void rcu_idle_enter(void)
>  	unsigned long flags;
>  	long long oldval;
>  	struct rcu_dynticks *rdtp;
> +	int cpu;
> +	long totqlen = 0;
> +	struct rcu_data *rdp;
> 
>  	local_irq_save(flags);
> +	rdp = &__get_cpu_var(rcu_sched_data);
>  	rdtp = &__get_cpu_var(rcu_dynticks);
>  	oldval = rdtp->dynticks_nesting;
>  	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
> @@ -410,6 +417,12 @@ void rcu_idle_enter(void)
>  	else
>  		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
>  	rcu_idle_enter_common(rdtp, oldval);
> +	if (tick_nohz_enabled && rcu_gp_in_progress(rdp->rsp)) {
> +		for_each_possible_cpu(cpu)
> +			totqlen += per_cpu_ptr(rdp->rsp->rda, cpu)->qlen;
> +		if (totqlen == 0)
> +			no_cbs_idle_entry_count = 1;
> +	}
>  	local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL_GPL(rcu_idle_enter);
> @@ -503,6 +516,10 @@ void rcu_idle_exit(void)
>  		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
>  	rcu_idle_exit_common(rdtp, oldval);
>  	local_irq_restore(flags);
> +	if (no_cbs_idle_entry_count) {
> +		no_cbs_idle_entry_count = 0;
> +		pr_err("* Tickless idle was entered with zero RCU callbacks\n");
> +	}
>  }
>  EXPORT_SYMBOL_GPL(rcu_idle_exit);
> 
> -- 
> 1.7.10.4
> 

