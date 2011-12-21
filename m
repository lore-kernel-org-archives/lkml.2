Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1LUMj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:39:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43158 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab1LUMiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:38:12 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=0JY5jpQLnPIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=VWQZKYP7uBNeuWE8fdAA:9 a=gnxLLtOGaXfMg_04kakA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=D1_cZDTDE4huCOFn7WsA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111221123808.293162346@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 07:36:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 10/16] ftrace: Create ftrace_hash_empty() helper routine
References: <20111221123624.193898256@goodmis.org>
Content-Disposition: inline; filename=0010-ftrace-Create-ftrace_hash_empty-helper-routine.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

There are two types of hashes in the ftrace_ops; one type
is the filter_hash and the other is the notrace_hash. Either
one may be null, meaning it has no elements. But when elements
are added, the hash is allocated.

Throughout the code, a check needs to be made to see if a hash
exists or the hash has elements, but the check if the hash exists
is usually missing causing the possible "NULL pointer dereference bug".

Add a helper routine called "ftrace_hash_empty()" that returns
true if the hash doesn't exist or its count is zero. As they mean
the same thing.

Last-bug-reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a383d6c..e1ee07f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -999,6 +999,11 @@ static struct ftrace_page *ftrace_new_pgs;
 static struct ftrace_page	*ftrace_pages_start;
 static struct ftrace_page	*ftrace_pages;
=20
+static bool ftrace_hash_empty(struct ftrace_hash *hash)
+{
+	return !hash || !hash->count;
+}
+
 static struct ftrace_func_entry *
 ftrace_lookup_ip(struct ftrace_hash *hash, unsigned long ip)
 {
@@ -1007,7 +1012,7 @@ ftrace_lookup_ip(struct ftrace_hash *hash, unsigned l=
ong ip)
 	struct hlist_head *hhd;
 	struct hlist_node *n;
=20
-	if (!hash->count)
+	if (ftrace_hash_empty(hash))
 		return NULL;
=20
 	if (hash->size_bits > 0)
@@ -1151,7 +1156,7 @@ alloc_and_copy_ftrace_hash(int size_bits, struct ftra=
ce_hash *hash)
 		return NULL;
=20
 	/* Empty hash? */
-	if (!hash || !hash->count)
+	if (ftrace_hash_empty(hash))
 		return new_hash;
=20
 	size =3D 1 << hash->size_bits;
@@ -1276,9 +1281,9 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long=
 ip)
 	filter_hash =3D rcu_dereference_raw(ops->filter_hash);
 	notrace_hash =3D rcu_dereference_raw(ops->notrace_hash);
=20
-	if ((!filter_hash || !filter_hash->count ||
+	if ((ftrace_hash_empty(filter_hash) ||
 	     ftrace_lookup_ip(filter_hash, ip)) &&
-	    (!notrace_hash || !notrace_hash->count ||
+	    (ftrace_hash_empty(notrace_hash) ||
 	     !ftrace_lookup_ip(notrace_hash, ip)))
 		ret =3D 1;
 	else
@@ -1371,7 +1376,7 @@ static void __ftrace_hash_rec_update(struct ftrace_op=
s *ops,
 	if (filter_hash) {
 		hash =3D ops->filter_hash;
 		other_hash =3D ops->notrace_hash;
-		if (!hash || !hash->count)
+		if (ftrace_hash_empty(hash))
 			all =3D 1;
 	} else {
 		inc =3D !inc;
@@ -1381,7 +1386,7 @@ static void __ftrace_hash_rec_update(struct ftrace_op=
s *ops,
 		 * If the notrace hash has no items,
 		 * then there's nothing to do.
 		 */
-		if (!hash || !hash->count)
+		if (ftrace_hash_empty(hash))
 			return;
 	}
=20
@@ -1398,8 +1403,8 @@ static void __ftrace_hash_rec_update(struct ftrace_op=
s *ops,
 			if (!other_hash || !ftrace_lookup_ip(other_hash, rec->ip))
 				match =3D 1;
 		} else {
-			in_hash =3D hash && !!ftrace_lookup_ip(hash, rec->ip);
-			in_other_hash =3D other_hash && !!ftrace_lookup_ip(other_hash, rec->ip);
+			in_hash =3D !!ftrace_lookup_ip(hash, rec->ip);
+			in_other_hash =3D !!ftrace_lookup_ip(other_hash, rec->ip);
=20
 			/*
 			 *
@@ -1407,7 +1412,7 @@ static void __ftrace_hash_rec_update(struct ftrace_op=
s *ops,
 			if (filter_hash && in_hash && !in_other_hash)
 				match =3D 1;
 			else if (!filter_hash && in_hash &&
-				 (in_other_hash || !other_hash->count))
+				 (in_other_hash || ftrace_hash_empty(other_hash)))
 				match =3D 1;
 		}
 		if (!match)
@@ -1950,7 +1955,7 @@ static int ops_traces_mod(struct ftrace_ops *ops)
 	struct ftrace_hash *hash;
=20
 	hash =3D ops->filter_hash;
-	return !!(!hash || !hash->count);
+	return ftrace_hash_empty(hash);
 }
=20
 static int ftrace_update_code(struct module *mod)
@@ -2320,7 +2325,8 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 	 * off, we can short cut and just print out that all
 	 * functions are enabled.
 	 */
-	if (iter->flags & FTRACE_ITER_FILTER && !ops->filter_hash->count) {
+	if (iter->flags & FTRACE_ITER_FILTER &&
+	    ftrace_hash_empty(ops->filter_hash)) {
 		if (*pos > 0)
 			return t_hash_start(m, pos);
 		iter->flags |=3D FTRACE_ITER_PRINTALL;
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8dMwAAoJEIy3vGnGbaoArKIP/1XFlfJC0Eg9Iwc/hXYQCYaI
MWRAj1KFgHYF/XS1RG4q4vIZNpHeYIS9B7daNHFFMVk6evXtNlNbef4aGf6Agv9A
TewAas4xMsWDdPMXtNLOO+cRH5sHPu3cAQaBfAHVrCK/4rtLvZCJWo4eqXpiY9YC
FPqCIqiTKm3gHqHpc8IaKtIlswXfdkCQzZl9BiXgxxlQDwAlvX8H3Sg6Es6powAM
Y7OcmNrNmJoQxKLIi3Y5uGAYI19NEjoQNVXBHo9T9PrfiPhv+qVmUKZnuWfTZkdc
SObqVEF9pOgMmdroblV5zpTnnYpk3sS2NkVuRwLauOA0hFXieU3k/UPOphzSfgIx
DbI5koglpk6IzV3vB3pO0LDuBeg2JDBTE7MMfH34f/igEb1GYUgYszZIV1mMaf7O
y/+H4/DcKnVZBj1pkilYAwtidpBCYnpIWsXEn4bQmoYy1rdHAPG95LabCpTepE7S
QK2gv5qSXaFLPNkIU+TXlGodAhCUCexsRx/HcptGI0oOWRw5iourbyiD3EDZE8xv
o02c1KK4ZgWXSnC+YlTCXi9wB56RsCX5ndZ3KWEnnfVFqGOofRkZf1dVLK1vfoxi
5i8srFm6tNw1plfuNEiGKAZYigdMuH9U/0CPtMZvmO9J1sujgl3KAqplyFnj7755
Okba+dyoq0KYbuVzGtOn
=V+Ua
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
