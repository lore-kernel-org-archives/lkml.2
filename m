Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab0LPMdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 07:33:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:36508 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab0LPMdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 07:33:53 -0500
Date: Thu, 16 Dec 2010 12:33:33 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Provide a PEBS capable cycle event
Message-ID: <tip-7639dae0ca11038286bbbcda05f2bef601c1eb8d@git.kernel.org>
Git-Commit-ID: 7639dae0ca11038286bbbcda05f2bef601c1eb8d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Dec 2010 12:33:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7639dae0ca11038286bbbcda05f2bef601c1eb8d
Gitweb:     http://git.kernel.org/tip/7639dae0ca11038286bbbcda05f2bef601c1eb8d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 14 Dec 2010 21:26:40 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 16 Dec 2010 11:36:44 +0100

perf, x86: Provide a PEBS capable cycle event

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index c8f5c08..24e390e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -816,6 +816,32 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	if (ret)
 		return ret;
 
+	if (event->attr.precise_ip &&
+	    (event->hw.config & X86_RAW_EVENT_MASK) == 0x003c) {
+		/*
+		 * Use an alternative encoding for CPU_CLK_UNHALTED.THREAD_P
+		 * (0x003c) so that we can use it with PEBS.
+		 *
+		 * The regular CPU_CLK_UNHALTED.THREAD_P event (0x003c) isn't
+		 * PEBS capable. However we can use INST_RETIRED.ANY_P
+		 * (0x00c0), which is a PEBS capable event, to get the same
+		 * count.
+		 *
+		 * INST_RETIRED.ANY_P counts the number of cycles that retires
+		 * CNTMASK instructions. By setting CNTMASK to a value (16)
+		 * larger than the maximum number of instructions that can be
+		 * retired per cycle (4) and then inverting the condition, we
+		 * count all cycles that retire 16 or less instructions, which
+		 * is every cycle.
+		 *
+		 * Thereby we gain a PEBS capable cycle counter.
+		 */
+		u64 alt_config = 0x108000c0; /* INST_RETIRED.TOTAL_CYCLES */
+
+		alt_config |= (event->hw.config & ~X86_RAW_EVENT_MASK);
+		event->hw.config = alt_config;
+	}
+
 	if (event->attr.type != PERF_TYPE_RAW)
 		return 0;
 
