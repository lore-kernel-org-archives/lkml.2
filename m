Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab2LDWRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 17:17:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab2LDWRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 17:17:08 -0500
Date: Tue, 4 Dec 2012 14:17:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, namhyung@kernel.org,
        vincent.guittot@linaro.org, sbw@mit.edu, tj@kernel.org,
        amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 02/10] smp, cpu hotplug: Fix smp_call_function_*()
 to prevent CPU offline properly
Message-Id: <20121204141707.b792e488.akpm@linux-foundation.org>
In-Reply-To: <20121204085419.25919.79543.stgit@srivatsabhat.in.ibm.com>
References: <20121204085149.25919.29920.stgit@srivatsabhat.in.ibm.com>
	<20121204085419.25919.79543.stgit@srivatsabhat.in.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Dec 2012 14:24:28 +0530
"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:

> From: Michael Wang <wangyun@linux.vnet.ibm.com>
> 
> With stop_machine() gone from the CPU offline path, we can't depend on
> preempt_disable() to prevent CPUs from going offline from under us.
> 
> Use the get/put_online_cpus_stable_atomic() APIs to prevent CPUs from going
> offline, while invoking from atomic context.
>
> ...
>
>  	 */
> -	this_cpu = get_cpu();
> +	get_online_cpus_stable_atomic();
> +	this_cpu = smp_processor_id();

I wonder if get_online_cpus_stable_atomic() should return the local CPU
ID.  Just as a little convenience thing.  Time will tell.
 
>  	/*
>  	 * Can deadlock when called with interrupts disabled.
>
> ...
>
> @@ -380,15 +383,15 @@ int smp_call_function_any(const struct cpumask *mask,
>  	nodemask = cpumask_of_node(cpu_to_node(cpu));
>  	for (cpu = cpumask_first_and(nodemask, mask); cpu < nr_cpu_ids;
>  	     cpu = cpumask_next_and(cpu, nodemask, mask)) {
> -		if (cpu_online(cpu))
> +		if (cpu_online_stable(cpu))
>  			goto call;
>  	}
>  
>  	/* Any online will do: smp_call_function_single handles nr_cpu_ids. */
> -	cpu = cpumask_any_and(mask, cpu_online_mask);
> +	cpu = cpumask_any_and(mask, cpu_online_stable_mask);
>  call:
>  	ret = smp_call_function_single(cpu, func, info, wait);
> -	put_cpu();
> +	put_online_cpus_stable_atomic();
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(smp_call_function_any);

So smp_call_function_any() has no synchronization against CPUs coming
online.  Hence callers of smp_call_function_any() are responsible for
ensuring that CPUs which are concurrently coming online will adopt the
required state?

I guess that has always been the case...


>
> ...
>

