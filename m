Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab0F1SIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 14:08:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34827 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab0F1SIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 14:08:10 -0400
From: Eric B Munson <ebmunson@us.ibm.com>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Eric B Munson <ebmunson@us.ibm.com>, Anton Blanchard <anton@samba.org>
Subject: [PATCH] Add munmap events to perf
Date: Mon, 28 Jun 2010 19:08:04 +0100
Message-Id: <1277748484-23882-1-git-send-email-ebmunson@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new software event for munmaps.  It will allows
users to profile changes to address space.  munmaps will be tracked
with mmaps.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
Signed-off-by: Anton Blanchard <anton@samba.org>
---
 include/linux/perf_event.h  |    6 ++++-
 kernel/perf_event.c         |   49 +++++++++++++++++++++++++++++++++++++++---
 mm/mmap.c                   |    2 +
 tools/perf/builtin-record.c |    1 +
 4 files changed, 53 insertions(+), 5 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 716f99b..937dd93 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -215,8 +215,9 @@ struct perf_event_attr {
 				 */
 				precise_ip     :  2, /* skid constraint       */
 				mmap_data      :  1, /* non-exec mmap data    */
+				munmap         :  1, /* include munmap events */
 
-				__reserved_1   : 46;
+				__reserved_1   : 45;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -341,6 +342,7 @@ enum perf_event_type {
 	 * };
 	 */
 	PERF_RECORD_MMAP			= 1,
+	PERF_RECORD_MUNMAP			= 10,
 
 	/*
 	 * struct {
@@ -969,6 +971,8 @@ perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);
+extern void perf_event_munmap(struct vm_area_struct *vma, unsigned long start,
+				size_t len);
 extern struct perf_guest_info_callbacks *perf_guest_cbs;
 extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 extern int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 403d180..2d24e4e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -46,6 +46,7 @@ static int perf_overcommit __read_mostly = 1;
 
 static atomic_t nr_events __read_mostly;
 static atomic_t nr_mmap_events __read_mostly;
+static atomic_t nr_munmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
 static atomic_t nr_task_events __read_mostly;
 
@@ -1891,6 +1892,8 @@ static void free_event(struct perf_event *event)
 		atomic_dec(&nr_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_dec(&nr_mmap_events);
+		if (event->attr.munmap)
+			atomic_dec(&nr_munmap_events);
 		if (event->attr.comm)
 			atomic_dec(&nr_comm_events);
 		if (event->attr.task)
@@ -3491,7 +3494,8 @@ perf_event_read_event(struct perf_event *event,
 /*
  * task tracking -- fork/exit
  *
- * enabled by: attr.comm | attr.mmap | attr.mmap_data | attr.task
+ * enabled by: attr.comm | attr.mmap | attr.mmap_data | attr.munmap |
+ *	       attr.task
  */
 
 struct perf_task_event {
@@ -3542,7 +3546,7 @@ static int perf_event_task_match(struct perf_event *event)
 		return 0;
 
 	if (event->attr.comm || event->attr.mmap ||
-	    event->attr.mmap_data || event->attr.task)
+	    event->attr.mmap_data || event->attr.munmap || event->attr.task)
 		return 1;
 
 	return 0;
@@ -3583,6 +3587,7 @@ static void perf_event_task(struct task_struct *task,
 
 	if (!atomic_read(&nr_comm_events) &&
 	    !atomic_read(&nr_mmap_events) &&
+	    !atomic_read(&nr_munmap_events) &&
 	    !atomic_read(&nr_task_events))
 		return;
 
@@ -3776,9 +3781,14 @@ static int perf_event_mmap_match(struct perf_event *event,
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
 		return 0;
 
-	if ((!executable && event->attr.mmap_data) ||
-	    (executable && event->attr.mmap))
+	if (mmap_event->event_id.header.type == PERF_RECORD_MMAP) {
+		if ((!executable && event->attr.mmap_data) ||
+		     (executable && event->attr.mmap))
+			return 1;
+	} else if ((mmap_event->event_id.header.type == PERF_RECORD_MUNMAP) &&
+		   event->attr.munmap) {
 		return 1;
+	}
 
 	return 0;
 }
@@ -3896,6 +3906,35 @@ void perf_event_mmap(struct vm_area_struct *vma)
 	perf_event_mmap_event(&mmap_event);
 }
 
+void perf_event_munmap(struct vm_area_struct *vma, unsigned long start,
+		       size_t len)
+{
+	struct perf_mmap_event mmap_event;
+
+	if (!atomic_read(&nr_munmap_events))
+		return;
+
+	mmap_event = (struct perf_mmap_event){
+		.vma	= vma,
+		/* .file_name */
+		/* .file_size */
+		.event_id  = {
+			.header = {
+				.type = PERF_RECORD_MUNMAP,
+				.misc = 0,
+				/* .size */
+			},
+			/* .pid */
+			/* .tid */
+			.start	= start,
+			.len	= len,
+			.pgoff	= 0,
+		},
+	};
+
+	perf_event_mmap_event(&mmap_event);
+}
+
 /*
  * IRQ throttle logging
  */
@@ -4925,6 +4964,8 @@ done:
 		atomic_inc(&nr_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_inc(&nr_mmap_events);
+		if (event->attr.munmap)
+			atomic_inc(&nr_munmap_events);
 		if (event->attr.comm)
 			atomic_inc(&nr_comm_events);
 		if (event->attr.task)
diff --git a/mm/mmap.c b/mm/mmap.c
index e38e910..cb03746 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2082,6 +2082,8 @@ int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
 		}
 	}
 
+	perf_event_munmap(vma, start, end - start);
+
 	/*
 	 * Remove the vma's, and unmap the actual pages
 	 */
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b938796..b2018be 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -287,6 +287,7 @@ static void create_counter(int counter, int cpu)
 	}
 
 	attr->mmap		= track;
+	attr->munmap		= track;
 	attr->comm		= track;
 	attr->inherit		= !no_inherit;
 	if (target_pid == -1 && target_tid == -1 && !system_wide) {
-- 
1.7.0.4

