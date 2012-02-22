Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab2BVOmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:42:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29839 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab2BVOmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:42:11 -0500
X-Authority-Analysis: v=2.0 cv=Xp94yC59 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=TZu3YCodNBYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=tgrjHhGWGO8IGqkC06wA:9 a=X6eoLNhjhKTwdocw66EA:7 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=2okdAwRRzKUnGa79:21 a=vvZQjQ32bLel6leO:21 a=6v6TomEN2Znurk1lMQkA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120222144210.122768180@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 22 Feb 2012 09:40:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/9] ftrace, perf: Add open/close tracepoint perf registration actions
References: <20120222144036.824378742@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-perf-Add-open-close-tracepoint-perf-registrat.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

Adding TRACE_REG_PERF_OPEN and TRACE_REG_PERF_CLOSE to differentiate
register/unregister from open/close actions.

The register/unregister actions are invoked for the first/last
tracepoint user when opening/closing the event.

The open/close actions are invoked for each tracepoint user when
opening/closing the event.

Link: http://lkml.kernel.org/r/1329317514-8131-3-git-send-email-jolsa@redha=
t.com

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h    |    6 +-
 kernel/trace/trace_event_perf.c |  116 +++++++++++++++++++++++++----------=
----
 kernel/trace/trace_events.c     |   10 ++-
 kernel/trace/trace_kprobe.c     |    6 ++-
 kernel/trace/trace_syscalls.c   |   14 +++-
 5 files changed, 101 insertions(+), 51 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index c3da42d..195e360 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -146,6 +146,8 @@ enum trace_reg {
 	TRACE_REG_UNREGISTER,
 	TRACE_REG_PERF_REGISTER,
 	TRACE_REG_PERF_UNREGISTER,
+	TRACE_REG_PERF_OPEN,
+	TRACE_REG_PERF_CLOSE,
 };
=20
 struct ftrace_event_call;
@@ -157,7 +159,7 @@ struct ftrace_event_class {
 	void			*perf_probe;
 #endif
 	int			(*reg)(struct ftrace_event_call *event,
-				       enum trace_reg type);
+				       enum trace_reg type, void *data);
 	int			(*define_fields)(struct ftrace_event_call *);
 	struct list_head	*(*get_fields)(struct ftrace_event_call *);
 	struct list_head	fields;
@@ -165,7 +167,7 @@ struct ftrace_event_class {
 };
=20
 extern int ftrace_event_reg(struct ftrace_event_call *event,
-			    enum trace_reg type);
+			    enum trace_reg type, void *data);
=20
 enum {
 	TRACE_EVENT_FL_ENABLED_BIT,
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_per=
f.c
index 19a359d..0cfcc37 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -44,23 +44,17 @@ static int perf_trace_event_perm(struct ftrace_event_ca=
ll *tp_event,
 	return 0;
 }
=20
-static int perf_trace_event_init(struct ftrace_event_call *tp_event,
-				 struct perf_event *p_event)
+static int perf_trace_event_reg(struct ftrace_event_call *tp_event,
+				struct perf_event *p_event)
 {
 	struct hlist_head __percpu *list;
-	int ret;
+	int ret =3D -ENOMEM;
 	int cpu;
=20
-	ret =3D perf_trace_event_perm(tp_event, p_event);
-	if (ret)
-		return ret;
-
 	p_event->tp_event =3D tp_event;
 	if (tp_event->perf_refcount++ > 0)
 		return 0;
=20
-	ret =3D -ENOMEM;
-
 	list =3D alloc_percpu(struct hlist_head);
 	if (!list)
 		goto fail;
@@ -83,7 +77,7 @@ static int perf_trace_event_init(struct ftrace_event_call=
 *tp_event,
 		}
 	}
=20
-	ret =3D tp_event->class->reg(tp_event, TRACE_REG_PERF_REGISTER);
+	ret =3D tp_event->class->reg(tp_event, TRACE_REG_PERF_REGISTER, NULL);
 	if (ret)
 		goto fail;
=20
@@ -108,6 +102,69 @@ fail:
 	return ret;
 }
