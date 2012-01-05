Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab2AEDu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:50:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63363 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276Ab2AEDs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:48:27 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=zqWe77YZEdMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=OvctI5GLiqHzMLXBzbMA:9 a=vD2VAKx01p6bn-MT_vIA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=tU3vplRDN1yW7w2_:21 a=vvme4PbLWBaAWuVX:21 a=dKs_TYUcxuJFYrtBlfsA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120105034825.814806721@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 04 Jan 2012 22:48:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 16/20] ktest: Have all values be set by defaults
References: <20120105034755.793909214@goodmis.org>
Content-Disposition: inline; filename=0016-ktest-Have-all-values-be-set-by-defaults.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Currently the patchcheck, bisect, and config_bisect variables
are only able to be set per test. You can not set a default
value for them.

By letting default values be set, it makes some config files
a bit easier, and also makes it easier to find typos in the
option names.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   86 ++++++++++++++++++++++++++++----------=
---
 1 files changed, 59 insertions(+), 27 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 85c5d94..5ba9ad4 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -103,7 +103,7 @@ my $output_minconfig;
 my $ignore_config;
 my $addconfig;
 my $in_bisect =3D 0;
-my $bisect_bad =3D "";
+my $bisect_bad_commit =3D "";
 my $reverse_bisect;
 my $bisect_manual;
 my $bisect_skip;
@@ -140,10 +140,27 @@ my $stop_after_failure;
 my $stop_test_after;
 my $build_target;
 my $target_image;
+my $checkout;
 my $localversion;
 my $iteration =3D 0;
 my $successes =3D 0;
=20
+my $bisect_good;
+my $bisect_bad;
+my $bisect_type;
+my $bisect_start;
+my $bisect_replay;
+my $bisect_files;
+my $bisect_reverse;
+my $bisect_check;
+
+my $config_bisect;
+my $config_bisect_type;
+
+my $patchcheck_type;
+my $patchcheck_start;
+my $patchcheck_end;
+
 # set when a test is something other that just building or install
 # which would require more options.
 my $buildonly =3D 1;
