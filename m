Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab1LJX2o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 18:28:44 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36604 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1LJX2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 18:28:43 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@infradead.org,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com
Subject: [PATCH 0/4] perf_events: add support for Intel reference cycles event
Date: Sun, 11 Dec 2011 00:28:50 +0100
Message-Id: <1323559734-3488-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unhalted_reference_cycles is a very useful event which counts cycles at the
reference CPU clock speed (same as TSC if processors supports constant_tsc).
That means, it keeps a constant correlation with wall-clock time while the
processor is not halted, unlike its counter-part unhalted_core_cycles.
The latter event, used by generic PMU event cycles in the perf tool is
subject to frequency down-scaling AND Turbo mode fluctuations.

The unhlated_reference_cycles is NOT equivalent to wall clock time because
it counts only when the processor is not in halted state. But this limitation
impacts only system-wide measurements.

The unhalted_reference_cycles can only be counted on fixed counter 2.
As such, it does not have an event encoding. Fixed counters can only measure
one (hardwired) event. Yet, with perf_events user manipulates events and not
counters, thus each event needs an encoding. That encoding is then used by
the kernel to identify the event and schedule it on the proper counter.

Up until now, there was no encoding chosen for unhalted_reference_cycles, thus
it could not be scheduled properly and thus it was not supported.

This patch uses the encoding 0x0300. That means event code 0x00, umask 0x3.
That event code is not used by Intel on any existing processor. We have
also checked with Intel and it seems that they don't plan on using it in
the future.

With this patch, it is possible to see the effect of Turbo mode:

$ perf stat -e unhalted_reference_cycles,unhalted_core_cycles ./noploop 1
noploop for 1 seconds

Performance counter stats for './noploop 1':

3,197,640,960 unhalted_reference_cycles
3,595,043,997 unhalted_core_cycles

1.000732233  seconds time elapsed

Signed-off-by: Stephane Eranian <eranian@google.com>
---

Stephane Eranian (4):
  perf_events: enable raw event support for Intel
    unhalted_reference_cycles event
  perf_event: add PERF_COUNT_HW_REF_CPU_CYCLES generic PMU event
  perf_events: add Intel X86 mapping for PERF_COUNT_HW_REF_CPU_CYCLES
  perf: add support for PERF_HW_COUNT_REF_CPU_CYCLES

 arch/x86/include/asm/perf_event.h      |   15 ++++++++-------
 arch/x86/kernel/cpu/perf_event.c       |    8 +++++++-
 arch/x86/kernel/cpu/perf_event_intel.c |   16 ++++++----------
 include/linux/perf_event.h             |    1 +
 tools/perf/util/parse-events.c         |    2 ++
 5 files changed, 24 insertions(+), 18 deletions(-)

