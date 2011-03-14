Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab1CNTST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:18:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47006 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab1CNTSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:18:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=r1gMB1WxxCMP/Is9gFv7Cz31QBSDxzoGl5e0kVJT5MdqrVL6Sa02VWShSXfsaNjEy3
         oluEmpJHxqxyJfJ4wRO0V/Tn88hmWHA9brnWp+FoVtzGrXuh4Ji5z/sJl/ibIln0KTlY
         JXwnVo7EVJxdipMuu3tOYbraJlEeaES7ot+Lk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [RFC PATCH 4/4] perf: New --enable-on-starter option
Date: Mon, 14 Mar 2011 20:18:03 +0100
Message-Id: <1300130283-10466-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new --enable-on-starter option can be used to perf record
and perf stat in order to get the event that precedes to be
started only once the starter fires. It won't count or sample
before.

starter/stopper events without --enable-on-starter must be
typically used to count everywhere but outside a pair of
events boundaries whereas the use of --enable-on-starter
should be rather used to count nowhere but inside the
pair of events boundaries.

Counting only outside softirqs:

	perf stat -e irq:softirq_exit -e irq:softirq_entry \
		-e instructions --starter 0 --stopper 1

Counting only inside softirqs:

	perf stat -e irq:softirq_entry -e irq:softirq_exit \
		-e instructions --starter 0 --stopper 1 --enable-on-starter

The following example shows a more complicated example, have three
instruction counters:

* One that counts instructions only when we hold the runqueue lock
* One that counts instructions only when we don't hold the
  runqueue lock.
* One that always count instructions

	./perf stat -e lock:lock_acquire --filter "name==\"&rq->lock\"" \
		-e lock:lock_release --filter "name==\"&rq->lock\"" \
		-e instructions --starter 0 --stopper 1 --enable-on-starter \
		-e instructions --starter 1 --stopper 0 -e instructions ./perf bench sched messaging

	# Running sched/messaging benchmark...
	# 20 sender and receiver processes per group
	# 10 groups == 400 processes run

	     Total time: 1.636 [sec]

	 Performance counter stats for './perf bench sched messaging':

	             2 274 lock:lock_acquire
	             2 234 lock:lock_release
	         9 601 767 instructions             #      0,000 IPC  <-- inside lock
	       482 273 822 instructions             #      0,000 IPC  <-- outside lock
	       490 646 837 instructions             #      0,000 IPC  <-- all

	        1,787294881  seconds time elapsed

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 tools/perf/builtin-record.c    |    2 ++
 tools/perf/builtin-stat.c      |    2 ++
 tools/perf/util/parse-events.c |   20 ++++++++++++++++++++
 tools/perf/util/parse-events.h |    1 +
 4 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7cc690e..272f0e4 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -745,6 +745,8 @@ const struct option record_options[] = {
 		     "event starter", parse_starter),
 	OPT_CALLBACK(0, "stopper", &evsel_list, "stopper",
 		     "event stopper", parse_stopper),
+	OPT_CALLBACK_NOOPT(0, "enable-on-starter", &evsel_list, "enable-on-starter",
+		     "enable-on-starter", parse_enable_on_starter),
 	OPT_INTEGER('p', "pid", &target_pid,
 		    "record events on existing process id"),
 	OPT_INTEGER('t', "tid", &target_tid,
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index ba89a4d..84f9e7f 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -658,6 +658,8 @@ static const struct option options[] = {
 		     "event starter", parse_starter),
 	OPT_CALLBACK(0, "stopper", &evsel_list, "stopper",
 		     "event stopper", parse_stopper),
+	OPT_CALLBACK_NOOPT(0, "enable-on-starter", &evsel_list, "enable-on-starter",
+			   "enable-on-starter", parse_enable_on_starter),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
 		    "child tasks do not inherit counters"),
 	OPT_INTEGER('p', "pid", &target_pid,
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 7dd494f..ce5cf10 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -845,6 +845,26 @@ int parse_filter(const struct option *opt, const char *str,
 	return 0;
 }
 
+int parse_enable_on_starter(const struct option *opt, const char __used *str,
+			    int unset __used)
+{
+	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
+	struct perf_evsel *last = NULL;
+
+	if (evlist->nr_entries > 0)
+		last = list_entry(evlist->entries.prev, struct perf_evsel, node);
+
+	if (last == NULL) {
+		fprintf(stderr,
+			"--enable-on-starter option should follow a -e tracepoint option\n");
+		return -1;
+	}
+
+	last->attr.enable_on_starter = 1;
+
+	return 0;
+}
+
 static int parse_starter_stopper(const struct option *opt,
 				 const char *str, int starter)
 {
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 72d73b5..262ebc8 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -27,6 +27,7 @@ extern int parse_events(const struct option *opt, const char *str, int unset);
 extern int parse_filter(const struct option *opt, const char *str, int unset);
 extern int parse_starter(const struct option *opt, const char *str, int unset);
 extern int parse_stopper(const struct option *opt, const char *str, int unset);
+extern int parse_enable_on_starter(const struct option *opt, const char *str, int unset);
 
 #define EVENTS_HELP_MAX (128*1024)
 
-- 
1.7.3.2

