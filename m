Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751044Ab2JICIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 22:08:52 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:48236 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2JICIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 22:08:47 -0400
X-AuditID: b753bd60-94fe2ba000004744-b0-5073872c5f1b
X-AuditID: b753bd60-94fe2ba000004744-b0-5073872c5f1b
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH 2/2] ftrace: Show raw time stamp on stats per cpu using
 counter or tsc mode for trace_clock
To: Steven Rostedt <rostedt@goodmis.org>, David Sharp <dhsharp@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Tue, 09 Oct 2012 11:08:43 +0900
Message-ID: <20121009020843.12110.63163.stgit@localhost.localdomain>
In-Reply-To: <20121009020838.12110.90016.stgit@localhost.localdomain>
References: <20121009020838.12110.90016.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show raw time stamp values for stats per cpu if you choose counter or tsc mode
for trace_clock. Although a unit of tracing time stamp is nsec in local or global mode,
the units in counter and TSC mode are tracing counter and cycles respectively.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---

 kernel/trace/trace.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3068374..83e5c6a 100644
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
 

