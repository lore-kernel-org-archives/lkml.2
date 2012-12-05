Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab2LESPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 13:15:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab2LESPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 13:15:47 -0500
Date: Wed, 5 Dec 2012 19:15:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, tglx@linutronix.de,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, sbw@mit.edu,
        amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 01/10] CPU hotplug: Provide APIs for "light"
	atomic readers to prevent CPU offline
Message-ID: <20121205181524.GA9401@redhat.com>
References: <20121205131038.17383.55472.stgit@srivatsabhat.in.ibm.com> <20121205131136.17383.23318.stgit@srivatsabhat.in.ibm.com> <20121205142316.GI3885@mtj.dyndns.org> <20121205164640.GA7382@redhat.com> <20121205165356.GL3885@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121205165356.GL3885@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add lkml)

On 12/05, Tejun Heo wrote:
>
> Replacing get_online_cpus() w/ percpu_rwsem is great but this thread
> is about replacing preempt_disable with something finer grained and
> less heavy on the writer side

If only I understood why preempt_disable() is bad ;)

OK, I guess "less heavy on the writer side" is the hint, and in the
previous email you mentioned that "stop_machine() itself is extremely
heavy".

Looks like, you are going to remove stop_machine() from cpu_down ???

> The problem seems that we don't have percpu_rwlock yet.  It shouldn't
> be too difficult to implement, right?

Oh, I am not sure... unless you simply copy-and-paste the lglock code
and replace spinlock_t with rwlock_t.

We probably want something more efficient, but I bet we can't avoid
the barriers on the read side.

And somehow we should avoid the livelocks. Say, we can't simply add
the per_cpu_reader_counter, _read_lock should spin if the writer is
active. But at the same time _read_lock should be recursive.

Tejun, could you please send me mbox with this thread offlist?

Oleg.

