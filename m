Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab2AEDvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:51:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63363 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab2AEDs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:48:26 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=219IcM2GDmkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=MsKxEnH6Rzcg6H9rgtwA:9 a=LpHINaZ8uM0rjt2Y9Y8A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=UON6TZPvHdjqcvBy:21 a=TU50Rr85xsgLc0-m:21 a=pMlOfe03zr7wu7s2ejcA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120105034825.196333819@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 04 Jan 2012 22:48:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 14/20] ktest: Add options SWITCH_TO_GOOD and SWITCH_TO_TEST
References: <20120105034755.793909214@goodmis.org>
Content-Disposition: inline; filename=0014-ktest-Add-options-SWITCH_TO_GOOD-and-SWITCH_TO_TEST.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

For machines that do no use grub, it may be needed to update an
external image (tftp) before doing a reboot into either the
test image or the known good image.

The option SWITCH_TO_GOOD is added, where if it is defined, the
command that is specified as its value will be executed before
doing a reboot into a known good image.

The option SWITCH_TO_TEST is added, where if it is defined, the
command that is specified as its value will be executed before
doing a reboot into the test image.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   33 ++++++++++++++++++++++++++-------
 tools/testing/ktest/sample.conf |   21 +++++++++++++++++++++
 2 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 47c2814..ff21e92 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -79,6 +79,8 @@ my $reboot_script;
 my $power_cycle;
 my $reboot;
 my $reboot_on_error;
+my $switch_to_good;
+my $switch_to_test;
 my $poweroff_on_error;
 my $die_on_failure;
 my $powercycle_after_reboot;
@@ -964,6 +966,17 @@ sub reboot {
     }
 }
