Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab2LLWQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:16:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12440 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab2LLWPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:15:45 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=HU87RHL30AYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=7ZJdDaSQYaoA:10 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=VwQbUJbxAAAA:8 a=0Rre3N-_Zodnn0pvHE0A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=SUVYIIwCRYHoO-uX:21 a=CniKhAToE1asZ5v-:21 a=xRLAFEQlN7zs-WGbIJ0A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121212221544.165327921@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 12 Dec 2012 17:14:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        John Warthog9 Hawley <warthog9@kernel.org>
Subject: [PATCH 3/5] ktest: Add native support for syslinux boot loader
References: <20121212221437.245229327@goodmis.org>
Content-Disposition: inline; filename=0003-ktest-Add-native-support-for-syslinux-boot-loader.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

I installed Fedora 17 which no longer supports grub v1. I worked
with grub2 for a while, but there's so many issues with it and automated
rebooting, that I decided to switch to syslinux. Instead of using
the REBOOT_SCRIPT and add customized changes to get syslinux booted,
I thought it better to make ktest aware of syslinux and add options
to simplify the use of syslinux on a target test box.

Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: John 'Warthog9' Hawley <warthog9@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   28 +++++++++++++++++++++++++++-
 tools/testing/ktest/sample.conf |   22 +++++++++++++++++++++-
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index f4b8f96..067337b 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -54,6 +54,8 @@ my %default =3D (
     "STOP_TEST_AFTER"		=3D> 600,
     "MAX_MONITOR_WAIT"		=3D> 1800,
     "GRUB_REBOOT"		=3D> "grub2-reboot",
+    "SYSLINUX"			=3D> "extlinux",
+    "SYSLINUX_PATH"		=3D> "/boot/extlinux",
=20
 # required, and we will ask users if they don't have them but we keep the =
default
 # value something that is common.
@@ -109,6 +111,9 @@ my $grub_menu;
 my $grub_file;
 my $grub_number;
 my $grub_reboot;
+my $syslinux;
+my $syslinux_path;
+my $syslinux_label;
 my $target;
 my $make;
 my $pre_install;
@@ -237,6 +242,9 @@ my %option_map =3D (
     "GRUB_MENU"			=3D> \$grub_menu,
     "GRUB_FILE"			=3D> \$grub_file,
     "GRUB_REBOOT"		=3D> \$grub_reboot,
+    "SYSLINUX"			=3D> \$syslinux,
+    "SYSLINUX_PATH"		=3D> \$syslinux_path,
+    "SYSLINUX_LABEL"		=3D> \$syslinux_label,
     "PRE_INSTALL"		=3D> \$pre_install,
     "POST_INSTALL"		=3D> \$post_install,
     "NO_INSTALL"		=3D> \$no_install,
@@ -373,7 +381,7 @@ EOF
     ;
 $config_help{"REBOOT_TYPE"} =3D << "EOF"
  Way to reboot the box to the test kernel.
- Only valid options so far are "grub", "grub2", and "script".
+ Only valid options so far are "grub", "grub2", "syslinux", and "script".
=20
  If you specify grub, it will assume grub version 1
  and will search in /boot/grub/menu.lst for the title \$GRUB_MENU
@@ -386,6 +394,11 @@ $config_help{"REBOOT_TYPE"} =3D << "EOF"
=20
  If you specify grub2, then you also need to specify both \$GRUB_MENU
  and \$GRUB_FILE.
+
+ If you specify syslinux, then you may use SYSLINUX to define the syslinux
+ command (defaults to extlinux), and SYSLINUX_PATH to specify the path to
+ the syslinux install (defaults to /boot/extlinux). But you have to specify
+ SYSLINUX_LABEL to define the label to boot to for the test kernel.
 EOF
     ;
 $config_help{"GRUB_MENU"} =3D << "EOF"
@@ -414,6 +427,11 @@ $config_help{"GRUB_FILE"} =3D << "EOF"
  here. Use something like /boot/grub2/grub.cfg to search.
 EOF
     ;
+$config_help{"SYSLINUX_LABEL"} =3D << "EOF"
+ If syslinux is used, the label that boots the target kernel must
+ be specified with SYSLINUX_LABEL.
+EOF
+    ;
 $config_help{"REBOOT_SCRIPT"} =3D << "EOF"
  A script to reboot the target into the test kernel
  (Only mandatory if REBOOT_TYPE =3D script)
@@ -545,6 +563,10 @@ sub get_ktest_configs {
 	get_ktest_config("GRUB_MENU");
 	get_ktest_config("GRUB_FILE");
     }
+
+    if ($rtype eq "syslinux") {
+	get_ktest_config("SYSLINUX_LABEL");
+    }
 }
=20
 sub process_variables {
@@ -1589,6 +1611,8 @@ sub reboot_to {
 	run_ssh "'(echo \"savedefault --default=3D$grub_number --once\" | grub --=
batch)'";
     } elsif ($reboot_type eq "grub2") {
 	run_ssh "$grub_reboot $grub_number";
+    } elsif ($reboot_type eq "syslinux") {
+	run_ssh "$syslinux --once \\\"$syslinux_label\\\" $syslinux_path";
     } elsif (defined $reboot_script) {
 	run_command "$reboot_script";
     }
@@ -3768,6 +3792,8 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
 	} elsif ($reboot_type eq "grub2") {
 	    dodie "GRUB_MENU not defined" if (!defined($grub_menu));
 	    dodie "GRUB_FILE not defined" if (!defined($grub_file));
+	} elsif ($reboot_type eq "syslinux") {
+	    dodie "SYSLINUX_LABEL not defined" if (!defined($syslinux_label));
 	}
     }
