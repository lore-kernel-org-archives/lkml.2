Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab2EaP4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:56:40 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46739 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609Ab2EaP4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:56:39 -0400
Date: Thu, 31 May 2012 17:56:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 17/41] rcu: Restart tick if we enqueue a callback in a
 nohz/cpuset CPU
Message-ID: <20120531155626.GC27841@somewhere.redhat.com>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
 <1335830115-14335-18-git-send-email-fweisbec@gmail.com>
 <20120522172714.GC8087@linux.vnet.ibm.com>
 <20120522173047.GA8160@linux.vnet.ibm.com>
 <20120523140331.GE1663@somewhere>
 <20120523161514.GD2402@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523161514.GD2402@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 09:15:14AM -0700, Paul E. McKenney wrote:
> On Wed, May 23, 2012 at 04:03:36PM +0200, Frederic Weisbecker wrote:
> > On Tue, May 22, 2012 at 10:30:47AM -0700, Paul E. McKenney wrote:
> > > On Tue, May 22, 2012 at 10:27:14AM -0700, Paul E. McKenney wrote:
> > > > On Tue, May 01, 2012 at 01:54:51AM +0200, Frederic Weisbecker wrote:
> > > > > If we enqueue an rcu callback, we need the CPU tick to stay
> > > > > alive until we take care of those by completing the appropriate
> > > > > grace period.
> > > > > 
> > > > > Thus, when we call_rcu(), send a self IPI that checks rcu_needs_cpu()
> > > > > so that we restore a periodic tick behaviour that can take care of
> > > > > everything.
> > > > 
> > > > Ouch, I hadn't considered RCU callbacks being posted from within an
> > > > extended quiescent state.  I guess I need to make __call_rcu() either
> > > > complain about this or handle it correctly...  It would -usually- be
> > > > harmless, but there is getting to be quite a bit of active machinery
> > > > in the various idle loops, so just assuming that it cannot happen is
> > > > probably getting to be an obsolete assumption.
> > > 
> > > Adaptive ticks does restart the tick upon entering the kernel, correct?
> > 
> > No, it keeps the tick down. The tick is restarted only if it's needed:
> > when more than one task are on the runqueue, a posix cpu timer is running,
> > a CPU needs the current one to report a quiescent state, etc...
> 
> Ah, I didn't realize that you didn't restart the tick upon entry to the
> kernel.  So this is why you need the IPI -- because there is no tick, if
> the system call runs for a long time, RCU is not guaranteed to make any
> progress on that CPU.
> 
> In the common case, this will not be a problem because system calls
> normally spend a short amount of time in the kernel, so normally RCU's
> dyntick-idle detection will handle this case.  The exception to this
> rule is when there is a long CPU-bound code path in the kernel, where
> "long" means many milliseconds.  In this exception case, this CPU needs
> to be interrupted or whatever is needed to force the CPU to progress
> through RCU.

Exactly!
