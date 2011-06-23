Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482Ab1FWOPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:15:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59489 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab1FWOPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:15:53 -0400
From: Eric B Munson <emunson@mgebm.net>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, borislav.petkov@amd.com, bblum@andrew.cmu.edu,
        linux-kernel@vger.kernel.org, mhack@us.ibm.com,
        Eric B Munson <emunson@mgebm.net>
Subject: [PATCH] events: Ensure that timers are updated without requiring read() call
Date: Thu, 23 Jun 2011 10:15:37 -0400
Message-Id: <1308838537-6682-1-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.4.1
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
 kernel/events/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9efe710..3dd4ebe 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3369,6 +3369,7 @@ void perf_event_update_userpage(struct perf_event *event)
 	struct perf_buffer *buffer;
 
 	rcu_read_lock();
+	update_event_times(event);
 	buffer = rcu_dereference(event->buffer);
 	if (!buffer)
 		goto unlock;
-- 
1.7.4.1

