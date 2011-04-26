Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab1DZM6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:58:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:38017 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478Ab1DZM6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:58:47 -0400
Date: Tue, 26 Apr 2011 12:58:24 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-rd2y4ct71hjawzz6fpvsy9hg@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, markus.t.metzger@intel.com, tglx@linutronix.de,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Fix BTS condition
Git-Commit-ID: 18a073a3acd3a47fbb5e23333df7fad28d576345
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Apr 2011 12:58:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18a073a3acd3a47fbb5e23333df7fad28d576345
Gitweb:     http://git.kernel.org/tip/18a073a3acd3a47fbb5e23333df7fad28d576345
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 26 Apr 2011 13:24:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 Apr 2011 13:34:34 +0200

perf, x86: Fix BTS condition

Currently the x86 backend incorrectly assumes that any BRANCH_INSN
with sample_period==1 is a BTS request. This is not true when we do
frequency driven profiling such as 'perf record -e branches'.

Solves this error:

  $ perf record -e branches ./array
  Error: sys_perf_event_open() syscall returned with 95 (Operation not supported).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-rd2y4ct71hjawzz6fpvsy9hg@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c       |    4 ++--
 arch/x86/kernel/cpu/perf_event_intel.c |    3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 632e5dc..fac0654 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -613,8 +613,8 @@ static int x86_setup_perfctr(struct perf_event *event)
 	/*
 	 * Branch tracing:
 	 */
-	if ((attr->config == PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
-	    (hwc->sample_period == 1)) {
+	if (attr->config == PERF_COUNT_HW_BRANCH_INSTRUCTIONS &&
+	    !attr->freq && hwc->sample_period == 1) {
 		/* BTS is not supported by this architecture. */
 		if (!x86_pmu.bts_active)
 			return -EOPNOTSUPP;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 43fa20b..9194b06 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -998,6 +998,9 @@ intel_bts_constraints(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	unsigned int hw_event, bts_event;
 
+	if (event->attr.freq)
+		return NULL;
+
 	hw_event = hwc->config & INTEL_ARCH_EVENT_MASK;
 	bts_event = x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
 
