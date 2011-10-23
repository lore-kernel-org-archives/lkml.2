Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab1JWP5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 11:57:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48754 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1JWP5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 11:57:42 -0400
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH v2 0/6] Reduce cross CPU IPI interference
Date: Sun, 23 Oct 2011 17:56:47 +0200
Message-Id: <1319385413-29665-1-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have lots of infrastructure in place to partition a multi-core system such
that we have a group of CPUs that are dedicated to specific task: cgroups,
scheduler and interrupt affinity and cpuisol boot parameter. Still, kernel
code will some time interrupt all CPUs in the system via IPIs for various
needs. These IPIs are useful and cannot be avoided altogether, but in certain
cases it is possible to interrupt only specific CPUs that have useful work to
do and not the entire system.

This patch set, inspired by discussions with Peter Zijlstra and Frederic
Weisbecker when testing the nohz task patch set, is a first stab at trying to
explore doing this by locating the places where such global IPI calls are
being made and turning a global IPI into an IPI for a specific group of CPUs.
The purpose of the patch set is to get  feedback if this is the right way to
go for dealing with this issue and indeed, if the issue is even worth dealing
with at all.

The patch creates an on_each_cpu_mask infrastructure API (derived from
existing arch specific versions in Tile and Arm) and uses it to turn two global
IPI invocation to per CPU group invocations.

This second version incorporates changes due to reviewers feedback and 
additional testing. The major changes from the previous version of the patch 
are:

- Better description for some of the patches with examples of what I am
  trying to solve.
- Better coding style for on_each_cpu based on review comments by Peter 
  Zijlstra and Sasha Levin.
- Fixed pcp_count handling to take into account which cpu the accounting 
  is done for. Sadly, AFAIK this negates using this_cpu_add/sub as 
  suggested by Peter Z.
- Removed kmalloc from the flush_all() path as per review comment by 
  Pekka Enberg.
- Moved cpumask allocations for CONFIG_CPUMASK_OFFSTACK=y to a point previous
  to first use during boot as testing revealed we no longer boot under 
  CONFIG_CPUMASK_OFFSTACK=y with original code.

The patch was compiled for arm and boot tested on x86 in UP, SMP, with and without 
CONFIG_CPUMASK_OFFSTACK and was further tested by running hackbench on x86 in 
SMP mode in a 4 CPUs VM for several hours with no obvious regressions.

I also artificially exercised SLUB flush_all via the debug interface and observed 
the difference in IPI count across processors  with and without the patch - from 
an IPI on all processors but one without the patch to a subset (and often no IPI 
at all) with the patch.


Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: linux-mm@kvack.org
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Pekka Enberg <penberg@kernel.org>
CC: Matt Mackall <mpm@selenic.com>
CC: Sasha Levin <levinsasha928@gmail.com>

Gilad Ben-Yossef (6):
  smp: Introduce a generic on_each_cpu_mask function
  arm: Move arm over to generic on_each_cpu_mask
  tile: Move tile to use generic on_each_cpu_mask
  mm: Only IPI CPUs to drain local pages if they exist
  slub: Only IPI CPUs that have per cpu obj to flush
  slub: only preallocate cpus_with_slabs if offstack

 arch/arm/kernel/smp_tlb.c   |   20 +++----------
 arch/tile/include/asm/smp.h |    7 -----
 arch/tile/kernel/smp.c      |   19 -------------
 include/linux/slub_def.h    |    9 ++++++
 include/linux/smp.h         |   16 +++++++++++
 kernel/smp.c                |   20 +++++++++++++
 mm/page_alloc.c             |   64 +++++++++++++++++++++++++++++++++++++------
 mm/slub.c                   |   61 +++++++++++++++++++++++++++++++++++++++-
 8 files changed, 164 insertions(+), 52 deletions(-)

