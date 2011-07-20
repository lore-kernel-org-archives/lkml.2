Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1GTT35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:29:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33704 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab1GTT34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:29:56 -0400
Date: Wed, 20 Jul 2011 12:29:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ben Greear <greearb@candelatech.com>, Ed Tomlinson <edt@aei.ca>,
        linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, edward.tomlinson@aero.bombardier.com
Subject: Re: [PATCH rcu/urgent 0/6] Fixes for RCU/scheduler/irq-threads
 trainwreck
Message-ID: <20110720192949.GM2313@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <201107192130.02080.edt@aei.ca>
 <201107192207.33813.edt@aei.ca>
 <20110720044435.GB2400@linux.vnet.ibm.com>
 <CA+55aFyaCY=qzFKswi2NR097KZtb5x98sba3rHJ7B0rchtzm2g@mail.gmail.com>
 <20110720133443.GG2400@linux.vnet.ibm.com>
 <4E270A0E.6090902@candelatech.com>
 <20110720171532.GB2313@linux.vnet.ibm.com>
 <20110720184413.GD17977@elte.hu>
 <1311187978.29152.58.camel@twins>
 <CA+55aFyuKTj3zEvWJEx4_RDzLQ+ipJ58UWFYH84nmcwGF_c4aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFyuKTj3zEvWJEx4_RDzLQ+ipJ58UWFYH84nmcwGF_c4aA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 12:02:47PM -0700, Linus Torvalds wrote:
> On Wed, Jul 20, 2011 at 11:52 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >>  6 files changed, 105 insertions(+), 30 deletions(-)
> >>
> >> looks very scary to me.
> >
> > A lot of that is also relevant to !BOOST.
> 
> Can we limit this somehow? Or split it up? Which part of this is "fix
> new BOOST features, not ever even executed without BOOST", and which
> part of this is "fixes core stuff"?

#2 (Fix RCU_BOOST race handling current->rcu_read_unlock_special) and
#7 (align __lock_task_sighand() irq disabling and RCU) are needed only
for RCU_BOOST.  The rest fix problems that can occur even with !RCU_BOOST.
I believe that #4 (protect __rcu_read_unlock() against scheduler-using 
irq handlers) turns #1 (decrease rcu_report_exp_rnp coupling with scheduler)
into a longer-term maintenance issue rather than an urgent fix.

> I *really* hate the timing of this. The code that is only impacted by
> BOOST I cannot find it in myself to care about, and I'd be willing to
> consider it basically EXPERIMENTAL and just pulling it.

I can only say that I completely failed in my goal of making my code
go in without a ripple.  :-(

> IOW, is the core non-boost fix just a few obvious oneliners?
> 
> The "it all broke completely" in previous version of this also doesn't
> make me get all the warm fuzzies. Which all makes me go "what is
> minimal and really really SAFE?"

Peter, does #4 (protect __rcu_read_unlock() against scheduler-using
irq handlers) remove the need for #5 (Add irq_{enter,exit}() to
scheduler_ipi()) and #6 (Inform RCU of irq_exit() activity)?  My guess is
"no" for #5 and "yes" for #6.

If my guess is correct, then the minimal non-RCU_BOOST fix is #4 (which
drags along #3) and #6.  Which are not one-liners, but somewhat smaller:

 b/kernel/rcutree_plugin.h |   12 ++++++------
 b/kernel/softirq.c        |   12 ++++++++++--
 kernel/rcutree_plugin.h   |   31 +++++++++++++++++++++++++------
 3 files changed, 41 insertions(+), 14 deletions(-)

How would you like to proceed?

							Thanx, Paul
