Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab1JMMu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 08:50:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52497 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab1JMMu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 08:50:26 -0400
Date: Thu, 13 Oct 2011 14:50:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Frysinger <vapier@gentoo.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 08/11 v2] nohz: Allow rcu extended quiescent state
 handling seperately from tick stop
Message-ID: <20111013125017.GH14968@somewhere>
References: <1318004530-705-9-git-send-email-fweisbec@gmail.com>
 <1318082460-9982-1-git-send-email-fweisbec@gmail.com>
 <20111013065752.GB2430@linux.vnet.ibm.com>
 <20111013070357.GA7656@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111013070357.GA7656@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 12:03:57AM -0700, Paul E. McKenney wrote:
> On Wed, Oct 12, 2011 at 11:57:52PM -0700, Paul E. McKenney wrote:
> > On Sat, Oct 08, 2011 at 04:01:00PM +0200, Frederic Weisbecker wrote:
> > > It is assumed that rcu won't be used once we switch to tickless
> > > mode and until we restart the tick. However this is not always
> > > true, as in x86-64 where we dereference the idle notifiers after
> > > the tick is stopped.
> > > 
> > > To prepare for fixing this, add two new APIs:
> > > tick_nohz_idle_enter_norcu() and tick_nohz_idle_exit_norcu().
> > > 
> > > If no use of RCU is made in the idle loop between
> > > tick_nohz_enter_idle() and tick_nohz_exit_idle() calls, the arch
> > > must instead call the new *_norcu() version such that the arch doesn't
> > > need to call rcu_idle_enter() and rcu_idle_exit().
> > > 
> > > Otherwise the arch must call tick_nohz_enter_idle() and
> > > tick_nohz_exit_idle() and also call explicitly:
> > > 
> > > - rcu_idle_enter() after its last use of RCU before the CPU is put
> > > to sleep.
> > > - rcu_idle_exit() before the first use of RCU after the CPU is woken
> > > up.
> > 
> > Thank you, Frederic!  I have queued this to replace the earlier
> > version.  The set is available on branch rcu/dyntick of
> > 
> > 	https://github.com/paulmckrcu/linux
> 
> Which reminds me...  About the ultimate objective, getting tick-free
> operation.  (Or, for the guys who want to eliminate the tick entirely,
> shutting up the hrtimer stuff that they want to replace it with.)
> 
> I believe that you will then need to have two levels of not-in-dynticks
> for processes, one for idle vs. not and another for when a process
> switches from user-space to kernel execution.  Correct, or am I
> confused?
> 
> The reason I ask is that commit e11f5981 currently only allows one
> level of not-in-dynticks for processes.  It is easy to add another
> level, but thought I should check beforehand.

Hmm, yeah looking at that patch, it's going to be hard to have a nesting
that looks like:

rcu_irq_enter();
rcu_user_enter();
rcu_irq_exit(); <-- with effective extended quiescent state starting there

I also need to be able to call rcu_user_enter() from non-irq path.

I don't truly understand the problem of the usermode helpers that
mess up the dynticks counts. May be we can somewhow fix it differently
from the offending callsite?
