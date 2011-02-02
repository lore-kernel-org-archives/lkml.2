Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1BBM20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 07:28:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab1BBM2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 07:28:25 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] trace: adding unstable sched clock note to the warning
Date: Wed,  2 Feb 2011 13:28:18 +0100
Message-Id: <1296649698-6003-1-git-send-email-jolsa@redhat.com>
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

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
