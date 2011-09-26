Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab1IZQDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 12:03:22 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53076 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab1IZQDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 12:03:21 -0400
Date: Mon, 26 Sep 2011 09:02:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/7] nohz: Allow rcu extended quiescent state handling
 seperately from tick stop
Message-ID: <20110926160205.GB2399@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1317032352-25571-1-git-send-email-fweisbec@gmail.com>
 <1317032352-25571-5-git-send-email-fweisbec@gmail.com>
 <1317033884.9084.79.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317033884.9084.79.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 12:44:44PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-09-26 at 12:19 +0200, Frederic Weisbecker wrote:
> > It is assumed that rcu won't be used once we switch to tickless
> > mode and until we restart the tick. However this is not always
> > true, as in x86-64 where we dereference the idle notifiers after
> > the tick is stopped.
> > 
> > To prepare for fixing this, add a parameter to tick_nohz_enter_idle()
> > named "rcu_ext_qs" that tells whether we want to enter RCU extended
> > quiescent state at the same time we stop the tick.
> > 
> > If no use of RCU is made in the idle loop between
> > tick_nohz_enter_idle() and tick_nohz_exit_idle() calls, the parameter
> > must be set to true and the arch doesn't need to call rcu_enter_nohz()
> > and rcu_exit_nohz() explicitly.
> > 
> > Otherwise the parameter must be set to false and the arch is
> > responsible of calling:
> > 
> > - rcu_enter_nohz() after its last use of RCU before the CPU is put
> > to sleep.
> > - rcu_exit_nohz() before the first use of RCU after the CPU is woken
> > up. 
> 
> I can't say this really makes sense:
> 
>   tick_nohz_idle_enter(false);
> 
> reads like, don't enter nohz state, not: enter nohz state but don't
> enter rcu-nohz state.
> 
> I realize you want to keep the per-arch frobbing low, but since you're
> already touching all of them, I think its more important to keep the
> functions readable.
> 
> Why not simply fully split nohz and rcu and modify all idle routines
> with both calls?

This might well be the correct thing to do, but one thing that gives
me pause is that some architectures have a large number of idle routines.
If such an architecture can use tick_nohz_idle_enter(true), then that
architecture needs only one change rather than one change to each of
potentially many idle loops.

Would your readability concerns be addressed by something like the
following?

#define RCU_NO_HZ_LATER 0
#define RCU_NO_HZ_NOW   1

Then we would have one of the following:

	tick_nohz_idle_enter(RCU_NO_HZ_LATER);
	tick_nohz_idle_enter(RCU_NO_HZ_NOW);

							Thanx, Paul
