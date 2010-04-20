Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab0DTVoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 17:44:38 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47415 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab0DTVoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 17:44:37 -0400
Date: Tue, 20 Apr 2010 14:44:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH tip/core/rcu 0/23] v3 patches queued for 2.6.35
Message-ID: <20100420214431.GA20777@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

RFC preview of RCU patches queued for 2.6.35, take 3, now ready for
-tip inclusion.  Take 2 is at http://lkml.org/lkml/2010/4/15/324.
Changes to old patches noted in "[]", new patches flagged with "New".

 1.	substitute set_need_resched for sending resched IPIs
 	This reduces OS jitter.

 2.	make dead code really dead.
 3.	move some code from macro to function
 	Cleanups from Lai Jiangshan.

 4.	ignore offline CPUs in last non dyntick idle CPU check
 	Fix to my CONFIG_RCU_FAST_NO_HZ code to handle offline and
	non-existent CPUs, also from Lai Jiangshan.

 5.	fix bogus CONFIG_PROVE_LOCKING in comments to reality
 6.	fix now bogus rcu_scheduler_active comments
 	Comment fixups.

 7.	shrink rcutiny by making synchronize_rcu_bh be inline
 	Shrink TINY_RCU some more.

 8.	rename rcutiny rcu_ctrlblk to rcu_sched_ctrlblk
 	First step towards TINY_PREEMPTIBLE_RCU.

 9.	refactor RCU's context switch handling
 	Reduce the number of needless softirqs.

10.	slim down rcutiny by removing rcu_scheduler_active and friends
	More shrinkage for TINY_RCU

11.	enable CPU_STALL_VERBOSE by default.  It will have been in one
	release, so time to enable it.

12.	disable CPU stall warnings upon panic

13.	print boot-time console messages if RCU configs out of ordinary

14.	improve RCU CPU stall-warning messages

15.	permit discontiguous cpu_possible_mask CPU numbering

16.	v2: reduce the number of spurious RCU_SOFTIRQ invocations
	[Original from Lai Jiangshan]

17.	New: improve the RCU CPU-stall-warning documentation

18.	New: debugobjects transition check
19.	New: introduce rcu_head_init_on_stack
20.	New: remove all non-on-stack rcu_head initializations
21.	New: remove rcu_head initializers
22.	New: Add debug RCU head objects
	Debug-objects-based rcu_head checking from Mathieu Desnoyers

23.	New: make SRCU usable in modules
	[From Lai Jiangshan]

							Thanx, Paul

 b/Documentation/RCU/stallwarn.txt             |   94 ++++++++++++----
 b/Documentation/RCU/trace.txt                 |   35 +++---
 b/arch/powerpc/mm/pgtable.c                   |    1 
 b/block/cfq-iosched.c                         |    1 
 b/block/genhd.c                               |    1 
 b/drivers/staging/batman-adv/hard-interface.c |    1 
 b/fs/file.c                                   |    3 
 b/fs/fs-writeback.c                           |   31 ++++-
 b/fs/partitions/check.c                       |    1 
 b/include/linux/debugobjects.h                |   11 +
 b/include/linux/init_task.h                   |    1 
 b/include/linux/rcupdate.h                    |   15 +-
 b/include/linux/rcutiny.h                     |   12 +-
 b/include/linux/rcutree.h                     |    2 
 b/include/linux/srcu.h                        |    4 
 b/kernel/rcupdate.c                           |   19 ---
 b/kernel/rcutiny.c                            |    9 -
 b/kernel/rcutiny_plugin.h                     |   39 ++++++
 b/kernel/rcutorture.c                         |    2 
 b/kernel/rcutree.c                            |   10 +
 b/kernel/rcutree.h                            |    1 
 b/kernel/rcutree_plugin.h                     |    2 
 b/kernel/rcutree_trace.c                      |    4 
 b/kernel/sched.c                              |    2 
 b/kernel/softirq.c                            |    2 
 b/lib/Kconfig.debug                           |    2 
 b/lib/debugobjects.c                          |   59 +++++++++-
 b/mm/backing-dev.c                            |    1 
 b/mm/slob.c                                   |    1 
 b/security/selinux/avc.c                      |    1 
 b/security/selinux/netnode.c                  |    2 
 include/linux/rcupdate.h                      |   75 ++++++++++---
 include/linux/rcutiny.h                       |   17 ++
 include/linux/rcutree.h                       |    4 
 include/linux/srcu.h                          |    2 
 kernel/rcupdate.c                             |  149 ++++++++++++++++++++++++++
 kernel/rcutiny.c                              |   28 +++-
 kernel/rcutree.c                              |  127 +++++++++++++++-------
 kernel/rcutree.h                              |    1 
 kernel/rcutree_plugin.h                       |   55 ++++++++-
 lib/Kconfig.debug                             |    6 +
 41 files changed, 669 insertions(+), 164 deletions(-)