=20
+static void perf_trace_event_unreg(struct perf_event *p_event)
+{
+	struct ftrace_event_call *tp_event =3D p_event->tp_event;
+	int i;
+
+	if (--tp_event->perf_refcount > 0)
+		goto out;
+
+	tp_event->class->reg(tp_event, TRACE_REG_PERF_UNREGISTER, NULL);
+
+	/*
+	 * Ensure our callback won't be called anymore. The buffers
+	 * will be freed after that.
+	 */
+	tracepoint_synchronize_unregister();
+
+	free_percpu(tp_event->perf_events);
+	tp_event->perf_events =3D NULL;
+
+	if (!--total_ref_count) {
+		for (i =3D 0; i < PERF_NR_CONTEXTS; i++) {
+			free_percpu(perf_trace_buf[i]);
+			perf_trace_buf[i] =3D NULL;
+		}
+	}
+out:
+	module_put(tp_event->mod);
+}
+
+static int perf_trace_event_open(struct perf_event *p_event)
+{
+	struct ftrace_event_call *tp_event =3D p_event->tp_event;
+	return tp_event->class->reg(tp_event, TRACE_REG_PERF_OPEN, p_event);
+}
+
+static void perf_trace_event_close(struct perf_event *p_event)
+{
+	struct ftrace_event_call *tp_event =3D p_event->tp_event;
+	tp_event->class->reg(tp_event, TRACE_REG_PERF_CLOSE, p_event);
+}
+
+static int perf_trace_event_init(struct ftrace_event_call *tp_event,
+				 struct perf_event *p_event)
+{
+	int ret;
+
+	ret =3D perf_trace_event_perm(tp_event, p_event);
+	if (ret)
+		return ret;
+
+	ret =3D perf_trace_event_reg(tp_event, p_event);
+	if (ret)
+		return ret;
+
+	ret =3D perf_trace_event_open(p_event);
+	if (ret) {
+		perf_trace_event_unreg(p_event);
+		return ret;
+	}
+
+	return 0;
+}
+
 int perf_trace_init(struct perf_event *p_event)
 {
 	struct ftrace_event_call *tp_event;
@@ -130,6 +187,14 @@ int perf_trace_init(struct perf_event *p_event)
 	return ret;
 }
=20
+void perf_trace_destroy(struct perf_event *p_event)
+{
+	mutex_lock(&event_mutex);
+	perf_trace_event_close(p_event);
+	perf_trace_event_unreg(p_event);
+	mutex_unlock(&event_mutex);
+}
+
 int perf_trace_add(struct perf_event *p_event, int flags)
 {
 	struct ftrace_event_call *tp_event =3D p_event->tp_event;
@@ -154,37 +219,6 @@ void perf_trace_del(struct perf_event *p_event, int fl=
ags)
 	hlist_del_rcu(&p_event->hlist_entry);
 }
=20
-void perf_trace_destroy(struct perf_event *p_event)
-{
-	struct ftrace_event_call *tp_event =3D p_event->tp_event;
-	int i;
-
-	mutex_lock(&event_mutex);
-	if (--tp_event->perf_refcount > 0)
-		goto out;
-
-	tp_event->class->reg(tp_event, TRACE_REG_PERF_UNREGISTER);
-
-	/*
-	 * Ensure our callback won't be called anymore. The buffers
-	 * will be freed after that.
-	 */
-	tracepoint_synchronize_unregister();
-
-	free_percpu(tp_event->perf_events);
-	tp_event->perf_events =3D NULL;
-
-	if (!--total_ref_count) {
-		for (i =3D 0; i < PERF_NR_CONTEXTS; i++) {
-			free_percpu(perf_trace_buf[i]);
-			perf_trace_buf[i] =3D NULL;
-		}
-	}
-out:
-	module_put(tp_event->mod);
-	mutex_unlock(&event_mutex);
-}
-
 __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 				       struct pt_regs *regs, int *rctxp)
 {
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index c212a7f..5138fea 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -147,7 +147,8 @@ int trace_event_raw_init(struct ftrace_event_call *call)
 }
 EXPORT_SYMBOL_GPL(trace_event_raw_init);
=20
-int ftrace_event_reg(struct ftrace_event_call *call, enum trace_reg type)
+int ftrace_event_reg(struct ftrace_event_call *call,
+		     enum trace_reg type, void *data)
 {
 	switch (type) {
 	case TRACE_REG_REGISTER:
@@ -170,6 +171,9 @@ int ftrace_event_reg(struct ftrace_event_call *call, en=
um trace_reg type)
 					    call->class->perf_probe,
 					    call);
 		return 0;
+	case TRACE_REG_PERF_OPEN:
+	case TRACE_REG_PERF_CLOSE:
+		return 0;
 #endif
 	}
 	return 0;
@@ -209,7 +213,7 @@ static int ftrace_event_enable_disable(struct ftrace_ev=
ent_call *call,
 				tracing_stop_cmdline_record();
 				call->flags &=3D ~TRACE_EVENT_FL_RECORDED_CMD;
 			}
-			call->class->reg(call, TRACE_REG_UNREGISTER);
+			call->class->reg(call, TRACE_REG_UNREGISTER, NULL);
 		}
 		break;
 	case 1:
@@ -218,7 +222,7 @@ static int ftrace_event_enable_disable(struct ftrace_ev=
ent_call *call,
 				tracing_start_cmdline_record();
 				call->flags |=3D TRACE_EVENT_FL_RECORDED_CMD;
 			}
