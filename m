Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab1LUMj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:39:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab1LUMiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:38:12 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=s9cERdXe6HgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=m4bYjdwJGVxnwUV7rP0A:9 a=uRUC3w-i_vta6kRmX2MA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=mca0LLFlsYW6tbGkEOYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111221123808.987851521@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 07:36:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 11/16] ftrace: Allow other users of function tracing to use the output listing
References: <20111221123624.193898256@goodmis.org>
Content-Disposition: inline; filename=0011-ftrace-Allow-other-users-of-function-tracing-to-use-.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The function tracer is set up to allow any other subsystem (like perf)
to use it. Ftrace already has a way to list what functions are enabled
by the global_ops. It would be very helpful to let other users of
the function tracer to be able to use the same code.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |   35 +++++++++++++++++++++++++++++++++++
 kernel/trace/ftrace.c  |   41 +++++++++++++++++++++++++----------------
 2 files changed, 60 insertions(+), 16 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 31b9fd7..aa7559f 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -202,6 +202,14 @@ enum {
 	FTRACE_UPDATE_MAKE_NOP,
 };
=20
+enum {
+	FTRACE_ITER_FILTER	=3D (1 << 0),
+	FTRACE_ITER_NOTRACE	=3D (1 << 1),
+	FTRACE_ITER_PRINTALL	=3D (1 << 2),
+	FTRACE_ITER_HASH	=3D (1 << 3),
+	FTRACE_ITER_ENABLED	=3D (1 << 4),
+};
+
 void arch_ftrace_update_code(int command);
=20
 struct ftrace_rec_iter;
@@ -217,6 +225,15 @@ int ftrace_location(unsigned long ip);
=20
 extern ftrace_func_t ftrace_trace_function;
=20
+int ftrace_regex_open(struct ftrace_ops *ops, int flag,
+		  struct inode *inode, struct file *file);
+ssize_t ftrace_filter_write(struct file *file, const char __user *ubuf,
+			    size_t cnt, loff_t *ppos);
+ssize_t ftrace_notrace_write(struct file *file, const char __user *ubuf,
+			     size_t cnt, loff_t *ppos);
+loff_t ftrace_regex_lseek(struct file *file, loff_t offset, int origin);
+int ftrace_regex_release(struct inode *inode, struct file *file);
+
 /* defined in arch */
 extern int ftrace_ip_converted(unsigned long ip);
 extern int ftrace_dyn_arch_init(void *data);
@@ -311,6 +328,24 @@ static inline int ftrace_text_reserved(void *start, vo=
id *end)
 {
 	return 0;
 }
+
+/*
+ * Again users of functions that have ftrace_ops may not
+ * have them defined when ftrace is not enabled, but these
+ * functions may still be called. Use a macro instead of inline.
+ */
+#define ftrace_regex_open(ops, flag, inod, file) ({ -ENODEV; })
+
+static inline ssize_t ftrace_filter_write(struct file *file, const char __=
user *ubuf,
+			    size_t cnt, loff_t *ppos) { return -ENODEV; }
+static inline ssize_t ftrace_notrace_write(struct file *file, const char _=
_user *ubuf,
+			     size_t cnt, loff_t *ppos) { return -ENODEV; }
+static inline loff_t ftrace_regex_lseek(struct file *file, loff_t offset, =
int origin)
+{
+	return -ENODEV;
+}
+static inline int
+ftrace_regex_release(struct inode *inode, struct file *file) { return -ENO=
DEV; }
 #endif /* CONFIG_DYNAMIC_FTRACE */
=20
 /* totally disable ftrace - can not re-enable after this */
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e1ee07f..5b105c5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2134,14 +2134,6 @@ static int __init ftrace_dyn_table_alloc(unsigned lo=
ng num_to_init)
 	return 0;
 }
=20
-enum {
-	FTRACE_ITER_FILTER	=3D (1 << 0),
-	FTRACE_ITER_NOTRACE	=3D (1 << 1),
-	FTRACE_ITER_PRINTALL	=3D (1 << 2),
-	FTRACE_ITER_HASH	=3D (1 << 3),
-	FTRACE_ITER_ENABLED	=3D (1 << 4),
-};
-
 #define FTRACE_BUFF_MAX (KSYM_SYMBOL_LEN+4) /* room for wildcards */
