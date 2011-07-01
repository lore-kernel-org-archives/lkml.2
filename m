Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab1GAPZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:25:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:42609 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab1GAPZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:25:03 -0400
Date: Fri, 1 Jul 2011 15:24:48 GMT
From: tip-bot for Avi Kivity <avi@redhat.com>
Message-ID: <tip-0af3ac1fdb9d5c297b4b07c9e0172531d42b6716@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, avi@redhat.com,
        mingo@elte.hu
In-Reply-To: <1309362157-6596-3-git-send-email-avi@redhat.com>
References: <1309362157-6596-3-git-send-email-avi@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, perf: Add constraints for architectural PMU
Git-Commit-ID: 0af3ac1fdb9d5c297b4b07c9e0172531d42b6716
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:24:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0af3ac1fdb9d5c297b4b07c9e0172531d42b6716
Gitweb:     http://git.kernel.org/tip/0af3ac1fdb9d5c297b4b07c9e0172531d42b6716
Author:     Avi Kivity <avi@redhat.com>
AuthorDate: Wed, 29 Jun 2011 18:42:36 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 11:06:39 +0200

x86, perf: Add constraints for architectural PMU

The v1 PMU does not have any fixed counters.  Using the v2 constraints,
which do have fixed counters, causes an additional choice to be present
in the weight calculation, but not when actually scheduling the event,
leading to an event being not scheduled at all.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1309362157-6596-3-git-send-email-avi@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index bf6f92f..45fbb8f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -112,6 +112,11 @@ static struct extra_reg intel_westmere_extra_regs[] __read_mostly =
 	EVENT_EXTRA_END
 };
 
+static struct event_constraint intel_v1_event_constraints[] __read_mostly =
+{
+	EVENT_CONSTRAINT_END
+};
+
 static struct event_constraint intel_gen_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
@@ -1606,11 +1611,19 @@ static __init int intel_pmu_init(void)
 		break;
 
 	default:
-		/*
-		 * default constraints for v2 and up
-		 */
-		x86_pmu.event_constraints = intel_gen_event_constraints;
-		pr_cont("generic architected perfmon, ");
+		switch (x86_pmu.version) {
+		case 1:
+			x86_pmu.event_constraints = intel_v1_event_constraints;
+			pr_cont("generic architected perfmon v1, ");
+			break;
+		default:
+			/*
+			 * default constraints for v2 and up
+			 */
+			x86_pmu.event_constraints = intel_gen_event_constraints;
+			pr_cont("generic architected perfmon, ");
+			break;
+		}
 	}
 	return 0;
 }
