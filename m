Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2KBGFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 02:05:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36935 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2KBGFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 02:05:08 -0400
Date: Fri, 2 Nov 2012 17:04:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: linux-next: build failures after merge of the final tree (usb tree
 related)
Message-Id: <20121102170459.5e152727a2a38797ee493da0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__2_Nov_2012_17_04_59_+1100_0AK3=k=8+0l/.lQB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__2_Nov_2012_17_04_59_+1100_0AK3=k=8+0l/.lQB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi ,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

In file included from drivers/usb/host/ehci-platform.c:28:0:
drivers/usb/host/ehci.h: In function 'ehci_readl':
drivers/usb/host/ehci.h:662:3: error: implicit declaration of function 'rea=
dl_be' [-Werror=3Dimplicit-function-declaration]
drivers/usb/host/ehci.h:663:3: error: implicit declaration of function 'rea=
dl' [-Werror=3Dimplicit-function-declaration]
drivers/usb/host/ehci.h: In function 'ehci_writel':
drivers/usb/host/ehci.h:674:3: error: implicit declaration of function 'wri=
tel_be' [-Werror=3Dimplicit-function-declaration]
drivers/usb/host/ehci.h:675:3: error: implicit declaration of function 'wri=
tel' [-Werror=3Dimplicit-function-declaration]

Caused by commit 99f91934a907 ("USB: EHCI: make ehci-platform a separate
driver") from the usb tree.

I have reverted that commit for today.

I then got:

drivers/usb/chipidea/built-in.o: In function `ehci_init_driver':
(.opd+0x5a0): multiple definition of `ehci_init_driver'
drivers/usb/host/built-in.o:(.opd+0xb58): first defined here
drivers/usb/chipidea/built-in.o: In function `.ehci_init_driver':
(.text+0x6528): multiple definition of `.ehci_init_driver'
drivers/usb/host/built-in.o:(.text+0x9eb4): first defined here
drivers/usb/chipidea/built-in.o: In function `ehci_suspend':
(.opd+0xc18): multiple definition of `ehci_suspend'
drivers/usb/host/built-in.o:(.opd+0x11d0): first defined here
drivers/usb/chipidea/built-in.o: In function `ehci_resume':
(.opd+0x1020): multiple definition of `ehci_resume'
drivers/usb/host/built-in.o:(.opd+0x1680): first defined here
drivers/usb/chipidea/built-in.o: In function `.ehci_suspend':
(.text+0x100e4): multiple definition of `.ehci_suspend'
drivers/usb/host/built-in.o:(.text+0x13b00): first defined here
drivers/usb/chipidea/built-in.o: In function `.ehci_resume':
(.text+0x17760): multiple definition of `.ehci_resume'
drivers/usb/host/built-in.o:(.text+0x1b498): first defined here
drivers/usb/chipidea/built-in.o: In function `ehci_setup':
(.opd+0x1128): multiple definition of `ehci_setup'
drivers/usb/host/built-in.o:(.opd+0x17a0): first defined here
drivers/usb/chipidea/built-in.o: In function `.ehci_setup':
(.text+0x228f0): multiple definition of `.ehci_setup'
drivers/usb/host/built-in.o:(.text+0x266fc): first defined here

Which is caused by commit 3e0232039967 ("USB: EHCI: prepare to make
ehci-hcd a library module").

I have added the following patch to disable the chipidea driver for now:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 2 Nov 2012 16:59:55 +1100
Subject: [PATCH] usb: mark the chipidea broken for now

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/usb/chipidea/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/chipidea/Kconfig b/drivers/usb/chipidea/Kconfig
index 1ea932a..26a239a 100644
--- a/drivers/usb/chipidea/Kconfig
+++ b/drivers/usb/chipidea/Kconfig
@@ -1,6 +1,7 @@
 config USB_CHIPIDEA
 	tristate "ChipIdea Highspeed Dual Role Controller"
 	depends on USB || USB_GADGET
+	depends on BROKEN
 	help
 	  Say Y here if your system has a dual role high speed USB
 	  controller based on ChipIdea silicon IP. Currently, only the
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__2_Nov_2012_17_04_59_+1100_0AK3=k=8+0l/.lQB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQk2KLAAoJEECxmPOUX5FE7NQP/2L6rHlVwaYA86hvvu7ZIqkm
8tErXYmk0a73sVzeInfaXeS/vk42GIatyi1O3CFIPphextljqb1ts86QbhLLfnU5
aHt6vlxkEjcqC4BicgqorfpruFvy4fPvZKPKKQMHNTJzj7oTGGKHpVP0JvLpkfP8
WwYVPnZivHanBNcu0uX7iG16+h7PdQqaG4+i4MHVcB64HxFOwRI86FsgYVU95kZw
DuS6Ec+Wp0nAvtcXcLzpC1JIPpcxYlw0qRJ8e0iQnrHWmismKuW78rQvn7m9VEBn
XiV1kFSdNP8AABZn6AY20rM8Ww6hVipMwvyKWRrgBdHwY3FAkYbJQ402pcR6lzvR
LExLnsU4hMTMXUvln0vrnBYtJB4S95SY4yDs45Hl13rpl7GFule1td85qiZtF+Kl
0sF5gPCE29siPYlnztVHNY/c52tRC/9yAuaYtSRybjJ2TPFVEOgVntKO+MaWntBa
sFlZsNaoKwuh8kdj2NNmBzqZ1q4i2FLd4c91XsWEp4FoiXwjyOCkiFuu47wGM0d0
FiSbzkqm0TGL1YQ2fthbRaqLQotti+TTaGeLxZulXYl3dItNLYtsAqzMwSLnCBMB
deaPpA6aQbFvahM5uZX1xS0zeWITYs7SP+dicgJlm+5BYcdwp0a2KRBaI1XYdkPi
LoEVXRmwWg9ZpjCAr65M
=8EOf
-----END PGP SIGNATURE-----

--Signature=_Fri__2_Nov_2012_17_04_59_+1100_0AK3=k=8+0l/.lQB--
