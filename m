Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab2BVOnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:43:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10495 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab2BVOmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:42:15 -0500
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=9QJGFBkUHwkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=xv7F_RwSEGyqHAq6ptsA:9 a=DFaQWu-492A7Z38V73wA:7 a=QEXdDO2ut3YA:10 a=YTw0oxLd7MoA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=NB3DgkIILUVRXzPZdFkA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120222144211.499161019@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 22 Feb 2012 09:40:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 8/9] ftrace: Allow to specify filter field type for ftrace events
References: <20120222144036.824378742@goodmis.org>
Content-Disposition: inline; filename=0008-ftrace-Allow-to-specify-filter-field-type-for-ftrace.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

Adding FILTER_TRACE_FN event field type for function tracepoint
event, so it can be properly recognized within filtering code.

Currently all fields of ftrace subsystem events share the common
field type FILTER_OTHER. Since the function trace fields need
special care within the filtering code we need to recognize it
properly, hence adding the FILTER_TRACE_FN event type.

Adding filter parameter to the FTRACE_ENTRY macro, to specify the
filter field type for the event.

Link: http://lkml.kernel.org/r/1329317514-8131-7-git-send-email-jolsa@redha=
t.com

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h       |    1 +
 kernel/trace/trace.h               |   23 +++++++++-------
 kernel/trace/trace_entries.h       |   48 ++++++++++++++++++++++++---------
 kernel/trace/trace_events_filter.c |    7 ++++-
 kernel/trace/trace_export.c        |   51 +++++++++++++++++++-------------=
---
 5 files changed, 83 insertions(+), 47 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 2bf677c..dd478fc 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -245,6 +245,7 @@ enum {
 	FILTER_STATIC_STRING,
 	FILTER_DYN_STRING,
 	FILTER_PTR_STRING,
+	FILTER_TRACE_FN,
 };
=20
 #define EVENT_STORAGE_SIZE 128
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 76a1c50..29f93cd 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -56,21 +56,23 @@ enum trace_type {
 #define F_STRUCT(args...)		args
=20
 #undef FTRACE_ENTRY
-#define FTRACE_ENTRY(name, struct_name, id, tstruct, print)	\
-	struct struct_name {					\
-		struct trace_entry	ent;			\
-		tstruct						\
+#define FTRACE_ENTRY(name, struct_name, id, tstruct, print, filter)	\
+	struct struct_name {						\
+		struct trace_entry	ent;				\
+		tstruct							\
 	}
=20
 #undef TP_ARGS
 #define TP_ARGS(args...)	args
=20
 #undef FTRACE_ENTRY_DUP
-#define FTRACE_ENTRY_DUP(name, name_struct, id, tstruct, printk)
+#define FTRACE_ENTRY_DUP(name, name_struct, id, tstruct, printk, filter)
=20
 #undef FTRACE_ENTRY_REG
-#define FTRACE_ENTRY_REG(name, struct_name, id, tstruct, print, regfn) \
-	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print))
+#define FTRACE_ENTRY_REG(name, struct_name, id, tstruct, print,	\
+			 filter, regfn) \
+	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print), \
+		     filter)
=20
 #include "trace_entries.h"
=20
@@ -826,12 +828,13 @@ extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
=20
 #undef FTRACE_ENTRY
-#define FTRACE_ENTRY(call, struct_name, id, tstruct, print)		\
+#define FTRACE_ENTRY(call, struct_name, id, tstruct, print, filter)	\
 	extern struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_##call;
 #undef FTRACE_ENTRY_DUP
-#define FTRACE_ENTRY_DUP(call, struct_name, id, tstruct, print)		\
-	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print))
+#define FTRACE_ENTRY_DUP(call, struct_name, id, tstruct, print, filter)	\
+	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print), \
+		     filter)
 #include "trace_entries.h"
=20
 #ifdef CONFIG_PERF_EVENTS
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index 47db7ed..d91eb05 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -66,6 +66,8 @@ FTRACE_ENTRY_REG(function, ftrace_entry,
=20
 	F_printk(" %lx <-- %lx", __entry->ip, __entry->parent_ip),
=20
+	FILTER_TRACE_FN,
+
 	perf_ftrace_event_register
 );
=20
@@ -80,7 +82,9 @@ FTRACE_ENTRY(funcgraph_entry, ftrace_graph_ent_entry,
 		__field_desc(	int,		graph_ent,	depth		)
 	),
