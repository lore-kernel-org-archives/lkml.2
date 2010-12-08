Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab0LHUmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:42:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:34666 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254Ab0LHUmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:42:44 -0500
Date: Wed, 8 Dec 2010 20:42:14 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, amd: Remove the nb lock
Message-ID: <tip-c079c791c5a0627fc7b752d31d72e274e0596ba8@git.kernel.org>
Git-Commit-ID: c079c791c5a0627fc7b752d31d72e274e0596ba8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 20:42:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c079c791c5a0627fc7b752d31d72e274e0596ba8
Gitweb:     http://git.kernel.org/tip/c079c791c5a0627fc7b752d31d72e274e0596ba8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 25 Nov 2010 08:56:17 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Dec 2010 20:16:30 +0100

perf, amd: Remove the nb lock

Since all the hotplug stuff is serialized by the hotplug mutex,
do away with the amd_nb_lock.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_amd.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index e421b8c..67e2202 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -1,7 +1,5 @@
 #ifdef CONFIG_CPU_SUP_AMD
 
-static DEFINE_RAW_SPINLOCK(amd_nb_lock);
-
 static __initconst const u64 amd_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -275,7 +273,7 @@ done:
 	return &emptyconstraint;
 }
 
-static struct amd_nb *amd_alloc_nb(int cpu, int nb_id)
+static struct amd_nb *amd_alloc_nb(int cpu)
 {
 	struct amd_nb *nb;
 	int i;
@@ -285,7 +283,7 @@ static struct amd_nb *amd_alloc_nb(int cpu, int nb_id)
 	if (!nb)
 		return NULL;
 
-	nb->nb_id = nb_id;
+	nb->nb_id = -1;
 
 	/*
 	 * initialize all possible NB constraints
@@ -306,7 +304,7 @@ static int amd_pmu_cpu_prepare(int cpu)
 	if (boot_cpu_data.x86_max_cores < 2)
 		return NOTIFY_OK;
 
-	cpuc->amd_nb = amd_alloc_nb(cpu, -1);
+	cpuc->amd_nb = amd_alloc_nb(cpu);
 	if (!cpuc->amd_nb)
 		return NOTIFY_BAD;
 
@@ -325,8 +323,6 @@ static void amd_pmu_cpu_starting(int cpu)
 	nb_id = amd_get_nb_id(cpu);
 	WARN_ON_ONCE(nb_id == BAD_APICID);
 
-	raw_spin_lock(&amd_nb_lock);
-
 	for_each_online_cpu(i) {
 		nb = per_cpu(cpu_hw_events, i).amd_nb;
 		if (WARN_ON_ONCE(!nb))
@@ -341,8 +337,6 @@ static void amd_pmu_cpu_starting(int cpu)
 
 	cpuc->amd_nb->nb_id = nb_id;
 	cpuc->amd_nb->refcnt++;
-
-	raw_spin_unlock(&amd_nb_lock);
 }
 
 static void amd_pmu_cpu_dead(int cpu)
@@ -354,8 +348,6 @@ static void amd_pmu_cpu_dead(int cpu)
 
 	cpuhw = &per_cpu(cpu_hw_events, cpu);
 
-	raw_spin_lock(&amd_nb_lock);
-
 	if (cpuhw->amd_nb) {
 		struct amd_nb *nb = cpuhw->amd_nb;
 
@@ -364,8 +356,6 @@ static void amd_pmu_cpu_dead(int cpu)
 
 		cpuhw->amd_nb = NULL;
 	}
-
-	raw_spin_unlock(&amd_nb_lock);
 }
 
 static __initconst const struct x86_pmu amd_pmu = {
