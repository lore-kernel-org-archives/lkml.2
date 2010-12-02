Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab0LBTjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 14:39:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:57653 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab0LBTjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 14:39:53 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/4] perf events: Separate the routines handling the PERF_SAMPLE_ identity fields
Date: Thu,  2 Dec 2010 17:39:29 -0200
Message-Id: <1291318772-30880-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291318772-30880-1-git-send-email-acme@infradead.org>
References: <1291318772-30880-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Those will be made available in sample like events like MMAP, EXEC, etc in a
followup patch. So precalculate the extra id header space and have a separate
routine to fill them up.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/perf_event.h |    1 +
 kernel/perf_event.c        |  128 +++++++++++++++++++++++++------------------
 2 files changed, 75 insertions(+), 54 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index adf6d99..b9950b1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -759,6 +759,7 @@ struct perf_event {
 
 	struct perf_event_attr		attr;
 	u16				header_size;
+	u16				id_header_size;
 	u16				read_size;
 	struct hw_perf_event		hw;
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index aede712..3b847b3 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -133,6 +133,28 @@ static void unclone_ctx(struct perf_event_context *ctx)
 	}
 }
 
+static u32 perf_event_pid(struct perf_event *event, struct task_struct *p)
+{
+	/*
+	 * only top level events have the pid namespace they were created in
+	 */
+	if (event->parent)
+		event = event->parent;
+
+	return task_tgid_nr_ns(p, event->ns);
+}
+
+static u32 perf_event_tid(struct perf_event *event, struct task_struct *p)
+{
+	/*
+	 * only top level events have the pid namespace they were created in
+	 */
+	if (event->parent)
+		event = event->parent;
+
+	return task_pid_nr_ns(p, event->ns);
+}
+
 /*
  * If we inherit events we want to return the parent event id
  * to userspace.
@@ -351,15 +373,30 @@ static void perf_event__header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_IP)
 		size += sizeof(data->ip);
 
+	if (sample_type & PERF_SAMPLE_ADDR)
+		size += sizeof(data->addr);
+
+	if (sample_type & PERF_SAMPLE_PERIOD)
+		size += sizeof(data->period);
+
+	if (sample_type & PERF_SAMPLE_READ)
+		size += event->read_size;
+
+	event->header_size = size;
+}
+
+static void perf_event__id_header_size(struct perf_event *event)
+{
+	struct perf_sample_data *data;
+	u64 sample_type = event->attr.sample_type;
+	u16 size = 0;
+
 	if (sample_type & PERF_SAMPLE_TID)
 		size += sizeof(data->tid_entry);
 
 	if (sample_type & PERF_SAMPLE_TIME)
 		size += sizeof(data->time);
 
-	if (sample_type & PERF_SAMPLE_ADDR)
-		size += sizeof(data->addr);
-
 	if (sample_type & PERF_SAMPLE_ID)
 		size += sizeof(data->id);
 
@@ -369,13 +406,7 @@ static void perf_event__header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_CPU)
 		size += sizeof(data->cpu_entry);
 
-	if (sample_type & PERF_SAMPLE_PERIOD)
-		size += sizeof(data->period);
-
-	if (sample_type & PERF_SAMPLE_READ)
-		size += event->read_size;
-
-	event->header_size = size;
+	event->id_header_size = size;
 }
 
 static void perf_group_attach(struct perf_event *event)
@@ -3357,6 +3388,36 @@ __always_inline void perf_output_copy(struct perf_output_handle *handle,
 	} while (len);
 }
 
+static void perf_event_header__init_id(struct perf_event_header *header,
+				       struct perf_sample_data *data,
+				       struct perf_event *event)
+{
+	u64 sample_type = event->attr.sample_type;
+
+	data->type = sample_type;
+	header->size += event->id_header_size;
+
+	if (sample_type & PERF_SAMPLE_TID) {
+		/* namespace issues */
+		data->tid_entry.pid = perf_event_pid(event, current);
+		data->tid_entry.tid = perf_event_tid(event, current);
+	}
+
+	if (sample_type & PERF_SAMPLE_TIME)
+		data->time = perf_clock();
+
+	if (sample_type & PERF_SAMPLE_ID)
+		data->id = primary_event_id(event);
+
+	if (sample_type & PERF_SAMPLE_STREAM_ID)
+		data->stream_id = event->id;
+
+	if (sample_type & PERF_SAMPLE_CPU) {
+		data->cpu_entry.cpu	 = raw_smp_processor_id();
+		data->cpu_entry.reserved = 0;
+	}
+}
+
 int perf_output_begin(struct perf_output_handle *handle,
 		      struct perf_event *event, unsigned int size,
 		      int nmi, int sample)
@@ -3459,28 +3520,6 @@ void perf_output_end(struct perf_output_handle *handle)
 	rcu_read_unlock();
 }
 
-static u32 perf_event_pid(struct perf_event *event, struct task_struct *p)
-{
-	/*
-	 * only top level events have the pid namespace they were created in
-	 */
-	if (event->parent)
-		event = event->parent;
-
-	return task_tgid_nr_ns(p, event->ns);
-}
-
-static u32 perf_event_tid(struct perf_event *event, struct task_struct *p)
-{
-	/*
-	 * only top level events have the pid namespace they were created in
-	 */
-	if (event->parent)
-		event = event->parent;
-
-	return task_pid_nr_ns(p, event->ns);
-}
-
 static void perf_output_read_one(struct perf_output_handle *handle,
 				 struct perf_event *event,
 				 u64 enabled, u64 running)
@@ -3655,37 +3694,17 @@ void perf_prepare_sample(struct perf_event_header *header,
 {
 	u64 sample_type = event->attr.sample_type;
 
-	data->type = sample_type;
-
 	header->type = PERF_RECORD_SAMPLE;
 	header->size = sizeof(*header) + event->header_size;
 
 	header->misc = 0;
 	header->misc |= perf_misc_flags(regs);
 
+	perf_event_header__init_id(header, data, event);
+
 	if (sample_type & PERF_SAMPLE_IP)
 		data->ip = perf_instruction_pointer(regs);
 
-	if (sample_type & PERF_SAMPLE_TID) {
-		/* namespace issues */
-		data->tid_entry.pid = perf_event_pid(event, current);
-		data->tid_entry.tid = perf_event_tid(event, current);
-	}
-
-	if (sample_type & PERF_SAMPLE_TIME)
-		data->time = perf_clock();
-
-	if (sample_type & PERF_SAMPLE_ID)
-		data->id = primary_event_id(event);
-
-	if (sample_type & PERF_SAMPLE_STREAM_ID)
-		data->stream_id = event->id;
-
-	if (sample_type & PERF_SAMPLE_CPU) {
-		data->cpu_entry.cpu		= raw_smp_processor_id();
-		data->cpu_entry.reserved	= 0;
-	}
-
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		int size = 1;
 
@@ -5745,6 +5764,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	 * Precalculate sample_data sizes
 	 */
 	perf_event__header_size(event);
+	perf_event__id_header_size(event);
 
 	/*
 	 * Drop the reference on the group_event after placing the
-- 
1.6.2.5

