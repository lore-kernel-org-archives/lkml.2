Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab0EIPY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 11:24:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:40369 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0EIPYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 11:24:21 -0400
Date: Sun, 9 May 2010 08:23:23 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, davej@redhat.com
Subject: [PATCH v2  3/8] sched: Update the idle statistics in
 get_cpu_idle_time_us()
Message-ID: <20100509082323.2d2f1945@infradead.org>
In-Reply-To: <20100509082126.4a080d46@infradead.org>
References: <20100509082126.4a080d46@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

Right now, get_cpu_idle_time_us() only reports the idle statistics
upto the point the CPU entered last idle; not what is valid right now.

This patch adds an update of the idle statistics to get_cpu_idle_time_us(),
so that calling this function always returns statistics that are accurate
at the point of the call.

This includes resetting the start of the idle time for accounting purposes
to avoid double accounting.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
---

 kernel/time/tick-sched.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN kernel/time/tick-sched.c~sched-update-the-idle-statistics-in-get_cpu_idle_time_us kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~sched-update-the-idle-statistics-in-get_cpu_idle_time_us
+++ a/kernel/time/tick-sched.c
@@ -161,6 +161,7 @@ static void update_ts_time_stats(struct 
 	if (ts->idle_active) {
 		delta = ktime_sub(now, ts->idle_entrytime);
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+		ts->idle_entrytime = now;
 	}
 }
 
@@ -205,14 +206,18 @@ static ktime_t tick_nohz_start_idle(stru
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
_
