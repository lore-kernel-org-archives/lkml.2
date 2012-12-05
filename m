Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab2LES1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 13:27:44 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50127 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab2LES1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 13:27:42 -0500
Date: Wed, 5 Dec 2012 10:27:35 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, tglx@linutronix.de,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, sbw@mit.edu,
        amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 01/10] CPU hotplug: Provide APIs for "light"
 atomic readers to prevent CPU offline
Message-ID: <20121205182735.GM3885@mtj.dyndns.org>
References: <20121205131038.17383.55472.stgit@srivatsabhat.in.ibm.com>
 <20121205131136.17383.23318.stgit@srivatsabhat.in.ibm.com>
 <20121205142316.GI3885@mtj.dyndns.org>
 <20121205164640.GA7382@redhat.com>
 <20121205165356.GL3885@mtj.dyndns.org>
 <20121205181524.GA9401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121205181524.GA9401@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Wed, Dec 05, 2012 at 07:15:24PM +0100, Oleg Nesterov wrote:
> On 12/05, Tejun Heo wrote:
> > Replacing get_online_cpus() w/ percpu_rwsem is great but this thread
> > is about replacing preempt_disable with something finer grained and
> > less heavy on the writer side
> 
> If only I understood why preempt_disable() is bad ;)
> 
> OK, I guess "less heavy on the writer side" is the hint, and in the
> previous email you mentioned that "stop_machine() itself is extremely
> heavy".
> 
> Looks like, you are going to remove stop_machine() from cpu_down ???

Yeah, that's what Srivatsa is trying to do.  The problem seems to be
that cpu up/down is very frequent on certain mobile platforms for
power management and as currently implemented cpu hotplug is too heavy
and latency-inducing.

> > The problem seems that we don't have percpu_rwlock yet.  It shouldn't
> > be too difficult to implement, right?
> 
> Oh, I am not sure... unless you simply copy-and-paste the lglock code
> and replace spinlock_t with rwlock_t.

Ah... right, so that's where brlock ended up.  So, lglock is the new
thing and brlock is a wrapper around it.

> We probably want something more efficient, but I bet we can't avoid
> the barriers on the read side.
> 
> And somehow we should avoid the livelocks. Say, we can't simply add
> the per_cpu_reader_counter, _read_lock should spin if the writer is
> active. But at the same time _read_lock should be recursive.

I think we should just go with lglock.  It does involve local atomic
ops but atomic ops themselves aren't that expensive and it's not like
we can avoid memory barriers.  Also, that's the non-sleeping
counterpart of percpu_rwsem.  If it's not good enough for some reason,
we should improve it rather than introducing something else.

Thanks.

-- 
tejun
