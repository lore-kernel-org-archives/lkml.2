Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab0JVNF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:05:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:41817 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610Ab0JVNF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:05:27 -0400
Date: Fri, 22 Oct 2010 13:04:51 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101019134808.514465326@chello.nl>
References: <20101019134808.514465326@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Use NUMA aware allocations for PEBS/BTS/DS allocations
Message-ID: <tip-96681fc3c9e7d1f89ab64e5eec40b6467c97680f@git.kernel.org>
Git-Commit-ID: 96681fc3c9e7d1f89ab64e5eec40b6467c97680f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Oct 2010 13:04:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96681fc3c9e7d1f89ab64e5eec40b6467c97680f
Gitweb:     http://git.kernel.org/tip/96681fc3c9e7d1f89ab64e5eec40b6467c97680f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 19 Oct 2010 14:55:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Oct 2010 14:18:26 +0200

perf, x86: Use NUMA aware allocations for PEBS/BTS/DS allocations

For performance reasons its best to use memory node local memory for
per-cpu buffers.

This logic comes from a much larger patch proposed by Stephane.

Suggested-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Stephane Eranian <eranian@google.com>
LKML-Reference: <20101019134808.514465326@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 8a7f81c..b7dcd9f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -77,13 +77,14 @@ static void fini_debug_store_on_cpu(int cpu)
 static int alloc_pebs_buffer(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+	int node = cpu_to_node(cpu);
 	int max, thresh = 1; /* always use a single PEBS record */
 	void *buffer;
 
 	if (!x86_pmu.pebs)
 		return 0;
 
-	buffer = kzalloc(PEBS_BUFFER_SIZE, GFP_KERNEL);
+	buffer = kmalloc_node(PEBS_BUFFER_SIZE, GFP_KERNEL | __GFP_ZERO, node);
 	if (unlikely(!buffer))
 		return -ENOMEM;
 
@@ -114,13 +115,14 @@ static void release_pebs_buffer(int cpu)
 static int alloc_bts_buffer(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+	int node = cpu_to_node(cpu);
 	int max, thresh;
 	void *buffer;
 
 	if (!x86_pmu.bts)
 		return 0;
 
-	buffer = kzalloc(BTS_BUFFER_SIZE, GFP_KERNEL);
+	buffer = kmalloc_node(BTS_BUFFER_SIZE, GFP_KERNEL | __GFP_ZERO, node);
 	if (unlikely(!buffer))
 		return -ENOMEM;
 
@@ -150,9 +152,10 @@ static void release_bts_buffer(int cpu)
 
 static int alloc_ds_buffer(int cpu)
 {
+	int node = cpu_to_node(cpu);
 	struct debug_store *ds;
 
-	ds = kzalloc(sizeof(*ds), GFP_KERNEL);
+	ds = kmalloc_node(sizeof(*ds), GFP_KERNEL | __GFP_ZERO, node);
 	if (unlikely(!ds))
 		return -ENOMEM;
 
