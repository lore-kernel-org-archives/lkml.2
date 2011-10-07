Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552Ab1JGXck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 19:32:40 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35260 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759384Ab1JGXcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 19:32:39 -0400
Date: Fri, 7 Oct 2011 16:32:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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
        Paul Mundt <lethal@linux-sh.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 00/11] rcu: Detect illegal uses of RCU in idle and fix
 some v5
Message-ID: <20111007233235.GJ2696@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1318004530-705-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318004530-705-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 06:21:59PM +0200, Frederic Weisbecker wrote:
> Hi Paul,
> 
> Here is the rebase. And it's more than just a rebase given the
> semantical changes after your patch that tracks idleness. And also
> because of the new API naming (with a new pair of tick_nohz_idle_enter()
> tick_nohz_idle_exit() with *_norcu suffixes).
> 
> I have reused and updated some comments (that you made on earlier
> versions of my patchset) that assumed that extended qs = dynticks
> idle, as it's not always true anymore. I've tried to bring a new
> wording to express what we are dealing with: "RCU-free window in idle"
> or "RCU-idle window". I let you update the comments if you think
> that's confusing or too scarce.
> 
> It has passed several hours of rcutorture with NO_HZ && SMP, and at least
> booted fine with all your configs.

Thank you, Frederic!  I have queued these locally and will start
testing them.

						Thanx, Paul

> Frederic Weisbecker (9):
>   rcu: Detect illegal rcu dereference in extended quiescent state
>   rcu: Inform the user about extended quiescent state on PROVE_RCU warning
>   rcu: Warn when rcu_read_lock() is used in extended quiescent state
>   rcu: Make srcu_read_lock_held() call common lockdep-enabled function
>   nohz: Separate out irq exit and idle loop dyntick logic
>   nohz: Allow rcu extended quiescent state handling seperately from tick stop
>   x86: Enter rcu extended qs after idle notifier call
>   x86: Call idle notifier after irq_enter()
>   rcu: Fix early call to rcu_idle_enter()
> 
> Paul E. McKenney (2):
>   rcu: Remove one layer of abstraction from PROVE_RCU checking
>   rcu: Warn when srcu_read_lock() is used in an extended quiescent state
> 
>  arch/arm/kernel/process.c                |    4 +-
>  arch/avr32/kernel/process.c              |    4 +-
>  arch/blackfin/kernel/process.c           |    4 +-
>  arch/microblaze/kernel/process.c         |    4 +-
>  arch/mips/kernel/process.c               |    4 +-
>  arch/openrisc/kernel/idle.c              |    4 +-
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
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
>  arch/x86/kernel/cpu/mcheck/threshold.c   |    2 +-
>  arch/x86/kernel/irq.c                    |    6 +-
>  arch/x86/kernel/process_32.c             |    4 +-
>  arch/x86/kernel/process_64.c             |   10 +++-
>  include/linux/rcupdate.h                 |   74 +++++++++++++++--------
>  include/linux/srcu.h                     |   38 ++++++++----
>  include/linux/tick.h                     |   52 ++++++++++++++--
>  kernel/lockdep.c                         |   22 +++++++
>  kernel/rcupdate.c                        |    4 +
>  kernel/rcutiny.c                         |    1 +
>  kernel/rcutree.c                         |   19 +++++-
>  kernel/softirq.c                         |    4 +-
>  kernel/time/tick-sched.c                 |   96 ++++++++++++++++++-----------
>  30 files changed, 273 insertions(+), 129 deletions(-)
> 
> -- 
> 1.7.5.4
> 
