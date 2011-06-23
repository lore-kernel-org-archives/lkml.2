Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446Ab1FWUfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:35:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45000 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933914Ab1FWUex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:34:53 -0400
From: Eric B Munson <emunson@mgebm.net>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, borislav.petkov@amd.com, bblum@andrew.cmu.edu,
        linux-kernel@vger.kernel.org, mhack@us.ibm.com, eranian@google.com,
        Eric B Munson <emunson@mgebm.net>
Subject: [PATCH 3/3] events: Ensure that timers are updated without requiring read() call
Date: Thu, 23 Jun 2011 16:34:39 -0400
Message-Id: <1308861279-15216-3-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308861279-15216-1-git-send-email-emunson@mgebm.net>
References: <1308861279-15216-1-git-send-email-emunson@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The event tracing infrastructure exposes two timers which should be updated
each time the value of the counter is updated.  Currently, these counters are
only updated when userspace calls read() on the fd associated with an event.
This means that counters which are read via the mmap'd page exclusively never
have their timers updated.  This patch adds ensures that the timers are updated
each time the values in the mmap'd page are updated.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
---
 kernel/events/core.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9e9a7fa..e3be175 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3382,6 +3382,18 @@ void perf_event_update_userpage(struct perf_event *event)
 	struct perf_buffer *buffer;
 
 	rcu_read_lock();
+	/*
+	 * compute total_time_enabled, total_time_running
+	 * based on snapshot values taken when the event
+	 * was last scheduled in.
+	 *
+	 * we cannot simply called update_context_time()
+	 * because of locking issue as we are called in
+	 * NMI context
+	 */
+	calc_timer_values(event,
+				&event->total_time_enabled,
+				&event->total_time_running);
 	buffer = rcu_dereference(event->buffer);
 	if (!buffer)
 		goto unlock;
-- 
1.7.4.1

