Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab0CVRVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 13:21:05 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:50523 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab0CVRVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:21:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=bFI/2YywNmLhre9nfCoSlKgoaoM7JDkNrRaNA/KmGhz8n1lRUVjUghvv2SYkDtK83m
         U3oghzWDpoqTOXgSnBHlgNK02usg0nt1xwm/Hq80T4iY3RFT2KwshNzos8LIIdsS8jiw
         5t6bH9L0OO0e52YhubYJJWYu2WfFM19aMUlnQ=
Message-ID: <4BA7A76E.3040007@gmail.com>
Date: Mon, 22 Mar 2010 18:22:54 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Tom Zanussi <tzanussi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf/scripts: tuple was set from long in both branches in
 python_process_event()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regardless of the sign, the tuple was set from a long.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 .../util/scripting-engines/trace-event-python.c    |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

Was something like this intended?

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 33a414b..1d710b6 100644
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
@@ -256,16 +256,19 @@ static void python_process_event(int cpu, void *data,
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
+				obj = PyInt_FromLong(val);
 			} else {
-				PyTuple_SetItem(t, n++, PyInt_FromLong(val));
+				if (sizeof(val) > sizeof(Py_ssize_t))
+					val += 1ULL <<
+						(sizeof(Py_ssize_t) * 8);
+				obj = PyLong_FromUnsignedLongLong(val);
 			}
 		}
+		PyTuple_SetItem(t, n++, obj);
 	}
 
 	if (_PyTuple_Resize(&t, n) == -1)

