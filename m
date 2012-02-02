Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2BBMzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:55:51 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63223 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab2BBMzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:55:48 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
Subject: [PATCH v5 06/18] perf: disable LBR support for older Intel Atom processors
Date: Thu,  2 Feb 2012 13:54:36 +0100
Message-Id: <1328187288-24395-7-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1328187288-24395-1-git-send-email-eranian@google.com>
References: <1328187288-24395-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds a restriction for Intel Atom LBR support. Only
steppings 10 (PineView) and more recent are supported. Older models,
do not have a functional LBR. Their LBR does not freeze on PMU interrupt
which makes LBR unusable in the context of perf_events.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index b4150dc..5cf86b4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -317,6 +317,16 @@ void intel_pmu_lbr_init_snb(void)
 /* atom */
 void intel_pmu_lbr_init_atom(void)
 {
+	/*
+	 * only models starting at stepping 10 seems
+	 * to have an operational LBR which can freeze
+	 * on PMU interrupt
+	 */
+	if (boot_cpu_data.x86_mask < 10) {
+		pr_cont("LBR disabled due to erratum");
+		return;
+	}
+
 	x86_pmu.lbr_nr	   = 8;
 	x86_pmu.lbr_tos    = MSR_LBR_TOS;
 	x86_pmu.lbr_from   = MSR_LBR_CORE_FROM;
-- 
1.7.4.1

