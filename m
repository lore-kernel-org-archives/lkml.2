Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab2AIQxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 11:53:03 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50922 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab2AIQuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 11:50:09 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@infradead.org,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu
Subject: [PATCH 06/13] perf_events: disable LBR support for older Intel Atom processors (v3)
Date: Mon,  9 Jan 2012 17:49:14 +0100
Message-Id: <1326127761-2723-7-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1326127761-2723-1-git-send-email-eranian@google.com>
References: <1326127761-2723-1-git-send-email-eranian@google.com>
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
index 8a1eb6c..e2b7094 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -313,6 +313,16 @@ void intel_pmu_lbr_init_snb(void)
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
1.7.1

