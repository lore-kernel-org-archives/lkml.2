Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab2E2RFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 13:05:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:59150 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab2E2RFQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 13:05:16 -0400
Message-ID: <1338311091.26856.146.camel@twins>
Subject: Re: [PATCH 08/35] autonuma: introduce kthread_bind_node()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Date: Tue, 29 May 2012 19:04:51 +0200
In-Reply-To: <20120529161157.GE21339@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
	 <1337965359-29725-9-git-send-email-aarcange@redhat.com>
	 <1338295753.26856.60.camel@twins> <20120529161157.GE21339@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 18:11 +0200, Andrea Arcangeli wrote:
> On Tue, May 29, 2012 at 02:49:13PM +0200, Peter Zijlstra wrote:
> > On Fri, 2012-05-25 at 19:02 +0200, Andrea Arcangeli wrote:
> > >  /**
> > > + * kthread_bind_node - bind a just-created kthread to the CPUs of a node.
> > > + * @p: thread created by kthread_create().
> > > + * @nid: node (might not be online, must be possible) for @k to run on.
> > > + *
> > > + * Description: This function is equivalent to set_cpus_allowed(),
> > > + * except that @nid doesn't need to be online, and the thread must be
> > > + * stopped (i.e., just returned from kthread_create()).
> > > + */
> > > +void kthread_bind_node(struct task_struct *p, int nid)
> > > +{
> > > +       /* Must have done schedule() in kthread() before we set_task_cpu */
> > > +       if (!wait_task_inactive(p, TASK_UNINTERRUPTIBLE)) {
> > > +               WARN_ON(1);
> > > +               return;
> > > +       }
> > > +
> > > +       /* It's safe because the task is inactive. */
> > > +       do_set_cpus_allowed(p, cpumask_of_node(nid));
> > > +       p->flags |= PF_THREAD_BOUND;
> > 
> > No, I've said before, this is wrong. You should only ever use
> > PF_THREAD_BOUND when its strictly per-cpu. Moving the your numa threads
> > to a different node is silly but not fatal in any way.
> 
> I changed the semantics of that bitflag, now it means: userland isn't
> allowed to shoot itself in the foot and mess with whatever CPU
> bindings the kernel has set for the kernel thread.

Yeah, and you did so without mentioning that in your changelog.
Furthermore I object to that change. I object even more strongly to
doing it without mention and keeping a misleading comment near the
definition.

> It'd be a clear regress not to set PF_THREAD_BOUND there. It would be
> even worse to remove the CPU binding to the node: it'd risk to copy
> memory with both src and dst being in remote nodes from the CPU where
> knuma_migrate runs on (there aren't just 2 node systems out there).

Just teach each knuma_migrated what node it represents and don't use
numa_node_id().

That way you can change the affinity just fine, it'll be sub-optimal,
copying memory from node x to node y through node z, but it'll still
work correctly.

numa isn't special in the way per-cpu stuff is special.
