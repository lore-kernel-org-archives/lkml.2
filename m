Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab0DRTCa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 15:02:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:44638 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab0DRTCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 15:02:24 -0400
Date: Sun, 18 Apr 2010 12:02:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org,
       mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de,
       davej@redhat.com, cpufreq@vger.kernel.org
Subject: [PATCH 5/7] sched: eliminate the ts->idle_lastupdate field
Message-ID: <20100418120258.09c95042@infradead.org>
In-Reply-To: <20100418115949.7b743898@infradead.org>
References: <20100418115949.7b743898@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 526a9f347d5a953f37b67b4b2afb39d7b4d77a92 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 18 Apr 2010 10:49:30 -0700
Subject: [PATCH 5/7] sched: eliminate the ts->idle_lastupdate field

Now that the only user of ts->idle_lastupdate is update_ts_time_stats(),
the entire field can be eliminated.

In update_ts_time_stats(), idle_lastupdate is first set to "now",
and a few lines later, the only user is an if() statement that
assigns a variable either to "now" or to ts->idle_lastupdate,
which has the value of "now" at that point.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
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
index ac54543..326f5f8 100644
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
-- 
1.6.2.5