=20
+sub reboot_to_good {
+    my ($time) =3D @_;
+
+    if (defined($switch_to_good)) {
+	run_command $switch_to_good;
+	return;
+    }
+
+    reboot $time;
+}
+
 sub do_not_reboot {
     my $i =3D $iteration;
=20
@@ -980,7 +993,7 @@ sub dodie {
     if ($reboot_on_error && !do_not_reboot) {
=20
 	doprint "REBOOTING\n";
-	reboot;
+	reboot_to_good;
=20
     } elsif ($poweroff_on_error && defined($power_off)) {
 	doprint "POWERING OFF\n";
@@ -1116,7 +1129,7 @@ sub fail {
 	# no need to reboot for just building.
 	if (!do_not_reboot) {
 	    doprint "REBOOTING\n";
-	    reboot $sleep_time;
+	    reboot_to_good $sleep_time;
 	}
=20
 	my $name =3D "";
@@ -1269,6 +1282,10 @@ sub wait_for_input
 }
=20
 sub reboot_to {
+    if (defined($switch_to_test)) {
+	run_command $switch_to_test;
+    }
+
     if ($reboot_type eq "grub") {
 	run_ssh "'(echo \"savedefault --default=3D$grub_number --once\" | grub --=
batch)'";
 	reboot;
@@ -1754,7 +1771,7 @@ sub success {
=20
     if ($i !=3D $opt{"NUM_TESTS"} && !do_not_reboot) {
 	doprint "Reboot and wait $sleep_time seconds\n";
-	reboot $sleep_time;
+	reboot_to_good $sleep_time;
     }
 }
=20
@@ -1935,7 +1952,7 @@ sub run_git_bisect {
=20
 sub bisect_reboot {
     doprint "Reboot and sleep $bisect_sleep_time seconds\n";
-    reboot $bisect_sleep_time;
+    reboot_to_good $bisect_sleep_time;
 }
=20
 # returns 1 on success, 0 on failure, -1 on skip
@@ -2528,7 +2545,7 @@ sub config_bisect {
=20
 sub patchcheck_reboot {
     doprint "Reboot and sleep $patchcheck_sleep_time seconds\n";
-    reboot $patchcheck_sleep_time;
+    reboot_to_good $patchcheck_sleep_time;
 }
=20
 sub patchcheck {
@@ -3145,7 +3162,7 @@ sub make_min_config {
 	}
=20
 	doprint "Reboot and wait $sleep_time seconds\n";
-	reboot $sleep_time;
+	reboot_to_good $sleep_time;
     }
=20
     success $i;
@@ -3314,6 +3331,8 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
     $no_install =3D set_test_option("NO_INSTALL", $i);
     $reboot_script =3D set_test_option("REBOOT_SCRIPT", $i);
     $reboot_on_error =3D set_test_option("REBOOT_ON_ERROR", $i);
+    $switch_to_good =3D set_test_option("SWITCH_TO_GOOD", $i);
+    $switch_to_test =3D set_test_option("SWITCH_TO_TEST", $i);
     $poweroff_on_error =3D set_test_option("POWEROFF_ON_ERROR", $i);
     $die_on_failure =3D set_test_option("DIE_ON_FAILURE", $i);
     $power_off =3D set_test_option("POWER_OFF", $i);
@@ -3472,7 +3491,7 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
 if ($opt{"POWEROFF_ON_SUCCESS"}) {
     halt;
 } elsif ($opt{"REBOOT_ON_SUCCESS"} && !do_not_reboot) {
-    reboot;
+    reboot_to_good;
 }
=20
 doprint "\n    $successes of $opt{NUM_TESTS} tests were successful\n\n";
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index 2ff0f8c..c8dc757 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -468,6 +468,27 @@
 # The test will not modify that file.
 #REBOOT_TYPE =3D grub
=20
+# If you are using a machine that doesn't boot with grub, and
+# perhaps gets its kernel from a remote server (tftp), then
+# you can use this option to update the target image with the
+# test image.
+#
+# You could also do the same with POST_INSTALL, but the difference
+# between that option and this option is that POST_INSTALL runs
+# after the install, where this one runs just before a reboot.
+# (default undefined)
+#SWITCH_TO_TEST =3D cp ${OUTPUT_DIR}/${BUILD_TARGET} ${TARGET_IMAGE}
+
+# If you are using a machine that doesn't boot with grub, and
+# perhaps gets its kernel from a remote server (tftp), then
+# you can use this option to update the target image with the
+# the known good image to reboot safely back into.
+#
+# This option holds a command that will execute before needing
+# to reboot to a good known image.
+# (default undefined)
+#SWITCH_TO_GOOD =3D ssh ${SSH_USER}/${MACHINE} cp good_image ${TARGET_IMAG=
E}
+
 # The min config that is needed to build for the machine
 # A nice way to create this is with the following:
 #
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBR2JAAoJEIy3vGnGbaoAWGAP/Rk4KVh6XKHp7NPNUCS782Tn
uLADTrr0yRa9KCjtd3EVqTGS3b9OU6xhB3JiZ6zQp24Ca+B7OrL21qg+Ka8NyGEb
H82/5AeuoERNltYPx4EgswuGtzp06UNdMXiq1BCqfL9P72aUYxNxKxPwgQd9sd4e
WhZc+y0kSGs9RK+VYmpB1PQK3VLx0J2g5r5bagyD1h0EKgwJXAIvZGlHnAZdF6By
PkIE28a7HK2G8GgLgtVoM+EJi3S6+emvVrr3MBxRKWKdty6W5A1gEpWQH8ar7AdU
+Suz0aoclf3rzvkrina9MUjGzQwwmjFSd8v++HI2F24BuUUmB0+PNA/XGR1AHSQz
W76R0r7uuTieAz5oEOeYfXm+rOjQKzFO4kO9M9TBWgEAFz7d1tKjLGNOUWUAchgt
c0U+sVGl5afoY0jqyIizwIfK4GNwaLcFwgjuSLdV8LMhJu41LeJ/X5LIitgVl1/V
WS8F4DWSjxkrM5NecKuLmnwmUxhqVYbWFe/UK0IqbNY3N7mjaD1XNurVaVyZ/Gpc
2dMO9pt0+PhFIIO28QPWmOq3b0BOCasON//4P4tN3VbbDPkAePKNbTIn30i+WR1l
pieZlHDCSZL5xbcbgjw4aweMILNGp9VYVzMBiiBhpGgJtETcuDTZ2STT7+PUOcvA
u1fihum1uwDkqlWTFFnY
=uITt
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
