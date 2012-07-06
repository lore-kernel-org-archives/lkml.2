Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab2GFLDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:03:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51625 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab2GFLDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:03:52 -0400
Date: Fri, 6 Jul 2012 04:03:32 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-76a8349dfdb775d387e9767db3092e410403138a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, peterz@infradead.org, dsahern@gmail.com,
        tglx@linutronix.de, namhyung@gmail.com
In-Reply-To: <1339698977-68962-1-git-send-email-dsahern@gmail.com>
References: <1339698977-68962-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf script:
  Fix format regression due to libtraceevent merge
Git-Commit-ID: 76a8349dfdb775d387e9767db3092e410403138a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:03:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  76a8349dfdb775d387e9767db3092e410403138a
Gitweb:     http://git.kernel.org/tip/76a8349dfdb775d387e9767db3092e410403138a
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Thu, 14 Jun 2012 12:36:17 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 2 Jul 2012 11:08:11 -0300

perf script: Fix format regression due to libtraceevent merge

Consider the commands:
    perf record -e sched:sched_switch -fo /tmp/perf.data  -a -- sleep 1
    perf script -i /tmp/perf.data

In v3.4 the output has the form (lines wrapped here)
    perf 29214 [005] 821043.582596: sched_switch:
prev_comm=perf prev_pid=29214 prev_prio=120
prev_state=S ==> next_comm=swapper/5 next_pid=0 next_prio=120

In 3.5 that same line has become:
    perf 29214 [005] 821043.582596: sched_switch:
<...>-29214 [005]     0.000000000: sched_switch:
prev_comm=perf prev_pid=29214 prev_prio=120
prev_state=S ==> next_comm=swapper/5 next_pid=0 next_prio=120

Note the duplicates in the output -- pid, cpu, event name. With
this patch the v3.4 output is restored:
    perf 29214 [005] 821043.582596: sched_switch:
prev_comm=perf prev_pid=29214 prev_prio=120
prev_state=S ==> next_comm=swapper/5 next_pid=0 next_prio=120

v3:
Remove that pesky newline too. Output now matches v3.4 (pre-libtracevent).

v2:
Change print_trace_event function local to perf per Steve's comments.

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1339698977-68962-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-parse.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index df2fddb..5dd3b5e 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -198,9 +198,8 @@ void print_trace_event(int cpu, void *data, int size)
 	record.data = data;
 
 	trace_seq_init(&s);
-	pevent_print_event(pevent, &s, &record);
+	pevent_event_info(&s, event, &record);
 	trace_seq_do_printf(&s);
-	printf("\n");
 }
 
 void print_event(int cpu, void *data, int size, unsigned long long nsecs,
