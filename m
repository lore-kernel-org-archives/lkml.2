Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab2JKX2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 19:28:09 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:47369 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2JKX2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 19:28:02 -0400
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, David Sharp <dhsharp@google.com>
Subject: [PATCH v6 5/6] ftrace: Show raw time stamp on stats per cpu using counter or tsc mode for trace_clock
Date: Thu, 11 Oct 2012 16:27:55 -0700
Message-Id: <1349998076-15495-6-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1349998076-15495-1-git-send-email-dhsharp@google.com>
References: <1349998076-15495-1-git-send-email-dhsharp@google.com>
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
index cff3427..8bfa3b7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4396,13 +4396,24 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
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
 
 	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
 
-- 
1.7.7.3

