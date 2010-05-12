Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab0ELOqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:46:34 -0400
Received: from mail.openrapids.net ([64.15.138.104]:41594 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755295Ab0ELOqc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:46:32 -0400
Date: Wed, 12 May 2010 10:46:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 0/10] Uprobes v3
Message-ID: <20100512144629.GA16343@Krystal>
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6> <1273611585.1810.132.camel@laptop> <20100512102518.GA30767@linux.vnet.ibm.com> <1273666385.1626.96.camel@laptop> <20100512132708.GC13606@in.ibm.com> <1273671560.1626.114.camel@laptop> <20100512140433.GD13606@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20100512140433.GD13606@in.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:33:36 up 109 days, 17:10, 10 users,  load average: 0.03, 0.10,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ananth N Mavinakayanahalli (ananth@in.ibm.com) wrote:
> On Wed, May 12, 2010 at 03:39:20PM +0200, Peter Zijlstra wrote:
> > On Wed, 2010-05-12 at 18:57 +0530, Ananth N Mavinakayanahalli wrote:
> > > Now, as long as we have the housekeeping code to handle the
> > > possibility of a thread hitting the said breakpoint when its being
> > > removed, is it safe to assume atomicity for replacing one byte of
> > > possibly a longer instruction? 
> > 
> > Dunno I'm not a hardware guy, but the issue is so simple to side-step
> > I'm not sure why you're arguing for relying on these special semantics.
> 
> Yes we know what to do, but I am just trying to get clarity if its
> possible at all, since Mathieu was pretty sure that the hoops aren't
> necessary...

>From what I gathered in the Intel code modification documentation, setting a
breakpoint instruction is both atomic and OK with respect to concurrent CPUs
executing the code. The breakpoint instruction itself deals with serialization
of remote cores when it is hit.

Placing back _the original instruction_ is considered as safe too, as it is both
atomic and brings back the remote cores to the original code state. Basically,
these cores either observe the int3, or the original code. If they observe the
int3, they perform core serialization. If they observe the original code, they
either have never observed the int3 version (which is fine, it is as if the code
had never changed), or if they did observe the int3, they executed the
serialization instruction at the int3, so it's OK to put back the original
instruction.

Now the tricky case is the sequence: instruction A -> int3 -> instruction B,
because a core can only see "instruction A -> instruction B" without any
core synchronization whatsoever, and may not see the int3. That's where the
djprobes logic (with IPIs to all cores) comes into play. But as long as we stick
to "insn A -> int3 -> insn A", things can be done very simply.

By the way, kprobes rely on the assumption that it is OK to put a breakpoint
atomically and to put back the original instruction afterward.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
