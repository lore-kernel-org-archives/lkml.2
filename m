Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab0DRTDc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 15:03:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:44621 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab0DRTCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 15:02:19 -0400
Date: Sun, 18 Apr 2010 12:01:50 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org,
       mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de,
       davej@redhat.com, cpufreq@vger.kernel.org
Subject: [PATCH 3/7] sched: update the idle statistics in
 get_cpu_idle_time_us()
Message-ID: <20100418120150.383061b5@infradead.org>
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

>From 60851b131900af03bf013afef69f3bcdbb04f1d6 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 18 Apr 2010 10:41:30 -0700
Subject: [PATCH 3/7] sched: update the idle statistics in get_cpu_idle_time_us()

Right now, get_cpu_idle_time_us() only reports the idle statistics
upto the point the CPU entered last idle; not what is valid right now.

This patch adds an update of the idle statistics to get_cpu_idle_time_us(),
so that calling this function always returns statistics that are accurate
at the point of the call.

This includes resetting the start of the idle time for accounting purposes
to avoid double accounting.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/time/tick-sched.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index ca2211d..7dbad2f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -161,6 +161,7 @@ static void update_ts_time_stats(struct tick_sched *ts, ktime_t now)
 	if (ts->idle_active) {
 		delta = ktime_sub(now, ts->idle_entrytime);
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+		ts->idle_entrytime = now;
 	}
 }
 
@@ -205,14 +206,18 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t now;
 
 	if (!tick_nohz_enabled)
 		return -1;
 
+	now = ktime_get();
+	update_ts_time_stats(ts, now);
+
 	if (ts->idle_active)
 		*last_update_time = ktime_to_us(ts->idle_lastupdate);
 	else
-		*last_update_time = ktime_to_us(ktime_get());
+		*last_update_time = ktime_to_us(now);
 
 	return ktime_to_us(ts->idle_sleeptime);
 }
-- 
1.6.2.5