=20
-	F_printk("--> %lx (%d)", __entry->func, __entry->depth)
+	F_printk("--> %lx (%d)", __entry->func, __entry->depth),
+
+	FILTER_OTHER
 );
=20
 /* Function return entry */
@@ -100,7 +104,9 @@ FTRACE_ENTRY(funcgraph_exit, ftrace_graph_ret_entry,
 	F_printk("<-- %lx (%d) (start: %llx  end: %llx) over: %d",
 		 __entry->func, __entry->depth,
 		 __entry->calltime, __entry->rettime,
-		 __entry->depth)
+		 __entry->depth),
+
+	FILTER_OTHER
 );
=20
 /*
@@ -129,8 +135,9 @@ FTRACE_ENTRY(context_switch, ctx_switch_entry,
 	F_printk("%u:%u:%u  =3D=3D> %u:%u:%u [%03u]",
 		 __entry->prev_pid, __entry->prev_prio, __entry->prev_state,
 		 __entry->next_pid, __entry->next_prio, __entry->next_state,
-		 __entry->next_cpu
-		)
+		 __entry->next_cpu),
+
+	FILTER_OTHER
 );
=20
 /*
@@ -148,8 +155,9 @@ FTRACE_ENTRY_DUP(wakeup, ctx_switch_entry,
 	F_printk("%u:%u:%u  =3D=3D+ %u:%u:%u [%03u]",
 		 __entry->prev_pid, __entry->prev_prio, __entry->prev_state,
 		 __entry->next_pid, __entry->next_prio, __entry->next_state,
-		 __entry->next_cpu
-		)
+		 __entry->next_cpu),
+
+	FILTER_OTHER
 );
=20
 /*
@@ -171,7 +179,9 @@ FTRACE_ENTRY(kernel_stack, stack_entry,
 		 "\t=3D> (%08lx)\n\t=3D> (%08lx)\n\t=3D> (%08lx)\n\t=3D> (%08lx)\n",
 		 __entry->caller[0], __entry->caller[1], __entry->caller[2],
 		 __entry->caller[3], __entry->caller[4], __entry->caller[5],
-		 __entry->caller[6], __entry->caller[7])
+		 __entry->caller[6], __entry->caller[7]),
+
+	FILTER_OTHER
 );
=20
 FTRACE_ENTRY(user_stack, userstack_entry,
@@ -187,7 +197,9 @@ FTRACE_ENTRY(user_stack, userstack_entry,
 		 "\t=3D> (%08lx)\n\t=3D> (%08lx)\n\t=3D> (%08lx)\n\t=3D> (%08lx)\n",
 		 __entry->caller[0], __entry->caller[1], __entry->caller[2],
 		 __entry->caller[3], __entry->caller[4], __entry->caller[5],
-		 __entry->caller[6], __entry->caller[7])
+		 __entry->caller[6], __entry->caller[7]),
+
+	FILTER_OTHER
 );
=20
 /*
@@ -204,7 +216,9 @@ FTRACE_ENTRY(bprint, bprint_entry,
 	),
=20
 	F_printk("%08lx fmt:%p",
-		 __entry->ip, __entry->fmt)
+		 __entry->ip, __entry->fmt),
+
+	FILTER_OTHER
 );
=20
 FTRACE_ENTRY(print, print_entry,
@@ -217,7 +231,9 @@ FTRACE_ENTRY(print, print_entry,
 	),
=20
 	F_printk("%08lx %s",
-		 __entry->ip, __entry->buf)
+		 __entry->ip, __entry->buf),
+
+	FILTER_OTHER
 );
=20
 FTRACE_ENTRY(mmiotrace_rw, trace_mmiotrace_rw,
@@ -236,7 +252,9 @@ FTRACE_ENTRY(mmiotrace_rw, trace_mmiotrace_rw,
=20
 	F_printk("%lx %lx %lx %d %x %x",
 		 (unsigned long)__entry->phys, __entry->value, __entry->pc,
-		 __entry->map_id, __entry->opcode, __entry->width)
+		 __entry->map_id, __entry->opcode, __entry->width),
+
+	FILTER_OTHER
 );
=20
 FTRACE_ENTRY(mmiotrace_map, trace_mmiotrace_map,
@@ -254,7 +272,9 @@ FTRACE_ENTRY(mmiotrace_map, trace_mmiotrace_map,
=20
 	F_printk("%lx %lx %lx %d %x",
 		 (unsigned long)__entry->phys, __entry->virt, __entry->len,
-		 __entry->map_id, __entry->opcode)
+		 __entry->map_id, __entry->opcode),
+
+	FILTER_OTHER
 );
=20
=20
@@ -274,6 +294,8 @@ FTRACE_ENTRY(branch, trace_branch,
=20
 	F_printk("%u:%s:%s (%u)",
 		 __entry->line,
-		 __entry->func, __entry->file, __entry->correct)
+		 __entry->func, __entry->file, __entry->correct),
+
+	FILTER_OTHER
 );
=20
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index 76afaee..3da3d0e 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -899,6 +899,11 @@ int filter_assign_type(const char *type)
 	return FILTER_OTHER;
 }
=20
+static bool is_function_field(struct ftrace_event_field *field)
+{
+	return field->filter_type =3D=3D FILTER_TRACE_FN;
+}
+
 static bool is_string_field(struct ftrace_event_field *field)
 {
 	return field->filter_type =3D=3D FILTER_DYN_STRING ||
@@ -986,7 +991,7 @@ static int init_pred(struct filter_parse_state *ps,
 			fn =3D filter_pred_strloc;
 		else
 			fn =3D filter_pred_pchar;
-	} else {
+	} else if (!is_function_field(field)) {
 		if (field->is_signed)
 			ret =3D strict_strtoll(pred->regex.pattern, 0, &val);
 		else
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index a3dbee6..7b46c9b 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -23,8 +23,10 @@
  * function and thus become accesible via perf.
  */
 #undef FTRACE_ENTRY_REG
