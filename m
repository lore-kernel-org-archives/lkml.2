Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab0I0Kkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:40:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37164 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab0I0Kka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:40:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oNUUYdt5ZTXKyaizuXViZ2EwBs5IcRmqrzpHNdcpUXIXLLUrABZiL9LDuO2XxifWQ9
         +HA1TCHFBYFtFj0hKdJlYKffqmYl0BZp0p2Mi6kpgScFNBB2Ycl/oGVdZn0HanVvHMC7
         wi/OKUfRPuK8hVmDKGdli0m+PojEU0mUUmyKQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] perf: Annotate lock context on perf_output_begin/end()
Date: Mon, 27 Sep 2010 19:39:54 +0900
Message-Id: <1285583997-1262-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285583997-1262-1-git-send-email-namhyung@gmail.com>
References: <1285583997-1262-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_output_begin() conditionally grabs RCU read lock in case of
returning 0. Rename and wrap it using __cond_lock() to annotate
this. Although perf_output_begin() returns 0 or error code, IMHO
converting it to boolean will not be a problem since there is no
user takes account of the actual code. Annotate perf_output_end()
also.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/perf_event.h |    6 +++++-
 kernel/perf_event.c        |    3 ++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 716f99b..167dd3d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1009,9 +1009,13 @@ extern void perf_bp_event(struct perf_event *event, void *data);
 #define perf_instruction_pointer(regs)	instruction_pointer(regs)
 #endif
 
-extern int perf_output_begin(struct perf_output_handle *handle,
+extern int __perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_event *event, unsigned int size,
 			     int nmi, int sample);
+
+#define perf_output_begin(h, e, s, n, sp)				\
+	(!__cond_lock(RCU, !__perf_output_begin(h, e, s, n, sp)))
+
 extern void perf_output_end(struct perf_output_handle *handle);
 extern void perf_output_copy(struct perf_output_handle *handle,
 			     const void *buf, unsigned int len);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c058a42..bd5d750 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3106,7 +3106,7 @@ __always_inline void perf_output_copy(struct perf_output_handle *handle,
 	} while (len);
 }
 
-int perf_output_begin(struct perf_output_handle *handle,
+int __perf_output_begin(struct perf_output_handle *handle,
 		      struct perf_event *event, unsigned int size,
 		      int nmi, int sample)
 {
@@ -3190,6 +3190,7 @@ out:
 }
 
 void perf_output_end(struct perf_output_handle *handle)
+	__releases(RCU)
 {
 	struct perf_event *event = handle->event;
 	struct perf_buffer *buffer = handle->buffer;
-- 
1.7.2.2

