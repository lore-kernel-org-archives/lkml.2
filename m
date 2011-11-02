Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1KBWk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 18:40:27 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:11082 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab1KBWkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 18:40:25 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, avagin@openvz.org,
        devel@openvz.org
Subject: [PATCH] event: fix TP_printk() argument in sched_switch
Date: Thu,  3 Nov 2011 01:40:11 +0300
Message-Id: <1320273611-2463347-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

process_arg(...) can't parse "__entry->prev_state & (TASK_STATE_MAX-1)",
because a complicated argument should be within brackets.

Without this patch "perf report" prints following errors:
$ ./perf record -ag -e sched:sched_switch
...
$ ./perf report
  Warning: Error: expected type 5 but read 4
  Warning: Error: expected type 4 but read 0
  Fatal: bad op token {

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 include/trace/events/sched.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 959ff18..1838237 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -140,7 +140,7 @@ TRACE_EVENT(sched_switch,
 	TP_printk("prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s%s ==> next_comm=%s next_pid=%d next_prio=%d",
 		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
 		__entry->prev_state & (TASK_STATE_MAX-1) ?
-		  __print_flags(__entry->prev_state & (TASK_STATE_MAX-1), "|",
+		  __print_flags((__entry->prev_state & (TASK_STATE_MAX-1)), "|",
 				{ 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" },
 				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
 				{ 128, "W" }) : "R",
-- 
1.7.1

