Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab2BVOm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:42:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21149 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab2BVOmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:42:14 -0500
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=GZl6IaAbD0gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=aZO6KyMcvEnsbD7TDiQA:9 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=PkyZ8_h919X1EJeYXxEA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120222144210.866394007@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 22 Feb 2012 09:40:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 6/9] ftrace: Add FTRACE_ENTRY_REG macro to allow event registration
References: <20120222144036.824378742@goodmis.org>
Content-Disposition: inline; filename=0006-ftrace-Add-FTRACE_ENTRY_REG-macro-to-allow-event-reg.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

Adding FTRACE_ENTRY_REG macro so particular ftrace entries
could specify registration function and thus become accesible
via perf.

This will be used in upcomming patch for function trace.

Link: http://lkml.kernel.org/r/1329317514-8131-5-git-send-email-jolsa@redha=
t.com

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h        |    4 ++++
 kernel/trace/trace_export.c |   18 ++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 55c6ea0..638476a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -68,6 +68,10 @@ enum trace_type {
 #undef FTRACE_ENTRY_DUP
 #define FTRACE_ENTRY_DUP(name, name_struct, id, tstruct, printk)
=20
+#undef FTRACE_ENTRY_REG
+#define FTRACE_ENTRY_REG(name, struct_name, id, tstruct, print, regfn) \
+	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print))
+
 #include "trace_entries.h"
=20
 /*
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index bbeec31..f74de86 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -18,6 +18,14 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM	ftrace
=20
+/*
+ * The FTRACE_ENTRY_REG macro allows ftrace entry to define register
+ * function and thus become accesible via perf.
+ */
+#undef FTRACE_ENTRY_REG
+#define FTRACE_ENTRY_REG(name, struct_name, id, tstruct, print, regfn) \
+	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print))
+
 /* not needed for this file */
 #undef __field_struct
 #define __field_struct(type, item)
@@ -152,13 +160,14 @@ ftrace_define_fields_##name(struct ftrace_event_call =
*event_call)	\
 #undef F_printk
 #define F_printk(fmt, args...) #fmt ", "  __stringify(args)
=20
-#undef FTRACE_ENTRY
-#define FTRACE_ENTRY(call, struct_name, etype, tstruct, print)		\
+#undef FTRACE_ENTRY_REG
+#define FTRACE_ENTRY_REG(call, struct_name, etype, tstruct, print, regfn)\
 									\
 struct ftrace_event_class event_class_ftrace_##call =3D {			\
 	.system			=3D __stringify(TRACE_SYSTEM),		\
 	.define_fields		=3D ftrace_define_fields_##call,		\
 	.fields			=3D LIST_HEAD_INIT(event_class_ftrace_##call.fields),\
+	.reg			=3D regfn,				\
 };									\
 									\
 struct ftrace_event_call __used event_##call =3D {			\
@@ -170,4 +179,9 @@ struct ftrace_event_call __used event_##call =3D {			\
 struct ftrace_event_call __used						\
 __attribute__((section("_ftrace_events"))) *__event_##call =3D &event_##ca=
ll;
=20
+#undef FTRACE_ENTRY
+#define FTRACE_ENTRY(call, struct_name, etype, tstruct, print)		\
+	FTRACE_ENTRY_REG(call, struct_name, etype,			\
+			 PARAMS(tstruct), PARAMS(print), NULL)
+
 #include "trace_entries.h"
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPRP7CAAoJEIy3vGnGbaoAe6sP/AtFnSi6uBY9oXI3IWopY7Zn
gzmM/RA3pyo8Tz+bLu67YUAof6ZeMItNOOWu4J1DM/24IG0EoIg6I0gYVCiRKZps
PbD0mEA9JA0ne6DjZUvh5jE5rokXhUzqwFauQKhXk+2iMli1H7jxR/oEZIbKl+io
xlyE6TXVUrFyOkgpnx+gJ6vg69rqc0CuT4meFSjzmnMB85tVhtVU4qAqlJio1ix4
C7qsI8T6HtnbS7wLxTaUAmTsL1ZHY5b7OhezTq4FXUb1CVMMxdzFZ6JUQfGXNhBn
WtGXdFdGzNxFwGDAkpGNaZlBJzVUxX0kRDWdtuqrdclegYiMPCc11not+JnOAz7j
3n7ryqcW9TbpS4oNh7il9Qw9CCmM//MMmtrNKa8Vm9b4WssopKUOBhZT8xy9vgYh
p1jB05SJGowXg8Keg3EP3HrCiEkhtwkDx72SvY0aHkWu59VU2P56eZlHI6jqmyM+
kvEK94eZ2SvYV+KNCe97YDCDUADYPy3NlNt2QHGCLg+v5PEi1vgRop7ULNuENAWl
lR1ldLCNW701s6HtviCFLm1I/4p4wZXdn/KKcAJH8SL9lBTXMiGGFaQtGz9LKyxj
KMdX3RlhV/50Z5uM48d3BKdOc0rifO9piUH5FOGZgQPGgcJy5l6/e9vSDiA4JVGH
mE8HdPp7j4i3BvU6ilUI
=TqyO
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
