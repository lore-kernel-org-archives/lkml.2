Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab1LULtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:49:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34088 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab1LULtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:49:22 -0500
Date: Wed, 21 Dec 2011 03:48:57 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-mwxab34dibqgzk5zywutfnha@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        asharma@fb.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, asharma@fb.com, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/fast] perf, x86: Implement user-space RDPMC support,
  to allow fast, user-space access to self-monitoring counters
Git-Commit-ID: fe4a330885aee20f233de36085fb15c38094e635
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 03:49:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fe4a330885aee20f233de36085fb15c38094e635
Gitweb:     http://git.kernel.org/tip/fe4a330885aee20f233de36085fb15c38094e635
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sun, 20 Nov 2011 20:44:06 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Dec 2011 11:01:10 +0100

perf, x86: Implement user-space RDPMC support, to allow fast, user-space access to self-monitoring counters

Implement a correct pmu::event_idx for the x86 counter index rules and
set CR4.PCE on CPU_STARTING.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: http://lkml.kernel.org/n/tip-mwxab34dibqgzk5zywutfnha@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5adce10..53b5699 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1210,6 +1210,7 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 		break;
 
 	case CPU_STARTING:
+		set_in_cr4(X86_CR4_PCE);
 		if (x86_pmu.cpu_starting)
 			x86_pmu.cpu_starting(cpu);
 		break;
@@ -1542,6 +1543,18 @@ static int x86_pmu_event_init(struct perf_event *event)
 	return err;
 }
 
+static int x86_pmu_event_idx(struct perf_event *event)
+{
+	int idx = event->hw.idx;
+
+	if (x86_pmu.num_counters_fixed && idx >= X86_PMC_IDX_FIXED) {
+		idx -= X86_PMC_IDX_FIXED;
+		idx |= 1 << 30;
+	}
+
+	return idx + 1;
+}
+
 static struct pmu pmu = {
 	.pmu_enable	= x86_pmu_enable,
 	.pmu_disable	= x86_pmu_disable,
@@ -1557,6 +1570,8 @@ static struct pmu pmu = {
 	.start_txn	= x86_pmu_start_txn,
 	.cancel_txn	= x86_pmu_cancel_txn,
 	.commit_txn	= x86_pmu_commit_txn,
+
+	.event_idx	= x86_pmu_event_idx,
 };
 
 /*
