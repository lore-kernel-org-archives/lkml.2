Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab0KUL70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 06:59:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:45503 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab0KUL7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 06:59:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,231,1288594800"; 
   d="scan'208";a="628865729"
Subject: [RFC PATCH 0/3 v2] perf: Add Intel Nehalem uncore pmu support
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Nov 2010 19:59:26 +0800
Message-Id: <1290340766.2245.121.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

Sorry for the late update, I was fixing some uncore NMI problem(see
below).
This v2 does not fully work yet, but it addresses most comments of v1.

FYI, below links are the entry for v1.
[DRAFT PATCH 0/3] perf: Add Intel Nehalem uncore pmu support
http://marc.info/?l=linux-kernel&m=128868293025309&w=2
http://marc.info/?l=linux-kernel&m=128868293025298&w=2
http://marc.info/?l=linux-kernel&m=128868296425366&w=2
http://marc.info/?l=linux-kernel&m=128868298125380&w=2

Applied on top of current tip/master(59c5300).

The main change is the uncore NMI handling code.
In the v1, I thought all the 4 cores will receive NMI when any uncore
counter overflows. So each core only handled the counters enabled by
itself in v1.
But actually only 1 of the 4 cores receives NMI each time, and we can't
determine which core receives it. So the NMI handler(running on 1 of the
4 cores) should handle all counters enabled by all 4 cores.

Changelogs of v2:

- modify the NMI handling code to handle all counters enabled by all 4
cores.

- allocate uncore_events[] table dynamically using kmalloc_node() to
avoid unnecessary remote memory accesses. (Stephane Eranian)

- add support for the fixed uncore counter. (Stephane Eranian)

- Handling of exclude_* bits. Uncore PMU measures at all privilege level
all the time. So it doesn't make sense to specify any exclude bits.
(Stephane Eranian)

- let uncore code be more self contained, that is, not include it in
arch/x86/kernel/cpu/perf_event.c (Peter Zijlstra)

- uncore pmu interrupt have its own NMI_DIE notifier entry. (Peter
Zijlstra)

Known bugs:

- When hyper thread is enabled, both HTs will receive the NMI. In this
case, the overflow status bits are not acked correctly.

TODO:

- per-task uncore event should not be allowed. Peter suggested simply
set pmu::task_ctx_nr = perf_invalid_context.

- This whole implementation is per-node, it should be converted to
per-socket. Andi Kleen has commented that using numa_node_id() implies
this implementation can't be used when NUMA is turned off. Better use
the package id.

- add support for uncore address/opcode match thing

As usual, any comment is very appreciated.

Lin Ming 

