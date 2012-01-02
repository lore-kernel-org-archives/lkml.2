Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab2ABKZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 05:25:13 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55270 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2ABKZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 05:25:10 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v5 0/8] Reduce cross CPU IPI interference
Date: Mon,  2 Jan 2012 12:24:11 +0200
Message-Id: <1325499859-2262-1-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have lots of infrastructure in place to partition a multi-core systems
such that we have a group of CPUs that are dedicated to specific task: 
cgroups, scheduler and interrupt affinity and cpuisol boot parameter. 
Still, kernel code will some time interrupt all CPUs in the system via IPIs 
for various needs. These IPIs are useful and cannot be avoided altogether, 
but in certain cases it is possible to interrupt only specific CPUs that 
have useful work to do and not the entire system.

This patch set, inspired by discussions with Peter Zijlstra and Frederic 
Weisbecker when testing the nohz task patch set, is a first stab at trying 
to explore doing this by locating the places where such global IPI calls 
are being made and turning a global IPI into an IPI for a specific group 
of CPUs.  The purpose of the patch set is to get feedback if this is the 
right way to go for dealing with this issue and indeed, if the issue is 
even worth dealing with at all. Based on the feedback from this patch set 
I plan to offer further patches that address similar issue in other code 
paths.

The patch creates an on_each_cpu_mask infrastructure API (derived from 
existing arch specific versions in Tile and Arm) and service wrappers 
and uses them to turn several  global IPI invocation to per CPU group 
invocations.

This 5th iteration includes the following changes:

- Abstract away the common boilerplate as on_each_cpu_cond wrapper 
  function and make all the places use it.
- Move the page_alloc.c/drain_all_pages to use a static global
  cpumask to avoid adding an allocation in the direct reclaim
  path, based on feedback and suggestion by Mel Gorman and Chris
  Metcalf.
- Add an optional patch to add vmstat counters to per-cpu page
  drain request and the upside to using this patch, based on 
  Mel Gorman idea.
- Provide the same treatment to yet another call site - this time
  the local LRU BH invalidation.

The patch was compiled for arm and boot tested on x86 in UP, SMP, with and without
CONFIG_CPUMASK_OFFSTACK and was further tested by running hackbench on x86 in
SMP mode in a 4 CPUs VM with no obvious regressions.

I also artificially exercised SLUB flush_all via the debug interface and observed
the difference in IPI count across processors with and without the patch - from
an IPI on all processors but one without the patch to a subset (and often no IPI
at all) with the patch.

I further used fault injection framework to force cpumask alloction failures for
CPUMASK_OFFSTACK=y cases and triggering the code using slub sys debug interface,
as well as running ./hackbench 400 for page_alloc, with no obvious falilures.

Gilad Ben-Yossef (8):
  smp: Introduce a generic on_each_cpu_mask function
  arm: Move arm over to generic on_each_cpu_mask
  tile: Move tile to use generic on_each_cpu_mask
  smp: Add func to IPI cpus based on parameter func
  slub: Only IPI CPUs that have per cpu obj to flush
  fs: only send IPI to invalidate LRU BH when needed
  mm: Only IPI CPUs to drain local pages if they exist
  mm: add vmstat counters for tracking PCP drains

 arch/arm/kernel/smp_tlb.c     |   20 ++++-------------
 arch/tile/include/asm/smp.h   |    7 ------
 arch/tile/kernel/smp.c        |   19 ----------------
 fs/buffer.c                   |   15 ++++++++++++-
 include/linux/smp.h           |   32 +++++++++++++++++++++++++++
 include/linux/vm_event_item.h |    1 +
 kernel/smp.c                  |   47 +++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c               |   30 +++++++++++++++++++++++++-
 mm/slub.c                     |   10 +++++++-
 mm/vmstat.c                   |    2 +
 10 files changed, 139 insertions(+), 44 deletions(-)

