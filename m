Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470Ab2JAXMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:12:25 -0400
Received: from 1wt.eu ([62.212.114.60]:35542 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933128Ab2JAXCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:23 -0400
Message-Id: <20121001225159.013913784@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:30 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Willy Tarreau <w@1wt.eu>
Subject: [ 033/180] sched: Fix signed unsigned comparison in check_preempt_tick()
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Galbraith <efault@gmx.de>

commit d7d8294415f0ce4254827d4a2a5ee88b00be52a8 upstream.

Signed unsigned comparison may lead to superfluous resched if leftmost
is right of the current task, wasting a few cycles, and inadvertently
_lengthening_ the current task's slice.

Reported-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1294202477.9384.5.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/sched_fair.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index cd9a40b..fd6e5f2 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -862,6 +862,9 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 		struct sched_entity *se = __pick_next_entity(cfs_rq);
 		s64 delta = curr->vruntime - se->vruntime;
 
+		if (delta < 0)
+			return;
+
 		if (delta > ideal_runtime)
 			resched_task(rq_of(cfs_rq)->curr);
 	}
-- 
1.7.2.1.45.g54fbc



