Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129Ab2ILPXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:23:02 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54821 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab2ILPW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:22:58 -0400
Date: Wed, 12 Sep 2012 08:21:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, sbw@mit.edu,
        patches@linaro.org, Alessio Igor Bogani <abogani@kernel.org>,
        Avi Kivity <avi@redhat.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Christoph Lameter <cl@linux.com>, Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: Re: [PATCH tip/core/rcu 11/26] rcu: Exit RCU extended QS on user
 preemption
Message-ID: <20120912152156.GP4257@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346360743-3628-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346950959.18408.47.camel@twins>
 <1346951591.18408.48.camel@twins>
 <20120910202611.GB19268@somewhere>
 <1347442413.2124.70.camel@twins>
 <20120912120627.GA14705@somewhere>
 <1347453696.15764.24.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347453696.15764.24.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091215-7606-0000-0000-0000039863CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 02:41:36PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-09-12 at 14:06 +0200, Frederic Weisbecker wrote:
> > 
> > 1) This can happen if something calls set_need_resched() while no other task is
> > on the runqueue.
> 
> People really shouldn't be doing that... I think I know why RCU does
> this, but yuck. I also think RCU can avoid doing this, but its a toss up
> if that's worth the trouble.

It used to do this whenever it had to force quiescent states on a given
CPU more than one time in a given grace period.  I have removed this
(on your advice), and the only remaining use is during RCU CPU stall
warnings, where a given CPU has refused to pass through a quiescent
state for more than a minute.

I could remove that one as well, if it would help.  Though it would
be nice to have -some- way to kick the CPU in that case.  Thoughts?

> > 2) Remote wake up done but we haven't yet received the schedule IPI.
> > 
> > 3) Non IPI remote wakeup you're referring above, I'm not sure
> > what you mean though.
> 
> Well there's two ways of doing remote wakeups, one is doing the wakeup
> from the waking cpu and sending an IPI over to reschedule iff you need
> wakeup-preemption, the other is queueing the task remotely and sending
> an IPI to do the wakeup on the remote cpu.
> 
> The former has the problem, the latter not. 
> 
> See ttwu_queue().
> 
> We could of course mandate that all remote wakeups to special nohz cpus
> get queued. That would just leave us with RCU and it would simply not
> send resched IPIs to extended quiescent CPUs anyway, right?

Indeed it never has done this, at least not in the absence of bugs.

							Thanx, Paul

> So at that point all return to user schedule() calls have nr_running > 1
> and the tick is running and RCU is not in extended quiescent state.
> Since either we had nr_running > 1 and pre and post state are the same,
> or we had nr_running == 1 and we just got a fresh wakeup pushing it to
> 2, the wakeup will have executed on our cpu and have re-started the tick
> and kicked RCU into active gear again.
> 
> We cannot hit return to user schedule() with nr_running == 0, simply
> because in that case there's no userspace to return to, only the idle
> thread and that's very much not userspace :-)
> 
> Hmm ?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

