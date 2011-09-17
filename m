Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1IQTFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 15:05:46 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41586 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334Ab1IQTFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 15:05:45 -0400
Date: Sat, 17 Sep 2011 12:05:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Henroid <andrew.d.henroid@intel.com>,
        Mike Frysinger <vapier@gentoo.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 0/5 v3] rcu: Fix some rcu uses in extended quiescent
 state
Message-ID: <20110917190538.GE2333@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1316270402-19919-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316270402-19919-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 04:39:57PM +0200, Frederic Weisbecker wrote:
> This is an updated set that tries to fix some illegal uses
> of RCU that are made in extended quiescent state, ie: between
> calls of rcu_enter_nohz() and rcu_exit_nohz().

Thank you, Frederic!

I have queued these, and have started testing them.

							Thanx, Paul

> Changes:
> 
> - Restructuring of the changes in nohz core code. We need to handle
> the case when the tick is not stopped from tick_nohz_idle_enter() but
> from the irq exit path when the irq happens in idle loop. This should
> fix the RCU stall Paul detected after applying my patches.
> The first patch sort of overlaps the simple scope of fixes for RCU
> but I believe it makes the code slightly more simple and optimized
> in the end.
> 
> - Rename tick_nohz_enter_idle() into tick_nohz_idle_enter() (same for
> exit). That to stay coherent with usual naming (tips from Peterz on
> the nohz cpuset patchset that needs similar changes).
> 
> - Remove the rcu_ext_qs parameter from tick_nohz_idle_exit(). We only
> need it in tick_nohz_idle_enter() because as long as we call
> rcu_enter_nohz() explicitly, we really want to pair it with an explicit
> call to rcu_exit_nohz() (and vice versa), to avoid confusion.
> 
> There are still the powerpc fixes that are not included. But I would
> like to first get this set merged in Paul's tree before focusing on
> the powerpc reported issues.
> 
> Frederic Weisbecker (5):
>   nohz: Seperate out irq exit and idle loop dyntick logic
>   nohz: Allow rcu extended state handling seperately from tick stop
>   x86: Enter rcu extended qs after idle notifier call
>   x86: Call idle notifier after irq_enter()
>   rcu: Fix early call to rcu_irq_exit()
> 
>  arch/arm/kernel/process.c                |    4 +-
>  arch/avr32/kernel/process.c              |    4 +-
>  arch/blackfin/kernel/process.c           |    4 +-
>  arch/microblaze/kernel/process.c         |    4 +-
>  arch/mips/kernel/process.c               |    4 +-
>  arch/powerpc/kernel/idle.c               |    4 +-
>  arch/powerpc/platforms/iseries/setup.c   |    8 +-
>  arch/s390/kernel/process.c               |    4 +-
>  arch/sh/kernel/idle.c                    |    4 +-
>  arch/sparc/kernel/process_64.c           |    4 +-
>  arch/tile/kernel/process.c               |    4 +-
>  arch/um/kernel/process.c                 |    4 +-
>  arch/unicore32/kernel/process.c          |    4 +-
>  arch/x86/kernel/apic/apic.c              |    6 +-
>  arch/x86/kernel/apic/io_apic.c           |    2 +-
>  arch/x86/kernel/cpu/mcheck/mce.c         |    2 +-
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
>  arch/x86/kernel/cpu/mcheck/threshold.c   |    2 +-
>  arch/x86/kernel/irq.c                    |    6 +-
>  arch/x86/kernel/process_32.c             |    4 +-
>  arch/x86/kernel/process_64.c             |    9 ++-
>  include/linux/tick.h                     |   12 ++-
>  kernel/softirq.c                         |    4 +-
>  kernel/time/tick-sched.c                 |  110 ++++++++++++++++++++----------
>  24 files changed, 131 insertions(+), 84 deletions(-)
> 
> -- 
> 1.7.5.4
> 
