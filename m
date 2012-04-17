Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab2DQLSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:18:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156Ab2DQLSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:18:18 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, rostedt@goodmis.org, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 04/16] perf: Add ability to dump part of the user stack
Date: Tue, 17 Apr 2012 13:17:09 +0200
Message-Id: <1334661441-4420-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
References: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Beeing able to dump parts of the user stack, starting from the
stack pointer, will be useful to make a post mortem dwarf CFI based
stack unwinding.

This is done through the new ustack_dump_size perf attribute. If it
is non zero, the user stack will dumped in samples following the
requested size in bytes.

The longer is the dump, the deeper will be the resulting retrieved
callchain.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/perf_event.h  |    6 +++-
 kernel/events/core.c        |   61 +++++++++++++++++++++++++++++++++++++++++++
 kernel/events/internal.h    |   56 ++++++++++++++++++++++++---------------
 kernel/events/ring_buffer.c |    4 +-
 4 files changed, 102 insertions(+), 25 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c63b807..e40bac5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -278,6 +278,7 @@ struct perf_event_attr {
 	 * samples. See asm/perf_regs.h for details.
 	 */
 	__u64			user_regs;
+	__u32			ustack_dump_size;
 };
 
 /*
@@ -1291,8 +1292,9 @@ static inline bool has_branch_stack(struct perf_event *event)
 extern int perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_event *event, unsigned int size);
 extern void perf_output_end(struct perf_output_handle *handle);
-extern void perf_output_copy(struct perf_output_handle *handle,
-			     const void *buf, unsigned int len);
+extern unsigned int
+perf_output_copy(struct perf_output_handle *handle,
+		 const void *buf, unsigned int len);
 extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9f29fc3..5bae705 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4057,6 +4057,41 @@ void perf_output_sample(struct perf_output_handle *handle,
 			perf_output_sample_regs(handle, data->uregs,
 						event->attr.user_regs);
 	}
+
+	if (event->attr.ustack_dump_size) {
+		unsigned long sp;
+		unsigned int rem;
+		u64 size, dyn_size;
+
+		/* Case of a kernel thread, nothing to dump */
+		if (!data->uregs) {
+			size = 0;
+			perf_output_put(handle, size);
+		} else {
+
+			/*
+			 * Static size: we always dump the size requested by
+			 * the user because most of the time, the top of the
+			 * user stack is not paged out.
+			 */
+			size = event->attr.ustack_dump_size;
+			size = round_up(size, sizeof(u64));
+			perf_output_put(handle, size);
+
+			sp = user_stack_pointer(data->uregs);
+			rem = __output_copy_user_gup(handle, (void *)sp, size);
+			dyn_size = size - rem;
+
+			/* What couldn't be dumped is zero padded */
+			while (rem--) {
+				char zero = 0;
+				perf_output_put(handle, zero);
+			}
+
+			/* Dynamic size: whole dump - padding */
+			perf_output_put(handle, dyn_size);
+		}
+	}
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
@@ -4118,6 +4153,32 @@ void perf_prepare_sample(struct perf_event_header *header,
 
 		header->size += size;
 	}
+
+	if (event->attr.ustack_dump_size) {
+		if (!event->attr.user_regs)
+			data->uregs = perf_sample_uregs(regs);
+
+		/*
+		 * A first field that tells the _static_ size of the dump. 0 if
+		 * there is nothing to dump (ie: we are in a kernel thread)
+		 * otherwise the requested size.
+		 */
+		header->size += sizeof(u64);
+
+		/*
+		 * If there is something to dump, add space for the dump itself
+		 * and for the field that tells the _dynamic_ size, which is
+		 * how many have been actually dumped. What couldn't be dumped
+		 * will be zero-padded.
+		 */
+		if (data->uregs) {
+			u64 size = event->attr.ustack_dump_size;
+
+			size = round_up(size, sizeof(u64));
+			header->size += size;
+			header->size += sizeof(u64);
+		}
+	}
 }
 
 static void perf_event_output(struct perf_event *event,
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index b0b107f..1ae5270 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -76,30 +76,44 @@ static inline unsigned long perf_data_size(struct ring_buffer *rb)
 	return rb->nr_pages << (PAGE_SHIFT + page_order(rb));
 }
 
-static inline void
-__output_copy(struct perf_output_handle *handle,
-		   const void *buf, unsigned int len)
+static int memcpy_common(void *dst, const void *src, size_t n)
 {
-	do {
-		unsigned long size = min_t(unsigned long, handle->size, len);
-
-		memcpy(handle->addr, buf, size);
-
-		len -= size;
-		handle->addr += size;
-		buf += size;
-		handle->size -= size;
-		if (!handle->size) {
-			struct ring_buffer *rb = handle->rb;
-
-			handle->page++;
-			handle->page &= rb->nr_pages - 1;
-			handle->addr = rb->data_pages[handle->page];
-			handle->size = PAGE_SIZE << page_order(rb);
-		}
-	} while (len);
+	memcpy(dst, src, n);
+	return n;
 }
 
+#define DEFINE_PERF_OUTPUT_COPY(func_name, memcpy_func)			\
+static inline unsigned int						\
+func_name(struct perf_output_handle *handle,				\
+	  const void *buf, unsigned int len)				\
+{									\
+	unsigned long size, written;					\
+									\
+	do {								\
+		size = min_t(unsigned long, handle->size, len);		\
+									\
+		written = memcpy_func(handle->addr, buf, size);		\
+									\
+		len -= written;						\
+		handle->addr += written;				\
+		buf += written;						\
+		handle->size -= written;				\
+		if (!handle->size) {					\
+			struct ring_buffer *rb = handle->rb;		\
+									\
+			handle->page++;					\
+			handle->page &= rb->nr_pages - 1;		\
+			handle->addr = rb->data_pages[handle->page];	\
+			handle->size = PAGE_SIZE << page_order(rb);	\
+		}							\
+	} while (len && written == size);				\
+									\
+	return len;							\
+}
+
+DEFINE_PERF_OUTPUT_COPY(__output_copy, memcpy_common)
+DEFINE_PERF_OUTPUT_COPY(__output_copy_user_gup, copy_from_user_gup)
+
 /* Callchain handling */
 extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
 extern int get_callchain_buffers(void);
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 6ddaba4..b4c2ad3 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -182,10 +182,10 @@ out:
 	return -ENOSPC;
 }
 
-void perf_output_copy(struct perf_output_handle *handle,
+unsigned int perf_output_copy(struct perf_output_handle *handle,
 		      const void *buf, unsigned int len)
 {
-	__output_copy(handle, buf, len);
+	return __output_copy(handle, buf, len);
 }
 
 void perf_output_end(struct perf_output_handle *handle)
-- 
1.7.7.6

