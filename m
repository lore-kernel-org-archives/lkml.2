Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946003Ab2ERNK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:10:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18640 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967202Ab2ERNKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:10:51 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=8ypjEO02qyYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=5KKST3nhYfKchGJsNdYA:9 a=AZVu-Z0au8g6cMJEbnkA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=McqO6jb0Q3gc4cdrnH0A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120518131050.256420374@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 09:09:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 09/15] ftrace: Remove extra helper functions
References: <20120518130858.392919640@goodmis.org>
Content-Disposition: inline; filename=0009-ftrace-Remove-extra-helper-functions.patch
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
index 53ed01e..e10f9e5 100644
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
@@ -3693,7 +3664,9 @@ static int ftrace_process_locs(struct module *mod,
 			       unsigned long *start,
 			       unsigned long *end)
 {
+	struct ftrace_page *start_pg;
 	struct ftrace_page *pg;
+	struct dyn_ftrace *rec;
 	unsigned long count;
 	unsigned long *p;
 	unsigned long addr;
@@ -3708,8 +3681,8 @@ static int ftrace_process_locs(struct module *mod,
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
@@ -3722,7 +3695,7 @@ static int ftrace_process_locs(struct module *mod,
 	if (!mod) {
 		WARN_ON(ftrace_pages || ftrace_pages_start);
 		/* First initialization */
-		ftrace_pages =3D ftrace_pages_start =3D pg;
+		ftrace_pages =3D ftrace_pages_start =3D start_pg;
 	} else {
 		if (!ftrace_pages)
 			goto out;
@@ -3733,11 +3706,11 @@ static int ftrace_process_locs(struct module *mod,
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
@@ -3748,12 +3721,26 @@ static int ftrace_process_locs(struct module *mod,
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
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtkpaAAoJEIy3vGnGbaoAMRYP/3t+YJS2VYTtOu7fyimLnFvk
CxnsNDAgj1sAV3MniuZpRjYao4tgcQsQ6nI/KcbDdKX6EOUY+wWSYKso528c153K
Cs7Y1AFHY6FxHPVa4dpw9wV+c45WzzJK0JTYTviyp+a+o6mDLTlAokhtfsoW5GOs
M5s1d1ZO5DiMewU7Xr+jVNGjqX1bJWL16vs3k/83tc7TiTk0vy8to6iZ2ZARbwgS
X/HgUtfDye5ZqBYujgUB1fCaHoE/JXx4IN58aeOw7Bhh/lFT+tPShlRaZgHBAFgj
9pr14k+/mIJFm9uV2YnzQ7iHsRfAEWyIildptPKp6BYnMRPaX3XukIMu/h4DkyOq
1C4VMxj12Zh2++ZbKHiu+tDZ+Ha7aVisxxMtvOWjaTeiX+b863U5VOg8Gl2YUAul
GYfMZ0XbDAEwb43xA3etXOfcdH1dgMqvGeKy+A1TIchfmTM3Swxjh9cxaG6zUUix
Co7nS0RqpGTZ0po/knbYd34m3Ap4MoyjjF3qtW2meynT5Joy82XrIO76qR7iEk0Y
GNyv5s5FR2JblYEA0hebecIiBd8pTJTGvP9UyHbuHFwyAHJj8KF6nTgbBTetrlCS
6vLX3J33KLmqMtidB6lAr031FYeTAUGliLxDBgrBCWHDmTZkosxWZ3b+U0Zo+vvA
upxqs+Iya1slTx7w7ZvW
=FPji
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
