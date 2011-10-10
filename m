Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab1JJTTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:19:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45813 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab1JJTTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:19:45 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=vhdKIqpQuCYA:10 a=bxbSl_UX3BEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=3nbZYyFuAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=oXhnnvYd_aZm0Kr8ZJsA:9 a=sDn2ZyGRuRaj9eUbMhMA:7 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=X3VK1Gp7Z8F2UsKt70oA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010191943.336954413@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 15:17:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>, stable@kernel.org
Subject: [PATCH 1/2] ftrace/kprobes: Fix not to delete probes if in use
References: <20111010191706.044816068@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-kprobes-Fix-not-to-delete-probes-if-in-use.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix kprobe-tracer not to delete a probe if the probe is in use.
In that case, delete operation will return -EBUSY.

This bug can cause a kernel panic if enabled probes are deleted
during perf record.

(Add some probes on functions)
sh-4.2# perf probe --del probe:\*
sh-4.2# exit
(kernel panic)

This is originally reported on the fedora bugzilla:

 https://bugzilla.redhat.com/show_bug.cgi?id=3D742383

I've also checked that this problem doesn't happen on
tracepoints when module removing because perf event
locks target module.

$ sudo ./perf record -e xfs:\* -aR sh
sh-4.2# rmmod xfs
ERROR: Module xfs is in use
sh-4.2# exit
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.203 MB perf.data (~8862 samples) ]

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: stable@kernel.org
Link: http://lkml.kernel.org/r/20111004104438.14591.6553.stgit@fedora15
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |   58 ++++++++++++++++++++++++++++++++++++---=
---
 1 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 5fb3697..00d527c 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -836,11 +836,17 @@ static void __unregister_trace_probe(struct trace_pro=
be *tp)
 }
=20
 /* Unregister a trace_probe and probe_event: call with locking probe_lock =
*/
-static void unregister_trace_probe(struct trace_probe *tp)
+static int unregister_trace_probe(struct trace_probe *tp)
 {
+	/* Enabled event can not be unregistered */
+	if (trace_probe_is_enabled(tp))
+		return -EBUSY;
+
 	__unregister_trace_probe(tp);
 	list_del(&tp->list);
 	unregister_probe_event(tp);
+
+	return 0;
 }
=20
 /* Register a trace_probe and probe_event */
@@ -854,7 +860,9 @@ static int register_trace_probe(struct trace_probe *tp)
 	/* Delete old (same name) event if exist */
 	old_tp =3D find_trace_probe(tp->call.name, tp->call.class->system);
 	if (old_tp) {
-		unregister_trace_probe(old_tp);
+		ret =3D unregister_trace_probe(old_tp);
+		if (ret < 0)
+			goto end;
 		free_trace_probe(old_tp);
 	}
=20
@@ -892,6 +900,7 @@ static int trace_probe_module_callback(struct notifier_=
block *nb,
 	mutex_lock(&probe_lock);
 	list_for_each_entry(tp, &probe_list, list) {
 		if (trace_probe_within_module(tp, mod)) {
+			/* Don't need to check busy - this should have gone. */
 			__unregister_trace_probe(tp);
 			ret =3D __register_trace_probe(tp);
 			if (ret)
@@ -1205,10 +1214,11 @@ static int create_trace_probe(int argc, char **argv)
 			return -ENOENT;
 		}
 		/* delete an event */
-		unregister_trace_probe(tp);
-		free_trace_probe(tp);
+		ret =3D unregister_trace_probe(tp);
+		if (ret =3D=3D 0)
+			free_trace_probe(tp);
 		mutex_unlock(&probe_lock);
-		return 0;
+		return ret;
 	}
=20
 	if (argc < 2) {
@@ -1317,18 +1327,29 @@ error:
 	return ret;
 }
=20
-static void release_all_trace_probes(void)
+static int release_all_trace_probes(void)
 {
 	struct trace_probe *tp;
+	int ret =3D 0;
=20
 	mutex_lock(&probe_lock);
+	/* Ensure no probe is in use. */
+	list_for_each_entry(tp, &probe_list, list)
+		if (trace_probe_is_enabled(tp)) {
+			ret =3D -EBUSY;
+			goto end;
+		}
 	/* TODO: Use batch unregistration */
 	while (!list_empty(&probe_list)) {
 		tp =3D list_entry(probe_list.next, struct trace_probe, list);
 		unregister_trace_probe(tp);
 		free_trace_probe(tp);
 	}
+
+end:
 	mutex_unlock(&probe_lock);
+
+	return ret;
 }
=20
 /* Probes listing interfaces */
@@ -1380,9 +1401,13 @@ static const struct seq_operations probes_seq_op =3D=
 {
=20
 static int probes_open(struct inode *inode, struct file *file)
 {
-	if ((file->f_mode & FMODE_WRITE) &&
-	    (file->f_flags & O_TRUNC))
-		release_all_trace_probes();
+	int ret;
+
+	if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_TRUNC)) {
+		ret =3D release_all_trace_probes();
+		if (ret < 0)
+			return ret;
+	}
=20
 	return seq_open(file, &probes_seq_op);
 }
