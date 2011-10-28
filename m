Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab1J1LUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:20:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65358 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab1J1LUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:20:40 -0400
X-Authority-Analysis: v=1.1 cv=dCTC1p3vNTdx1H6U0HtbMKjJ9bTEtPwCLJ4qOUv6lx4= c=1 sm=0 a=vhdKIqpQuCYA:10 a=0fc9ZQCChTAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Fl5eY8M0jbBIqMiGCIIA:9 a=KVQI4cpVpNLvF4p_un8A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=VzEIr6rREtcuOvmoocQA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111028112037.610135627@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 Oct 2011 07:16:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 17/21] ktest: Add processing of complex conditionals
References: <20111028111558.173726794@goodmis.org>
Content-Disposition: inline; filename=0017-ktest-Add-processing-of-complex-conditionals.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The IF statements for DEFAULTS and TEST_START sections now handle
complex statements (&&,||)

Example:

  TEST_START IF (DEFINED ALL_TESTS || ${MYTEST} =3D=3D boottest) && ${MACHI=
NE} =3D=3D gandalf

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   53 +++++++++++++++++++++++++++++++++++=
---
 tools/testing/ktest/sample.conf |   10 +++++++
 2 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index d292c2d..1bda07f 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -304,7 +304,7 @@ sub get_ktest_configs {
 }
=20
 sub process_variables {
-    my ($value) =3D @_;
+    my ($value, $remove_undef) =3D @_;
     my $retval =3D "";
=20
     # We want to check for '\', and it is just easier
@@ -322,6 +322,10 @@ sub process_variables {
 	$retval =3D "$retval$begin";
 	if (defined($variable{$var})) {
 	    $retval =3D "$retval$variable{$var}";
+	} elsif (defined($remove_undef) && $remove_undef) {
+	    # for if statements, any variable that is not defined,
+	    # we simple convert to 0
+	    $retval =3D "${retval}0";
 	} else {
 	    # put back the origin piece.
 	    $retval =3D "$retval\$\{$var\}";
@@ -403,10 +407,40 @@ sub value_defined {
 	defined($opt{$2});
 }
=20
-sub process_if {
-    my ($name, $value) =3D @_;
+my $d =3D 0;
+sub process_expression {
+    my ($name, $val) =3D @_;
+
+    my $c =3D $d++;
+
+    while ($val =3D~ s/\(([^\(]*?)\)/\&\&\&\&VAL\&\&\&\&/) {
+	my $express =3D $1;
+
+	if (process_expression($name, $express)) {
+	    $val =3D~ s/\&\&\&\&VAL\&\&\&\&/ 1 /;
+	} else {
+	    $val =3D~ s/\&\&\&\&VAL\&\&\&\&/ 0 /;
+	}
+    }
+
+    $d--;
+    my $OR =3D "\\|\\|";
+    my $AND =3D "\\&\\&";
=20
-    my $val =3D process_variables($value);
+    while ($val =3D~ s/^(.*?)($OR|$AND)//) {
+	my $express =3D $1;
+	my $op =3D $2;
+
+	if (process_expression($name, $express)) {
+	    if ($op eq "||") {
+		return 1;
+	    }
+	} else {
+	    if ($op eq "&&") {
+		return 0;
+	    }
+	}
+    }
=20
     if ($val =3D~ /(.*)(=3D=3D|\!=3D|>=3D|<=3D|>|<)(.*)/) {
 	my $ret =3D process_compare($1, $2, $3);
@@ -431,7 +465,16 @@ sub process_if {
     }
=20
     die ("$name: $.: Undefined content $val in if statement\n");
-    return 1;
+}
+
+sub process_if {
+    my ($name, $value) =3D @_;
+
+    # Convert variables and replace undefined ones with 0
+    my $val =3D process_variables($value, 1);
+    my $ret =3D process_expression $name, $val;
+
+    return $ret;
 }
=20
 sub __read_config {
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index 7b49f07..dbedfa1 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -154,6 +154,16 @@
 # MAKE_CMD :=3D make ARCH=3Dx86
 #
 #
+# And/or ops (&&,||) may also be used to make complex conditionals.
+#
+# TEST_START IF (DEFINED ALL_TESTS || ${MYTEST} =3D=3D boottest) && ${MACH=
INE} =3D=3D gandalf
+#
+# Notice the use of paranthesis. Without any paranthesis the above would be
+# processed the same as:
+#
+# TEST_START IF DEFINED ALL_TESTS || (${MYTEST} =3D=3D boottest && ${MACHI=
NE} =3D=3D gandalf)
+#
+#
 #
 # INCLUDE file
 #
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOqpAFAAoJEIy3vGnGbaoAUmoQAOsZptxNJqdaPCz0onPCEfh3
M5hej7LRToUeHk9Shj5Yjt+ZaVRTw0u6NWK1ufnaWfddmAiO6ii8UQB3IXlpNrEV
3Fv4ac4Qpo2HP9k5i7uuWzWI7b6xsprCJXfvudB7Feh2ejZKfhd3BjMMe+s2hwKc
Jlayz+wn7GjDiQOkJXu/GCvfyWlA8hyDjBrCCZ1rd3m4+hVRtXP0BFSFgum2V+yE
/t6WJsuqPEsgfvZA08KVBgn3Y+SW3mxbORskJQH2jCySlM7QxKj36rjyc4A3oeQD
RnSS0sAtVCoLmq0s8ynBn1jTnLgA2fGt83KQCJWhAVCy5F0w8OItFqUG6SJ1nn8X
ipgD6AhIRVxLrxxLlEIlJsFxeGciOhfo1RcKvDECbrnDMQMwB8qJygeuSMy2uGDm
ATR2WMk63aNm1Bd4r+i1ZBA2DRFlJwuttQlclvWuleIRMKE4NNKhVrrgD2ZBUH69
kYogRmyOZQ/4DmJNUhS3D2yB2dLD79iHA7YeDaz8px48lGrDZlCaRCMJ3lWgQwXR
9+iffaM7TJyzPJiBdI3gqsg1/bj5SkqkyPFL3LyRiqwsksVeQr7tA6SGC24PIPRI
gmkrxojkdy1ki4JFXSzuICJ9vnMVZ/dd7n5S3hNIOiEfErJZi7JH+68628x/4jrs
L8GPd/8BhAr3pxDXCkGI
=K9mn
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
