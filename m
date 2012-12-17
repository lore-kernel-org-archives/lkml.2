Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab2LQLvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 06:51:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271Ab2LQLvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 06:51:17 -0500
Date: Mon, 17 Dec 2012 12:51:04 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH RFC -tip 0/6] IRQ-bound performance events
Message-ID: <cover.1355744680.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset is against perf/core branch.

This is an an attempt to introduce IRQ-bound performance events -
ones that only count in a context of a hardware interrupt handler.
The aim is to measure events which can not be measured using
existing task-bound or CPU-bound counters (i.e. L1 cache-misses
of a particular hardware handler or its durability).

The implementation is pretty straightforward: an IRQ-bound event
is registered with the IRQ descriptor and gets enabled/disabled
using new PMU callbacks: pmu_enable_irq() and pmu_disable_irq().

The series has not been tested thoroughly and is a concept proof
rather than a decent implementation: no group events could be be
loaded, inappropriate (i.e. software) events are not rejected,
only Intel and AMD PMUs were tried for 'perf stat', only Intel
PMU works with precise events. Perf tool changes are just a hack.

Yet, I want first ensure if the taken approach is not screwed and
I did not miss anything vital.

Below is a sample session on a machine with x2apic in cluster mode.
IRQ number is passed using new argument -I <irq> (please nevermind
'...process id '8'...' in the output):

# cat /proc/irq/8/smp_affinity_list
0,4,8,12,16,20,24,28,32,36,40,44
# ./tools/perf/perf stat -a -e L1-dcache-load-misses:k sleep 1

 Performance counter stats for 'sleep 1':

           124,078 L1-dcache-load-misses                                       

       1.001464219 seconds time elapsed

# ./tools/perf/perf stat -I 8 -a -e L1-dcache-load-misses:k sleep 1

 Performance counter stats for process id '8':

                 0 L1-dcache-load-misses                                       

       1.001466384 seconds time elapsed

# ./tools/perf/perf stat -I 8 -a -e L1-dcache-load-misses:k hwclock --test
Mon 17 Dec 2012 03:24:05 AM EST  -0.500690 seconds

 Performance counter stats for process id '8':

               317 L1-dcache-load-misses                                       

       0.502153382 seconds time elapsed

# ./tools/perf/perf stat -I 8 -C 0 -e L1-dcache-load-misses:k hwclock --test
Mon 17 Dec 2012 03:30:36 AM EST  -0.078717 seconds

 Performance counter stats for process id '8':

                72 L1-dcache-load-misses                                       

       0.079948468 seconds time elapsed

Alexander Gordeev (6):
  perf/core: IRQ-bound performance events
  perf/x86: IRQ-bound performance events
  perf/x86/AMD PMU: IRQ-bound performance events
  perf/x86/Core PMU: IRQ-bound performance events
  perf/x86/Intel PMU: IRQ-bound performance events
  perf/tool: Hack 'pid' as 'irq' for sys_perf_event_open()

 arch/x86/kernel/cpu/perf_event.c          |   71 ++++++++++++++++++---
 arch/x86/kernel/cpu/perf_event.h          |   19 ++++++
 arch/x86/kernel/cpu/perf_event_amd.c      |    2 +
 arch/x86/kernel/cpu/perf_event_intel.c    |   93 +++++++++++++++++++++++++--
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    5 +-
 arch/x86/kernel/cpu/perf_event_knc.c      |    2 +
 arch/x86/kernel/cpu/perf_event_p4.c       |    2 +
 arch/x86/kernel/cpu/perf_event_p6.c       |    2 +
 include/linux/irq.h                       |    8 ++
 include/linux/irqdesc.h                   |    3 +
 include/linux/perf_event.h                |   16 +++++
 include/uapi/linux/perf_event.h           |    1 +
 kernel/events/core.c                      |   69 +++++++++++++++----
 kernel/irq/Makefile                       |    1 +
 kernel/irq/handle.c                       |    4 +
 kernel/irq/irqdesc.c                      |   14 ++++
 kernel/irq/perf_event.c                   |  100 +++++++++++++++++++++++++++++
 tools/perf/builtin-record.c               |    9 +++
 tools/perf/builtin-stat.c                 |   11 +++
 tools/perf/util/evlist.c                  |    4 +-
 tools/perf/util/evsel.c                   |    3 +
 tools/perf/util/evsel.h                   |    1 +
 tools/perf/util/target.c                  |    4 +
 tools/perf/util/thread_map.c              |   16 +++++
 24 files changed, 426 insertions(+), 34 deletions(-)
 create mode 100644 kernel/irq/perf_event.c

-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
