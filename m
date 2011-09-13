Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab1IMQtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 12:49:43 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44356 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab1IMQtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 12:49:42 -0400
Date: Tue, 13 Sep 2011 09:49:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Mike Frysinger <vapier@gentoo.org>, Ralf Baechle <ralf@linux-mips.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/4] nohz: Split extended quiescent state handling from
 nohz switch
Message-ID: <20110913164933.GF2416@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1313861452-24783-1-git-send-email-fweisbec@gmail.com>
 <1313861452-24783-2-git-send-email-fweisbec@gmail.com>
 <20110904233643.GN2411@linux.vnet.ibm.com>
 <20110907142233.GA11570@linux.vnet.ibm.com>
 <20110913000637.GA17335@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110913000637.GA17335@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 02:06:45AM +0200, Frederic Weisbecker wrote:
> On Wed, Sep 07, 2011 at 07:22:33AM -0700, Paul E. McKenney wrote:
> > On Sun, Sep 04, 2011 at 04:36:43PM -0700, Paul E. McKenney wrote:
> > > On Sat, Aug 20, 2011 at 07:30:49PM +0200, Frederic Weisbecker wrote:
> > > > It is assumed that rcu won't be used once we switch to tickless
> > > > mode and until we restart the tick. However this is not always
> > > > true, as in x86-64 where we dereference the idle notifiers after
> > > > the tick is stopped.
> > > > 
> > > > To prepare for fixing this, split the tickless mode switching and
> > > > RCU extended quiescent state logics.
> > > > Make tick_nohz_stop/restart_sched_tick() RCU agnostic but provide
> > > > a new pair of APIs tick_nohz_enter/exit_idle() that keep the
> > > > old behaviour by handling both the nohz mode and RCU extended
> > > > quiescent states, then convert every archs to use these.
> > > > 
> > > > Archs that want to switch to RCU extended QS to some custom points
> > > > can do it later by changing the parameter in tick_nohz_enter,exit_idle()
> > > > to false and call rcu_enter,exit() separately.
> > > 
> > > This approach looks quite good to me!  A few comments below.
> > 
> > But I get RCU stall warnings when running it on powerpc on top of
> > the patch set at:
> > 
> > 	https://lkml.org/lkml/2011/9/7/64
> > 
> > At first glance, it appears that CPUs are entering dyntick-idle
> > mode without RCU being informed.  Any thoughts on diagnostics?
> > 
> > 							Thanx, Paul
> 
> I've just tested with your rcu/next branch from github and applied
> my patches on top of it but did not experience a stall in x86.

Thank you for checking this!

> That may be related to powerpc more precisely, or may be any arch
> but on some particular condition.

OK, I guess my next step is to put a WARN_ON_ONCE() in the idle loop
to check to see if there might be some other idle loop buried in
PowerPC somewhere...

							Thanx, Paul
