Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab1J1LXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:23:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61559 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab1J1LUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:20:25 -0400
X-Authority-Analysis: v=1.1 cv=rFxaVhpzdNKRsWyFDFmDbYx/QEtlW7L1Gw9MiLxO4aw= c=1 sm=0 a=vhdKIqpQuCYA:10 a=YtTKwoM3tooA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=g3W1TVA1e65YW-LzzFwA:9 a=IhAwZzdN0q-5rzXpZo8A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=vqjP7JJgXErAdttpDgsA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111028112022.431301836@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 Oct 2011 07:16:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 10/21] ktest: Let IF keyword take comparisons
References: <20111028111558.173726794@goodmis.org>
Content-Disposition: inline; filename=0010-ktest-Let-IF-keyword-take-comparisons.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Allow =3D=3D, !=3D, <=3D, >=3D, <, and > to be used in IF statements
to compare if a section should be processed or not.

For example:

BITS :=3D 32

DEFAULTS IF ${BITS} =3D=3D 32
MIN_CONFIG =3D ${CONFIG_DIR}/config-32
ELSE
MIN_CONFIG =3D ${CONFIG_DIR}/config-64

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   54 ++++++++++++++++++++++++++++++++++-=
---
 tools/testing/ktest/sample.conf |   14 ++++++++++
 2 files changed, 62 insertions(+), 6 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index c76e18f..ed20d68 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -361,11 +361,47 @@ sub set_variable {
     }
 }
