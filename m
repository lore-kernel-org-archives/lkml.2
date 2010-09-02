Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab0IBRxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 13:53:00 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35761 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab0IBRw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 13:52:59 -0400
Date: Thu, 2 Sep 2010 23:17:12 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
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
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv11 2.6.36-rc2-tip 3/15]  3: uprobes: Slot allocation
 for Execution out of line(XOL)
Message-ID: <20100902174712.GA14891@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
 <20100825134156.5447.43216.sendpatchset@localhost6.localdomain6>
 <1283415812.2059.1825.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1283415812.2059.1825.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Current slot allocation mechanism:
> > 1. Allocate one dedicated slot per user breakpoint. Each slot is big
> > enuf to accomodate the biggest instruction for that architecture. (16
> > bytes for x86).
> > 2. We currently allocate only one page for slots. Hence the number of
> > slots is limited to active breakpoint hits on that process.
> > 3. Bitmap to track used slots. 
> 
> An alternative method would be to have 1 slot per cpu, and manage the
> slot content using preemption notifiers. That gives you a fixed number
> of slots and an unlimited number of probe points.
> 
> If the preemption happens to be a migration you need to rewrite the
> userspace IP to point to the new slot -- if indeed the task was inside
> one when it got preempted -- but that all should be doable.
> 

Certainly doable but it has its share of drawbacks.
1. On every probe hit we have to copy the instruction into the
slot, so there is a performance penalty. 

2  This might complicate booster probe, because the jump
instruction that follows the original instruction now actually have to
coded every time.

3. Yes migration is an issue esp
-  if a thread of the same process that hit a breakpoint is scheduled into the same cpu and that newly scheduled thread hits a breakpoint. 
- Something similar can happen if a multithreaded process runs on a
  uniprocessor machine.

4. I dont see a need for clearing slots after post processing, but if
we need to clear we then are adding more penalties because not only are
we clearing the slots but the post processing then cant happen in
interrupt context.

5. I think we are covered on the cpu hotplug too, (i.e not sure if we have
to make uprobes cpu hot plug aware.).

6. We would still be allocating a page for the slots. Unless we want
to expand to more slots than available in one page, I dont see the
disadvantages with the current approach.

--
Thanks and Regards
Srikar
