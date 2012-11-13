Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab2KMBxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:53:14 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64882 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab2KMBxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:53:12 -0500
Message-ID: <50A1A800.3020102@gmail.com>
Date: Tue, 13 Nov 2012 09:53:04 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: rostedt@goodmis.org, fweisbec@gmail.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>, mingo@redhat.com,
        cl@linux-foundation.org, Shan Wei <shanwei88@gmail.com>
Subject: [PATCH v4 7/9] trace: use this_cpu_ptr per-cpu helper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>

typeof(&buffer) is a pointer to array of 1024 char, or char (*)[1024].
But, typeof(&buffer[0]) is a pointer to char which match the return type of get_trace_buf().
As well-known, the value of &buffer is equal to &buffer[0].
so return this_cpu_ptr(&percpu_buffer->buffer[0]) can avoid type cast. 

Signed-off-by: Shan Wei <davidshan@tencent.com>
---
v4: avoid type cast using &percpu_buffer->buffer[0].
---
 kernel/trace/blktrace.c |    2 +-
 kernel/trace/trace.c    |    5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c0bd030..71259e2 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -147,7 +147,7 @@ void __trace_note_message(struct blk_trace *bt, const char *fmt, ...)
 		return;
 
 	local_irq_save(flags);
-	buf = per_cpu_ptr(bt->msg_data, smp_processor_id());
+	buf = this_cpu_ptr(bt->msg_data);
 	va_start(args, fmt);
 	n = vscnprintf(buf, BLK_TN_MAX_MSG, fmt, args);
 	va_end(args);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 31e4f55..65cb003 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1495,7 +1495,6 @@ static struct trace_buffer_struct *trace_percpu_nmi_buffer;
 static char *get_trace_buf(void)
 {
 	struct trace_buffer_struct *percpu_buffer;
-	struct trace_buffer_struct *buffer;
 
 	/*
 	 * If we have allocated per cpu buffers, then we do not
@@ -1513,9 +1512,7 @@ static char *get_trace_buf(void)
 	if (!percpu_buffer)
 		return NULL;
 
-	buffer = per_cpu_ptr(percpu_buffer, smp_processor_id());
-
-	return buffer->buffer;
+	return this_cpu_ptr(&percpu_buffer->buffer[0]);
 }
 
 static int alloc_percpu_trace_buffer(void)
-- 
1.7.1


