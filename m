Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab0IQL3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 07:29:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:60830 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab0IQL3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 07:29:02 -0400
Date: Fri, 17 Sep 2010 11:28:37 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, robert.richter@amd.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100917093009.461794357@chello.nl>
References: <20100917093009.461794357@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix perf_event_exit_cpu_context()
Message-ID: <tip-917bdd1c9b7b0f4c22f2504c2f0c1074c8ab9df7@git.kernel.org>
Git-Commit-ID: 917bdd1c9b7b0f4c22f2504c2f0c1074c8ab9df7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 17 Sep 2010 11:28:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  917bdd1c9b7b0f4c22f2504c2f0c1074c8ab9df7
Gitweb:     http://git.kernel.org/tip/917bdd1c9b7b0f4c22f2504c2f0c1074c8ab9df7
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 17 Sep 2010 11:28:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Sep 2010 12:48:48 +0200

perf: Fix perf_event_exit_cpu_context()

Use the right cpu-context.. spotted by preempt warning on
hot-unplug

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>
LKML-Reference: <20100917093009.461794357@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 6d7eef5..27332e5 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -6269,14 +6269,13 @@ static void perf_event_exit_cpu_context(int cpu)
 
 	idx = srcu_read_lock(&pmus_srcu);
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
-		ctx = &this_cpu_ptr(pmu->pmu_cpu_context)->ctx;
+		ctx = &per_cpu_ptr(pmu->pmu_cpu_context, cpu)->ctx;
 
 		mutex_lock(&ctx->mutex);
 		smp_call_function_single(cpu, __perf_event_exit_context, ctx, 1);
 		mutex_unlock(&ctx->mutex);
 	}
 	srcu_read_unlock(&pmus_srcu, idx);
-
 }
 
 static void perf_event_exit_cpu(int cpu)
