Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab1GAPUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:20:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:57441 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527Ab1GAPUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:20:41 -0400
Date: Fri, 1 Jul 2011 15:20:27 GMT
From: tip-bot for Eric B Munson <emunson@mgebm.net>
Message-ID: <tip-0d6412085b7ff58612af52e51ffa864f0df4b8fd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        emunson@mgebm.net
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, emunson@mgebm.net,
        mingo@elte.hu
In-Reply-To: <1308932786-5111-1-git-send-email-emunson@mgebm.net>
References: <1308932786-5111-1-git-send-email-emunson@mgebm.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] events: Ensure that timers are updated without requiring read() call
Git-Commit-ID: 0d6412085b7ff58612af52e51ffa864f0df4b8fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:20:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d6412085b7ff58612af52e51ffa864f0df4b8fd
Gitweb:     http://git.kernel.org/tip/0d6412085b7ff58612af52e51ffa864f0df4b8fd
Author:     Eric B Munson <emunson@mgebm.net>
AuthorDate: Fri, 24 Jun 2011 12:26:26 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 11:06:34 +0200

events: Ensure that timers are updated without requiring read() call

The event tracing infrastructure exposes two timers which should be updated
each time the value of the counter is updated.  Currently, these counters are
only updated when userspace calls read() on the fd associated with an event.
This means that counters which are read via the mmap'd page exclusively never
have their timers updated.  This patch adds ensures that the timers are updated
each time the values in the mmap'd page are updated.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1308932786-5111-1-git-send-email-emunson@mgebm.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c851d70..270e32f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3372,8 +3372,19 @@ void perf_event_update_userpage(struct perf_event *event)
 {
 	struct perf_event_mmap_page *userpg;
 	struct ring_buffer *rb;
+	u64 enabled, running;
 
 	rcu_read_lock();
+	/*
+	 * compute total_time_enabled, total_time_running
+	 * based on snapshot values taken when the event
+	 * was last scheduled in.
+	 *
+	 * we cannot simply called update_context_time()
+	 * because of locking issue as we can be called in
+	 * NMI context
+	 */
+	calc_timer_values(event, &enabled, &running);
 	rb = rcu_dereference(event->rb);
 	if (!rb)
 		goto unlock;
@@ -3392,10 +3403,10 @@ void perf_event_update_userpage(struct perf_event *event)
 	if (event->state == PERF_EVENT_STATE_ACTIVE)
 		userpg->offset -= local64_read(&event->hw.prev_count);
 
-	userpg->time_enabled = event->total_time_enabled +
+	userpg->time_enabled = enabled +
 			atomic64_read(&event->child_total_time_enabled);
 
-	userpg->time_running = event->total_time_running +
+	userpg->time_running = running +
 			atomic64_read(&event->child_total_time_running);
 
 	barrier();
