Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1CKJwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:52:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:38619 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab1CKJwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:52:00 -0500
Date: Fri, 11 Mar 2011 09:51:44 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <20110218145219.GD2604@jolsa.brq.redhat.com>
References: <20110218145219.GD2604@jolsa.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Explain about unstable clock on resume with ring buffer warning
Message-ID: <tip-31274d72f01604f4b02d933b4f3cac84d2c201fd@git.kernel.org>
Git-Commit-ID: 31274d72f01604f4b02d933b4f3cac84d2c201fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Mar 2011 09:51:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  31274d72f01604f4b02d933b4f3cac84d2c201fd
Gitweb:     http://git.kernel.org/tip/31274d72f01604f4b02d933b4f3cac84d2c201fd
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 18 Feb 2011 15:52:19 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 10 Mar 2011 10:34:47 -0500

tracing: Explain about unstable clock on resume with ring buffer warning

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
