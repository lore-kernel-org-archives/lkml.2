Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492Ab2EIQ7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:59:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25110 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760363Ab2EIQ6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:58:40 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=qiI5MMBm31MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=H3gl3DrdBYqlT2BT5dkA:9 a=SW_ZTkOx0ToRB8nugw8A:7 a=QEXdDO2ut3YA:10 a=YTw0oxLd7MoA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=adJ48WtIPIj6hS9BongA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120509165838.602434589@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 12:57:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/3] tracing: Use seq_*_private interface for some seq files
References: <20120509165751.114716410@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Use-seq_-_private-interface-for-some-seq-fil.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

It's appropriate to use __seq_open_private interface to open
some of trace seq files, because it covers all steps we are
duplicating in tracing code - zallocating the iterator and
setting it as seq_file's private.

Using this for following files:
  trace
  available_filter_functions
  enabled_functions

Link: http://lkml.kernel.org/r/1335342219-2782-5-git-send-email-jolsa@redha=
t.com

Signed-off-by: Jiri Olsa <jolsa@redhat.com>

[
 Fixed warnings for:
   kernel/trace/trace.c: In function '__tracing_open':
   kernel/trace/trace.c:2418:11: warning: unused variable 'ret' [-Wunused-v=
ariable]
   kernel/trace/trace.c:2417:19: warning: unused variable 'm' [-Wunused-var=
iable]
]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   44 +++++++++++---------------------------------
 kernel/trace/trace.c  |   30 +++++-------------------------
 2 files changed, 16 insertions(+), 58 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0fa92f6..cf81f27 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2469,57 +2469,35 @@ static int
 ftrace_avail_open(struct inode *inode, struct file *file)
 {
 	struct ftrace_iterator *iter;
-	int ret;
=20
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
=20
-	iter =3D kzalloc(sizeof(*iter), GFP_KERNEL);
-	if (!iter)
-		return -ENOMEM;
-
-	iter->pg =3D ftrace_pages_start;
-	iter->ops =3D &global_ops;
-
-	ret =3D seq_open(file, &show_ftrace_seq_ops);
-	if (!ret) {
-		struct seq_file *m =3D file->private_data;
-
-		m->private =3D iter;
-	} else {
-		kfree(iter);
+	iter =3D __seq_open_private(file, &show_ftrace_seq_ops, sizeof(*iter));
+	if (iter) {
+		iter->pg =3D ftrace_pages_start;
+		iter->ops =3D &global_ops;
 	}
=20
-	return ret;
+	return iter ? 0 : -ENOMEM;
 }
=20
 static int
 ftrace_enabled_open(struct inode *inode, struct file *file)
 {
 	struct ftrace_iterator *iter;
-	int ret;
=20
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
=20
-	iter =3D kzalloc(sizeof(*iter), GFP_KERNEL);
-	if (!iter)
-		return -ENOMEM;
-
-	iter->pg =3D ftrace_pages_start;
-	iter->flags =3D FTRACE_ITER_ENABLED;
-	iter->ops =3D &global_ops;
-
-	ret =3D seq_open(file, &show_ftrace_seq_ops);
-	if (!ret) {
-		struct seq_file *m =3D file->private_data;
-
-		m->private =3D iter;
-	} else {
-		kfree(iter);
+	iter =3D __seq_open_private(file, &show_ftrace_seq_ops, sizeof(*iter));
+	if (iter) {
+		iter->pg =3D ftrace_pages_start;
+		iter->flags =3D FTRACE_ITER_ENABLED;
+		iter->ops =3D &global_ops;
 	}
=20
-	return ret;
+	return iter ? 0 : -ENOMEM;
 }
=20
 static void ftrace_filter_reset(struct ftrace_hash *hash)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f11a285..4fb10ef 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2413,15 +2413,13 @@ static struct trace_iterator *
 __tracing_open(struct inode *inode, struct file *file)
 {
 	long cpu_file =3D (long) inode->i_private;
-	void *fail_ret =3D ERR_PTR(-ENOMEM);
 	struct trace_iterator *iter;
-	struct seq_file *m;
-	int cpu, ret;
+	int cpu;
=20
 	if (tracing_disabled)
 		return ERR_PTR(-ENODEV);
=20
-	iter =3D kzalloc(sizeof(*iter), GFP_KERNEL);
+	iter =3D __seq_open_private(file, &tracer_seq_ops, sizeof(*iter));
 	if (!iter)
 		return ERR_PTR(-ENOMEM);
=20
@@ -2478,32 +2476,15 @@ __tracing_open(struct inode *inode, struct file *fi=
le)
 		tracing_iter_reset(iter, cpu);
 	}
=20
-	ret =3D seq_open(file, &tracer_seq_ops);
-	if (ret < 0) {
-		fail_ret =3D ERR_PTR(ret);
-		goto fail_buffer;
-	}
-
-	m =3D file->private_data;
-	m->private =3D iter;
-
 	mutex_unlock(&trace_types_lock);
=20
 	return iter;
=20
- fail_buffer:
-	for_each_tracing_cpu(cpu) {
-		if (iter->buffer_iter[cpu])
-			ring_buffer_read_finish(iter->buffer_iter[cpu]);
-	}
-	free_cpumask_var(iter->started);
-	tracing_start();
  fail:
 	mutex_unlock(&trace_types_lock);
 	kfree(iter->trace);
-	kfree(iter);
-
-	return fail_ret;
+	seq_release_private(inode, file);
+	return ERR_PTR(-ENOMEM);
 }
=20
 int tracing_open_generic(struct inode *inode, struct file *filp)
@@ -2539,11 +2520,10 @@ static int tracing_release(struct inode *inode, str=
uct file *file)
 	tracing_start();
 	mutex_unlock(&trace_types_lock);
=20
-	seq_release(inode, file);
 	mutex_destroy(&iter->mutex);
 	free_cpumask_var(iter->started);
 	kfree(iter->trace);
-	kfree(iter);
+	seq_release_private(inode, file);
 	return 0;
 }
