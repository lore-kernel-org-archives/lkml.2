Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab2IYTU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:20:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22934 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab2IYTUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:20:32 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=q7vdrXB6yRQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Tvleaa9oKDUA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=5AsGncLD6tBg03Uobs0A:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=ea1CRt6O6R-LzL3aHuAA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120925192029.506885571@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 25 Sep 2012 15:19:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 2/2] trace: Move trace event enable from fs_initcall to core_initcall
References: <20120925191941.504217238@goodmis.org>
Content-Disposition: inline; filename=0002-trace-Move-trace-event-enable-from-fs_initcall-to-co.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Ezequiel Garcia <elezegarcia@gmail.com>

This patch splits trace event initialization in two stages:
 * ftrace enable
 * sysfs event entry creation

This allows to capture trace events from an earlier point
by using 'trace_event' kernel parameter and is important
to trace boot-up allocations.

Note that, in order to enable events at core_initcall,
it's necessary to move init_ftrace_syscalls() from
core_initcall to early_initcall.

Link: http://lkml.kernel.org/r/1347461277-25302-1-git-send-email-elezegarci=
a@gmail.com

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c   |  108 +++++++++++++++++++++++++++----------=
----
 kernel/trace/trace_syscalls.c |    2 +-
 2 files changed, 73 insertions(+), 37 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index bbb0e63..d608d09 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1199,6 +1199,31 @@ event_create_dir(struct ftrace_event_call *call, str=
uct dentry *d_events,
 	return 0;
 }
=20
+static void event_remove(struct ftrace_event_call *call)
+{
+	ftrace_event_enable_disable(call, 0);
+	if (call->event.funcs)
+		__unregister_ftrace_event(&call->event);
+	list_del(&call->list);
+}
+
+static int event_init(struct ftrace_event_call *call)
+{
+	int ret =3D 0;
+
+	if (WARN_ON(!call->name))
+		return -EINVAL;
+
+	if (call->class->raw_init) {
+		ret =3D call->class->raw_init(call);
+		if (ret < 0 && ret !=3D -ENOSYS)
+			pr_warn("Could not initialize trace events/%s\n",
+				call->name);
+	}
+
+	return ret;
+}
+
 static int
 __trace_add_event_call(struct ftrace_event_call *call, struct module *mod,
 		       const struct file_operations *id,
@@ -1209,19 +1234,9 @@ __trace_add_event_call(struct ftrace_event_call *cal=
l, struct module *mod,
 	struct dentry *d_events;
 	int ret;
=20
-	/* The linker may leave blanks */
-	if (!call->name)
-		return -EINVAL;
-
-	if (call->class->raw_init) {
-		ret =3D call->class->raw_init(call);
-		if (ret < 0) {
-			if (ret !=3D -ENOSYS)
-				pr_warning("Could not initialize trace events/%s\n",
-					   call->name);
-			return ret;
-		}
-	}
+	ret =3D event_init(call);
+	if (ret < 0)
+		return ret;
=20
 	d_events =3D event_trace_events_dir();
 	if (!d_events)
@@ -1272,13 +1287,10 @@ static void remove_subsystem_dir(const char *name)
  */
 static void __trace_remove_event_call(struct ftrace_event_call *call)
 {
-	ftrace_event_enable_disable(call, 0);
-	if (call->event.funcs)
-		__unregister_ftrace_event(&call->event);
-	debugfs_remove_recursive(call->dir);
-	list_del(&call->list);
+	event_remove(call);
 	trace_destroy_fields(call);
 	destroy_preds(call);
+	debugfs_remove_recursive(call->dir);
 	remove_subsystem_dir(call->class->system);
 }
=20
@@ -1450,15 +1462,43 @@ static __init int setup_trace_event(char *str)
 }
 __setup("trace_event=3D", setup_trace_event);
=20
+static __init int event_trace_enable(void)
+{
+	struct ftrace_event_call **iter, *call;
+	char *buf =3D bootup_event_buf;
+	char *token;
+	int ret;
+
+	for_each_event(iter, __start_ftrace_events, __stop_ftrace_events) {
+
+		call =3D *iter;
+		ret =3D event_init(call);
+		if (!ret)
+			list_add(&call->list, &ftrace_events);
+	}
+
+	while (true) {
+		token =3D strsep(&buf, ",");
+
+		if (!token)
+			break;
+		if (!*token)
+			continue;
+
+		ret =3D ftrace_set_clr_event(token, 1);
+		if (ret)
+			pr_warn("Failed to enable trace event: %s\n", token);
+	}
+	return 0;
+}
+
 static __init int event_trace_init(void)
 {
-	struct ftrace_event_call **call;
+	struct ftrace_event_call *call;
 	struct dentry *d_tracer;
 	struct dentry *entry;
 	struct dentry *d_events;
 	int ret;
-	char *buf =3D bootup_event_buf;
-	char *token;
=20
 	d_tracer =3D tracing_init_dentry();
 	if (!d_tracer)
@@ -1497,24 +1537,19 @@ static __init int event_trace_init(void)
 	if (trace_define_common_fields())
 		pr_warning("tracing: Failed to allocate common fields");
=20
-	for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
-		__trace_add_event_call(*call, NULL, &ftrace_event_id_fops,
+	/*
+	 * Early initialization already enabled ftrace event.
+	 * Now it's only necessary to create the event directory.
+	 */
+	list_for_each_entry(call, &ftrace_events, list) {
+
+		ret =3D event_create_dir(call, d_events,
+				       &ftrace_event_id_fops,
 				       &ftrace_enable_fops,
 				       &ftrace_event_filter_fops,
 				       &ftrace_event_format_fops);
-	}
-
-	while (true) {
-		token =3D strsep(&buf, ",");
-
-		if (!token)
-			break;
-		if (!*token)
-			continue;
-
-		ret =3D ftrace_set_clr_event(token, 1);
-		if (ret)
-			pr_warning("Failed to enable trace event: %s\n", token);
+		if (ret < 0)
+			event_remove(call);
 	}
=20
 	ret =3D register_module_notifier(&trace_module_nb);
@@ -1523,6 +1558,7 @@ static __init int event_trace_init(void)
=20
 	return 0;
 }
+core_initcall(event_trace_enable);
 fs_initcall(event_trace_init);
=20
 #ifdef CONFIG_FTRACE_STARTUP_TEST
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 6b245f64..2485a7d 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -487,7 +487,7 @@ int __init init_ftrace_syscalls(void)
=20
 	return 0;
 }
-core_initcall(init_ftrace_syscalls);
+early_initcall(init_ftrace_syscalls);
=20
 #ifdef CONFIG_PERF_EVENTS
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQYgP9AAoJEOdOSU1xswtMvXcH/A6zPGkUhUCUnkMnfgOls1mt
oP2nFrj1uGsSB2HfkR0BXj+2ZJ/rJORv+z7ho5dNEcEEIwuOhX+SsFZX8Nj8fMQQ
jb66MrZYzrSeoR5IAxPCGojqyFa4wFDrc0KWdsPpLvdc2muxcjCupLcJSTpZHn40
5QdOxXdN+50qv3qDdXNGULxjpNLv++kQH8bVk49X9bMKo1xIEf68c1Awf7mo2fAS
72RelAi99+jBju7ta6AndJ4eP8q9MzgmF09qk33MNxWYKqXgchj7a5B/+cNxgXIf
EI4tvCdU4UYJVKlwjE4OgGS9mM+lyNp1XaOPxJwVgCjejU0ri3JNR8EOP9IW1AI=
=psYi
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
