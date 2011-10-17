Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab1JQQ74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:59:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52674 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab1JQQ7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:59:53 -0400
X-Authority-Analysis: v=1.1 cv=UpSRffbr9y8V5xg6O7MBcDNOk5f8u00m038obrfOR4U= c=1 sm=0 a=vhdKIqpQuCYA:10 a=dpEo6TZrp7EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Qdg3YHP4dvspYzXrr44A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=TjaiqMRUOx5P8DQf:21 a=W69gfQoDoO0aC5g2:21 a=BRj_892zC60lrK2mg8AA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111017165952.559137810@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 17 Oct 2011 12:05:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 12/17][RFC] ktest: Consolidate TEST_TYPE and DEFAULT code
References: <20111017160455.498567257@goodmis.org>
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

iQIcBAABAgAGBQJOnF8IAAoJEIy3vGnGbaoA02wQALr2HKhl/5ZjffMSoBkQ2etZ
EhyET4KRAHVSxcwnVwy+b1J0O70mOFjZh3s2tUXhzkPwkA3trHC9QePrDXSLaORo
bHNeL8xxFmH5j3JkrEGhkchZAKpjLomQ3R8IvRimHJModeHwPxWl4/BHdPyt5+oo
t5x+KcQJpO35Uo0+wp6TJrNmqt12isw53i0GSvN0FGuvndw4B+uSa3a96GuMGqEe
dHcy8KFcB8u1Ady5URs0gdjhHNBn/QqHbN2ODBvtnfzUY0tdd8cjo4nHMKPFyc/n
+EGQaA5E7wT+JJ+4+If0Y12xpH/KxqmR02h1lhmaSyOj1WGtz6eQqcI9Ryp7za3k
5oIU8TdsMTanEWCL9RKlvMrJ8Dy6h89l6sPqkC/C4JfJbX3R5/UdKqBob7SRkLcX
AMG8Oj81ireRvKffJzPSk1u+8/KQXj9nE5iRC76aBZzLa7IvLwXUChnTMkCSczqv
08Pn2/rmnqiK5nVHy/Dy57k5zk5Q415W+kkwX/FGW+3Ya4WaqNK7W8fWxvVgZGro
C7zsMKpawYXH4q+1E2bd8dx3a11LHPlTKX2pojyJRxc5KV8Kr+e7DEVHXUcVl4BP
zZPhzoSSub09Q8/0bK93J72K2Ya48hhj/hLyPGIhX/MSpEfk5628NQwL65ykAp2n
IvQaD/UaZtxEeIDtsvSe
=5T4C
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
