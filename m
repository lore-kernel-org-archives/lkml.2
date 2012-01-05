Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab2AEDsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:48:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770Ab2AEDsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:48:24 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=hKwKqxHj1oIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=meVymXHHAAAA:8 a=JXcDg1lMw95lLQokmGcA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ESe3K-8YdiT5FNqk:21 a=wgDaOiYFAQ1ES2IO:21 a=rNZzu46FCpiwJDvs0RkA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120105034823.336859585@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 04 Jan 2012 22:48:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 08/20] ktest: Do not ask for some options if the only test is build
References: <20120105034755.793909214@goodmis.org>
Content-Disposition: inline; filename=0008-ktest-Do-not-ask-for-some-options-if-the-only-test-i.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When creating a ktest config or if te config only has build only
tests, some of the manditory config options are not needed.

Do not ask for them if all tests in the config file are just build
tests.

Suggested-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   43 ++++++++++++++++++++++++++++++--------=
---
 1 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index f50b44f..7159e10 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -22,7 +22,7 @@ my %default;
=20
 #default opts
 $default{"NUM_TESTS"}		=3D 1;
-$default{"TEST_TYPE"}		=3D "test";
+$default{"TEST_TYPE"}		=3D "build";
 $default{"BUILD_TYPE"}		=3D "randconfig";
 $default{"MAKE_CMD"}		=3D "make";
 $default{"TIMEOUT"}		=3D 120;
@@ -136,6 +136,10 @@ my $localversion;
 my $iteration =3D 0;
 my $successes =3D 0;
=20
+# set when a test is something other that just building
+# which would require more options.
+my $buildonly =3D 1;
+
 my %entered_configs;
 my %config_help;
 my %variable;
@@ -149,6 +153,7 @@ chomp ($variable{"PWD"} =3D `pwd`);
=20
 $config_help{"MACHINE"} =3D << "EOF"
  The machine hostname that you will test.
+ For build only tests, it is still needed to differentiate log files.
 EOF
     ;
 $config_help{"SSH_USER"} =3D << "EOF"
@@ -321,15 +326,22 @@ sub get_ktest_config {
=20
 sub get_ktest_configs {
     get_ktest_config("MACHINE");
-    get_ktest_config("SSH_USER");
     get_ktest_config("BUILD_DIR");
     get_ktest_config("OUTPUT_DIR");
-    get_ktest_config("BUILD_TARGET");
-    get_ktest_config("TARGET_IMAGE");
-    get_ktest_config("POWER_CYCLE");
-    get_ktest_config("CONSOLE");
+
+    # options required for other than just building a kernel
+    if (!$buildonly) {
+	get_ktest_config("SSH_USER");
+	get_ktest_config("BUILD_TARGET");
+	get_ktest_config("TARGET_IMAGE");
+	get_ktest_config("POWER_CYCLE");
+	get_ktest_config("CONSOLE");
+    }
+
     get_ktest_config("LOCALVERSION");
=20
+    return if ($buildonly);
+
     my $rtype =3D $opt{"REBOOT_TYPE"};
=20
     if (!defined($rtype)) {
@@ -388,6 +400,12 @@ sub process_variables {
 sub set_value {
     my ($lvalue, $rvalue, $override, $overrides, $name) =3D @_;
=20
+    if ($lvalue =3D~ /^TEST_TYPE(\[.*\])?$/ && $rvalue ne "build") {
+	# Note if a test is something other than build, then we
+	# will need other manditory options.
+	$buildonly =3D 0;
+    }
+
     if (defined($opt{$lvalue})) {
 	if (!$override || defined(${$overrides}{$lvalue})) {
 	    my $extra =3D "";
@@ -3271,18 +3289,19 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
     $ENV{"SSH_USER"} =3D $ssh_user;
     $ENV{"MACHINE"} =3D $machine;
=20
-    $target =3D "$ssh_user\@$machine";
-
     $buildlog =3D "$tmpdir/buildlog-$machine";
     $testlog =3D "$tmpdir/testlog-$machine";
     $dmesg =3D "$tmpdir/dmesg-$machine";
     $make =3D "$makecmd O=3D$outputdir";
     $output_config =3D "$outputdir/.config";
=20
-    if ($reboot_type eq "grub") {
-	dodie "GRUB_MENU not defined" if (!defined($grub_menu));
-    } elsif (!defined($reboot_script)) {
-	dodie "REBOOT_SCRIPT not defined"
+    if (!$buildonly) {
+	$target =3D "$ssh_user\@$machine";
+	if ($reboot_type eq "grub") {
+	    dodie "GRUB_MENU not defined" if (!defined($grub_menu));
+	} elsif (!defined($reboot_script)) {
+	    dodie "REBOOT_SCRIPT not defined"
+	}
     }
=20
     my $run_type =3D $build_type;
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBR2HAAoJEIy3vGnGbaoAGR0QAOk6DLeCzXKFJiDUxgsLuK8/
UnAy+rg95IX9nT8zAQllp8V3J4PExds78VnvJOj4lSt5sMDkk52WZq/+zVeM6FYP
RFKQSWSzjxBtuZCOqqSdh/6TYEBn6+oK3Q3vOdFzCHhtreMvB/C0jrKqu1i+f1w4
PF/KyvCPFSkMjgz3qPCNw04vBVY9tY2ix66EXaQa9IV2ohH41s2HbBtvlzgykVAe
1nbtNMb6K8A6uz0RJ+5vO1D69tA9gbDeCW2Wc32km1eKPHLS7rSYrwpEV6kl/v98
7EIDDNbWq6D6tY3ftNXHJa4Hd+stLV1Nk1+81xdkyRM4RjSbIShpu7wgMhLVL/mx
P6CvxeiWvIhjyj69ykZ5k18rw2YRAQmNu3MUqrVaGiHg8MckcNf1HR3WMOby6cpO
/qjdFNtzUskNAF26bGENdc4aaNWLVefpCqf4RcGdC3If92CSTkx7Gmnf01GAoiFI
A9jqjp2MbuV1/KIvSPYq3xsksjBKUmm1JxlaPHIq3XkMN0q+9oIeV/z24CTjvtJd
OMWLORZohPSf7K4hZQJtReIP85jpzI/HAnLKjuNyPEtHXVp0mtwrVnDgRMmWDHqz
slYnI9xt/wMzjPdtQk71kC4izBbbrIEt5OukeVQUwPtbZ8FHfurGSnqc6xyf/GVO
/qM1ZhDstm+CsP4TSZDr
=dODZ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
