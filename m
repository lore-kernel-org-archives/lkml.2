Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab1GTTBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:01:47 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60127 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab1GTTBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:01:46 -0400
Date: Wed, 20 Jul 2011 12:01:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Greear <greearb@candelatech.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ed Tomlinson <edt@aei.ca>, linux-kernel@vger.kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, edward.tomlinson@aero.bombardier.com
Subject: Re: [PATCH rcu/urgent 0/6] Fixes for RCU/scheduler/irq-threads
 trainwreck
Message-ID: <20110720190141.GJ2313@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110720001738.GA16369@linux.vnet.ibm.com>
 <201107192130.02080.edt@aei.ca>
 <201107192207.33813.edt@aei.ca>
 <20110720044435.GB2400@linux.vnet.ibm.com>
 <CA+55aFyaCY=qzFKswi2NR097KZtb5x98sba3rHJ7B0rchtzm2g@mail.gmail.com>
 <20110720133443.GG2400@linux.vnet.ibm.com>
 <4E270A0E.6090902@candelatech.com>
 <20110720171532.GB2313@linux.vnet.ibm.com>
 <20110720184413.GD17977@elte.hu>
 <1311187978.29152.58.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311187978.29152.58.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 08:52:58PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-07-20 at 20:44 +0200, Ingo Molnar wrote:
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > RCU boost is new and counts as strange for another few days at least.
> > 
> > I'd rather prefer a oneliner patch that turns it off in the Kconfig 
> > for now.
> > 
> > We are awfully late in the -rc cycle and this diffstat:
> > 
> >  b/include/linux/sched.h   |    3 ++
> >  b/kernel/rcutree_plugin.h |    6 +++--
> >  b/kernel/sched.c          |   44 ++++++++++++++++++++++++++++++++++-----
> >  b/kernel/signal.c         |   19 +++++++++++------
> >  b/kernel/softirq.c        |   12 +++++++++-
> >  kernel/rcutree_plugin.h   |   51 +++++++++++++++++++++++++++++++++-------------
> >  6 files changed, 105 insertions(+), 30 deletions(-)
> > 
> > looks very scary to me.
> 
> A lot of that is also relevant to !BOOST.

Unfortunately, agreed.  :-(

The expedited grace periods also cause rcu_read_unlock() to call
into the scheduler.  This can interact badly with the recently
added RCU read-side critical sections in the scheduler that have
either the runqueue or the priority-inheritance locks held, especially
when interrupts occur towards the end of __rcu_read_unlock().  But
there are some failure cases that don't involve interrupts (though
I believe all of them involve RCU_BOOST).

That said, turning off RCU_BOOST would allow dropping this patches:

7765be2fec0f4 Fix RCU_BOOST race handling current->rcu_read_unlock_special



							Thanx, Paul
