Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab2JANjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:39:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15627 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2JANiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:38:04 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Ic979CjBoWEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=PKl1Ax_xUEAA:10 a=RalSYxT0Wv6-4AMu8yIA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=hbRqmq2Ala7c-e2PLOQA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121001133801.742955429@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 01 Oct 2012 09:30:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH 3/4] localmodconfig: Use 3 parameter open in streamline_config.pl
References: <20121001133055.594443758@goodmis.org>
Content-Disposition: inline; filename=0003-localmodconfig-Use-3-parameter-open-in-streamline_co.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Bill Pemberton <wfp5p@virginia.edu>

Convert remaining open calls to use the perl's preferred 3 parameter
open.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streaml=
ine_config.pl
index 62d64ce..22b66ca 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -171,8 +171,8 @@ sub read_kconfig {
 	$source =3D~ s/\$$env/$ENV{$env}/;
     }
=20
-    open(KIN, "$source") || die "Can't open $kconfig";
-    while (<KIN>) {
+    open(my $kinfile, '<', $source) || die "Can't open $kconfig";
+    while (<$kinfile>) {
 	chomp;
=20
 	# Make sure that lines ending with \ continue
@@ -249,7 +249,7 @@ sub read_kconfig {
 	    $state =3D "NONE";
 	}
     }
-    close(KIN);
+    close($kinfile);
=20
     # read in any configs that were found.
     foreach $kconfig (@kconfigs) {
@@ -293,8 +293,8 @@ foreach my $makefile (@makefiles) {
     my $line =3D "";
     my %make_vars;
=20
-    open(MIN,$makefile) || die "Can't open $makefile";
-    while (<MIN>) {
+    open(my $infile, '<', $makefile) || die "Can't open $makefile";
+    while (<$infile>) {
 	# if this line ends with a backslash, continue
 	chomp;
 	if (/^(.*)\\$/) {
@@ -341,10 +341,11 @@ foreach my $makefile (@makefiles) {
 	    }
 	}
     }
-    close(MIN);
+    close($infile);
 }
=20
 my %modules;
+my $linfile;
=20
 if (defined($lsmod_file)) {
     if ( ! -f $lsmod_file) {
@@ -354,13 +355,10 @@ if (defined($lsmod_file)) {
 		die "$lsmod_file not found";
 	}
     }
-    if ( -x $lsmod_file) {
-	# the file is executable, run it
-	open(LIN, "$lsmod_file|");
-    } else {
-	# Just read the contents
-	open(LIN, "$lsmod_file");
-    }
+
+    my $otype =3D ( -x $lsmod_file) ? '-|' : '<';
+    open($linfile, $otype, $lsmod_file);
+
 } else {
=20
     # see what modules are loaded on this system
@@ -377,16 +375,16 @@ if (defined($lsmod_file)) {
 	$lsmod =3D "lsmod";
     }
=20
-    open(LIN,"$lsmod|") || die "Can not call lsmod with $lsmod";
+    open($linfile, '-|', $lsmod) || die "Can not call lsmod with $lsmod";
 }
=20
-while (<LIN>) {
+while (<$linfile>) {
 	next if (/^Module/);  # Skip the first line.
 	if (/^(\S+)/) {
 		$modules{$1} =3D 1;
 	}
 }
-close (LIN);
+close ($linfile);
=20
 # add to the configs hash all configs that are needed to enable
 # a loaded module. This is a direct obj-${CONFIG_FOO} +=3D bar.o
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQaZy5AAoJEOdOSU1xswtMT1QIAKtvqx5/ohcR252BcFZyXVqp
I1zKsT9iqXYn4T4dwCffZ4zhPALiRdqzzDlEDbY0MK8vrDczKSN+t4VnilLZaBMS
vYC9q6l2Xrzc8kGcWXQ/2KSGvPOcRLFpqt34Uffy97eAD5QOjYVDV5IrzVxgHVjc
CwKHQdMYE52YL37Xvv8QIWX7ZptJFQUqhDYgd2BK8k+bPFg0GmgH61UAuXZDv9P+
V5SnI7uPgocgMRNDV23soS9BGMdWf3JmJLIwC0gxw/9TROZY1/PgmqRuO57s/7Ou
6eva37xONT2U4YjTspM43VNfD69vAxEPiD5LvQyPJfht0s3/u/Lmxb7Xkv23jso=
=TC3y
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
