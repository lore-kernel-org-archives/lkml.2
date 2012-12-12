Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab2LLVMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:12:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab2LLVMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:12:42 -0500
Date: Wed, 12 Dec 2012 22:10:52 +0100
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
Message-ID: <20121212211052.GA31735@redhat.com>
References: <20121211140314.23621.64088.stgit@srivatsabhat.in.ibm.com> <20121211140358.23621.97011.stgit@srivatsabhat.in.ibm.com> <20121212171720.GA22289@redhat.com> <50C8C4A5.4080104@linux.vnet.ibm.com> <20121212180248.GA24882@redhat.com> <20121212193646.GA29395@redhat.com> <50C8DE7B.8080708@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C8DE7B.8080708@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13, Srivatsa S. Bhat wrote:
>
> On 12/13/2012 01:06 AM, Oleg Nesterov wrote:
> >
> > But perhaps there is another reason to make it per-cpu...

Actually this is not the reason, please see below. But let me repeat,
it is not that I suggest to remove "per-cpu".

> > It seems we can avoid cpu_hotplug.active_writer == current check in
> > get/put.
> >
> > take_cpu_down() can clear this_cpu(writer_signal) right after it takes
> > hotplug_rwlock for writing. It runs with irqs and preemption disabled,
> > nobody else will ever look at writer_signal on its CPU.
> >
>
> Hmm.. And then the get/put_ on that CPU will increment/decrement the per-cpu
> refcount, but we don't care.. because we only need to ensure that they don't
> deadlock by taking the rwlock for read.

Yes, but...

Probably it would be more clean to simply do this_cpu_inc(reader_percpu_refcnt)
after write_lock(hotplug_rwlock). This will have the same effect for get/put,
and we still can make writer_signal global (if we want).

And note that this will also simplify the lockdep annotations which we (imho)
should add later.

Ignoring all complications get_online_cpus_atomic() does:

	if (this_cpu_read(reader_percpu_refcnt))
		this_cpu_inc(reader_percpu_refcnt);
	else if (!writer_signal)
		this_cpu_inc(reader_percpu_refcnt);	// same as above
	else
		read_lock(&hotplug_rwlock);

But for lockdep it should do:

	if (this_cpu_read(reader_percpu_refcnt))
		this_cpu_inc(reader_percpu_refcnt);
	else if (!writer_signal) {
		this_cpu_inc(reader_percpu_refcnt);
		// pretend we take hotplug_rwlock for lockdep
		rwlock_acquire_read(&hotplug_rwlock.dep_map, 0, 0);
	}
	else
		read_lock(&hotplug_rwlock);

And we need to ensure that rwlock_acquire_read() is not called under
write_lock(hotplug_rwlock).

If we use reader_percpu_refcnt to fool get/put, we should not worry.

Oleg.

