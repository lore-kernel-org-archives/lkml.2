Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab0DBE6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 00:58:34 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:54985 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab0DBE62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 00:58:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=EBcV8SKzVLHpUnKdbsidV0KZRAWZHKm0Jq8X/6eUh5Zkd0/abr9JPog4EUq2L1tt5s
         XEhrn/w6+camooBZ89oZdzX2MXtw+YNCiNUGPfaXipzzAuLF7uiBX+LDimzNh+48A1yZ
         Hq0tJZXzLRBP7yYL5xo5aTfRINewxzOmjq4rM=
Subject: [PATCH] perf/scripts: tuple was set from long in both branches in
 python_process_event()
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Roel Kluin <roel.kluin@gmail.com>, mingo@elte.hu,
       Frederic Weisbecker <fweisbec@gmail.com>, rostedt@goodmis.org
Content-Type: text/plain
Date: Thu, 01 Apr 2010 23:58:25 -0500
Message-Id: <1270184305.6422.10.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fix to the signed/unsigned field handling in the Python
scripting engine, based on a patch from Roel Kluin.

Basically, Python wants to use a PyInt (which is internally a long) if
it can i.e. if the value will fit into that type.  If not, it stores it
into a PyLong, which isn't actually a long, but an arbitrary-precision
integer variable.

The code below is similar to to what Python does internally, and it
seems to work as expected on the x86 and x86_64 sytems I tested it on.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
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
-- 
1.6.4.GIT



