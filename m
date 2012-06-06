Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab2FFG5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 02:57:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35728 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2FFG5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 02:57:46 -0400
Date: Tue, 5 Jun 2012 23:57:27 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-4eysr236r0pgiyum9epwxw7s@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf stat:
  Initialize default events wrt exclude_{guest,host}
Git-Commit-ID: 79695e1bb65ba0e21488c360a1bed6e358354aaa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 05 Jun 2012 23:57:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79695e1bb65ba0e21488c360a1bed6e358354aaa
Gitweb:     http://git.kernel.org/tip/79695e1bb65ba0e21488c360a1bed6e358354aaa
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 30 May 2012 13:53:54 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 30 May 2012 14:02:38 -0300

perf stat: Initialize default events wrt exclude_{guest,host}

When no event is specified the tools use perf_evlist__add_default(), that will
call event_attr_init to initialize the KVM exclusion bits.

When the change was made to the tools so that by default guest samples would be
excluded, the changes were made just to the parsing routines and to
perf_evlist__add_default(), not to perf_evlist__add_attrs, that is used so far
just by perf stat to add multiple events, according to the level of detail
specified.

Recently the tools were changed to reconstruct the event name from all the
details in perf_event_attr, not just from .type and .config, but taking into
account all the feature bits (.exclude_{guest,host,user,kernel,etc},
.precise_ip, etc).

That is when we noticed that the default for perf stat wasn't the one for the
rest of the tools, i.e. the .exclude_guest bit wasn't being set.

I.e. the default, that doesn't call event_attr_init was showing the :HG
modifier:

  $ perf stat usleep 1

   Performance counter stats for 'usleep 1':

            0.942119 task-clock                #    0.454 CPUs utilized
                   1 context-switches          #    0.001 M/sec
                   0 CPU-migrations            #    0.000 K/sec
                 126 page-faults               #    0.134 M/sec
             693,193 cycles:HG                 #    0.736 GHz                     [40.11%]
             407,461 stalled-cycles-frontend:HG #   58.78% frontend cycles idle    [72.29%]
             365,403 stalled-cycles-backend:HG #   52.71% backend  cycles idle
             465,982 instructions:HG           #    0.67  insns per cycle
                                               #    0.87  stalled cycles per insn
              89,760 branches:HG               #   95.275 M/sec
               6,178 branch-misses:HG          #    6.88% of all branches

         0.002077228 seconds time elapsed

While if one explicitely specifies the same events, which will make the parsing code
to be called and thus event_attr_init is called:

  $ perf stat -e task-clock,context-switches,migrations,page-faults,cycles,stalled-cycles-frontend,stalled-cycles-backend,instructions,branches,branch-misses usleep 1

   Performance counter stats for 'usleep 1':

            1.040349 task-clock                #    0.500 CPUs utilized
                   2 context-switches          #    0.002 M/sec
                   0 CPU-migrations            #    0.000 K/sec
                 127 page-faults               #    0.122 M/sec
             587,966 cycles                    #    0.565 GHz                     [13.18%]
             459,167 stalled-cycles-frontend   #   78.09% frontend cycles idle
             390,249 stalled-cycles-backend    #   66.37% backend  cycles idle
             504,006 instructions              #    0.86  insns per cycle
                                               #    0.91  stalled cycles per insn
              96,455 branches                  #   92.714 M/sec
               6,522 branch-misses             #    6.76% of all branches         [96.12%]

         0.002078681 seconds time elapsed

Fix it by introducing a perf_evlist__add_default_attrs method that will call
evlist_attr_init in all the perf_event_attr entries before adding the events.

Reported-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-4eysr236r0pgiyum9epwxw7s@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |    8 ++++----
 tools/perf/util/evlist.c  |   11 +++++++++++
 tools/perf/util/evlist.h  |    4 ++++
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 62ae30d..2625899 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1129,7 +1129,7 @@ static int add_default_attributes(void)
 		return 0;
 
 	if (!evsel_list->nr_entries) {
-		if (perf_evlist__add_attrs_array(evsel_list, default_attrs) < 0)
+		if (perf_evlist__add_default_attrs(evsel_list, default_attrs) < 0)
 			return -1;
 	}
 
@@ -1139,21 +1139,21 @@ static int add_default_attributes(void)
 		return 0;
 
 	/* Append detailed run extra attributes: */
-	if (perf_evlist__add_attrs_array(evsel_list, detailed_attrs) < 0)
+	if (perf_evlist__add_default_attrs(evsel_list, detailed_attrs) < 0)
 		return -1;
 
 	if (detailed_run < 2)
 		return 0;
 
 	/* Append very detailed run extra attributes: */
-	if (perf_evlist__add_attrs_array(evsel_list, very_detailed_attrs) < 0)
+	if (perf_evlist__add_default_attrs(evsel_list, very_detailed_attrs) < 0)
 		return -1;
 
 	if (detailed_run < 3)
 		return 0;
 
 	/* Append very, very detailed run extra attributes: */
-	return perf_evlist__add_attrs_array(evsel_list, very_very_detailed_attrs);
+	return perf_evlist__add_default_attrs(evsel_list, very_very_detailed_attrs);
 }
 
 int cmd_stat(int argc, const char **argv, const char *prefix __used)
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 4ac5f5a..ed277e5 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -159,6 +159,17 @@ out_delete_partial_list:
 	return -1;
 }
 
+int __perf_evlist__add_default_attrs(struct perf_evlist *evlist,
+				     struct perf_event_attr *attrs, size_t nr_attrs)
+{
+	size_t i;
+
+	for (i = 0; i < nr_attrs; i++)
+		event_attr_init(attrs + i);
+
+	return perf_evlist__add_attrs(evlist, attrs, nr_attrs);
+}
+
 static int trace_event__id(const char *evname)
 {
 	char *filename, *colon;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 58abb63..989bee9 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -54,6 +54,8 @@ void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry);
 int perf_evlist__add_default(struct perf_evlist *evlist);
 int perf_evlist__add_attrs(struct perf_evlist *evlist,
 			   struct perf_event_attr *attrs, size_t nr_attrs);
+int __perf_evlist__add_default_attrs(struct perf_evlist *evlist,
+				     struct perf_event_attr *attrs, size_t nr_attrs);
 int perf_evlist__add_tracepoints(struct perf_evlist *evlist,
 				 const char *tracepoints[], size_t nr_tracepoints);
 int perf_evlist__set_tracepoints_handlers(struct perf_evlist *evlist,
@@ -62,6 +64,8 @@ int perf_evlist__set_tracepoints_handlers(struct perf_evlist *evlist,
 
 #define perf_evlist__add_attrs_array(evlist, array) \
 	perf_evlist__add_attrs(evlist, array, ARRAY_SIZE(array))
+#define perf_evlist__add_default_attrs(evlist, array) \
+	__perf_evlist__add_default_attrs(evlist, array, ARRAY_SIZE(array))
 
 #define perf_evlist__add_tracepoints_array(evlist, array) \
 	perf_evlist__add_tracepoints(evlist, array, ARRAY_SIZE(array))
