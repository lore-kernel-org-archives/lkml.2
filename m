Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab1J1LUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:20:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61629 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab1J1LUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:20:38 -0400
X-Authority-Analysis: v=1.1 cv=rFxaVhpzdNKRsWyFDFmDbYx/QEtlW7L1Gw9MiLxO4aw= c=1 sm=0 a=vhdKIqpQuCYA:10 a=ffSEOtEVeEgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=KRCr8N6MsTSkg2eTPMEA:9 a=72fgMRCJTlKv7fW5eHIA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=zMTsXtV2ZVJXfLNr:21 a=CjAY00WYveH1sr0y:21 a=eLChSJfEZxoJsNcfvBcA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111028112035.504124931@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 Oct 2011 07:16:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 16/21] ktest: Fix parsing of config section lines
References: <20111028111558.173726794@goodmis.org>
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

iQIcBAABAgAGBQJOqpADAAoJEIy3vGnGbaoAtREP/0xINf9D8lDDuW8JbKEBrycp
j1F7R5qmhfGDUuhMYqVJWkKSbhHalJfEesQZkDKIDWQCxs7af0Oizw6peyvytRtI
36gMNBj8VOGADQuZdsvRGad+8jvxFPaPWHRQ9+lXX8y6+s65PiHeUFi+pZWrN07K
IC2yxAmFMmNFsNNuU4/l5LmuNTHFAVUkwx26q4Lm6BOOvlWIHUh9MG4Vkp8rbzgF
rO+0NKwqTFxeCLE1Lp83LLz6kTdQpZbBg/BOouQhcZJksGMTf8bGl53Ajir61G/m
vbIeAZUJnX7mMwZBQVK1TuIzoFkZv5LZbMGpkATtms3VPFp2MHN/h2djrOQyIeUQ
LJSsNR5goDbTVet/WQ8muetZN87RQQnLohEvLeaVqFkRP7gAP3bjTh81hKgBcX2O
lQU6moUGkLzuipvpeMA1KaM53EnQuihznQjXlZ6jcUeoIrWLzdpPWCynFUQpdT8P
8+hs3XWN4XvCd6isa329c5QNXdTmip/i2+cvY0EF9rzsRCVJe/pi8YaMmb3U/fDu
SE1QjTcDO3OcVZ+Uy7qctSDorQzO4mhnzMzM/El8spupxmTcf4JVFEgYrTTFghPb
EKFoI5olJ7duRIzRqqdMDd20c6bjK/RdGWv1+L+ARkjJm6uepewGe5VMbBpOFA6Y
YkbS0gk8D+KMa8Op0hUF
=qiET
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
