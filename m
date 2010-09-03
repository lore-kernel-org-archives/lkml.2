Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab0ICH1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 03:27:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:35426 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab0ICH1i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 03:27:38 -0400
Subject: Re: [PATCHv11 2.6.36-rc2-tip 3/15]  3: uprobes: Slot allocation
 for Execution out of line(XOL)
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
In-Reply-To: <20100902174712.GA14891@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
	 <20100825134156.5447.43216.sendpatchset@localhost6.localdomain6>
	 <1283415812.2059.1825.camel@laptop>
	 <20100902174712.GA14891@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Sep 2010 09:26:17 +0200
Message-ID: <1283498777.1783.45.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 23:17 +0530, Srikar Dronamraju wrote:
> > > Current slot allocation mechanism:
> > > 1. Allocate one dedicated slot per user breakpoint. Each slot is big
> > > enuf to accomodate the biggest instruction for that architecture. (16
> > > bytes for x86).
> > > 2. We currently allocate only one page for slots. Hence the number of
> > > slots is limited to active breakpoint hits on that process.
> > > 3. Bitmap to track used slots. 
> > 
> > An alternative method would be to have 1 slot per cpu, and manage the
> > slot content using preemption notifiers. That gives you a fixed number
> > of slots and an unlimited number of probe points.
> > 
> > If the preemption happens to be a migration you need to rewrite the
> > userspace IP to point to the new slot -- if indeed the task was inside
> > one when it got preempted -- but that all should be doable.
> > 
> 
> Certainly doable but it has its share of drawbacks.
> 1. On every probe hit we have to copy the instruction into the
> slot, so there is a performance penalty. 

Yeah, although I imagine its nearly free since you need to pay the
cache-miss anyway.

> 2  This might complicate booster probe, because the jump
> instruction that follows the original instruction now actually have to
> coded every time.

Why can't you keep the whole replacement sequence in-tact? Simply copy
it out into the slot each time.

> 3. Yes migration is an issue esp
> -  if a thread of the same process that hit a breakpoint is scheduled into the same cpu and that newly scheduled thread hits a breakpoint. 
> - Something similar can happen if a multithreaded process runs on a
>   uniprocessor machine.

-ENOPARSE ?!

> 4. I dont see a need for clearing slots after post processing, but if
> we need to clear we then are adding more penalties because not only are
> we clearing the slots but the post processing then cant happen in
> interrupt context.

post-processing? you mean the probe handler? Why couldn't that be done
from interrupt context?

> 5. I think we are covered on the cpu hotplug too, (i.e not sure if we have
> to make uprobes cpu hot plug aware.).

Not if you use a slot per cpu and use preemption notifiers, the
preemption notifiers will migrate the slots around.

> 6. We would still be allocating a page for the slots. Unless we want
> to expand to more slots than available in one page, I dont see the
> disadvantages with the current approach.

The current approach limits the number of probes to what fits in a page.
The slot per cpu approach will have no such limit.
