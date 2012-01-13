Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500Ab2AMXYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 18:24:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60381 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2AMXYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 18:24:23 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=O-crL0TLGJsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=Q-fNiiVtAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=1GmzgTZZ5JjQvCN4sHEA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=_RhRFcbxBZMA:10 a=lcTMV_K9oDIA:10 a=jeBq3FmKZ4MA:10 a=3MyMELLQZ7If-qtUhScA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120113232419.155439516@goodmis.org>
User-Agent: quilt/0.50-1
Date: Fri, 13 Jan 2012 18:12:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Lange <thomas-lange2@gmx.de>,
        Arend van Spriel <arend@broadcom.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] kconfig/streamline-config.pl: Fix parsing Makefile with variables
References: <20120113231158.364436936@goodmis.org>
Content-Disposition: inline; filename=0002-kconfig-streamline-config.pl-Fix-parsing-Makefile-wi.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Thomas Lange reported that when he did a 'make localmodconfig', his
config was missing the brcmsmac driver, even though he had the module
loaded.

Looking into this, I found the file:
drivers/net/wireless/brcm80211/brcmsmac/Makefile
had the following in the Makefile:

MODULEPFX :=3D brcmsmac

obj-$(CONFIG_BRCMSMAC)  +=3D $(MODULEPFX).o

The way streamline-config.pl works, is parsing all the
 obj-$(CONFIG_FOO) +=3D foo.o
lines to find that CONFIG_FOO belongs to the module foo.ko.

But in this case, the brcmsmac.o was not used, but a variable in its place.

By changing streamline-config.pl to remember defined variables in Makefiles
and substituting them when they are used in the obj-X lines, allows
Thomas (and others) to have their brcmsmac module stay configured
when it is loaded and running "make localmodconfig".

Reported-by: Thomas Lange <thomas-lange2@gmx.de>
Tested-by: Thomas Lange <thomas-lange2@gmx.de>
Cc: Arend van Spriel <arend@broadcom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streaml=
ine_config.pl
index 42ef5ea..bccf07d 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -250,10 +250,33 @@ if ($kconfig) {
     read_kconfig($kconfig);
 }
=20
+sub convert_vars {
+    my ($line, %vars) =3D @_;
+
+    my $process =3D "";
+
+    while ($line =3D~ s/^(.*?)(\$\((.*?)\))//) {
+	my $start =3D $1;
+	my $variable =3D $2;
+	my $var =3D $3;
+
+	if (defined($vars{$var})) {
+	    $process .=3D $start . $vars{$var};
+	} else {
+	    $process .=3D $start . $variable;
+	}
+    }
+
+    $process .=3D $line;
+
+    return $process;
+}
+
 # Read all Makefiles to map the configs to the objects
 foreach my $makefile (@makefiles) {
=20
     my $line =3D "";
+    my %make_vars;
=20
     open(MIN,$makefile) || die "Can't open $makefile";
     while (<MIN>) {
@@ -270,10 +293,16 @@ foreach my $makefile (@makefiles) {
=20
 	my $objs;
=20
+	$_ =3D convert_vars($_, %make_vars);
+
 	# collect objects after obj-$(CONFIG_FOO_BAR)
 	if (/obj-\$\((CONFIG_[^\)]*)\)\s*[+:]?=3D\s*(.*)/) {
 	    $var =3D $1;
 	    $objs =3D $2;
+
+	# check if variables are set
+	} elsif (/^\s*(\S+)\s*[:]?=3D\s*(.*\S)/) {
+	    $make_vars{$1} =3D $2;
 	}
 	if (defined($objs)) {
 	    foreach my $obj (split /\s+/,$objs) {
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPEL0jAAoJEIy3vGnGbaoAZVwQAMLopa+PE15nMEzdFodrbekO
3nAud442Z6VhzyAq4K7BTLhcsEmkWjUCEHngtho1GGfFDUsB8/BgCSxrxVhgd2sI
Y0SNZZ0XPvYx7Z/Irs39b9+4Ei5bQg4NuWCuQuOYKypyVEsG1S2Dj7Ag0p1/gFvT
ZFyw6bhGutVa6Vfca5oLAaYN7RUWvvZSCfls/W1AnOyILV/cFySuWVYWYd8lO2hS
sil2qS4z5TIt7PF9A2VPY2PgYLITwQfoyGdE2Mnlm/LvhRM9Pgc2yOPP1p32DzQH
X0PSJI4SJ1ZCn5MpiLi75KkHin1Gfg2YMAKjye/eF9HO/VFJ0LsaeHtuKzhtgpqZ
odZVr3Xm5TNF3rKLitTRvyKqP3zUO5iSZ9bFlYLo7PbOEFz0yB/4sn0bib7AcQmQ
qGTLPYCbKnCVczs9pVhDMeFjWcNbIFgLf8wNYNDc9RnaISmapWxAIHsK128DchFi
UHEcslbnvWeIVBlK/Hxifn+z1xNlLdvIKysPPekOtcns0tyagWMZHPP6C3K4H3cf
qyh6affKczFdNbCi1Re3dh53vpsj85V3B5klXjO0iOp0sm2t7XFkepRQgtbZVhay
qIqUGenfS7fiZhfX1rxfLDCIYeMnFbWvLL1lT9wO8pplfr76iMlpAYz+GrBReHKN
/KM2W1hy1KdK2rCrRJn8
=36BC
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
