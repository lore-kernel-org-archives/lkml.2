Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946040Ab2ERNMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:12:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933722Ab2ERNKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:10:53 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=qKccPN6sc8AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=xkS7cEQK18UYUIan8ZcA:9 a=5U9k56OlpVqdqvqouuEA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=rJmqdrJ-pPgpA_SZ:21 a=d70PUlaOxHDhe0oF:21 a=mRso85lu_IU--pLBQ3EA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120518131050.631235481@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 09:09:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 10/15] ftrace: Speed up search by skipping pages by address
References: <20120518130858.392919640@goodmis.org>
Content-Disposition: inline; filename=0010-ftrace-Speed-up-search-by-skipping-pages-by-address.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

As all records in a page of the ftrace table are sorted, we can
speed up the search algorithm by checking if the address to look for
falls in between the first and last record ip on the page.

This speeds up both the ftrace_location() and ftrace_text_reserved()
algorithms, as it can skip full pages when the search address is
not in them.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e10f9e5..fc93562 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1411,6 +1411,8 @@ int ftrace_location(unsigned long ip)
 	key.ip =3D ip;
=20
 	for (pg =3D ftrace_pages_start; pg; pg =3D pg->next) {
+		if (ip < pg->records[0].ip || ip > pg->records[pg->index - 1].ip)
+			continue;
 		rec =3D bsearch(&key, pg->records, pg->index,
 			      sizeof(struct dyn_ftrace),
 			      ftrace_cmp_recs);
@@ -1571,16 +1573,24 @@ void ftrace_bug(int failed, unsigned long ip)
=20
=20
 /* Return 1 if the address range is reserved for ftrace */
-int ftrace_text_reserved(void *start, void *end)
+int ftrace_text_reserved(void *s, void *e)
 {
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
+	unsigned long start =3D (unsigned long)s;
+	unsigned long end =3D (unsigned long)e;
+	int i;
=20
-	do_for_each_ftrace_rec(pg, rec) {
-		if (rec->ip <=3D (unsigned long)end &&
-		    rec->ip + MCOUNT_INSN_SIZE > (unsigned long)start)
-			return 1;
-	} while_for_each_ftrace_rec();
+	for (pg =3D ftrace_pages_start; pg; pg =3D pg->next) {
+		if (end < pg->records[0].ip ||
+		    start >=3D (pg->records[pg->index - 1].ip + MCOUNT_INSN_SIZE))
+			continue;
+		for (i =3D 0; i < pg->index; i++) {
+			rec =3D &pg->records[i];
+			if (rec->ip <=3D end && rec->ip + MCOUNT_INSN_SIZE > start)
+				return 1;
+		}
+	}
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

iQIcBAABAgAGBQJPtkpaAAoJEIy3vGnGbaoAjo4QAMVxAIGVJ7DMPpud9Cw/1EjZ
tBFWQzLnE7obchzVEy6mCQcPPdhGZ+NKGCQbnb1mL/5r4J955UC/OUQ8H8PwMxIu
Lki4asfU5GyQ9JAZb1Jc/BETZmRp4RzpurZWx3o5+buxkHCqugk9yar4aHYUVBuL
gRuCp1Jb7YmKDJaxT6Vy+e9L7LQtimHjJBD1CCEcKXTyAz2cU5oOX4gR6CONs8z9
dSxV24Lyq8nW8P7iaW3azzhtQUCZy7uatOspBUbBLGeaN4i5NfmoDVGkPMLx6CvS
dpUK7nBN8l63slbutUwR5U39mnMWykoUkClYVAWFFQjjMRElcEcIk7SE8rB2ifAi
iWPA7tzoYWuMnaI/2mVAiouZpCbRZ4Y76uNQpKCdh8VVj87AKkF4NqJxTg+x//I1
e8EgVA8l1r31G0mFByXAydg2l+dxO2Fmsfkd1VnSqvfEyT45ZLpqDcEE0mysozSl
g+F6EU7Rb2XRPkNtiVTeeLvxpR6arePy8yYIQEvmLWCmN2g9nJ7e9bLCgpbQJ0m2
qI/WcdAmkMKEoRU59bfBYLmyrkuxgCSq4cM1JT7bYXyshAQ/ChOWtPlZK1VY5xmZ
8fRFLGIMe7WwVE0jXLu6uygBkzU4H5fANQCTjjQLn8bRMtR2OghgPju30OtLHK18
iRp4r4OlooLtX8jO1wTw
=il/n
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
