Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0LDW2A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 17:28:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:40556 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab0LDW1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 17:27:34 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/5] perf events: Make sample_type identity fields available in all PERF_RECORD_ events
Date: Sat,  4 Dec 2010 20:26:55 -0200
Message-Id: <1291501617-6966-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291501617-6966-1-git-send-email-acme@infradead.org>
References: <1291501617-6966-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

If perf_event_attr.sample_id_all is set it will add the PERF_SAMPLE_ identity
info:

TID, TIME, ID, CPU, STREAM_ID

As a trailer, so that older perf tools can process new files, just ignoring the
extra payload.

With this its possible to do further analysis on problems in the event stream,
like detecting reordering of MMAP and FORK events, etc.

V2: Fixup header size in comm, mmap and task processing, as we have to take into
account different sample_types for each matching event, noticed by Thomas Gleixner.

Thomas also noticed a problem in v2 where if we didn't had space in the buffer we
wouldn't restore the header size.

Tested-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ian Munsie <imunsie@au1.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/perf_event.h |   12 +++++-
 kernel/perf_event.c        |  108 +++++++++++++++++++++++++++++++++++++-------
 2 files changed, 102 insertions(+), 18 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index b9950b1..2814ead 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -215,8 +215,9 @@ struct perf_event_attr {
 				 */
 				precise_ip     :  2, /* skid constraint       */
 				mmap_data      :  1, /* non-exec mmap data    */
+				sample_id_all  :  1, /* sample_type all events */
 
-				__reserved_1   : 46;
+				__reserved_1   : 45;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -327,6 +328,15 @@ struct perf_event_header {
 enum perf_event_type {
 
 	/*
+	 * If perf_event_attr.sample_id_all is set then all event types will
+	 * have the sample_type selected fields related to where/when
+	 * (identity) an event took place (TID, TIME, ID, CPU, STREAM_ID)
+	 * described in PERF_RECORD_SAMPLE below, it will be stashed just after
+	 * the perf_event_header and the fields already present for the existing
+	 * fields, i.e. at the end of the payload. That way a newer perf.data
+	 * file will be supported by older perf tools, with these new optional
+	 * fields being ignored.
+	 *
 	 * The MMAP events record the PROT_EXEC mappings so that we can
 	 * correlate userspace IPs to code. They have the following structure:
 	 *
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a047997..77ad22c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3388,9 +3388,9 @@ __always_inline void perf_output_copy(struct perf_output_handle *handle,
 	} while (len);
 }
 
-static void perf_event_header__init_id(struct perf_event_header *header,
-				       struct perf_sample_data *data,
-				       struct perf_event *event)
+static void __perf_event_header__init_id(struct perf_event_header *header,
+					 struct perf_sample_data *data,
+					 struct perf_event *event)
 {
 	u64 sample_type = event->attr.sample_type;
 
@@ -3418,6 +3418,43 @@ static void perf_event_header__init_id(struct perf_event_header *header,
 	}
 }
 
+static void perf_event_header__init_id(struct perf_event_header *header,
+				       struct perf_sample_data *data,
+				       struct perf_event *event)
+{
+	if (event->attr.sample_id_all)
+		__perf_event_header__init_id(header, data, event);
+}
+
+static void __perf_event__output_id_sample(struct perf_output_handle *handle,
+					   struct perf_sample_data *data)
+{
+	u64 sample_type = data->type;
+
+	if (sample_type & PERF_SAMPLE_TID)
+		perf_output_put(handle, data->tid_entry);
+
+	if (sample_type & PERF_SAMPLE_TIME)
+		perf_output_put(handle, data->time);
+
+	if (sample_type & PERF_SAMPLE_ID)
+		perf_output_put(handle, data->id);
+
+	if (sample_type & PERF_SAMPLE_STREAM_ID)
+		perf_output_put(handle, data->stream_id);
+
+	if (sample_type & PERF_SAMPLE_CPU)
+		perf_output_put(handle, data->cpu_entry);
+}
+
+static void perf_event__output_id_sample(struct perf_event *event,
+					 struct perf_output_handle *handle,
+					 struct perf_sample_data *sample)
+{
+	if (event->attr.sample_id_all)
+		__perf_event__output_id_sample(handle, sample);
+}
+
 int perf_output_begin(struct perf_output_handle *handle,
 		      struct perf_event *event, unsigned int size,
 		      int nmi, int sample)
@@ -3425,6 +3462,7 @@ int perf_output_begin(struct perf_output_handle *handle,
 	struct perf_buffer *buffer;
 	unsigned long tail, offset, head;
 	int have_lost;
+	struct perf_sample_data sample_data;
 	struct {
 		struct perf_event_header header;
 		u64			 id;
@@ -3451,8 +3489,12 @@ int perf_output_begin(struct perf_output_handle *handle,
 		goto out;
 
 	have_lost = local_read(&buffer->lost);
-	if (have_lost)
-		size += sizeof(lost_event);
+	if (have_lost) {
+		lost_event.header.size = sizeof(lost_event);
+		perf_event_header__init_id(&lost_event.header, &sample_data,
+					   event);
+		size += lost_event.header.size;
+	}
 
 	perf_output_get_handle(handle);
 
@@ -3483,11 +3525,11 @@ int perf_output_begin(struct perf_output_handle *handle,
 	if (have_lost) {
 		lost_event.header.type = PERF_RECORD_LOST;
 		lost_event.header.misc = 0;
-		lost_event.header.size = sizeof(lost_event);
 		lost_event.id          = event->id;
 		lost_event.lost        = local_xchg(&buffer->lost, 0);
 
 		perf_output_put(handle, lost_event);
+		perf_event__output_id_sample(event, handle, &sample_data);
 	}
 
 	return 0;
@@ -3700,7 +3742,7 @@ void perf_prepare_sample(struct perf_event_header *header,
 	header->misc = 0;
 	header->misc |= perf_misc_flags(regs);
 
-	perf_event_header__init_id(header, data, event);
+	__perf_event_header__init_id(header, data, event);
 
 	if (sample_type & PERF_SAMPLE_IP)
 		data->ip = perf_instruction_pointer(regs);
@@ -3768,6 +3810,7 @@ perf_event_read_event(struct perf_event *event,
 			struct task_struct *task)
 {
 	struct perf_output_handle handle;
+	struct perf_sample_data sample;
 	struct perf_read_event read_event = {
 		.header = {
 			.type = PERF_RECORD_READ,
@@ -3779,12 +3822,14 @@ perf_event_read_event(struct perf_event *event,
 	};
 	int ret;
 
+	perf_event_header__init_id(&read_event.header, &sample, event);
 	ret = perf_output_begin(&handle, event, read_event.header.size, 0, 0);
 	if (ret)
 		return;
 
 	perf_output_put(&handle, read_event);
 	perf_output_read(&handle, event);
+	perf_event__output_id_sample(event, &handle, &sample);
 
 	perf_output_end(&handle);
 }
@@ -3814,14 +3859,16 @@ static void perf_event_task_output(struct perf_event *event,
 				     struct perf_task_event *task_event)
 {
 	struct perf_output_handle handle;
+	struct perf_sample_data	sample;
 	struct task_struct *task = task_event->task;
-	int size, ret;
+	int ret, size = task_event->event_id.header.size;
 
-	size  = task_event->event_id.header.size;
-	ret = perf_output_begin(&handle, event, size, 0, 0);
+	perf_event_header__init_id(&task_event->event_id.header, &sample, event);
 
+	ret = perf_output_begin(&handle, event,
+				task_event->event_id.header.size, 0, 0);
 	if (ret)
-		return;
+		goto out;
 
 	task_event->event_id.pid = perf_event_pid(event, task);
 	task_event->event_id.ppid = perf_event_pid(event, current);
@@ -3831,7 +3878,11 @@ static void perf_event_task_output(struct perf_event *event,
 
 	perf_output_put(&handle, task_event->event_id);
 
+	perf_event__output_id_sample(event, &handle, &sample);
+
 	perf_output_end(&handle);
+out:
+	task_event->event_id.header.size = size;
 }
 
 static int perf_event_task_match(struct perf_event *event)
@@ -3944,11 +3995,16 @@ static void perf_event_comm_output(struct perf_event *event,
 				     struct perf_comm_event *comm_event)
 {
 	struct perf_output_handle handle;
+	struct perf_sample_data sample;
 	int size = comm_event->event_id.header.size;
-	int ret = perf_output_begin(&handle, event, size, 0, 0);
+	int ret;
+
+	perf_event_header__init_id(&comm_event->event_id.header, &sample, event);
+	ret = perf_output_begin(&handle, event,
+				comm_event->event_id.header.size, 0, 0);
 
 	if (ret)
-		return;
+		goto out;
 
 	comm_event->event_id.pid = perf_event_pid(event, comm_event->task);
 	comm_event->event_id.tid = perf_event_tid(event, comm_event->task);
@@ -3956,7 +4012,12 @@ static void perf_event_comm_output(struct perf_event *event,
 	perf_output_put(&handle, comm_event->event_id);
 	perf_output_copy(&handle, comm_event->comm,
 				   comm_event->comm_size);
+
+	perf_event__output_id_sample(event, &handle, &sample);
+
 	perf_output_end(&handle);
+out:
+	comm_event->event_id.header.size = size;
 }
 
 static int perf_event_comm_match(struct perf_event *event)
@@ -4001,7 +4062,6 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 	comm_event->comm_size = size;
 
 	comm_event->event_id.header.size = sizeof(comm_event->event_id) + size;
-
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
@@ -4080,11 +4140,15 @@ static void perf_event_mmap_output(struct perf_event *event,
 				     struct perf_mmap_event *mmap_event)
 {
 	struct perf_output_handle handle;
+	struct perf_sample_data sample;
 	int size = mmap_event->event_id.header.size;
-	int ret = perf_output_begin(&handle, event, size, 0, 0);
+	int ret;
 
+	perf_event_header__init_id(&mmap_event->event_id.header, &sample, event);
+	ret = perf_output_begin(&handle, event,
+				mmap_event->event_id.header.size, 0, 0);
 	if (ret)
-		return;
+		goto out;
 
 	mmap_event->event_id.pid = perf_event_pid(event, current);
 	mmap_event->event_id.tid = perf_event_tid(event, current);
@@ -4092,7 +4156,12 @@ static void perf_event_mmap_output(struct perf_event *event,
 	perf_output_put(&handle, mmap_event->event_id);
 	perf_output_copy(&handle, mmap_event->file_name,
 				   mmap_event->file_size);
+
+	perf_event__output_id_sample(event, &handle, &sample);
+
 	perf_output_end(&handle);
+out:
+	mmap_event->event_id.header.size = size;
 }
 
 static int perf_event_mmap_match(struct perf_event *event,
@@ -4245,6 +4314,7 @@ void perf_event_mmap(struct vm_area_struct *vma)
 static void perf_log_throttle(struct perf_event *event, int enable)
 {
 	struct perf_output_handle handle;
+	struct perf_sample_data sample;
 	int ret;
 
 	struct {
@@ -4266,11 +4336,15 @@ static void perf_log_throttle(struct perf_event *event, int enable)
 	if (enable)
 		throttle_event.header.type = PERF_RECORD_UNTHROTTLE;
 
-	ret = perf_output_begin(&handle, event, sizeof(throttle_event), 1, 0);
+	perf_event_header__init_id(&throttle_event.header, &sample, event);
+
+	ret = perf_output_begin(&handle, event,
+				throttle_event.header.size, 1, 0);
 	if (ret)
 		return;
 
 	perf_output_put(&handle, throttle_event);
+	perf_event__output_id_sample(event, &handle, &sample);
 	perf_output_end(&handle);
 }
 
-- 
1.6.2.5