=20
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index 57617ec..4012e93 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -364,6 +364,22 @@
 #
 #GRUB_MENU =3D Test Kernel
=20
+# For REBOOT_TYPE =3D syslinux, the name of the syslinux executable
+# (on the target) to use to set up the next reboot to boot the
+# test kernel.
+# (default extlinux)
+#SYSLINUX =3D syslinux
+
+# For REBOOT_TYPE =3D syslinux, the path that is passed to to the
+# syslinux command where syslinux is installed.
+# (default /boot/extlinux)
+#SYSLINUX_PATH =3D /boot/syslinux
+
+# For REBOOT_TYPE =3D syslinux, the syslinux label that references the
+# test kernel in the syslinux config file.
+# (default undefined)
+#SYSLINUX_LABEL =3D "test-kernel"
+
 # A script to reboot the target into the test kernel
 # This and SWITCH_TO_TEST are about the same, except
 # SWITCH_TO_TEST is run even for REBOOT_TYPE =3D grub.
@@ -516,7 +532,7 @@
 #POST_BUILD_DIE =3D 1
=20
 # Way to reboot the box to the test kernel.
-# Only valid options so far are "grub", "grub2" and "script"
+# Only valid options so far are "grub", "grub2", "syslinux" and "script"
 # (default grub)
 # If you specify grub, it will assume grub version 1
 # and will search in /boot/grub/menu.lst for the title $GRUB_MENU
@@ -527,6 +543,10 @@
 # For REBOOT_TYPE =3D grub2, you must define both GRUB_MENU and
 # GRUB_FILE.
 #
+# For REBOOT_TYPE =3D syslinux, you must define SYSLINUX_LABEL, and
+# perhaps modify SYSLINUX (default extlinux) and SYSLINUX_PATH
+# (default /boot/extlinux)
+#
 # The entry in /boot/grub/menu.lst must be entered in manually.
 # The test will not modify that file.
 #REBOOT_TYPE =3D grub
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQyQIQAAoJEOdOSU1xswtMARIH/1gAwFe5wqdLZmjhlQMbVpON
Zp7a+k6FH0RQF8uSHne3y8Y8Yo010QopNAG/aNR45sogwZxyvP9CKgPFrsitoZ+l
F0W2CmFxd9ytpKRcZ1jajBqNHVIAJoKj2v2BNIo9D0yJHQxZSQkliJuApL6+HGGN
S4xG2meIaie3xai+Eq3ACzGGagMLvxrXZ72BwrfCRXQxFxg/qnwfLW1xHZ5Iu6LT
0rKe3NOJI8qev/3FT53bXGZveqSQRkqnSg+KIR+iyDHUGsAaK0tsqJbtPjG+bqQM
jIvvPC8W5WHvC6W2mFKHgZmKW1YvZbuzQpMuaxaSSI/iSilO7OTpBsahkefYhCo=
=wr9J
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
