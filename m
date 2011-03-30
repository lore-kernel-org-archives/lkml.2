Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab1C3HRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 03:17:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:47669 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1C3HRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 03:17:12 -0400
Date: Wed, 30 Mar 2011 07:16:53 GMT
From: tip-bot for David Ahern <daahern@cisco.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, daahern@cisco.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, tglx@linutronix.de, daahern@cisco.com,
        mingo@elte.hu
In-Reply-To: <1301080271-20945-1-git-send-email-daahern@cisco.com>
References: <1301080271-20945-1-git-send-email-daahern@cisco.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Emit clearer message for sys_perf_event_open ENOENT return
Message-ID: <tip-ca6a42586fae639ff9e5285d9bdc550fcb1b8d41@git.kernel.org>
Git-Commit-ID: ca6a42586fae639ff9e5285d9bdc550fcb1b8d41
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 30 Mar 2011 07:16:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca6a42586fae639ff9e5285d9bdc550fcb1b8d41
Gitweb:     http://git.kernel.org/tip/ca6a42586fae639ff9e5285d9bdc550fcb1b8d41
Author:     David Ahern <daahern@cisco.com>
AuthorDate: Fri, 25 Mar 2011 13:11:11 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 29 Mar 2011 13:40:27 -0300

perf tools: Emit clearer message for sys_perf_event_open ENOENT return

Resend of patch sent back in January 2011 in light of recent confusion around
unsupported events for a given platform.

Improve sys_perf_event_open ENOENT return handling in top and record, just
like 5a3446b does for stat.

Retry of Arnaldo's patch using ui_warning instead of die which allows the
fallback from hardware cycles to software clock.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
LKML-Reference: <1301080271-20945-1-git-send-email-daahern@cisco.com>
Signed-off-by: David Ahern <daahern@cisco.com>
[ committer note: Some adjustments to make it apply to newer codebase ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   10 +++++++++-
 tools/perf/builtin-top.c    |    6 ++++++
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 623695e..db6adec 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -301,11 +301,19 @@ try_again:
 					&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
 
 				if (verbose)
-					warning(" ... trying to fall back to cpu-clock-ticks\n");
+					ui__warning("The cycles event is not supported, "
+						    "trying to fall back to cpu-clock-ticks\n");
 				attr->type = PERF_TYPE_SOFTWARE;
 				attr->config = PERF_COUNT_SW_CPU_CLOCK;
 				goto try_again;
 			}
+
+			if (err == ENOENT) {
+				ui__warning("The %s event is not supported.\n",
+					    event_name(pos));
+				exit(EXIT_FAILURE);
+			}
+
 			printf("\n");
 			error("sys_perf_event_open() syscall returned with %d (%s).  /bin/dmesg may provide additional information.\n",
 			      err, strerror(err));
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 935fc4f..fc1273e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -870,6 +870,12 @@ try_again:
 				goto try_again;
 			}
 
+			if (err == ENOENT) {
+				ui__warning("The %s event is not supported.\n",
+					    event_name(counter));
+				goto out_err;
+			}
+
 			ui__warning("The sys_perf_event_open() syscall "
 				    "returned with %d (%s).  /bin/dmesg "
 				    "may provide additional information.\n"
