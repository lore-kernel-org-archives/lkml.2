Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab2EVMIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:08:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13129 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab2EVMGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:06:32 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=S0Gjs9_3yuAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=20KFwNOVAAAA:8 a=JpMdEs_0hY1xULFluYwA:9 a=MdBOYfNZ4W-JS2gTTuUA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=x-D5UNwRnB8pDXpzq_EA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120522120630.214015312@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 22 May 2012 08:05:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/8] ktest: Add MIN_CONFIG_TYPE to allow making a minum .config that has
 network
References: <20120522120531.460108326@goodmis.org>
Content-Disposition: inline; filename=0002-ktest-Add-MIN_CONFIG_TYPE-to-allow-making-a-minum-.c.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Add a MIN_CONFIG_TYPE that can be set to 'test' or 'boot'. The default
is 'boot' which is what make_min_config has done previously: makes a
config file that is the minimum needed to boot the target.

But when MIN_CONFIG_TYPE is set to 'test', not only must the target
boot, but it must also successfully run the TEST. This allows the
creation of a config file that is the minimum to boot and also
perform ssh to the target, or anything else a developer wants.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   14 ++++++++++++++
 tools/testing/ktest/sample.conf |   10 ++++++++++
 2 files changed, 24 insertions(+)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 50b6726..b6de819 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -39,6 +39,7 @@ my %default =3D (
     "CLEAR_LOG"			=3D> 0,
     "BISECT_MANUAL"		=3D> 0,
     "BISECT_SKIP"		=3D> 1,
+    "MIN_CONFIG_TYPE"		=3D> "boot",
     "SUCCESS_LINE"		=3D> "login:",
     "DETECT_TRIPLE_FAULT"	=3D> 1,
     "NO_INSTALL"		=3D> 0,
@@ -107,6 +108,7 @@ my $minconfig;
 my $start_minconfig;
 my $start_minconfig_defined;
 my $output_minconfig;
+my $minconfig_type;
 my $ignore_config;
 my $ignore_errors;
 my $addconfig;
@@ -206,6 +208,7 @@ my %option_map =3D (
     "MIN_CONFIG"		=3D> \$minconfig,
     "OUTPUT_MIN_CONFIG"		=3D> \$output_minconfig,
     "START_MIN_CONFIG"		=3D> \$start_minconfig,
+    "MIN_CONFIG_TYPE"		=3D> \$minconfig_type,
     "IGNORE_CONFIG"		=3D> \$ignore_config,
     "TEST"			=3D> \$run_test,
     "ADD_CONFIG"		=3D> \$addconfig,
@@ -3128,6 +3131,12 @@ sub test_this_config {
 sub make_min_config {
     my ($i) =3D @_;
=20
+    my $type =3D $minconfig_type;
+    if ($type ne "boot" && $type ne "test") {
+	fail "Invalid MIN_CONFIG_TYPE '$minconfig_type'\n" .
+	    " make_min_config works only with 'boot' and 'test'\n" and return;
+    }
+
     if (!defined($output_minconfig)) {
 	fail "OUTPUT_MIN_CONFIG not defined" and return;
     }
@@ -3287,6 +3296,11 @@ sub make_min_config {
 	build "oldconfig" or $failed =3D 1;
 	if (!$failed) {
 		start_monitor_and_boot or $failed =3D 1;
+
+		if ($type eq "test" && !$failed) {
+		    do_run_test or $failed =3D 1;
+		}
+
 		end_monitor;
 	}
=20
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index b682456..1c1b7dc 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -1105,10 +1105,20 @@
 #   and will not be tested again in later runs.
 #   (optional)
 #
+#  MIN_CONFIG_TYPE can be either 'boot' or 'test'. With 'boot' it will
+#   test if the created config can just boot the machine. If this is
+#   set to 'test', then the TEST option must be defined and the created
+#   config will not only boot the target, but also make sure that the
+#   config lets the test succeed. This is useful to make sure the final
+#   config that is generated allows network activity (ssh).
+#   (optional)
+#
 # Example:
 #
 #  TEST_TYPE =3D make_min_config
 #  OUTPUT_MIN_CONFIG =3D /path/to/config-new-min
 #  START_MIN_CONFIG =3D /path/to/config-min
 #  IGNORE_CONFIG =3D /path/to/config-tested
+#  MIN_CONFIG_TYPE =3D test
+#  TEST =3D ssh ${USER}@${MACHINE} echo hi
 #
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPu4FGAAoJEIy3vGnGbaoA9ygQAKys32aQ2WLUz4jSbpyA6n+d
qtT4/1IxYX/9DBRdICgYJs+p+D+TmikTA5VlRnd91ZgDq5TI6EDrDgGdc00PvbOu
QO4FU0CMpEm7cSGFUzUdU7UrXNPUqgoiLf4IEz3WYlFzFR5kwgz5vwCrrKMChy7f
T/Vk/fU3adA5nBEwt0Gq45g+ugu+iFPE3vN0/ZpXI1sE+5n2T0xQgabOULUEJmiN
tMK7rWQ1sSR42ASsZ63C6EEPJhvwElVW8sCNzOQnuf96YHrxuCvuxR4226UP+jf3
2G+vcobZ0tON6unv200pbUPW+RQbiRpPJJO1gx+ywcBCxeakNtQa5vYBg3JuRr8o
JENshFznYEr4zWn5br/lbbHODg7c3NO5bGd86XFhVXTlYc6YsunMq5Wk0AZnayqV
EghfHw4sHU9goPDe8lM+4kQLnV46UFTaH58cZDeexw47ixUxxzgINrJxGSMoKRWa
IlWmu/Hkx2WigNg7VDXhceKtDAEeldIiID618MGvMtPlnW3nCRSPv4gHSK2WkkTT
R0Qh5Yf8Bkra3wcRpjaAK6Hbj+NrrffgaQTflO0XIliDlIHCNpsuju9x8PRziUj7
qosxGW8KWecso8jqNndwFjDFFehlTc5hYpSVuOnahTCj5a5afguoKzIFmyiUWs9u
ojfAXn1F8p6MOsTG0FcP
=plB2
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
