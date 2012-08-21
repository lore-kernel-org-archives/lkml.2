Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab2HUPsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:48:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60211 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab2HUPsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:48:54 -0400
Date: Tue, 21 Aug 2012 08:47:28 -0700
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-91d7753a45f8525dc75b6be01e427dc1c378dc16@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org, gorcunov@openvz.org,
        a.p.zijlstra@chello.nl, benjamin.redelings@nescent.org,
        jolsa@redhat.com, drepper@gmail.com, robert.richter@amd.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        asharma@fb.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        fche@redhat.com, paulus@samba.org, tzanussi@gmail.com,
        masami.hiramatsu.pt@hitachi.com, mingo@elte.hu
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com,
        gorcunov@openvz.org, a.p.zijlstra@chello.nl,
        benjamin.redelings@nescent.org, jolsa@redhat.com, fweisbec@gmail.com,
        robert.richter@amd.com, drepper@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, asharma@fb.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
        tzanussi@gmail.com, masami.hiramatsu.pt@hitachi.com, mingo@elte.hu
In-Reply-To: <1344345647-11536-4-git-send-email-jolsa@redhat.com>
References: <1344345647-11536-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Factor __output_copy to be usable with specific copy function
Git-Commit-ID: 91d7753a45f8525dc75b6be01e427dc1c378dc16
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:47:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  91d7753a45f8525dc75b6be01e427dc1c378dc16
Gitweb:     http://git.kernel.org/tip/91d7753a45f8525dc75b6be01e427dc1c378dc16
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 7 Aug 2012 15:20:38 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 10 Aug 2012 11:44:06 -0300

perf: Factor __output_copy to be usable with specific copy function

Adding a generic way to use __output_copy function with specific copy
function via DEFINE_PERF_OUTPUT_COPY macro.

Using this to add new __output_copy_user function, that provides output
copy from user pointers. For x86 the copy_from_user_nmi function is used
and __copy_from_user_inatomic for the rest of the architectures.

This new function will be used in user stack dump on sample, coming in
next patches.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Benjamin Redelings <benjamin.redelings@nescent.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/1344345647-11536-4-git-send-email-jolsa@redhat.com
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/x86/include/asm/perf_event.h |    2 +
 include/linux/perf_event.h        |    2 +-
 kernel/events/internal.h          |   62 ++++++++++++++++++++++++------------
 kernel/events/ring_buffer.c       |    4 +-
 4 files changed, 46 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index cb4e43b..4fabcdf 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -262,4 +262,6 @@ static inline void perf_check_microcode(void) { }
  static inline void amd_pmu_disable_virt(void) { }
 #endif
 
+#define arch_perf_out_copy_user copy_from_user_nmi
+
 #endif /* _ASM_X86_PERF_EVENT_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3d4d847..d41394a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1319,7 +1319,7 @@ static inline bool has_branch_stack(struct perf_event *event)
 extern int perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_event *event, unsigned int size);
 extern void perf_output_end(struct perf_output_handle *handle);
-extern void perf_output_copy(struct perf_output_handle *handle,
+extern unsigned int perf_output_copy(struct perf_output_handle *handle,
 			     const void *buf, unsigned int len);
 extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index a096c19..7fd5408 100644
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
 extern struct perf_callchain_entry *
 perf_callchain(struct perf_event *event, struct pt_regs *regs);
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
