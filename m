Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab2DZCiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 22:38:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10821 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab2DZChK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 22:37:10 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=sycReAnuD4wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=meVymXHHAAAA:8 a=4BIMDcWzHu9iSGmsBiMA:9 a=XZL_HHw7mTsa98oUw50A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=4MaVgtmE-LvxYOB4:21 a=s7pHVPVU-cmNVeRA:21 a=EuP8_Mf2DA83a4x-hQUA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120426023707.821072001@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 25 Apr 2012 22:29:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/6][RFC] ftrace: Consolidate ftrace_location() and ftrace_text_reserved()
References: <20120426022922.683707508@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-Consolidate-ftrace_location-and-ftrace_text_r.patch
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

This laso makes the ftrace_text_reserved() faster as it now uses a bsearch()
instead of linearly searching all the addresses within a page.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   80 ++++++++++++++++++++++++---------------------=
----
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 333f890..51e07f7 100644
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
1.7.9.5



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPmLTTAAoJEIy3vGnGbaoAwDMP/0kiGXD1UC/X4jdlUsW03N0f
TjeFV6KnF8T9YguctgpeSkyIIqESee3pZ/YE2FGA/HPhpwn+oEuZhY9t59o5K2OK
eG+ZrFo+ptQ9uNYMZlAyFBsTn2j+dwH7JzmoMF0nUDH2JxoBD4VkIUuOgqmtmu4p
QA6KgW+K1lfNV4jPe6DcNu89UunxnB3/b9sGHUqKg0/RpzEI67bBQwcI4xkh3fc9
DZhp99dkHAR18sUB/NDDRHVz1krV8k9GTYB+LwlSIJGOlT26VjAFP5z5STplh/94
vh3fjl1m8jWc+63FUgdrHcxe/HPnIVzAGsWV00W7ZpkXv2pQqISlVWg0ShBkEM7D
7b0O2fgmO4KR3ZzrZwDDvbuv/P8ClPzkfJK203QC/blcOno1bzbZOeNXfuHqmbJg
7MZRj1LlAGbahFgp2VHTVp+LSRmsnzDVyG/X+jm+9AVv8PbE8qxDgQegkuwfepcv
ktC0R9XbBUMcnqvJ+qag53MzDcaxtlDxZZRnMC9D5MTIi/ukmUwuz9t+zHrmzBib
eSC1dx4YWdvN6lCVU+lidPiOp3+8YIByQXh56cCp+vw461ttioEANaSnGA1PJ/Qq
uSORnsMjlmWJkvwGMP0nTOs7GId5fZWj0GIUJoAPxeDNPMO9iZ8bu+GfLiRWL8lM
u0KD9oHPY1wc4K3j40Yw
=jwYS
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
