Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab2CAMRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:17:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37484 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab2CAMRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:17:30 -0500
Date: Thu, 1 Mar 2012 04:16:40 -0800
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-7x70cypsotjb4jvcor3edctk@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Do not throttle when PI boosting
Git-Commit-ID: 7abc63b1bd412f7655b62ef3e35c3c11c5134636
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 01 Mar 2012 04:17:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7abc63b1bd412f7655b62ef3e35c3c11c5134636
Gitweb:     http://git.kernel.org/tip/7abc63b1bd412f7655b62ef3e35c3c11c5134636
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 18 Oct 2011 22:03:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Mar 2012 10:28:02 +0100

sched/rt: Do not throttle when PI boosting

When a runqueue has rt_runtime_us = 0 then the only way it can
accumulate rt_time is via PI boosting. That causes the runqueue
to be throttled and replenishing does not change anything due to
rt_runtime_us = 0. So avoid that situation by clearing rt_time and
skip the throttling alltogether.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
[ Changelog ]
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/n/tip-7x70cypsotjb4jvcor3edctk@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/rt.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 6d1eb0b..7f7e7cd 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -857,8 +857,24 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 		return 0;
 
 	if (rt_rq->rt_time > runtime) {
-		rt_rq->rt_throttled = 1;
-		printk_once(KERN_WARNING "sched: RT throttling activated\n");
+		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+
+		/*
+		 * Don't actually throttle groups that have no runtime assigned
+		 * but accrue some time due to boosting.
+		 */
+		if (likely(rt_b->rt_runtime)) {
+			rt_rq->rt_throttled = 1;
+			printk_once(KERN_WARNING "sched: RT throttling activated\n");
+		} else {
+			/*
+			 * In case we did anyway, make it go away,
+			 * replenishment is a joke, since it will replenish us
+			 * with exactly 0 ns.
+			 */
+			rt_rq->rt_time = 0;
+		}
+
 		if (rt_rq_throttled(rt_rq)) {
 			sched_rt_rq_dequeue(rt_rq);
 			return 1;
