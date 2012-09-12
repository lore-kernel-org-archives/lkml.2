Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab2ILMGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:06:54 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:45788 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673Ab2ILMGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:06:49 -0400
Date: Wed, 12 Sep 2012 14:06:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        sbw@mit.edu, patches@linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: Re: [PATCH tip/core/rcu 11/26] rcu: Exit RCU extended QS on user
 preemption
Message-ID: <20120912120627.GA14705@somewhere>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346360743-3628-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346950959.18408.47.camel@twins>
 <1346951591.18408.48.camel@twins>
 <20120910202611.GB19268@somewhere>
 <1347442413.2124.70.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347442413.2124.70.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 11:33:33AM +0200, Peter Zijlstra wrote:
> On Mon, 2012-09-10 at 22:26 +0200, Frederic Weisbecker wrote:
> 
> > > > OK, so colour me unconvinced.. why are we doing this?
> > > > 
> > > > Typically when we call schedule nr_running != 1 (we need current to be
> > > > running and a possible target to switch to).
> > > > 
> > > > So I'd prefer to simply have schedule() disable all this adaptive tick
> > > > nonsense and leave it at that.
> > > 
> > > In fact, the only way to get here is through ttwu(), which would have
> > > done the nr_running increment and should have disabled all this adaptive
> > > stuff.
> > > 
> > > So again,.. why?
> > 
> > Ok, indeed if the ttwu happened locally or even remotely through an IPI, the
> > tick engine would stop the tick and exit that RCU extended quiescent state
> > before we reach that place.
> > 
> > I just want to be sure I'm covering every case. There are some places
> > around that call set_need_resched() even if no task is waiting for the CPU
> > (RCU is such an example). In this case the nohz engine won't exit the RCU
> > user mode before schedule().
> > 
> > Another example: a CPU does a remote wake up so it does set_need_resched()
> > and sends the IPI. The target CPU could see the TIF_RESCHED before resuming
> > userspace and call schedule_user() -> schedule() while the IPI has not
> > yet arrived. In this case we need that rcu_user_exit() before schedule might
> > make any use of RCU.
> > 
> > Also when the task returns from schedule(), if it's alone in the runqueue,
> > the rcu_user_enter() that follows can be helpful to stop the tick and
> > enter our RCU quiescent state.
> 
> So all that should have been in the Changelog.

Right, I'm fixing that.

> 
> So the only real problem I see is non IPI remote wakeups, those cannot
> actually restart the tick on the target cpu like we want.

Ok so let identify and validate the corner cases so that I can report them confidently
in the changelog:

1) This can happen if something calls set_need_resched() while no other task is
on the runqueue.

2) Remote wake up done but we haven't yet received the schedule IPI.

3) Non IPI remote wakeup you're referring above, I'm not sure
what you mean though.

> 
> The rest could all be fixed to not need this.
> 
> Hrmm. still don't like the patch, but at least I see why its needed.
> 
> > Also I'm considering this RCU user extended quiescent state as a standalone
> > feature for now. Indeed the only user of it is the adaptive tickless thing.
> > But I'm treating that RCU part independantly for now so that it makes it
> > easier to merge, piecewise.
> 
> But its semantics are very tightly tied to the requirements of adaptive
> tick, so arguing about one without the other doesn't really make sense.
> 

Yeah it's true. Now all of these hooks have been required in practice with
the adaptive tick code running.

Also keeping these hooks unconditional, until the adaptive tick code comes in
and drives that conditionally, is also a nice way to runtime selftest that code (check
there is no missing rcu_user_exit() call for example, easy to check if RCU lockdep
is enabled).
