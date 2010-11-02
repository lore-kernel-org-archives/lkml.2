Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab0KBH2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 03:28:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:46879 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756277Ab0KBH22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 03:28:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,279,1286175600"; 
   d="scan'208";a="673318037"
Subject: [DRAFT PATCH 0/3] perf: Add Intel Nehalem uncore pmu support
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Stephane Eranian <eranian@google.com>, robert.richter@amd.com,
        Cyrill Gorcunov <gorcunov@gmail.com>, paulus@samba.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        CoreyAshford <cjashfor@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 15:27:38 +0800
Message-ID: <1288682858.12061.105.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

Here is the draft patch to add Intel Nehalem uncore pmu support.
It's not fully functional, but I threw it out early to get comments.

For the background of Nehalem uncore pmu, see Intel SDM Volume 3B
"30.6.2 Performance Monitoring Facility in the Uncore"

1. data structure

struct node_hw_events {
        struct perf_event *events[UNCORE_NUM_COUNTERS];
        int n_events;
        struct spinlock lock;
        int enabled;
};

struct node_hw_events is the per node structure.
"lock" protects add/delete events to uncore pmu.

struct uncore_cpu_hw_events {
        unsigned long active_mask[BITS_TO_LONGS(UNCORE_NUM_COUNTERS)];
};

struct uncore_cpu_hw_events is the per logical cpu structure.
"active_mask" represents the counters used by the cpu.
For example, if bit 3, 6 are set for cpuX, then it means uncore counter
3 and 6 are used by cpuX.

2. Uncore pmu NMI handling

Every core in the socket can be programmed to receive uncore counter
overflow interrupt.

In this draft implementation, each core handles the overflow interrupt
caused by the counters with bit set in "active_mask".

3. perf tool update

In this draft, the uncore events are monitored with raw events with "ru"
prefix("u" for uncore).

./perf stat -e ru0101 -- ls

Performance counter stats for 'ls':

             795920  raw 0x101               

        0.002110130  seconds time elapsed

4. Issues

How to eliminate the duplicate counter values accumulated by multi child
processes on the same socket?

perf stat -e ru0101 -- make -j4

Assume the 4 "make" child processes are running on the same socket and
counting uncore raw event "0101", and the counter value read by them are
val0, val1, val2, val3.

Then the final counter result given by "perf stat" will be "val0 + val1
+ val2 + val3".

But this is obvious wrong, because the uncore counter is shared by all
cores in the socket, so the final result should not be accumulated.

Any comment is very appreciated.

 arch/x86/include/asm/msr-index.h              |    1 +
 arch/x86/kernel/cpu/perf_event.c              |   30 ++-
 arch/x86/kernel/cpu/perf_event_intel.c        |    4 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  280 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |   80 +++++++
 arch/x86/kernel/cpu/perf_event_p4.c           |    2 +-
 include/linux/perf_event.h                    |    1 +
 tools/perf/util/parse-events.c                |   14 +-
 8 files changed, 394 insertions(+), 18 deletions(-)


Thanks,
Lin Ming



