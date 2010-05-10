Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab0EJFyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:54:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:33846 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab0EJFyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:54:04 -0400
Date: Mon, 10 May 2010 05:53:09 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, arjan@linux.intel.com, riel@redhat.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: riel@redhat.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100509082323.2d2f1945@infradead.org>
References: <20100509082323.2d2f1945@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Update the idle statistics in get_cpu_idle_time_us()
Message-ID: <tip-8c7b09f43f4bf570654bcc458ce96819a932303c@git.kernel.org>
Git-Commit-ID: 8c7b09f43f4bf570654bcc458ce96819a932303c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 10 May 2010 05:53:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c7b09f43f4bf570654bcc458ce96819a932303c
Gitweb:     http://git.kernel.org/tip/8c7b09f43f4bf570654bcc458ce96819a932303c
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Sun, 9 May 2010 08:23:23 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 9 May 2010 19:35:26 +0200

sched: Update the idle statistics in get_cpu_idle_time_us()

Right now, get_cpu_idle_time_us() only reports the idle
statistics upto the point the CPU entered last idle; not what is
valid right now.

This patch adds an update of the idle statistics to
get_cpu_idle_time_us(), so that calling this function always
returns statistics that are accurate at the point of the call.

This includes resetting the start of the idle time for
accounting purposes to avoid double accounting.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: davej@redhat.com
LKML-Reference: <20100509082323.2d2f1945@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/time/tick-sched.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 59d8762..f15d18d 100644
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
