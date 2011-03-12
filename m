Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab1CLW76 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 17:59:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab1CLW7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 17:59:53 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/2] tracing - trace lost events properly
Date: Sat, 12 Mar 2011 23:59:45 +0100
Message-Id: <1299970786-8075-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1299970786-8075-1-git-send-email-jolsa@redhat.com>
References: <1299970786-8075-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add proper handling of lost event trace, allowing callers
to get correct trace buffer info.

 - returning TRACE_TYPE_PARTIAL_LINE, in case we dont fit into
   the trace_seq buffer
 - added WARN_ON to make sure we don't miss incorrect trace_seq
   handling

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9541c27..20d84f8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2013,9 +2013,10 @@ enum print_line_t print_trace_line(struct trace_iterator *iter)
 {
 	enum print_line_t ret;
 
-	if (iter->lost_events)
-		trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
-				 iter->cpu, iter->lost_events);
+	if (iter->lost_events &&
+	    !trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
+				 iter->cpu, iter->lost_events))
+		return TRACE_TYPE_PARTIAL_LINE;
 
 	if (iter->trace && iter->trace->print_line) {
 		ret = iter->trace->print_line(iter);
@@ -3229,6 +3230,13 @@ waitagain:
 
 		if (iter->seq.len >= cnt)
 			break;
+
+		/*
+		 * Setting the full flag means we reached the trace_seq buffer
+		 * size and we should leave by partial output condition above.
+		 * One of the trace_seq_* functions is not used properly.
+		 */
+		WARN_ON(iter->seq.full);
 	}
 	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
-- 
1.7.1

