Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab0JVNDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:03:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:40353 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677Ab0JVNDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:03:22 -0400
Date: Fri, 22 Oct 2010 13:02:33 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101019134808.196793164@chello.nl>
References: <20101019134808.196793164@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Extract PEBS/BTS buffer free routines
Message-ID: <tip-b39f88acd7d989b6b247ba87c480fc24ed71d9c5@git.kernel.org>
Git-Commit-ID: b39f88acd7d989b6b247ba87c480fc24ed71d9c5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Oct 2010 13:02:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b39f88acd7d989b6b247ba87c480fc24ed71d9c5
Gitweb:     http://git.kernel.org/tip/b39f88acd7d989b6b247ba87c480fc24ed71d9c5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 19 Oct 2010 14:08:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Oct 2010 14:18:24 +0200

perf, x86: Extract PEBS/BTS buffer free routines

So that we may grow additional call-sites..

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Stephane Eranian <eranian@google.com>
LKML-Reference: <20101019134808.196793164@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   30 ++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 4977f9c..1bc1351 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -74,6 +74,28 @@ static void fini_debug_store_on_cpu(int cpu)
 	wrmsr_on_cpu(cpu, MSR_IA32_DS_AREA, 0, 0);
 }
 
+static void release_pebs_buffer(int cpu)
+{
+	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+
+	if (!ds || !x86_pmu.pebs)
+		return;
+
+	kfree((void *)(unsigned long)ds->pebs_buffer_base);
+	ds->pebs_buffer_base = 0;
+}
+
+static void release_bts_buffer(int cpu)
+{
+	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+
+	if (!ds || !x86_pmu.bts)
+		return;
+
+	kfree((void *)(unsigned long)ds->bts_buffer_base);
+	ds->bts_buffer_base = 0;
+}
+
 static void release_ds_buffers(void)
 {
 	int cpu;
@@ -82,7 +104,6 @@ static void release_ds_buffers(void)
 		return;
 
 	get_online_cpus();
-
 	for_each_online_cpu(cpu)
 		fini_debug_store_on_cpu(cpu);
 
@@ -92,13 +113,12 @@ static void release_ds_buffers(void)
 		if (!ds)
 			continue;
 
-		per_cpu(cpu_hw_events, cpu).ds = NULL;
+		release_pebs_buffer(cpu);
+		release_bts_buffer(cpu);
 
-		kfree((void *)(unsigned long)ds->pebs_buffer_base);
-		kfree((void *)(unsigned long)ds->bts_buffer_base);
+		per_cpu(cpu_hw_events, cpu).ds = NULL;
 		kfree(ds);
 	}
-
 	put_online_cpus();
 }
 
