Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab0DFMyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 08:54:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:56747 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755180Ab0DFMyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 08:54:15 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/7JZE7Y4r7ldKnwVewdk6WN2Krwx5vabeaEByM14
	RXjTkN/7RWKqTg
Subject: Re: Random scheduler/unaligned accesses crashes with perf lock
 events on sparc 64
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
       paulus@samba.org
In-Reply-To: <1270554716.1595.134.camel@laptop>
References: <20100405065701.GC5127@nowhere>
	 <20100405.122233.188421941.davem@davemloft.net>
	 <20100405194055.GA5265@nowhere>
	 <20100406.025049.267615796.davem@davemloft.net>
	 <20100406113830.GF5147@nowhere>  <1270554716.1595.134.camel@laptop>
Content-Type: text/plain
Date: Tue, 06 Apr 2010 14:54:10 +0200
Message-Id: <1270558450.6369.30.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 13:51 +0200, Peter Zijlstra wrote:
> On Tue, 2010-04-06 at 13:38 +0200, Frederic Weisbecker wrote:
> > On Tue, Apr 06, 2010 at 02:50:49AM -0700, David Miller wrote:
> > > From: Frederic Weisbecker <fweisbec@gmail.com>
> > > Date: Mon, 5 Apr 2010 21:40:58 +0200
> > > 
> > > > It happens without CONFIG_FUNCTION_TRACER as well (but it happens
> > > > when the function tracer runs). And I hadn't your
> > > > perf_arch_save_caller_regs() when I triggered this.
> > > 
> > > I figured out the problem, it's NMIs.  As soon as I disable all of the
> > > NMI watchdog code, the problem goes away.
> > > 
> > > This is because some parts of the NMI interrupt handling path are not
> > > marked with "notrace" and the various tracer code paths use
> > > local_irq_disable() (either directly or indirectly) which doesn't work
> > > with sparc64's NMI scheme.  These essentially turn NMIs back on in the
> > > NMI handler before the NMI condition has been cleared, and thus we can
> > > re-enter with another NMI interrupt.
> > > 
> > > We went through this for perf events, and we just made sure that
> > > local_irq_{enable,disable}() never occurs in any of the code paths in
> > > perf events that can be reached via the NMI interrupt handler.  (the
> > > only one we had was sched_clock() and that was easily fixed)
> > 
> > 
> > 
> > That reminds me we have a new pair of local_irq_disable/enable
> > in perf_event_task_output(), which path can be taken by hardware
> > pmu events.
> > 
> > See this patch:
> > 
> > 8bb39f9aa068262732fe44b965d7a6eb5a5a7d67
> > perf: Fix 'perf sched record' deadlock
> 
> ARGH.. yes
> 
> Also, I guess that should live in perf_output_lock/unlock() not in
> perf_event_task_output().
> 
> Egads, how to fix that

Damn, so deadlock fix isn't a fix.  No idea.

	-Mike

