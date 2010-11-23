Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab0KWFg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 00:36:29 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:59889 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab0KWFgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 00:36:10 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Munsie <imunsie@au1.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 4/6] perf: Add timestamp to READ and LOST events
Date: Tue, 23 Nov 2010 16:35:42 +1100
Message-Id: <1290490544-14349-5-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com>
References: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch adds timestamps to the remaining events previously missing
them (PERF_RECORD_READ and PERF_RECORD_LOST) if requested by the
all_timed flag in the event attributes when opening the event.

This is not strictly necessary to fix any known bugs, but it is
foreseeable that knowing the timestamp of these events may be desirable
in the future and if we are going to add a timestamp to them, we may as
well do it now while we are changing the ABI to add timestamps to COMM
and MMAP events anyway.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 include/linux/perf_event.h |    2 +
 kernel/perf_event.c        |   56 +++++++++++++++++++++++++++++++++-----------
 2 files changed, 44 insertions(+), 14 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ef99af4..8b646aa 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -347,6 +347,7 @@ enum perf_event_type {
 	/*
 	 * struct {
 	 *	struct perf_event_header	header;
+	 *	{ u64			time;     } && all_timed
 	 *	u64				id;
 	 *	u64				lost;
 	 * };
@@ -398,6 +399,7 @@ enum perf_event_type {
 	/*
 	 * struct {
 	 *	struct perf_event_header	header;
+	 *	{ u64			time;     } && all_timed
 	 *	u32				pid, tid;
 	 *
 	 *	struct read_format		values;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c8ebab2..310b54a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3310,10 +3310,14 @@ int perf_output_begin(struct perf_output_handle *handle,
 	struct perf_buffer *buffer;
 	unsigned long tail, offset, head;
 	int have_lost;
+	unsigned int lostsize;
 	struct {
 		struct perf_event_header header;
-		u64			 id;
-		u64			 lost;
+		u64			time; /* && all_timed */
+		struct {
+			u64			 id;
+			u64			 lost;
+		} event_id;
 	} lost_event;
 
 	rcu_read_lock();
@@ -3336,8 +3340,14 @@ int perf_output_begin(struct perf_output_handle *handle,
 		goto out;
 
 	have_lost = local_read(&buffer->lost);
-	if (have_lost)
-		size += sizeof(lost_event);
+	if (have_lost) {
+		lostsize = sizeof(lost_event.header) + sizeof(lost_event.event_id);
+		if (event->attr.all_timed) {
+			lostsize += sizeof(u64);
+			lost_event.time = perf_clock();
+		}
+		size += lostsize;
+	}
 
 	perf_output_get_handle(handle);
 
@@ -3368,11 +3378,14 @@ int perf_output_begin(struct perf_output_handle *handle,
 	if (have_lost) {
 		lost_event.header.type = PERF_RECORD_LOST;
 		lost_event.header.misc = 0;
-		lost_event.header.size = sizeof(lost_event);
-		lost_event.id          = event->id;
-		lost_event.lost        = local_xchg(&buffer->lost, 0);
+		lost_event.header.size = lostsize;
+		lost_event.event_id.id = event->id;
+		lost_event.event_id.lost = local_xchg(&buffer->lost, 0);
 
-		perf_output_put(handle, lost_event);
+		perf_output_put(handle, lost_event.header);
+		if (event->attr.all_timed)
+			perf_output_put(handle, lost_event.time);
+		perf_output_put(handle, lost_event.event_id);
 	}
 
 	return 0;
@@ -3710,9 +3723,12 @@ exit:
 
 struct perf_read_event {
 	struct perf_event_header	header;
+	u64				time; /* && all_timed */
 
-	u32				pid;
-	u32				tid;
+	struct {
+		u32				pid;
+		u32				tid;
+	} event_id;
 };
 
 static void
@@ -3724,18 +3740,30 @@ perf_event_read_event(struct perf_event *event,
 		.header = {
 			.type = PERF_RECORD_READ,
 			.misc = 0,
-			.size = sizeof(read_event) + perf_event_read_size(event),
+			.size = sizeof(read_event.header) + sizeof(read_event.event_id)
+				+ perf_event_read_size(event),
+		},
+		/* .time && all_timed */
+		.event_id = {
+			.pid = perf_event_pid(event, task),
+			.tid = perf_event_tid(event, task),
 		},
-		.pid = perf_event_pid(event, task),
-		.tid = perf_event_tid(event, task),
 	};
 	int ret;
 
+	if (event->attr.all_timed) {
+		read_event.header.size += sizeof(u64);
+		read_event.time = perf_clock();
+	}
+
 	ret = perf_output_begin(&handle, event, read_event.header.size, 0, 0);
 	if (ret)
 		return;
 
-	perf_output_put(&handle, read_event);
+	perf_output_put(&handle, read_event.header);
+	if (event->attr.all_timed)
+		perf_output_put(&handle, read_event.time);
+	perf_output_put(&handle, read_event.event_id);
 	perf_output_read(&handle, event);
 
 	perf_output_end(&handle);
-- 
1.7.2.3

