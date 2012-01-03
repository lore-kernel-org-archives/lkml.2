Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab2ACWeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:34:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab2ACWeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:34:18 -0500
Date: Tue, 3 Jan 2012 14:34:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH v5 4/8] smp: Add func to IPI cpus based on parameter
 func
Message-Id: <20120103143417.7cbea589.akpm@linux-foundation.org>
In-Reply-To: <1325499859-2262-5-git-send-email-gilad@benyossef.com>
References: <1325499859-2262-1-git-send-email-gilad@benyossef.com>
	<1325499859-2262-5-git-send-email-gilad@benyossef.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Jan 2012 12:24:15 +0200
Gilad Ben-Yossef <gilad@benyossef.com> wrote:

> Add the on_each_cpu_required() function that wraps on_each_cpu_mask()
> and calculates the cpumask of cpus to IPI by calling a function supplied
> as a parameter in order to determine whether to IPI each specific cpu.

The name is actually "on_each_cpu_cond".

> The function deals with allocation failure of cpumask variable in
> CONFIG_CPUMASK_OFFSTACK=y by sending IPI to all cpus via on_each_cpu()
> instead.

This seems rather dangerous.  Poeple will test and ship code which has
always called only the targetted CPUs.  Later, real live users will get
the occasional memory exhaustion and will end up calling the callback
function on CPUs which aren't supposed to be used.  So users end up
running untested code.  And it's code which could quite easily explode,
because inattentive programmers could fall into assuming that the
function is not called on incorrect CPUs.  I think this is easy to fix
(see below).

> The function is useful since it allows to seperate the specific
> code that decided in each case whether to IPI a specific cpu for
> a specific request from the common boilerplate code of handling
> creating the mask, handling failures etc.
> 
>
> ...
>
> @@ -147,6 +155,14 @@ static inline int up_smp_call_function(smp_call_func_t func, void *info)
>  			local_irq_enable();		\
>  		}					\
>  	} while (0)
> +#define on_each_cpu_cond(cond_func, func, info, wait) \
> +	do {						\
> +		if (cond_func(0, info)) {		\

I suppose this is reasonable.  It's likely that on UP, cond_func() will
always return true but perhaps for some reason it won't.  hmmm...

> +			local_irq_disable();		\
> +			(func)(info);			\
> +			local_irq_enable();		\
> +		}					\
> +	} while (0)
>  
>  static inline void smp_send_reschedule(int cpu) { }
>  #define num_booting_cpus()			1
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 7c0cbd7..5f7b24e 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -721,3 +721,30 @@ void on_each_cpu_mask(const struct cpumask *mask, void (*func)(void *),
>  	put_cpu();
>  }
>  EXPORT_SYMBOL(on_each_cpu_mask);
> +
> +/*
> + * Call a function on each processor for which the supplied function
> + * cond_func returns a positive value. This may include the local
> + * processor, optionally waiting for all the required CPUs to finish.
> + * The function may be called on all online CPUs without running the
> + * cond_func function in extreme circumstance (memory allocation
> + * failure condition when CONFIG_CPUMASK_OFFSTACK=y)
> + * All the limitations specified in smp_call_function_many apply.
> + */
> +void on_each_cpu_cond(int (*cond_func) (int cpu, void *info),
> +			void (*func)(void *), void *info, bool wait)
> +{
> +	cpumask_var_t cpus;
> +	int cpu;
> +
> +	if (likely(zalloc_cpumask_var(&cpus, GFP_ATOMIC))) {
> +		for_each_online_cpu(cpu)
> +			if (cond_func(cpu, info))
> +				cpumask_set_cpu(cpu, cpus);
> +		on_each_cpu_mask(cpus, func, info, wait);
> +		free_cpumask_var(cpus);
> +	} else
> +		on_each_cpu(func, info, wait);
> +}
> +EXPORT_SYMBOL(on_each_cpu_cond);

If zalloc_cpumask_var() fails, can we not fall back to

		for_each_online_cpu(cpu)
			if (cond_func(cpu, info))
				smp_call_function_single(...);

