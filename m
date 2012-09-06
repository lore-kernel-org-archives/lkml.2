Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab2IFFKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 01:10:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38772 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2IFFKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 01:10:22 -0400
Date: Thu, 6 Sep 2012 15:10:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>, Alan Cox <alan@linux.intel.com>
Subject: linux-next: build failure after merge of the tty tree
Message-Id: <20120906151014.c5b6be5dfbbcf3e516d7d70c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Sep_2012_15_10_14_+1000_BxF_kqtC.N0OVgvT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Sep_2012_15_10_14_+1000_BxF_kqtC.N0OVgvT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

In file included from drivers/tty/serial/sccnxp.c:20:0:
include/linux/serial_core.h: In function 'uart_handle_break':
include/linux/serial_core.h:543:30: error: dereferencing pointer to incompl=
ete type

Caused by commit 1d65c0b12656 ("serial: New serial driver SCCNXP").  This
seems to be just exposing a preexisting problem with linux/serial_core.h:
when SUPPORT_SYSRQ is defined, this header depends on linux/console.h.  I
can only imagein that every other use of serial_core.h pre-includes
(maybe indirectly) console.h (or doesn't define SUPPORT_SYSRQ).

I have applied the following patch, but a better solution should be
figured out.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 6 Sep 2012 15:05:04 +1000
Subject: [PATCH] serial: serial_core.h needs console.h included first

Fixes these build errors:

In file included from drivers/tty/serial/sccnxp.c:20:0:
include/linux/serial_core.h: In function 'uart_handle_break':
include/linux/serial_core.h:543:30: error: dereferencing pointer to incompl=
ete type

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/tty/serial/sccnxp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sccnxp.c b/drivers/tty/serial/sccnxp.c
index 29dda9b..05d767c 100644
--- a/drivers/tty/serial/sccnxp.c
+++ b/drivers/tty/serial/sccnxp.c
@@ -17,12 +17,12 @@
=20
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/console.h>
 #include <linux/serial_core.h>
 #include <linux/serial.h>
 #include <linux/io.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
-#include <linux/console.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/sccnxp.h>
=20
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Sep_2012_15_10_14_+1000_BxF_kqtC.N0OVgvT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQSDA2AAoJEECxmPOUX5FE/4oP/3n+d3CRKmSXy+gw5aC/j7g3
rwM9iXOP2Cp6Iyj6bvILeJQpojQNjcT81fL5x40w+OZ9Zec1EeRl/L3fh8awsl9a
Q9tHm7xLFmrWb47kpKWFxCWmMtAF8Ve7u3RMa/cbTKaeosmbKSlDvfz21bcwvcZ0
77k97XryOnUpNW0BSPkxBWiK7hzHbQommDoO7kyr71FJ2WXi5GCmVbJezsZxYdDY
s/w/cw5wTtdtlTXoDnwJIp0ob+ud8tof7a5YaxMEom/HNgbzTp1+D4ofOTtUuUgs
lwaFnrNbztmAsMd4oS2sSJks9/VxxWliLOc1Av7mFH2Sqjdt9YEpfDFOJlLcFWCJ
KdAL/pK27rP7SBuBNeiL+DMNif3XxC76L/LJeWcVVhtDjZR3J2ELSOuFfBQrw6Ue
qPNhQypPNX9hD/i3iv47p8yALN9RuZ3brzU9c/Cis1bdZoVus5Pwz1pmI39dYRqj
AQUOkPLGu2e2SMFNTsZavxmVYm8Aok3SLGAzmaVPwCT3KgNTMXoP+HFek5MWslEZ
7wX4hFGXoZrDrxookl2/Zu0VvXhUz1IrSfRabmH/IHwxGmg9jVhAXE7SAUTrjRmE
Qa10aifCii2TrTYkmCw0tl/xoeiOWaK9JHNktiDLStJPdBjKprUdA7AhPUEfLIdN
R4tVCSJizFZHR0sd1IW0
=P4F4
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Sep_2012_15_10_14_+1000_BxF_kqtC.N0OVgvT--
