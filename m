Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab2JQC5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:57:12 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:33036 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab2JQC4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:56:30 -0400
X-AuditID: b753bd60-928c4ba0000047ca-1b-507e1e5d96c0
X-AuditID: b753bd60-928c4ba0000047ca-1b-507e1e5d96c0
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH v2 -tip 2/4] tracing: add a resize function for making one
 buffer equivalent to the other buffer
To: rostedt@goodmis.org
Cc: yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Wed, 17 Oct 2012 11:56:16 +0900
Message-ID: <20121017025616.2627.91226.stgit@falsita>
In-Reply-To: <20121017025608.2627.87497.stgit@falsita>
References: <20121017025608.2627.87497.stgit@falsita>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace buffer size is now per-cpu, so that there are following two
patterns in resize of the buffers.

  (1) resize per-cpu buffers to same given size
  (2) resize per-cpu buffers to the other trace_array's buffer size
      for each CPU (such as preparing the max_tr which is equivalent
      to the global_trace's size)

__tracing_resize_ring_buffer() can be used for (1), and had
implemented (2) inside it for resetting the global_trace to the
original size.

(2) was also implemented in other place. So this patch assembles
them in a new function - resize_buffer_duplicate_size().

Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
---

 kernel/trace/trace.c |   58 +++++++++++++++++++++++++++-----------------------
 1 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 08acf42..d71eee1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3017,6 +3017,31 @@ static void set_buffer_entries(struct trace_array *tr, unsigned long val)
 		tr->data[cpu]->entries = val;
 }
 
+/* resize @tr's buffer to the size of @size_tr's entries */
+static int resize_buffer_duplicate_size(struct trace_array *tr,
+					struct trace_array *size_tr, int cpu_id)
+{
+	int cpu, ret = 0;
+
+	if (cpu_id == RING_BUFFER_ALL_CPUS) {
+		for_each_tracing_cpu(cpu) {
+			ret = ring_buffer_resize(tr->buffer,
+					size_tr->data[cpu]->entries, cpu);
+			if (ret < 0)
+				break;
+			tr->data[cpu]->entries = size_tr->data[cpu]->entries;
+		}
+	} else {
+		ret = ring_buffer_resize(tr->buffer,
+					size_tr->data[cpu_id]->entries, cpu_id);
+		if (ret == 0)
+			tr->data[cpu_id]->entries =
+				size_tr->data[cpu_id]->entries;
+	}
+
+	return ret;
+}
+
 static int __tracing_resize_ring_buffer(unsigned long size, int cpu)
 {
 	int ret;
@@ -3037,23 +3062,8 @@ static int __tracing_resize_ring_buffer(unsigned long size, int cpu)
 
 	ret = ring_buffer_resize(max_tr.buffer, size, cpu);
 	if (ret < 0) {
-		int r = 0;
-
-		if (cpu == RING_BUFFER_ALL_CPUS) {
-			int i;
-			for_each_tracing_cpu(i) {
-				r = ring_buffer_resize(global_trace.buffer,
-						global_trace.data[i]->entries,
-						i);
-				if (r < 0)
-					break;
-			}
-		} else {
-			r = ring_buffer_resize(global_trace.buffer,
-						global_trace.data[cpu]->entries,
-						cpu);
-		}
-
+		int r = resize_buffer_duplicate_size(&global_trace,
+						     &global_trace, cpu);
 		if (r < 0) {
 			/*
 			 * AARGH! We are left with different
@@ -3191,17 +3201,11 @@ static int tracing_set_tracer(const char *buf)
 
 	topts = create_trace_option_files(t);
 	if (t->use_max_tr) {
-		int cpu;
 		/* we need to make per cpu buffer sizes equivalent */
-		for_each_tracing_cpu(cpu) {
-			ret = ring_buffer_resize(max_tr.buffer,
-						global_trace.data[cpu]->entries,
-						cpu);
-			if (ret < 0)
-				goto out;
-			max_tr.data[cpu]->entries =
-					global_trace.data[cpu]->entries;
-		}
+		ret = resize_buffer_duplicate_size(&max_tr, &global_trace,
+						   RING_BUFFER_ALL_CPUS);
+		if (ret < 0)
+			goto out;
 	}
 
 	if (t->init) {

