Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab0ELR72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:59:28 -0400
Received: from mail.openrapids.net ([64.15.138.104]:44991 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751090Ab0ELR70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:59:26 -0400
Date: Wed, 12 May 2010 13:59:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Mark Wielaard <mjw@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 0/10] Uprobes v3
Message-ID: <20100512175924.GB15953@Krystal>
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6> <1273611585.1810.132.camel@laptop> <20100512102518.GA30767@linux.vnet.ibm.com> <1273666385.1626.96.camel@laptop> <20100512132708.GC13606@in.ibm.com> <1273671560.1626.114.camel@laptop> <20100512140433.GD13606@in.ibm.com> <20100512144629.GA16343@Krystal> <4BEADD94.6080501@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BEADD94.6080501@zytor.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:32:07 up 109 days, 20:09,  9 users,  load average: 0.40, 0.23,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> On 05/12/2010 07:46 AM, Mathieu Desnoyers wrote:
> > 
> > Now the tricky case is the sequence: instruction A -> int3 -> instruction B,
> > because a core can only see "instruction A -> instruction B" without any
> > core synchronization whatsoever, and may not see the int3. That's where the
> > djprobes logic (with IPIs to all cores) comes into play. But as long as we stick
> > to "insn A -> int3 -> insn A", things can be done very simply.
> > 
> > By the way, kprobes rely on the assumption that it is OK to put a breakpoint
> > atomically and to put back the original instruction afterward.
> > 
> 
> Keep in mind the following corner case, though:
> 
> insnA -> int3@A -> insnA
> insnB -> int3@B -> insnB
> 
> It is now possible for the core to hit int3@A, without the int3@B being
> there.  The int3 handler *has* to be able to handle any of the int3's
> put in place, quite possibly out of order, until a core serialization is
> performed.

Indeed. I would add that this out-of-order observation of breakpoint
modification is already expected, because other cores may be executing arbitrary
code when we add the two breakpoints (either insnA, B, or somewhere in between,
or somewhere else entirely).

Basically, we can make no assumption about the order in which the two stores
will be seen by other CPUs. But I can't imagine a debugger expecting these two
stores to be observed in order.

If we ever want to provide a _guarantee_ that starting from a certain point all
CPUs will see a set of breakpoint, then we need to issue a core serializing
instruction on all CPUs. This would determine the "quiescent state" of the CPUs,
starting from which all of them see the breakpoints.

Thanks,

Mathieu

> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