-#define FTRACE_ENTRY_REG(name, struct_name, id, tstruct, print, regfn) \
-	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print))
+#define FTRACE_ENTRY_REG(name, struct_name, id, tstruct, print, \
+			 filter, regfn) \
+	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print), \
+		     filter)
=20
 /* not needed for this file */
 #undef __field_struct
@@ -52,21 +54,22 @@
 #define F_printk(fmt, args...) fmt, args
=20
 #undef FTRACE_ENTRY
-#define FTRACE_ENTRY(name, struct_name, id, tstruct, print)	\
-struct ____ftrace_##name {					\
-	tstruct							\
-};								\
-static void __always_unused ____ftrace_check_##name(void)	\
-{								\
-	struct ____ftrace_##name *__entry =3D NULL;		\
-								\
-	/* force compile-time check on F_printk() */		\
-	printk(print);						\
+#define FTRACE_ENTRY(name, struct_name, id, tstruct, print, filter)	\
+struct ____ftrace_##name {						\
+	tstruct								\
+};									\
+static void __always_unused ____ftrace_check_##name(void)		\
+{									\
+	struct ____ftrace_##name *__entry =3D NULL;			\
+									\
+	/* force compile-time check on F_printk() */			\
+	printk(print);							\
 }
=20
 #undef FTRACE_ENTRY_DUP
-#define FTRACE_ENTRY_DUP(name, struct_name, id, tstruct, print)	\
-	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print))
+#define FTRACE_ENTRY_DUP(name, struct_name, id, tstruct, print, filter)	\
+	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print), \
+		     filter)
=20
 #include "trace_entries.h"
=20
@@ -75,7 +78,7 @@ static void __always_unused ____ftrace_check_##name(void)=
	\
 	ret =3D trace_define_field(event_call, #type, #item,		\
 				 offsetof(typeof(field), item),		\
 				 sizeof(field.item),			\
-				 is_signed_type(type), FILTER_OTHER);	\
+				 is_signed_type(type), filter_type);	\
 	if (ret)							\
 		return ret;
=20
@@ -85,7 +88,7 @@ static void __always_unused ____ftrace_check_##name(void)=
	\
 				 offsetof(typeof(field),		\
 					  container.item),		\
 				 sizeof(field.container.item),		\
-				 is_signed_type(type), FILTER_OTHER);	\
+				 is_signed_type(type), filter_type);	\
 	if (ret)							\
 		return ret;
=20
@@ -99,7 +102,7 @@ static void __always_unused ____ftrace_check_##name(void=
)	\
 		ret =3D trace_define_field(event_call, event_storage, #item, \
 				 offsetof(typeof(field), item),		\
 				 sizeof(field.item),			\
-				 is_signed_type(type), FILTER_OTHER);	\
+				 is_signed_type(type), filter_type);	\
 		mutex_unlock(&event_storage_mutex);			\
 		if (ret)						\
 			return ret;					\
