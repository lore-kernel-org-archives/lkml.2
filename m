Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab2KMUSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 15:18:44 -0500
Received: from mail-we0-f202.google.com ([74.125.82.202]:39332 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab2KMUSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 15:18:41 -0500
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, David Sharp <dhsharp@google.com>
Subject: [PATCH v9 3/3] ftrace: Show raw time stamp on stats per cpu using counter or tsc mode for trace_clock
Date: Tue, 13 Nov 2012 12:18:23 -0800
Message-Id: <1352837903-32191-3-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1352837903-32191-1-git-send-email-dhsharp@google.com>
References: <1352837903-32191-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>

Show raw time stamp values for stats per cpu if you choose counter or tsc mode
for trace_clock. Although a unit of tracing time stamp is nsec in local or global mode,
the units in counter and TSC mode are tracing counter and cycles respectively.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: David Sharp <dhsharp@google.com>
---
 kernel/trace/trace.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d943e69..b69cc38 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4388,13 +4388,24 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	cnt = ring_buffer_bytes_cpu(tr->buffer, cpu);
 	trace_seq_printf(s, "bytes: %ld\n", cnt);
 
-	t = ns2usecs(ring_buffer_oldest_event_ts(tr->buffer, cpu));
-	usec_rem = do_div(t, USEC_PER_SEC);
-	trace_seq_printf(s, "oldest event ts: %5llu.%06lu\n", t, usec_rem);
+	if (trace_clocks[trace_clock_id].in_ns) {
+		/* local or global for trace_clock */
+		t = ns2usecs(ring_buffer_oldest_event_ts(tr->buffer, cpu));
+		usec_rem = do_div(t, USEC_PER_SEC);
+		trace_seq_printf(s, "oldest event ts: %5llu.%06lu\n",
+								t, usec_rem);
+
+		t = ns2usecs(ring_buffer_time_stamp(tr->buffer, cpu));
+		usec_rem = do_div(t, USEC_PER_SEC);
+		trace_seq_printf(s, "now ts: %5llu.%06lu\n", t, usec_rem);
+	} else {
+		/* counter or tsc mode for trace_clock */
+		trace_seq_printf(s, "oldest event ts: %llu\n",
+				ring_buffer_oldest_event_ts(tr->buffer, cpu));
 
-	t = ns2usecs(ring_buffer_time_stamp(tr->buffer, cpu));
-	usec_rem = do_div(t, USEC_PER_SEC);
-	trace_seq_printf(s, "now ts: %5llu.%06lu\n", t, usec_rem);
+		trace_seq_printf(s, "now ts: %llu\n",
+				ring_buffer_time_stamp(tr->buffer, cpu));
+	}
 
 	cnt = ring_buffer_dropped_events_cpu(tr->buffer, cpu);
 	trace_seq_printf(s, "dropped events: %ld\n", cnt);
-- 
1.7.7.3

