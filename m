Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab0ENALX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:11:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65300 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab0ENALW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:11:22 -0400
X-Authority-Analysis: v=1.1 cv=MoOeBCR3UCSroT7bBzr0mtJUqJhHyBWzyNa37ex1qNU= c=1 sm=0 a=yIUWbiYEC5gA:10 a=UBIxAjGgU1YA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=TDVm55_1NoOrEodbF3UA:9 a=tf_j3Am_0tSQKCZNr8oA:7 a=JiDhOtSEG8_bwlfzS6jIvK-TI6YA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL] ring-buffer: Add cached pages when freeing
 reader page
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 13 May 2010 20:11:20 -0400
Message-ID: <1273795880.27703.1610.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This includes the updates in core-2.

Please pull the latest tip/tracing/core-3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core-3


Steven Rostedt (1):
      ring-buffer: Add cached pages when freeing reader page

----
 kernel/trace/ring_buffer.c |   52 ++++++++++++++++++++++++++++++++++++++------
 1 files changed, 45 insertions(+), 7 deletions(-)
---------------------------
commit 9d70909920a69e431348c6d5cf46e72d4e3514bc
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu May 13 15:33:06 2010 -0400

    ring-buffer: Add cached pages when freeing reader page
    
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
 


