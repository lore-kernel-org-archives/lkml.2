Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab2I0Fsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:48:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54346 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab2I0Fsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:48:52 -0400
Date: Wed, 26 Sep 2012 22:48:37 -0700
From: tip-bot for Mandeep Singh Baines <mandeep.baines@gmail.com>
Message-ID: <tip-5224c3a31549f1c056039545b289e1b01ed02f12@git.kernel.org>
Cc: msb@chromium.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        mandeep.baines@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        msb@chromium.org, fweisbec@gmail.com, rostedt@goodmis.org,
        mandeep.baines@gmail.com, tglx@linutronix.de
In-Reply-To: <1347066739-26285-1-git-send-email-msb@chromium.org>
References: <1347066739-26285-1-git-send-email-msb@chromium.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Add an option for disabling markers
Git-Commit-ID: 5224c3a31549f1c056039545b289e1b01ed02f12
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 22:48:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5224c3a31549f1c056039545b289e1b01ed02f12
Gitweb:     http://git.kernel.org/tip/5224c3a31549f1c056039545b289e1b01ed02f12
Author:     Mandeep Singh Baines <mandeep.baines@gmail.com>
AuthorDate: Fri, 7 Sep 2012 18:12:19 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 24 Sep 2012 14:10:44 -0400

tracing: Add an option for disabling markers

In our application, we have trace markers spread through user-space.
We have markers in GL, X, etc. These are super handy for Chrome's
about:tracing feature (Chrome + system + kernel trace view), but
can be very distracting when you're trying to debug a kernel issue.

I normally, use "grep -v tracing_mark_write" but it would be nice
if I could just temporarily disable markers all together.

Link: http://lkml.kernel.org/r/1347066739-26285-1-git-send-email-msb@chromium.org

CC: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    6 +++++-
 kernel/trace/trace.h |    1 +
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 08acf42..1ec5c1d 100644
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
index 593debe..63a2da0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -680,6 +680,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_OVERWRITE		= 0x200000,
 	TRACE_ITER_STOP_ON_FREE		= 0x400000,
 	TRACE_ITER_IRQ_INFO		= 0x800000,
+	TRACE_ITER_MARKERS		= 0x1000000,
 };
 
 /*