@@ -2055,6 +2080,21 @@ static __init int kprobe_trace_self_tests_init(void)
=20
 	ret =3D target(1, 2, 3, 4, 5, 6);
=20
+	/* Disable trace points before removing it */
+	tp =3D find_trace_probe("testprobe", KPROBE_EVENT_SYSTEM);
+	if (WARN_ON_ONCE(tp =3D=3D NULL)) {
+		pr_warning("error on getting test probe.\n");
+		warn++;
+	} else
+		disable_trace_probe(tp, TP_FLAG_TRACE);
+
+	tp =3D find_trace_probe("testprobe2", KPROBE_EVENT_SYSTEM);
+	if (WARN_ON_ONCE(tp =3D=3D NULL)) {
+		pr_warning("error on getting 2nd test probe.\n");
+		warn++;
+	} else
+		disable_trace_probe(tp, TP_FLAG_TRACE);
+
 	ret =3D command_trace_probe("-:testprobe");
 	if (WARN_ON_ONCE(ret)) {
 		pr_warning("error on deleting a probe.\n");
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOk0VPAAoJEIy3vGnGbaoA45EQAJmPzYV1ZtGXor0zJD+Yk35b
fKJrB+EtrGHlA3DanR3CWvELXxMjYEpnM5fuVhB+T279pQgDGu3DRAYq32KKFxyF
h1cOJv2uSo/v/8VY/x7TpnSZEYtsVLLIcmVkyF5KdOy3Qi4P7pGlFg2v2Vge+EMZ
0JeqpEhtTZ+u+j8uje2i+J8kIFPzbdSMQ3BwCmzqHB6tpp6/X2sdBlPTilKXxEOE
/pvPelYkaGHhr1hmHonKPL6zQKZ5I7QIjBh8RxVkUrmHSj1YuEHqPW3TY6OnaMy9
WKF/FQPdRteF+DnaCPjiY0d7waTyZNoUHMkVLcEAXDs8OohrokjE800+Wyvai2i/
HgDc7/cjdjNRzrK3ndiLBEOhmupXzYrxqFFJn8bywpwLNNJmB3qY7b4XE49IYQL2
wAPuMI8rvT+RRwapnKSr4dE0dzFEeP8fwqhGojGfHdTrJ3nuK2s76WOcxIuSoh4Y
aLUA7esSxXOPTw8ErcirqtoUgMV5JJYXXk42n72PGUFELTK1BK4NvL/N4qJHt0jj
Qn2qo86WFR8u4RyHTWuci+2ddw8x6jSR5Ne4bMv3Hvi1jsCBM1+rMNo3ZAdhXbwb
6siqg5a1DNq4r4RG+QK4KlfCNJx2VLEAUIM28sC6cFhm2GAwRN7uSToccd201qRm
ILD0DRyovRw8ce+8xWXe
=6CpG
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
