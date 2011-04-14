Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab1DNBVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 21:21:41 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50567 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab1DNBVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 21:21:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GIx84oNvol2DwxhUULteKKL7j91iOqmg4i/lxQqAyXgNUXANl8p7G9GyxX3gZYbmGd
         ROFYoUCHKp8BmJkmkjQQ==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Rik van Riel <riel@redhat.com>, Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 1/2] sched: Make set_*_buddy work on non-task entity -v2
Date: Wed, 13 Apr 2011 18:21:09 -0700
Message-Id: <1302744070-30079-2-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <AANLkTi=ao5dci3gb=+UmegZx_ag_X6gAFZ5mBb+8=9hR@mail.gmail.com>
References: <AANLkTi=ao5dci3gb=+UmegZx_ag_X6gAFZ5mBb+8=9hR@mail.gmail.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make set_*_buddy work on non-task sched_entity, to facilitate the
use of next_buddy to cache a group entity in cases where one of the tasks
within that entity sleeps or gets preempted.

set_skip_buddy was wrongly comparing the policy of task that is yielding
to be not equal to SCHED_IDLE. Yielding should happen even when task yielding
is SCHED_IDLE. This change removes the policy check on the yielding task.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched_fair.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 80ecd09..d3513b7 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1826,26 +1826,26 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
 
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
-- 
1.7.3.1

