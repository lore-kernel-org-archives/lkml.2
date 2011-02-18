Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab1BROwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 09:52:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab1BROwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 09:52:37 -0500
Date: Fri, 18 Feb 2011 15:52:19 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu
Subject: [PATCHv2] trace: adding unstable sched clock note to the warning
Message-ID: <20110218145219.GD2604@jolsa.brq.redhat.com>
References: <1296649698-6003-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296649698-6003-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

warning "Delta way too big" warning might appear on a system with
unstable shed clock right after the system is resumed and tracing
was enabled during the suspend.

Since it's not realy bug, and the unstable sched clock is working
fast and reliable otherwise, Steven suggested to keep using the
sched clock in any case and just to make note in the warning itself.

v2 changes:
- added CONFIG_HAVE_UNSTABLE_SCHED_CLOCK dependency

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/ring_buffer.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index bd1c35a..37c4d3e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2162,11 +2162,19 @@ rb_reserve_next_event(struct ring_buffer *buffer,
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
1.7.1
