Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab2AEDse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:48:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34876 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab2AEDsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:48:25 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=6XaT_Fu5m3wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=hXWk5fNttL6Z-C3cZIoA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=MljROgGtd1ra027-QiwA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120105034822.714222035@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 04 Jan 2012 22:48:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 06/20] ktest: Allow bisect test to restart where it left off
References: <20120105034755.793909214@goodmis.org>
Content-Disposition: inline; filename=0006-ktest-Allow-bisect-test-to-restart-where-it-left-off.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

If a bisect is killed for some reason, have ktest detect that a bisect
is in progress and if so, allow the user to start the bisect where
it left off.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   70 ++++++++++++++++++++++++++++++++++++++=
---
 1 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 77b4649..2ffb67c 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -239,20 +239,36 @@ $config_help{"REBOOT_SCRIPT"} =3D << "EOF"
 EOF
     ;
=20
-sub read_yn {
-    my ($prompt) =3D @_;
+sub read_prompt {
+    my ($cancel, $prompt) =3D @_;
=20
     my $ans;
=20
     for (;;) {
-	print "$prompt [Y/n] ";
+	if ($cancel) {
+	    print "$prompt [y/n/C] ";
+	} else {
+	    print "$prompt [Y/n] ";
+	}
 	$ans =3D <STDIN>;
 	chomp $ans;
 	if ($ans =3D~ /^\s*$/) {
-	    $ans =3D "y";
+	    if ($cancel) {
+		$ans =3D "c";
+	    } else {
+		$ans =3D "y";
+	    }
 	}
 	last if ($ans =3D~ /^y$/i || $ans =3D~ /^n$/i);
-	print "Please answer either 'y' or 'n'.\n";
+	if ($cancel) {
+	    last if ($ans =3D~ /^c$/i);
+	    print "Please answer either 'y', 'n' or 'c'.\n";
+	} else {
+	    print "Please answer either 'y' or 'n'.\n";
+	}
+    }
+    if ($ans =3D~ /^c/i) {
+	exit;
     }
     if ($ans !~ /^y$/i) {
 	return 0;
@@ -260,6 +276,18 @@ sub read_yn {
     return 1;
 }
=20
+sub read_yn {
+    my ($prompt) =3D @_;
+
+    return read_prompt 0, $prompt;
+}
+
+sub read_ync {
+    my ($prompt) =3D @_;
+
+    return read_prompt 1, $prompt;
+}
+
 sub get_ktest_config {
     my ($config) =3D @_;
     my $ans;
@@ -1895,6 +1923,13 @@ sub run_bisect {
     }
 }
=20
+sub update_bisect_replay {
+    my $tmp_log =3D "$tmpdir/ktest_bisect_log";
+    run_command "git bisect log > $tmp_log" or
+	die "can't create bisect log";
+    return $tmp_log;
+}
+
 sub bisect {
     my ($i) =3D @_;
=20
@@ -1934,8 +1969,31 @@ sub bisect {
 	$type =3D "boot";
     }
=20
+    # Check if a bisect was running
+    my $bisect_start_file =3D "$builddir/.git/BISECT_START";
+
     my $check =3D $opt{"BISECT_CHECK[$i]"};
-    if (defined($check) && $check ne "0") {
+    my $do_check =3D defined($check) && $check ne "0";
+
+    if ( -f $bisect_start_file ) {
+	print "Bisect in progress found\n";
+	if ($do_check) {
+	    print " If you say yes, then no checks of good or bad will be done\n";
+	}
+	if (defined($replay)) {
+	    print "** BISECT_REPLAY is defined in config file **";
+	    print " Ignore config option and perform new git bisect log?\n";
+	    if (read_ync " (yes, no, or cancel) ") {
+		$replay =3D update_bisect_replay;
+		$do_check =3D 0;
+	    }
+	} elsif (read_yn "read git log and continue?") {
+	    $replay =3D update_bisect_replay;
+	    $do_check =3D 0;
+	}
+    }
+
+    if ($do_check) {
=20
 	# get current HEAD
 	my $head =3D get_sha1("HEAD");
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBR2GAAoJEIy3vGnGbaoAJQ0P/1epjTltagMybulq9NjX6idH
OpVrLQF0uOnc4hc/lhCcQoqGEQDEcnC8czzlQCiTT01X73MTbrVbrnHQAvX89q4H
9FnqBvV6+aESob6dzN11K8l/qJ5JKPdQ+/L8vJqxN/XF3/Xh3O7uD+Ex25iai5Ns
6Eu8NxLygrWOxJtjV6i7CCirv1llG9c8D7X5VzN2ECPeZEG1iX3fOaLDoPZyQV0n
6fUNqKbA9NRQ1RDoGBuuygOs3f2rzZpmeIKm+/uIiDVZQ+sBLTGq2tdHfQWfPZbb
0JHusZ8j2sf4tL9nm6i4g4sXFuvtbLbPpgIq2/kxh7V1g7yen5HG0HpfvtKLzQeP
vML3hhwceFe39II28L4+YRWYGOYP3GX+MqPa8jEsRDbENrX5xIxB/LJUoD7Eq1Lj
K5LFKuUbFJk2dhoFGuC4t6eIDfm/IsaxFDGou1tt1sjTipFIvNp3iW69ZXC8itV6
6tug7aqS/X89JQZ96wD0GV1chqHr6OCYwDi/ZokkCa6U5/G3zcSKn68+0gAeJkT3
DDNDdKEtVRih9CzE9JcdbpehLuSVZ3FlnR1Ar7/Z1If+QArsc/er/0aTPvZG44dt
R1vLhF9Bk7Zeah7ZJOHc2DA9Mm5ZHNBiih0lqk9w81IVR4ogToR7ak4smeTS9WDD
K/DuhQGx+0WSeyqE98yI
=fKWh
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