=20
+sub process_compare {
+    my ($lval, $cmp, $rval) =3D @_;
+
+    # remove whitespace
+
+    $lval =3D~ s/^\s*//;
+    $lval =3D~ s/\s*$//;
+
+    $rval =3D~ s/^\s*//;
+    $rval =3D~ s/\s*$//;
+
+    if ($cmp eq "=3D=3D") {
+	return $lval eq $rval;
+    } elsif ($cmp eq "!=3D") {
+	return $lval ne $rval;
+    }
+
+    my $statement =3D "$lval $cmp $rval";
+    my $ret =3D eval $statement;
+
+    # $@ stores error of eval
+    if ($@) {
+	return -1;
+    }
+
+    return $ret;
+}
+
 sub process_if {
     my ($name, $value) =3D @_;
=20
     my $val =3D process_variables($value);
=20
+    if ($val =3D~ /(.*)(=3D=3D|\!=3D|>=3D|<=3D|>|<)(.*)/) {
+	my $ret =3D process_compare($1, $2, $3);
+	if ($ret < 0) {
+	    die "$name: $.: Unable to process comparison\n";
+	}
+	return $ret;
+    }
+
     if ($val =3D~ /^\s*0\s*$/) {
 	return 0;
     } elsif ($val =3D~ /^\s*\d+\s*$/) {
@@ -428,8 +464,8 @@ sub read_config {
 		$repeat_tests{"$test_num"} =3D $repeat;
 	    }
=20
-	    if ($rest =3D~ /\sIF\s+(\S*)(.*)/) {
-		$rest =3D $2;
+	    if ($rest =3D~ /\sIF\s+(.*)/) {
+		$rest =3D "";
 		if (process_if($name, $1)) {
 		    $if_set =3D 1;
 		} else {
@@ -461,14 +497,14 @@ sub read_config {
 		$skip =3D 0;
 	    }
=20
-	    if ($rest =3D~ /\sIF\s+(\S*)(.*)/) {
+	    if ($rest =3D~ /\sIF\s+(.*)/) {
 		$if =3D 1;
-		$rest =3D $2;
 		if (process_if($name, $1)) {
 		    $if_set =3D 1;
 		} else {
 		    $skip =3D 1;
 		}
+		$rest =3D "";
 	    } else {
 		$if =3D 0;
 	    }
@@ -477,26 +513,32 @@ sub read_config {
 		die "$name: $.: Gargbage found after DEFAULTS\n$_";
 	    }
=20
-	} elsif (/^\s*ELSE(.*)$/) {
+	} elsif (/^\s*ELSE\b(.*)$/) {
 	    if (!$if) {
 		die "$name: $.: ELSE found with out matching IF section\n$_";
 	    }
 	    $rest =3D $1;
 	    if ($if_set) {
 		$skip =3D 1;
+		$rest =3D "";
 	    } else {
 		$skip =3D 0;
=20
-		if ($rest =3D~ /\sIF\s+(\S*)(.*)/) {
+		if ($rest =3D~ /\sIF\s+(.*)/) {
 		    # May be a ELSE IF section.
 		    if (!process_if($name, $1)) {
 			$skip =3D 1;
 		    }
+		    $rest =3D "";
 		} else {
 		    $if =3D 0;
 		}
 	    }
=20
+	    if ($rest !~ /^\s*$/) {
+		die "$name: $.: Gargbage found after DEFAULTS\n$_";
+	    }
+
 	} elsif (/^\s*([A-Z_\[\]\d]+)\s*=3D\s*(.*?)\s*$/) {
=20
 	    next if ($skip);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index 6a0a0ba..4e8fb91 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -72,6 +72,8 @@
 # the same option name under the same test or as default
 # ktest will fail to execute, and no tests will run.
 #
+#
+#
 # Both TEST_START and DEFAULTS sections can also have the IF keyword
 # The value after the IF must evaluate into a 0 or non 0 positive
 # integer, and can use the config variables (explained below).
@@ -110,6 +112,18 @@
 # ELSE
 # BUILD_TYPE =3D useconfig:${CONFIG_DIR}/config-network
 #
+# The if statement may also have comparisons that will and for
+# =3D=3D and !=3D, strings may be used for both sides.
+#
+# BOX_TYPE :=3D x86_32
+#
+# DEFAULTS IF ${BOX_TYPE} =3D=3D x86_32
+# BUILD_TYPE =3D useconfig:${CONFIG_DIR}/config-32
+# ELSE
+# BUILD_TYPE =3D useconfig:${CONFIG_DIR}/config-64
+#
+
+
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

iQIcBAABAgAGBQJOqo/2AAoJEIy3vGnGbaoA/pUP+QGnfbVKRSzn1u6VI8V57eK/
SDr6iGlLPSzKMyrUZ3rJn+78ffHhwbDIwJC5QWC3KMyJCX6uxDKxXdxyc8BtDaWR
nF9XFZjTgZvx3OfLt2fHeDRbXrT9vd1LNi8xeBSfewvIZjlBv16uj1cT4edEvRZU
d6wGAvCpDkUbKbzmBCJ45sykg4JDv68DohBIncQiBsYXOEiSgOGK/D1GxwTP3Lb9
GGoZQW5Kku6e5HUherLITzyjR3RmimEWOj/rJvz3QLp144ufZrDID+wRUoFRpBZn
E2Hwfp62pnX8tvfOho+fnqXeqviahrNhIQzhqYg32ayTVUxzz3wjJg5gdiq7sR0/
O7IlIw7ddA2Y9jEh13Q13+HPgHG3NiXb6BNGJAZOphRKC/PJlG7OvZRukz3ykm4m
8jvoQRZkYlGMU9HBNEtTJB9BN+xEOtzN55S1B6S48egoFOp6lqRPiEolgWEspzEI
sbVyUCRn8CSH8Nd+zrg89jj6Wvr/V7/3wJLe0H/R6ysOaAf8bgni2nusy2lail4I
0JBWK1Sjv2qGFSGkrHP7H7t+cQEwmElpsQs+DsUomhfsbOvkQ4An8UdUAAUVdGM5
i4/XFe/JAd1wwyoVug0GM7r9Cb1Xfe+7y5P0eddWSpw+mUOMPf02C/04QBOCt5TO
PBSFza/9kkAuPmVsPBN2
=e9Oi
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
