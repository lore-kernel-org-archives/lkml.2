Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab2AEDvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:51:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab2AEDs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:48:26 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=me4J8IgG7usA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=kLLxnWLJMdmxGx3nhNQA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=8xfSG-akExDj7h6Z76YA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120105034824.882092541@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 04 Jan 2012 22:48:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 13/20] ktest: Allow overriding bisect test results
References: <20120105034755.793909214@goodmis.org>
Content-Disposition: inline; filename=0013-ktest-Allow-overriding-bisect-test-results.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When running the ktest git bisect test, if the BISECT_TYPE is "test",
the bisect is determined to be good or bad based off of the error
code of the test that is run. Currently, if the test returns 0,
it is considered a pass (good), a non-zero is considered a fail (bad).

But it has been requested to add more options, and also change
the meanings of the error codes of the test. For example, one may
want the test to detect if the commit is not good or bad,
(maybe the bisect came to a point where the code in question
does not exist). The test could report an error code that should tell
ktest to skip the commit.

Also, a test could detect that something is horribly wrong and the
biscet should just be aborted.

The new options:

 BISECT_RET_GOOD
 BISECT_RET_BAD
 BISECT_RET_SKIP
 BISECT_RET_ABORT
 BISECT_RET_DEFAULT

have been added. The first 4 take an integer value that will
represent if the test should be considered a pass, fail, neither
good nor bad, or abort respectively.

The BISECT_RET_DEFAULT will bo whatever is not defined by the
above codes. If only BISECT_RET_DEFAULT is defined, then all tests
will do the default.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   47 +++++++++++++++++++++++++++++++++++=
++++
 tools/testing/ktest/sample.conf |   36 +++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 04a7bb5..47c2814 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -105,6 +105,11 @@ my $reverse_bisect;
 my $bisect_manual;
 my $bisect_skip;
 my $config_bisect_good;
+my $bisect_ret_good;
+my $bisect_ret_bad;
+my $bisect_ret_skip;
+my $bisect_ret_abort;
+my $bisect_ret_default;
 my $in_patchcheck =3D 0;
 my $run_test;
 my $redirect;
