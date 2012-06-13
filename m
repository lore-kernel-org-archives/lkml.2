Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab2FMS6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:58:10 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37326 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab2FMS6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:58:08 -0400
Date: Wed, 13 Jun 2012 11:57:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
Message-ID: <20120613185748.GF2427@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120613102823.373180763@linutronix.de>
 <20120613105815.206105518@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613105815.206105518@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061318-6148-0000-0000-000006AC274B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 11:00:54AM -0000, Thomas Gleixner wrote:
> Provide a generic interface for setting up and tearing down percpu
> threads.
> 
> On registration the threads for already online cpus are created and
> started. On deregistration (modules) the threads are stoppped.
> 
> During hotplug operations the threads are created, started, parked and
> unparked. The datastructure for registration provides a pointer to
> percpu storage space and optional setup, cleanup, park, unpark
> functions. These functions are called when the thread state changes.
> 
> Thread functions should look like the following:
> 
> int thread_fn(void *cookie)
> {
> 	while (!smpboot_thread_check_parking(cookie)) {
> 		do_stuff();
> 	}
> 	return 0;
> }
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

[ . . . ]

> Index: tip/kernel/cpu.c
> ===================================================================
> --- tip.orig/kernel/cpu.c
> +++ tip/kernel/cpu.c
> @@ -280,6 +280,7 @@ static int __ref _cpu_down(unsigned int 
>  				__func__, cpu);
>  		goto out_release;
>  	}
> +	smpboot_park_threads(cpu);
> 
>  	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
>  	if (err) {
> @@ -354,6 +355,10 @@ static int __cpuinit _cpu_up(unsigned in
>  		goto out;
>  	}
> 
> +	ret = smpboot_create_threads(cpu);
> +	if (ret)
> +		goto out;
> +
>  	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
>  	if (ret) {
>  		nr_calls--;
> @@ -370,6 +375,7 @@ static int __cpuinit _cpu_up(unsigned in
> 
>  	/* Now call notifier in preparation. */
>  	cpu_notify(CPU_ONLINE | mod, hcpu);
> +	smpboot_unpark_threads(cpu);

OK, RCU must use the lower-level interfaces, given that one of
then CPU_ONLINE notifiers might invoke synchronize_rcu().

							Thanx, Paul

