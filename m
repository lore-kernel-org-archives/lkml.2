Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab1J1LUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:20:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36854 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab1J1LUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:20:31 -0400
X-Authority-Analysis: v=1.1 cv=PzmnriOiyqYdyw8suerSEFMr8oy2Ua58JL+Rk7iuDKE= c=1 sm=0 a=vhdKIqpQuCYA:10 a=s8vNV0VetqYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Uq1LQkEK12DiPy_JfjoA:9 a=q7RHVR6LALaEXBMc0aMA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=kX_FQbC6cxkiiZXY:21 a=Ar_V3aJfphiZFGJW:21 a=HB1eDBFl9dWmiTM7-2MA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111028112028.709806036@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 Oct 2011 07:16:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 13/21] ktest: Add OVERRIDE keyword to DEFAULTS section
References: <20111028111558.173726794@goodmis.org>
Content-Disposition: inline; filename=0013-ktest-Add-OVERRIDE-keyword-to-DEFAULTS-section.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The OVERRIDE keyword will allow options defined in the given
DEFAULTS section to override options defined in previous DEFAULT
sections.

Normally, options will error if they were previous defined.
The OVERRIDE keyword allows options that have been previously
defined to be changed in the given section.

Note, the same option can not be defined in the same DEFAULT section
even if that section is marked as OVERRIDE.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   37 +++++++++++++++++++++++++++++------=
--
 tools/testing/ktest/sample.conf |   15 +++++++++++++++
 2 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index b4f32e7..7bce412 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -337,10 +337,17 @@ sub process_variables {
 }
=20
 sub set_value {
-    my ($lvalue, $rvalue) =3D @_;
+    my ($lvalue, $rvalue, $override, $overrides, $name) =3D @_;
=20
     if (defined($opt{$lvalue})) {
-	die "Error: Option $lvalue defined more than once!\n";
+	if (!$override || defined(${$overrides}{$lvalue})) {
+	    my $extra =3D "";
+	    if ($override) {
+		$extra =3D "In the same override section!\n";
+	    }
+	    die "$name: $.: Option $lvalue defined more than once!\n$extra";
+	}
+	${$overrides}{$lvalue} =3D $rvalue;
     }
     if ($rvalue =3D~ /^\s*$/) {
 	delete $opt{$lvalue};
@@ -430,6 +437,9 @@ sub __read_config {
     my $test_case =3D 0;
     my $if =3D 0;
     my $if_set =3D 0;
+    my $override =3D 0;
+
+    my %overrides;
=20
     while (<$in>) {
=20
@@ -443,6 +453,7 @@ sub __read_config {
=20
 	    my $old_test_num;
 	    my $old_repeat;
+	    $override =3D 0;
=20
 	    if ($type eq "TEST_START") {
=20
@@ -468,10 +479,20 @@ sub __read_config {
 		$skip =3D 0;
 	    }
=20
-	    if ($rest =3D~ /\s+ITERATE\s+(\d+)(.*)$/) {
-		$repeat =3D $1;
-		$rest =3D $2;
-		$repeat_tests{"$test_num"} =3D $repeat;
+	    if (!$skip) {
+		if ($type eq "TEST_START") {
+		    if ($rest =3D~ /\s+ITERATE\s+(\d+)(.*)$/) {
+			$repeat =3D $1;
+			$rest =3D $2;
+			$repeat_tests{"$test_num"} =3D $repeat;
+		    }
+		} elsif ($rest =3D~ /\sOVERRIDE\b(.*)/) {
+		    # DEFAULT only
+		    $rest =3D $1;
+		    $override =3D 1;
+		    # Clear previous overrides
+		    %overrides =3D ();
+		}
 	    }
=20
 	    if ($rest =3D~ /\sIF\s+(.*)/) {
@@ -573,10 +594,10 @@ sub __read_config {
 	    }
=20
 	    if ($default || $lvalue =3D~ /\[\d+\]$/) {
-		set_value($lvalue, $rvalue);
+		set_value($lvalue, $rvalue, $override, \%overrides, $name);
 	    } else {
 		my $val =3D "$lvalue\[$test_num\]";
-		set_value($val, $rvalue);
+		set_value($val, $rvalue, $override, \%overrides, $name);
=20
 		if ($repeat > 1) {
 		    $repeats{$val} =3D $repeat;
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index ae2a93c..0fd3ca3 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -72,6 +72,21 @@
 # the same option name under the same test or as default
 # ktest will fail to execute, and no tests will run.
 #
+# DEFAULTS OVERRIDE
+#
+# Options defined in the DEFAULTS section can not be duplicated
+# even if they are defined in two different DEFAULT sections.
+# This is done to catch mistakes where an option is added but
+# the previous option was forgotten about and not commented.
+#
+# The OVERRIDE keyword can be added to a section to allow this
+# section to override other DEFAULT sections values that have
+# been defined previously. It will only override options that
+# have been defined before its use. Options defined later
+# in a non override section will still error. The same option
+# can not be defined in the same section even if that section
+# is marked OVERRIDE.
+#
 #
 #
 # Both TEST_START and DEFAULTS sections can also have the IF keyword
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOqo/8AAoJEIy3vGnGbaoAOosQALxvJ0ZHtmuIdUQ7VtqGn5BP
d3zcTu6Vl2cWNmnS7Pi1B8RP3e0U6bsBAlUn6PpgiM4s0QAkphigdxVHNh/aJrGr
lr3t6o70NvesWX69+NHj/xQ7eZaMKr8Ms3HLYj3i7Gmpi6JHSTeIjZSRwGAjjvSV
eayVI+V1e3jtiByvyl6GenYAmywmr89UTALz2d4dX4361/5/eRbBTB3HgAa9nYHL
0ZF/fs0gR3rNp141xGF7w0TVP2flk3etvYxSRoVOoLEVLV5c83Tt8Hl3Wl49RkS3
y2Ds7eLxysTS56jNKbFWIQ+JnHMyNhz2SrbYgqhypNz8SHp1nl0wKLdkJkJCx1jH
VdHd49LwAZgVdJFvhqozJiMbvZ1YxRTvrZ6DENcZNGfFe322MizWaG6D8wNXWjw8
R9+06ACs2JkOZgqtDxkDOdK6kiPdsGQdlMFgemfSDmineB7LHQ5bROHWO8pVvPpo
IqILkA4Vw7qdvVi1DfoWJEI2EjI0UI1AMX++j5Zwz7Q2hTTyiucBxX3DYOgFp3xr
I3bHfAFbbDoMHfIafc3j280T/C7avKotGZTRlSH3lzrlww3LaMT8NYEeqE8bIzfr
RvVaMkmVaZbSTLMtQeRAwrpHInfm+DMnhsOjYwaW4RC8ZMRzs3J6f86VW9vP9MvB
vFUfpiqsJYD6tFQYJ9gb
=HjCF
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
