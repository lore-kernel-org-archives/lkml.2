Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab2AEDu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:50:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63363 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab2AEDs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:48:28 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=FlIZ5NbsKzUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Ddbtnt9JYj7CYVKDmRUA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=pfSUFiwYrrhrWG7X:21 a=VAiBLfQn0FS-Yx6D:21 a=nOMPGTguBczr5Pajv1sA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120105034826.759263257@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 04 Jan 2012 22:48:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 19/20] ktest: Still do reboot even for REBOOT_TYPE = script
References: <20120105034755.793909214@goodmis.org>
Content-Disposition: inline; filename=0019-ktest-Still-do-reboot-even-for-REBOOT_TYPE-script.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The REBOOT_TYPE may be either grub or script, if it is script
it is expected that a REBOOT_SCRIPT is defined.

With the SWITCH_TO_TEST which is the complement of SWITCH_TO_GOOD,
which does basically the same thing as REBOOT_SCRIPT and but for
both grub and script, the REBOOT_SCRIPT does not need to be mandatory
anymore.

Do not require the REBOOT_SCRIPT and always run the reboot code
for both grub and script.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   11 +++--------
 tools/testing/ktest/sample.conf |    5 ++++-
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index f360cbd..f81c8b3 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -485,8 +485,6 @@ sub get_ktest_configs {
=20
     if ($rtype eq "grub") {
 	get_ktest_config("GRUB_MENU");
-    } else {
-	get_ktest_config("REBOOT_SCRIPT");
     }
 }
=20
@@ -1430,11 +1428,10 @@ sub reboot_to {
=20
     if ($reboot_type eq "grub") {
 	run_ssh "'(echo \"savedefault --default=3D$grub_number --once\" | grub --=
batch)'";
-	reboot;
-	return;
+    } elsif (defined $reboot_script) {
+	run_command "$reboot_script";
     }
-
-    run_command "$reboot_script";
+    reboot;
 }
=20
 sub get_sha1 {
@@ -3479,8 +3476,6 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
 	$target =3D "$ssh_user\@$machine";
 	if ($reboot_type eq "grub") {
 	    dodie "GRUB_MENU not defined" if (!defined($grub_menu));
-	} elsif (!defined($reboot_script)) {
-	    dodie "REBOOT_SCRIPT not defined"
 	}
     }
=20
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index 86ce62c..d7148f7 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -346,7 +346,10 @@
 #GRUB_MENU =3D Test Kernel
=20
 # A script to reboot the target into the test kernel
-# (Only mandatory if REBOOT_TYPE =3D script)
+# This and SWITCH_TO_TEST are about the same, except
+# SWITCH_TO_TEST is run even for REBOOT_TYPE =3D grub.
+# This may be left undefined.
+# (default undefined)
 #REBOOT_SCRIPT =3D
=20
 #### Optional Config Options (all have defaults) ####
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBR2KAAoJEIy3vGnGbaoApGAP/3BDZn3LN1Bt32oo2DkWuYFh
CS8qrPKGn/nSnxC2wg3iTAyvjJZnNMOUKX9IiEVBfhnzPQc1ynlR1FkEZOfdTwVV
/1sjgM9cP+4OQC2z5tN80NzGjNZtSGAJg+EjORMge69ASxG79OwRvlhsI5ombsMo
1aQ9h7AnVni/on+U2Feojessb3im7F5tfHLdat/ge/9Gj0/NKfmLxnF4yUG/ByE6
D4LWGVMy0/c7ijej87E8PE5eFgFNUVY+u62jLoMnYu2HaMi8So5bC4DBP/DyxDEr
8BZTSxRm2Cp09OUPx1KBqOhit/rGrqSybEIokv2OJkYt4XqO5aChXus0QqcX7DYG
4SPRxTVZ3Ult4Z2ZYf6H6G7DSXviLQlkF0/fYtLnj6lS9pctFmD1/VhSdaTT5eHi
WWnmhO6w9E1eCx0aljfduIhqyilZY5ljtAIMPoTwDwFeO6Gajh7aykaBuuodvc6w
pPWX8zP3Fha8dhMTLra1YQoNseXMPJn78XrrqxW61miWIa/pSA/DqSY2GQf/fBCK
GnR/kDPkRdLW6QM87VNgq7C0teJHyko58OYnQI6mwQUhTE30DuXDiysSTUJD5LfY
2rfhP3SpCwxyidD1TlouhGdVk/sadE6FPBkc4Zj1Py1as5i14KqhjXe8RgMBF3pC
yUMHbvuYLvgRqFI6Vwqn
=Mkvw
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
