Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab0KWFg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 00:36:28 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36383 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab0KWFgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 00:36:12 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Munsie <imunsie@au1.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Tom Zanussi <tzanussi@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6/6] perf tool: Process READ and LOST events in order
Date: Tue, 23 Nov 2010 16:35:44 +1100
Message-Id: <1290490544-14349-7-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com>
References: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patches changes the perf tool so that READ and LOST events will be
processed in order of their timestamp, if present.

This is not strictly necessary to fix any known bugs, but it is
foreseeable that knowing the timestamp of these events may be desirable
in the future and if we are going to add a timestamp to them, we may as
well do it now while we are changing the ABI to add timestamps to COMM
and MMAP events anyway.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 tools/perf/util/event.h   |    2 ++
 tools/perf/util/session.c |   18 ++++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index b9c2b2d..ba0a761 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -51,6 +51,7 @@ struct fork_event {
 
 struct lost_event {
 	struct perf_event_header header;
+	u64 time; /* && all_timed */
 	u64 id;
 	u64 lost;
 };
@@ -60,6 +61,7 @@ struct lost_event {
  */
 struct read_event {
 	struct perf_event_header header;
+	u64 time; /* && all_timed */
 	u32 pid, tid;
 	u64 value;
 	u64 time_enabled;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 09d0f3a..025da8f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -344,6 +344,7 @@ static void event__task_swap(event_t *self)
 
 static void event__read_swap(event_t *self)
 {
+	self->read.time		= bswap_64(self->mmap.time);
 	self->read.pid		= bswap_32(self->read.pid);
 	self->read.tid		= bswap_32(self->read.tid);
 	self->read.value	= bswap_64(self->read.value);
@@ -436,6 +437,12 @@ static void flush_sample_queue(struct perf_session *s,
 		case PERF_RECORD_MMAP:
 			ops->mmap((event_t *)iter->event, s);
 			break;
+		case PERF_RECORD_LOST:
+			ops->lost((event_t *)iter->event, s);
+			break;
+		case PERF_RECORD_READ:
+			ops->read((event_t *)iter->event, s);
+			break;
 		default:
 			printf("Warning: Unrecognised event in flush_sample_queue\n");
 		}
@@ -652,6 +659,12 @@ static int __perf_session__process_event(struct perf_session *self,
 	case PERF_RECORD_COMM:
 		return perf_session__process_timed(event, self, ops,
 						   ops->comm, offset, head);
+	case PERF_RECORD_LOST:
+		return perf_session__process_timed(event, self, ops,
+						   ops->lost, offset, head);
+	case PERF_RECORD_READ:
+		return perf_session__process_timed(event, self, ops,
+						   ops->read, offset, head);
 	default: break;
 	}
 
@@ -662,10 +675,6 @@ static int __perf_session__process_event(struct perf_session *self,
 		return ops->fork(event, self);
 	case PERF_RECORD_EXIT:
 		return ops->exit(event, self);
-	case PERF_RECORD_LOST:
-		return ops->lost(event, self);
-	case PERF_RECORD_READ:
-		return ops->read(event, self);
 	case PERF_RECORD_THROTTLE:
 		return ops->throttle(event, self);
 	case PERF_RECORD_UNTHROTTLE:
@@ -701,6 +710,7 @@ static int perf_session__process_event(struct perf_session *self,
 
 	switch (event->header.type) {
 	case PERF_RECORD_MMAP: case PERF_RECORD_COMM:
+	case PERF_RECORD_LOST: case PERF_RECORD_READ:
 		/* These events are coming in with the old ABI (missing time
 		 * field), so make a temporary copy following the new ABI data
 		 * structure and set the time field to 0.
-- 
1.7.2.3

