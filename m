Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab2FNIdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:33:00 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:52769 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab2FNIc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:32:56 -0400
Message-ID: <4FD9A176.7080806@linux.vnet.ibm.com>
Date: Thu, 14 Jun 2012 14:01:50 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu hotplug
 threads
References: <20120613102823.373180763@linutronix.de> <20120613105815.206105518@linutronix.de>
In-Reply-To: <20120613105815.206105518@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12061322-5140-0000-0000-00000193047F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2012 04:30 PM, Thomas Gleixner wrote:

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


This patchset looks great! But I have some comments below:

 
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


If cpu_down fails further down, don't we want to unpark these threads
as part of error recovery?

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


Here also, we might want to clean up on error right?

>  	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
>  	if (ret) {
>  		nr_calls--;
> @@ -370,6 +375,7 @@ static int __cpuinit _cpu_up(unsigned in
> 
>  	/* Now call notifier in preparation. */
>  	cpu_notify(CPU_ONLINE | mod, hcpu);
> +	smpboot_unpark_threads(cpu);
> 
>  out_notify:
>  	if (ret != 0)



Regards,
Srivatsa S. Bhat

