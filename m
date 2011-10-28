Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab1J1LYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:24:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab1J1LUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:20:21 -0400
X-Authority-Analysis: v=1.1 cv=dCTC1p3vNTdx1H6U0HtbMKjJ9bTEtPwCLJ4qOUv6lx4= c=1 sm=0 a=vhdKIqpQuCYA:10 a=6Mc5Nmu5D4kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=EOjbvJ8Y0MT3O1Ua2AYA:9 a=GUWOx1SM66l2TzKvHh8A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=bqwy9bwCJzqER_7q:21 a=VKljtPumy7uPvgbQ:21 a=q25IntYG1Ll27FC1wtYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111028112018.130650509@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 Oct 2011 07:16:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 08/21] ktest: Do not reboot on config or build issues
References: <20111028111558.173726794@goodmis.org>
Content-Disposition: inline; filename=0008-ktest-Do-not-reboot-on-config-or-build-issues.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Even if REBOOT_ON_ERROR is set, it becomes annoying that the target
machine is rebooted when a config option is incorrect or a build
fails. There's no reason to reboot the target for host only issues.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 51ddaa5..057676a 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -133,6 +133,9 @@ my %config_help;
 my %variable;
 my %force_config;
=20
+# do not force reboots on config problems
+my $no_reboot =3D 1;
+
 $config_help{"MACHINE"} =3D << "EOF"
  The machine hostname that you will test.
 EOF
@@ -640,7 +643,7 @@ sub reboot {
 sub do_not_reboot {
     my $i =3D $iteration;
=20
-    return $test_type eq "build" ||
+    return $test_type eq "build" || $no_reboot ||
 	($test_type eq "patchcheck" && $opt{"PATCHCHECK_TYPE[$i]"} eq "build") ||
 	($test_type eq "bisect" && $opt{"BISECT_TYPE[$i]"} eq "build");
 }
@@ -1285,6 +1288,10 @@ sub build {
=20
     unlink $buildlog;
=20
+    # Failed builds should not reboot the target
+    my $save_no_reboot =3D $no_reboot;
+    $no_reboot =3D 1;
+
     if (defined($pre_build)) {
 	my $ret =3D run_command $pre_build;
 	if (!$ret && defined($pre_build_die) &&
@@ -1353,10 +1360,15 @@ sub build {
=20
     if (!$build_ret) {
 	# bisect may need this to pass
-	return 0 if ($in_bisect);
+	if ($in_bisect) {
+	    $no_reboot =3D $save_no_reboot;
+	    return 0;
+	}
 	fail "failed build" and return 0;
     }
=20
+    $no_reboot =3D $save_no_reboot;
+
     return 1;
 }
=20
@@ -2806,6 +2818,9 @@ sub set_test_option {
 # First we need to do is the builds
 for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
=20
+    # Do not reboot on failing test options
+    $no_reboot =3D 1;
+
     $iteration =3D $i;
=20
     my $makecmd =3D set_test_option("MAKE_CMD", $i);
@@ -2941,6 +2956,9 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
 	    die "failed to checkout $checkout";
     }
=20
+    $no_reboot =3D 0;
+
+
     if ($test_type eq "bisect") {
 	bisect $i;
 	next;
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOqo/yAAoJEIy3vGnGbaoA/e8QAOpOqDvv+/i+yTR+KgFMmTBb
yo3MHQ0k8CfQGs+ocavTKrJkm6qka3NJoXnOnV8BHyaUtlqpRpB5FXHmDX+U9R2b
imBvVNovQJUvvYZQnxG+lfsvpYA3RcajaHZJXTayZ3aK304yr9QBQks3eEyTYOr0
ZlbVoVwMxzvCKWee1QVgBlkoBKema8hhFvWWQ8YPLIjPpSIYFcM24Y8Vm2eOubdR
KQPaoBmgQgVEsjKOwl/pWjI7aruP0wPgE07Babsao0HgNjcP80IWi/rHd9kjv5x9
KcC7NrpiE6Eq/HrRvJ9sO+8c9aimB76Q5uDhMIcO/VcvTMlJ0mW4KB3MLtxmOsD5
Hhqiuh3ch71GJm0iTpnldUhrgL2+GHOE5f6XhoT7+gFy5dfgNg5Zchpd1rgM6VYo
TCjyTd/3PasfXoZy2HqV5c5Z+1j09lEXHG7s6Pb7Dc0OsxLmLWDD4B+26hFaLqPM
pVHYNmawGjJxDTNARltWm1Nxrj2x2oaf+N65OZ3f/AJIZqAmnhsrHInNzAI7w+42
zRA+qLr+gqVfSvi+xyq/o4qL7fIA1JWJhoI9ta3CQLXGDC9qkQk7gGkBLTPvHlTI
8REEe9XN4bUpjmerb41ZOv+76TcKBbSc8TMA5ioXkkihAJNIcEDd6STy3qGsLTdD
Yo6EfbXBDrqrokZ4Bl7P
=FLMP
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
