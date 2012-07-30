Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab2G3TaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:30:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12250 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab2G3T05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:26:57 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=ypm1jJkmWyoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=vqFf1HR-H9hPTU6sVUMA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gL_ez-DpCTCu2j1DOU4A:9 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120730192656.508834300@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 30 Jul 2012 15:23:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 04/10] ktest: Add CONFIG_BISECT_CHECK option
References: <20120730192314.144253843@goodmis.org>
Content-Disposition: inline; filename=0004-ktest-Add-CONFIG_BISECT_CHECK-option.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The config-bisect can take a bad config and bisect it down to find out
what config actually breaks the config. But as all tests will apply a
minconfig (defined by a user) to apply before booting, it is possible
that the minconfig could actually make the bad config work (minconfigs
can disable configs). The end result is that the config bisect test will
not find a config that breaks. This can be rather frustrating to the
user.

The CONFIG_BISECT_CHECK option, when set to 1, will make sure that the
bad config (with the minconfig applied) still fails before trying to
bisect.

And yes, I did get burned by this.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   14 ++++++++++++++
 tools/testing/ktest/sample.conf |    6 ++++++
 2 files changed, 20 insertions(+)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index e91702e..8ce58d7 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -173,6 +173,7 @@ my $bisect_check;
=20
 my $config_bisect;
 my $config_bisect_type;
+my $config_bisect_check;
=20
 my $patchcheck_type;
 my $patchcheck_start;
@@ -283,6 +284,7 @@ my %option_map =3D (
=20
     "CONFIG_BISECT"		=3D> \$config_bisect,
     "CONFIG_BISECT_TYPE"	=3D> \$config_bisect_type,
+    "CONFIG_BISECT_CHECK"	=3D> \$config_bisect_check,
=20
     "PATCHCHECK_TYPE"		=3D> \$patchcheck_type,
     "PATCHCHECK_START"		=3D> \$patchcheck_start,
@@ -2743,6 +2745,18 @@ sub config_bisect {
 	}
     }
     my $ret;
+
+    if (defined($config_bisect_check) && $config_bisect_check) {
+	doprint " Checking to make sure bad config with min config fails\n";
+	create_config keys %config_list;
+	$ret =3D run_config_bisect_test $config_bisect_type;
+	if ($ret) {
+	    doprint " FAILED! Bad config with min config boots fine\n";
+	    return -1;
+	}
+	doprint " Bad config with min config fails as expected\n";
+    }
+
     do {
 	$ret =3D run_config_bisect;
     } while (!$ret);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index 19754e0..e4a12da 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -1077,6 +1077,12 @@
 #  can specify it with CONFIG_BISECT_GOOD. Otherwise
 #  the MIN_CONFIG is the base.
 #
+# CONFIG_BISECT_CHECK (optional)
+#  Set this to 1 if you want to confirm that the config ktest
+#  generates (the bad config with the min config) is still bad.
+#  It may be that the min config fixes what broke the bad config
+#  and the test will not return a result.
+#
 # Example:
 #   TEST_START
 #   TEST_TYPE =3D config_bisect
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQFuAAAAoJEIy3vGnGbaoApZwP/2TYk6G0EpI3l/6z3ghvjECY
wAbcI6taiBARflCa5a3oPKqfsikEmXKAX5urHib6KYhA603j5PFeLkvjfUOSLLrT
VIgY+qdE2mWu5b+3yQlymNVQ0/WJnxDTXqWuLvXYqOP0Rpm2SYkdUe/8Nj5Xn0Pp
38nPvfNRz7CsPSixmXe+KS32awtzMv7h/73Olamdg6bAIDoM+qXTozO73lKWa825
/kJHK4h9VQ8KDRcvNEU09EUfguFHFJbvAhxlrxl44HK8vH5ah5kM0yeDDMua/Vlh
ZuW3ms3a/pC4KyQY3HmkjiGPDn15vJvhttK18vuYRz18D5uF/x6GSgRN9x8S934e
Wo2xoe45McYyvdCpUhynLOC0ImZ7bwlXzuNfnzqp/SAytpx5mgqmeXggYdJQTt0d
NaU+Nftidq4kCjg8gQzZrm43n3JwTj8tRCLGx2OLHHB8DecfcQXycRAIXA4U4LbH
rS10Ii6D4d14xsOy/Vr8ZnoYhYRwCAV6JZntc8XByZrRSFnVIQnHIEIvNECQ+vGW
mJ4NNRwocvNXYMeulULEPJ+LJWynqnvjsv1YwzmLIHqfwa0TeIZ1NFNuCeWrBxQ0
Yy2m57hMj0OFMnie7wFT/WLGoPVB42swxsVasQcWXnFFrgnrOuZUiUSeVAnltEsT
fbED4Lu0HD8NcS9MB+Nf
=vfhX
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