@@ -1940,7 +1957,7 @@ sub run_git_bisect {
     if ($output =3D~ m/^(Bisecting: .*\(roughly \d+ steps?\))\s+\[([[:xdig=
it:]]+)\]/) {
 	doprint "$1 [$2]\n";
     } elsif ($output =3D~ m/^([[:xdigit:]]+) is the first bad commit/) {
-	$bisect_bad =3D $1;
+	$bisect_bad_commit =3D $1;
 	doprint "Found bad commit... $1\n";
 	return 0;
     } else {
@@ -2050,16 +2067,16 @@ sub bisect {
=20
     my $result;
=20
-    die "BISECT_GOOD[$i] not defined\n"	if (!defined($opt{"BISECT_GOOD[$i]=
"}));
-    die "BISECT_BAD[$i] not defined\n"	if (!defined($opt{"BISECT_BAD[$i]"}=
));
-    die "BISECT_TYPE[$i] not defined\n"	if (!defined($opt{"BISECT_TYPE[$i]=
"}));
+    die "BISECT_GOOD[$i] not defined\n"	if (!defined($bisect_good));
+    die "BISECT_BAD[$i] not defined\n"	if (!defined($bisect_bad));
+    die "BISECT_TYPE[$i] not defined\n"	if (!defined($bisect_type));
=20
-    my $good =3D $opt{"BISECT_GOOD[$i]"};
-    my $bad =3D $opt{"BISECT_BAD[$i]"};
-    my $type =3D $opt{"BISECT_TYPE[$i]"};
-    my $start =3D $opt{"BISECT_START[$i]"};
-    my $replay =3D $opt{"BISECT_REPLAY[$i]"};
-    my $start_files =3D $opt{"BISECT_FILES[$i]"};
+    my $good =3D $bisect_good;
+    my $bad =3D $bisect_bad;
+    my $type =3D $bisect_type;
+    my $start =3D $bisect_start;
+    my $replay =3D $bisect_replay;
+    my $start_files =3D $bisect_files;
=20
     if (defined($start_files)) {
 	$start_files =3D " -- " . $start_files;
@@ -2071,8 +2088,7 @@ sub bisect {
     $good =3D get_sha1($good);
     $bad =3D get_sha1($bad);
=20
-    if (defined($opt{"BISECT_REVERSE[$i]"}) &&
-	$opt{"BISECT_REVERSE[$i]"} =3D=3D 1) {
+    if (defined($bisect_reverse) && $bisect_reverse =3D=3D 1) {
 	doprint "Performing a reverse bisect (bad is good, good is bad!)\n";
 	$reverse_bisect =3D 1;
     } else {
@@ -2087,7 +2103,7 @@ sub bisect {
     # Check if a bisect was running
     my $bisect_start_file =3D "$builddir/.git/BISECT_START";
=20
-    my $check =3D $opt{"BISECT_CHECK[$i]"};
+    my $check =3D $bisect_check;
     my $do_check =3D defined($check) && $check ne "0";
=20
     if ( -f $bisect_start_file ) {
@@ -2173,7 +2189,7 @@ sub bisect {
     run_command "git bisect reset" or
 	dodie "could not reset git bisect";
=20
-    doprint "Bad commit was [$bisect_bad]\n";
+    doprint "Bad commit was [$bisect_bad_commit]\n";
=20
     success $i;
 }
@@ -2329,7 +2345,7 @@ sub run_config_bisect {
     }
=20
     doprint "***** RUN TEST ***\n";
-    my $type =3D $opt{"CONFIG_BISECT_TYPE[$iteration]"};
+    my $type =3D $config_bisect_type;
     my $ret;
     my %current_config;
=20
@@ -2433,7 +2449,7 @@ sub run_config_bisect {
 sub config_bisect {
     my ($i) =3D @_;
=20
-    my $start_config =3D $opt{"CONFIG_BISECT[$i]"};
+    my $start_config =3D $config_bisect;
=20
     my $tmpconfig =3D "$tmpdir/use_config";
=20
@@ -2553,22 +2569,22 @@ sub patchcheck {
     my ($i) =3D @_;
=20
     die "PATCHCHECK_START[$i] not defined\n"
-	if (!defined($opt{"PATCHCHECK_START[$i]"}));
+	if (!defined($patchcheck_start));
     die "PATCHCHECK_TYPE[$i] not defined\n"
-	if (!defined($opt{"PATCHCHECK_TYPE[$i]"}));
+	if (!defined($patchcheck_type));
=20
-    my $start =3D $opt{"PATCHCHECK_START[$i]"};
+    my $start =3D $patchcheck_start;
=20
     my $end =3D "HEAD";
-    if (defined($opt{"PATCHCHECK_END[$i]"})) {
-	$end =3D $opt{"PATCHCHECK_END[$i]"};
+    if (defined($patchcheck_end)) {
+	$end =3D $patchcheck_end;
     }
=20
     # Get the true sha1's since we can use things like HEAD~3
     $start =3D get_sha1($start);
     $end =3D get_sha1($end);
=20
-    my $type =3D $opt{"PATCHCHECK_TYPE[$i]"};
+    my $type =3D $patchcheck_type;
=20
     # Can't have a test without having a test to run
     if ($type eq "test" && !defined($run_test)) {
@@ -3366,9 +3382,26 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
     $build_target =3D set_test_option("BUILD_TARGET", $i);
     $ssh_exec =3D set_test_option("SSH_EXEC", $i);
     $scp_to_target =3D set_test_option("SCP_TO_TARGET", $i);
+    $checkout =3D set_test_option("CHECKOUT", $i);
     $target_image =3D set_test_option("TARGET_IMAGE", $i);
     $localversion =3D set_test_option("LOCALVERSION", $i);
=20
+    $bisect_good =3D set_test_option("BISECT_GOOD", $i);
+    $bisect_bad =3D set_test_option("BISECT_BAD", $i);
+    $bisect_type =3D set_test_option("BISECT_TYPE", $i);
+    $bisect_start =3D set_test_option("BISECT_START", $i);
+    $bisect_replay =3D set_test_option("BISECT_REPLAY", $i);
+    $bisect_files =3D set_test_option("BISECT_FILES", $i);
+    $bisect_reverse =3D set_test_option("BISECT_REVERSE", $i);
+    $bisect_check =3D set_test_option("BISECT_CHECK", $i);
+
+    $config_bisect =3D set_test_option("CONFIG_BISECT", $i);
+    $config_bisect_type =3D set_test_option("CONFIG_BISECT_TYPE", $i);
+
+    $patchcheck_type =3D set_test_option("PATCHCHECK_TYPE", $i);
+    $patchcheck_start =3D set_test_option("PATCHCHECK_START", $i);
+    $patchcheck_end =3D set_test_option("PATCHCHECK_END", $i);
+
     $start_minconfig_defined =3D 1;
=20
     if (!defined($start_minconfig)) {
@@ -3405,11 +3438,11 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
=20
     my $run_type =3D $build_type;
     if ($test_type eq "patchcheck") {
-	$run_type =3D $opt{"PATCHCHECK_TYPE[$i]"};
+	$run_type =3D $patchcheck_type;
     } elsif ($test_type eq "bisect") {
-	$run_type =3D $opt{"BISECT_TYPE[$i]"};
+	$run_type =3D $bisect_type;
     } elsif ($test_type eq "config_bisect") {
-	$run_type =3D $opt{"CONFIG_BISECT_TYPE[$i]"};
+	$run_type =3D $config_bisect_type;
     }
=20
     if ($test_type eq "make_min_config") {
@@ -3441,7 +3474,6 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
 	$minconfig =3D "$tmpdir/add_config";
     }
=20
-    my $checkout =3D $opt{"CHECKOUT[$i]"};
     if (defined($checkout)) {
 	run_command "git checkout $checkout" or
 	    die "failed to checkout $checkout";
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBR2JAAoJEIy3vGnGbaoASBwQAMLpI4I9+R6XYaNva5CvXRxb
zM9AQE8osFRITYulWsODvVnFA7gUZZhym95Gv7QIkeFnM5lREEBRZxvN1g7rcWnI
giDU1pYDMNdF9o+eLK2S/CQYt/HS39ybcag61IZgDuN5plIHwypxbJwZaVFjST4T
1B3bIoqr4buinWm/dDidf2dfbTUVDGv15Rn9h+tgksI2gOehh16Bx4EExr0mxFzi
zz7TZtIbdU2jjPfIAlIUMmvTSDtMjXUE8543Wmel0BoZ+x+BFAjhOKkM8GFVM1QA
WWSKc7+5zGTPV53sXPmhH3aGA/omATPWhYUSj7jIzfDmWTd8467Yi2mvmP32gW4p
/d4NkBdLUoeo/t6PXXiFe5icsZ6Wk//TJL51SxRCsuy7Czbv3U+bGkLaPCZUbVng
rQzFBAU9J27PRvIc2io7VUGfit84LrnyamF3/SS/8NM9B7nRk785EMfe7JXFVRJK
S52bX07DRB8LUnC3WEPmCssCIFqpjFOcfSxyluj7w9G9/PSw5qWjU1mYBmsLLVYX
5l6Ve09F5jEWBT+uzoKZVJp2qkIhEnuDV1jdtpSPWMcNbOFL82PgX78RscYBPJiB
M8tcRIv9Wt5npGt98/fdzl6brwFNU9rTr4YIAWftGlUFgOQKqfbRyL7Jg7RQKe2q
LRIvEOnzpgCP5Mxt4h+C
=3AqN
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
