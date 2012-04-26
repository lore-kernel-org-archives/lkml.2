Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab2DZChL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 22:37:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13453 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab2DZChJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 22:37:09 -0400
X-Authority-Analysis: v=2.0 cv=XbcLPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=gZTB3qPt6e0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=meVymXHHAAAA:8 a=xkS7cEQK18UYUIan8ZcA:9 a=5U9k56OlpVqdqvqouuEA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=BKN6tE9iLdKNP7uY:21 a=ZniWxbwpcDarBSNa:21 a=wQj6efY3tGY2dUZFoe0A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120426023707.427721264@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 25 Apr 2012 22:29:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/6][RFC] ftrace: Speed up search by skipping pages by address
References: <20120426022922.683707508@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Speed-up-search-by-skipping-pages-by-address.patch
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
index 4e608f8..333f890 100644
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
1.7.9.5



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPmLTTAAoJEIy3vGnGbaoAr7IQAMR2k4/pdJ2SZJnCK87jS6PF
ir7wyARJ65IYyCYPm4ccmT5LyWg7rQSmWeEbbZ4yav4LfzCSy9XtYLJcaJKlC6wX
myHGXJGNUqMI9/ysP1UCKSTLpZZVpQ0xGU1jy45WbfzZWth46Lpp9I6vBOlAUCuM
+yPYPZq6+iwZd7rxH5BqwkYYCaBT4OTbFHKoOmFDpUjRa7wLym4Py0x9vemQYN/B
L6xge2h+CCquJv0050iGbElaLwB4uQjrYYJYgW1tj8HUOth0qJitNixH9jZgrucf
lG7mqEI4fzc6naC8LO1aZFnbJTjgT9OoPaSWgASF+80PxAr+w/0/rdd/pHuLuVJ0
vOE5PrheEf3YaHXxJUbtqAlvHsjhz7FEJ1zfHHDYezXtVZto9lahkQH5g6P/reOj
SVfjWH39HocFQeEHfF+vTUVM5KoUPOZVkf9yFNWwPgZBp2cJyF/7SBkl4sDHXtvB
9ToxsPOKH407xbo+VyzloCOqywBiimFlu8Lfw7L4QJHZRe266FXV/Vh/nPLVRXKJ
phz4koweaDMFAimRBp4ywDd9pjZnZgPfAl8DkS48NqO9t7ZUcW6N7eOS2GbCvKUp
W5WOQXYzrY+h84VtWJwWIl3uTJP7W+SOmnxqTUrLvUH8wpROAlXWcM4LuY8A+56A
zqvjsvW0szh348mY9zXM
=6p+3
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
