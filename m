Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab1GGFeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 01:34:24 -0400
Received: from smtp-out.google.com ([74.125.121.67]:3662 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab1GGFdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 01:33:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=wOFfG07dfIOYOlNSqa6xfYoza5wQ3H1qg+KVt4+J7mFaWoeJM6uvu8DacpXAnnkFd
	lbhJ0EtS+1Zt3WzmI2p6A==
Message-Id: <20110707053100.822190945@google.com>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jul 2011 22:30:48 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Hu Tao <hutao@cn.fujitsu.com>
Subject: [patch 12/17] sched: prevent buddy interactions with throttled entities
References: <20110707053036.173186930@google.com>
Content-Disposition: inline; filename=sched-bwc-throttled_buddies.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Buddies allow us to select "on-rq" entities without actually selecting them
from a cfs_rq's rb_tree.  As a result we must ensure that throttled entities
are not falsely nominated as buddies.  The fact that entities are dequeued
within throttle_entity is not sufficient for clearing buddy status as the
nomination may occur after throttling.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched_fair.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -2367,6 +2367,15 @@ static void check_preempt_wakeup(struct 
 	if (unlikely(se == pse))
 		return;
 
+	/*
+	 * This is possible from callers such as pull_task(), in which we
+	 * unconditionally check_prempt_curr() after an enqueue (which may have
+	 * lead to a throttle).  This both saves work and prevents false
+	 * next-buddy nomination below.
+	 */
+	if (unlikely(throttled_hierarchy(cfs_rq_of(pse))))
+		return;
+
 	if (sched_feat(NEXT_BUDDY) && scale && !(wake_flags & WF_FORK)) {
 		set_next_buddy(pse);
 		next_buddy_marked = 1;
@@ -2375,6 +2384,12 @@ static void check_preempt_wakeup(struct 
 	/*
 	 * We can come here with TIF_NEED_RESCHED already set from new task
 	 * wake up path.
+	 *
+	 * Note: this also catches the edge-case of curr being in a throttled
+	 * group (e.g. via set_curr_task), since update_curr() (in the
+	 * enqueue of curr) will have resulted in resched being set.  This
+	 * prevents us from potentially nominating it as a false LAST_BUDDY
+	 * below.
 	 */
 	if (test_tsk_need_resched(curr))
 		return;
@@ -2497,7 +2512,8 @@ static bool yield_to_task_fair(struct rq
 {
 	struct sched_entity *se = &p->se;
 
-	if (!se->on_rq)
+	/* throttled hierarchies are not runnable */
+	if (!se->on_rq || throttled_hierarchy(cfs_rq_of(se)))
 		return false;
 
 	/* Tell the scheduler that we'd really like pse to run next. */


