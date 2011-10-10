Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab1JJNnC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:43:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60188 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab1JJNlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:41:45 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=vhdKIqpQuCYA:10 a=pTplU-xATcUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=ZZoUqqbgIFapVa-vX_4A:9 a=QEXdDO2ut3YA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=eMO72KH27by3Xy1Y_SAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010134144.310010179@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 09:39:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>
Subject: [PATCH 15/20] trace: Add a new readonly entry to report total buffer size
References: <20111010133852.829771373@goodmis.org>
Content-Disposition: inline; filename=0015-trace-Add-a-new-readonly-entry-to-report-total-buffe.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

The current file "buffer_size_kb" reports the size of per-cpu buffer and
not the overall memory allocated which could be misleading. A new file
"buffer_total_size_kb" adds up all the enabled CPU buffer sizes and
reports it. This is only a readonly entry.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: David Sharp <dhsharp@google.com>
Link: http://lkml.kernel.org/r/1313531179-9323-2-git-send-email-vnagarnaik@=
google.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e5df02c..0117678 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3569,6 +3569,30 @@ tracing_entries_write(struct file *filp, const char =
__user *ubuf,
 }
=20
 static ssize_t
+tracing_total_entries_read(struct file *filp, char __user *ubuf,
+				size_t cnt, loff_t *ppos)
+{
+	struct trace_array *tr =3D filp->private_data;
+	char buf[64];
+	int r, cpu;
+	unsigned long size =3D 0, expanded_size =3D 0;
+
+	mutex_lock(&trace_types_lock);
+	for_each_tracing_cpu(cpu) {
+		size +=3D tr->entries >> 10;
+		if (!ring_buffer_expanded)
+			expanded_size +=3D trace_buf_size >> 10;
+	}
+	if (ring_buffer_expanded)
+		r =3D sprintf(buf, "%lu\n", size);
+	else
+		r =3D sprintf(buf, "%lu (expanded: %lu)\n", size, expanded_size);
+	mutex_unlock(&trace_types_lock);
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static ssize_t
 tracing_free_buffer_write(struct file *filp, const char __user *ubuf,
 			  size_t cnt, loff_t *ppos)
 {
@@ -3739,6 +3763,12 @@ static const struct file_operations tracing_entries_=
fops =3D {
 	.llseek		=3D generic_file_llseek,
 };
=20
+static const struct file_operations tracing_total_entries_fops =3D {
+	.open		=3D tracing_open_generic,
+	.read		=3D tracing_total_entries_read,
+	.llseek		=3D generic_file_llseek,
+};
+
 static const struct file_operations tracing_free_buffer_fops =3D {
 	.write		=3D tracing_free_buffer_write,
 	.release	=3D tracing_free_buffer_release,
@@ -4450,6 +4480,9 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("buffer_size_kb", 0644, d_tracer,
 			&global_trace, &tracing_entries_fops);
=20
+	trace_create_file("buffer_total_size_kb", 0444, d_tracer,
+			&global_trace, &tracing_total_entries_fops);
+
 	trace_create_file("free_buffer", 0644, d_tracer,
 			&global_trace, &tracing_free_buffer_fops);
=20
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkvYYAAoJEIy3vGnGbaoAeuQQANukHnPr1qEIclYkTyxRXJLa
rhv4VaTPxlZADw5iHV2KVhGreEjka9A9b39ILERQY3ZK/Gi4/aNoo/Xdm4ZGIA27
1j265Cei/hbFs1ksqvlY04AYv2dc4GZmLwMBn0gM4V5t1AJYvBgsmO+09c7EX2MU
VhSpdrgwzf0J4uymlHx+vTQibvYPtl8Wt40pVZj23K3/x4GpoH6lMiMGsavUj3XY
pDx3g/IRm0eFKGRnPinQgktrzOux2L6kZljLmz3yn6MUsnQ10SEPh+qL0uR9unUK
K7/l3YO/T01oNjRYXMNO0byC4Iu+SIR6mWRD10GiKurlGZwSJthbh6sYCSuxuSBg
EntmcLr5KzhjxEm+4IvEw4ctqyggKJ8cVN3tuvq0jceV58S8aIKAm5vW4dmMgdy+
ilg1BruTJCx2h/0C89nR3yCrf5BR9f638PDTY0wKVNWoVaQTkySorcfAUP07iRof
MjbnKsugaC52I5WiYGx4GR7TQagl2d9VC0mcmMS8D1FDpqE1/h5K4jP/VVuGeQ63
/P2jNpptR1rvUBaTOB7bePEPptiPv7QVUl2L000G2kt4GLrq5DetG2S86JFwAdDW
nKUytg04fMDXXHhnss7sD1HpjZYaH78vhyjxnCZfUYvVZDGnIUL4b8azMqcik760
5LA4jML7YYyVD+xJm1rk
=ib1z
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
