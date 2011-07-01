Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab1GAPWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:22:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:57531 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862Ab1GAPWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:22:05 -0400
Date: Fri, 1 Jul 2011 15:21:50 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-2crpvsx3cqu67q3zqjbnlpsc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Remove the perf_output_begin(.sample) argument
Git-Commit-ID: a7ac67ea021b4603095d2aa458bc41641238f22c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:21:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7ac67ea021b4603095d2aa458bc41641238f22c
Gitweb:     http://git.kernel.org/tip/a7ac67ea021b4603095d2aa458bc41641238f22c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 27 Jun 2011 16:47:16 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 11:06:35 +0200

perf: Remove the perf_output_begin(.sample) argument

Since only samples call perf_output_sample() its much saner (and more
correct) to put the sample logic in there than in the
perf_output_begin()/perf_output_end() pair.

Saves a useless argument, reduces conditionals and shrinks
struct perf_output_handle, win!

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-2crpvsx3cqu67q3zqjbnlpsc@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    2 +-
 include/linux/perf_event.h                |    4 +---
 kernel/events/core.c                      |   26 ++++++++++++++++++++------
 kernel/events/ring_buffer.c               |   19 +------------------
 4 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 0941f93..1b1ef3a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -340,7 +340,7 @@ static int intel_pmu_drain_bts_buffer(void)
 	 */
 	perf_prepare_sample(&header, &data, event, &regs);
 
-	if (perf_output_begin(&handle, event, header.size * (top - at), 1))
+	if (perf_output_begin(&handle, event, header.size * (top - at)))
 		return 1;
 
 	for (; at < top; at++) {
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0946a8b..771b0b2 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -925,7 +925,6 @@ struct perf_output_handle {
 	unsigned long			size;
 	void				*addr;
 	int				page;
-	int				sample;
 };
 
 #ifdef CONFIG_PERF_EVENTS
@@ -1117,8 +1116,7 @@ extern void perf_bp_event(struct perf_event *event, void *data);
 #endif
 
 extern int perf_output_begin(struct perf_output_handle *handle,
-			     struct perf_event *event, unsigned int size,
-			     int sample);
+			     struct perf_event *event, unsigned int size);
 extern void perf_output_end(struct perf_output_handle *handle);
 extern void perf_output_copy(struct perf_output_handle *handle,
 			     const void *buf, unsigned int len);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index dbd1ca7..81de28d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3928,6 +3928,20 @@ void perf_output_sample(struct perf_output_handle *handle,
 			perf_output_put(handle, raw);
 		}
 	}
+
+	if (!event->attr.watermark) {
+		int wakeup_events = event->attr.wakeup_events;
+
+		if (wakeup_events) {
+			struct ring_buffer *rb = handle->rb;
+			int events = local_inc_return(&rb->events);
+
+			if (events >= wakeup_events) {
+				local_sub(wakeup_events, &rb->events);
+				local_inc(&rb->wakeup);
+			}
+		}
+	}
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
@@ -3984,7 +3998,7 @@ static void perf_event_output(struct perf_event *event,
 
 	perf_prepare_sample(&header, data, event, regs);
 
-	if (perf_output_begin(&handle, event, header.size, 1))
+	if (perf_output_begin(&handle, event, header.size))
 		goto exit;
 
 	perf_output_sample(&handle, &header, data, event);
@@ -4024,7 +4038,7 @@ perf_event_read_event(struct perf_event *event,
 	int ret;
 
 	perf_event_header__init_id(&read_event.header, &sample, event);
-	ret = perf_output_begin(&handle, event, read_event.header.size, 0);
+	ret = perf_output_begin(&handle, event, read_event.header.size);
 	if (ret)
 		return;
 
@@ -4067,7 +4081,7 @@ static void perf_event_task_output(struct perf_event *event,
 	perf_event_header__init_id(&task_event->event_id.header, &sample, event);
 
 	ret = perf_output_begin(&handle, event,
-				task_event->event_id.header.size, 0);
+				task_event->event_id.header.size);
 	if (ret)
 		goto out;
 
@@ -4204,7 +4218,7 @@ static void perf_event_comm_output(struct perf_event *event,
 
 	perf_event_header__init_id(&comm_event->event_id.header, &sample, event);
 	ret = perf_output_begin(&handle, event,
-				comm_event->event_id.header.size, 0);
+				comm_event->event_id.header.size);
 
 	if (ret)
 		goto out;
@@ -4351,7 +4365,7 @@ static void perf_event_mmap_output(struct perf_event *event,
 
 	perf_event_header__init_id(&mmap_event->event_id.header, &sample, event);
 	ret = perf_output_begin(&handle, event,
-				mmap_event->event_id.header.size, 0);
+				mmap_event->event_id.header.size);
 	if (ret)
 		goto out;
 
@@ -4546,7 +4560,7 @@ static void perf_log_throttle(struct perf_event *event, int enable)
 	perf_event_header__init_id(&throttle_event.header, &sample, event);
 
 	ret = perf_output_begin(&handle, event,
-				throttle_event.header.size, 0);
+				throttle_event.header.size);
 	if (ret)
 		return;
 
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 8b3b736..a2a2920 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -98,8 +98,7 @@ out:
 }
 
 int perf_output_begin(struct perf_output_handle *handle,
-		      struct perf_event *event, unsigned int size,
-		      int sample)
+		      struct perf_event *event, unsigned int size)
 {
 	struct ring_buffer *rb;
 	unsigned long tail, offset, head;
@@ -124,7 +123,6 @@ int perf_output_begin(struct perf_output_handle *handle,
 
 	handle->rb	= rb;
 	handle->event	= event;
-	handle->sample	= sample;
 
 	if (!rb->nr_pages)
 		goto out;
@@ -192,21 +190,6 @@ void perf_output_copy(struct perf_output_handle *handle,
 
 void perf_output_end(struct perf_output_handle *handle)
 {
-	struct perf_event *event = handle->event;
-	struct ring_buffer *rb = handle->rb;
-
-	if (handle->sample && !event->attr.watermark) {
-		int wakeup_events = event->attr.wakeup_events;
-
-		if (wakeup_events) {
-			int events = local_inc_return(&rb->events);
-			if (events >= wakeup_events) {
-				local_sub(wakeup_events, &rb->events);
-				local_inc(&rb->wakeup);
-			}
-		}
-	}
-
 	perf_output_put_handle(handle);
 	rcu_read_unlock();
 }
