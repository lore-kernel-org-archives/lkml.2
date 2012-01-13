Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486Ab2AMXYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 18:24:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60381 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759448Ab2AMXYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 18:24:21 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=9arp4V8VrsEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=sGGnhyIJ8nLc9J5IjNsA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=_RhRFcbxBZMA:10 a=jeBq3FmKZ4MA:10 a=RGulpHBI3NXa-8Sy-50A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120113232418.842290307@goodmis.org>
User-Agent: quilt/0.50-1
Date: Fri, 13 Jan 2012 18:11:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Lange <thomas-lange2@gmx.de>, stable@vger.kernel.org
Subject: [PATCH 1/2] kconfig/streamline-config.pl: Simplify backslash line concatination
References: <20120113231158.364436936@goodmis.org>
Content-Disposition: inline; filename=0001-kconfig-streamline-config.pl-Simplify-backslash-line.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Simplify the way lines ending with backslashes (continuation) in Makefiles
is parsed. This is needed to implement a necessary fix.

Tested-by: Thomas Lange <thomas-lange2@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streaml=
ine_config.pl
index ec7afce..42ef5ea 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -253,17 +253,22 @@ if ($kconfig) {
 # Read all Makefiles to map the configs to the objects
 foreach my $makefile (@makefiles) {
=20
-    my $cont =3D 0;
+    my $line =3D "";
=20
     open(MIN,$makefile) || die "Can't open $makefile";
     while (<MIN>) {
-	my $objs;
-
-	# is this a line after a line with a backslash?
-	if ($cont && /(\S.*)$/) {
-	    $objs =3D $1;
+	# if this line ends with a backslash, continue
+	chomp;
+	if (/^(.*)\\$/) {
+	    $line .=3D $1;
+	    next;
 	}
-	$cont =3D 0;
+
+	$line .=3D $_;
+	$_ =3D $line;
+	$line =3D "";
+
+	my $objs;
=20
 	# collect objects after obj-$(CONFIG_FOO_BAR)
 	if (/obj-\$\((CONFIG_[^\)]*)\)\s*[+:]?=3D\s*(.*)/) {
@@ -271,12 +276,6 @@ foreach my $makefile (@makefiles) {
 	    $objs =3D $2;
 	}
 	if (defined($objs)) {
-	    # test if the line ends with a backslash
-	    if ($objs =3D~ m,(.*)\\$,) {
-		$objs =3D $1;
-		$cont =3D 1;
-	    }
-
 	    foreach my $obj (split /\s+/,$objs) {
 		$obj =3D~ s/-/_/g;
 		if ($obj =3D~ /(.*)\.o$/) {
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPEL0iAAoJEIy3vGnGbaoAEsEQANBW/pr9oGvi1Zd22whRT6BM
SHdqp4mNkFIDsZhW9xFngKRzlI37BoKjaejgK+VMdLzeABifsCCtxjTGvjrPNgfh
F/mOW8/Uf9xwapHGBMMnQqe2fTDIOyXM/eKmtaIfvyD1MOlMmjdhCX0Ew0ZYM6YZ
IIAada9s+g7zVQRZ0PF9e4MyMQkd2cbg2cFepl9hkWiQNchhemIY2x3YEtMSNJiB
leQ4thV7gENgxpmNlz1HNbm2P4mctE/TeKYrIu7gYyWzji0qtopK4HRJcxtAmwi+
o5Qz7Ydh9RKVpyRV+oDMI8roPmoH47HtZv7F1G4dWvU21uob00HRJ8f2QDQ3qdFD
Gzf9Qs1C3x9OhVgTlNKNoaXEFZwmHC7T2rT4T/tfwDJuAW2bN6fX1qVxGqdbQTGb
jG0cODm9gmR3pwJpXBbwNX9tiUNZDaf3JX1eeGPt76+YnV82VlFxC3ODQ9/5j+ft
u+taxxxOfvrwkMj72V7RfO3C5nsnMmMUfxuYj8lelk8wtxFNELGe23STaSywBpCO
C2o55BxnDLjZ3v1C2AS7TFZ3X/FZ6GMmJmsiA6eK46X8FkVm/KgsdQas20RTKRk0
afuwFTedytbyuIg8H2+Qrpxv6IhxsdwEiREyVSXFSGGOfW0q+5XsxkbzDtbpMFa+
OfQK/hxecbXJg1Cm2u/O
=hNYZ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
