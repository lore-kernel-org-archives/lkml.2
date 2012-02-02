Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab2BBM64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:58:56 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63223 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab2BBMzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:55:41 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
Subject: [PATCH v5 04/18] perf: sync branch stack sampling with X86 precise_sampling
Date: Thu,  2 Feb 2012 13:54:34 +0100
Message-Id: <1328187288-24395-5-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1328187288-24395-1-git-send-email-eranian@google.com>
References: <1328187288-24395-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If precise sampling is enabled on Intel X86, then perf_event uses PEBS.
To correct for the off-by-one error of PEBS, perf_event uses LBR when
precise_sample > 1.

On Intel X86, PERF_SAMPLE_BRANCH_STACK is implemented using LBR,
therefore both features must be coordinated as they may not
configure LBR the same way.

For PEBS, LBR needs to capture all branches at the priv level of
the associated event.

This patch checks that the branch type and priv level of BRANCH_STACK
is compatible with that of the PEBS LBR requirement, thereby allowing:

   $ perf record -b any,u -e instructions:upp ....

But
   $ perf record -b any_call,u -e instructions:upp

Is not possible.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.c |   60 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3779313..71e0264 100644
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
+	 * ignore PERF_SAMPLE_BRANCH_HV, not supported on X86
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
-- 
1.7.4.1