@@ -112,7 +115,7 @@ static void __always_unused ____ftrace_check_##name(voi=
d)	\
 				 offsetof(typeof(field),		\
 					  container.item),		\
 				 sizeof(field.container.item),		\
-				 is_signed_type(type), FILTER_OTHER);	\
+				 is_signed_type(type), filter_type);	\
 	if (ret)							\
 		return ret;
=20
@@ -120,17 +123,18 @@ static void __always_unused ____ftrace_check_##name(v=
oid)	\
 #define __dynamic_array(type, item)					\
 	ret =3D trace_define_field(event_call, #type, #item,		\
 				 offsetof(typeof(field), item),		\
-				 0, is_signed_type(type), FILTER_OTHER);\
+				 0, is_signed_type(type), filter_type);\
 	if (ret)							\
 		return ret;
=20
 #undef FTRACE_ENTRY
-#define FTRACE_ENTRY(name, struct_name, id, tstruct, print)		\
+#define FTRACE_ENTRY(name, struct_name, id, tstruct, print, filter)	\
 int									\
 ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 {									\
 	struct struct_name field;					\
 	int ret;							\
+	int filter_type =3D filter;					\
 									\
 	tstruct;							\
 									\
@@ -161,7 +165,8 @@ ftrace_define_fields_##name(struct ftrace_event_call *e=
vent_call)	\
 #define F_printk(fmt, args...) #fmt ", "  __stringify(args)
=20
 #undef FTRACE_ENTRY_REG
-#define FTRACE_ENTRY_REG(call, struct_name, etype, tstruct, print, regfn)\
+#define FTRACE_ENTRY_REG(call, struct_name, etype, tstruct, print, filter,\
+			 regfn)						\
 									\
 struct ftrace_event_class event_class_ftrace_##call =3D {			\
 	.system			=3D __stringify(TRACE_SYSTEM),		\
@@ -180,9 +185,9 @@ struct ftrace_event_call __used						\
 __attribute__((section("_ftrace_events"))) *__event_##call =3D &event_##ca=
ll;
=20
 #undef FTRACE_ENTRY
-#define FTRACE_ENTRY(call, struct_name, etype, tstruct, print)		\
+#define FTRACE_ENTRY(call, struct_name, etype, tstruct, print, filter)	\
 	FTRACE_ENTRY_REG(call, struct_name, etype,			\
-			 PARAMS(tstruct), PARAMS(print), NULL)
+			 PARAMS(tstruct), PARAMS(print), filter, NULL)
=20
 int ftrace_event_is_function(struct ftrace_event_call *call)
 {
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPRP7DAAoJEIy3vGnGbaoAeh0QAIyZyMxHtDd5NVo6vUC+jw43
oUAa+xKXvNMEl2lfR5ngUgHuDKlxdl2l/PZuhjaa6te7P1LjcZPkqyr/bDMp3sUl
XfUHqfVUXO356BGRKe6UIe0ISTAU6UcnugR4F2kY1CV0FVLgPY6RJgmo1wRRlcnq
IFWb3rxgIRZYEA2UA7drnEj6Dhbc3Eyv4Z+FhK8jznKZMvifTJCEIY1WW8QNTkRC
1sIPqSKa0sko6Mb8o0+d+rDfPY5ZKWtt8XkAotdjFFymtElrN7iYRewMLShcIDpw
JChWC1JFE14FFd+YM/cJ2W5I+qr7eeM4jv97sSO8tS10hIcRsBM2n7UksLAXR9jl
WwA1zQ/v2LcRdV89sXky9JhVCInmKClxDzAW2clV7dTFy7dmjsiFPENgjIODf5aX
4VYzEfMdzBP/JCTJPDLmlV2Hp/P7xstWC0QHR/WpMAEvCi4cF+c0fNOD6LJQmKDf
u+IkyhpLbV7Z3GNH4d8/LgBV8c7yG11kJoAgzD3XdD6FfjcMnso1ZBxFqYHlQbuJ
wr5xfJfBSX0bGRib1DmpaL1GKZr8HmWhdVaTtTmCnQDEapNP4PBYmmSi89vnDZxx
CXODCmbe8H146cCPdhEXTNDyyAsWybwiOXxGVk/GeQRPXnw5ONaABYGXfgK3W+5D
nqJrA3ofdKnbLbNoviZA
=VBp8
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
