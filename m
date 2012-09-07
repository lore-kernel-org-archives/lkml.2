Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab2IGObU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:31:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44620 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933283Ab2IGObQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:31:16 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com, robert.richter@amd.com
Subject: [PATCH 0/3] perf: use hrtimer for event multiplexing
Date: Fri,  7 Sep 2012 16:29:26 +0200
Message-Id: <1347028169-1983-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current scheme of using the timer tick was fine
for per-thread events. However, it was causing
bias issues in system-wide mode (including for
uncore PMUs). Event groups would not get their
fair share of runtime on the PMU. With tickless
kernels, if a core is idle there is no timer tick,
and thus no event rotation (multiplexing). However,
there are events (especially uncore events) which do
count even though cores are asleep.

This patch changes the timer source for multiplexing.
It introduces a per-cpu hrtimer. The advantage is that
even when the core goes idle, it will come back to
service the hrtimer, thus multiplexing on system-wide
events works much better.

In order to minimize the impact of the hrtimer, it
is turned on and off on demand. When the PMU on
a CPU is overcommited, the hrtimer is activated.
It is stopped when the PMU is not overcommitted.

In order for this to work properly with HOTPLUG_CPU,
we had to change the order of initialization in
start_kernel() such that hrtimer_init() is run
before perf_event_init().

The second patch provide a sysctl control to
adjust the multiplexing interval. Unit is
milliseconds.

Here is a simple before/after example with
two event groups which do require multiplexing.
This is done in system-wide mode on an idle
system. What matters here is the scaling factor
in [] in not the total counts.

Before:

# perf stat -a -e ref-cycles,ref-cycles sleep 10
 Performance counter stats for 'sleep 10':
 34,319,545 ref-cycles  [56.51%]
 31,917,229 ref-cycles  [43.50%]

 10.000827569 seconds time elapsed

After:
# perf stat -a -e ref-cycles,ref-cycles sleep 10
 Performance counter stats for 'sleep 10':
 11,144,822,193 ref-cycles [50.00%]
 11,103,760,513 ref-cycles [50.00%]

 10.000672946 seconds time elapsed

Signed-off-by: Stephane Eranian <eranian@google.com>
---

Stephane Eranian (3):
  perf: use hrtimer for event multiplexing
  perf: add sysctl control to adjust multiplexing interval
  perf: remove jiffies_interval

 include/linux/perf_event.h |    6 ++-
 init/main.c                |    2 +-
 kernel/events/core.c       |  155 +++++++++++++++++++++++++++++++++++++++++---
 kernel/sysctl.c            |    8 ++
 4 files changed, 160 insertions(+), 11 deletions(-)

-- 
1.7.5.4

