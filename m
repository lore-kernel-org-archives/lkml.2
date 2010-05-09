Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab0EIPZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 11:25:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:40376 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab0EIPYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 11:24:24 -0400
Date: Sun, 9 May 2010 08:24:39 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, davej@redhat.com
Subject: [PATCH v2  5/8] sched: Eliminate the ts->idle_lastupdate field
Message-ID: <20100509082439.2fab0b4f@infradead.org>
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

Now that the only user of ts->idle_lastupdate is update_ts_time_stats(),
the entire field can be eliminated.

In update_ts_time_stats(), idle_lastupdate is first set to "now",
and a few lines later, the only user is an if() statement that
assigns a variable either to "now" or to ts->idle_lastupdate,
which has the value of "now" at that point.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
---

 include/linux/tick.h     |    1 -
 kernel/time/tick-sched.c |    5 +----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff -puN include/linux/tick.h~sched-eliminate-the-ts-idle_lastupdate-field include/linux/tick.h
--- a/include/linux/tick.h~sched-eliminate-the-ts-idle_lastupdate-field
+++ a/include/linux/tick.h
@@ -60,7 +60,6 @@ struct tick_sched {
 	ktime_t				idle_waketime;
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
-	ktime_t				idle_lastupdate;
 	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
diff -puN kernel/time/tick-sched.c~sched-eliminate-the-ts-idle_lastupdate-field kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~sched-eliminate-the-ts-idle_lastupdate-field
+++ a/kernel/time/tick-sched.c
@@ -158,16 +158,13 @@ update_ts_time_stats(struct tick_sched *
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
_
