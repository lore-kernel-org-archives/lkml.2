Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab2AZKC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 05:02:56 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33004 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2AZKCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 05:02:54 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, Christoph Lameter <cl@linux.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Subject: [v7 0/8] Reduce cross CPU IPI interference
Date: Thu, 26 Jan 2012 12:01:53 +0200
Message-Id: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have lots of infrastructure in place to partition multi-core systems
such that we have a group of CPUs that are dedicated to specific task:
cgroups, scheduler and interrupt affinity, and cpuisol= boot parameter.
Still, kernel code will at times interrupt all CPUs in the system via IPIs
for various needs. These IPIs are useful and cannot be avoided altogether,
but in certain cases it is possible to interrupt only specific CPUs that
have useful work to do and not the entire system.

This patch set, inspired by discussions with Peter Zijlstra and Frederic
Weisbecker when testing the nohz task patch set, is a first stab at trying
to explore doing this by locating the places where such global IPI calls
are being made and turning the global IPI into an IPI for a specific group
of CPUs.  The purpose of the patch set is to get feedback if this is the
right way to go for dealing with this issue and indeed, if the issue is
even worth dealing with at all. Based on the feedback from this patch set
I plan to offer further patches that address similar issue in other code
paths.

The patch creates an on_each_cpu_mask and on_each_cpu_cond infrastructure
API (the former derived from existing arch specific versions in Tile and
Arm) and uses them to turn several global IPI invocation to per CPU
group invocations.

This 7th iteration includes the following changes, all based on feedback 
from Milton Miller:

- Use a static cpumask_t to track CPUs with pcps in drain_all_pages.
- Fix logic bug sending an IPI based on state of pcps in last zone only
  (and re-run tests to make sure we still see the benefits).
- Use bool and smp_call_func_t for on_each_cpu_cond prototype.
- Accept a GFP flags parameters by on_each_cpu_cond for cpumask allocation.
- Disable preemption around for_each_online_cpu in on_each_cpu_cond to avoid.
  racing with hotplug events.
- Use bool and smp_call_func_t for n_each_cpu_mask prototype.
- Multiple documentation and description fixes and improvements.

The patch set also available from the ipi_noise_v7 branch at
git://github.com/gby/linux.git

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Christoph Lameter <cl@linux.com>
CC: Chris Metcalf <cmetcalf@tilera.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-mm@kvack.org
CC: Pekka Enberg <penberg@kernel.org>
CC: Matt Mackall <mpm@selenic.com>
CC: Sasha Levin <levinsasha928@gmail.com>
CC: Rik van Riel <riel@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: Avi Kivity <avi@redhat.com>
CC: Michal Nazarewicz <mina86@mina86.com>
CC: Kosaki Motohiro <kosaki.motohiro@gmail.com>
CC: Milton Miller <miltonm@bga.com>

Gilad Ben-Yossef (8):
  smp: introduce a generic on_each_cpu_mask function
  arm: move arm over to generic on_each_cpu_mask
  tile: move tile to use generic on_each_cpu_mask
  smp: add func to IPI cpus based on parameter func
  slub: only IPI CPUs that have per cpu obj to flush
  fs: only send IPI to invalidate LRU BH when needed
  mm: only IPI CPUs to drain local pages if they exist
  mm: add vmstat counters for tracking PCP drains

 arch/arm/kernel/smp_tlb.c     |   20 ++-------
 arch/tile/include/asm/smp.h   |    7 ---
 arch/tile/kernel/smp.c        |   19 ---------
 fs/buffer.c                   |   15 +++++++-
 include/linux/smp.h           |   41 +++++++++++++++++++
 include/linux/vm_event_item.h |    1 +
 kernel/smp.c                  |   87 +++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c               |   36 ++++++++++++++++-
 mm/slub.c                     |   10 ++++-
 mm/vmstat.c                   |    2 +
 10 files changed, 194 insertions(+), 44 deletions(-)

