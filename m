Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab1JQRCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:02:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52674 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab1JQQ7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:59:52 -0400
X-Authority-Analysis: v=1.1 cv=UpSRffbr9y8V5xg6O7MBcDNOk5f8u00m038obrfOR4U= c=1 sm=0 a=vhdKIqpQuCYA:10 a=PNP0HHTZC3oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=d_yON4x6gciIcn7BXBAA:9 a=aV8xZ56l4vTWJKqxg94A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ApjUT8FHXwqQuxr298gA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111017165951.126001279@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 17 Oct 2011 12:05:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 09/17][RFC] ktest: Add IF and ELSE to config sections
References: <20111017160455.498567257@goodmis.org>
Content-Disposition: inline; filename=0009-ktest-Add-IF-and-ELSE-to-config-sections.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Add IF keyword to sections within the config. Also added an ELSE
keyword that allows different config options to be set for a given
section.

For example:

TYPE :=3D 1
STATUS :=3D 0

DEFAULTS IF ${TYPE}
[...]
ELSE IF ${STATUS}
[...]
ELSE
[...]

The above will process the first section as $TYPE is true. If it
was false, it would process the last section as $STATUS is false.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   64 +++++++++++++++++++++++++++++++++++=
+--
 tools/testing/ktest/sample.conf |   38 +++++++++++++++++++++++
 2 files changed, 98 insertions(+), 4 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 057676a..c76e18f 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -361,6 +361,21 @@ sub set_variable {
     }
 }
