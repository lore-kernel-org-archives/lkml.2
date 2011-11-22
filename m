Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab1KVLJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:09:39 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38576 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab1KVLJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:09:38 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH v4 0/5] Reduce cross CPU IPI interference
Date: Tue, 22 Nov 2011 13:08:43 +0200
Message-Id: <1321960128-15191-1-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have lots of infrastructure in place to partition a multi-core system such that we have a group of CPUs that are dedicated to specific task: cgroups, scheduler and interrupt affinity and cpuisol boot parameter. Still, kernel code will some time interrupt all CPUs in the system via IPIs for various needs. These IPIs are useful and cannot be avoided altogether, but in certain cases it is possible to interrupt only specific CPUs that have useful work to
do and not the entire system.

This patch set, inspired by discussions with Peter Zijlstra and Frederic Weisbecker when testing the nohz task patch set, is a first stab at trying to explore doing this by locating the places where such global IPI calls are being made and turning a global IPI into an IPI for a specific group of CPUs.  The purpose of the patch set is to get feedback if this is the right way to go for dealing with this issue and indeed, if the issue is even worth dealing with at all. Based on the feedback from this patch set I plan to offer further patches that address similar issue in other code paths.

The patch creates an on_each_cpu_mask infrastructure API (derived from existing arch specific versions in Tile and Arm) and uses it to turn two global
IPI invocation to per CPU group invocations.

This 4rd version incorporates three efficiency and code style changes based on Christoph L. feedback. 

- Remove un-needed check for per cpu cpu_slab pointer.
  It is guranteed to always be there.

- Renamed pageset variable to pcp to match code style.

- Itereate on cpus first, then zones in the inner loop
  This has a chance to have us better memory locality and so a better cache access pattern.

The patch was compiled for arm and boot tested on x86 in UP, SMP, with and without
CONFIG_CPUMASK_OFFSTACK and was further tested by running hackbench on x86 in
SMP mode in a 4 CPUs VM with no obvious regressions.

I also artificially exercised SLUB flush_all via the debug interface and observed
the difference in IPI count across processors with and without the patch - from
an IPI on all processors but one without the patch to a subset (and often no IPI
at all) with the patch.

I further used fault injection framework to force cpumask alloction failures for
CPUMASK_OFFSTACK=y cases and triggering the code using slub sys debug interface
and running ./hackbench 1000 for page_alloc, with no critical failures.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Chris Metcalf <cmetcalf@tilera.com>
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: linux-mm@kvack.org
CC: Pekka Enberg <penberg@kernel.org>
CC: Matt Mackall <mpm@selenic.com>
CC: Sasha Levin <levinsasha928@gmail.com>
CC: Rik van Riel <riel@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>

Gilad Ben-Yossef (5):
  smp: Introduce a generic on_each_cpu_mask function
  arm: Move arm over to generic on_each_cpu_mask
  tile: Move tile to use generic on_each_cpu_mask
  slub: Only IPI CPUs that have per cpu obj to flush
  mm: Only IPI CPUs to drain local pages if they exist

 arch/arm/kernel/smp_tlb.c   |   20 +++++---------------
 arch/tile/include/asm/smp.h |    7 -------
 arch/tile/kernel/smp.c      |   19 -------------------
 include/linux/smp.h         |   16 ++++++++++++++++
 kernel/smp.c                |   20 ++++++++++++++++++++
 mm/page_alloc.c             |   18 +++++++++++++++++-
 mm/slub.c                   |   15 ++++++++++++++-
 7 files changed, 72 insertions(+), 43 deletions(-)

