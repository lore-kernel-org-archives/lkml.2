Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab1BWPMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:12:23 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46897 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab1BWPMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:12:22 -0500
Date: Wed, 23 Feb 2011 07:12:07 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
Message-ID: <20110223151207.GG2163@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110223013917.GA20996@linux.vnet.ibm.com>
 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110223030940.GB5809@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223030940.GB5809@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 04:09:43AM +0100, Frederic Weisbecker wrote:
> On Tue, Feb 22, 2011 at 05:39:40PM -0800, Paul E. McKenney wrote:
> > +/*
> > + * Set the per-rcu_node kthread's affinity to cover all CPUs that are
> > + * served by the rcu_node in question.
> > + */
> > +static void rcu_node_kthread_setaffinity(struct rcu_node *rnp)
> > +{
> > +	cpumask_var_t cm;
> > +	int cpu;
> > +	unsigned long mask = rnp->qsmaskinit;
> > +
> > +	if (rnp->node_kthread_task == NULL ||
> > +	    rnp->qsmaskinit == 0)
> > +		return;
> > +	if (!alloc_cpumask_var(&cm, GFP_KERNEL))
> > +		return;
> > +	cpumask_clear(cm);
> > +	for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask <<= 1)
> 
> There seem to be the same shift problem here.

Right you are, thank you again!!!

							Thanx, Paul

> > +		if (mask & 01)
> > +			cpumask_set_cpu(cpu, cm);
> > +	set_cpus_allowed_ptr(rnp->node_kthread_task, cm);
> > +	free_cpumask_var(cm);
> > +}
