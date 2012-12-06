Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424368Ab2LFQTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:19:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423988Ab2LFQTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:19:38 -0500
Date: Thu, 6 Dec 2012 17:18:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tj@kernel.org, tglx@linutronix.de, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org,
        vincent.guittot@linaro.org, sbw@mit.edu, amit.kucheria@linaro.org,
        rostedt@goodmis.org, rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 01/10] CPU hotplug: Provide APIs for "light"
	atomic readers to prevent CPU offline
Message-ID: <20121206161850.GA6710@redhat.com>
References: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com> <20121205184258.3750.31879.stgit@srivatsabhat.in.ibm.com> <50BF96DF.3000500@linux.vnet.ibm.com> <50BF979A.50304@linux.vnet.ibm.com> <50BF982D.7090704@linux.vnet.ibm.com> <50BF98F7.3030600@linux.vnet.ibm.com> <50BF999C.6030707@linux.vnet.ibm.com> <50BFAB17.3090603@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50BFAB17.3090603@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06, Srivatsa S. Bhat wrote:
>
> +void get_online_cpus_atomic(void)
> +{
> +	int c, old;
> +
> +	preempt_disable();
> +	read_lock(&hotplug_rwlock);

Confused... Why it also takes hotplug_rwlock?

> +
> +	for (;;) {
> +		c = atomic_read(&__get_cpu_var(atomic_reader_refcount));
> +		if (unlikely(writer_active(c))) {
> +			cpu_relax();
> +			continue;
> +		}
> +
> +		old = atomic_cmpxchg(&__get_cpu_var(atomic_reader_refcount),
> +				     c, c + 1);
> +
> +		if (likely(old == c))
> +			break;
> +
> +		c = old;
> +	}
> +}

	while (!atomic_inc_unless_negative(...))
		cpu_relax();
	
and atomic_dec_unless_positive() in disable_atomic_reader().


Obviously you can't use get_online_cpus_atomic() under rq->lock or
task->pi_lock or any other lock CPU_DYING can take. Probably this is
fine, but perhaps it makes sense to add the lockdep annotations.

Oleg.

