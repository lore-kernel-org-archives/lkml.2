Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab2CUQD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:03:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790Ab2CUQCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:02:45 -0400
X-Authority-Analysis: v=2.0 cv=UcbTuduN c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=9mNETcBehAsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=q12GCDr3aBSW22yVJi8A:9 a=zb9ZikdVeeV7jsKTdbAA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=zPnJbaTCryifsujrk30A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120321160243.845311481@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 21 Mar 2012 12:01:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/5] ktest: Add SCP_TO_TARGET_INSTALL option
References: <20120321160125.496052559@goodmis.org>
Content-Disposition: inline; filename=0003-ktest-Add-SCP_TO_TARGET_INSTALL-option.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Currently the option used to scp both the modules to the target as well
as the kernel image are the same (SCP_TO_TARGET). But some embedded
boards may require them to be different. The modules may need to be put
directly on the board, but the kernel image may need to go to a
tftpserver.

Add the option SCP_TO_TARGET_INSTALL that will allow the user to change
the config so that they may have the modules and image got to different
machines.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   26 ++++++++++++++++++++++----
 tools/testing/ktest/sample.conf |   14 +++++++++++---
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 0a5f6cb..1143e6c 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -46,6 +46,7 @@ my %default =3D (
     "DIE_ON_FAILURE"		=3D> 1,
     "SSH_EXEC"			=3D> "ssh \$SSH_USER\@\$MACHINE \$SSH_COMMAND",
     "SCP_TO_TARGET"		=3D> "scp \$SRC_FILE \$SSH_USER\@\$MACHINE:\$DST_FILE=
",
+    "SCP_TO_TARGET_INSTALL"	=3D> "\${SCP_TO_TARGET}",
     "REBOOT"			=3D> "ssh \$SSH_USER\@\$MACHINE reboot",
     "STOP_AFTER_SUCCESS"	=3D> 10,
     "STOP_AFTER_FAILURE"	=3D> 60,
@@ -91,6 +92,7 @@ my $powercycle_after_reboot;
 my $poweroff_after_halt;
 my $ssh_exec;
 my $scp_to_target;
+my $scp_to_target_install;
 my $power_off;
 my $grub_menu;
 my $grub_number;
@@ -243,6 +245,7 @@ my %option_map =3D (
     "BUILD_TARGET"		=3D> \$build_target,
     "SSH_EXEC"			=3D> \$ssh_exec,
     "SCP_TO_TARGET"		=3D> \$scp_to_target,
+    "SCP_TO_TARGET_INSTALL"	=3D> \$scp_to_target_install,
     "CHECKOUT"			=3D> \$checkout,
     "TARGET_IMAGE"		=3D> \$target_image,
     "LOCALVERSION"		=3D> \$localversion,
@@ -1349,8 +1352,7 @@ sub run_ssh {
 }
=20
 sub run_scp {
-    my ($src, $dst) =3D @_;
-    my $cp_scp =3D $scp_to_target;
+    my ($src, $dst, $cp_scp) =3D @_;
=20
     $cp_scp =3D~ s/\$SRC_FILE/$src/g;
     $cp_scp =3D~ s/\$DST_FILE/$dst/g;
@@ -1358,6 +1360,22 @@ sub run_scp {
     return run_command "$cp_scp";
 }
=20
+sub run_scp_install {
+    my ($src, $dst) =3D @_;
+
+    my $cp_scp =3D $scp_to_target_install;
+
+    return run_scp($src, $dst, $cp_scp);
+}
+
+sub run_scp_mod {
+    my ($src, $dst) =3D @_;
+
+    my $cp_scp =3D $scp_to_target;
+
+    return run_scp($src, $dst, $cp_scp);
+}
+
 sub get_grub_index {
=20
     if ($reboot_type ne "grub") {
@@ -1630,7 +1648,7 @@ sub install {
=20
     my $cp_target =3D eval_kernel_version $target_image;
=20
-    run_scp "$outputdir/$build_target", "$cp_target" or
+    run_scp_install "$outputdir/$build_target", "$cp_target" or
 	dodie "failed to copy image";
=20
     my $install_mods =3D 0;
@@ -1665,7 +1683,7 @@ sub install {
     run_command "cd $tmpdir && tar -cjf $modtar lib/modules/$version" or
 	dodie "making tarball";
=20
-    run_scp "$tmpdir/$modtar", "/tmp" or
+    run_scp_mod "$tmpdir/$modtar", "/tmp" or
 	dodie "failed to copy modules";
=20
     unlink "$tmpdir/$modtar";
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index 5ea04c6..b682456 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -710,10 +710,18 @@
 # The variables SSH_USER, MACHINE and SSH_COMMAND are defined
 #SSH_EXEC =3D ssh $SSH_USER@$MACHINE $SSH_COMMAND";
=20
-# The way to copy a file to the target
+# The way to copy a file to the target (install and modules)
 # (default scp $SRC_FILE $SSH_USER@$MACHINE:$DST_FILE)
-# The variables SSH_USER, MACHINE, SRC_FILE and DST_FILE are defined.
-#SCP_TO_TARGET =3D scp $SRC_FILE $SSH_USER@$MACHINE:$DST_FILE
+# The variables SSH_USER, MACHINE are defined by the config
+# SRC_FILE and DST_FILE are ktest internal variables and
+# should only have '$' and not the '${}' notation.
+# (default scp $SRC_FILE ${SSH_USER}@${MACHINE}:$DST_FILE)
+#SCP_TO_TARGET =3D echo skip scp for $SRC_FILE $DST_FILE
+
+# If install needs to be different than modules, then this
+# option will override the SCP_TO_TARGET for installation.
+# (default ${SCP_TO_TARGET} )
+#SCP_TO_TARGET_INSTALL =3D scp $SRC_FILE tftp@tftpserver:$DST_FILE
=20
 # The nice way to reboot the target
 # (default ssh $SSH_USER@$MACHINE reboot)
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPafujAAoJEIy3vGnGbaoAaVgP/jkt8NRfQ3+L72ZDRYCE3swx
z4BdWE/58upK+qYPoHTg3ytmYhC8THblbyvIyJcNTT0OYgooq8GZ9tS7uMTwBXht
FNKBht98lvZjotXl3a1mtnilUAxAsVtoRJMsTWvGhXHJ+eXoW98T4Kl29gGMJkng
CxHD4v946MX4cBcrAMDJFC4zduARnzjrR8Gl7owlIFUoFW51YxguFKCwknS2o6kf
GSValyGN5x/PO689S99J2BOFiysIK+puUzsnk4aU6TP6ByHuhy7r6oQIR6g47+7l
tTZF5bEOUDiX6nk/TsepRPEORPg+qTe+0fRkdVZMyvp4PgQVcKZ+dMWKfWgP04dU
9NbgqbTQFY5mANj//83zbSWYFORuOhTVk12RqldX8X5ceWjaQ2Tev60tbCooByG1
r0ljLl00s67HK3nX1xiFc45nbDxkBYfgRBGOLZRTcZGKMVSjeOq4zvSzxI/+xNY8
U8U9SZ4j6+Rb8BezGcF6A8QiB1tbDqgdo9P0ivOLplov4tXy6ekrdXJSlXkKHXep
9bxIZ8zbVITEDfOHYlkl3SSFtGoh4xgoyO3DNxM1Mz1wdF3s+tgg68V9KxW2KCsD
s7i0ZfstG9KvizdZD6v9VJ/QEAxI2D+q8G6O7c55PVkPTtV8GDgfzxJ5TNluUi2N
iA6qxandr41Aw3xgNho0
=pI5l
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
