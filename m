Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab1G1HBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 03:01:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:56897 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab1G1HBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 03:01:30 -0400
Date: Thu, 28 Jul 2011 09:01:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yong Zhang <yong.zhang0@gmail.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Carsten Emde <ce@ceag.ch>,
        Clark Williams <williams@redhat.com>,
        Kumar Gala <galak@gate.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, rostedt <rostedt@goodmis.org>,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: On migrate_disable() and latencies
In-Reply-To: <20110728055043.GA570@windriver.com>
Message-ID: <alpine.LFD.2.02.1107280855220.2660@ionos>
References: <1311329992.27400.23.camel@twins> <20110723003934.GP2382@linux.vnet.ibm.com> <1311582653.2617.49.camel@laptop> <20110725211706.GT2327@linux.vnet.ibm.com> <1311765198.24752.437.camel@twins> <20110727183008.GA2407@linux.vnet.ibm.com>
 <20110728055043.GA570@windriver.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jul 2011, Yong Zhang wrote:

> On Wed, Jul 27, 2011 at 11:30:08AM -0700, Paul E. McKenney wrote:
> > o	Tasks awakening outside of migrate-disable regions will pick
> > 	the CPU running the lowest-priority task, whether or not this
> > 	task is in migrate-disable state.  (At least I don't see
> > 	anything in 3.0-rt3 that looks like a scheduling decision
> > 	based on ->migrate_disable, perhaps due to blindness.)
> 
> I'm also confused here, seems we just disable migration for RT task.
> migrate_disable()
> {
> 	...
> 		if (p->sched_class->set_cpus_allowed)
> 			p->sched_class->set_cpus_allowed(p, mask);
> 		p->rt.nr_cpus_allowed =	cpumask_weight(mask);
> 	...
> }
> 
> Shouldn't we also forbid migration on !RT task?

We do. Just RT is the only sched class which has a set_cpus_allowed()
callback implemented and want's an update to its rt.nr_cpus_allowed
field.

       if (!p->migrate_disable) {
                if (p->sched_class && p->sched_class->set_cpus_allowed)
                        p->sched_class->set_cpus_allowed(p, new_mask);
                p->rt.nr_cpus_allowed = cpumask_weight(new_mask);
        }

The general part is here:

       cpumask_copy(&p->cpus_allowed, new_mask);

And tsk_cpus_allowed() does:
{
        if (p->migrate_disable)
                return cpumask_of(task_cpu(p));

        return &p->cpus_allowed;
}

which is the relevant information to keep any task independent of it's
sched class pinned.

Thanks,

	tglx
