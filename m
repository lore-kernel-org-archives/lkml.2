Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab2JBXxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 19:53:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:31357 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831Ab2JBXtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 19:49:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,525,1344236400"; 
   d="scan'208";a="200845778"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, x86@vger.kernel.org, eranian@google.com, jolsa@redhat.com,
        a.p.zijlstra@chello.nl, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 21/31] perf, x86: Add Haswell specific transaction flag reporting
Date: Tue,  2 Oct 2012 16:48:41 -0700
Message-Id: <1349221731-15665-22-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
References: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

In the PEBS handler report the transaction flags using the new
generic transaction flags facility. Most of them come from
the "tsx_tuning" field in PEBSv2, but the abort code is derived
from the RAX register reported in the PEBS record.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 6066740..44394d4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -684,6 +684,15 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 			data.weight = ((struct pebs_record_v2 *)pebs)->nhm.lat;
 	}
 
+	if ((event->attr.sample_type & PERF_SAMPLE_TRANSACTION) &&
+	    x86_pmu.intel_cap.pebs_format >= 2) {
+		data.transaction =
+		     ((struct pebs_record_v2 *)pebs)->tsx_tuning >> 32;
+		if ((data.transaction & PERF_SAMPLE_TXN_TRANSACTION) &&
+		    (pebs->ax & 1))
+			data.transaction |= pebs->ax & 0xff000000;
+	}
+
 	if (has_branch_stack(event))
 		data.br_stack = &cpuc->lbr_stack;
 
-- 
1.7.7.6

