Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab2ITWw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:52:58 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:54243 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab2ITWw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:52:56 -0400
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org
Cc: David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH v3 2/3] tracing: reset ring buffer when changing trace_clocks
Date: Thu, 20 Sep 2012 15:52:29 -0700
Message-Id: <1348181550-21931-2-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1348181550-21931-1-git-send-email-dhsharp@google.com>
References: <1348148044.13080.59.camel@gandalf.local.home>
 <1348181550-21931-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the "tsc" clock isn't in nanoseconds, the ring buffer must be
reset when changing clocks so that incomparable timestamps don't end up
in the same trace.

Tested: Confirmed switching clocks resets the trace buffer.

Google-Bug-Id: 6980623
Signed-off-by: David Sharp <dhsharp@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 kernel/trace/trace.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 92fb08e..4e26df3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4012,6 +4012,14 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
 	if (max_tr.buffer)
 		ring_buffer_set_clock(max_tr.buffer, trace_clocks[i].func);
 
+	/*
+	 * New clock may not be consistent with the previous clock.
+	 * Reset the buffer so that it doesn't have incomparable timestamps.
+	 */
+	tracing_reset_online_cpus(&global_trace);
+	if (max_tr.buffer)
+		tracing_reset_online_cpus(&max_tr);
+
 	mutex_unlock(&trace_types_lock);
 
 	*fpos += cnt;
-- 
1.7.7.3

