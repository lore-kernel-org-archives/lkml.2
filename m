Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab2GYLyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:54:05 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:41838 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab2GYLyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:54:01 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH 0/6] CPU hotplug: Reverse invocation of notifiers during
 CPU hotplug
To: tglx@linutronix.de, mingo@kernel.org, peterz@infradead.org,
        rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, namhyung@kernel.org,
        tj@kernel.org
Cc: rjw@sisk.pl, srivatsa.bhat@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Jul 2012 17:23:28 +0530
Message-ID: <20120725115224.3900.80783.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12072511-3864-0000-0000-000003E866A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset implements the approach of invoking the CPU hotplug callbacks
(notifiers) in one order during CPU online and in the reverse order during CPU
offline. The rationale behind this is that services for a CPU are started in a
particular order (perhaps, with implicit dependencies between them) while
bringing up the CPU, and hence, it makes sense to tear down the services in
the opposite order, thereby honoring most of the dependencies automatically
(and also correctly). This is explained in more detail in Patch 6.

Patch 1 adds rcu primitives for traversing a linked list in reverse order.
Patch 2 converts the notifiers to a circular doubly linked list (in
preparation for the reverse invocation support).
Patch 3 adds helpers to invoke notifiers in the reverse order.
Patches 4 and 5 do the necessary prep work for moving over to the reverse
invocation model, by adjusting some of the callbacks/priorities as necessary.
Patch 6 does the final transition and invokes the notifiers in the reverse order
during CPU offline.

This patchset applies on top of:
1. Tejun's workqueue CPU hotplug patchset[1] merged with
2. Thomas Gleixner's park/unpark patchset with Paul McKenney's fixes which
   are available at [2].

References:
[1]. git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-wq-hotplug
[2]. git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/smp/hotplug

--
 Srivatsa S. Bhat (6):
      list, rcu: Introduce rcu version of reverse list traversal
      notifiers: Convert notifier chain to circular doubly linked-list
      notifiers: Add support for reverse invocation of notifier chains
      sched, cpuset: Prepare scheduler and cpuset CPU hotplug callbacks for reverse invocation
      sched, perf: Prepare migration and perf CPU hotplug callbacks for reverse invocation
      CPU hotplug: Invoke CPU offline notifiers in reverse order


  arch/mips/powertv/powertv_setup.c                |    2 
 arch/um/drivers/mconsole_kern.c                  |    2 
 arch/um/kernel/um_arch.c                         |    2 
 drivers/acpi/sleep.c                             |    2 
 drivers/char/ipmi/ipmi_msghandler.c              |    2 
 drivers/char/ipmi/ipmi_watchdog.c                |    4 
 drivers/firmware/dcdbas.c                        |    2 
 drivers/md/md.c                                  |    2 
 drivers/net/ethernet/intel/igb/igb_main.c        |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c    |    2 
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c |    2 
 drivers/staging/vt6655/device_main.c             |    2 
 include/linux/cpu.h                              |   40 +++--
 include/linux/notifier.h                         |   27 ++-
 include/linux/rculist.h                          |   46 ++++++
 kernel/cpu.c                                     |   34 +++-
 kernel/debug/debug_core.c                        |    2 
 kernel/notifier.c                                |  179 ++++++++++++++++------
 kernel/sched/core.c                              |  140 ++++++++++-------
 kernel/trace/trace.c                             |    2 
 kernel/workqueue.c                               |   30 +---
 mm/page-writeback.c                              |    2 
 mm/vmstat.c                                      |    4 
 23 files changed, 357 insertions(+), 175 deletions(-)



Thanks,
Srivatsa S. Bhat
IBM Linux Technology Center

