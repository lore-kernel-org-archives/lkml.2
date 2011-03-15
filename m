Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347Ab1COS6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 14:58:52 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:41693 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab1COS6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 14:58:50 -0400
Date: Wed, 16 Mar 2011 00:28:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 7/20]  7: uprobes: store/restore
 original instruction.
Message-ID: <20110315185841.GH3410@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
 <20110314133522.27435.45121.sendpatchset@localhost6.localdomain6>
 <20110314180914.GA18855@fibrous.localdomain>
 <20110315092247.GW24254@linux.vnet.ibm.com>
 <1300211862.2203.302.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1300211862.2203.302.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-03-15 18:57:42]:

> On Tue, 2011-03-15 at 14:52 +0530, Srikar Dronamraju wrote:
> > * Stephen Wilson <wilsons@start.ca> [2011-03-14 14:09:14]:
> > 
> > > On Mon, Mar 14, 2011 at 07:05:22PM +0530, Srikar Dronamraju wrote:
> > > >  static int install_uprobe(struct mm_struct *mm, struct uprobe *uprobe)
> > > >  {
> > > > -	int ret = 0;
> > > > +	struct task_struct *tsk;
> > > > +	int ret = -EINVAL;
> > > >  
> > > > -	/*TODO: install breakpoint */
> > > > -	if (!ret)
> > > > +	get_task_struct(mm->owner);
> > > > +	tsk = mm->owner;
> > > > +	if (!tsk)
> > > > +		return ret;
> > > 
> > > I think you need to check that tsk != NULL before calling
> > > get_task_struct()...
> > > 
> > 
> > Guess checking for tsk != NULL would only help if and only if we are doing
> > within rcu.  i.e we have to change to something like this
> > 
> > 	rcu_read_lock()
> > 	if (mm->owner) {
> > 		get_task_struct(mm->owner)
> > 		tsk = mm->owner;
> > 	}
> > 	rcu_read_unlock()
> > 	if (!tsk)
> > 		return ret;
> 
> so the whole mm->owner semantics seem vague, memcontrol.c doesn't seem
> consistent in itself, one site uses rcu_dereference() the other site
> doesn't.
> 

mm->owner should be under rcu_read_lock, unless the task is exiting
and mm_count is 1. mm->owner is updated under task_lock().

> Also, the assignments in kernel/fork.c and kernel/exit.c don't use
> rcu_assign_pointer() and therefore lack the needed write barrier.
>

Those are paths when the only context using the mm->owner is single
 
> Git blames Balbir for this.

I accept the blame and am willing to fix anything incorrect found in
the code.


-- 
	Three Cheers,
	Balbir
