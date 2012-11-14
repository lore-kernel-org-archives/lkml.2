Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab2KNHDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:03:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43587 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab2KNHDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:03:07 -0500
Date: Tue, 13 Nov 2012 23:02:52 -0800
From: tip-bot for David Sharp <dhsharp@google.com>
Message-ID: <tip-60303ed3f4b9332b9aa9bc17c68bc174e7343e2d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        dhsharp@google.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        dhsharp@google.com, tglx@linutronix.de
In-Reply-To: <1349998076-15495-3-git-send-email-dhsharp@google.com>
References: <1349998076-15495-3-git-send-email-dhsharp@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing:
  Reset ring buffer when changing trace_clocks
Git-Commit-ID: 60303ed3f4b9332b9aa9bc17c68bc174e7343e2d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:02:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60303ed3f4b9332b9aa9bc17c68bc174e7343e2d
Gitweb:     http://git.kernel.org/tip/60303ed3f4b9332b9aa9bc17c68bc174e7343e2d
Author:     David Sharp <dhsharp@google.com>
AuthorDate: Thu, 11 Oct 2012 16:27:52 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 2 Nov 2012 10:21:47 -0400

tracing: Reset ring buffer when changing trace_clocks

Because the "tsc" clock isn't in nanoseconds, the ring buffer must be
reset when changing clocks so that incomparable timestamps don't end up
in the same trace.

Tested: Confirmed switching clocks resets the trace buffer.

Google-Bug-Id: 6980623
Link: http://lkml.kernel.org/r/1349998076-15495-3-git-send-email-dhsharp@google.com

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: David Sharp <dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 88111b0..6ed6013 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4073,6 +4073,14 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
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
