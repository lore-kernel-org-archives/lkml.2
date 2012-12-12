Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab2LLSsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:48:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab2LLSss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:48:48 -0500
Date: Wed, 12 Dec 2012 19:48:49 +0100
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
Message-ID: <20121212184849.GA26784@redhat.com>
References: <20121211140314.23621.64088.stgit@srivatsabhat.in.ibm.com> <20121211140358.23621.97011.stgit@srivatsabhat.in.ibm.com> <20121212171720.GA22289@redhat.com> <50C8C4A5.4080104@linux.vnet.ibm.com> <20121212180248.GA24882@redhat.com> <50C8CD52.8040808@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C8CD52.8040808@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13, Srivatsa S. Bhat wrote:
>
> On 12/12/2012 11:32 PM, Oleg Nesterov wrote:
> > And _perhaps_ get_ can avoid it too?
> >
> > I didn't really try to think, probably this is not right, but can't
> > something like this work?
> >
> > 	#define XXXX	(1 << 16)
> > 	#define MASK	(XXXX -1)
> >
> > 	void get_online_cpus_atomic(void)
> > 	{
> > 		preempt_disable();
> >
> > 		// only for writer
> > 		__this_cpu_add(reader_percpu_refcnt, XXXX);
> >
> > 		if (__this_cpu_read(reader_percpu_refcnt) & MASK) {
> > 			__this_cpu_inc(reader_percpu_refcnt);
> > 		} else {
> > 			smp_wmb();
> > 			if (writer_active()) {
> > 				...
> > 			}
> > 		}
> >
> > 		__this_cpu_dec(reader_percpu_refcnt, XXXX);
> > 	}
> >
>
> Sorry, may be I'm too blind to see, but I didn't understand the logic
> of how the mask helps us avoid disabling interrupts..

Why do we need cli/sti at all? We should prevent the following race:

	- the writer already holds hotplug_rwlock, so get_ must not
	  succeed.

	- the new reader comes, it increments reader_percpu_refcnt,
	  but before it checks writer_active() ...

	- irq handler does get_online_cpus_atomic() and sees
	  reader_nested_percpu() == T, so it simply increments
	  reader_percpu_refcnt and succeeds.

OTOH, why do we need to increment reader_percpu_refcnt the counter
in advance? To ensure that either we see writer_active() or the
writer should see reader_percpu_refcnt != 0 (and that is why they
should write/read in reverse order).

The code above tries to avoid this race using the lower 16 bits
as a "nested-counter", and the upper bits to avoid the race with
the writer.

	// only for writer
	__this_cpu_add(reader_percpu_refcnt, XXXX);

If irq comes and does get_online_cpus_atomic(), it won't be confused
by __this_cpu_add(XXXX), it will check the lower bits and switch to
the "slow path".


But once again, so far I didn't really try to think. It is quite
possible I missed something.

Oleg.

