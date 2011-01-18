Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab1ARTGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:06:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:53096 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab1ARTGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:06:38 -0500
Date: Tue, 18 Jan 2011 19:06:14 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
In-Reply-To: <1294202477.9384.5.camel@marge.simson.net>
References: <1294202477.9384.5.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix signed unsigned comparison in check_preempt_tick()
Message-ID: <tip-d7d8294415f0ce4254827d4a2a5ee88b00be52a8@git.kernel.org>
Git-Commit-ID: d7d8294415f0ce4254827d4a2a5ee88b00be52a8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 Jan 2011 19:06:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7d8294415f0ce4254827d4a2a5ee88b00be52a8
Gitweb:     http://git.kernel.org/tip/d7d8294415f0ce4254827d4a2a5ee88b00be52a8
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Wed, 5 Jan 2011 05:41:17 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Jan 2011 15:09:44 +0100

sched: Fix signed unsigned comparison in check_preempt_tick()

Signed unsigned comparison may lead to superfluous resched if leftmost
is right of the current task, wasting a few cycles, and inadvertently
_lengthening_ the current task's slice.

Reported-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1294202477.9384.5.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 414145c..77e9166 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1062,6 +1062,9 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 		struct sched_entity *se = __pick_next_entity(cfs_rq);
 		s64 delta = curr->vruntime - se->vruntime;
 
+		if (delta < 0)
+			return;
+
 		if (delta > ideal_runtime)
 			resched_task(rq_of(cfs_rq)->curr);
 	}
