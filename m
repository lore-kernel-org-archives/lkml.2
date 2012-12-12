Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab2LLWQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:16:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25576 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab2LLWPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:15:45 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=GMVl4loFy5EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=C8IVCphtoh8A:10 a=20KFwNOVAAAA:8 a=ZAa7fEOZ1A9KKmsj3JwA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Bm2AAUd2Y0yw2VdW:21 a=44oN3kd3m2GbMfX8:21 a=NpecSKJieX_mCIyY:21 a=tSiLWyvzqFRHjtTzFKEA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121212221543.812138431@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 12 Dec 2012 17:14:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/5] ktest: Add support for grub2
References: <20121212221437.245229327@goodmis.org>
Content-Disposition: inline; filename=0001-ktest-Add-support-for-grub2.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

As only grub or 'script' is supported for rebooting to a new kernel,
and Fedora 17 has dropped support for grub, I decided to add grub2
support as well (I also plan on adding syslinux/extlinux support too).

The options GRUB_FILE and GRUB_REBOOT were added to allow the user
to specify where to find the grub.cfg and what tool to use to reboot
into the next kernel respectively.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   69 +++++++++++++++++++++++++++++++++++=
++--
 tools/testing/ktest/sample.conf |   26 +++++++++++++--
 2 files changed, 91 insertions(+), 4 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index c7ba761..63245a5 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -53,6 +53,7 @@ my %default =3D (
     "STOP_AFTER_FAILURE"	=3D> 60,
     "STOP_TEST_AFTER"		=3D> 600,
     "MAX_MONITOR_WAIT"		=3D> 1800,
+    "GRUB_REBOOT"		=3D> "grub2-reboot",
=20
 # required, and we will ask users if they don't have them but we keep the =
default
 # value something that is common.
@@ -105,7 +106,9 @@ my $scp_to_target;
 my $scp_to_target_install;
 my $power_off;
 my $grub_menu;
+my $grub_file;
 my $grub_number;
+my $grub_reboot;
 my $target;
 my $make;
 my $pre_install;
@@ -232,6 +235,8 @@ my %option_map =3D (
     "ADD_CONFIG"		=3D> \$addconfig,
     "REBOOT_TYPE"		=3D> \$reboot_type,
     "GRUB_MENU"			=3D> \$grub_menu,
+    "GRUB_FILE"			=3D> \$grub_file,
+    "GRUB_REBOOT"		=3D> \$grub_reboot,
     "PRE_INSTALL"		=3D> \$pre_install,
     "POST_INSTALL"		=3D> \$post_install,
     "NO_INSTALL"		=3D> \$no_install,
@@ -368,7 +373,7 @@ EOF
     ;
 $config_help{"REBOOT_TYPE"} =3D << "EOF"
  Way to reboot the box to the test kernel.
- Only valid options so far are "grub" and "script".
+ Only valid options so far are "grub", "grub2", and "script".
=20
  If you specify grub, it will assume grub version 1
  and will search in /boot/grub/menu.lst for the title \$GRUB_MENU
@@ -378,11 +383,14 @@ $config_help{"REBOOT_TYPE"} =3D << "EOF"
=20
  The entry in /boot/grub/menu.lst must be entered in manually.
  The test will not modify that file.
+
+ If you specify grub2, then you also need to specify both \$GRUB_MENU
+ and \$GRUB_FILE.
 EOF
     ;
 $config_help{"GRUB_MENU"} =3D << "EOF"
  The grub title name for the test kernel to boot
- (Only mandatory if REBOOT_TYPE =3D grub)
+ (Only mandatory if REBOOT_TYPE =3D grub or grub2)
=20
  Note, ktest.pl will not update the grub menu.lst, you need to
  manually add an option for the test. ktest.pl will search
@@ -393,6 +401,17 @@ $config_help{"GRUB_MENU"} =3D << "EOF"
  title Test Kernel
  kernel vmlinuz-test
  GRUB_MENU =3D Test Kernel
+
+ For grub2, a search of \$GRUB_FILE is performed for the lines
+ that begin with "menuentry". It will not detect submenus. The
+ menu must be a non-nested menu. Add the quotes used in the menu
+ to guarantee your selection, as the first menuentry with the content
+ of \$GRUB_MENU that is found will be used.
+EOF
+    ;
+$config_help{"GRUB_FILE"} =3D << "EOF"
+ If grub2 is used, the full path for the grub.cfg file is placed
+ here. Use something like /boot/grub2/grub.cfg to search.
 EOF
     ;
 $config_help{"REBOOT_SCRIPT"} =3D << "EOF"
@@ -521,6 +540,11 @@ sub get_ktest_configs {
     if ($rtype eq "grub") {
 	get_ktest_config("GRUB_MENU");
     }
+
+    if ($rtype eq "grub2") {
+	get_ktest_config("GRUB_MENU");
+	get_ktest_config("GRUB_FILE");
+    }
 }
=20
 sub process_variables {
@@ -1452,8 +1476,44 @@ sub run_scp_mod {
     return run_scp($src, $dst, $cp_scp);
 }
=20
+sub get_grub2_index {
+
+    return if (defined($grub_number));
+
+    doprint "Find grub2 menu ... ";
+    $grub_number =3D -1;
+
+    my $ssh_grub =3D $ssh_exec;
+    $ssh_grub =3D~ s,\$SSH_COMMAND,cat $grub_file,g;
+
+    open(IN, "$ssh_grub |")
+	or die "unable to get $grub_file";
+
+    my $found =3D 0;
+
+    while (<IN>) {
+	if (/^menuentry.*$grub_menu/) {
+	    $grub_number++;
+	    $found =3D 1;
+	    last;
+	} elsif (/^menuentry\s/) {
+	    $grub_number++;
+	}
+    }
+    close(IN);
+
+    die "Could not find '$grub_menu' in $grub_file on $machine"
+	if (!$found);
+    doprint "$grub_number\n";
+}
+
 sub get_grub_index {
=20
+    if ($reboot_type eq "grub2") {
+	get_grub2_index;
+	return;
+    }
+
     if ($reboot_type ne "grub") {
 	return;
     }
@@ -1524,6 +1584,8 @@ sub reboot_to {
=20
     if ($reboot_type eq "grub") {
 	run_ssh "'(echo \"savedefault --default=3D$grub_number --once\" | grub --=
batch)'";
+    } elsif ($reboot_type eq "grub2") {
+	run_ssh "$grub_reboot $grub_number";
     } elsif (defined $reboot_script) {
 	run_command "$reboot_script";
     }
@@ -3700,6 +3762,9 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
 	$target =3D "$ssh_user\@$machine";
 	if ($reboot_type eq "grub") {
 	    dodie "GRUB_MENU not defined" if (!defined($grub_menu));
+	} elsif ($reboot_type eq "grub2") {
+	    dodie "GRUB_MENU not defined" if (!defined($grub_menu));
+	    dodie "GRUB_FILE not defined" if (!defined($grub_file));
 	}
     }
=20
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index de28a0a..57617ec 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -332,8 +332,18 @@
 # from other linux builds on the system.
 #LOCALVERSION =3D -test
=20
+# For REBOOT_TYPE =3D grub2, you must specify where the grub.cfg
+# file is. This is the file that is searched to find the menu
+# option to boot to with GRUB_REBOOT
+#GRUB_FILE =3D /boot/grub2/grub.cfg
+
+# The tool for REBOOT_TYPE =3D grub2 to set the next reboot kernel
+# to boot into (one shot mode).
+# (default grub2_reboot)
+#GRUB_REBOOT =3D grub2_reboot
+
 # The grub title name for the test kernel to boot
-# (Only mandatory if REBOOT_TYPE =3D grub)
+# (Only mandatory if REBOOT_TYPE =3D grub or grub2)
 #
 # Note, ktest.pl will not update the grub menu.lst, you need to
 # manually add an option for the test. ktest.pl will search
@@ -343,6 +353,15 @@
 # For example, if in the /boot/grub/menu.lst the test kernel title has:
 # title Test Kernel
 # kernel vmlinuz-test
+#
+# For grub2, a search of top level "menuentry"s are done. No
+# submenu is searched. The menu is found by searching for the
+# contents of GRUB_MENU in the line that starts with "menuentry".
+# You may want to include the quotes around the option. For example:
+# for: menuentry 'Test Kernel'
+# do a: GRUB_MENU =3D 'Test Kernel'
+# For customizing, add your entry in /etc/grub.d/40_custom.
+#
 #GRUB_MENU =3D Test Kernel
=20
 # A script to reboot the target into the test kernel
@@ -497,7 +516,7 @@
 #POST_BUILD_DIE =3D 1
=20
 # Way to reboot the box to the test kernel.
-# Only valid options so far are "grub" and "script"
+# Only valid options so far are "grub", "grub2" and "script"
 # (default grub)
 # If you specify grub, it will assume grub version 1
 # and will search in /boot/grub/menu.lst for the title $GRUB_MENU
@@ -505,6 +524,9 @@
 # your setup, then specify "script" and have a command or script
 # specified in REBOOT_SCRIPT to boot to the target.
 #
+# For REBOOT_TYPE =3D grub2, you must define both GRUB_MENU and
+# GRUB_FILE.
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

iQEcBAABAgAGBQJQyQIPAAoJEOdOSU1xswtMq/8H/RitaRBtK3uJjCFA3pyxKjrn
FGaIcz4W0yVY/MAfWGhWy/Hkdvkvl52HBhzh0zmmELUd2vfyhNocgZfGUGo4Df/L
gMUZGwTBheKD/Rxw83ZOP8qEfLX/L6ZRtvHmV0UyrcmKQbTB+99qBKi5x+AKGaep
K7zTnRZ9vjF2b4osT67azdpQiFtIDXYSnYSVqE/DWkJ0nkcGp3GQIUDFGZvGbOfJ
edCTblGaObNptIrYEs2HUTQ5j/qR4U1DiFbO0foI/bW1qsJYoZCY3AJfB3m+GStb
Ngeh5doNnU6A8yRsgloRinlB0ZcpKTEH623Yt/Dfw/0E1DwGEjTUhj0D9fySKuY=
=26iz
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
