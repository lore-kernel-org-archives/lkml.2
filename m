Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab0CYFnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:43:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36327 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0CYFnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:43:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PeE7Q2KJuS+d7V5UxV7bzniJCimryXp/rsxlfr0HYyyGnuPPySsy4r7+6DeBhOX0pU
         hYqSiTU3A0V6IkoIL9S/TQLgNVgyZB0fCzlBhF7+gVpDEv/Vn0YPsFDl7xrI6DgblC5d
         aGh7qG+UNq49BWu4BNaxxhoJmQXZp16eF7QgA=
Subject: Re: [PATCH] perf/scripts: tuple was set from long in both branches
 in python_process_event()
From: Tom Zanussi <tzanussi@gmail.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4BA7A76E.3040007@gmail.com>
References: <4BA7A76E.3040007@gmail.com>
Content-Type: text/plain
Date: Thu, 25 Mar 2010 00:42:58 -0500
Message-Id: <1269495778.6606.86.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2010-03-22 at 18:22 +0100, Roel Kluin wrote:
> Regardless of the sign, the tuple was set from a long.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  .../util/scripting-engines/trace-event-python.c    |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> Was something like this intended?

Yeah, something like that - thanks for noticing it and providing the
patch.  After looking at the Python implementation, I modified your
patch as below...

Basically, Python wants to use a PyInt (which is internally a long) if
it can i.e. if the value will fit into that type.  If not, it stores it
into a PyLong, which isn't actually a long, but an arbitrary-precision
integer variable.

The code below is similar to to what Python does internally, and it
seems to work as expected on the x86 and x86_64 sytems I tested it on.

Thanks,

Tom

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

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




