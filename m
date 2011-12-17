Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab1LQE35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 23:29:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37593 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901Ab1LQE3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 23:29:51 -0500
Message-ID: <1324096186.2825.311.camel@deadeye>
Subject: [PATCH linux-firmware 1/4] dsp56k: Add makefile for building from
 source
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Dec 2011 04:29:46 +0000
In-Reply-To: <1324096119.2825.310.camel@deadeye>
References: <1324096119.2825.310.camel@deadeye>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-iWHU7S8+3p4VRCfazDet"
X-Mailer: Evolution 3.2.1-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iWHU7S8+3p4VRCfazDet
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Some small amount of postprocessing is required after assembling
bootstrap.asm with a56.  Add a script and makefile for this.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 WHENCE                     |    4 +++-
 dsp56k/Makefile            |    6 ++++++
 dsp56k/concat-bootstrap.pl |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 1 deletions(-)
 create mode 100644 dsp56k/Makefile
 create mode 100644 dsp56k/concat-bootstrap.pl

diff --git a/WHENCE b/WHENCE
index bf216fe..7553628 100644
--- a/WHENCE
+++ b/WHENCE
@@ -372,10 +372,12 @@ Driver: dsp56k - Atari DSP56k support
=20
 File: dsp56k/bootstrap.bin
 Source: dsp56k/bootstrap.asm
+Source: dsp56k/Makefile
+Source: dsp56k/concat-bootstrap.pl
=20
 Licence: GPLv2 or later
=20
-DSP56001 assembler, possibly buildable with a56 from=20
+DSP56001 assembler, buildable with a56 from
 http://www.zdomain.com/a56.html
=20
 --------------------------------------------------------------------------
diff --git a/dsp56k/Makefile b/dsp56k/Makefile
new file mode 100644
index 0000000..c758a28
--- /dev/null
+++ b/dsp56k/Makefile
@@ -0,0 +1,6 @@
+bootstrap.bin: bootstrap.asm concat-bootstrap.pl
+	a56 bootstrap.asm >/dev/null
+	perl concat-bootstrap.pl <a56.out >bootstrap.bin
+
+clean:
+	rm -f a56.out bootstrap.bin
diff --git a/dsp56k/concat-bootstrap.pl b/dsp56k/concat-bootstrap.pl
new file mode 100644
index 0000000..b6d9003
--- /dev/null
+++ b/dsp56k/concat-bootstrap.pl
@@ -0,0 +1,33 @@
+# Postprocessor for dsp56k bootstrap code.
+#
+# Copyright Ben Hutchings 2011.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+
+use strict;
+use warnings;
+
+my @memory;
+my %symbol;
+
+# Reconstruct memory image and symbol table
+while (<>) {
+    if (/^P ([0-9A-F]{4}) ([0-9A-F]{6})\n/) {
+	$memory[hex($1)] =3D hex($2);
+    } elsif (/^I ([0-9A-F]{6}) (\w+)\n/) {
+	$symbol{$2} =3D hex($1);
+    } else {
+	print STDERR "W: did not recognise line $.\n";
+    }
+}
+
+# Concatenate first and second stage.  Second stage is assembled
+# between 'upload' and 'upload_end', but initially loaded at
+# 'real' (end of the first stage).
+for (0 .. ($symbol{real} - 1), $symbol{upload} .. ($symbol{upload_end} - 1=
)) {
+    my $word =3D $memory[$_] || 0;
+    print pack('CCC', $word / 65536, ($word / 256) % 256, $word % 256);
+}
--=20
1.7.7.3




--=-iWHU7S8+3p4VRCfazDet
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATuwauue/yOyVhhEJAQoKkA/7BqqeA2O3eo1hyKpskww9ssHsb2nx3EcG
oQfnPNhRXcYvAsOC8Pn84IZ2iHoHvHJbZeO15JoJwCsYACbLCQ/LRm16wVV062mA
zhQFRH0ett2z5kkrMiD4LDCElHVprCZJ+VBJNYhpxPJqRpopq769naD/kEp2m/hb
/slMztvPYJ1ymucZctAw9H/PZLOQYChe+212Bs6aGvS9jY9Hgh/g5BI3sbhlHEI9
EiDiv+fpjxt8MROVqAthHrSlnxmezQ19DSgfGMCrRNuaM9jsyAU00hJE+TFmy2jI
EkgbJpoelBsq4tToCwG5Vyr6cDN8TorNXK4S9rhD1sPd2q5C4fEpU1X2LIQVpAHZ
xWepvwIMp4GjGau8c3zjHhwCzqjLfGtXS5lTc1AQQieJ3iHQSuje1uCUE3x7snq/
AqcxxQdsYNA1NsKKiu2Vs7ctGB8qzWcUPgzjkHz/3UHEQ1PHgpJEa7zXcndUsal1
mBxdSo9+63tjLMR/2Brh6a4XyMA6teSa1ttp4H/QEtnRJ76e6AcEG/Rpct468KIU
VbXrWgkRarMXIdbxmynQrsLk3kgRxgHO6g5ylb0BUNAXKxL4Sb9jO5PTjpQxziEj
cDYPlNCfEdOpV7BfNIOTkLHSr6EP+zv53mDSTX7NhB8MgcufBsD2M7UX0TN4N8eU
cBPtPADTY4U=
=Uepn
-----END PGP SIGNATURE-----

--=-iWHU7S8+3p4VRCfazDet--
