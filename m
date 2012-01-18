Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2ARXbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 18:31:49 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:59302 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab2ARXbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 18:31:47 -0500
Date: Thu, 19 Jan 2012 10:31:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Rusty Russell <rusty@rustcorp.com.au>
Subject: linux-next: build failure after merge of the origin tree
Message-Id: <20120119103136.e92b828eca9f2e903da0ea29@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Jan_2012_10_31_36_+1100_Z05MfB5Hhj9bmoxR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Jan_2012_10_31_36_+1100_Z05MfB5Hhj9bmoxR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the origin tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "xen_biovec_phys_mergeable" [drivers/block/nvme.ko] undefined!

This is weird, as CONFIG_BLOCK and CONFIG_XEN are both set in this build
and I started with an empty object directory.  And biomerge.o has been
built.

Ah ha!

drivers/xen/biomerge.c:14:1: warning: data definition has no type or storag=
e class [enabled by default]
drivers/xen/biomerge.c:14:1: warning: type defaults to 'int' in declaration=
 of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/xen/biomerge.c:14:1: warning: parameter names (without types) in fu=
nction declaration [enabled by default]

drivers/xen/biomerge.c does not include export.h.  It would be nice if
this produced an error, not just the warnings above.  Caused by commit
0b934ccd707f ("Xen: Export xen_biovec_phys_mergeable") (which was never
in linux-next :-().

I applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 19 Jan 2012 10:24:31 +1100
Subject: [PATCH] xen: using EXPORT_SYMBOL requires including export.h

Fixes these warnings:

drivers/xen/biomerge.c:14:1: warning: data definition has no type or storag=
e class [enabled by default]
drivers/xen/biomerge.c:14:1: warning: type defaults to 'int' in declaration=
 of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/xen/biomerge.c:14:1: warning: parameter names (without types) in fu=
nction declaration [enabled by default]

And this build error:

ERROR: "xen_biovec_phys_mergeable" [drivers/block/nvme.ko] undefined!

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/xen/biomerge.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/biomerge.c b/drivers/xen/biomerge.c
index 18c1bb6..0edb91c 100644
--- a/drivers/xen/biomerge.c
+++ b/drivers/xen/biomerge.c
@@ -1,5 +1,6 @@
 #include <linux/bio.h>
 #include <linux/io.h>
+#include <linux/export.h>
 #include <xen/page.h>
=20
 bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
--=20
1.7.9.rc0.23.g7e521

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__19_Jan_2012_10_31_36_+1100_Z05MfB5Hhj9bmoxR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPF1ZYAAoJEECxmPOUX5FEjiMP/iWKJvM8ai4jHQ3KVOJnmBpo
hnz6E+DnUTaJXrWZrF9d8ydW9ua9FMgi9kVqo1dXf49ZAJim7rTXKUu32w4YVPWm
TeeEiVSIObTjFB2Xj6A/7ZSZLpQddCkCimDv2V8Nb494UpuaL/fVL//M/3nHp4xE
H9RfCQuxHK9bCCwUAkPDlZtS5EuRvrgHCdhyNHP1gEShEqavBoG/jkz4lhV6VR8F
JorzuJ8MjvVxIdry56svefnOkachjxTIHgjao9hyQrkygC3YhOn2d2xQxK8EkERs
BAIQwSIoikzpe/ZbKiW7T6x2UFaWGqyQUyyZjG2KEAsWoZv70fhKVWsbE1gneiDz
7Gxz65BVqOUdjP7/K5Zmoz6FhrmVoGyIZec8E94Nc/aOW7DwLK/b45Pnlzu42ybm
MjQ+zrCqXornvPzHjr0g+J/EpSk4Lh8Br01EPkdfpp/+/sJOPswOLvw87xOEfUSC
E4kiLDE5ASQjNdGuWHVCO7x0vyTenOL9/ozlP8pDhyIHWOaWqn/e4CaBatVdofXU
ZPysDLOwCH+0OJMWTiU5kur7sGCGsP74Lut/GfhRGsLkMjaqkcNpvwp5iGZimNvN
bOw2dW5OU5qhIMikSlrdQQDdA7eJXT+69/fcEIlSu62Dq9j1R3NZGwv/GuWia5kq
XOFUEramyeFGeAC7DErm
=Lx0F
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Jan_2012_10_31_36_+1100_Z05MfB5Hhj9bmoxR--
