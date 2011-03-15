Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab1COJ3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:29:10 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49941 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab1COJ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:29:04 -0400
Date: Tue, 15 Mar 2011 14:52:47 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Stephen Wilson <wilsons@start.ca>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20110315092247.GW24254@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
 <20110314133522.27435.45121.sendpatchset@localhost6.localdomain6>
 <20110314180914.GA18855@fibrous.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110314180914.GA18855@fibrous.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Wilson <wilsons@start.ca> [2011-03-14 14:09:14]:

> On Mon, Mar 14, 2011 at 07:05:22PM +0530, Srikar Dronamraju wrote:
> >  static int install_uprobe(struct mm_struct *mm, struct uprobe *uprobe)
> >  {
> > -	int ret = 0;
> > +	struct task_struct *tsk;
> > +	int ret = -EINVAL;
> >  
> > -	/*TODO: install breakpoint */
> > -	if (!ret)
> > +	get_task_struct(mm->owner);
> > +	tsk = mm->owner;
> > +	if (!tsk)
> > +		return ret;
> 
> I think you need to check that tsk != NULL before calling
> get_task_struct()...
> 

Guess checking for tsk != NULL would only help if and only if we are doing
within rcu.  i.e we have to change to something like this

	rcu_read_lock()
	if (mm->owner) {
		get_task_struct(mm->owner)
		tsk = mm->owner;
	}
	rcu_read_unlock()
	if (!tsk)
		return ret;

Agree?

