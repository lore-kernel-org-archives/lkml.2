Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab2AEDs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:48:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab2AEDsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:48:23 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=aYHK48gm54oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=_8uaXH8-Os4dW32iUSEA:9 a=QEXdDO2ut3YA:10 a=ByEePuvHlDcA:10 a=jeBq3FmKZ4MA:10 a=_s6oIUR3PVL_xyi8:21 a=Vcc2XEdHYQfTn1pD:21 a=Zrvmg2sFctYKX4PMLvEA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120105034821.649619094@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 04 Jan 2012 22:47:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 03/20] ktest: Allow success logs to be stored
References: <20120105034755.793909214@goodmis.org>
Content-Disposition: inline; filename=0003-ktest-Allow-success-logs-to-be-stored.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Rabin Vincent <rabin@rab.in>

Add a STORE_SUCCESSES option, to allow success logs to be stored, for
example to double-check or otherwise post-process the test logs.

Link: http://lkml.kernel.org/r/1321616131-21352-3-git-send-email-rabin@rab.=
in

Signed-off-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   80 ++++++++++++++++++++++-------------=
---
 tools/testing/ktest/sample.conf |    6 +++
 2 files changed, 52 insertions(+), 34 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index e93c21c..6ef104e 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -113,6 +113,7 @@ my $bisect_sleep_time;
 my $patchcheck_sleep_time;
 my $ignore_warnings;
 my $store_failures;
+my $store_successes;
 my $test_name;
 my $timeout;
 my $booted_timeout;
@@ -976,6 +977,43 @@ sub wait_for_monitor {
     print "** Monitor flushed **\n";
 }
=20
+sub save_logs {
+	my ($result, $basedir) =3D @_;
+	my @t =3D localtime;
+	my $date =3D sprintf "%04d%02d%02d%02d%02d%02d",
+		1900+$t[5],$t[4],$t[3],$t[2],$t[1],$t[0];
+
+	my $type =3D $build_type;
+	if ($type =3D~ /useconfig/) {
+	    $type =3D "useconfig";
+	}
+
+	my $dir =3D "$machine-$test_type-$type-$result-$date";
+
+	$dir =3D "$basedir/$dir";
+
+	if (!-d $dir) {
+	    mkpath($dir) or
+		die "can't create $dir";
+	}
+
+	my %files =3D (
+		"config" =3D> $output_config,
+		"buildlog" =3D> $buildlog,
+		"dmesg" =3D> $dmesg,
+		"testlog" =3D> $testlog,
+	);
+
+	while (my ($name, $source) =3D each(%files)) {
+		if (-f "$source") {
+			cp "$source", "$dir/$name" or
+				die "failed to copy $source";
+		}
+	}
+
+	doprint "*** Saved info to $dir ***\n";
+}
+
 sub fail {
=20
 	if ($die_on_failure) {
@@ -1004,40 +1042,9 @@ sub fail {
 	doprint "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n";
 	doprint "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n";
=20
-	return 1 if (!defined($store_failures));
-
-	my @t =3D localtime;
-	my $date =3D sprintf "%04d%02d%02d%02d%02d%02d",
-		1900+$t[5],$t[4],$t[3],$t[2],$t[1],$t[0];
-
-	my $type =3D $build_type;
-	if ($type =3D~ /useconfig/) {
-	    $type =3D "useconfig";
-	}
-
-	my $dir =3D "$machine-$test_type-$type-fail-$date";
-	my $faildir =3D "$store_failures/$dir";
-
-	if (!-d $faildir) {
-	    mkpath($faildir) or
-		die "can't create $faildir";
-	}
-
-	my %files =3D (
-		"config" =3D> $output_config,
-		"buildlog" =3D> $buildlog,
-		"dmesg" =3D> $dmesg,
-		"testlog" =3D> $testlog,
-	);
-
-	while (my ($name, $source) =3D each(%files)) {
-		if (-f "$source") {
-			cp "$source", "$faildir/$name" or
-				die "failed to copy $source";
-		}
-	}
-
-	doprint "*** Saved info to $faildir ***\n";
+	if (defined($store_failures)) {
+	    save_logs "fail", $store_failures;
+        }
=20
 	return 1;
 }
@@ -1643,6 +1650,10 @@ sub success {
     doprint     "*******************************************\n";
     doprint     "*******************************************\n";
=20
+    if (defined($store_successes)) {
+        save_logs "success", $store_successes;
+    }
+
     if ($i !=3D $opt{"NUM_TESTS"} && !do_not_reboot) {
 	doprint "Reboot and wait $sleep_time seconds\n";
 	reboot $sleep_time;
@@ -3137,6 +3148,7 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
     $bisect_skip =3D set_test_option("BISECT_SKIP", $i);
     $config_bisect_good =3D set_test_option("CONFIG_BISECT_GOOD", $i);
     $store_failures =3D set_test_option("STORE_FAILURES", $i);
+    $store_successes =3D set_test_option("STORE_SUCCESSES", $i);
     $test_name =3D set_test_option("TEST_NAME", $i);
     $timeout =3D set_test_option("TIMEOUT", $i);
     $booted_timeout =3D set_test_option("BOOTED_TIMEOUT", $i);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index dbedfa1..42e0eb9 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -589,6 +589,12 @@
 # (default undefined)
 #STORE_FAILURES =3D /home/test/failures
=20
+# Directory to store success directories on success. If this is not
+# set, the .config, dmesg and bootlog will not be saved if a
+# test succeeds.
+# (default undefined)
+#STORE_SUCCESSES =3D /home/test/successes
+
 # Build without doing a make mrproper, or removing .config
 # (default 0)
 #BUILD_NOCLEAN =3D 0
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBR2FAAoJEIy3vGnGbaoA4aQP/i/sNO7Q41pmvmz9Rw3iydWX
33NNocMG0gsafAeR/kKf35m1fui8XllyjyIrJJCjDNwPb7/5KebyfcCy1WCAE/pR
Pv7BJA3mHYXtYxtraDjMmr9AuL84EtyCUUt6Q+1diX0qOSFXYIfXyG/j6hepM4lx
m35zYZEPVc2OdlLBP7F4evS+4raM6knLAzwTka2U1CCxFx2uvCv+nozez/v1hFT4
H6tZgfYk8oXXpVG+xMff1pYhZz4Gcer5ZU1Ar2XJxUmfVNaaAI8Kw0cAOcTdkkEK
Qvtxe1OmOMty/851/rQD92V/ZuumcycRJ0pXiqmwNdsFhxGSeLNE1mZbhtDyRX9e
tjwxc2XW1WeBeBsSd2jL+msY5UR51Rn6efolUE9qkdtXWo6jWjvrlrAbJUdlZmln
w8wZdY4jNO8kwdRdf0DXe5ByR/S/hFD3FFWNsOlM4a2tz9uv3fdZoKMkAt30v2DG
pxVFA22Z2f7FCdM8uDv0sSlyNLtZfifE74CplXISKQiCLqRYw/K2UgSuarh/v3Iq
0Dpbkim+YkHmfABa1RyXyP5FnRPOutFODPcS8POuu1p24Ss6hE3LX2Obid9nPz80
2faNnil4vkL1uNVxk1M5IQOYQmS1YALRMepuBWzk4koILCivvxCWqXscKwWShkVr
fTa6FxNc42Fd8NIN4Owl
=Z6u/
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
