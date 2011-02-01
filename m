Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab1BAJVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 04:21:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:45522 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab1BAJVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 04:21:35 -0500
Date: Tue, 1 Feb 2011 09:21:09 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf python: Fix build on 32-bit
Message-ID: <tip-f6bbc1daac964da551130dbf01809d3fbd178b2d@git.kernel.org>
Git-Commit-ID: f6bbc1daac964da551130dbf01809d3fbd178b2d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 01 Feb 2011 09:21:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6bbc1daac964da551130dbf01809d3fbd178b2d
Gitweb:     http://git.kernel.org/tip/f6bbc1daac964da551130dbf01809d3fbd178b2d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 31 Jan 2011 20:56:27 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 31 Jan 2011 20:56:27 -0200

perf python: Fix build on 32-bit

Where there are lots of errors related to python methods receiving
'char *' for things like file open mode, which break the build, also
disable strict aliasing and fixup some other warnings. Now builds on
both 32-bit and 64-bit fedora systems.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/python.c |   52 +++++++++++++++++++++++-----------------------
 tools/perf/util/setup.py |    3 +-
 2 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index d2d5217..5317ef2 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -15,6 +15,8 @@ struct throttle_event {
 	u64			 stream_id;
 };
 
+PyMODINIT_FUNC initperf(void);
+
 #define member_def(type, member, ptype, help) \
 	{ #member, ptype, \
 	  offsetof(struct pyrf_event, event) + offsetof(struct type, member), \
@@ -31,17 +33,15 @@ struct pyrf_event {
 	union perf_event   event;
 };
 
-#define T_ULONG_LONG T_ULONG
-
 #define sample_members \
-	sample_member_def(sample_ip, ip, T_ULONG_LONG, "event type"),			 \
+	sample_member_def(sample_ip, ip, T_ULONGLONG, "event type"),			 \
 	sample_member_def(sample_pid, pid, T_INT, "event pid"),			 \
 	sample_member_def(sample_tid, tid, T_INT, "event tid"),			 \
-	sample_member_def(sample_time, time, T_ULONG_LONG, "event timestamp"),		 \
-	sample_member_def(sample_addr, addr, T_ULONG_LONG, "event addr"),		 \
-	sample_member_def(sample_id, id, T_ULONG_LONG, "event id"),			 \
-	sample_member_def(sample_stream_id, stream_id, T_ULONG_LONG, "event stream id"), \
-	sample_member_def(sample_period, period, T_ULONG_LONG, "event period"),		 \
+	sample_member_def(sample_time, time, T_ULONGLONG, "event timestamp"),		 \
+	sample_member_def(sample_addr, addr, T_ULONGLONG, "event addr"),		 \
+	sample_member_def(sample_id, id, T_ULONGLONG, "event id"),			 \
+	sample_member_def(sample_stream_id, stream_id, T_ULONGLONG, "event stream id"), \
+	sample_member_def(sample_period, period, T_ULONGLONG, "event period"),		 \
 	sample_member_def(sample_cpu, cpu, T_UINT, "event cpu"),
 
 static char pyrf_mmap_event__doc[] = PyDoc_STR("perf mmap event object.");
@@ -51,11 +51,11 @@ static PyMemberDef pyrf_mmap_event__members[] = {
 	member_def(perf_event_header, type, T_UINT, "event type"),
 	member_def(mmap_event, pid, T_UINT, "event pid"),
 	member_def(mmap_event, tid, T_UINT, "event tid"),
-	member_def(mmap_event, start, T_ULONG_LONG, "start of the map"),
-	member_def(mmap_event, len, T_ULONG_LONG, "map length"),
-	member_def(mmap_event, pgoff, T_ULONG_LONG, "page offset"),
+	member_def(mmap_event, start, T_ULONGLONG, "start of the map"),
+	member_def(mmap_event, len, T_ULONGLONG, "map length"),
+	member_def(mmap_event, pgoff, T_ULONGLONG, "page offset"),
 	member_def(mmap_event, filename, T_STRING_INPLACE, "backing store"),
-	{ NULL, },
+	{ .name = NULL, },
 };
 
 static PyObject *pyrf_mmap_event__repr(struct pyrf_event *pevent)
@@ -96,8 +96,8 @@ static PyMemberDef pyrf_task_event__members[] = {
 	member_def(fork_event, ppid, T_UINT, "event ppid"),
 	member_def(fork_event, tid, T_UINT, "event tid"),
 	member_def(fork_event, ptid, T_UINT, "event ptid"),
-	member_def(fork_event, time, T_ULONG_LONG, "timestamp"),
-	{ NULL, },
+	member_def(fork_event, time, T_ULONGLONG, "timestamp"),
+	{ .name = NULL, },
 };
 
 static PyObject *pyrf_task_event__repr(struct pyrf_event *pevent)
@@ -130,7 +130,7 @@ static PyMemberDef pyrf_comm_event__members[] = {
 	member_def(comm_event, pid, T_UINT, "event pid"),
 	member_def(comm_event, tid, T_UINT, "event tid"),
 	member_def(comm_event, comm, T_STRING_INPLACE, "process name"),
-	{ NULL, },
+	{ .name = NULL, },
 };
 
 static PyObject *pyrf_comm_event__repr(struct pyrf_event *pevent)
@@ -156,10 +156,10 @@ static char pyrf_throttle_event__doc[] = PyDoc_STR("perf throttle event object."
 static PyMemberDef pyrf_throttle_event__members[] = {
 	sample_members
 	member_def(perf_event_header, type, T_UINT, "event type"),
-	member_def(throttle_event, time, T_ULONG_LONG, "timestamp"),
-	member_def(throttle_event, id, T_ULONG_LONG, "event id"),
-	member_def(throttle_event, stream_id, T_ULONG_LONG, "event stream id"),
-	{ NULL, },
+	member_def(throttle_event, time, T_ULONGLONG, "timestamp"),
+	member_def(throttle_event, id, T_ULONGLONG, "event id"),
+	member_def(throttle_event, stream_id, T_ULONGLONG, "event stream id"),
+	{ .name = NULL, },
 };
 
 static PyObject *pyrf_throttle_event__repr(struct pyrf_event *pevent)
@@ -522,7 +522,7 @@ static PyMethodDef pyrf_evsel__methods[] = {
 		.ml_flags = METH_VARARGS | METH_KEYWORDS,
 		.ml_doc	  = PyDoc_STR("open the event selector file descriptor table.")
 	},
-	{ NULL, }
+	{ .ml_name = NULL, }
 };
 
 static char pyrf_evsel__doc[] = PyDoc_STR("perf event selector list object.");
@@ -551,7 +551,7 @@ struct pyrf_evlist {
 };
 
 static int pyrf_evlist__init(struct pyrf_evlist *pevlist,
-			     PyObject *args, PyObject *kwargs)
+			     PyObject *args, PyObject *kwargs __used)
 {
 	PyObject *pcpus = NULL, *pthreads = NULL;
 	struct cpu_map *cpus;
@@ -613,7 +613,7 @@ static PyObject *pyrf_evlist__poll(struct pyrf_evlist *pevlist,
 }
 
 static PyObject *pyrf_evlist__get_pollfd(struct pyrf_evlist *pevlist,
-					 PyObject *args, PyObject *kwargs)
+					 PyObject *args __used, PyObject *kwargs __used)
 {
 	struct perf_evlist *evlist = &pevlist->evlist;
         PyObject *list = PyList_New(0);
@@ -645,7 +645,7 @@ free_list:
 
 
 static PyObject *pyrf_evlist__add(struct pyrf_evlist *pevlist,
-				  PyObject *args, PyObject *kwargs)
+				  PyObject *args, PyObject *kwargs __used)
 {
 	struct perf_evlist *evlist = &pevlist->evlist;
 	PyObject *pevsel;
@@ -724,7 +724,7 @@ static PyMethodDef pyrf_evlist__methods[] = {
 		.ml_flags = METH_VARARGS | METH_KEYWORDS,
 		.ml_doc	  = PyDoc_STR("reads an event.")
 	},
-	{ NULL, }
+	{ .ml_name = NULL, }
 };
 
 static Py_ssize_t pyrf_evlist__length(PyObject *obj)
@@ -840,11 +840,11 @@ static struct {
 	{ "RECORD_FORK",       PERF_RECORD_FORK },
 	{ "RECORD_READ",       PERF_RECORD_READ },
 	{ "RECORD_SAMPLE",     PERF_RECORD_SAMPLE },
-	{ NULL, },
+	{ .name = NULL, },
 };
 
 static PyMethodDef perf__methods[] = {
-	{ NULL, NULL }
+	{ .ml_name = NULL, }
 };
 
 PyMODINIT_FUNC initperf(void)
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 496d7f4..1947b04 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -6,7 +6,8 @@ perf = Extension('perf',
 		  sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
 			     'util/evsel.c', 'util/cpumap.c', 'util/thread_map.c',
 			     'util/util.c', 'util/xyarray.c'],
-		  include_dirs = ['util/include'])
+		  include_dirs = ['util/include'],
+		  extra_compile_args = ['-fno-strict-aliasing', '-Wno-write-strings'])
 
 setup(name='perf',
       version='0.1',
