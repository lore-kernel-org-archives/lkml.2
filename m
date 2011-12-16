Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab1LPLgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 06:36:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47672 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab1LPLgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 06:36:41 -0500
Date: Fri, 16 Dec 2011 03:36:10 -0800
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-ab2789213d224202237292d78aaa0c386c7b28b2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        efault@gmx.de, peterz@infradead.org, alex.shi@intel.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, efault@gmx.de, alex.shi@intel.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1323978421.1984.244.camel@sbsiddha-desk.sc.intel.com>
References: <1323978421.1984.244.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix select_idle_sibling()
  regression in selecting an idle SMT sibling
Git-Commit-ID: ab2789213d224202237292d78aaa0c386c7b28b2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 16 Dec 2011 03:36:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab2789213d224202237292d78aaa0c386c7b28b2
Gitweb:     http://git.kernel.org/tip/ab2789213d224202237292d78aaa0c386c7b28b2
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 15 Dec 2011 11:47:00 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 16 Dec 2011 09:44:58 +0100

sched: Fix select_idle_sibling() regression in selecting an idle SMT sibling

Mike Galbraith reported that this recent commit:

   commit 4dcfe1025b513c2c1da5bf5586adb0e80148f612
   Author: Peter Zijlstra <peterz@infradead.org>
   Date:   Thu Nov 10 13:01:10 2011 +0100

       sched: Avoid SMT siblings in select_idle_sibling() if possible

stopped selecting an idle SMT sibling when there are no idle
cores in a single socket system.

Intent of the select_idle_sibling() was to fallback to an idle
SMT sibling, if it fails to identify an idle core. But this
fallback was not happening on systems where all the scheduler
domains had `SD_SHARE_PKG_RESOURCES' flag set.

Fix it. Slightly bigger patch of cleaning all these goto's etc
is queued up for the next release.

Reported-by: Mike Galbraith <efault@gmx.de>
Reported-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1323978421.1984.244.camel@sbsiddha-desk.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
