Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab2IHBMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 21:12:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40135 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758667Ab2IHBMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 21:12:36 -0400
From: Mandeep Singh Baines <mandeep.baines@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] tracing: add an option for disabling markers
Date: Fri,  7 Sep 2012 18:12:19 -0700
Message-Id: <1347066739-26285-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In our application, we have trace markers spread through user-space.
We have markers in GL, X, etc. These are super handy for Chrome's
about:tracing feature (Chrome + system + kernel trace view), but
can be very distracting when you're trying to debug a kernel issue.

I normally, use "grep -v tracing_mark_write" but it would be nice
if I could just temporarily disable markers all together.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace.c |    6 +++++-
 kernel/trace/trace.h |    1 +
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5c38c81..0b052da 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -328,7 +328,7 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
 	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE |
-	TRACE_ITER_IRQ_INFO;
+	TRACE_ITER_IRQ_INFO | TRACE_ITER_MARKERS;
 
 static int trace_stop_count;
 static DEFINE_RAW_SPINLOCK(tracing_start_lock);
@@ -470,6 +470,7 @@ static const char *trace_options[] = {
 	"overwrite",
 	"disable_on_free",
 	"irq-info",
+	"markers",
 	NULL
 };
 
@@ -3886,6 +3887,9 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	if (tracing_disabled)
 		return -EINVAL;
 
+	if (!(trace_flags & TRACE_ITER_MARKERS))
+		return -EINVAL;
+
 	if (cnt > TRACE_BUF_SIZE)
 		cnt = TRACE_BUF_SIZE;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 55e1f7f..3da9da0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -680,6 +680,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_OVERWRITE		= 0x200000,
 	TRACE_ITER_STOP_ON_FREE		= 0x400000,
 	TRACE_ITER_IRQ_INFO		= 0x800000,
+	TRACE_ITER_MARKERS		= 0x1000000,
 };
 
 /*
-- 
1.7.8.6

