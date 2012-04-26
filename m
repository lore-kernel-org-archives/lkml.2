Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab2DZCi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 22:38:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10757 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab2DZChK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 22:37:10 -0400
X-Authority-Analysis: v=2.0 cv=MNHiabll c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=hye7S_sYQ4EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=5KKST3nhYfKchGJsNdYA:9 a=AZVu-Z0au8g6cMJEbnkA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=uGREW3pb6d3YDRYC_QgA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120426023707.067992109@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 25 Apr 2012 22:29:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/6][RFC] ftrace: Remove extra helper functions
References: <20120426022922.683707508@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Remove-extra-helper-functions.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The ftrace_record_ip() and ftrace_alloc_dyn_node() were from the
time of the ftrace daemon. Although they were still used, they
still make things a bit more complex than necessary.

Move the code into the one function that uses it, and remove the
helper functions.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   61 +++++++++++++++++++--------------------------=
----
 1 file changed, 24 insertions(+), 37 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6a19e81..4e608f8 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1520,35 +1520,6 @@ static void ftrace_hash_rec_enable(struct ftrace_ops=
 *ops,
 	__ftrace_hash_rec_update(ops, filter_hash, 1);
 }
=20
-static struct dyn_ftrace *ftrace_alloc_dyn_node(unsigned long ip)
-{
-	if (ftrace_pages->index =3D=3D ftrace_pages->size) {
-		/* We should have allocated enough */
-		if (WARN_ON(!ftrace_pages->next))
-			return NULL;
-		ftrace_pages =3D ftrace_pages->next;
-	}
-
-	return &ftrace_pages->records[ftrace_pages->index++];
-}
-
-static struct dyn_ftrace *
-ftrace_record_ip(unsigned long ip)
-{
-	struct dyn_ftrace *rec;
-
-	if (ftrace_disabled)
-		return NULL;
-
-	rec =3D ftrace_alloc_dyn_node(ip);
-	if (!rec)
-		return NULL;
-
-	rec->ip =3D ip;
-
-	return rec;
-}
-
 static void print_ip_ins(const char *fmt, unsigned char *p)
 {
 	int i;
@@ -3715,7 +3686,9 @@ static int ftrace_process_locs(struct module *mod,
 			       unsigned long *start,
 			       unsigned long *end)
 {
+	struct ftrace_page *start_pg;
 	struct ftrace_page *pg;
+	struct dyn_ftrace *rec;
 	unsigned long count;
 	unsigned long *p;
 	unsigned long addr;
@@ -3730,8 +3703,8 @@ static int ftrace_process_locs(struct module *mod,
 	sort(start, count, sizeof(*start),
 	     ftrace_cmp_ips, ftrace_swap_ips);
=20
-	pg =3D ftrace_allocate_pages(count);
-	if (!pg)
+	start_pg =3D ftrace_allocate_pages(count);
+	if (!start_pg)
 		return -ENOMEM;
=20
 	mutex_lock(&ftrace_lock);
@@ -3744,7 +3717,7 @@ static int ftrace_process_locs(struct module *mod,
 	if (!mod) {
 		WARN_ON(ftrace_pages || ftrace_pages_start);
 		/* First initialization */
-		ftrace_pages =3D ftrace_pages_start =3D pg;
+		ftrace_pages =3D ftrace_pages_start =3D start_pg;
 	} else {
 		if (!ftrace_pages)
 			goto out;
@@ -3755,11 +3728,11 @@ static int ftrace_process_locs(struct module *mod,
 				ftrace_pages =3D ftrace_pages->next;
 		}
=20
-		ftrace_pages->next =3D pg;
-		ftrace_pages =3D pg;
+		ftrace_pages->next =3D start_pg;
 	}
=20
 	p =3D start;
+	pg =3D start_pg;
 	while (p < end) {
 		addr =3D ftrace_call_adjust(*p++);
 		/*
@@ -3770,12 +3743,26 @@ static int ftrace_process_locs(struct module *mod,
 		 */
 		if (!addr)
 			continue;
-		if (!ftrace_record_ip(addr))
-			break;
+
+		if (pg->index =3D=3D pg->size) {
+			/* We should have allocated enough */
+			if (WARN_ON(!pg->next))
+				break;
+			pg =3D pg->next;
+		}
+
+		rec =3D &pg->records[pg->index++];
+		rec->ip =3D addr;
 	}
=20
+	/* We should have used all pages */
+	WARN_ON(pg->next);
+
+	/* Assign the last page to ftrace_pages */
+	ftrace_pages =3D pg;
+
 	/* These new locations need to be initialized */
-	ftrace_new_pgs =3D pg;
+	ftrace_new_pgs =3D start_pg;
=20
 	/*
 	 * We only need to disable interrupts on start up
--=20
1.7.9.5



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPmLTTAAoJEIy3vGnGbaoArFkQAN9moMxc3bfAMQgBgoiQBQbz
ZgJy5X7CyOlLKBY9C2KVpcQhq6lI5ePXF5gFEpynaj5jyffxZCs2/NuDHDiO6Mst
gFWFba8f+mBYpy+qIFbF1nP75OnEiVj6IPpg0WFruHwRogvpwNXMMOGN+hnUvWZ3
r5AvNMR1QAVwL2FUbI4xOpmDqRRlL+/nK+Wtbj7JBYh+YlPXM5FTttaDeepehyZY
wo8iCmx3OrDIObCplBNPP3IX4N4boukNX0bO5zlZBYa4fpuTHnkCZ7hEe3IfydIF
Zj2PXVUGQK7U5cTBM7TvPQVAG7rRACDNusa1tMKmtK+txXMwhQEtY2po0hDDv5Y6
XYo+s2U0VlnAzqwgSZT3EQZkpzy8dQBIkiOObWj/n/UfEtN5Rm3Pl2nmaS5abheV
/qnbgI74NsWjFBYUqkFr0ccBHVreBXZ8Jz5v4deRUEgoba6BugAlUK3I+xHjgODW
WMKBz7U8X33IOSmZr3Ueq8jHNg4ChPguMUoMivO0TH82OJainCgETlrDZc5Xnl6S
RH9YCLnJ9z9DHqSjYjFDjJfqm9R/kcg1odJ3binZpDu2EWJ1X5ZXuuDHm+RkB5q4
FaSd8VSzZVNFoOseokvUuI13P0A4dRs5VOWkeGGkPhNSCLFy1W6cJj3VDpsbKLNd
biVhZoySkeCt8065IQmI
=LTHr
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
