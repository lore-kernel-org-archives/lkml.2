Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab0DOSNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:13:06 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41983 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019Ab0DOSND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:13:03 -0400
Date: Thu, 15 Apr 2010 11:12:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH tip/core/rcu 0/16] rcu: v2 patches queued for 2.6.35
Message-ID: <20100415181255.GA19588@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

RFC preview of RCU patches queued for 2.6.35, take 2.  Take 1 is at
http://lkml.org/lkml/2010/4/5/134.  Changes to old patches noted in
"[]", new patches flagged with "New".

 1.	substitute set_need_resched for sending resched IPIs
 	This reduces OS jitter.

 2.	make dead code really dead.  [Updated commit message as suggested
 	by Mathieu Desnoyers.]
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

11.	New: enable CPU_STALL_VERBOSE by default.  It will have been in one
	release, so time to enable it.

12.	New: disable CPU stall warnings upon panic

13.	New: print boot-time console messages if RCU configs out of ordinary

14.	New: improve RCU CPU stall-warning messages

15.	New: permit discontiguous cpu_possible_mask CPU numbering

16.	New: v2: reduce the number of spurious RCU_SOFTIRQ invocations

							Thanx, Paul


 b/Documentation/RCU/trace.txt |   35 ++++++------
 b/include/linux/rcupdate.h    |   15 ++---
 b/include/linux/rcutiny.h     |   12 +++-
 b/include/linux/rcutree.h     |    2 
 b/include/linux/srcu.h        |    4 -
 b/kernel/rcupdate.c           |   19 ------
 b/kernel/rcutiny.c            |    9 ---
 b/kernel/rcutiny_plugin.h     |   39 +++++++++++++
 b/kernel/rcutree.c            |   10 +++
 b/kernel/rcutree.h            |    1 
 b/kernel/rcutree_plugin.h     |    2 
 b/kernel/rcutree_trace.c      |    4 +
 b/kernel/sched.c              |    2 
 b/kernel/softirq.c            |    2 
 b/lib/Kconfig.debug           |    2 
 include/linux/rcupdate.h      |   12 +---
 include/linux/rcutiny.h       |   17 +++++
 include/linux/rcutree.h       |    4 +
 kernel/rcutiny.c              |   20 ++++--
 kernel/rcutree.c              |  121 +++++++++++++++++++++++++++++-------------
 kernel/rcutree.h              |    1 
 kernel/rcutree_plugin.h       |   55 +++++++++++++++++--
 22 files changed, 275 insertions(+), 113 deletions(-)
