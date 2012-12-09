Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab2LIL2A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 06:28:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56226 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758522Ab2LIL16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 06:27:58 -0500
Date: Sun, 9 Dec 2012 03:27:37 -0800
From: tip-bot for Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Message-ID: <tip-11043d8b125671a32253cddb0b05177be0e976f6@git.kernel.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, fweisbec@gmail.com, yoshihiro.yunomae.ez@hitachi.com,
        rostedt@goodmis.org, dhsharp@google.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, yoshihiro.yunomae.ez@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dhsharp@google.com, tglx@linutronix.de
In-Reply-To: <1352837903-32191-3-git-send-email-dhsharp@google.com>
References: <1352837903-32191-3-git-send-email-dhsharp@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing:
  Show raw time stamp on stats per cpu using counter or tsc mode for trace_clock
Git-Commit-ID: 11043d8b125671a32253cddb0b05177be0e976f6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 09 Dec 2012 03:27:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11043d8b125671a32253cddb0b05177be0e976f6
Gitweb:     http://git.kernel.org/tip/11043d8b125671a32253cddb0b05177be0e976f6
Author:     Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
AuthorDate: Tue, 13 Nov 2012 12:18:23 -0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 13 Nov 2012 15:49:11 -0500

tracing: Show raw time stamp on stats per cpu using counter or tsc mode for trace_clock

Show raw time stamp values for stats per cpu if you choose counter or tsc mode
for trace_clock. Although a unit of tracing time stamp is nsec in local or global mode,
the units in counter and TSC mode are tracing counter and cycles respectively.
Link: http://lkml.kernel.org/r/1352837903-32191-3-git-send-email-dhsharp@google.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Signed-off-by: David Sharp <dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d943e69..b69cc38 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4388,13 +4388,24 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	cnt = ring_buffer_bytes_cpu(tr->buffer, cpu);
 	trace_seq_printf(s, "bytes: %ld\n", cnt);
 
-	t = ns2usecs(ring_buffer_oldest_event_ts(tr->buffer, cpu));
-	usec_rem = do_div(t, USEC_PER_SEC);
-	trace_seq_printf(s, "oldest event ts: %5llu.%06lu\n", t, usec_rem);
+	if (trace_clocks[trace_clock_id].in_ns) {
+		/* local or global for trace_clock */
+		t = ns2usecs(ring_buffer_oldest_event_ts(tr->buffer, cpu));
+		usec_rem = do_div(t, USEC_PER_SEC);
+		trace_seq_printf(s, "oldest event ts: %5llu.%06lu\n",
+								t, usec_rem);
+
+		t = ns2usecs(ring_buffer_time_stamp(tr->buffer, cpu));
+		usec_rem = do_div(t, USEC_PER_SEC);
+		trace_seq_printf(s, "now ts: %5llu.%06lu\n", t, usec_rem);
+	} else {
+		/* counter or tsc mode for trace_clock */
+		trace_seq_printf(s, "oldest event ts: %llu\n",
+				ring_buffer_oldest_event_ts(tr->buffer, cpu));
 
-	t = ns2usecs(ring_buffer_time_stamp(tr->buffer, cpu));
-	usec_rem = do_div(t, USEC_PER_SEC);
-	trace_seq_printf(s, "now ts: %5llu.%06lu\n", t, usec_rem);
+		trace_seq_printf(s, "now ts: %llu\n",
+				ring_buffer_time_stamp(tr->buffer, cpu));
+	}
 
 	cnt = ring_buffer_dropped_events_cpu(tr->buffer, cpu);
 	trace_seq_printf(s, "dropped events: %ld\n", cnt);
