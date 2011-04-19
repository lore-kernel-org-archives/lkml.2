Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab1DSMFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 08:05:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:38366 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab1DSMFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 08:05:30 -0400
Date: Tue, 19 Apr 2011 12:05:15 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Message-ID: <tip-69c80f3e9d3c569f8a3cee94ba1a324b5a7fa6b9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, venki@google.com,
        mingo@elte.hu
In-Reply-To: <1302744070-30079-2-git-send-email-venki@google.com>
References: <1302744070-30079-2-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Make set_*_buddy() work on non-task entities
Git-Commit-ID: 69c80f3e9d3c569f8a3cee94ba1a324b5a7fa6b9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Apr 2011 12:05:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69c80f3e9d3c569f8a3cee94ba1a324b5a7fa6b9
Gitweb:     http://git.kernel.org/tip/69c80f3e9d3c569f8a3cee94ba1a324b5a7fa6b9
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Wed, 13 Apr 2011 18:21:09 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 19 Apr 2011 10:08:37 +0200

sched: Make set_*_buddy() work on non-task entities

Make set_*_buddy() work on non-task sched_entity, to facilitate the
use of next_buddy to cache a group entity in cases where one of the
tasks within that entity sleeps or gets preempted.

set_skip_buddy() was incorrectly comparing the policy of task that is
yielding to be not equal to SCHED_IDLE. Yielding should happen even
when task yielding is SCHED_IDLE. This change removes the policy check
on the yielding task.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1302744070-30079-2-git-send-email-venki@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8744593..501ab63 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1846,26 +1846,26 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
 
 static void set_last_buddy(struct sched_entity *se)
 {
-	if (likely(task_of(se)->policy != SCHED_IDLE)) {
-		for_each_sched_entity(se)
-			cfs_rq_of(se)->last = se;
-	}
+	if (entity_is_task(se) && unlikely(task_of(se)->policy == SCHED_IDLE))
+		return;
+
+	for_each_sched_entity(se)
+		cfs_rq_of(se)->last = se;
 }
 
 static void set_next_buddy(struct sched_entity *se)
 {
-	if (likely(task_of(se)->policy != SCHED_IDLE)) {
-		for_each_sched_entity(se)
-			cfs_rq_of(se)->next = se;
-	}
+	if (entity_is_task(se) && unlikely(task_of(se)->policy == SCHED_IDLE))
+		return;
+
+	for_each_sched_entity(se)
+		cfs_rq_of(se)->next = se;
 }
 
 static void set_skip_buddy(struct sched_entity *se)
 {
-	if (likely(task_of(se)->policy != SCHED_IDLE)) {
-		for_each_sched_entity(se)
-			cfs_rq_of(se)->skip = se;
-	}
+	for_each_sched_entity(se)
+		cfs_rq_of(se)->skip = se;
 }
 
 /*
