Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab2ALGRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 01:17:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42734 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab2ALGRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 01:17:51 -0500
Date: Wed, 11 Jan 2012 22:17:09 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-bced76aeaca03b45e3b4bdb868cada328e497847@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        eric.dumazet@gmail.com, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, fweisbec@gmail.com,
        suresh.b.siddha@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, schwidefsky@de.ibm.com,
        fweisbec@gmail.com, dsahern@gmail.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1326297936.2442.157.camel@twins>
References: <1326297936.2442.157.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched:
  Fix lockup by limiting load-balance retries on lock-break
Git-Commit-ID: bced76aeaca03b45e3b4bdb868cada328e497847
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 11 Jan 2012 22:17:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bced76aeaca03b45e3b4bdb868cada328e497847
Gitweb:     http://git.kernel.org/tip/bced76aeaca03b45e3b4bdb868cada328e497847
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 11 Jan 2012 13:11:12 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 11 Jan 2012 17:15:12 +0100

sched: Fix lockup by limiting load-balance retries on lock-break

Eric and David reported dead machines and traced it to commit
a195f004 ("sched: Fix load-balance lock-breaking"), it turns out
there's still a scenario where we can end up re-trying forever.

Since there is no strict forward progress guarantee in the
load-balance iteration we can get stuck re-retrying the same
task-set over and over.

Creating a forward progress guarantee with the existing
structure is somewhat non-trivial, for now simply terminate the
retry loop after a few tries.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Tested-by: Eric Dumazet <eric.dumazet@gmail.com>
Reported-by: David Ahern <dsahern@gmail.com>
[ logic cleanup as suggested by Eric ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1326297936.2442.157.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/fair.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8e42de9..84adb2d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3130,8 +3130,10 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 }
 
 #define LBF_ALL_PINNED	0x01
-#define LBF_NEED_BREAK	0x02
-#define LBF_ABORT	0x04
+#define LBF_NEED_BREAK	0x02	/* clears into HAD_BREAK */
+#define LBF_HAD_BREAK	0x04
+#define LBF_HAD_BREAKS	0x0C	/* count HAD_BREAKs overflows into ABORT */
+#define LBF_ABORT	0x10
 
 /*
  * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
@@ -4508,7 +4510,9 @@ redo:
 			goto out_balanced;
 
 		if (lb_flags & LBF_NEED_BREAK) {
-			lb_flags &= ~LBF_NEED_BREAK;
+			lb_flags += LBF_HAD_BREAK - LBF_NEED_BREAK;
+			if (lb_flags & LBF_ABORT)
+				goto out_balanced;
 			goto redo;
 		}
 
