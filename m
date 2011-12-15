Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab1LOTnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:43:01 -0500
Received: from mga14.intel.com ([143.182.124.37]:53434 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932579Ab1LOTmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:42:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="47653955"
Subject: [patch] sched: fix select_idle_sibling() regression in selecting an
 idle SMT sibling
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 15 Dec 2011 11:47:00 -0800
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323978421.1984.244.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Please queue this scheduler patch for the next 3.2-rc release. We
already have a cleaned up version of this patch queued in -tip. If you
have any merge problems in tip/master, me or peterz can help resolve it.

Thanks.
---
From: Peter Zijlstra <peterz@infradead.org>
Subject: sched: fix select_idle_sibling() regression in selecting an idle SMT sibling

Mike Galbraith reported that this recent commit,

   commit 4dcfe1025b513c2c1da5bf5586adb0e80148f612
   Author: Peter Zijlstra <peterz@infradead.org>
   Date:   Thu Nov 10 13:01:10 2011 +0100

       sched: Avoid SMT siblings in select_idle_sibling() if possible

stopped selecting an idle SMT sibling when there are no idle cores in a
single socket system.

Intent of the select_idle_sibling() was to fallback to an idle SMT sibling,
if it fails to identify an idle core. But this fallback was not happening
on systems where all the scheduler domains had `SD_SHARE_PKG_RESOURCES'
flag set.

Fix it. Slightly bigger patch of cleaning all these goto's etc is
queued up for the next release.

Reported-by: Mike Galbraith <efault@gmx.de>
Reported-by: Alex Shi <alex.shi@intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched_fair.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a78ed27..8a39fa3 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2352,13 +2352,11 @@ again:
 		if (!smt && (sd->flags & SD_SHARE_CPUPOWER))
 			continue;
 
-		if (!(sd->flags & SD_SHARE_PKG_RESOURCES)) {
-			if (!smt) {
-				smt = 1;
-				goto again;
-			}
+		if (smt && !(sd->flags & SD_SHARE_CPUPOWER))
+			break;
+
+		if (!(sd->flags & SD_SHARE_PKG_RESOURCES))
 			break;
-		}
 
 		sg = sd->groups;
 		do {
@@ -2378,6 +2376,10 @@ next:
 			sg = sg->next;
 		} while (sg != sd->groups);
 	}
+	if (!smt) {
+		smt = 1;
+		goto again;
+	}
 done:
 	rcu_read_unlock();
 


