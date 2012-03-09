Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2CINWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:22:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58647 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2CINWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:22:20 -0500
Date: Fri, 9 Mar 2012 05:21:57 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-ff3fb511ba377e8a0a7f553cc352237f70d08121@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1328826068-11713-5-git-send-email-eranian@google.com>
References: <1328826068-11713-5-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/hw-branch-sampling] perf/x86:
  Sync branch stack sampling with precise_sampling
Git-Commit-ID: ff3fb511ba377e8a0a7f553cc352237f70d08121
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Mar 2012 05:22:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff3fb511ba377e8a0a7f553cc352237f70d08121
Gitweb:     http://git.kernel.org/tip/ff3fb511ba377e8a0a7f553cc352237f70d08121
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 9 Feb 2012 23:20:54 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Mar 2012 14:55:40 +0100

perf/x86: Sync branch stack sampling with precise_sampling

If precise sampling is enabled on Intel x86 then perf_event uses PEBS.
To correct for the off-by-one error of PEBS, perf_event uses LBR when
precise_sample > 1.

On Intel x86 PERF_SAMPLE_BRANCH_STACK is implemented using LBR,
therefore both features must be coordinated as they may not
configure LBR the same way.

For PEBS, LBR needs to capture all branches at the priv level of
the associated event.

This patch checks that the branch type and priv level of BRANCH_STACK
is compatible with that of the PEBS LBR requirement, thereby allowing:

   $ perf record -b any,u -e instructions:upp ....

But:

   $ perf record -b any_call,u -e instructions:upp

Is not possible.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1328826068-11713-5-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   60 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3779313..cea5674 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -353,6 +353,36 @@ int x86_setup_perfctr(struct perf_event *event)
 	return 0;
 }
 
+/*
+ * check that branch_sample_type is compatible with
+ * settings needed for precise_ip > 1 which implies
+ * using the LBR to capture ALL taken branches at the
+ * priv levels of the measurement
+ */
+static inline int precise_br_compat(struct perf_event *event)
+{
+	u64 m = event->attr.branch_sample_type;
+	u64 b = 0;
+
+	/* must capture all branches */
+	if (!(m & PERF_SAMPLE_BRANCH_ANY))
+		return 0;
+
+	m &= PERF_SAMPLE_BRANCH_KERNEL | PERF_SAMPLE_BRANCH_USER;
+
+	if (!event->attr.exclude_user)
+		b |= PERF_SAMPLE_BRANCH_USER;
+
+	if (!event->attr.exclude_kernel)
+		b |= PERF_SAMPLE_BRANCH_KERNEL;
+
+	/*
+	 * ignore PERF_SAMPLE_BRANCH_HV, not supported on x86
+	 */
+
+	return m == b;
+}
+
 int x86_pmu_hw_config(struct perf_event *event)
 {
 	if (event->attr.precise_ip) {
@@ -369,6 +399,36 @@ int x86_pmu_hw_config(struct perf_event *event)
 
 		if (event->attr.precise_ip > precise)
 			return -EOPNOTSUPP;
+		/*
+		 * check that PEBS LBR correction does not conflict with
+		 * whatever the user is asking with attr->branch_sample_type
+		 */
+		if (event->attr.precise_ip > 1) {
+			u64 *br_type = &event->attr.branch_sample_type;
+
+			if (has_branch_stack(event)) {
+				if (!precise_br_compat(event))
+					return -EOPNOTSUPP;
+
+				/* branch_sample_type is compatible */
+
+			} else {
+				/*
+				 * user did not specify  branch_sample_type
+				 *
+				 * For PEBS fixups, we capture all
+				 * the branches at the priv level of the
+				 * event.
+				 */
+				*br_type = PERF_SAMPLE_BRANCH_ANY;
+
+				if (!event->attr.exclude_user)
+					*br_type |= PERF_SAMPLE_BRANCH_USER;
+
+				if (!event->attr.exclude_kernel)
+					*br_type |= PERF_SAMPLE_BRANCH_KERNEL;
+			}
+		}
 	}
 
 	/*
