Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab2BDBpC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 20:45:02 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:35704 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab2BDBo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 20:44:59 -0500
Date: Fri, 3 Feb 2012 17:44:52 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/N] v2 RCU commits for 3.4
Message-ID: <20120204014452.GA29811@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020401-4242-0000-0000-000000AEC588
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This is v2 of this patchset.  Earlier versions may be found at
https://lkml.org/lkml/2012/2/1/354 and https://lkml.org/lkml/2012/2/2/575.
A big "thank you" to all the reviewers, particularly Josh Triplett, for the
excellent feedback.

This patchset makes RCU more aggressive about entering dyntick-idle mode
in order to improve energy efficiency, converts a few more call_rcu()s to
kfree_rcu(), applies a number of rcutree fixes and cleanups to rcutiny,
removes CONFIG_SMP #ifdef from treercu, allows RCU CPU stall times to
be set via sysfs, add CPU-stall capability to rcutorture, adds more
RCU-abuse diagnostics, updates documentation, and yet more fixes from
the still-ongoing top-to-bottom inspection of RCU with a special focus
on the CPU-hotplug code path.  The patches are as follows:

1,26,31,33,41,40.
	Documentation upgrades.
2.	Improve synchronize_rcu() diagnostics, courtesy of
	Frederic Weisbecker.
3.	Add lockdep-RCU checks for simple self deadlock, such as calling
	synchronize_rcu() while in an RCU read-side critical section.
4.	Add a diagnostic for misaligned rcu_head structures.  This is
	preparation for a call_rcu_lazy() for added energy efficiency.
5,14,37.
	Upgrades to CONFIG_RCU_FAST_NO_HZ.
6.	Move CONFIG_RCU_TRACE to lib/Kconfig.debug: not for production use.
7-11.	Convert several call_rcu() primitives to kfree_rcu().
12,13,15,16,35,38,39.
	Fixes to and streamlining of CPU-hotplug handling based on review.
17.	Remove dubious single-rcu_node optimization from rcu_start_gp().
18-22.	Apply prior rcutree fixes to rcutiny.
23.	Catch rcu_preempt_needs_cpu()'s name up with 2011.
24.	Check for idle-loop entry while in an RCU read-side critical section.
25.	Check for sleeping in TREE_RCU read-side critical sections.
27,36.	Remove "#ifdef CONFIG_SMP" from treercu, move code accordingly.
28.	Allow RCU CPU stall times to be adjusted at runtime via sysfs.
29.	Print scheduling-clock timer information on RCU CPU stall warning
	messages if requested by CONFIG_RCU_CPU_STALL_INFO config parameter.
30.	Allow rcutorture to be told to hold off CPU-hotplug operations during
	early boot.
32.	Allow rcutorture to generate CPU stalls in order to test RCU CPU
	stall warning facility.
34.	Silence module-parameter warnings by converting a couple of
	rcutorture's module parameters to bool.
41.	Fix misplaced NULL-pointer check in rcutorture.
42.	Convert WARN_ON_ONCE() in rcu_lock_acquire() to lockdep, in
	part courtesy of Heiko Carstens.
43.	Fix botched PTR_ERR() call, courtesy of Julia Lawall.
44.	Remove now-redundant check for rcu_head misalignment.
45-47.	Fix incorrect uses of RCU from the idle loop.  Note that patch
	47 will likely be replaced by some event-tracing upgrades from
	Steven Rostedt.

For a testing-only version of this patchset from git, please see the
following subject-to-rebase branch:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next

							Thanx, Paul

------------------------------------------------------------------------

 Documentation/RCU/torture.txt      |   20 
 b/Documentation/RCU/RTFP.txt       | 1902 +++++++++++++++++++++++++++++++++----
 b/Documentation/RCU/checklist.txt  |   14 
 b/Documentation/RCU/stallwarn.txt  |   87 +
 b/Documentation/RCU/torture.txt    |   13 
 b/Documentation/RCU/trace.txt      |   36 
 b/arch/s390/kernel/irq.c           |    9 
 b/drivers/cpuidle/cpuidle.c        |   12 
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
 b/kernel/rcutiny.c                 |    4 
 b/kernel/rcutiny_plugin.h          |    5 
 b/kernel/rcutorture.c              |    4 
 b/kernel/rcutree.c                 |    8 
 b/kernel/rcutree.h                 |    3 
 b/kernel/rcutree_plugin.h          |    4 
 b/kernel/rcutree_trace.c           |    8 
 b/kernel/srcu.c                    |    6 
 b/lib/Kconfig.debug                |   10 
 b/net/ipv4/cipso_ipv4.c            |   11 
 b/net/ipv4/ip_sockglue.c           |    7 
 b/net/mac80211/mesh_pathtbl.c      |    8 
 include/linux/rcupdate.h           |   81 +
 include/linux/rcutiny.h            |    4 
 include/linux/rcutree.h            |   18 
 include/linux/srcu.h               |    4 
 kernel/rcu.h                       |   22 
 kernel/rcutiny.c                   |   22 
 kernel/rcutiny_plugin.h            |   72 +
 kernel/rcutorture.c                |   91 +
 kernel/rcutree.c                   |  661 ++++++++----
 kernel/rcutree.h                   |   24 
 kernel/rcutree_plugin.h            |  443 +++++---
 kernel/rcutree_trace.c             |    6 
 kernel/srcu.c                      |   27 
 lib/Kconfig.debug                  |   14 
 45 files changed, 3055 insertions(+), 729 deletions(-)