-			ret =3D call->class->reg(call, TRACE_REG_REGISTER);
+			ret =3D call->class->reg(call, TRACE_REG_REGISTER, NULL);
 			if (ret) {
 				tracing_stop_cmdline_record();
 				pr_info("event trace: Could not enable event "
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 00d527c..5667f89 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1892,7 +1892,8 @@ static __kprobes void kretprobe_perf_func(struct kret=
probe_instance *ri,
 #endif	/* CONFIG_PERF_EVENTS */
=20
 static __kprobes
-int kprobe_register(struct ftrace_event_call *event, enum trace_reg type)
+int kprobe_register(struct ftrace_event_call *event,
+		    enum trace_reg type, void *data)
 {
 	struct trace_probe *tp =3D (struct trace_probe *)event->data;
=20
@@ -1909,6 +1910,9 @@ int kprobe_register(struct ftrace_event_call *event, =
enum trace_reg type)
 	case TRACE_REG_PERF_UNREGISTER:
 		disable_trace_probe(tp, TP_FLAG_PROFILE);
 		return 0;
+	case TRACE_REG_PERF_OPEN:
+	case TRACE_REG_PERF_CLOSE:
+		return 0;
 #endif
 	}
 	return 0;
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 4350015..e23515f 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -17,9 +17,9 @@ static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls=
);
 static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
=20
 static int syscall_enter_register(struct ftrace_event_call *event,
-				 enum trace_reg type);
+				 enum trace_reg type, void *data);
 static int syscall_exit_register(struct ftrace_event_call *event,
-				 enum trace_reg type);
+				 enum trace_reg type, void *data);
=20
 static int syscall_enter_define_fields(struct ftrace_event_call *call);
 static int syscall_exit_define_fields(struct ftrace_event_call *call);
@@ -649,7 +649,7 @@ void perf_sysexit_disable(struct ftrace_event_call *cal=
l)
 #endif /* CONFIG_PERF_EVENTS */
=20
 static int syscall_enter_register(struct ftrace_event_call *event,
-				 enum trace_reg type)
+				 enum trace_reg type, void *data)
 {
 	switch (type) {
 	case TRACE_REG_REGISTER:
@@ -664,13 +664,16 @@ static int syscall_enter_register(struct ftrace_event=
_call *event,
 	case TRACE_REG_PERF_UNREGISTER:
 		perf_sysenter_disable(event);
 		return 0;
+	case TRACE_REG_PERF_OPEN:
+	case TRACE_REG_PERF_CLOSE:
+		return 0;
 #endif
 	}
 	return 0;
 }
=20
 static int syscall_exit_register(struct ftrace_event_call *event,
-				 enum trace_reg type)
+				 enum trace_reg type, void *data)
 {
 	switch (type) {
 	case TRACE_REG_REGISTER:
@@ -685,6 +688,9 @@ static int syscall_exit_register(struct ftrace_event_ca=
ll *event,
 	case TRACE_REG_PERF_UNREGISTER:
 		perf_sysexit_disable(event);
 		return 0;
+	case TRACE_REG_PERF_OPEN:
+	case TRACE_REG_PERF_CLOSE:
+		return 0;
 #endif
 	}
 	return 0;
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPRP7CAAoJEIy3vGnGbaoA70AP/3E0AYgD2YvX2cKF7vJ1ckRP
6jo6+86YfD43DKPTKwF1IQ7STaovf3WB4Xja6kHoOemV2Gq+Knmp9xogoWf5Q7wu
8gpnZMlUURHAymQo0jT5Q8xTYFsAColyPywc5T2Iy7GSHuX98ETPzag0SRp7HQzh
VLc4Upk4yeYEmkPPm8S5yHTc3zVWPNxrSyHwB+94uGJh6bikyfOGmwqlR5I4n/mQ
F/LdN/ZgIdkM0XBtOYf6LBA2WFxNT9Qbs0tQ+p11YtjgNOR8t92XwhB3u1VTGQwE
oVHvnQxajLwOgm2g6YR4EgUivPeRkj8LrNdGXjFsO+RT2n/yMqB0P4VBtJrSHHIz
NCl2h3fGCNPpJWguZvdnFdHmrpcps2VurXMSKZpLiIzu9PWe2bXExFuIt50LHOvp
oZDWcx/8cpi2YgL8Auu9iU4uSiWGtpU9UF0rwpOUBSQEFTF4ZovLOcdS17lZEee1
wqZ1nPCp4VkNcM72WDmohNeDWyyFQdzdHX5JV1he/1gkzjH7et3FGl+Bo2Lecsg4
w9p8Kk0jbIX+YswFRhjRSZqrXpLFAkka5wgX5F5XDavYpHCpnfDLbiTMXss8CRay
tTN4ZYXMCwUZYzRWtA+55oWzAmQ/hln3eDXh8KKXjuadAgUXZc5zjwTbff0Ao9BJ
f2pvp38UuveB18P3Z4uH
=mQg2
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
