Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab2LBSo7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 13:44:59 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45147 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab2LBSow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 13:44:52 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 25/52] sched, numa: Improve the CONFIG_NUMA_BALANCING help text
Date: Sun,  2 Dec 2012 19:43:17 +0100
Message-Id: <1354473824-19229-26-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354473824-19229-1-git-send-email-mingo@kernel.org>
References: <1354473824-19229-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add information about cost, type of optimizations, etc.,
so that the user knows what to expect.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 init/Kconfig | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 37cd8d6..018c8af 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -721,13 +721,42 @@ config ARCH_USES_NUMA_PROT_NONE
 	depends on NUMA_BALANCING
 
 config NUMA_BALANCING
-	bool "Memory placement aware NUMA scheduler"
+	bool "NUMA-optimizing scheduler"
 	default n
 	depends on ARCH_SUPPORTS_NUMA_BALANCING
 	depends on !ARCH_WANT_NUMA_VARIABLE_LOCALITY
 	depends on SMP && NUMA && MIGRATION
 	help
-	  This option adds support for automatic NUMA aware memory/task placement.
+	  This option enables NUMA-aware, transparent, automatic
+	  placement optimizations of memory, tasks and task groups.
+
+	  The optimizations work by (transparently) runtime sampling the
+	  workload sharing relationship between threads and processes
+	  of long-run workloads, and scheduling them based on these
+	  measured inter-task relationships (or the lack thereof).
+
+	  ("Long-run" means several seconds of CPU runtime at least.)
+
+	  Tasks that predominantly perform their own processing, without
+	  interacting with other tasks much will be independently balanced
+	  to a CPU and their working set memory will migrate to that CPU/node.
+
+	  Tasks that share a lot of data with each other will be attempted to
+	  be scheduled on as few nodes as possible, with their memory
+	  following them there and being distributed between those nodes.
+
+	  This optimization can improve the performance of long-run CPU-bound
+	  workloads by 10% or more. The sampling and migration has a small
+	  but nonzero cost, so if your NUMA workload is already perfectly
+	  placed (for example by use of explicit CPU and memory bindings,
+	  or because the stock scheduler does a good job already) then you
+	  probably don't need this feature.
+
+	  [ On non-NUMA systems this feature will not be active. You can query
+	    whether your system is a NUMA system via looking at the output of
+	    "numactl --hardware". ]
+
+	  Say N if unsure.
 
 menuconfig CGROUPS
 	boolean "Control Group support"
-- 
1.7.11.7

