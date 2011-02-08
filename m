Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab1BHWRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:17:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43765 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab1BHWRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:17:21 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=0nNWrt12pMMA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=7ZQwqa3CbsZe9ahqxigA:9 a=KDKU3mU6SBf8FTlU5Yk9qCSajpwA:4 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208221720.339784840@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Feb 2011 17:16:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 06/10] tracing: Add unstable sched clock note to the warning
References: <20110208221612.084294240@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Add-unstable-sched-clock-note-to-the-warning.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

The warning "Delta way too big" warning might appear on a system with
unstable shed clock right after the system is resumed and tracing
was enabled during the suspend.

Since it's not realy bug, and the unstable sched clock is working
fast and reliable otherwise, Steven suggested to keep using the
sched clock in any case and just to make note in the warning itself.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <1296649698-6003-1-git-send-email-jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index bd1c35a..7739893 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2163,10 +2163,14 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 		delta = diff;
 		if (unlikely(test_time_stamp(delta))) {
 			WARN_ONCE(delta > (1ULL << 59),
-				  KERN_WARNING "Delta way too big! %llu ts=%llu write stamp = %llu\n",
+				  KERN_WARNING "Delta way too big! %llu ts=%llu write stamp = %llu\n%s",
 				  (unsigned long long)delta,
 				  (unsigned long long)ts,
-				  (unsigned long long)cpu_buffer->write_stamp);
+				  (unsigned long long)cpu_buffer->write_stamp,
+				  sched_clock_stable ? "" :
+				  "If you just came from a suspend/resume,\n"
+				  "please switch to the trace global clock:\n"
+				  "  echo global > /sys/kernel/debug/tracing/trace_clock\n");
 			add_timestamp = 1;
 		}
 	}
-- 
1.7.2.3


