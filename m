Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab1BJSv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:51:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47573 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab1BJSv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:51:56 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jeff Moyer <jmoyer@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/1] perf tools: Fix thread_map event synthesizing in top and record
Date: Thu, 10 Feb 2011 16:51:39 -0200
Message-Id: <1297363899-21466-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297363899-21466-1-git-send-email-acme@infradead.org>
References: <1297363899-21466-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Jeff Moyer reported these messages:

  Warning:  ... trying to fall back to cpu-clock-ticks

couldn't open /proc/-1/status
couldn't open /proc/-1/maps
[ls output]
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.008 MB perf.data (~363 samples) ]

That lead me and David Ahern to see that something was fishy on the thread
synthesizing routines, at least for the case where the workload is started
from 'perf record', as -1 is the default for target_tid in 'perf record --tid'
parameter, so somehow we were trying to synthesize the PERF_RECORD_MMAP and
PERF_RECORD_COMM events for the thread -1, a bug.

So I investigated this and noticed that when we introduced support for
recording a process and its threads using --pid some bugs were introduced and
that the way to fix it was to instead of passing the target_tid to the event
synthesizing routines we should better pass the thread_map that has the list of
threads for a --pid or just the single thread for a --tid.

Checked in the following ways:

On a 8-way machine run cyclictest:

[root@emilia ~]# perf record cyclictest -a -t -n -p99 -i100 -d50
policy: fifo: loadavg: 0.00 0.13 0.31 2/139 28798

T: 0 (28791) P:99 I:100 C:  25072 Min:      4 Act:    5 Avg:    6 Max:     122
T: 1 (28792) P:98 I:150 C:  16715 Min:      4 Act:    6 Avg:    5 Max:      27
T: 2 (28793) P:97 I:200 C:  12534 Min:      4 Act:    5 Avg:    4 Max:       8
T: 3 (28794) P:96 I:250 C:  10028 Min:      4 Act:    5 Avg:    5 Max:      96
T: 4 (28795) P:95 I:300 C:   8357 Min:      5 Act:    6 Avg:    5 Max:      12
T: 5 (28796) P:94 I:350 C:   7163 Min:      5 Act:    6 Avg:    5 Max:      12
T: 6 (28797) P:93 I:400 C:   6267 Min:      4 Act:    5 Avg:    5 Max:       9
T: 7 (28798) P:92 I:450 C:   5571 Min:      4 Act:    5 Avg:    5 Max:       9
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.108 MB perf.data (~4719 samples) ]

[root@emilia ~]#

This will create one extra thread per CPU:

[root@emilia ~]# tuna -t cyclictest -CP
                      thread       ctxt_switches
    pid SCHED_ rtpri affinity voluntary nonvoluntary             cmd
 28825   OTHER     0     0xff      2169          671      cyclictest
  28832   FIFO    93        6     52338            1      cyclictest
  28833   FIFO    92        7     46524            1      cyclictest
  28826   FIFO    99        0    209360            1      cyclictest
  28827   FIFO    98        1    139577            1      cyclictest
  28828   FIFO    97        2    104686            0      cyclictest
  28829   FIFO    96        3     83751            1      cyclictest
  28830   FIFO    95        4     69794            1      cyclictest
  28831   FIFO    94        5     59825            1      cyclictest
[root@emilia ~]#

So we should expect only samples for the above 9 threads when using the
--dump-raw-trace|-D perf report switch to look at the column with the tid:

[root@emilia ~]# perf report -D | grep RECORD_SAMPLE | cut -d/ -f2 | cut -d: -f1 | sort | uniq -c
    629 28825
    110 28826
    491 28827
    308 28828
    198 28829
    621 28830
    225 28831
    203 28832
     89 28833
[root@emilia ~]#

So for workloads started by 'perf record' seems to work, now for existing workloads,
just run cyclictest first, without 'perf record':

[root@emilia ~]# tuna -t cyclictest -CP
                      thread       ctxt_switches
    pid SCHED_ rtpri affinity voluntary nonvoluntary             cmd
 28859   OTHER     0     0xff       594          200      cyclictest
  28864   FIFO    95        4     16587            1      cyclictest
  28865   FIFO    94        5     14219            1      cyclictest
  28866   FIFO    93        6     12443            0      cyclictest
  28867   FIFO    92        7     11062            1      cyclictest
  28860   FIFO    99        0     49779            1      cyclictest
  28861   FIFO    98        1     33190            1      cyclictest
  28862   FIFO    97        2     24895            1      cyclictest
  28863   FIFO    96        3     19918            1      cyclictest
