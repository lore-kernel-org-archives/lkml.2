Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab0JVNDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:03:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:40390 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556Ab0JVNDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:03:53 -0400
Date: Fri, 22 Oct 2010 13:03:17 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101019134808.304495776@chello.nl>
References: <20101019134808.304495776@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Extract DS alloc/free functions
Message-ID: <tip-65af94baca56beb3514d6cfce782634db9cf676d@git.kernel.org>
Git-Commit-ID: 65af94baca56beb3514d6cfce782634db9cf676d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Oct 2010 13:03:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  65af94baca56beb3514d6cfce782634db9cf676d
Gitweb:     http://git.kernel.org/tip/65af94baca56beb3514d6cfce782634db9cf676d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 19 Oct 2010 14:37:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Oct 2010 14:18:25 +0200

perf, x86: Extract DS alloc/free functions

Again, mostly a cleanup to unclutter the reserve_ds_buffer() code.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Stephane Eranian <eranian@google.com>
LKML-Reference: <20101019134808.304495776@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   40 ++++++++++++++++++----------
 1 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 14d98bd..3c86f4d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -148,6 +148,30 @@ static void release_bts_buffer(int cpu)
 	ds->bts_buffer_base = 0;
 }
 
+static int alloc_ds_buffer(int cpu)
+{
+	struct debug_store *ds;
+
+	ds = kzalloc(sizeof(*ds), GFP_KERNEL);
+	if (unlikely(!ds))
+		return -ENOMEM;
+
+	per_cpu(cpu_hw_events, cpu).ds = ds;
+
+	return 0;
+}
+
+static void release_ds_buffer(int cpu)
+{
+	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+
+	if (!ds)
+		return;
+
+	per_cpu(cpu_hw_events, cpu).ds = NULL;
+	kfree(ds);
+}
+
 static void release_ds_buffers(void)
 {
 	int cpu;
@@ -160,16 +184,9 @@ static void release_ds_buffers(void)
 		fini_debug_store_on_cpu(cpu);
 
 	for_each_possible_cpu(cpu) {
-		struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
-
-		if (!ds)
-			continue;
-
 		release_pebs_buffer(cpu);
 		release_bts_buffer(cpu);
-
-		per_cpu(cpu_hw_events, cpu).ds = NULL;
-		kfree(ds);
+		release_ds_buffer(cpu);
 	}
 	put_online_cpus();
 }
@@ -184,13 +201,8 @@ static int reserve_ds_buffers(void)
 	get_online_cpus();
 
 	for_each_possible_cpu(cpu) {
-		struct debug_store *ds;
-
-		err = -ENOMEM;
-		ds = kzalloc(sizeof(*ds), GFP_KERNEL);
-		if (unlikely(!ds))
+		if (alloc_ds_buffer(cpu))
 			break;
-		per_cpu(cpu_hw_events, cpu).ds = ds;
 
 		if (alloc_bts_buffer(cpu))
 			break;
