Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab1FPKCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 06:02:21 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50174 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756991Ab1FPKCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 06:02:19 -0400
Date: Thu, 16 Jun 2011 15:24:12 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 4/22]  4: Uprobes: register/unregister
 probes.
Message-ID: <20110616095412.GK4952@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607125900.28590.16071.sendpatchset@localhost6.localdomain6>
 <1308159719.2171.57.camel@laptop>
 <20110616041137.GG4952@linux.vnet.ibm.com>
 <1308217582.15315.94.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1308217582.15315.94.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-06-16 11:46:22]:

> On Thu, 2011-06-16 at 09:41 +0530, Srikar Dronamraju wrote:
> > * Peter Zijlstra <peterz@infradead.org> [2011-06-15 19:41:59]:
> > 
> > > On Tue, 2011-06-07 at 18:29 +0530, Srikar Dronamraju wrote:
> > > > 1. Use mm->owner and walk thro the thread_group of mm->owner, siblings
> > > > of mm->owner, siblings of parent of mm->owner.  This should be
> > > > good list to traverse. Not sure if this is an exhaustive
> > > > enough list that all tasks that have a mm set to this mm_struct are
> > > > walked through. 
> > > 
> > > As per copy_process():
> > > 
> > > 	/*
> > > 	 * Thread groups must share signals as well, and detached threads
> > > 	 * can only be started up within the thread group.
> > > 	 */
> > > 	if ((clone_flags & CLONE_THREAD) && !(clone_flags & CLONE_SIGHAND))
> > > 		return ERR_PTR(-EINVAL);
> > > 
> > > 	/*
> > > 	 * Shared signal handlers imply shared VM. By way of the above,
> > > 	 * thread groups also imply shared VM. Blocking this case allows
> > > 	 * for various simplifications in other code.
> > > 	 */
> > > 	if ((clone_flags & CLONE_SIGHAND) && !(clone_flags & CLONE_VM))
> > > 		return ERR_PTR(-EINVAL);
> > > 
> > > CLONE_THREAD implies CLONE_VM, but not the other way around, we
> > > therefore would be able to CLONE_VM and not be part of the primary
> > > owner's thread group.
> > > 
> > > This is of course all terribly sad..
> > 
> > Agree, 
> > 
> > If clone(CLONE_VM) were to be done by a thread_group leader, we can walk
> > thro the siblings of parent of mm->owner.
> > 
> > However if clone(CLONE_VM) were to be done by non thread_group_leader
> > thread, then we dont even seem to add it to the init_task. i.e I dont
> > think we can refer to such a thread even when we walk thro
> > do_each_thread(g,t) { .. } while_each_thread(g,t);
> > 
> > right?
> 
> No, we initialize p->group_leader = p; and only change that for
> CLONE_THREAD, so a clone without CLONE_THREAD always results in a new
> thread group leader, which are always added to the init_task list.
> 

Ahh .. I missed the p->group_leader = p thing.

In which case, shouldnt traversing all the tasks of all siblings of 
parent of mm->owner should provide us all the the tasks that have linked
to mm. Right?

Agree that we can bother about this a little later.

-- 
Thanks and Regards
Srikar
