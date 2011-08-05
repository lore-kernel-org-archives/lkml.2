Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab1HEKJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:09:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:32962 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab1HEKIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:08:23 -0400
Date: Fri, 5 Aug 2011 10:07:50 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-b0rc8y5jd03f9f11kftodvkm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf python: Add PERF_RECORD_{LOST,READ,SAMPLE} routine tables
Git-Commit-ID: 3e9f45a7a4179604ccbae1589de0e7165bc6fcd0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Aug 2011 10:07:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e9f45a7a4179604ccbae1589de0e7165bc6fcd0
Gitweb:     http://git.kernel.org/tip/3e9f45a7a4179604ccbae1589de0e7165bc6fcd0
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 25 Jul 2011 17:13:27 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 25 Jul 2011 17:13:27 -0300

perf python: Add PERF_RECORD_{LOST,READ,SAMPLE} routine tables

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