[root@emilia ~]#

and then later did:

[root@emilia ~]# perf record --pid 28859 sleep 3
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.027 MB perf.data (~1195 samples) ]
[root@emilia ~]#

To collect 3 seconds worth of samples for pid 28859 and its children:

[root@emilia ~]# perf report -D | grep RECORD_SAMPLE | cut -d/ -f2 | cut -d: -f1 | sort | uniq -c
     15 28859
     33 28860
     19 28861
     13 28862
     13 28863
     10 28864
     11 28865
      9 28866
    255 28867
[root@emilia ~]#

Works, last thing is to check if looking at just one of those threads also works:

[root@emilia ~]# perf record --tid 28866 sleep 3
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.006 MB perf.data (~242 samples) ]
[root@emilia ~]# perf report -D | grep RECORD_SAMPLE | cut -d/ -f2 | cut -d: -f1 | sort | uniq -c
      3 28866
[root@emilia ~]#

Works too.

Reported-by: Jeff Moyer <jmoyer@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    4 ++--
 tools/perf/builtin-top.c    |    2 +-
 tools/perf/util/event.c     |   18 +++++++++++++-----
 tools/perf/util/event.h     |    6 ++++--
 4 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b2f729f..60cac6f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -759,8 +759,8 @@ static int __cmd_record(int argc, const char **argv)
 		perf_session__process_machines(session, event__synthesize_guest_os);
 
 	if (!system_wide)
-		event__synthesize_thread(target_tid, process_synthesized_event,
-					 session);
+		event__synthesize_thread_map(threads, process_synthesized_event,
+					     session);
 	else
 		event__synthesize_threads(process_synthesized_event, session);
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b6998e0..5a29d9c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1306,7 +1306,7 @@ static int __cmd_top(void)
 		return -ENOMEM;
 
 	if (target_tid != -1)
-		event__synthesize_thread(target_tid, event__process, session);
+		event__synthesize_thread_map(threads, event__process, session);
 	else
 		event__synthesize_threads(event__process, session);
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 1478ab4..50d0a93 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -263,11 +263,12 @@ static int __event__synthesize_thread(event_t *comm_event, event_t *mmap_event,
 					     process, session);
 }
 
-int event__synthesize_thread(pid_t pid, event__handler_t process,
-			     struct perf_session *session)
+int event__synthesize_thread_map(struct thread_map *threads,
+				 event__handler_t process,
+				 struct perf_session *session)
 {
 	event_t *comm_event, *mmap_event;
-	int err = -1;
+	int err = -1, thread;
 
 	comm_event = malloc(sizeof(comm_event->comm) + session->id_hdr_size);
 	if (comm_event == NULL)
@@ -277,8 +278,15 @@ int event__synthesize_thread(pid_t pid, event__handler_t process,
 	if (mmap_event == NULL)
 		goto out_free_comm;
 
-	err = __event__synthesize_thread(comm_event, mmap_event, pid,
-					 process, session);
+	err = 0;
+	for (thread = 0; thread < threads->nr; ++thread) {
+		if (__event__synthesize_thread(comm_event, mmap_event,
+					       threads->map[thread],
+					       process, session)) {
+			err = -1;
+			break;
+		}
+	}
 	free(mmap_event);
 out_free_comm:
 	free(comm_event);
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 2b7e919..cc7b52f 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -135,14 +135,16 @@ typedef union event_union {
 void event__print_totals(void);
 
 struct perf_session;
+struct thread_map;
 
 typedef int (*event__handler_synth_t)(event_t *event, 
 				      struct perf_session *session);
 typedef int (*event__handler_t)(event_t *event, struct sample_data *sample,
 				struct perf_session *session);
 
-int event__synthesize_thread(pid_t pid, event__handler_t process,
-			     struct perf_session *session);
+int event__synthesize_thread_map(struct thread_map *threads,
+				 event__handler_t process,
+				 struct perf_session *session);
 int event__synthesize_threads(event__handler_t process,
 			      struct perf_session *session);
 int event__synthesize_kernel_mmap(event__handler_t process,
-- 
1.6.2.5

