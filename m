Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab0K3ULX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:11:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:33393 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab0K3ULU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:11:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 01/11] perf events: Precalculate the header space for PERF_SAMPLE_ fields
Date: Tue, 30 Nov 2010 18:10:46 -0200
Message-Id: <1291147856-17459-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291147856-17459-1-git-send-email-acme@infradead.org>
References: <1291147856-17459-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

PERF_SAMPLE_{CALLCHAIN,RAW} have variable lenghts per sample, but the others
can be precalculated, reducing a bit the per sample cost.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/perf_event.h |    2 +
 kernel/perf_event.c        |  150 ++++++++++++++++++++++++++-----------------
 2 files changed, 93 insertions(+), 59 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index cbf04cc..adf6d99 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -758,6 +758,8 @@ struct perf_event {
 	u64				shadow_ctx_time;
 
 	struct perf_event_attr		attr;
+	u16				header_size;
+	u16				read_size;
 	struct hw_perf_event		hw;
 
 	struct perf_event_context	*ctx;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index af1e63f..aede712 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -312,9 +312,75 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 		ctx->nr_stat++;
 }
 
+/*
+ * Called at perf_event creation and when events are attached/detached from a
+ * group.
+ */
+static void perf_event__read_size(struct perf_event *event)
+{
+	int entry = sizeof(u64); /* value */
+	int size = 0;
+	int nr = 1;
+
+	if (event->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
+		size += sizeof(u64);
+
+	if (event->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
+		size += sizeof(u64);
+
+	if (event->attr.read_format & PERF_FORMAT_ID)
+		entry += sizeof(u64);
+
+	if (event->attr.read_format & PERF_FORMAT_GROUP) {
+		nr += event->group_leader->nr_siblings;
+		size += sizeof(u64);
+	}
+
+	size += entry * nr;
+	event->read_size = size;
+}
+
+static void perf_event__header_size(struct perf_event *event)
+{
+	struct perf_sample_data *data;
+	u64 sample_type = event->attr.sample_type;
+	u16 size = 0;
+
+	perf_event__read_size(event);
+
+	if (sample_type & PERF_SAMPLE_IP)
+		size += sizeof(data->ip);
+
+	if (sample_type & PERF_SAMPLE_TID)
+		size += sizeof(data->tid_entry);
+
+	if (sample_type & PERF_SAMPLE_TIME)
+		size += sizeof(data->time);
+
+	if (sample_type & PERF_SAMPLE_ADDR)
+		size += sizeof(data->addr);
+
+	if (sample_type & PERF_SAMPLE_ID)
+		size += sizeof(data->id);
+
+	if (sample_type & PERF_SAMPLE_STREAM_ID)
+		size += sizeof(data->stream_id);
+
+	if (sample_type & PERF_SAMPLE_CPU)
+		size += sizeof(data->cpu_entry);
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
 static void perf_group_attach(struct perf_event *event)
 {
-	struct perf_event *group_leader = event->group_leader;
+	struct perf_event *group_leader = event->group_leader, *pos;
 
 	/*
 	 * We can have double attach due to group movement in perf_event_open.
@@ -333,6 +399,11 @@ static void perf_group_attach(struct perf_event *event)
 
 	list_add_tail(&event->group_entry, &group_leader->sibling_list);
 	group_leader->nr_siblings++;
+
+	perf_event__header_size(group_leader);
+
+	list_for_each_entry(pos, &group_leader->sibling_list, group_entry)
+		perf_event__header_size(pos);
 }
 
 /*
@@ -391,7 +462,7 @@ static void perf_group_detach(struct perf_event *event)
 	if (event->group_leader != event) {
 		list_del_init(&event->group_entry);
 		event->group_leader->nr_siblings--;
-		return;
+		goto out;
 	}
 
 	if (!list_empty(&event->group_entry))
@@ -410,6 +481,12 @@ static void perf_group_detach(struct perf_event *event)
 		/* Inherit group flags from the previous leader */
 		sibling->group_flags = event->group_flags;
 	}
+
+out:
+	perf_event__header_size(event->group_leader);
+
+	list_for_each_entry(tmp, &event->group_leader->sibling_list, group_entry)
+		perf_event__header_size(tmp);
 }
 
 static inline int
@@ -2289,31 +2366,6 @@ static int perf_release(struct inode *inode, struct file *file)
 	return perf_event_release_kernel(event);
 }
 
-static int perf_event_read_size(struct perf_event *event)
-{
-	int entry = sizeof(u64); /* value */
-	int size = 0;
-	int nr = 1;
-
-	if (event->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
-		size += sizeof(u64);
-
-	if (event->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
-		size += sizeof(u64);
-
-	if (event->attr.read_format & PERF_FORMAT_ID)
-		entry += sizeof(u64);
-
-	if (event->attr.read_format & PERF_FORMAT_GROUP) {
-		nr += event->group_leader->nr_siblings;
-		size += sizeof(u64);
-	}
-
-	size += entry * nr;
-
-	return size;
-}
-
 u64 perf_event_read_value(struct perf_event *event, u64 *enabled, u64 *running)
 {
 	struct perf_event *child;
@@ -2428,7 +2480,7 @@ perf_read_hw(struct perf_event *event, char __user *buf, size_t count)
 	if (event->state == PERF_EVENT_STATE_ERROR)
 		return 0;
 
-	if (count < perf_event_read_size(event))
+	if (count < event->read_size)
 		return -ENOSPC;
 
 	WARN_ON_ONCE(event->ctx->parent_ctx);
@@ -3606,59 +3658,34 @@ void perf_prepare_sample(struct perf_event_header *header,
 	data->type = sample_type;
 
 	header->type = PERF_RECORD_SAMPLE;
-	header->size = sizeof(*header);
+	header->size = sizeof(*header) + event->header_size;
 
 	header->misc = 0;
 	header->misc |= perf_misc_flags(regs);
 
-	if (sample_type & PERF_SAMPLE_IP) {
+	if (sample_type & PERF_SAMPLE_IP)
 		data->ip = perf_instruction_pointer(regs);
 
-		header->size += sizeof(data->ip);
-	}
-
 	if (sample_type & PERF_SAMPLE_TID) {
 		/* namespace issues */
 		data->tid_entry.pid = perf_event_pid(event, current);
 		data->tid_entry.tid = perf_event_tid(event, current);
-
-		header->size += sizeof(data->tid_entry);
 	}
 
-	if (sample_type & PERF_SAMPLE_TIME) {
+	if (sample_type & PERF_SAMPLE_TIME)
 		data->time = perf_clock();
 
-		header->size += sizeof(data->time);
-	}
-
-	if (sample_type & PERF_SAMPLE_ADDR)
-		header->size += sizeof(data->addr);
-
-	if (sample_type & PERF_SAMPLE_ID) {
+	if (sample_type & PERF_SAMPLE_ID)
 		data->id = primary_event_id(event);
 
-		header->size += sizeof(data->id);
-	}
-
-	if (sample_type & PERF_SAMPLE_STREAM_ID) {
+	if (sample_type & PERF_SAMPLE_STREAM_ID)
 		data->stream_id = event->id;
 
-		header->size += sizeof(data->stream_id);
-	}
-
 	if (sample_type & PERF_SAMPLE_CPU) {
 		data->cpu_entry.cpu		= raw_smp_processor_id();
 		data->cpu_entry.reserved	= 0;
-
-		header->size += sizeof(data->cpu_entry);
 	}
 
-	if (sample_type & PERF_SAMPLE_PERIOD)
-		header->size += sizeof(data->period);
-
-	if (sample_type & PERF_SAMPLE_READ)
-		header->size += perf_event_read_size(event);
-
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		int size = 1;
 
@@ -3726,7 +3753,7 @@ perf_event_read_event(struct perf_event *event,
 		.header = {
 			.type = PERF_RECORD_READ,
 			.misc = 0,
-			.size = sizeof(read_event) + perf_event_read_size(event),
+			.size = sizeof(read_event) + event->read_size,
 		},
 		.pid = perf_event_pid(event, task),
 		.tid = perf_event_tid(event, task),
@@ -5715,6 +5742,11 @@ SYSCALL_DEFINE5(perf_event_open,
 	mutex_unlock(&current->perf_event_mutex);
 
 	/*
+	 * Precalculate sample_data sizes
+	 */
+	perf_event__header_size(event);
+
+	/*
 	 * Drop the reference on the group_event after placing the
 	 * new event on the sibling_list. This ensures destruction
 	 * of the group leader will find the pointer to itself in
-- 
1.6.2.5

