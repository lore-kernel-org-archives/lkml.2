Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946035Ab2ERNM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:12:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5608 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933716Ab2ERNKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:10:55 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=YpncgTFXi2gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=4BIMDcWzHu9iSGmsBiMA:9 a=2gubk0O2b5VqwnY0ZwYA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=xHwhiXTqpfXNena4:21 a=YrioqwwT_Tihq5p8:21 a=Rt8R2sD4AZaHR-3414UA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120518131050.931001057@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 09:09:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 11/15] ftrace: Consolidate ftrace_location() and ftrace_text_reserved()
References: <20120518130858.392919640@goodmis.org>
Content-Disposition: inline; filename=0011-ftrace-Consolidate-ftrace_location-and-ftrace_text_r.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Both ftrace_location() and ftrace_text_reserved() do basically the same thi=
ng.
They search to see if an address is in the ftace table (contains an address
that may change from nop to call ftrace_caller). The difference is
that ftrace_location() searches a single address, but ftrace_text_reserved()
searches a range.

This also makes the ftrace_text_reserved() faster as it now uses a bsearch()
instead of linearly searching all the addresses within a page.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   80 ++++++++++++++++++++++++---------------------=
----
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index fc93562..dd091c8 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1383,35 +1383,28 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned lo=
ng ip)
=20
 static int ftrace_cmp_recs(const void *a, const void *b)
 {
-	const struct dyn_ftrace *reca =3D a;
-	const struct dyn_ftrace *recb =3D b;
+	const struct dyn_ftrace *key =3D a;
+	const struct dyn_ftrace *rec =3D b;
=20
-	if (reca->ip > recb->ip)
-		return 1;
-	if (reca->ip < recb->ip)
+	if (key->flags < rec->ip)
 		return -1;
+	if (key->ip >=3D rec->ip + MCOUNT_INSN_SIZE)
+		return 1;
 	return 0;
 }
=20
-/**
- * ftrace_location - return true if the ip giving is a traced location
- * @ip: the instruction pointer to check
- *
- * Returns 1 if @ip given is a pointer to a ftrace location.
- * That is, the instruction that is either a NOP or call to
- * the function tracer. It checks the ftrace internal tables to
- * determine if the address belongs or not.
- */
-int ftrace_location(unsigned long ip)
+static int ftrace_location_range(unsigned long start, unsigned long end)
 {
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
 	struct dyn_ftrace key;
=20
-	key.ip =3D ip;
+	key.ip =3D start;
+	key.flags =3D end;	/* overload flags, as it is unsigned long */
=20
 	for (pg =3D ftrace_pages_start; pg; pg =3D pg->next) {
-		if (ip < pg->records[0].ip || ip > pg->records[pg->index - 1].ip)
+		if (end < pg->records[0].ip ||
+		    start >=3D (pg->records[pg->index - 1].ip + MCOUNT_INSN_SIZE))
 			continue;
 		rec =3D bsearch(&key, pg->records, pg->index,
 			      sizeof(struct dyn_ftrace),
@@ -1423,6 +1416,36 @@ int ftrace_location(unsigned long ip)
 	return 0;
 }
=20
+/**
+ * ftrace_location - return true if the ip giving is a traced location
+ * @ip: the instruction pointer to check
+ *
+ * Returns 1 if @ip given is a pointer to a ftrace location.
+ * That is, the instruction that is either a NOP or call to
+ * the function tracer. It checks the ftrace internal tables to
+ * determine if the address belongs or not.
+ */
+int ftrace_location(unsigned long ip)
+{
+	return ftrace_location_range(ip, ip);
+}
+
+/**
+ * ftrace_text_reserved - return true if range contains an ftrace location
+ * @start: start of range to search
+ * @end: end of range to search (inclusive). @end points to the last byte =
to check.
+ *
+ * Returns 1 if @start and @end contains a ftrace location.
+ * That is, the instruction that is either a NOP or call to
+ * the function tracer. It checks the ftrace internal tables to
+ * determine if the address belongs or not.
+ */
+int ftrace_text_reserved(void *start, void *end)
+{
+	return ftrace_location_range((unsigned long)start,
+				     (unsigned long)end);
+}
+
 static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 				     int filter_hash,
 				     bool inc)
@@ -1571,29 +1594,6 @@ void ftrace_bug(int failed, unsigned long ip)
 	}
 }
=20
-
-/* Return 1 if the address range is reserved for ftrace */
-int ftrace_text_reserved(void *s, void *e)
-{
-	struct dyn_ftrace *rec;
-	struct ftrace_page *pg;
-	unsigned long start =3D (unsigned long)s;
-	unsigned long end =3D (unsigned long)e;
-	int i;
-
-	for (pg =3D ftrace_pages_start; pg; pg =3D pg->next) {
-		if (end < pg->records[0].ip ||
-		    start >=3D (pg->records[pg->index - 1].ip + MCOUNT_INSN_SIZE))
-			continue;
-		for (i =3D 0; i < pg->index; i++) {
-			rec =3D &pg->records[i];
-			if (rec->ip <=3D end && rec->ip + MCOUNT_INSN_SIZE > start)
-				return 1;
-		}
-	}
-	return 0;
-}
-
 static int ftrace_check_record(struct dyn_ftrace *rec, int enable, int upd=
ate)
 {
 	unsigned long flag =3D 0UL;
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtkpbAAoJEIy3vGnGbaoATRUP/jCaBA4u5lPJT2kiBvsGQ6bU
tSNYXn+CE6rSCgPU7V/Aw6Xihj3hSQ+cSa+1ADj9mOiP+eU4EGP5NE1m0KGKVQdK
+6HgarYVjVKSFzC+fqzaluKATM6CDG6OPguV1+YrsfsC9vHNPjbqDSbwdJsiZ4LC
dISGvUcoX9CI+jWZhdjCbdAvgcWBWD63tAvSfgIc3x4mT8sXuOrKNrbE9pbtzkZl
ETCoNY86qeRvHzsIi8VqJXoXVYD2EqLoQ5KsE0w7Dqz3SS7B0YZd4M9WRy/vnXSW
MHf/nIuq7+TbdXbJ9m67+kJUeN7keNNAXpLa4mQzmmuKZBJXGdrWbU9G1yOfR9iD
6oy/caqZp6wabz6GbMBUsIXfmXOIQSJp4778N/URoRrBOlQ+4SooYNy5APd0hObZ
NDWykXc1G5I2XuqpND/LVi9kfqq5BNImHjq3q6zYb6WVCf18vnX8DDaKygOA14+6
sV/pRFqdD9dKL3XhQ3230JC667lahq1VIxD9g4U2+nlr0nU6xAyuIlSROm/3WkOV
96UbiHfRPZY7AjdiRl1DQ5JxqSGqSxjInV7SWYmB5Nq9ptasNz4uj3I5FOswubKi
3ozghK4lFr6FYGbCeLWiN1wp+xZAetBOye8ZyiZPMAlPl18dr0RNPPvw9t9572O3
p1AdG8E1U72BgKtIyOpy
=SzdC
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
