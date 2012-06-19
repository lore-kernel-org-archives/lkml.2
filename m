Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab2FSPtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:49:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650Ab2FSPth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:49:37 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 06/23] perf: Add perf_output_skip function to skip bytes in sample
Date: Tue, 19 Jun 2012 17:47:57 +0200
Message-Id: <1340120894-9465-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing perf_output_skip function to be able to skip
data within the perf ring buffer.

When writing data into perf ring buffer we first reserve needed
place in ring buffer and then copy the actual data.

There's a possibility we won't be able to fill all the reserved
size with data, so we need a way to skip the remaining bytes.

This is going to be usefull when storing the user stack dump,
where we might end up with less data than we originally requested.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/perf_event.h  |    2 ++
 kernel/events/internal.h    |    4 ++++
 kernel/events/ring_buffer.c |    6 ++++++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index cd40669..024a822 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1303,6 +1303,8 @@ extern int perf_output_begin(struct perf_output_handle *handle,
 extern void perf_output_end(struct perf_output_handle *handle);
 extern unsigned int perf_output_copy(struct perf_output_handle *handle,
 			     const void *buf, unsigned int len);
+extern unsigned int perf_output_skip(struct perf_output_handle *handle,
+				     unsigned int len);
 extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 2206a0f..be1ef29 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -114,6 +114,10 @@ static inline int memcpy_common(void *dst, const void *src, size_t n)
 
 DEFINE_OUTPUT_COPY(__output_copy, memcpy_common)
 
+#define MEMCPY_SKIP(dst, src, n) (n)
+
+DEFINE_OUTPUT_COPY(__output_skip, MEMCPY_SKIP)
+
 #ifndef arch_perf_out_copy_user
 #define arch_perf_out_copy_user __copy_from_user_inatomic
 #endif
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index b4c2ad3..23cb34f 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -188,6 +188,12 @@ unsigned int perf_output_copy(struct perf_output_handle *handle,
 	return __output_copy(handle, buf, len);
 }
 
+unsigned int perf_output_skip(struct perf_output_handle *handle,
+			      unsigned int len)
+{
+	return __output_skip(handle, NULL, len);
+}
+
 void perf_output_end(struct perf_output_handle *handle)
 {
 	perf_output_put_handle(handle);
-- 
1.7.7.6

