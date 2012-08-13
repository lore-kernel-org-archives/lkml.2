Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2HMCfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 22:35:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857Ab2HMCfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 22:35:06 -0400
Date: Mon, 13 Aug 2012 12:34:53 +1000
From: NeilBrown <neilb@suse.de>
To: balbi@ti.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Infinite looping in omap2430.c USB driver
Message-ID: <20120813123453.4cba14ca@notabene.brown>
In-Reply-To: <20120809111549.GT12174@arwen.pp.htv.fi>
References: <20120707083949.2cf91eeb@notabene.brown>
	<20120809111549.GT12174@arwen.pp.htv.fi>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/IAnIF=EIPIm1aK7eCXcbeMK"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/IAnIF=EIPIm1aK7eCXcbeMK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 9 Aug 2012 14:15:51 +0300 Felipe Balbi <balbi@ti.com> wrote:


> hehe, that's nasty. Please send a patch converting to a try count and a
> udelay_range(), or something.
>=20

how's this?

Thanks,
NeilBrown


From: NeilBrown <neilb@suse.de>
Date: Mon, 13 Aug 2012 12:32:58 +1000
Subject: [PATCH] omap2430: don't loop indefinitely in interrupt.

When called during resume_irqs, omap2430_musb_set_vbus() is run with
interrupts disabled,  In that case 'jiffies' never changes so the loop
can loop forever.

So impose a maximum loop count and add an 'mdelay' to ensure we wait
a reasonable amount of time for bit to be cleared.

This fixes a hang on resume.

Signed-of-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index c7785e8..8a93381 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -34,6 +34,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/pm_runtime.h>
 #include <linux/err.h>
+#include <linux/delay.h>
=20
 #include "musb_core.h"
 #include "omap2430.h"
@@ -145,6 +146,7 @@ static void omap2430_musb_set_vbus(struct musb *musb, i=
nt is_on)
=20
 	if (is_on) {
 		if (musb->xceiv->state =3D=3D OTG_STATE_A_IDLE) {
+			int loops =3D 100;
 			/* start the session */
 			devctl |=3D MUSB_DEVCTL_SESSION;
 			musb_writeb(musb->mregs, MUSB_DEVCTL, devctl);
@@ -154,9 +156,11 @@ static void omap2430_musb_set_vbus(struct musb *musb, =
int is_on)
 			 */
 			while (musb_readb(musb->mregs, MUSB_DEVCTL) & 0x80) {
=20
+				mdelay(5);
 				cpu_relax();
=20
-				if (time_after(jiffies, timeout)) {
+				if (time_after(jiffies, timeout)
+				    || loops-- <=3D 0) {
 					dev_err(musb->controller,
 					"configured as A device timeout");
 					ret =3D -EINVAL;

--Sig_/IAnIF=EIPIm1aK7eCXcbeMK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUChnzTnsnt1WYoG5AQK+fBAAlv2n740UiFMpfbLBf2OLnfnHsTcy1WVE
KTuJL4sJroEW6u17Z9DaZ8Fh7IHN+zqZfgzR7H54x5V4sx7DtEFU5vAM6hzB96r9
SkglQKvwYD9XCq8Oqfod9ru6/g0zptH1oVbV1vLA54RwU6EbZpo7KSGjnNHRrp+Y
lUKfYw39T1JKmZsFmcbP9ZUAFButXFGsYs0KRFrBVziHc8xFBY031LXLmWtSLyI+
fMC/R4rn+dAdCpWSVt2WTxyiiz6wEY7ynNG3TBHGtG22Vsw3EZM37ViBN+857FQL
M/tL8nSKbHC3OF01AVwsssjS1ce/sNyYs0M0MbT0n0B6p1XDxnMLG4sfFd5N7j8a
Bj2eIBKJcOwKsOchbJLlOy7Qu7NzwXAT64bR8v7goEO0LmLs1hZeRaqFuCCU2Etb
xLAPvG4JwUSKehvQw2R8yG9uiSuYGfPR0m3Wv9r9UUOzo/BS8ZXqBJY3A0WaUxy8
+ly3IITsCQmptwSGv9itbnCZDxIUZwDYLLP86zFfyargf93v7UJIvSeKibybzM8Z
2g51OxcLrMfNmuyAtxA6yC/X+de4PZzmZG4w8Ce8+27k2YNSLn+oOdKM6japMPms
CejNOKqXbD1KK6qkrlMGnHORD8SPEoxvooIJoOrIHwYhOmnCXcEjzFlMhS1LjqAy
P6r3UFoiZcs=
=mWBd
-----END PGP SIGNATURE-----

--Sig_/IAnIF=EIPIm1aK7eCXcbeMK--
