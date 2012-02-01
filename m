Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab2BATnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:43:40 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54829 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756789Ab2BATni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:43:38 -0500
Date: Wed, 1 Feb 2012 11:41:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH RFC 0/41] RCU commits for 3.4
Message-ID: <20120201194131.GA10028@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-5806-0000-0000-000011F30073
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset makes RCU more aggressive about entering dyntick-idle mode
in order to improve energy efficiency, converts a few more call_rcu()s to
kfree_rcu(), applies a number of rcutree fixes and cleanups to rcutiny,
removes CONFIG_SMP #ifdef from treercu, allows RCU CPU stall times to
be set via sysfs, add CPU-stall capability to rcutorture, adds more
RCU-abuse diagnostics, updates documentation, and yet more fixes from
the still-ongoing top-to-bottom inspection of RCU with a special focus
on the CPU-hotplug code path.  The patches are as follows:

1,26,41,40.
	Documentation upgrades.
2.	Improve synchronize_rcu() diagnostics, courtesy of
	Frederic Weisbecker.
3.	Add lockdep-RCU checks for simple self deadlock, such as calling
	synchronize_rcu() while in an RCU read-side critical section.
4.	Add a diagnostic for misaligned rcu_head structures.  This is
	preparation for a call_rcu_lazy() for added energy efficiency.
5,14,36.
	Upgrades to CONFIG_RCU_FAST_NO_HZ.
6.	Move CONFIG_RCU_TRACE to lib/Kconfig.debug: not for production use.
7-11.	Convert several call_rcu() primitives to kfree_rcu().
12,13,15,16,37-39.
	Fixes to and streamlining of CPU-hotplug handling based on review.
17.	Remove dubious single-rcu_node optimization from rcu_start_gp().
18-22.	Apply prior rcutree fixes to rcutiny.
23.	Catch rcu_preempt_needs_cpu()'s name up with 2011.
24.	Check for idle-loop entry while in an RCU read-side critical section.
25.	Check for sleeping in TREE_RCU read-side critical sections.
27,35.	Remove "#ifdef CONFIG_SMP" from treercu, move code accordingly.
28.	Allow RCU CPU stall times to be adjusted at runtime via sysfs.
29.	Print scheduling-clock timer information on RCU CPU stall warning
	messages if requested by CONFIG_RCU_CPU_STALL_INFO config parameter.
30.	Allow rcutorture to be told to hold off CPU-hotplug operations during
	early boot.
31.	Allow rcutorture to generate CPU stalls in order to test RCU CPU
	stall warning facility.
33.	Silence module-parameter warnings by converting a couple of
	rcutorture's module parameters to bool.
34.	Check for illegal use of RCU from offlined CPUs.
41.	Fix misplaced NULL-pointer check in rcutorture.

For a testing-only version of this patchset from git, please see the
following subject-to-rebase branch:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/dev

							Thanx, Paul

------------------------------------------------------------------------

 Documentation/RCU/torture.txt      |   18 
 b/Documentation/RCU/RTFP.txt       | 1910 ++++++++++++++++++++++++++++++++++---
 b/Documentation/RCU/checklist.txt  |   14 
 b/Documentation/RCU/stallwarn.txt  |   85 +
 b/Documentation/RCU/torture.txt    |   15 
 b/Documentation/RCU/trace.txt      |   36 
 b/arch/s390/kernel/irq.c           |    9 
 b/drivers/target/tcm_fc/tfc_sess.c |   12 
 b/include/linux/rcupdate.h         |    2 
 b/include/linux/rcutiny.h          |    6 
 b/include/linux/rcutree.h          |    1 
 b/include/linux/sched.h            |    3 
 b/include/linux/srcu.h             |   11 
 b/include/trace/events/rcu.h       |   63 -
 b/init/Kconfig                     |    9 
 b/kernel/lockdep.c                 |    8 
 b/kernel/rcu.h                     |    4 
 b/kernel/rcupdate.c                |    5 
 b/kernel/rcutiny.c                 |    3 
 b/kernel/rcutiny_plugin.h          |    4 
 b/kernel/rcutorture.c              |    4 
 b/kernel/rcutree.c                 |    6 
 b/kernel/rcutree.h                 |    3 
 b/kernel/rcutree_plugin.h          |    3 
 b/kernel/rcutree_trace.c           |    8 
 b/kernel/srcu.c                    |    4 
 b/lib/Kconfig.debug                |    9 
 b/net/ipv4/cipso_ipv4.c            |   11 
 b/net/ipv4/ip_sockglue.c           |    7 
 b/net/mac80211/mesh_pathtbl.c      |    8 
 include/linux/rcupdate.h           |   40 
 include/linux/rcutiny.h            |    4 
 include/linux/rcutree.h            |   18 
 kernel/rcutiny.c                   |    4 
 kernel/rcutiny_plugin.h            |   72 +
 kernel/rcutorture.c                |   83 +
 kernel/rcutree.c                   |  641 ++++++++----
 kernel/rcutree.h                   |   24 
 kernel/rcutree_plugin.h            |  443 +++++---
 kernel/rcutree_trace.c             |    6 
 kernel/srcu.c                      |   27 
 lib/Kconfig.debug                  |   14 
 42 files changed, 2954 insertions(+), 703 deletions(-)

