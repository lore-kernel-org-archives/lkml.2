Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196Ab2KFAsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 19:48:10 -0500
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53894 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295Ab2KFAsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 19:48:07 -0500
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org
Cc: David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH v8 2/5] tracing: Reset ring buffer when changing trace_clocks
Date: Mon,  5 Nov 2012 16:47:48 -0800
Message-Id: <1352162868-11347-1-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1351864814.4004.133.camel@gandalf.local.home>
References: <1351864814.4004.133.camel@gandalf.local.home>
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
index 9aed7f5..84aa489 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4017,6 +4017,14 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
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

