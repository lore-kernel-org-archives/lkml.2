Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab0EHK6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 06:58:12 -0400
Received: from ozlabs.org ([203.10.76.45]:41463 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab0EHK6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 06:58:10 -0400
Date: Sat, 8 May 2010 20:58:00 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, eranian@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf_event: Make software events work again
Message-ID: <20100508105800.GB10650@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6bde9b6ce0127e2a56228a2071536d422be31336 ("perf: Add group
scheduling transactional APIs") added code to allow a group to be
scheduled in a single transaction.  However, it introduced a bug in
handling events whose pmu does not implement transactions -- at the
end of scheduling in the events in the group, in the non-transactional
case the code now falls through to the group_error label, and proceeds
to unschedule all the events in the group and return failure.

This fixes it by returning 0 (success) in the non-transactional case.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index bb06382..180151f 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -664,13 +664,13 @@ group_sched_in(struct perf_event *group_event,
 		}
 	}
 
-	if (txn) {
-		ret = pmu->commit_txn(pmu);
-		if (!ret) {
-			pmu->cancel_txn(pmu);
+	if (!txn)
+		return 0;
 
-			return 0;
-		}
+	ret = pmu->commit_txn(pmu);
+	if (!ret) {
+		pmu->cancel_txn(pmu);
+		return 0;
 	}
 
 group_error:
