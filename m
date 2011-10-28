Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab1J1LXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:23:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36854 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab1J1LU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:20:29 -0400
X-Authority-Analysis: v=1.1 cv=PzmnriOiyqYdyw8suerSEFMr8oy2Ua58JL+Rk7iuDKE= c=1 sm=0 a=vhdKIqpQuCYA:10 a=6WuKSVtN1MUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Qdg3YHP4dvspYzXrr44A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=TjaiqMRUOx5P8DQf:21 a=W69gfQoDoO0aC5g2:21 a=Nxda4CgRZObEcL8Xng0A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111028112026.605698280@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 Oct 2011 07:16:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 12/21] ktest: Consolidate TEST_TYPE and DEFAULT code
References: <20111028111558.173726794@goodmis.org>
Content-Disposition: inline; filename=0012-ktest-Consolidate-TEST_TYPE-and-DEFAULT-code.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The code that handles parsing the TEST_TYPE and DEFAULT code share
a lot of common functionality. Combine the two and add a if statement
that does what is different between them.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   61 ++++++++++++++------------------------=
---
 1 files changed, 21 insertions(+), 40 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 62de47d..b4f32e7 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -436,20 +436,29 @@ sub __read_config {
 	# ignore blank lines and comments
 	next if (/^\s*$/ || /\s*\#/);
=20
-	if (/^\s*TEST_START(.*)/) {
+	if (/^\s*(TEST_START|DEFAULTS)\b(.*)/) {
=20
-	    $rest =3D $1;
+	    my $type =3D $1;
+	    $rest =3D $2;
=20
-	    if ($num_tests_set) {
-		die "$name: $.: Can not specify both NUM_TESTS and TEST_START\n";
-	    }
+	    my $old_test_num;
+	    my $old_repeat;
+
+	    if ($type eq "TEST_START") {
=20
-	    my $old_test_num =3D $test_num;
-	    my $old_repeat =3D $repeat;
+		if ($num_tests_set) {
+		    die "$name: $.: Can not specify both NUM_TESTS and TEST_START\n";
+		}
=20
-	    $test_num +=3D $repeat;
-	    $default =3D 0;
-	    $repeat =3D 1;
+		$old_test_num =3D $test_num;
+		$old_repeat =3D $repeat;
+
+		$test_num +=3D $repeat;
+		$default =3D 0;
+		$repeat =3D 1;
+	    } else {
+		$default =3D 1;
+	    }
=20
 	    if ($rest =3D~ /\s+SKIP\b(.*)/) {
 		$rest =3D $1;
@@ -478,42 +487,14 @@ sub __read_config {
 	    }
=20
 	    if ($rest !~ /^\s*$/) {
-		die "$name: $.: Gargbage found after TEST_START\n$_";
+		die "$name: $.: Gargbage found after $type\n$_";
 	    }
=20
-	    if ($skip) {
+	    if ($skip && $type eq "TEST_START") {
 		$test_num =3D $old_test_num;
 		$repeat =3D $old_repeat;
 	    }
=20
-	} elsif (/^\s*DEFAULTS(.*)$/) {
-	    $default =3D 1;
-
-	    $rest =3D $1;
-
-	    if ($rest =3D~ /\s+SKIP(.*)/) {
-		$rest =3D $1;
-		$skip =3D 1;
-	    } else {
-		$skip =3D 0;
-	    }
-
-	    if ($rest =3D~ /\sIF\s+(.*)/) {
-		$if =3D 1;
-		if (process_if($name, $1)) {
-		    $if_set =3D 1;
-		} else {
-		    $skip =3D 1;
-		}
-		$rest =3D "";
-	    } else {
-		$if =3D 0;
-	    }
-
-	    if ($rest !~ /^\s*$/) {
-		die "$name: $.: Gargbage found after DEFAULTS\n$_";
-	    }
-
 	} elsif (/^\s*ELSE\b(.*)$/) {
 	    if (!$if) {
 		die "$name: $.: ELSE found with out matching IF section\n$_";
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOqo/6AAoJEIy3vGnGbaoAM54QAIzyJokyE29h23loYFYIdq67
0hcbmydUKOs1bFEhie9/FjxDXVTW6Q19+NsxqQmt5PjuTP0VMhCCQLprtUEXSPus
QLf6sTJ0n6bE7xFHjL5P/fmeZdzIuemj6ZW2CYPVN71M59AAtX1wX2ov6enOyU+1
TyBymWpI9cE4HRFRRsrrl0u43Wdewpxdbgyy6WPPFD6LI96eCf7nSyHhInrX9Q48
w9GgnokgCePPbFgPoHiqlMbUwycx6pgcVsjPEDvCVBcv70CkBJuTRqQoHYDq2fTO
ROvjNnYbgem8uPR11evC/Wj2rbCy9UR9DJ8ba/kNSzTm9BJTK/6U2YGQZCUGxX6q
gfaYuiwzhRbmV3NX+h7SlgLDmzccmLB0MHaVOEf2AKxXu976XxxvmvOVyJM2lQau
HbmOwzz66GIa8YldijrMfunPqG+nFKavQHxsRCZBDMI+5+b1ivW+C2ZgdR4l3Zf4
ILaIODpmz57XJbQcYvythOYKK5G3EQEwmN6FR5eCMcxMD2RS2cq3MdJ5uYu+fd0F
gMeVonAIikp+Dq6Y8fX7Y02qJEALA+pv6l/lA1b/3O9VrhmkBVsN8a/FFSNJhr62
G5NeZ0YKkbL3S/+oJIgaUPpSpfL+Ofzzrl6oFG3Z8K4EY714CuP4f0kTBc0llLjp
AYJ92a2o1tDVk6NzHvXL
=grtA
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
