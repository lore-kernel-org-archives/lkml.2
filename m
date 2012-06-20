Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab2FTCuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 22:50:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28792 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab2FTCuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 22:50:07 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=C2gnn1LOoZAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=9PgPiwaQxtW9giTdnEwA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=T1yCy-6XXuVCl0wbWyAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120620025005.198307619@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Jun 2012 22:06:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: John David Yost <johnyost@ptd.net>
Subject: [PATCH 4/4] localmodconfig: Add debug environment variable LOCALMODCONFIG_DEBUG
References: <20120620020608.911616775@goodmis.org>
Content-Disposition: inline; filename=0004-localmodconfig-Add-debug-environment-variable-LOCALM.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

If the environment variable LOCALMODCONFIG_DEBUG is set, then debug output
will appear in the make localmodconfig. This will simplify debugging what
people get with their output, as I can just tell people to do:

  LOCALMODCONFIG_DEBUG=3D1 make localmodconfig 2>out.txt

and have them send me the out.txt. I'll be able to see why things are not
working as they think it should be.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streaml=
ine_config.pl
index fcfcb30..2fbbbc1 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -45,6 +45,16 @@
 use strict;
 use Getopt::Long;
=20
+# set the environment variable LOCALMODCONFIG_DEBUG to get
+# debug output.
+my $debugprint =3D 0;
+$debugprint =3D 1 if (defined($ENV{LOCALMODCONFIG_DEBUG}));
+
+sub dprint {
+    return if (!$debugprint);
+    print STDERR @_;
+}
+
 my $config =3D ".config";
=20
 my $uname =3D `uname -r`;
@@ -389,6 +399,7 @@ foreach my $module (keys(%modules)) {
 	my @arr =3D @{$objects{$module}};
 	foreach my $conf (@arr) {
 	    $configs{$conf} =3D $module;
+	    dprint "$conf added by direct ($module)\n";
 	}
     } else {
 	# Most likely, someone has a custom (binary?) module loaded.
@@ -412,6 +423,8 @@ foreach my $line (@config_file) {
=20
 my $repeat =3D 1;
=20
+my $depconfig;
+
 #
 # Note, we do not care about operands (like: &&, ||, !) we want to add any
 # config that is in the depend list of another config. This script does
@@ -440,6 +453,7 @@ sub parse_config_depends
 		# We must make sure that this config has its
 		# dependencies met.
 		$repeat =3D 1; # do again
+		dprint "$conf selected by depend $depconfig\n";
 		$configs{$conf} =3D 1;
 	    }
 	} else {
@@ -473,15 +487,18 @@ sub parse_config_selects
=20
 	    # Make sure that this config exists in the current .config file
 	    if (!defined($orig_configs{$conf})) {
+		dprint "$conf not set for $config select\n";
 		next;
 	    }
=20
 	    # Check if something other than a module selects this config
 	    if (defined($orig_configs{$conf}) && $orig_configs{$conf} ne "m") {
+		dprint "$conf (non module) selects config, we are good\n";
 		# we are good with this
 		return;
 	    }
 	    if (defined($configs{$conf})) {
+		dprint "$conf selects $config so we are good\n";
 		# A set config selects this config, we are good
 		return;
 	    }
@@ -506,6 +523,7 @@ sub parse_config_selects
     $repeat =3D 1;
     # Make this config need to be selected
     $configs{$next_config} =3D 1;
+    dprint "$next_config selected by select $config\n";
 }
=20
 my %process_selects;
@@ -526,6 +544,7 @@ sub loop_depend {
 	    }
=20
 	    $config =3D~ s/^CONFIG_//;
+	    $depconfig =3D $config;
=20
 	    if (defined($depends{$config})) {
 		# This config has dependencies. Make sure they are also included
@@ -546,6 +565,8 @@ sub loop_select {
     foreach my $config (keys %process_selects) {
 	$config =3D~ s/^CONFIG_//;
=20
+	dprint "Process select $config\n";
+
 	# config has no prompt and must be selected.
 	parse_config_selects $config, $selects{$config};
     }
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP4TpdAAoJEIy3vGnGbaoAoIEP+gKFhMxNw3Vql4AMkBc9KuKy
RF5n5ofKNm6cngs9XihX19Fr45sFpO6SyGMZNx8e4CsGQCVjVc0ttRk0ljXwflSa
WCeW5kgl7V0RRqJOhr0/q6WRTib3364s6b3KrHDjiZ0u91PQqwows5TK8QWSpEY2
nBL+2JWXfuklQ8mTnVkpS8vlKfMZZ2oQhrDnnsHjE33PZOU1XSnvOo+KutSUuW98
q+XeQsKzSRzoDvKhabwLNIduzGalCjxcRznTgqLDUf18US86bJwLRmigzX21UZYO
JCpojhKvlb/Vfat0aEVlJU19fVqpVNxBzVgcvd7kGkGPmqSYa0zOvm6nz4A0opZT
y/u/yUWL5bq/4HQpHrA0iFij6O/1Iezz0kPdsgAFsi7+yT+1TzfdCrzm98T+aRN7
aBapD/KxTaOUxyRPlJcqJ9EnT49MLF7G1pOthFEtDikdSgF/Qv9uMYVg3UO/TJv1
dnk2sp2qNNqgdIre5OLI/Pnp2eTHEDhHQKQbP3KH3YdmhtfEVDYwVthyOeO2ehyD
g7z6iOxSLHD65Q4IdK2+KkTjmZ5dXMhGkIGI1frQMtJrMMhC/qsKgH8wGCOV76SL
606lCuJSln7GtbLR9WTnbyxnYIUwNSD9EIGoiC677hsWF/YocEnRgLU8L1tTggnq
6MtjzPaXSN4wWQoL0Ifv
=wpqc
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
