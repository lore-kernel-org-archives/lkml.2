Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134Ab2GYDny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:43:54 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:52413 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933053Ab2GYDne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:43:34 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 48/52] tools/power: turbostat: fix large c1% issue
Date: Tue, 24 Jul 2012 23:41:44 -0400
Message-Id: <c3ae331d1c2fe25edfbece73fda0bb312445b636.1343187618.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.rc0
In-Reply-To: <1343187708-19532-1-git-send-email-lenb@kernel.org>
References: <1343187708-19532-1-git-send-email-lenb@kernel.org>
In-Reply-To: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
References: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Under some conditions, c1% was displayed as very large number,
much higher than 100%.

c1% is not measured, it is derived as "that, which is left over"
from other counters.  However, the other counters are not collected
atomically, and so it is possible for c1% to be calaculagted as
a small negative number -- displayed as very large positive.

There was a check for mperf vs tsc for this already,
but it needed to also include the other counters
that are used to calculate c1.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/x86/turbostat/turbostat.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index b815a12..861d771 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -444,6 +444,9 @@ delta_core(struct core_data *new, struct core_data *old)
 	old->c7 = new->c7 - old->c7;
 }
 
+/*
+ * old = new - old
+ */
 void
 delta_thread(struct thread_data *new, struct thread_data *old,
 	struct core_data *core_delta)
@@ -482,19 +485,20 @@ delta_thread(struct thread_data *new, struct thread_data *old,
 
 
 	/*
-	 * As mperf and tsc collection are not atomic,
-	 * it is possible for mperf's non-halted cycles
+	 * As counter collection is not atomic,
+	 * it is possible for mperf's non-halted cycles + idle states
 	 * to exceed TSC's all cycles: show c1 = 0% in that case.
 	 */
-	if (old->mperf > old->tsc)
+	if ((old->mperf + core_delta->c3 + core_delta->c6 + core_delta->c7) > old->tsc)
 		old->c1 = 0;
 	else {
 		/* normal case, derive c1 */
 		old->c1 = old->tsc - old->mperf - core_delta->c3
 				- core_delta->c6 - core_delta->c7;
 	}
+
 	if (old->mperf == 0) {
-		if (verbose) fprintf(stderr, "cpu%d MPERF 0!\n", old->cpu_id);
+		if (verbose > 1) fprintf(stderr, "cpu%d MPERF 0!\n", old->cpu_id);
 		old->mperf = 1;	/* divide by 0 protection */
 	}
 
-- 
1.7.12.rc0

