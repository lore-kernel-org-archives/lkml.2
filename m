Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab0IFSGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 14:06:18 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46157 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412Ab0IFSGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 14:06:09 -0400
Date: Mon, 6 Sep 2010 23:29:57 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCHv11 2.6.36-rc2-tip 3/15]  3: uprobes: Slot allocation
 for Execution out of line(XOL)
Message-ID: <20100906175957.GH14891@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
 <20100825134156.5447.43216.sendpatchset@localhost6.localdomain6>
 <1283415812.2059.1825.camel@laptop>
 <20100902174712.GA14891@linux.vnet.ibm.com>
 <1283498777.1783.45.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1283498777.1783.45.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > An alternative method would be to have 1 slot per cpu, and manage the
> > > slot content using preemption notifiers. That gives you a fixed number
> > > of slots and an unlimited number of probe points.
> > > 
> > > If the preemption happens to be a migration you need to rewrite the
> > > userspace IP to point to the new slot -- if indeed the task was inside
> > > one when it got preempted -- but that all should be doable.
> > > 
> > 
> > 3. Yes migration is an issue esp
> > -  if a thread of the same process that hit a breakpoint is scheduled into the same cpu and that newly scheduled thread hits a breakpoint. 
> > - Something similar can happen if a multithreaded process runs on a
> >   uniprocessor machine.
> 
> > 5. I think we are covered on the cpu hotplug too, (i.e not sure if we have
> > to make uprobes cpu hot plug aware.).
> 
> Not if you use a slot per cpu and use preemption notifiers, the
> preemption notifiers will migrate the slots around.


Lets say the thread while singlestepping the process gets
pre-empted. Eventually the cpu might run some other thread of the same
process before picking the first run thread. Or the first run
thread could after migration due to load balancing or whatever end up
running on  a different thread?  How do we handle these cases? 

> 
> > 6. We would still be allocating a page for the slots. Unless we want
> > to expand to more slots than available in one page, I dont see the
> > disadvantages with the current approach.
> 
> The current approach limits the number of probes to what fits in a page.
> The slot per cpu approach will have no such limit.


yes the limit on number of probes is a limitation. For now the
implementation would be straight and easy. We could either rework on the
algorithm or add more pages depending on how often uprobes gets used.

> > 2  This might complicate booster probe, because the jump
> > instruction that follows the original instruction now actually have to
> > coded every time.
> 
> Why can't you keep the whole replacement sequence in-tact? Simply copy
> it out into the slot each time.

Yes, if we use jump absolute then the replacement sequence stays
in-tact.

--
Thanks and Regards
Srikar
