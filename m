Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab0EHLTM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 07:19:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:55093 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab0EHLTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 07:19:10 -0400
Date: Sat, 8 May 2010 11:18:37 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100508105800.GB10650@brick.ozlabs.ibm.com>
References: <20100508105800.GB10650@brick.ozlabs.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_event: Make software events work again
Message-ID: <tip-6e85158cf5a2385264316870256fb6ad681156a0@git.kernel.org>
Git-Commit-ID: 6e85158cf5a2385264316870256fb6ad681156a0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 08 May 2010 11:18:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e85158cf5a2385264316870256fb6ad681156a0
Gitweb:     http://git.kernel.org/tip/6e85158cf5a2385264316870256fb6ad681156a0
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Sat, 8 May 2010 20:58:00 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 May 2010 13:16:55 +0200

perf_event: Make software events work again

Commit 6bde9b6ce0127e2a56228a2071536d422be31336 ("perf: Add
group scheduling transactional APIs") added code to allow a
group to be scheduled in a single transaction.  However, it
introduced a bug in handling events whose pmu does not implement
transactions -- at the end of scheduling in the events in the
group, in the non-transactional case the code now falls through
to the group_error label, and proceeds to unschedule all the
events in the group and return failure.

This fixes it by returning 0 (success) in the non-transactional
case.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: eranian@gmail.com
LKML-Reference: <20100508105800.GB10650@brick.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

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
