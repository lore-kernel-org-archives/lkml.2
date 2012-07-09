Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab2GIM0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:26:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:48243 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2GIM0q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:26:46 -0400
Message-ID: <1341836787.3462.64.camel@twins>
Subject: Re: [RFC][PATCH 25/26] sched, numa: Only migrate long-running
 entities
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Mon, 09 Jul 2012 14:26:27 +0200
In-Reply-To: <4FF9D29D.8030903@redhat.com>
References: <20120316144028.036474157@chello.nl>
	 <20120316144241.749359061@chello.nl> <4FF9D29D.8030903@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-08 at 14:34 -0400, Rik van Riel wrote:
> On 03/16/2012 10:40 AM, Peter Zijlstra wrote:
> 
> > +static u64 process_cpu_runtime(struct numa_entity *ne)
> > +{
> > +	struct task_struct *p, *t;
> > +	u64 runtime = 0;
> > +
> > +	rcu_read_lock();
> > +	t = p = ne_owner(ne);
> > +	if (p) do {
> > +		runtime += t->se.sum_exec_runtime; // @#$#@ 32bit
> > +	} while ((t = next_thread(t)) != p);
> > +	rcu_read_unlock();
> > +
> > +	return runtime;
> > +}
> 
> > +	/*
> > +	 * Don't bother migrating memory if there's less than 1 second
> > +	 * of runtime on the tasks.
> > +	 */
> > +	if (ne->nops->cpu_runtime(ne) < NSEC_PER_SEC)
> > +		return false;
> 
> Do we really want to calculate the amount of CPU time used
> by a process, and start migrating after just one second?
> 
> Or would it be ok to start migrating once a process has
> been scanned once or twice by the NUMA code?

You mean, the 2-3rd time we try and migrate this task, not the memory
scanning thing as per Andrea, right?

Yeah, that might work too.. 
