Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab0JMFIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 01:08:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35732 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab0JMFHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 01:07:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=caQ/j7ZyLqgajpoMK+Y9gV/ZgEfd9xooTJQtOkMdPqJiyk/z7oaFgb5Ae6Hap8mYxw
         XAjMLpOc7P9BiGrxYbtKEciwDvUz+7JW7IRoqkXVcUAZehhzVWvyswNotrdXqEfIq43r
         cNX6XAPA978fOZZkfveI4l0Ear4Sfh06MMf1I=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [RFC PATCH 3/9] perf: Add ability to dump part of the user stack
Date: Wed, 13 Oct 2010 07:06:55 +0200
Message-Id: <1286946421-32202-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
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
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>
---
 include/linux/perf_event.h |   11 +++-
 kernel/perf_event.c        |  123 ++++++++++++++++++++++++++++++++++++--------
 2 files changed, 110 insertions(+), 24 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 71b108b..0b1b039 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -227,6 +227,12 @@ struct perf_event_attr {
 	__u32			bp_type;
 	__u64			bp_addr;
 	__u64			bp_len;
+
+	__u64			__reserved_2;
+	__u64			__reserved_3;
+
+	__u32			ustack_dump_size;
+	__u32			__reserved_4;
 };
 
 /*
@@ -1061,8 +1067,9 @@ extern int perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_event *event, unsigned int size,
 			     int nmi, int sample);
 extern void perf_output_end(struct perf_output_handle *handle);
-extern void perf_output_copy(struct perf_output_handle *handle,
-			     const void *buf, unsigned int len);
+extern unsigned int
+perf_output_copy(struct perf_output_handle *handle,
+		 const void *buf, unsigned int len);
 extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index f1c0d72..0a1f0df 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3332,28 +3332,43 @@ out:
 	preempt_enable();
 }
 
-__always_inline void perf_output_copy(struct perf_output_handle *handle,
-		      const void *buf, unsigned int len)
-{
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
-			struct perf_buffer *buffer = handle->buffer;
-
-			handle->page++;
-			handle->page &= buffer->nr_pages - 1;
-			handle->addr = buffer->data_pages[handle->page];
-			handle->size = PAGE_SIZE << page_order(buffer);
-		}
-	} while (len);
-}
+static int memcpy_common(void *dst, const void *src, size_t n)
+{
+	memcpy(dst, src, n);
+
+	return n;
+}
+
+#define DEFINE_PERF_OUTPUT_COPY(func_name, memcpy_func)				\
+__always_inline unsigned int func_name(struct perf_output_handle *handle,	\
+				       const void *buf, unsigned int len)	\
+{										\
+	unsigned long size, written;						\
+										\
+	do {									\
+		size = min_t(unsigned long, handle->size, len);			\
+										\
+		written = memcpy_func(handle->addr, buf, size);			\
+										\
+		len -= written;							\
+		handle->addr += written;					\
+		buf += written;							\
+		handle->size -= written;					\
+		if (!handle->size) {						\
+			struct perf_buffer *buffer = handle->buffer;		\
+										\
+			handle->page++;						\
+			handle->page &= buffer->nr_pages - 1;			\
+			handle->addr = buffer->data_pages[handle->page];	\
+			handle->size = PAGE_SIZE << page_order(buffer);		\
+		}								\
+	} while (len && written == size);					\
+										\
+	return len;								\
+}
+
+DEFINE_PERF_OUTPUT_COPY(perf_output_copy, memcpy_common)
+DEFINE_PERF_OUTPUT_COPY(perf_output_copy_user_nmi, copy_from_user_nmi)
 
 int perf_output_begin(struct perf_output_handle *handle,
 		      struct perf_event *event, unsigned int size,
@@ -3639,6 +3654,44 @@ void perf_output_sample(struct perf_output_handle *handle,
 			perf_output_put(handle, size);
 		}
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
+
+			return;
+		}
+
+		/*
+		 * Static size: we always dump the size requested by the user
+		 * because most of the time, the top of the user stack is not
+		 * paged out. Perhaps we should force ustack_dump_size
+		 * to be % 8.
+		 */
+		size = event->attr.ustack_dump_size;
+		size = round_up(size, sizeof(u64));
+		perf_output_put(handle, size);
+
+		/* CHECKME: might me missing on some archs */
+		sp = user_stack_pointer(data->uregs);
+		rem = perf_output_copy_user_nmi(handle, (void *)sp, size);
+		dyn_size = size - rem;
+
+		/* What couldn't be dumped is zero padded */
+		while (rem--) {
+			char zero = 0;
+			perf_output_put(handle, zero);
+		}
+
+		/* Dynamic size: whole dump - padding */
+		perf_output_put(handle, dyn_size);
+	}
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
@@ -3736,6 +3789,32 @@ void perf_prepare_sample(struct perf_event_header *header,
 
 		header->size += size;
 	}
+
+	if (event->attr.ustack_dump_size) {
+		if (!(sample_type & PERF_SAMPLE_UREGS))
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
 
 static void perf_event_output(struct perf_event *event, int nmi,
-- 
1.6.2.3

