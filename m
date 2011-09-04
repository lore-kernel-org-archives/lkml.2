Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab1IDVFS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 17:05:18 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41121 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab1IDVFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 17:05:14 -0400
Date: Sun, 4 Sep 2011 23:05:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
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
Message-ID: <20110904210504.GC5587@somewhere>
References: <1313861452-24783-1-git-send-email-fweisbec@gmail.com>
 <1313861452-24783-2-git-send-email-fweisbec@gmail.com>
 <20110904210130.GL2411@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110904210130.GL2411@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 04, 2011 at 02:01:30PM -0700, Paul E. McKenney wrote:
> On Sat, Aug 20, 2011 at 07:30:49PM +0200, Frederic Weisbecker wrote:
> > It is assumed that rcu won't be used once we switch to tickless
> > mode and until we restart the tick. However this is not always
> > true, as in x86-64 where we dereference the idle notifiers after
> > the tick is stopped.
> > 
> > To prepare for fixing this, split the tickless mode switching and
> > RCU extended quiescent state logics.
> > Make tick_nohz_stop/restart_sched_tick() RCU agnostic but provide
> > a new pair of APIs tick_nohz_enter/exit_idle() that keep the
> > old behaviour by handling both the nohz mode and RCU extended
> > quiescent states, then convert every archs to use these.
> > 
> > Archs that want to switch to RCU extended QS to some custom points
> > can do it later by changing the parameter in tick_nohz_enter,exit_idle()
> > to false and call rcu_enter,exit() separately.
> 
> Hello, Frederic,
> 
> Some of my testing indicates that it is necessary to push
> tick_nohz_enter_idle() and tick_nohz_exit_idle() further down in the
> powerpc case due to tracing that happens in functions called from
> ppc_md.power_save().  My current guess is that for the pSeries flavor
> of powerpc, these must be called from __trace_hcall_entry() and
> __trace_hcall_exit(), probably controlled by a powerpc-specific per-CPU
> variable.
> 
> The following functions likely need help.
> 
> 	cbe_power_save()
> 	cpm_idle()
> 	e500_idle()
> 	idle_doze()
> 	idle_spin()
> 	ppc44x_idle()
> 	ppc6xx_idle()
> 	ps3_power_save()
> 	pseries_dedicated_idle_sleep()
> 	pseries_shared_idle_sleep()
> 
> I am continuing testing.  In the meantime, other thoughts?
> 
> 							Thanx, Paul

Yeah sure, I still have that in my todo list. I wanted to ensure
first that at least you are fine with the new interface before I go
fixing more detected bad callsites.

Thanks.
