Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab1JQQ7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:59:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45329 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab1JQQ7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:59:50 -0400
X-Authority-Analysis: v=1.1 cv=G2mrdTwFgeQf4gnIVCGl5REDSA/JVLCrZmxI9r5hHjY= c=1 sm=0 a=vhdKIqpQuCYA:10 a=F_gZ6J38438A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=naH2w8ClI-P2GX4P7P8A:9 a=vxBg8trNK5pP-a56xfQA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=k0_IMW1n6nxiKHhj:21 a=DNIGOo4VqhQ6Tn51:21 a=p55yOnOV5VJVtr6QVq4A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111017165949.728701450@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 17 Oct 2011 12:05:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 06/17][RFC] ktest: Add NO_INSTALL option to not install for a test
References: <20111017160455.498567257@goodmis.org>
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

iQIcBAABAgAGBQJOnF8FAAoJEIy3vGnGbaoAE6EP/1HfcM13VbpgatHz81OfP3wC
76u5YpizaghxG3Df+V/EdRGK8mmgPmIAzUHzqxfkZFpldZjP7O+xkC2RQiwd0IB8
rtdUQkAM+5j+WKWDYojgI7GrZkTIcNTSFPTTxrQpRGH0qcBfN6wKLXTKCszQqWC0
ybT4otttmhIXIpX8u9ak2uf/jqPjTi2Yb83wk37saG2Of9WA1SZZsa4HSR+5lseA
XyCGYzHCaCe8UaM/GV5ikYkeh2Er+d9qsW890i1wgWUoOrqAAI/9SnasN9VSt7wr
4bA0uq9qVj2EsENlA3fI9UOP8oNE2TcXg58mdQffbh51Jjxguk+WAdrUeNc/ABZ5
pMidFsc6riCDr4bjTUBGZ2bEqHTfpolT6P84yBo6iSday782hPrKWRFxaBzlG/q0
dZt2+TsPw1PBfZbLGrbzpG1NgvWgy40G4UKnftYggRnOyoWE2jiRiPkQ0SFkVc1x
aJhr69gvqwSSTdUrIHzdk5gwVeonSOKX5eJnIcHSVXnlZ9Ad6OSwgwwKM8ZhnitV
BuwDK999RGbxNoCVmodru0k6s+vd00UqyOEOrd0M1MWSXkZ9GTRoT8Y1h4AY3Uyu
aIPQcywdE0N8CsDFU8RPVfCPfXqQdyanT6sWcMpkGQHU/rQ0/g+oLkSHGzEqaP/8
d0wADyYK4+KU1ohS6DhI
=WKXW
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
