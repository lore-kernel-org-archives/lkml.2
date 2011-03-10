Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab1CJQAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:00:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41186 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab1CJP7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:59:14 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=wZezGcEurugA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=JIAjFgqsX2v0nRl9AKkA:9 a=cfCPEVovJ5Dxy63spN7ydoWom4gA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110310155912.029198359@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Mar 2011 10:58:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 12/15] tracing: Explain about unstable clock on resume with ring buffer warning
References: <20110310155800.478792851@goodmis.org>
Content-Disposition: inline; filename=0012-tracing-Explain-about-unstable-clock-on-resume-with-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

The "Delta way too big" warning might appear on a system with a
unstable shed clock right after the system is resumed and tracing
was enabled at time of suspend.

Since it's not realy a bug, and the unstable sched clock is working
fast and reliable otherwise, Steven suggested to keep using the
sched clock in any case and just to make note in the warning itself.

v2 changes:
- added #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <20110218145219.GD2604@jolsa.brq.redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 3237d96..db7b439 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2172,11 +2172,19 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 	if (likely(ts >= cpu_buffer->write_stamp)) {
 		delta = diff;
 		if (unlikely(test_time_stamp(delta))) {
+			int local_clock_stable = 1;
+#ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
+			local_clock_stable = sched_clock_stable;
+#endif
 			WARN_ONCE(delta > (1ULL << 59),
-				  KERN_WARNING "Delta way too big! %llu ts=%llu write stamp = %llu\n",
+				  KERN_WARNING "Delta way too big! %llu ts=%llu write stamp = %llu\n%s",
 				  (unsigned long long)delta,
 				  (unsigned long long)ts,
-				  (unsigned long long)cpu_buffer->write_stamp);
+				  (unsigned long long)cpu_buffer->write_stamp,
+				  local_clock_stable ? "" :
+				  "If you just came from a suspend/resume,\n"
+				  "please switch to the trace global clock:\n"
+				  "  echo global > /sys/kernel/debug/tracing/trace_clock\n");
 			add_timestamp = 1;
 		}
 	}
-- 
1.7.2.3


