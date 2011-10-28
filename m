Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab1J1LY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:24:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36751 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab1J1LUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:20:16 -0400
X-Authority-Analysis: v=1.1 cv=PzmnriOiyqYdyw8suerSEFMr8oy2Ua58JL+Rk7iuDKE= c=1 sm=0 a=vhdKIqpQuCYA:10 a=CikNVDQLwmAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=naH2w8ClI-P2GX4P7P8A:9 a=vxBg8trNK5pP-a56xfQA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=k0_IMW1n6nxiKHhj:21 a=DNIGOo4VqhQ6Tn51:21 a=McT7lFRd-AWDxImo3X0A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111028112013.850548144@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 Oct 2011 07:16:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 06/21] ktest: Add NO_INSTALL option to not install for a test
References: <20111028111558.173726794@goodmis.org>
Content-Disposition: inline; filename=0006-ktest-Add-NO_INSTALL-option-to-not-install-for-a-tes.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

There's cases where running the same kernel over and over again
is useful, and being able to not install the same kernel can
save time between tests.

Add a NO_INSTALL option that tells ktest.pl to not install the
new kernel.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   10 +++++++++-
 tools/testing/ktest/sample.conf |    7 +++++++
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index ca6ff99..74fb2ac 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -42,6 +42,7 @@ $default{"BISECT_MANUAL"}	=3D 0;
 $default{"BISECT_SKIP"}		=3D 1;
 $default{"SUCCESS_LINE"}	=3D "login:";
 $default{"DETECT_TRIPLE_FAULT"} =3D 1;
+$default{"NO_INSTALL"}		=3D 0;
 $default{"BOOTED_TIMEOUT"}	=3D 1;
 $default{"DIE_ON_FAILURE"}	=3D 1;
 $default{"SSH_EXEC"}		=3D "ssh \$SSH_USER\@\$MACHINE \$SSH_COMMAND";
@@ -84,6 +85,7 @@ my $grub_number;
 my $target;
 my $make;
 my $post_install;
+my $no_install;
 my $noclean;
 my $minconfig;
 my $start_minconfig;
@@ -1094,6 +1096,8 @@ sub do_post_install {
=20
 sub install {
=20
+    return if ($no_install);
+
     run_scp "$outputdir/$build_target", "$target_image" or
 	dodie "failed to copy image";
=20
@@ -2810,6 +2814,7 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
     $reboot_type =3D set_test_option("REBOOT_TYPE", $i);
     $grub_menu =3D set_test_option("GRUB_MENU", $i);
     $post_install =3D set_test_option("POST_INSTALL", $i);
+    $no_install =3D set_test_option("NO_INSTALL", $i);
     $reboot_script =3D set_test_option("REBOOT_SCRIPT", $i);
     $reboot_on_error =3D set_test_option("REBOOT_ON_ERROR", $i);
     $poweroff_on_error =3D set_test_option("POWEROFF_ON_ERROR", $i);
@@ -2890,8 +2895,11 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
 	$run_type =3D "ERROR";
     }
=20
+    my $installme =3D "";
+    $installme =3D " no_install" if ($no_install);
+
     doprint "\n\n";
-    doprint "RUNNING TEST $i of $opt{NUM_TESTS} with option $test_type $ru=
n_type\n\n";
+    doprint "RUNNING TEST $i of $opt{NUM_TESTS} with option $test_type $ru=
n_type$installme\n\n";
=20
     unlink $dmesg;
     unlink $buildlog;
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index eadca3e..b3e0dc1 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -294,6 +294,13 @@
 # or on some systems:
 #POST_INSTALL =3D ssh user@target /sbin/dracut -f /boot/initramfs-test.img=
 $KERNEL_VERSION
=20
+# If for some reason you just want to boot the kernel and you do not
+# want the test to install anything new. For example, you may just want
+# to boot test the same kernel over and over and do not want to go through
+# the hassle of installing anything, you can set this option to 1
+# (default 0)
+#NO_INSTALL =3D 1
+
 # If there is a script that you require to run before the build is done
 # you can specify it with PRE_BUILD.
 #
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOqo/uAAoJEIy3vGnGbaoAM1kP/imIHChTzXjbEzVei/K3G375
HnxJxHM85x51JHYomKIyBioWQA/FjJEtunDEnrvleb5Ygnwxu4E3sv1msQZi28x0
6NgxwkM0hdapfZo1UFqHen7iRRdAtN+AIs0Z3VHrLY/OUzVQqHy+K/8Lh1OMc/3n
mUuWIlC/21riDKZVpakpNWip+dEigF/VXEpYQL+OMtQp/cL8hkkxifXD6bstn8oU
+QIDWzBmvxfCkKmeD3WWmA83mR/vwJdjEqmJBLCqo8bPn71bPZNm2DEEXyG/BeAz
y7B3onwA6xvmiYl+nF5Ciar1/fnB7rwaw2hXajPI/9WvnjO65R7AUbvbEi0aqZL4
AdX13htbb3J9t66H1/8TyhXPT4Dt6itEghl99itF0gLG0/XGPS1Q136DkAw6Cquq
y6LbjdDB0CjW8hsX5Q/SaKNSyU5LqDAqONSHdWkZwAFahK7g0dn4Wa/R/LK0Lf4h
ByESuNr97jX/2OfJC9a2DNDvsGgvoSx73E0kUINhLiyjGDkG3YgilDImmJaogSxJ
2dDEa6joMNreY7VBZTfFzLWXx4TeVMqzBki2G+nLcC1G6yJUI3jN6xowaip9DzKH
mUOy46er6UwMKKXM0XCpd9ZDc5bHm5OYIBamKmcj/Ri9aOqa9+KnDnbFR8HuvkHT
87pJ6IQ7wLegqVbHDFbs
=HOsx
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