=20
 struct ftrace_iterator {
@@ -2249,7 +2241,7 @@ static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct ftrace_iterator *iter =3D m->private;
-	struct ftrace_ops *ops =3D &global_ops;
+	struct ftrace_ops *ops =3D iter->ops;
 	struct dyn_ftrace *rec =3D NULL;
=20
 	if (unlikely(ftrace_disabled))
@@ -2305,7 +2297,7 @@ static void reset_iter_read(struct ftrace_iterator *i=
ter)
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
 	struct ftrace_iterator *iter =3D m->private;
-	struct ftrace_ops *ops =3D &global_ops;
+	struct ftrace_ops *ops =3D iter->ops;
 	void *p =3D NULL;
 	loff_t l;
=20
@@ -2414,6 +2406,7 @@ ftrace_avail_open(struct inode *inode, struct file *f=
ile)
 		return -ENOMEM;
=20
 	iter->pg =3D ftrace_pages_start;
+	iter->ops =3D &global_ops;
=20
 	ret =3D seq_open(file, &show_ftrace_seq_ops);
 	if (!ret) {
@@ -2442,6 +2435,7 @@ ftrace_enabled_open(struct inode *inode, struct file =
*file)
=20
 	iter->pg =3D ftrace_pages_start;
 	iter->flags =3D FTRACE_ITER_ENABLED;
+	iter->ops =3D &global_ops;
=20
 	ret =3D seq_open(file, &show_ftrace_seq_ops);
 	if (!ret) {
@@ -2462,7 +2456,23 @@ static void ftrace_filter_reset(struct ftrace_hash *=
hash)
 	mutex_unlock(&ftrace_lock);
 }
=20
-static int
+/**
+ * ftrace_regex_open - initialize function tracer filter files
+ * @ops: The ftrace_ops that hold the hash filters
+ * @flag: The type of filter to process
+ * @inode: The inode, usually passed in to your open routine
+ * @file: The file, usually passed in to your open routine
+ *
+ * ftrace_regex_open() initializes the filter files for the
+ * @ops. Depending on @flag it may process the filter hash or
+ * the notrace hash of @ops. With this called from the open
+ * routine, you can use ftrace_filter_write() for the write
+ * routine if @flag has FTRACE_ITER_FILTER set, or
+ * ftrace_notrace_write() if @flag has FTRACE_ITER_NOTRACE set.
+ * ftrace_regex_lseek() should be used as the lseek routine, and
+ * release must call ftrace_regex_release().
+ */
+int
 ftrace_regex_open(struct ftrace_ops *ops, int flag,
 		  struct inode *inode, struct file *file)
 {
@@ -2542,7 +2552,7 @@ ftrace_notrace_open(struct inode *inode, struct file =
*file)
 				 inode, file);
 }
=20
-static loff_t
+loff_t
 ftrace_regex_lseek(struct file *file, loff_t offset, int origin)
 {
 	loff_t ret;
@@ -3095,14 +3105,14 @@ out_unlock:
 	return ret;
 }
=20
-static ssize_t
+ssize_t
 ftrace_filter_write(struct file *file, const char __user *ubuf,
 		    size_t cnt, loff_t *ppos)
 {
 	return ftrace_regex_write(file, ubuf, cnt, ppos, 1);
 }
=20
-static ssize_t
+ssize_t
 ftrace_notrace_write(struct file *file, const char __user *ubuf,
 		     size_t cnt, loff_t *ppos)
 {
@@ -3292,8 +3302,7 @@ static void __init set_ftrace_early_filters(void)
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 }
=20
-static int
-ftrace_regex_release(struct inode *inode, struct file *file)
+int ftrace_regex_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m =3D (struct seq_file *)file->private_data;
 	struct ftrace_iterator *iter;
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8dMxAAoJEIy3vGnGbaoAXvsP/2lBiWXYHLlIhbrNySMUYfFF
C4ooAFuh1AYVZnpnX6yX5nSmHD7KQk3PHtJkgOPYhMRFatllwmqxpZdYSEzxBvUo
LqSth3swUAKgTDSVWtsXU3JG3AS3836q0JfaZ56Quk+HtcR4MqA82Gcz7Z0V45I9
3vDOKXx2kQZYwDjyEkjNhwioRcljywY1hMSPJIOESiEZxTRmmeT5ZHU1x5GgyLij
onZgaXfRGiix5/q7WmxRWmnREliHm+AXNE4E6IoRwqSZztL+5GkiNzSupwkN71QX
FdHLkXn2/RgQTv7vx8bvuomF806QEqw6XMWoCAtn+1/i9SCbNF4k2T57y2rVRsuC
RoiHQFh9AoC/f75PLcrAf1gatF78jvC9geAD35I34ZoThr2kdwWWr5cWjCKcZ9Yx
VRrJVHjXMugKhGLzfTymEDf0/VyeyWPqN+buelxMLsrQqTR85hQa9vCU41OPpFPV
/M9l/f8KvrQuq1uVQkOlFniRHqC6G5QhW9SjUd/0WAMbtWNk2HHrAXidtbK9ol5Y
zq85GdLzIn5sKuyQYe4l2yQLQswWqnfmBQk4fDheFWeaUETV93gSnB3o93MVUEXV
A/Aq6o/gLJKXrzW8ZwEfVcvQpfizS+njWNiybfMnp1/ms9DATtKhgsMwwNdVSmBT
Ar1IXjHeieCH9zfhEApp
=4QAU
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
