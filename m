Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab0GAPyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:54:13 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47049 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab0GAPyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:54:05 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/21] perf_events: Export buffer handling functions
Date: Thu,  1 Jul 2010 17:55:43 +0200
Message-Id: <1277999763-20357-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277999763-20357-1-git-send-email-bp@amd64.org>
References: <1277999763-20357-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

... for other in-kernel users.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 include/linux/perf_event.h |    8 ++++++++
 kernel/perf_event.c        |    8 ++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 63b5aa5..cb242bd 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1017,6 +1017,10 @@ extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
+extern struct perf_buffer *
+perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags);
+extern void perf_buffer_put(struct perf_buffer *buffer);
+
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
@@ -1054,6 +1058,10 @@ static inline int  perf_swevent_get_recursion_context(void)		{ return -1; }
 static inline void perf_swevent_put_recursion_context(int rctx)		{ }
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
+extern struct perf_buffer *
+perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)	{ return NULL; }
+static inline void perf_buffer_put(struct perf_buffer *buffer)		{}
+
 #endif
 
 #define perf_output_put(handle, x) \
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c772a3d..40478af 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1881,7 +1881,7 @@ static void free_event_rcu(struct rcu_head *head)
 }
 
 static void perf_pending_sync(struct perf_event *event);
-static void perf_buffer_put(struct perf_buffer *buffer);
+void perf_buffer_put(struct perf_buffer *buffer);
 
 static void free_event(struct perf_event *event)
 {
@@ -2424,7 +2424,7 @@ static void *perf_mmap_alloc_page(int cpu)
 	return page_address(page);
 }
 
-static struct perf_buffer *
+struct perf_buffer *
 perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
 {
 	struct perf_buffer *buffer;
@@ -2541,7 +2541,7 @@ static void perf_buffer_free(struct perf_buffer *buffer)
 	schedule_work(&buffer->work);
 }
 
-static struct perf_buffer *
+struct perf_buffer *
 perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
 {
 	struct perf_buffer *buffer;
@@ -2642,7 +2642,7 @@ static struct perf_buffer *perf_buffer_get(struct perf_event *event)
 	return buffer;
 }
 
-static void perf_buffer_put(struct perf_buffer *buffer)
+void perf_buffer_put(struct perf_buffer *buffer)
 {
 	if (!atomic_dec_and_test(&buffer->refcount))
 		return;
-- 
1.7.1