=20
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPqqI+AAoJEIy3vGnGbaoAQpwQALy0Mfn/MYUWKOwxvSiIVKGy
8Fa61qSQRXfrfMwWdg589/pM64GmCY3JgOR7zBhwE+Nwm4HuIpqOJd8KxlrlSKJS
76zJXoc8OED96vX/d7WhMoOQLxyi8lm3FZRgPOLTkjUeT56xK1GWUr/uNXUVokP+
QWGpUJBujmmNg09pR1a784JkTTWeEc5t63DtxOhbr+adfCkj9zMUycmR4sR1ot4y
zKk4pLkPLqkCkyO4vSQ7eNtEM5kFs8KLFepGTc1xHcN7bsF6B292beEFho2+V2aq
7NzvcvpBa1+zo1nlAgV7fvHVzxVCsL14cOKdBW0GaXKBhKmfM2COmJOas1C9mkZq
kx/l0kbL7CRTePXq7ry944eveXQkKzxZHXPYQa3NHbrPaYItczuuMibuJPftHRbg
otZvYQ5M2HcJu2RSDKGzh2CUjAon/KBUNO6Rwcej/lltTDvLyaV06/gfe01nxxWO
yzWfJy2LgEHp/lXIEiTXTYU+cJ7+BxEPuuh0nFNXKz40E70Reb1bueTOtMze+dL3
9B7tJeS9dG7kmhYsoe34iXHeD8DCw3NEfbElYsy4O//wXVZ3s+38mB/IR9PuZeym
FtYTl4OBCyikj3br0N2lsd3CTZrJJYPQ5yy+OKkYRzaFJVotDK6v9iaUTBWJZGYX
/Y5SIez5F9Q8ZZ4GcCGv
=ysBY
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
