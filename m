Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645Ab0ENTcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:32:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62777 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759359Ab0ENT3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:29:18 -0400
X-Authority-Analysis: v=1.1 cv=RZg5C6NCKrCZril9sGGnsuGk01/OiP2z3O3lo0hXATg= c=1 sm=0 a=zGwFfr6l9OEA:10 a=1CvaPgNKC-EA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=ofj7Fx6950qZ8SgYEC4A:9 a=Eo_flsM7LB68SeD-jUEA:7 a=5zqmB9nYWYJhe2nHl-zvnp9wWYsA:4 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100514192916.945900385@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 14 May 2010 15:22:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 12/13 v3] ring-buffer: Add cached pages when freeing reader page
References: <20100514192246.079025623@goodmis.org>
Content-Disposition: inline; filename=0012-ring-buffer-Add-cached-pages-when-freeing-reader-pag.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When the pages are removed from the ring buffer for things like
splice they are freed with ring_buffer_free_read_page().
They are also allocated with ring_buffer_alloc_read_page().

Currently the ring buffer does not take advantage of this situation.
Every time the page is freed, the ring buffer simply frees it.
When a new page is needed, it allocates it. This means that reading
several pages with splice will cause a page to be freed and allocated
several times. This is simply a waste.

This patch adds a cache of the pages freed (16 max). This allows
the pages to be reused quickly without need to go back to the memory
pool.

v2: Added in locking that should have been there in the first release.

Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   52 ++++++++++++++++++++++++++++++++++++++------
 1 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7f6059c..7aded7d 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -157,6 +157,8 @@ static unsigned long ring_buffer_flags __read_mostly = RB_BUFFERS_ON;
 
 #define BUF_PAGE_HDR_SIZE offsetof(struct buffer_data_page, data)
 
+#define RB_MAX_FREE_PAGES	16
+
 /**
  * tracing_on - enable all tracing buffers
  *
@@ -325,7 +327,10 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
 #define RB_MISSED_STORED	(1 << 30)
 
 struct buffer_data_page {
-	u64		 time_stamp;	/* page time stamp */
+	union {
+		struct buffer_data_page	*next;	/* for free pages */
+		u64		 time_stamp;	/* page time stamp */
+	};
 	local_t		 commit;	/* write committed index */
 	unsigned char	 data[];	/* data of buffer page */
 };
@@ -472,6 +477,10 @@ struct ring_buffer {
 	atomic_t			record_disabled;
 	cpumask_var_t			cpumask;
 
+	struct buffer_data_page		*free_pages;
+	int				nr_free_pages;
+	spinlock_t			free_pages_lock;
+
 	struct lock_class_key		*reader_lock_key;
 
 	struct mutex			mutex;
@@ -1118,6 +1127,7 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 	buffer->flags = flags;
 	buffer->clock = trace_clock_local;
 	buffer->reader_lock_key = key;
+	spin_lock_init(&buffer->free_pages_lock);
 
 	/* need at least two pages */
 	if (buffer->pages < 2)
@@ -1184,6 +1194,7 @@ EXPORT_SYMBOL_GPL(__ring_buffer_alloc);
 void
 ring_buffer_free(struct ring_buffer *buffer)
 {
+	struct buffer_data_page *bpage;
 	int cpu;
 
 	get_online_cpus();
@@ -1200,6 +1211,11 @@ ring_buffer_free(struct ring_buffer *buffer)
 	kfree(buffer->buffers);
 	free_cpumask_var(buffer->cpumask);
 
+	while (buffer->free_pages) {
+		bpage = buffer->free_pages;
+		buffer->free_pages = bpage->next;
+		free_page((unsigned long)bpage);
+	};
 	kfree(buffer);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_free);
@@ -3714,14 +3730,24 @@ EXPORT_SYMBOL_GPL(ring_buffer_swap_cpu);
  */
 void *ring_buffer_alloc_read_page(struct ring_buffer *buffer)
 {
-	struct buffer_data_page *bpage;
+	struct buffer_data_page *bpage = NULL;
 	unsigned long addr;
 
-	addr = __get_free_page(GFP_KERNEL);
-	if (!addr)
-		return NULL;
+	spin_lock(&buffer->free_pages_lock);
+	if (buffer->free_pages) {
+		bpage = buffer->free_pages;
+		buffer->free_pages = bpage->next;
+		buffer->nr_free_pages--;
+	}
+	spin_unlock(&buffer->free_pages_lock);
 
-	bpage = (void *)addr;
+	if (!bpage) {
+		addr = __get_free_page(GFP_KERNEL);
+		if (!addr)
+			return NULL;
+
+		bpage = (void *)addr;
+	}
 
 	rb_init_page(bpage);
 
@@ -3738,7 +3764,19 @@ EXPORT_SYMBOL_GPL(ring_buffer_alloc_read_page);
  */
 void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data)
 {
-	free_page((unsigned long)data);
+	struct buffer_data_page *bpage = data;
+
+	spin_lock(&buffer->free_pages_lock);
+	if (buffer->nr_free_pages >= RB_MAX_FREE_PAGES) {
+		spin_unlock(&buffer->free_pages_lock);
+		free_page((unsigned long)data);
+		return;
+	}
+
+	bpage->next = buffer->free_pages;
+	buffer->free_pages = bpage;
+	buffer->nr_free_pages++;
+	spin_unlock(&buffer->free_pages_lock);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_free_read_page);
 
-- 
1.7.0


