Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab0LUPf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 10:35:27 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53723 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab0LUPf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 10:35:26 -0500
Date: Tue, 21 Dec 2010 07:35:15 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 07/15] nohz_task: Restart tick when RCU forces nohz
 task cpu quiescent state
Message-ID: <20101221153515.GM2143@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-8-git-send-email-fweisbec@gmail.com>
 <1292860929.5021.16.camel@laptop>
 <20101220235158.GE1715@nowhere>
 <1292917274.5021.173.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292917274.5021.173.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 08:41:14AM +0100, Peter Zijlstra wrote:
> On Tue, 2010-12-21 at 00:52 +0100, Frederic Weisbecker wrote:
> > On Mon, Dec 20, 2010 at 05:02:09PM +0100, Peter Zijlstra wrote:
> > > On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > > > If a cpu is in nohz mode due to a nohz task running, then
> > > > it is not able to notify quiescent states requested by other
> > > > CPUs.
> > > > 
> > > > Then restart the tick to remotely force the quiescent states on the
> > > > nohz task cpus.
> > > 
> > > -ENOPARSE.. if its in NOHZ state, it couldn't possibly need to
> > > participate in the quiescent state machine because the cpu is in a
> > > quiescent state and has 0 RCU activity.
> > 
> > But it can be in nohz state in the kernel in which case it can have
> > any RCU activity.
> 
> That still doesn't make sense.. if you're in nohz state there shouldn't
> be any rcu activity, otherwise its not nohz is it?

This was one of the outcomes of the LPC session that Frederic presented
at, along with subsequent discussions.

The initial thought was that the kernel would exit nohz mode on each
transition into the kernel, as it currently does for nohz-idle in response
to interrupts and NMIs.  However, Frederic found that restarting the
tick on each system call was problematic, as he noted during his LPC
presentation.  The alternative is to make CPUs stay out of nohz-task
mode if they have RCU work (as you note above).

However, this also fails if a nohz-task CPU stays in a long-running
system call.  It has the tick turned off, so is ignoring RCU.  It has
informed RCU that it is in the kernel, so RCU cannot ignore it.
The result would be stalled grace periods.

The solution to this impasse is to note that if there is a grace period
in progress, then there must also be an RCU callback queued on some
CPU somewhere in the system.  This CPU cannot be in nohz mode, because
rcu_needs_cpu() won't let the CPU enter nohz mode.  This CPU therefore
has the tick running, and can therefore IPI the CPU that is in the
long-running system call.  This IPI can replace the tick, but only
when needed.

Of course, this IPI is only needed for some strange system call that
chews up several ticks of CPU-bound execution.  Or that is being hammered
by interrupts.  So these IPIs should be rare, but are required for
correctness in this corner case.  In the normal case, there would be
no RCU callback, so there would be no IPIs -- as is desired for the
workloads that want nohz-task.

Make sense?

							Thanx, Paul
