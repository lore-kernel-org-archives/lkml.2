Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab1KRXeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:34:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53337 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1KRXeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:34:20 -0500
Date: Fri, 18 Nov 2011 15:33:43 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-xv8geaz2zpbjhlx0svmpp28n@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, dengcheng.zhu@gmail.com, will.deacon@arm.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        ralf@linux-mips.org, david.daney@cavium.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, dengcheng.zhu@gmail.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        will.deacon@arm.com, ralf@linux-mips.org, david.daney@cavium.com,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Don't use -ENOSPC for out of PMU resources
Git-Commit-ID: aa2bc1ade59003a379ffc485d6da2d92ea3370a6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:33:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa2bc1ade59003a379ffc485d6da2d92ea3370a6
Gitweb:     http://git.kernel.org/tip/aa2bc1ade59003a379ffc485d6da2d92ea3370a6
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 9 Nov 2011 17:56:37 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Nov 2011 13:01:24 +0100

perf: Don't use -ENOSPC for out of PMU resources

People (Linus) objected to using -ENOSPC to signal not having enough
resources on the PMU to satisfy the request. Use -EINVAL.

Requested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: David Daney <david.daney@cavium.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-xv8geaz2zpbjhlx0svmpp28n@git.kernel.org
[ merged to newer kernel, fixed up MIPS impact ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/arm/kernel/perf_event.c         |    6 +++---
 arch/mips/kernel/perf_event_mipsxx.c |    8 ++++----
 arch/x86/kernel/cpu/perf_event.c     |   10 +++++-----
 arch/x86/kernel/cpu/perf_event_p4.c  |    2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 24e2347..ff17b17 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -347,15 +347,15 @@ validate_group(struct perf_event *event)
 	memset(&fake_pmu, 0, sizeof(fake_pmu));
 
 	if (!validate_event(&fake_pmu, leader))
-		return -ENOSPC;
+		return -EINVAL;
 
 	list_for_each_entry(sibling, &leader->sibling_list, group_entry) {
 		if (!validate_event(&fake_pmu, sibling))
-			return -ENOSPC;
+			return -EINVAL;
 	}
 
 	if (!validate_event(&fake_pmu, event))
-		return -ENOSPC;
+		return -EINVAL;
 
 	return 0;
 }
diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index 4f2971b..315fc0b 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -623,7 +623,7 @@ static int mipspmu_event_init(struct perf_event *event)
 	if (!atomic_inc_not_zero(&active_events)) {
 		if (atomic_read(&active_events) > MIPS_MAX_HWEVENTS) {
 			atomic_dec(&active_events);
-			return -ENOSPC;
+			return -EINVAL;
 		}
 
 		mutex_lock(&pmu_reserve_mutex);
@@ -732,15 +732,15 @@ static int validate_group(struct perf_event *event)
 	memset(&fake_cpuc, 0, sizeof(fake_cpuc));
 
 	if (!validate_event(&fake_cpuc, leader))
-		return -ENOSPC;
+		return -EINVAL;
 
 	list_for_each_entry(sibling, &leader->sibling_list, group_entry) {
 		if (!validate_event(&fake_cpuc, sibling))
-			return -ENOSPC;
+			return -EINVAL;
 	}
 
 	if (!validate_event(&fake_cpuc, event))
-		return -ENOSPC;
+		return -EINVAL;
 
 	return 0;
 }
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 6408910..ff0e8d4 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -588,7 +588,7 @@ done:
 				x86_pmu.put_event_constraints(cpuc, cpuc->event_list[i]);
 		}
 	}
-	return num ? -ENOSPC : 0;
+	return num ? -EINVAL : 0;
 }
 
 /*
@@ -607,7 +607,7 @@ static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader,
 
 	if (is_x86_event(leader)) {
 		if (n >= max_count)
-			return -ENOSPC;
+			return -EINVAL;
 		cpuc->event_list[n] = leader;
 		n++;
 	}
@@ -620,7 +620,7 @@ static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader,
 			continue;
 
 		if (n >= max_count)
-			return -ENOSPC;
+			return -EINVAL;
 
 		cpuc->event_list[n] = event;
 		n++;
@@ -1316,7 +1316,7 @@ static int validate_event(struct perf_event *event)
 	c = x86_pmu.get_event_constraints(fake_cpuc, event);
 
 	if (!c || !c->weight)
-		ret = -ENOSPC;
+		ret = -EINVAL;
 
 	if (x86_pmu.put_event_constraints)
 		x86_pmu.put_event_constraints(fake_cpuc, event);
@@ -1341,7 +1341,7 @@ static int validate_group(struct perf_event *event)
 {
 	struct perf_event *leader = event->group_leader;
 	struct cpu_hw_events *fake_cpuc;
-	int ret = -ENOSPC, n;
+	int ret = -EINVAL, n;
 
 	fake_cpuc = allocate_fake_cpuc();
 	if (IS_ERR(fake_cpuc))
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 492bf13..ef484d9 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -1268,7 +1268,7 @@ reserve:
 	}
 
 done:
-	return num ? -ENOSPC : 0;
+	return num ? -EINVAL : 0;
 }
 
 static __initconst const struct x86_pmu p4_pmu = {
