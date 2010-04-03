Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0DCJ2z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 05:28:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:60868 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980Ab0DCJ2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 05:28:42 -0400
Date: Sat, 3 Apr 2010 09:28:24 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, tzanussi@gmail.com, fweisbec@gmail.com,
       roel.kluin@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, tzanussi@gmail.com,
       roel.kluin@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1270184305.6422.10.camel@tropicana>
References: <1270184305.6422.10.camel@tropicana>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/scripts: Tuple was set from long in both branches in python_process_event()
Message-ID: <tip-b1dcc03cb8ee0f5718491e8c518257238dc64e00@git.kernel.org>
Git-Commit-ID: b1dcc03cb8ee0f5718491e8c518257238dc64e00
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 03 Apr 2010 09:28:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1dcc03cb8ee0f5718491e8c518257238dc64e00
Gitweb:     http://git.kernel.org/tip/b1dcc03cb8ee0f5718491e8c518257238dc64e00
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Thu, 1 Apr 2010 23:58:25 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 21:32:16 +0200

perf/scripts: Tuple was set from long in both branches in python_process_event()

This is a fix to the signed/unsigned field handling in the
Python scripting engine, based on a patch from Roel Kluin.

Basically, Python wants to use a PyInt (which is internally a
long) if it can i.e. if the value will fit into that type.  If
not, it stores it into a PyLong, which isn't actually a long,
but an arbitrary-precision integer variable.

The code below is similar to to what Python does internally, and
it seems to work as expected on the x86 and x86_64 sytems I
tested it on.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Roel Kluin <roel.kluin@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org
LKML-Reference: <1270184305.6422.10.camel@tropicana>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 .../util/scripting-engines/trace-event-python.c    |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 33a414b..6a72f14 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -208,7 +208,7 @@ static void python_process_event(int cpu, void *data,
 				 int size __unused,
 				 unsigned long long nsecs, char *comm)
 {
-	PyObject *handler, *retval, *context, *t;
+	PyObject *handler, *retval, *context, *t, *obj;
 	static char handler_name[256];
 	struct format_field *field;
 	unsigned long long val;
@@ -256,16 +256,23 @@ static void python_process_event(int cpu, void *data,
 				offset &= 0xffff;
 			} else
 				offset = field->offset;
-			PyTuple_SetItem(t, n++,
-				PyString_FromString((char *)data + offset));
+			obj = PyString_FromString((char *)data + offset);
 		} else { /* FIELD_IS_NUMERIC */
 			val = read_size(data + field->offset, field->size);
 			if (field->flags & FIELD_IS_SIGNED) {
-				PyTuple_SetItem(t, n++, PyInt_FromLong(val));
+				if ((long long)val >= LONG_MIN &&
+				    (long long)val <= LONG_MAX)
+					obj = PyInt_FromLong(val);
+				else
+					obj = PyLong_FromLongLong(val);
 			} else {
-				PyTuple_SetItem(t, n++, PyInt_FromLong(val));
+				if (val <= LONG_MAX)
+					obj = PyInt_FromLong(val);
+				else
+					obj = PyLong_FromUnsignedLongLong(val);
 			}
 		}
+		PyTuple_SetItem(t, n++, obj);
 	}
 
 	if (_PyTuple_Resize(&t, n) == -1)
