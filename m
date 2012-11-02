Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762741Ab2KBNfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:35:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2638 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761945Ab2KBNfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:35:06 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=cOWqjG3jUGoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=WIrT5TUJZlIA:10 a=20KFwNOVAAAA:8 a=qO5MOOkrgEhYrwDurMoA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=zs30g1tXrEa4qzKjUM8A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102133501.083182198@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 09:33:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 17/22] tracing: Separate open function from set_event and available_events
References: <20121102133251.998500247@goodmis.org>
Content-Disposition: inline; filename=0017-tracing-Separate-open-function-from-set_event-and-av.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The open function used by available_events is the same as set_event even
though it uses different seq functions. This causes a side effect of
writing into available_events clearing all events, even though
available_events is suppose to be read only.

There's no reason to keep a single function for just the open and have
both use different functions for everything else. It is a little
confusing and causes strange behavior. Just have each have their own
function.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   46 +++++++++++++++++++++++++--------------=
----
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index dec47e7..cb2df3b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -491,19 +491,6 @@ static void t_stop(struct seq_file *m, void *p)
 	mutex_unlock(&event_mutex);
 }
=20
-static int
-ftrace_event_seq_open(struct inode *inode, struct file *file)
-{
-	const struct seq_operations *seq_ops;
-
-	if ((file->f_mode & FMODE_WRITE) &&
-	    (file->f_flags & O_TRUNC))
-		ftrace_clear_events();
-
-	seq_ops =3D inode->i_private;
-	return seq_open(file, seq_ops);
-}
-
 static ssize_t
 event_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
@@ -980,6 +967,9 @@ show_header(struct file *filp, char __user *ubuf, size_=
t cnt, loff_t *ppos)
 	return r;
 }
=20
+static int ftrace_event_avail_open(struct inode *inode, struct file *file);
+static int ftrace_event_set_open(struct inode *inode, struct file *file);
+
 static const struct seq_operations show_event_seq_ops =3D {
 	.start =3D t_start,
 	.next =3D t_next,
@@ -995,14 +985,14 @@ static const struct seq_operations show_set_event_seq=
_ops =3D {
 };
=20
 static const struct file_operations ftrace_avail_fops =3D {
-	.open =3D ftrace_event_seq_open,
+	.open =3D ftrace_event_avail_open,
 	.read =3D seq_read,
 	.llseek =3D seq_lseek,
 	.release =3D seq_release,
 };
=20
 static const struct file_operations ftrace_set_event_fops =3D {
-	.open =3D ftrace_event_seq_open,
+	.open =3D ftrace_event_set_open,
 	.read =3D seq_read,
 	.write =3D ftrace_event_write,
 	.llseek =3D seq_lseek,
@@ -1078,6 +1068,26 @@ static struct dentry *event_trace_events_dir(void)
 	return d_events;
 }
=20
+static int
+ftrace_event_avail_open(struct inode *inode, struct file *file)
+{
+	const struct seq_operations *seq_ops =3D &show_event_seq_ops;
+
+	return seq_open(file, seq_ops);
+}
+
+static int
+ftrace_event_set_open(struct inode *inode, struct file *file)
+{
+	const struct seq_operations *seq_ops =3D &show_set_event_seq_ops;
+
+	if ((file->f_mode & FMODE_WRITE) &&
+	    (file->f_flags & O_TRUNC))
+		ftrace_clear_events();
+
+	return seq_open(file, seq_ops);
+}
+
 static struct dentry *
 event_subsystem_dir(const char *name, struct dentry *d_events)
 {
@@ -1508,15 +1518,13 @@ static __init int event_trace_init(void)
 		return 0;
=20
 	entry =3D debugfs_create_file("available_events", 0444, d_tracer,
-				    (void *)&show_event_seq_ops,
-				    &ftrace_avail_fops);
+				    NULL, &ftrace_avail_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs "
 			   "'available_events' entry\n");
=20
 	entry =3D debugfs_create_file("set_event", 0644, d_tracer,
-				    (void *)&show_set_event_seq_ops,
-				    &ftrace_set_event_fops);
+				    NULL, &ftrace_set_event_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs "
 			   "'set_event' entry\n");
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQk8wFAAoJEOdOSU1xswtMvuQIAIQUR+BCfYXj45NR5bv1oDuY
VV1u6iDcRnMsnYMJ6iYT6S5SSzpsj0vIuTY2oKXKesdpKz6Wupm5BsLS82Offv8H
3RzUCB7xuf31fHLuik01QPfrYcGP5vXs35jG5YP5j1ok2Qx5zDTgbZC/08ZMW9Fi
rSdDlFel8Cyxk3RSCaSq1QsOrYg4QOQzN1h6qoFlVwxfWzJUwv40O21wL0DqEgdX
VAHpJEOcaEy/kDOpiX4+tCf7sFFYm52WgXg6cltUM0/e+VqOXtzF22AX8Rp6yBCs
X959c4PaPbnu0U0+Z+xwjSdlvgbtSOtWEaRI0LYNDJZPVHw6Yoga9bjgtJadhAU=
=F82Z
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
