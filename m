Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab0KWFgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 00:36:31 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:40422 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab0KWFgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 00:36:09 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Munsie <imunsie@au1.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 3/6] perf: Add timestamp to COMM and MMAP events
Date: Tue, 23 Nov 2010 16:35:41 +1100
Message-Id: <1290490544-14349-4-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com>
References: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch adds extra ABI to the perf interface to allow the
PERF_RECORD_COMM and PERF_RECORD_MMAP events to optionally include a
timestamp, which they were previously missing.

This has become necessary since the move to per-task-per-cpu events in
perf as those events would not necessarily be recorded prior to any
samples associated with them and would cause perf to miss-attribute
those events and produce bogus reports. This behaviour can be observed
almost every run on 64 CPU PowerPC systems, but has also been observed
on a simple quad core Intel i7.

The timestamp is requested by setting the all_timed flag in the
event attributes when opening the event and will be placed just after
the header of the events in question.

This patch also ensures that the PERF_RECORD_COMM event is dispatched
before enabling the counters for enable_on_exec.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 include/linux/perf_event.h |    5 ++-
 kernel/perf_event.c        |   95 +++++++++++++++++++++++++------------------
 2 files changed, 59 insertions(+), 41 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 40150f3..ef99af4 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -215,8 +215,9 @@ struct perf_event_attr {
 				 */
 				precise_ip     :  2, /* skid constraint       */
 				mmap_data      :  1, /* non-exec mmap data    */
+				all_timed      :  1, /* timestamp every event */
 
-				__reserved_1   : 46;
+				__reserved_1   : 47;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -332,6 +333,7 @@ enum perf_event_type {
 	 *
 	 * struct {
 	 *	struct perf_event_header	header;
+	 *	{ u64			time;     } && all_timed
 	 *
 	 *	u32				pid, tid;
 	 *	u64				addr;
@@ -354,6 +356,7 @@ enum perf_event_type {
 	/*
 	 * struct {
 	 *	struct perf_event_header	header;
+	 *	{ u64			time;     } && all_timed
 	 *
 	 *	u32				pid, tid;
 	 *	char				comm[];
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8d099f3..c8ebab2 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3884,9 +3884,9 @@ struct perf_comm_event {
 	char			*comm;
 	int			comm_size;
 
+	struct perf_event_header	header;
+	u64				time; /* && all_timed */
 	struct {
-		struct perf_event_header	header;
-
 		u32				pid;
 		u32				tid;
 	} event_id;
@@ -3896,16 +3896,23 @@ static void perf_event_comm_output(struct perf_event *event,
 				     struct perf_comm_event *comm_event)
 {
 	struct perf_output_handle handle;
-	int size = comm_event->event_id.header.size;
-	int ret = perf_output_begin(&handle, event, size, 0, 0);
 
-	if (ret)
+	if (event->attr.all_timed) {
+		comm_event->header.size += sizeof(u64);
+		comm_event->time = perf_clock();
+	}
+
+	if (perf_output_begin(&handle, event, comm_event->header.size, 0, 0))
 		return;
 
 	comm_event->event_id.pid = perf_event_pid(event, comm_event->task);
 	comm_event->event_id.tid = perf_event_tid(event, comm_event->task);
 
+	perf_output_put(&handle, comm_event->header);
+	if (event->attr.all_timed)
+		perf_output_put(&handle, comm_event->time);
 	perf_output_put(&handle, comm_event->event_id);
+
 	perf_output_copy(&handle, comm_event->comm,
 				   comm_event->comm_size);
 	perf_output_end(&handle);
@@ -3913,9 +3920,6 @@ static void perf_event_comm_output(struct perf_event *event,
 
 static int perf_event_comm_match(struct perf_event *event)
 {
-	if (event->state < PERF_EVENT_STATE_INACTIVE)
-		return 0;
-
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
 		return 0;
 
@@ -3952,7 +3956,8 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 	comm_event->comm = comm;
 	comm_event->comm_size = size;
 
-	comm_event->event_id.header.size = sizeof(comm_event->event_id) + size;
+	comm_event->header.size = sizeof(comm_event->header)
+				+ sizeof(comm_event->event_id) + size;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
@@ -3978,33 +3983,34 @@ void perf_event_comm(struct task_struct *task)
 	struct perf_event_context *ctx;
 	int ctxn;
 
-	for_each_task_context_nr(ctxn) {
-		ctx = task->perf_event_ctxp[ctxn];
-		if (!ctx)
-			continue;
-
-		perf_event_enable_on_exec(ctx);
-	}
 
-	if (!atomic_read(&nr_comm_events))
-		return;
-
-	comm_event = (struct perf_comm_event){
-		.task	= task,
-		/* .comm      */
-		/* .comm_size */
-		.event_id  = {
+	if (atomic_read(&nr_comm_events)) {
+		comm_event = (struct perf_comm_event){
+			.task	= task,
+			/* .comm      */
+			/* .comm_size */
 			.header = {
 				.type = PERF_RECORD_COMM,
 				.misc = 0,
 				/* .size */
 			},
-			/* .pid */
-			/* .tid */
-		},
-	};
+			/* .time && all_timed */
+			.event_id  = {
+				/* .pid */
+				/* .tid */
+			},
+		};
+
+		perf_event_comm_event(&comm_event);
+	}
+
+	for_each_task_context_nr(ctxn) {
+		ctx = task->perf_event_ctxp[ctxn];
+		if (!ctx)
+			continue;
 
-	perf_event_comm_event(&comm_event);
+		perf_event_enable_on_exec(ctx);
+	}
 }
 
 /*
@@ -4017,9 +4023,9 @@ struct perf_mmap_event {
 	const char		*file_name;
 	int			file_size;
 
+	struct perf_event_header	header;
+	u64				time; /* && all_timed */
 	struct {
-		struct perf_event_header	header;
-
 		u32				pid;
 		u32				tid;
 		u64				start;
@@ -4032,16 +4038,23 @@ static void perf_event_mmap_output(struct perf_event *event,
 				     struct perf_mmap_event *mmap_event)
 {
 	struct perf_output_handle handle;
-	int size = mmap_event->event_id.header.size;
-	int ret = perf_output_begin(&handle, event, size, 0, 0);
 
-	if (ret)
+	if (event->attr.all_timed) {
+		mmap_event->header.size += sizeof(u64);
+		mmap_event->time = perf_clock();
+	}
+
+	if (perf_output_begin(&handle, event, mmap_event->header.size, 0, 0))
 		return;
 
 	mmap_event->event_id.pid = perf_event_pid(event, current);
 	mmap_event->event_id.tid = perf_event_tid(event, current);
 
+	perf_output_put(&handle, mmap_event->header);
+	if (event->attr.all_timed)
+		perf_output_put(&handle, mmap_event->time);
 	perf_output_put(&handle, mmap_event->event_id);
+
 	perf_output_copy(&handle, mmap_event->file_name,
 				   mmap_event->file_size);
 	perf_output_end(&handle);
@@ -4137,7 +4150,8 @@ got_name:
 	mmap_event->file_name = name;
 	mmap_event->file_size = size;
 
-	mmap_event->event_id.header.size = sizeof(mmap_event->event_id) + size;
+	mmap_event->header.size = sizeof(mmap_event->header)
+				+ sizeof(mmap_event->event_id) + size;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
@@ -4173,12 +4187,13 @@ void perf_event_mmap(struct vm_area_struct *vma)
 		.vma	= vma,
 		/* .file_name */
 		/* .file_size */
+		.header = {
+			.type = PERF_RECORD_MMAP,
+			.misc = PERF_RECORD_MISC_USER,
+			/* .size */
+		},
+		/* .time && all_timed */
 		.event_id  = {
-			.header = {
-				.type = PERF_RECORD_MMAP,
-				.misc = PERF_RECORD_MISC_USER,
-				/* .size */
-			},
 			/* .pid */
 			/* .tid */
 			.start  = vma->vm_start,
-- 
1.7.2.3