@@ -1854,6 +1859,43 @@ sub do_run_test {
     waitpid $child_pid, 0;
     $child_exit =3D $?;
=20
+    if (!$bug && $in_bisect) {
+	if (defined($bisect_ret_good)) {
+	    if ($child_exit =3D=3D $bisect_ret_good) {
+		return 1;
+	    }
+	}
+	if (defined($bisect_ret_skip)) {
+	    if ($child_exit =3D=3D $bisect_ret_skip) {
+		return -1;
+	    }
+	}
+	if (defined($bisect_ret_abort)) {
+	    if ($child_exit =3D=3D $bisect_ret_abort) {
+		fail "test abort" and return -2;
+	    }
+	}
+	if (defined($bisect_ret_bad)) {
+	    if ($child_exit =3D=3D $bisect_ret_skip) {
+		return 0;
+	    }
+	}
+	if (defined($bisect_ret_default)) {
+	    if ($bisect_ret_default eq "good") {
+		return 1;
+	    } elsif ($bisect_ret_default eq "bad") {
+		return 0;
+	    } elsif ($bisect_ret_default eq "skip") {
+		return -1;
+	    } elsif ($bisect_ret_default eq "abort") {
+		return -2;
+	    } else {
+		fail "unknown default action: $bisect_ret_default"
+		    and return -2;
+	    }
+	}
+    }
+
     if ($bug || $child_exit) {
 	return 0 if $in_bisect;
 	fail "test failed" and return 0;
@@ -3284,6 +3326,11 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
     $bisect_manual =3D set_test_option("BISECT_MANUAL", $i);
     $bisect_skip =3D set_test_option("BISECT_SKIP", $i);
     $config_bisect_good =3D set_test_option("CONFIG_BISECT_GOOD", $i);
+    $bisect_ret_good =3D set_test_option("BISECT_RET_GOOD", $i);
+    $bisect_ret_bad =3D set_test_option("BISECT_RET_BAD", $i);
+    $bisect_ret_skip =3D set_test_option("BISECT_RET_SKIP", $i);
+    $bisect_ret_abort =3D set_test_option("BISECT_RET_ABORT", $i);
+    $bisect_ret_default =3D set_test_option("BISECT_RET_DEFAULT", $i);
     $store_failures =3D set_test_option("STORE_FAILURES", $i);
     $store_successes =3D set_test_option("STORE_SUCCESSES", $i);
     $test_name =3D set_test_option("TEST_NAME", $i);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index 42e0eb9..2ff0f8c 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -868,6 +868,42 @@
 #   BISECT_BAD with BISECT_CHECK =3D good or
 #   BISECT_CHECK =3D bad, respectively.
 #
+# BISECT_RET_GOOD =3D 0 (optional, default undefined)
+#
+#   In case the specificed test returns something other than just
+#   0 for good, and non-zero for bad, you can override 0 being
+#   good by defining BISECT_RET_GOOD.
+#
+# BISECT_RET_BAD =3D 1 (optional, default undefined)
+#
+#   In case the specificed test returns something other than just
+#   0 for good, and non-zero for bad, you can override non-zero being
+#   bad by defining BISECT_RET_BAD.
+#
+# BISECT_RET_ABORT =3D 255 (optional, default undefined)
+#
+#   If you need to abort the bisect if the test discovers something
+#   that was wrong, you can define BISECT_RET_ABORT to be the error
+#   code returned by the test in order to abort the bisect.
+#
+# BISECT_RET_SKIP =3D 2 (optional, default undefined)
+#
+#   If the test detects that the current commit is neither good
+#   nor bad, but something else happened (another bug detected)
+#   you can specify BISECT_RET_SKIP to an error code that the
+#   test returns when it should skip the current commit.
+#
+# BISECT_RET_DEFAULT =3D good (optional, default undefined)
+#
+#   You can override the default of what to do when the above
+#   options are not hit. This may be one of, "good", "bad",
+#   "abort" or "skip" (without the quotes).
+#
+#   Note, if you do not define any of the previous BISECT_RET_*
+#   and define BISECT_RET_DEFAULT, all bisects results will do
+#   what the BISECT_RET_DEFAULT has.
+#
+#
 # Example:
 #   TEST_START
 #   TEST_TYPE =3D bisect
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBR2IAAoJEIy3vGnGbaoAATMP/1ZEn1RsZ9qvDy9VjU4bYpHp
dj69e2KpQ7AF/xfT103sMTuQ7MlThWuePAMUXzPnNfkhfB7I9AufGB0eqg8K6oxN
Dmx55MngkDe8npORvuglHNfmgCmounMfhvJkeZ6dSJIweoNXIGXLigQKJ2hhze2l
YZAtyL86WuGDwu2WDuQPx7SgobNtaoAXUX8vdHvwaVjNhODjryANyeaEnQIec0gL
rpVwkljmG1Ih5A+nNFUv7XbiohH2GuL7V0NrSOhB4a3oAULauB0nCZKaaXAqos/f
lecX2nEfASI3uY9XX/G8SXSWo5QOorvPKffvo/VXdtV8ZzI9U2Zet0EzXKGPN8aR
nyecZ5498Hqxw89c/x+odajrg6sefW41a6VROt2+TQqBO7QEz9fts+z1dCmK2PHd
mAO5YU/AVWSQyzEN00vNU111P8ALWLbxYWGMJvwB6KMmup7N1Vy/GeZJRFfkL4QG
w6chSOMjxlJC7nfiG7+MvhzvZz7kex3HZ8fDs9rnKwJIbGaWugy5TIbH2Kbq38Nr
ZdiKXBIb3xIyKQL5YnLb+OyMT9udpb0if4pP+MU0cvfYoTNfkB1Nen0EIUk4T6Wl
FL0aOKPgCspi2kxR4hvgb6GvoPDgVhjnzDMEE8V4Ynp0J9FsG+7EoH22Or7z1z2F
fSnqvyphZ/zLp8xqZDXZ
=/Rqa
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
