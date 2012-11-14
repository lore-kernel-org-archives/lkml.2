Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab2KNGpD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:45:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43276 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2KNGpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:45:01 -0500
Date: Tue, 13 Nov 2012 22:44:43 -0800
From: tip-bot for Slava Pestov <slavapestov@google.com>
Message-ID: <tip-884bfe89a462fcc85c8abd96171519cf2fe70929@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, slavapestov@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, slavapestov@google.com
In-Reply-To: <1310765038-26399-1-git-send-email-slavapestov@google.com>
References: <1310765038-26399-1-git-send-email-slavapestov@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ring-buffer: Add a 'dropped events' counter
Git-Commit-ID: 884bfe89a462fcc85c8abd96171519cf2fe70929
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:44:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  884bfe89a462fcc85c8abd96171519cf2fe70929
Gitweb:     http://git.kernel.org/tip/884bfe89a462fcc85c8abd96171519cf2fe70929
Author:     Slava Pestov <slavapestov@google.com>
AuthorDate: Fri, 15 Jul 2011 14:23:58 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 31 Oct 2012 16:45:27 -0400

ring-buffer: Add a 'dropped events' counter

The existing 'overrun' counter is incremented when the ring
buffer wraps around, with overflow on (the default). We wanted
a way to count requests lost from the buffer filling up with
overflow off, too. I decided to add a new counter instead
of retro-fitting the existing one because it seems like a
different statistic to count conceptually, and also because
of how the code was structured.

Link: http://lkml.kernel.org/r/1310765038-26399-1-git-send-email-slavapestov@google.com

Signed-off-by: Slava Pestov <slavapestov@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ring_buffer.h |    1 +
 kernel/trace/ring_buffer.c  |   41 +++++++++++++++++++++++++++++++++++------
 kernel/trace/trace.c        |    3 +++
 3 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 6c8835f..2007375 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -166,6 +166,7 @@ unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
 unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu);
+unsigned long ring_buffer_dropped_events_cpu(struct ring_buffer *buffer, int cpu);
 
 u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu);
 void ring_buffer_normalize_time_stamp(struct ring_buffer *buffer,
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index b979426..0ebeb1d 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -460,9 +460,10 @@ struct ring_buffer_per_cpu {
 	unsigned long			lost_events;
 	unsigned long			last_overrun;
 	local_t				entries_bytes;
-	local_t				commit_overrun;
-	local_t				overrun;
 	local_t				entries;
+	local_t				overrun;
+	local_t				commit_overrun;
+	local_t				dropped_events;
 	local_t				committing;
 	local_t				commits;
 	unsigned long			read;
@@ -2155,8 +2156,10 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 			 * If we are not in overwrite mode,
 			 * this is easy, just stop here.
 			 */
-			if (!(buffer->flags & RB_FL_OVERWRITE))
+			if (!(buffer->flags & RB_FL_OVERWRITE)) {
+				local_inc(&cpu_buffer->dropped_events);
 				goto out_reset;
+			}
 
 			ret = rb_handle_head_page(cpu_buffer,
 						  tail_page,
@@ -2995,7 +2998,8 @@ unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
 EXPORT_SYMBOL_GPL(ring_buffer_entries_cpu);
 
 /**
- * ring_buffer_overrun_cpu - get the number of overruns in a cpu_buffer
+ * ring_buffer_overrun_cpu - get the number of overruns caused by the ring
+ * buffer wrapping around (only if RB_FL_OVERWRITE is on).
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to get the number of overruns from
  */
@@ -3015,7 +3019,9 @@ unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu)
 EXPORT_SYMBOL_GPL(ring_buffer_overrun_cpu);
 
 /**
- * ring_buffer_commit_overrun_cpu - get the number of overruns caused by commits
+ * ring_buffer_commit_overrun_cpu - get the number of overruns caused by
+ * commits failing due to the buffer wrapping around while there are uncommitted
+ * events, such as during an interrupt storm.
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to get the number of overruns from
  */
@@ -3036,6 +3042,28 @@ ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu)
 EXPORT_SYMBOL_GPL(ring_buffer_commit_overrun_cpu);
 
 /**
+ * ring_buffer_dropped_events_cpu - get the number of dropped events caused by
+ * the ring buffer filling up (only if RB_FL_OVERWRITE is off).
+ * @buffer: The ring buffer
+ * @cpu: The per CPU buffer to get the number of overruns from
+ */
+unsigned long
+ring_buffer_dropped_events_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long ret;
+
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+		return 0;
+
+	cpu_buffer = buffer->buffers[cpu];
+	ret = local_read(&cpu_buffer->dropped_events);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_dropped_events_cpu);
+
+/**
  * ring_buffer_entries - get the number of entries in a buffer
  * @buffer: The ring buffer
  *
@@ -3864,9 +3892,10 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
 	cpu_buffer->reader_page->read = 0;
 
-	local_set(&cpu_buffer->commit_overrun, 0);
 	local_set(&cpu_buffer->entries_bytes, 0);
 	local_set(&cpu_buffer->overrun, 0);
+	local_set(&cpu_buffer->commit_overrun, 0);
+	local_set(&cpu_buffer->dropped_events, 0);
 	local_set(&cpu_buffer->entries, 0);
 	local_set(&cpu_buffer->committing, 0);
 	local_set(&cpu_buffer->commits, 0);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f6928ed..36c213f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4385,6 +4385,9 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	usec_rem = do_div(t, USEC_PER_SEC);
 	trace_seq_printf(s, "now ts: %5llu.%06lu\n", t, usec_rem);
 
+	cnt = ring_buffer_dropped_events_cpu(tr->buffer, cpu);
+	trace_seq_printf(s, "dropped events: %ld\n", cnt);
+
 	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
 
 	kfree(s);
