Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759832Ab0JVTPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:15:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37529 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab0JVTN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:13:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=UwS1u82oTz3sCBzA9Ls4M7RVFzZIgknoy3+h/s3uqCcFAPYd6D0A5yZS+kusG3GDur
         oWqiSk5YK0bBEHcPxn6q/MZ3Hrp1oRbq1A168WTLm3VbEF1Oma2IAP/g7D+lK4OqPcv4
         EOAzRa8iEGuo8HNHOZoTgFPgGNPXZLTzOWmFU=
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
        Robert Richter <robert.richter@amd.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: [RFC PATCH 04/11] perf: Add ability to dump part of the user stack
Date: Fri, 22 Oct 2010 21:13:05 +0200
Message-Id: <1287774792-23123-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1287774792-23123-1-git-send-regression-fweisbec@gmail.com>
References: <1287774792-23123-1-git-send-regression-fweisbec@gmail.com>
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
Cc: Robert Richter <robert.richter@amd.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
---
 include/linux/perf_event.h |    9 +++-
 kernel/perf_event.c        |  123 ++++++++++++++++++++++++++++++++++++--------
 2 files changed, 108 insertions(+), 24 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 28210d4..87441b5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -236,6 +236,10 @@ struct perf_event_attr {
 	 * samples. See asm/perf_regs.h for details.
 	 */
 	__u64			user_regs;
+	__u32			ustack_dump_size;
+
+	/* Future extension */
+	__u32			__reserved_4;
 };
 
 /*
@@ -1107,8 +1111,9 @@ extern int perf_output_begin(struct perf_output_handle *handle,
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
index 0e4ab11..674ed25 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3295,28 +3295,43 @@ out:
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
+DEFINE_PERF_OUTPUT_COPY(perf_output_copy_user_gup, copy_from_user_gup)
 
 int perf_output_begin(struct perf_output_handle *handle,
 		      struct perf_event *event, unsigned int size,
@@ -3618,6 +3633,44 @@ void perf_output_sample(struct perf_output_handle *handle,
 						event->attr.user_regs);
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
+		rem = perf_output_copy_user_gup(handle, (void *)sp, size);
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
@@ -3716,6 +3769,32 @@ void perf_prepare_sample(struct perf_event_header *header,
 
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
 
 static void perf_event_output(struct perf_event *event, int nmi,
-- 
1.6.2.3

