Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab2A0U6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:58:31 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50639 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab2A0U62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:58:28 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
Subject: [PATCH v4 04/18] perf: sync branch stack sampling with X86 precise_sampling
Date: Fri, 27 Jan 2012 21:56:04 +0100
Message-Id: <1327697778-18515-5-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1327697778-18515-1-git-send-email-eranian@google.com>
References: <1327697778-18515-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If precise sampling is enabled on Intel X86, then perf_event uses PEBS.
To correct for the off-by-one error of PEBS, perf_event uses LBR when
precise_sample > 1.

On Intel X86 PERF_SAMPLE_BRANCH_STACK is implemented using LBR,
therefore both features must be coordinated as they may not
configure LBR the same way.

For PEBS, LBR needs to capture all branches at all priv levels.
This patch sets this up.

The configuration of PERF_SAMPLE_BRANCH_STACK may not be compatible
in which case an error must be returned.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3779313..710ec93 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -356,6 +356,7 @@ int x86_setup_perfctr(struct perf_event *event)
 int x86_pmu_hw_config(struct perf_event *event)
 {
 	if (event->attr.precise_ip) {
+		u64 *br_type, br_sel;
 		int precise = 0;
 
 		/* Support for constant skid */
@@ -369,6 +370,27 @@ int x86_pmu_hw_config(struct perf_event *event)
 
 		if (event->attr.precise_ip > precise)
 			return -EOPNOTSUPP;
+		/*
+		 * check that PEBS LBR correction does not conflict with
+		 * whatever the user is asking with attr->branch_sample_type
+		 */
+		if (event->attr.precise_ip > 1) {
+
+			br_type = &event->attr.branch_sample_type;
+
+			if (has_branch_stack(event)) {
+				br_sel = *br_type & PERF_SAMPLE_BRANCH_ANY;
+				if (br_sel != PERF_SAMPLE_BRANCH_ANY)
+					return -EOPNOTSUPP;
+			} else {
+				/*
+				 * For PEBS fixups, we capture all
+				 * the branches at all priv levels
+				 */
+				*br_type = PERF_SAMPLE_BRANCH_ANY
+					 | PERF_SAMPLE_BRANCH_PLM_ALL;
+			}
+		}
 	}
 
 	/*
-- 
1.7.1

