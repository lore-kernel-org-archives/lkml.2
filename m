Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab1JQRBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:01:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52674 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607Ab1JQQ7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:59:53 -0400
X-Authority-Analysis: v=1.1 cv=UpSRffbr9y8V5xg6O7MBcDNOk5f8u00m038obrfOR4U= c=1 sm=0 a=vhdKIqpQuCYA:10 a=ogg7NRa721QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Cdhn2xjLDckY7s-cELsA:9 a=dYNasFYixILBgEcXiBYA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gdpVqDWjwXk_MeHT:21 a=ExlW8f9lRkqXTi0m:21 a=EdrgXF1aUodzMqqWZkMA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111017165952.099087970@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 17 Oct 2011 12:05:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 11/17][RFC] ktest: Add INCLUDE keyword to include other config files
References: <20111017160455.498567257@goodmis.org>
Content-Disposition: inline; filename=0011-ktest-Add-INCLUDE-keyword-to-include-other-config-fi.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Have the reading of the config file allow reading of other config
files using the INCLUDE keyword. This allows multiple config files
to share config options.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   55 ++++++++++++++++++++++++++++++++++-=
----
 tools/testing/ktest/sample.conf |   32 +++++++++++++++++++++-
 2 files changed, 78 insertions(+), 9 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index ed20d68..62de47d 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -412,15 +412,16 @@ sub process_if {
     return 1;
 }
=20
-sub read_config {
-    my ($config) =3D @_;
+sub __read_config {
+    my ($config, $current_test_num) =3D @_;
=20
-    open(IN, $config) || die "can't read file $config";
+    my $in;
+    open($in, $config) || die "can't read file $config";
=20
     my $name =3D $config;
     $name =3D~ s,.*/(.*),$1,;
=20
-    my $test_num =3D 0;
+    my $test_num =3D $$current_test_num;
     my $default =3D 1;
     my $repeat =3D 1;
     my $num_tests_set =3D 0;
@@ -430,7 +431,7 @@ sub read_config {
     my $if =3D 0;
     my $if_set =3D 0;
=20
-    while (<IN>) {
+    while (<$in>) {
=20
 	# ignore blank lines and comments
 	next if (/^\s*$/ || /\s*\#/);
@@ -539,6 +540,33 @@ sub read_config {
 		die "$name: $.: Gargbage found after DEFAULTS\n$_";
 	    }
=20
+	} elsif (/^\s*INCLUDE\s+(\S+)/) {
+
+	    next if ($skip);
+
+	    if (!$default) {
+		die "$name: $.: INCLUDE can only be done in default sections\n$_";
+	    }
+
+	    my $file =3D process_variables($1);
+
+	    if ($file !~ m,^/,) {
+		# check the path of the config file first
+		if ($config =3D~ m,(.*)/,) {
+		    if (-f "$1/$file") {
+			$file =3D "$1/$file";
+		    }
+		}
+	    }
+=09=09
+	    if ( ! -r $file ) {
+		die "$name: $.: Can't read file $file\n$_";
+	    }
+
+	    if (__read_config($file, \$test_num)) {
+		$test_case =3D 1;
+	    }
+
 	} elsif (/^\s*([A-Z_\[\]\d]+)\s*=3D\s*(.*?)\s*$/) {
=20
 	    next if ($skip);
@@ -594,13 +622,26 @@ sub read_config {
 	}
     }
=20
-    close(IN);
-
     if ($test_num) {
 	$test_num +=3D $repeat - 1;
 	$opt{"NUM_TESTS"} =3D $test_num;
     }
=20
+    close($in);
+
+    $$current_test_num =3D $test_num;
+
+    return $test_case;
+}
+
+sub read_config {
+    my ($config) =3D @_;
+
+    my $test_case;
+    my $test_num =3D 0;
+
+    $test_case =3D __read_config $config, \$test_num;
+
     # make sure we have all mandatory configs
     get_ktest_configs;
=20
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index 4e8fb91..ae2a93c 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -122,8 +122,36 @@
 # ELSE
 # BUILD_TYPE =3D useconfig:${CONFIG_DIR}/config-64
 #
-
-
+#
+# INCLUDE file
+#
+# The INCLUDE keyword may be used in DEFAULT sections. This will
+# read another config file and process that file as well. The included
+# file can include other files, add new test cases or default
+# statements. Config variables will be passed to these files and changes
+# to config variables will be seen by top level config files. Including
+# a file is processed just like the contents of the file was cut and pasted
+# into the top level file, except, that include files that end with
+# TEST_START sections will have that section ended at the end of
+# the include file. That is, an included file is included followed
+# by another DEFAULT keyword.
+#
+# Unlike other files referenced in this config, the file path does not need
+# to be absolute. If the file does not start with '/', then the directory
+# that the current config file was located in is used. If no config by the
+# given name is found there, then the current directory is searched.
+#
+# INCLUDE myfile
+# DEFAULT
+#
+# is the same as:
+#
+# INCLUDE myfile
+#
+# Note, if the include file does not contain a full path, the file is
+# searched first by the location of the original include file, and then
+# by the location that ktest.pl was executed in.
+#
=20
 #### Config variables ####
 #
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOnF8IAAoJEIy3vGnGbaoAkRIP/jA7blrBygFkMNCYPGjiU2O6
hd1rh7zDK645lS2l6c3UG9EDibPaq9LnY8FC8l5IIUadL1LmGKK1jfnb8+Awrzqq
Kjgjl7YjbJ8V968ruJutbveexozGXj7iIKmpS6LrYHL/MxwpfPYueOMlbn0VLXNl
89ZdK3QaG8JvbJKJXqT+GJRiNDJIcEsm8n/Es/bb050tdQAB0EpnAR8chay5Ghbi
JLw8MUqaldUkIgJKL+rcahvR7ohYP0T62mKz4zjzv8DBOneTbQQ/fDxwv0To+DES
/WhSw+AOwRgylm0kPPyPvG6N8lQKaK1Lla6Zxo1fRDX4RM9e2bRaNivaDcJzUO+M
G3J0ZfIC7w+c/7Dehe27XOm+FQC4LojDxIEKOrrdJnLWSxmN20UCtFx5nJddQakb
R2VALUmPshYMaYYz1GTAE09wVf0eZwNm4xHpCuceM0xr8taODR+Sx8mzeM84/pNX
5gTava1A36hPzXmIJP23vs28bbr/VWSCaJ0+/3CsiuUd2q6pw3nUz9yy9HFdEfnR
DW5Tbig4tD3uCc7Kno2kTyk39xAiPBf0s/XQGSunIxkT8TBLZVx3neO8mbx6qdJ0
ItlwRNcLxw48fU57i22u94Djh62nCwSc53+QOft6RfPRAjStO8yVgAidAHFG4Kzz
gMQLKs05pdb9sji4sY1n
=AjMd
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
