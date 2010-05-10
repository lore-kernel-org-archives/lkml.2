Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab0EJFyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:54:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:33874 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199Ab0EJFyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:54:36 -0400
Date: Mon, 10 May 2010 05:53:44 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, arjan@linux.intel.com, riel@redhat.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: riel@redhat.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100509082439.2fab0b4f@infradead.org>
References: <20100509082439.2fab0b4f@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Eliminate the ts->idle_lastupdate field
Message-ID: <tip-e0e37c200f1357db0dd986edb359c41c57d24f6e@git.kernel.org>
Git-Commit-ID: e0e37c200f1357db0dd986edb359c41c57d24f6e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 10 May 2010 05:53:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e0e37c200f1357db0dd986edb359c41c57d24f6e
Gitweb:     http://git.kernel.org/tip/e0e37c200f1357db0dd986edb359c41c57d24f6e
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Sun, 9 May 2010 08:24:39 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 9 May 2010 19:35:26 +0200

sched: Eliminate the ts->idle_lastupdate field

Now that the only user of ts->idle_lastupdate is
update_ts_time_stats(), the entire field can be eliminated.

In update_ts_time_stats(), idle_lastupdate is first set to
"now", and a few lines later, the only user is an if() statement
that assigns a variable either to "now" or to
ts->idle_lastupdate, which has the value of "now" at that point.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: davej@redhat.com
LKML-Reference: <20100509082439.2fab0b4f@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/tick.h     |    1 -
 kernel/time/tick-sched.c |    5 +----
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index d2ae79e..0343eed 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -60,7 +60,6 @@ struct tick_sched {
 	ktime_t				idle_waketime;
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
-	ktime_t				idle_lastupdate;
 	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e86e1c6..50953f4 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -158,16 +158,13 @@ update_ts_time_stats(struct tick_sched *ts, ktime_t now, u64 *last_update_time)
 {
 	ktime_t delta;
 
-	ts->idle_lastupdate = now;
 	if (ts->idle_active) {
 		delta = ktime_sub(now, ts->idle_entrytime);
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 		ts->idle_entrytime = now;
 	}
 
-	if (ts->idle_active && last_update_time)
-		*last_update_time = ktime_to_us(ts->idle_lastupdate);
-	else
+	if (last_update_time)
 		*last_update_time = ktime_to_us(now);
 
 }
