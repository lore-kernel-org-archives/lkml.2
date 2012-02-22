Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab2BVJZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 04:25:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49427 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab2BVJZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 04:25:05 -0500
Message-ID: <4F44B578.4030007@cn.fujitsu.com>
Date: Wed, 22 Feb 2012 17:29:28 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH 1/3 RFC paul/rcu/srcu] srcu: Remove fast check path
References: <20120213020951.GA12138@linux.vnet.ibm.com> <4F41F315.1040900@cn.fujitsu.com> <20120220174418.GI2470@linux.vnet.ibm.com> <4F42EF53.6060400@cn.fujitsu.com> <20120221015037.GE2384@linux.vnet.ibm.com> <4F435966.9020106@cn.fujitsu.com> <20120221172442.GG2375@linux.vnet.ibm.com>
In-Reply-To: <20120221172442.GG2375@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-22 17:23:17,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-22 17:23:19,
	Serialize complete at 2012-02-22 17:23:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All

These three patches reduce the states of srcu.
the call_srcu() will be implemented based on this new algorithm if it has no problem.

It is an aggressive algorithm, it needs more reviews, please examine it critically
and leave your comments.

Thanks,
Lai.

>From abe3fd64d08f74f13e8111e333a9790e9e6d782c Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Wed, 22 Feb 2012 10:15:48 +0800
Subject: [PATCH 1/3 RFC paul/rcu/srcu] srcu: Remove fast check path

This fast check path is used for optimizing the situation
that there are many concurrently update site.

But we have no suck situation in currect kernel.
And it introduces complexity, so we just remove it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/srcu.c |   25 +------------------------
 1 files changed, 1 insertions(+), 24 deletions(-)

diff --git a/kernel/srcu.c b/kernel/srcu.c
index 84c9b97..17e95bc 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -308,7 +308,7 @@ static void flip_idx_and_wait(struct srcu_struct *sp, bool expedited)
  */
 static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
 {
-	int idx;
+	int idx = 0;
 
 	rcu_lockdep_assert(!lock_is_held(&sp->dep_map) &&
 			   !lock_is_held(&rcu_bh_lock_map) &&
@@ -316,32 +316,9 @@ static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
 			   !lock_is_held(&rcu_sched_lock_map),
 			   "Illegal synchronize_srcu() in same-type SRCU (or RCU) read-side critical section");
 
-	smp_mb();  /* Ensure prior action happens before grace period. */
-	idx = ACCESS_ONCE(sp->completed);
-	smp_mb();  /* Access to ->completed before lock acquisition. */
 	mutex_lock(&sp->mutex);
 
 	/*
-	 * Check to see if someone else did the work for us while we were
-	 * waiting to acquire the lock.  We need -three- advances of
-	 * the counter, not just one.  If there was but one, we might have
-	 * shown up -after- our helper's first synchronize_sched(), thus
-	 * having failed to prevent CPU-reordering races with concurrent
-	 * srcu_read_unlock()s on other CPUs (see comment below).  If there
-	 * was only two, we are guaranteed to have waited through only one
-	 * full index-flip phase.  So we either (1) wait for three or
-	 * (2) supply the additional ones we need.
-	 */
-
-	if (sp->completed == idx + 2)
-		idx = 1;
-	else if (sp->completed == idx + 3) {
-		mutex_unlock(&sp->mutex);
-		return;
-	} else
-		idx = 0;
-
-	/*
 	 * If there were no helpers, then we need to do two flips of
 	 * the index.  The first flip is required if there are any
 	 * outstanding SRCU readers even if there are no new readers
-- 
1.7.4.4
