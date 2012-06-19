Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab2FSPtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:49:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab2FSPs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:48:57 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 05/23] perf: Factor __output_copy to be usable with specific copy function
Date: Tue, 19 Jun 2012 17:47:56 +0200
Message-Id: <1340120894-9465-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a generic way to use __output_copy function with
specific copy function via DEFINE_PERF_OUTPUT_COPY macro.

Using this to add new __output_copy_user function, that provides
output copy from user pointers. For x86 the copy_from_user_nmi_nochk
function is used and __copy_from_user_inatomic for the rest
of the architectures.

This new function will be used in user stack dump on sample,
comming in next patches.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/include/asm/perf_event.h |    2 +
 include/linux/perf_event.h        |    2 +-
 kernel/events/internal.h          |   62 ++++++++++++++++++++++++------------
 kernel/events/ring_buffer.c       |    4 +-
 4 files changed, 46 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 588f52e..7b46815 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -257,4 +257,6 @@ static inline void perf_events_lapic_init(void)	{ }
  static inline void amd_pmu_disable_virt(void) { }
 #endif
 
+#define arch_perf_out_copy_user copy_from_user_nmi_nochk
+
 #endif /* _ASM_X86_PERF_EVENT_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 969ee0b..cd40669 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1301,7 +1301,7 @@ static inline bool has_branch_stack(struct perf_event *event)
 extern int perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_event *event, unsigned int size);
 extern void perf_output_end(struct perf_output_handle *handle);
-extern void perf_output_copy(struct perf_output_handle *handle,
+extern unsigned int perf_output_copy(struct perf_output_handle *handle,
 			     const void *buf, unsigned int len);
 extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index b0b107f..2206a0f 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -2,6 +2,7 @@
 #define _KERNEL_EVENTS_INTERNAL_H
 
 #include <linux/hardirq.h>
+#include <linux/uaccess.h>
 
 /* Buffer handling */
 
@@ -76,30 +77,49 @@ static inline unsigned long perf_data_size(struct ring_buffer *rb)
 	return rb->nr_pages << (PAGE_SHIFT + page_order(rb));
 }
 
-static inline void
-__output_copy(struct perf_output_handle *handle,
-		   const void *buf, unsigned int len)
+#define DEFINE_OUTPUT_COPY(func_name, memcpy_func)			\
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
+static inline int memcpy_common(void *dst, const void *src, size_t n)
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
 
+DEFINE_OUTPUT_COPY(__output_copy, memcpy_common)
+
+#ifndef arch_perf_out_copy_user
+#define arch_perf_out_copy_user __copy_from_user_inatomic
+#endif
+
+DEFINE_OUTPUT_COPY(__output_copy_user, arch_perf_out_copy_user)
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

