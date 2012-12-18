Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab2LRRyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:54:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5571 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab2LRRyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:54:10 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ewCj4f1DgrAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=0V42Mp9rtPcA:10 a=D19gQVrFAAAA:8 a=VwQbUJbxAAAA:8 a=RIF_b-v2H8SzXMR5e34A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355853247.5896.8.camel@gandalf.local.home>
Subject: [RFC GIT PULL] tracing: Minor updates and fixes
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Date: Tue, 18 Dec 2012 12:54:07 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

As Ingo is busy working hard on the NUMA patches, it seems that one of
my old pull requests have slipped through.

https://lkml.org/lkml/2012/11/28/690

as well as a little reminder:

https://lkml.org/lkml/2012/12/13/715

The changes are contained to just the files that I maintain, and are
changes from others that I told I would get into this merge window.

They have already been in linux-next for several weeks, and should be
well tested.

If you don't feel that these small changes are needed to go through tip,
would you be able to pull them directly.

Thanks!

-- Steve


Please pull the latest tip/perf/core-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core-2

Head SHA1: bf3071f5a054db9e5bab873355d27a7330ce5187


Anton Vorontsov (1):
      tracing: Remove unneeded checks from the stack tracer

Dave Jones (1):
      tracing: Remove unnecessary WARN_ONCE's from tracing_buffers_splice_read

Hiraku Toyooka (1):
      tracing: Add a resize function to make one buffer equivalent to another buffer

----
 kernel/trace/trace.c       |   60 +++++++++++++++++++++++---------------------
 kernel/trace/trace_stack.c |    4 ---
 2 files changed, 31 insertions(+), 33 deletions(-)
---------------------------
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b69cc38..5bc3590 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3034,6 +3034,31 @@ static void set_buffer_entries(struct trace_array *tr, unsigned long val)
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
@@ -3058,23 +3083,8 @@ static int __tracing_resize_ring_buffer(unsigned long size, int cpu)
 
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
@@ -3212,17 +3222,11 @@ static int tracing_set_tracer(const char *buf)
 
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
@@ -4271,13 +4275,11 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		return -ENOMEM;
 
 	if (*ppos & (PAGE_SIZE - 1)) {
-		WARN_ONCE(1, "Ftrace: previous read must page-align\n");
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if (len & (PAGE_SIZE - 1)) {
-		WARN_ONCE(1, "Ftrace: splice_read should page-align\n");
 		if (len < PAGE_SIZE) {
 			ret = -EINVAL;
 			goto out;
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 0c1b1657..42ca822 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -33,7 +33,6 @@ static unsigned long max_stack_size;
 static arch_spinlock_t max_stack_lock =
 	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
-static int stack_trace_disabled __read_mostly;
 static DEFINE_PER_CPU(int, trace_active);
 static DEFINE_MUTEX(stack_sysctl_mutex);
 
@@ -116,9 +115,6 @@ stack_trace_call(unsigned long ip, unsigned long parent_ip,
 {
 	int cpu;
 
-	if (unlikely(!ftrace_enabled || stack_trace_disabled))
-		return;
-
 	preempt_disable_notrace();
 
 	cpu = raw_smp_processor_id();