=20
+sub process_if {
+    my ($name, $value) =3D @_;
+
+    my $val =3D process_variables($value);
+
+    if ($val =3D~ /^\s*0\s*$/) {
+	return 0;
+    } elsif ($val =3D~ /^\s*\d+\s*$/) {
+	return 1;
+    }
+
+    die ("$name: $.: Undefined variable $val in if statement\n");
+    return 1;
+}
+
 sub read_config {
     my ($config) =3D @_;
=20
@@ -376,6 +391,8 @@ sub read_config {
     my $skip =3D 0;
     my $rest;
     my $test_case =3D 0;
+    my $if =3D 0;
+    my $if_set =3D 0;
=20
     while (<IN>) {
=20
@@ -397,7 +414,7 @@ sub read_config {
 	    $default =3D 0;
 	    $repeat =3D 1;
=20
-	    if ($rest =3D~ /\s+SKIP(.*)/) {
+	    if ($rest =3D~ /\s+SKIP\b(.*)/) {
 		$rest =3D $1;
 		$skip =3D 1;
 	    } else {
@@ -411,9 +428,16 @@ sub read_config {
 		$repeat_tests{"$test_num"} =3D $repeat;
 	    }
=20
-	    if ($rest =3D~ /\s+SKIP(.*)/) {
-		$rest =3D $1;
-		$skip =3D 1;
+	    if ($rest =3D~ /\sIF\s+(\S*)(.*)/) {
+		$rest =3D $2;
+		if (process_if($name, $1)) {
+		    $if_set =3D 1;
+		} else {
+		    $skip =3D 1;
+		}
+		$if =3D 1;
+	    } else {
+		$if =3D 0;
 	    }
=20
 	    if ($rest !~ /^\s*$/) {
@@ -437,10 +461,42 @@ sub read_config {
 		$skip =3D 0;
 	    }
=20
+	    if ($rest =3D~ /\sIF\s+(\S*)(.*)/) {
+		$if =3D 1;
+		$rest =3D $2;
+		if (process_if($name, $1)) {
+		    $if_set =3D 1;
+		} else {
+		    $skip =3D 1;
+		}
+	    } else {
+		$if =3D 0;
+	    }
+
 	    if ($rest !~ /^\s*$/) {
 		die "$name: $.: Gargbage found after DEFAULTS\n$_";
 	    }
=20
+	} elsif (/^\s*ELSE(.*)$/) {
+	    if (!$if) {
+		die "$name: $.: ELSE found with out matching IF section\n$_";
+	    }
+	    $rest =3D $1;
+	    if ($if_set) {
+		$skip =3D 1;
+	    } else {
+		$skip =3D 0;
+
+		if ($rest =3D~ /\sIF\s+(\S*)(.*)/) {
+		    # May be a ELSE IF section.
+		    if (!process_if($name, $1)) {
+			$skip =3D 1;
+		    }
+		} else {
+		    $if =3D 0;
+		}
+	    }
+
 	} elsif (/^\s*([A-Z_\[\]\d]+)\s*=3D\s*(.*?)\s*$/) {
=20
 	    next if ($skip);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index 67bc4e0..6a0a0ba 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -72,6 +72,44 @@
 # the same option name under the same test or as default
 # ktest will fail to execute, and no tests will run.
 #
+# Both TEST_START and DEFAULTS sections can also have the IF keyword
+# The value after the IF must evaluate into a 0 or non 0 positive
+# integer, and can use the config variables (explained below).
+#
+# DEFAULTS IF ${IS_X86_32}
+#
+# The above will process the DEFAULTS section if the config
+# variable IS_X86_32 evaluates to a non zero positive integer
+# otherwise if it evaluates to zero, it will act the same
+# as if the SKIP keyword was used.
+#
+# The ELSE keyword can be used directly after a section with
+# a IF statement.
+#
+# TEST_START IF ${RUN_NET_TESTS}
+# BUILD_TYPE =3D useconfig:${CONFIG_DIR}/config-network
+#
+# ELSE
+#
+# BUILD_TYPE =3D useconfig:${CONFIG_DIR}/config-normal
+#
+#
+# The ELSE keyword can also contain an IF statement to allow multiple
+# if then else sections. But all the sections must be either
+# DEFAULT or TEST_START, they can not be a mixture.
+#
+# TEST_START IF ${RUN_NET_TESTS}
+# BUILD_TYPE =3D useconfig:${CONFIG_DIR}/config-network
+#
+# ELSE IF ${RUN_DISK_TESTS}
+# BUILD_TYPE =3D useconfig:${CONFIG_DIR}/config-tests
+#
+# ELSE IF ${RUN_CPU_TESTS}
+# BUILD_TYPE =3D useconfig:${CONFIG_DIR}/config-cpu
+#
+# ELSE
+# BUILD_TYPE =3D useconfig:${CONFIG_DIR}/config-network
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

iQIcBAABAgAGBQJOnF8HAAoJEIy3vGnGbaoA8Z0P/2E7n+r7VVrDbMjyTU7uYEf0
EBnCBWMPLAc8ryQFfGPbc3SbBobyw0MVkkF3PKwP1CNNW3JvFxnOOCx5o6LT2zG0
xdAV0FXJLTs4aCCZRArO05WolpT7/3B8eSkH//ufeC56f5DMZSIGUfNBCRCX5PH2
5KeZarMVfEegP2ZTB/0WlKVIfeC7E7vth0+sbOuNc7PxKpaV9gkPx+UPSsZTlpr0
3tSMjEvFFBMSZM3a/Rv+2qsfynrw9JtEwuUMWE6SEKZjK9xtuLTX031idHw3Mdg4
uun/YraIJMsyqQwPa4udtPBn/14xYLNVQQbrQ2m1dnhVWlHfDkaBW8nMhiigi5Jo
wrD/gYxyhMC7FsaDBdQpjverwcsAB4tbuwK2BFs7v1bOFQoJW57TgFu7FAorTj8w
Nhgbkk2gc0hSM1ORAEVJwtQXtNG5aamnTIVynl1IuUiNRjrEz7SIU8FzsWw2TYej
khOONuB4AK8EcP1ZncDvaSKJeltHk/Bj2iAYfrU2t1iEGz01LZYxUIcuxNyDBcYp
ifQcqbEViji3mK5teSFvpPCeh0PHj9I4papnAQMeNXthl1f9ktFs0/9X6Xu4Dxgo
HVEncFM1iBw4AzXcN22H7TEQvqdNRYT6oW8LrfzZqcneYm51NmHVTalUFx8CiBO0
LVre9nSd1vxvd6T3iLIv
=Aq38
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
