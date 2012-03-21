Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab2CUQCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:02:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076Ab2CUQCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:02:46 -0400
X-Authority-Analysis: v=2.0 cv=UcbTuduN c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=vSR_77ExQU4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=DGVdJMzkP5qVwfwKpk0A:9 a=MTocQoJVF8CqSSsctTsA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=VpyCUuCw5JZxbyK2:21 a=EyBBiWVHZ693A4KO:21 a=-myBjJ4njXlruc6DL10A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120321160244.450154952@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 21 Mar 2012 12:01:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5/5] ktest: Allow a test to override REBOOT_ON_SUCCESS
References: <20120321160125.496052559@goodmis.org>
Content-Disposition: inline; filename=0005-ktest-Allow-a-test-to-override-REBOOT_ON_SUCCESS.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The option REBOOT_ON_SUCCESS is global, and will have the machine reboot
the the box if all tests are successful. But a test may not want the
machine to reboot, and perhaps have the kernel it loaded be used to
install the next kernel. Or the last test may set up a kernel that the
user may want to look at. In this case, the user could have the global
option REBOOT_ON_SUCCESS be true, but if a test is defined to run at the
end, that test can override the global option and keep the kernel it
installed for the user to log in with.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index e7fed79..c858152 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -87,6 +87,7 @@ my $reboot_on_error;
 my $switch_to_good;
 my $switch_to_test;
 my $poweroff_on_error;
+my $reboot_on_success;
 my $die_on_failure;
 my $powercycle_after_reboot;
 my $poweroff_after_halt;
@@ -213,6 +214,7 @@ my %option_map =3D (
     "SWITCH_TO_GOOD"		=3D> \$switch_to_good,
     "SWITCH_TO_TEST"		=3D> \$switch_to_test,
     "POWEROFF_ON_ERROR"		=3D> \$poweroff_on_error,
+    "REBOOT_ON_SUCCESS"		=3D> \$reboot_on_success,
     "DIE_ON_FAILURE"		=3D> \$die_on_failure,
     "POWER_OFF"			=3D> \$power_off,
     "POWERCYCLE_AFTER_REBOOT"	=3D> \$powercycle_after_reboot,
@@ -3552,8 +3554,10 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
 	    die "failed to checkout $checkout";
     }
=20
-    $no_reboot =3D 0;
-
+    # A test may opt to not reboot the box
+    if ($reboot_on_success) {
+	$no_reboot =3D 0;
+    }
=20
     if ($test_type eq "bisect") {
 	bisect $i;
@@ -3598,8 +3602,12 @@ if ($opt{"POWEROFF_ON_SUCCESS"}) {
     halt;
 } elsif ($opt{"REBOOT_ON_SUCCESS"} && !do_not_reboot) {
     reboot_to_good;
+} elsif (defined($switch_to_good)) {
+    # still need to get to the good kernel
+    run_command $switch_to_good;
 }
=20
+
 doprint "\n    $successes of $opt{NUM_TESTS} tests were successful\n\n";
=20
 exit 0;
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPafukAAoJEIy3vGnGbaoAKPgQAOK7dApLsyqobmwjLvjjNRXQ
i9GzClXf/vRiTaJHuKI8N+x77oeL9P0TweIKjN6+hhfc7rHK21rJTGcxjgjTd41E
XBWx0CzA6bwz3ToiU6hF/nV6NBYPXrN79E8PKwAkGUWOxnihNWqMO76H6ZrMZb1p
lz+B36fVfzYpgKncgvUzCpVwdoTYY7ruqvK8PIeOTwevgtA0XBAbB0+eE1HB4pbO
o62yyMt3k0iXcvS7S/F3wrnPJtJzbs35Jhe+FLNGP6U4QMdI5WFaooi1UfPIaQo9
06gtsoEg4yXgYVY3lNXBquPsCvp7DrB4PUiRwDQ2Hwpq0wLRoCvWj6bLZn3+Udfi
I8ZSQkKzqmekSEMs1RyMw7TMBRKxT2zb+LfB1frogYGDl9M3kyQ0AguN1nqBjtKI
4+gs1gT/oxo7/0tHD7Y6VL98cXodKwzWW0XSqKGv34INPRcZXvmuwLdbh59F/q4m
JAHHMH8vz99FDqo+7k4lDMIlcixQHBT/B+FUc6s2gzWSH5Fmul+9Skn6WAXqfAa8
9DzJGbkrf4YF0Eev56beZ818vpgP/4ryLy10SulV0KrjnDii6rkaJ6rwRuFN3x97
FQ5SafsV47R6AiXIv4jBjoPkSXSR1KLnlbsdTx8N40Neata5oJsCjkdtCV/kzBN1
bS9GNQ3wzIHxOUDqVW0l
=pvz4
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
