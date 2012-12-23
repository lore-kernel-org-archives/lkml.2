Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab2LWQnI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 11:43:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab2LWQnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 11:43:07 -0500
Date: Sun, 23 Dec 2012 17:42:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/9] CPU hotplug: Provide APIs to prevent CPU
	offline from atomic context
Message-ID: <20121223164242.GA9979@redhat.com>
References: <20121212184849.GA26784@redhat.com> <50C8D739.6030903@linux.vnet.ibm.com> <50C9F38F.3020005@linux.vnet.ibm.com> <50D0CCB3.10105@linux.vnet.ibm.com> <20121219163900.GA18516@redhat.com> <50D2047A.1040606@linux.vnet.ibm.com> <20121219191436.GA25829@redhat.com> <50D21A5F.4040604@linux.vnet.ibm.com> <20121220134203.GB10813@redhat.com> <50D61561.7090805@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D61561.7090805@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23, Srivatsa S. Bhat wrote:
>
> On 12/20/2012 07:12 PM, Oleg Nesterov wrote:
> >
> > We need mb() + rmb(). Plust cli/sti unless this arch has optimized
> > this_cpu_add() like x86 (as you pointed out).
> >
>
> Hey, IIUC, we actually don't need mb() in the reader!! Just an rmb() will do.

Well. I don't think so. But when it comes to the barriers I am never sure
until Paul confirms my understanding ;)

> #define reader_nested_percpu()						\
> 	     (__this_cpu_read(reader_percpu_refcnt) & READER_REFCNT_MASK)
>
> #define writer_active()							\
> 				(__this_cpu_read(writer_signal))
>
>
> #define READER_PRESENT		(1UL << 16)
> #define READER_REFCNT_MASK	(READER_PRESENT - 1)
>
> void get_online_cpus_atomic(void)
> {
> 	preempt_disable();
>
> 	/*
> 	 * First and foremost, make your presence known to the writer.
> 	 */
> 	this_cpu_add(reader_percpu_refcnt, READER_PRESENT);
>
> 	/*
> 	 * If we are already using per-cpu refcounts, it is not safe to switch
> 	 * the synchronization scheme. So continue using the refcounts.
> 	 */
> 	if (reader_nested_percpu()) {
> 		this_cpu_inc(reader_percpu_refcnt);
> 	} else {
> 		smp_rmb();
> 		if (unlikely(writer_active())) {
> 			... //take hotplug_rwlock
> 		}
> 	}
>
> 	...
>
> 	/* Prevent reordering of any subsequent reads of cpu_online_mask. */
> 	smp_rmb();
> }
>
> The smp_rmb() before writer_active() ensures that LOAD(writer_signal) follows
> LOAD(reader_percpu_refcnt) (at the 'if' condition). And in turn, that load is
> automatically going to follow the STORE(reader_percpu_refcnt)

But why this STORE should be visible on another CPU before we LOAD(writer_signal)?

Lets discuss the simple and artificial example. Suppose we have

	int X, Y;

	int func(void)
	{
		X = 1;	// suppose that nobody else can change it
		mb();
		return Y;
	}

Now you are saying that we can change it and avoid the costly mb():

	int func(void)
	{
		X = 1;

		if (X != 1)
			BUG();
	
		rmb();
		return Y;
	}

I doubt. rmb() can only guarantee that the preceding LOAD's should be
completed. Without mb() it is possible that this CPU won't write X to
memory at all.

Oleg.

