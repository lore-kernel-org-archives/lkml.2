Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab1JQRAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:00:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45329 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab1JQQ7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:59:55 -0400
X-Authority-Analysis: v=1.1 cv=G2mrdTwFgeQf4gnIVCGl5REDSA/JVLCrZmxI9r5hHjY= c=1 sm=0 a=vhdKIqpQuCYA:10 a=SERZnYZTKdUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=KRCr8N6MsTSkg2eTPMEA:9 a=72fgMRCJTlKv7fW5eHIA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=zMTsXtV2ZVJXfLNr:21 a=CjAY00WYveH1sr0y:21 a=fmbVO6pYXtQaKoyDroAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111017165954.376385828@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 17 Oct 2011 12:05:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 16/17][RFC] ktest: Fix parsing of config section lines
References: <20111017160455.498567257@goodmis.org>
Content-Disposition: inline; filename=0016-ktest-Fix-parsing-of-config-section-lines.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The order for some of the keywords on a section line
(TEST_START or DEFAULTS) does not really matter. Simply need
to remove the keyword from the line as we process it and
evaluate the next keyword in the line. By removing the keywords
as we find them, we do not need to keep track of where on the
line they were found.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   49 ++++++++++++++++++++++++++------------=
---
 1 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 2a9d042..d292c2d 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -449,6 +449,7 @@ sub __read_config {
     my $num_tests_set =3D 0;
     my $skip =3D 0;
     my $rest;
+    my $line;
     my $test_case =3D 0;
     my $if =3D 0;
     my $if_set =3D 0;
@@ -465,6 +466,7 @@ sub __read_config {
=20
 	    my $type =3D $1;
 	    $rest =3D $2;
+	    $line =3D $2;
=20
 	    my $old_test_num;
 	    my $old_repeat;
@@ -486,32 +488,28 @@ sub __read_config {
 		$default =3D 1;
 	    }
=20
-	    if ($rest =3D~ /\s+SKIP\b(.*)/) {
-		$rest =3D $1;
+	    # If SKIP is anywhere in the line, the command will be skipped
+	    if ($rest =3D~ s/\s+SKIP\b//) {
 		$skip =3D 1;
 	    } else {
 		$test_case =3D 1;
 		$skip =3D 0;
 	    }
=20
-	    if (!$skip) {
-		if ($type eq "TEST_START") {
-		    if ($rest =3D~ /\s+ITERATE\s+(\d+)(.*)$/) {
-			$repeat =3D $1;
-			$rest =3D $2;
-			$repeat_tests{"$test_num"} =3D $repeat;
-		    }
-		} elsif ($rest =3D~ /\sOVERRIDE\b(.*)/) {
-		    # DEFAULT only
-		    $rest =3D $1;
-		    $override =3D 1;
-		    # Clear previous overrides
-		    %overrides =3D ();
+	    if ($rest =3D~ s/\sELSE\b//) {
+		if (!$if) {
+		    die "$name: $.: ELSE found with out matching IF section\n$_";
+		}
+		$if =3D 0;
+
+		if ($if_set) {
+		    $skip =3D 1;
+		} else {
+		    $skip =3D 0;
 		}
 	    }
=20
-	    if ($rest =3D~ /\sIF\s+(.*)/) {
-		$rest =3D "";
+	    if ($rest =3D~ s/\sIF\s+(.*)//) {
 		if (process_if($name, $1)) {
 		    $if_set =3D 1;
 		} else {
@@ -520,9 +518,24 @@ sub __read_config {
 		$if =3D 1;
 	    } else {
 		$if =3D 0;
+		$if_set =3D 0;
 	    }
=20
-	    if ($rest !~ /^\s*$/) {
+	    if (!$skip) {
+		if ($type eq "TEST_START") {
+		    if ($rest =3D~ s/\s+ITERATE\s+(\d+)//) {
+			$repeat =3D $1;
+			$repeat_tests{"$test_num"} =3D $repeat;
+		    }
+		} elsif ($rest =3D~ s/\sOVERRIDE\b//) {
+		    # DEFAULT only
+		    $override =3D 1;
+		    # Clear previous overrides
+		    %overrides =3D ();
+		}
+	    }
+
+	    if (!$skip && $rest !~ /^\s*$/) {
 		die "$name: $.: Gargbage found after $type\n$_";
 	    }
=20
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOnF8KAAoJEIy3vGnGbaoA/zYQAKYeIzLYuBk6n/Vo56Ow1L5G
w71XKRF5nhv32d/L2ig9D6I0D9Iwq+Sr7gnvkX/tFz8Ga+ICtZd+O4p5p2RoKeMp
5Yd52dyJssZD/hgmnIiua6+o8CJV2DTz+/JJgfYBYRPlXEEKwrHSclHsX5QSm6s8
M+bjT7Oi69ABDDAVjY2dZs31VOhkzJ9p/6crp+q5I0GU98x5LTiNkWNyMQGI0fN4
2LB5T+4dGZpW/yy4dw/Zytg3hAYh1Yn2A7MT3xZnqGcVYCCGMUnclRh04UUEgvFo
bj71c/NXkUd6eYSYI/nF8dGClWcXSip082vsBjiv+Ui1eN3nOTKDh+S3nT/iau8j
QBOAsL2WXgT+UVVmAyk29JqGN/Up/Cl4jrC2Yg4DGQTrhFsdYToqN3mF60zGHLIv
WljKu+wA0OZEN/us5Ex3mmCpIgkXsISLzJfwxfKN5CnpfkunSRinSZw4N/1wKAeL
XG75i3rtPA4R6OOcKqvpBJUM/qhdl0bIVv0Zpl0pvg5MPI7mgXnRVXn+hdK6wfxd
mBYXzpUaVqeVENKHGIKlU6/gQcgw2lg/ivXFZDJvpFuQ7TQS5AQzriOAICiw48mT
AJwCZ8O3TpNJ5i0cBfKGMJbqkZrACoNvWTpVBwggFVotZEgSM6Zg718G3lg9MZ8V
FCsvCoFeBp1oAEWPVBnn
=a06D
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
