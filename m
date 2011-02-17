Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab1BQPA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:00:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:37971 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab1BQPA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:00:57 -0500
Date: Thu, 17 Feb 2011 15:00:43 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1296649698-6003-1-git-send-email-jolsa@redhat.com>
References: <1296649698-6003-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Add unstable sched clock note to the warning
Message-ID: <tip-5e38ca8f3ea423442eaafe1b7e206084aa38120a@git.kernel.org>
Git-Commit-ID: 5e38ca8f3ea423442eaafe1b7e206084aa38120a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Feb 2011 15:00:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e38ca8f3ea423442eaafe1b7e206084aa38120a
Gitweb:     http://git.kernel.org/tip/5e38ca8f3ea423442eaafe1b7e206084aa38120a
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 2 Feb 2011 13:28:18 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 8 Feb 2011 11:57:22 -0500

tracing: Add unstable sched clock note to the warning

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
