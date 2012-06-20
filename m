Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab2FTCuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 22:50:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28084 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab2FTCuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 22:50:05 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=m-5qM9h8XkYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=qrFA_WvyAAAA:8 a=jeQFJ1gBC8V7uS6IoycA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=bdmcM0_chmsA:10 a=jeBq3FmKZ4MA:10 a=Hh_zZyL19z6mRDJValwA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120620025004.584667211@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Jun 2012 22:06:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: John David Yost <johnyost@ptd.net>
Subject: [PATCH 2/4] localmodconfig: Read in orig config file to avoid extra processing
References: <20120620020608.911616775@goodmis.org>
Content-Disposition: inline; filename=0002-localmodconfig-Read-in-orig-config-file-to-avoid-ext.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Read in the entire config file. If there's a config that we depend on
that happens to be in the core set (not a module) then we do not need
to process it as a module.

Currently, we follow the entire depend and selects even if they
are enabled as core and not modules. By checking to make sure that we
only look at modules we can drop the count a little.

>From one of my tests, localmodconfig went from taking 3095 set modules
down to 356 before this patch, and down to 290 modules after the change.

Tested-by: John David Yost <johnyost@ptd.net> # AlleyTrotter
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streaml=
ine_config.pl
index 5c1ce87..ab4985f 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -113,6 +113,10 @@ sub find_config {
=20
 find_config;
=20
+# Read in the entire config file into config_file
+my @config_file =3D <CIN>;
+close CIN;
+
 # Parse options
 my $localmodconfig =3D 0;
 my $localyesconfig =3D 0;
@@ -392,7 +396,20 @@ foreach my $module (keys(%modules)) {
     }
 }
=20
+# Read the current config, and see what is enabled. We want to
+# ignore configs that we would not enable anyway.
+
+my %orig_configs;
 my $valid =3D "A-Za-z_0-9";
+
+foreach my $line (@config_file) {
+    $_ =3D $line;
+
+    if (/(CONFIG_[$valid]*)=3D(m|y)/) {
+	$orig_configs{$1} =3D $2;
+    }
+}
+
 my $repeat =3D 1;
=20
 #
@@ -414,6 +431,11 @@ sub parse_config_dep_select
=20
 	    $p =3D~ s/^[^$valid]*[$valid]+//;
=20
+	    # We only need to process if the depend config is a module
+	    if (!defined($orig_configs{$conf}) || !$orig_configs{conf} eq "m") {
+		next;
+	    }
+
 	    if (!defined($configs{$conf})) {
 		# We must make sure that this config has its
 		# dependencies met.
@@ -450,7 +472,8 @@ my %setconfigs;
=20
 # Finally, read the .config file and turn off any module enabled that
 # we could not find a reason to keep enabled.
-while(<CIN>) {
+foreach my $line (@config_file) {
+    $_ =3D $line;
=20
     if (/CONFIG_IKCONFIG/) {
 	if (/# CONFIG_IKCONFIG is not set/) {
@@ -478,7 +501,6 @@ while(<CIN>) {
     }
     print;
 }
-close(CIN);
=20
 # Integrity check, make sure all modules that we want enabled do
 # indeed have their configs set.
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP4TpcAAoJEIy3vGnGbaoAG0UP/3c4ODXJjWMcePzPLuRWEEM2
UL/FX5icBHjwdoU+jKnxTN8hlyZGsJeVxOfVTvXra9APUTGrZRk8uzkfDmSTUHbv
hl4+mGTFvCtu9SbzBauVKrWGSsQjn4FjlYOGFP08+KELBGKRaZM/XXUjXGRa77sV
ITrF4sBmrQnzAaqlHbDaxnYcIfkFEcn2ef1VcgWObIQXzV9I3/XafBiFofovjezf
6xvKgOggW3SRXzAbvAXW1LTIIvNXaXiPHmkSCHqRAUeFYathwftiE2i87irD2cyj
BYjB9I/Y04I3PycH3FUlI8UormIUXXTjjC9DWx6fmrEb2L6ZSB5y+aTqPDHXEk1a
tzjdAbQLLJntVF5CPSTRGRSYqWUEUCwY+eqSAmtCXMFr5GV/MI/oimd/yJVlAQcD
boVlsoJxKR7+G1OG3gWWdFxI3kTpkMcoh/x/dNk7txbG73MLqWRFn0/cD2e3IUIf
eA2sw6gAekmGKN8+H5nbV63yzhbCqGFR7pwvjhVuUv6MXrm+khqkY7LfWsaiR0bt
BUNyXap4eXw8zmi3EFSu6UZpEj1/9eQuomWZ1B0jaFPKNyd9K1iFoBQBFod0eChv
qLwZIjO54579pzybY7vv5czbEIyKVXdpdSl0KJlyoBfNYcgS8/YuupOIpdQAj6FI
0D2c2rUWJKRHXgSX8vZ6
=Tezx
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
