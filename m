Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab1COR6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 13:58:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49814 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758228Ab1COR63 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 13:58:29 -0400
Subject: Re: [PATCH v2 2.6.38-rc8-tip 7/20]  7: uprobes: store/restore
 original instruction.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Stephen Wilson <wilsons@start.ca>, Ingo Molnar <mingo@elte.hu>,
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
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20110315092247.GW24254@linux.vnet.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
	 <20110314133522.27435.45121.sendpatchset@localhost6.localdomain6>
	 <20110314180914.GA18855@fibrous.localdomain>
	 <20110315092247.GW24254@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 Mar 2011 18:57:42 +0100
Message-ID: <1300211862.2203.302.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 14:52 +0530, Srikar Dronamraju wrote:
> * Stephen Wilson <wilsons@start.ca> [2011-03-14 14:09:14]:
> 
> > On Mon, Mar 14, 2011 at 07:05:22PM +0530, Srikar Dronamraju wrote:
> > >  static int install_uprobe(struct mm_struct *mm, struct uprobe *uprobe)
> > >  {
> > > -	int ret = 0;
> > > +	struct task_struct *tsk;
> > > +	int ret = -EINVAL;
> > >  
> > > -	/*TODO: install breakpoint */
> > > -	if (!ret)
> > > +	get_task_struct(mm->owner);
> > > +	tsk = mm->owner;
> > > +	if (!tsk)
> > > +		return ret;
> > 
> > I think you need to check that tsk != NULL before calling
> > get_task_struct()...
> > 
> 
> Guess checking for tsk != NULL would only help if and only if we are doing
> within rcu.  i.e we have to change to something like this
> 
> 	rcu_read_lock()
> 	if (mm->owner) {
> 		get_task_struct(mm->owner)
> 		tsk = mm->owner;
> 	}
> 	rcu_read_unlock()
> 	if (!tsk)
> 		return ret;

so the whole mm->owner semantics seem vague, memcontrol.c doesn't seem
consistent in itself, one site uses rcu_dereference() the other site
doesn't.

Also, the assignments in kernel/fork.c and kernel/exit.c don't use
rcu_assign_pointer() and therefore lack the needed write barrier.

Git blames Balbir for this.
