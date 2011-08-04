Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab1HDO54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 10:57:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54007 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab1HDO5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 10:57:35 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/4] perf python: Add PERF_RECORD_{LOST,READ,SAMPLE} routine tables
Date: Thu,  4 Aug 2011 11:57:17 -0300
Message-Id: <1312469838-2884-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1312469838-2884-1-git-send-email-acme@infradead.org>
References: <1312469838-2884-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So those friggin "spurious" PERF_RECORD_MMAP events were actually a
brain fart copy'n'paste error in the python binding, doh. I.e. they
weren't MMAPs, just SAMPLEs.

Fix it by providing routines for these events instead of using the MMAP
ones.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-b0rc8y5jd03f9f11kftodvkm@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/python.c |  115 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 112 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 8e0b5a3..cbc8f21 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -187,16 +187,119 @@ static PyTypeObject pyrf_throttle_event__type = {
 	.tp_repr	= (reprfunc)pyrf_throttle_event__repr,
 };
 
+static char pyrf_lost_event__doc[] = PyDoc_STR("perf lost event object.");
+
+static PyMemberDef pyrf_lost_event__members[] = {
+	sample_members
+	member_def(lost_event, id, T_ULONGLONG, "event id"),
+	member_def(lost_event, lost, T_ULONGLONG, "number of lost events"),
+	{ .name = NULL, },
+};
+
+static PyObject *pyrf_lost_event__repr(struct pyrf_event *pevent)
+{
+	PyObject *ret;
+	char *s;
+
+	if (asprintf(&s, "{ type: lost, id: %#" PRIx64 ", "
+			 "lost: %#" PRIx64 " }",
+		     pevent->event.lost.id, pevent->event.lost.lost) < 0) {
+		ret = PyErr_NoMemory();
+	} else {
+		ret = PyString_FromString(s);
+		free(s);
+	}
+	return ret;
+}
+
+static PyTypeObject pyrf_lost_event__type = {
+	PyVarObject_HEAD_INIT(NULL, 0)
+	.tp_name	= "perf.lost_event",
+	.tp_basicsize	= sizeof(struct pyrf_event),
+	.tp_flags	= Py_TPFLAGS_DEFAULT|Py_TPFLAGS_BASETYPE,
+	.tp_doc		= pyrf_lost_event__doc,
+	.tp_members	= pyrf_lost_event__members,
+	.tp_repr	= (reprfunc)pyrf_lost_event__repr,
+};
+
+static char pyrf_read_event__doc[] = PyDoc_STR("perf read event object.");
+
+static PyMemberDef pyrf_read_event__members[] = {
+	sample_members
+	member_def(read_event, pid, T_UINT, "event pid"),
+	member_def(read_event, tid, T_UINT, "event tid"),
+	{ .name = NULL, },
+};
+
+static PyObject *pyrf_read_event__repr(struct pyrf_event *pevent)
+{
+	return PyString_FromFormat("{ type: read, pid: %u, tid: %u }",
+				   pevent->event.read.pid,
+				   pevent->event.read.tid);
+	/*
+ 	 * FIXME: return the array of read values,
+ 	 * making this method useful ;-)
+ 	 */
+}
+
+static PyTypeObject pyrf_read_event__type = {
+	PyVarObject_HEAD_INIT(NULL, 0)
+	.tp_name	= "perf.read_event",
+	.tp_basicsize	= sizeof(struct pyrf_event),
+	.tp_flags	= Py_TPFLAGS_DEFAULT|Py_TPFLAGS_BASETYPE,
+	.tp_doc		= pyrf_read_event__doc,
+	.tp_members	= pyrf_read_event__members,
+	.tp_repr	= (reprfunc)pyrf_read_event__repr,
+};
+
+static char pyrf_sample_event__doc[] = PyDoc_STR("perf sample event object.");
+
+static PyMemberDef pyrf_sample_event__members[] = {
+	sample_members
+	member_def(perf_event_header, type, T_UINT, "event type"),
+	{ .name = NULL, },
+};
+
+static PyObject *pyrf_sample_event__repr(struct pyrf_event *pevent)
+{
+	PyObject *ret;
+	char *s;
+
+	if (asprintf(&s, "{ type: sample }") < 0) {
+		ret = PyErr_NoMemory();
+	} else {
+		ret = PyString_FromString(s);
+		free(s);
+	}
+	return ret;
+}
+
+static PyTypeObject pyrf_sample_event__type = {
+	PyVarObject_HEAD_INIT(NULL, 0)
+	.tp_name	= "perf.sample_event",
+	.tp_basicsize	= sizeof(struct pyrf_event),
+	.tp_flags	= Py_TPFLAGS_DEFAULT|Py_TPFLAGS_BASETYPE,
+	.tp_doc		= pyrf_sample_event__doc,
+	.tp_members	= pyrf_sample_event__members,
+	.tp_repr	= (reprfunc)pyrf_sample_event__repr,
+};
+
 static int pyrf_event__setup_types(void)
 {
 	int err;
 	pyrf_mmap_event__type.tp_new =
 	pyrf_task_event__type.tp_new =
 	pyrf_comm_event__type.tp_new =
+	pyrf_lost_event__type.tp_new =
+	pyrf_read_event__type.tp_new =
+	pyrf_sample_event__type.tp_new =
 	pyrf_throttle_event__type.tp_new = PyType_GenericNew;
 	err = PyType_Ready(&pyrf_mmap_event__type);
 	if (err < 0)
 		goto out;
+	err = PyType_Ready(&pyrf_lost_event__type);
+	if (err < 0)
+		goto out;
 	err = PyType_Ready(&pyrf_task_event__type);
 	if (err < 0)
 		goto out;
@@ -206,20 +309,26 @@ static int pyrf_event__setup_types(void)
 	err = PyType_Ready(&pyrf_throttle_event__type);
 	if (err < 0)
 		goto out;
+	err = PyType_Ready(&pyrf_read_event__type);
+	if (err < 0)
+		goto out;
+	err = PyType_Ready(&pyrf_sample_event__type);
+	if (err < 0)
+		goto out;
 out:
 	return err;
 }
 
 static PyTypeObject *pyrf_event__type[] = {
 	[PERF_RECORD_MMAP]	 = &pyrf_mmap_event__type,
-	[PERF_RECORD_LOST]	 = &pyrf_mmap_event__type,
+	[PERF_RECORD_LOST]	 = &pyrf_lost_event__type,
 	[PERF_RECORD_COMM]	 = &pyrf_comm_event__type,
 	[PERF_RECORD_EXIT]	 = &pyrf_task_event__type,
 	[PERF_RECORD_THROTTLE]	 = &pyrf_throttle_event__type,
 	[PERF_RECORD_UNTHROTTLE] = &pyrf_throttle_event__type,
 	[PERF_RECORD_FORK]	 = &pyrf_task_event__type,
-	[PERF_RECORD_READ]	 = &pyrf_mmap_event__type,
-	[PERF_RECORD_SAMPLE]	 = &pyrf_mmap_event__type,
+	[PERF_RECORD_READ]	 = &pyrf_read_event__type,
+	[PERF_RECORD_SAMPLE]	 = &pyrf_sample_event__type,
 };
 
 static PyObject *pyrf_event__new(union perf_event *event)
-- 
1.6.2.5

