Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2HMVrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 17:47:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737Ab2HMVrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 17:47:13 -0400
Date: Tue, 14 Aug 2012 07:46:59 +1000
From: NeilBrown <neilb@suse.de>
To: balbi@ti.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Infinite looping in omap2430.c USB driver
Message-ID: <20120814074659.3c48fa41@notabene.brown>
In-Reply-To: <20120813143233.GJ14781@arwen.pp.htv.fi>
References: <20120707083949.2cf91eeb@notabene.brown>
	<20120809111549.GT12174@arwen.pp.htv.fi>
	<20120813123453.4cba14ca@notabene.brown>
	<20120813143233.GJ14781@arwen.pp.htv.fi>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/O3/YEC0cfVz6AADutU7CybN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/O3/YEC0cfVz6AADutU7CybN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Aug 2012 17:32:34 +0300 Felipe Balbi <balbi@ti.com> wrote:

> Hi,
>=20
> On Mon, Aug 13, 2012 at 12:34:53PM +1000, NeilBrown wrote:
> > On Thu, 9 Aug 2012 14:15:51 +0300 Felipe Balbi <balbi@ti.com> wrote:
> >=20
> >=20
> > > hehe, that's nasty. Please send a patch converting to a try count and=
 a
> > > udelay_range(), or something.
> > >=20
> >=20
> > how's this?
> >=20
> > Thanks,
> > NeilBrown
> >=20
> >=20
> > From: NeilBrown <neilb@suse.de>
> > Date: Mon, 13 Aug 2012 12:32:58 +1000
> > Subject: [PATCH] omap2430: don't loop indefinitely in interrupt.
> >=20
> > When called during resume_irqs, omap2430_musb_set_vbus() is run with
> > interrupts disabled,  In that case 'jiffies' never changes so the loop
> > can loop forever.
> >=20
> > So impose a maximum loop count and add an 'mdelay' to ensure we wait
> > a reasonable amount of time for bit to be cleared.
> >=20
> > This fixes a hang on resume.
> >=20
> > Signed-of-by: NeilBrown <neilb@suse.de>
> >=20
> > diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> > index c7785e8..8a93381 100644
> > --- a/drivers/usb/musb/omap2430.c
> > +++ b/drivers/usb/musb/omap2430.c
> > @@ -34,6 +34,7 @@
> >  #include <linux/dma-mapping.h>
> >  #include <linux/pm_runtime.h>
> >  #include <linux/err.h>
> > +#include <linux/delay.h>
> > =20
> >  #include "musb_core.h"
> >  #include "omap2430.h"
> > @@ -145,6 +146,7 @@ static void omap2430_musb_set_vbus(struct musb *mus=
b, int is_on)
> > =20
> >  	if (is_on) {
> >  		if (musb->xceiv->state =3D=3D OTG_STATE_A_IDLE) {
> > +			int loops =3D 100;
> >  			/* start the session */
> >  			devctl |=3D MUSB_DEVCTL_SESSION;
> >  			musb_writeb(musb->mregs, MUSB_DEVCTL, devctl);
> > @@ -154,9 +156,11 @@ static void omap2430_musb_set_vbus(struct musb *mu=
sb, int is_on)
> >  			 */
> >  			while (musb_readb(musb->mregs, MUSB_DEVCTL) & 0x80) {
> > =20
> > +				mdelay(5);
>=20
> I would prefer udelay_range() as it will let scheduler group timers.
> Something like:
>=20
> udelay_range(3000, 5000);
>=20
> should do, I gues...
>=20

Except that there is no udelay_range :-(
There is a usleep_range, but that can only be used from non-atomic context
and in the problem case interrupts are disabled and a spinlock is held so we
very definitely are not in non-atomic context.  If we need a delay at all, =
it
has to be udelay or mdelay.
If we could do this in a work function rather than directly from the
interrupt handler that would be best but I have no idea what dependencies
there are..  Would it be safe for musb_stage0_irq() to ask a workqueue to r=
un
musb_platform_set_vbus rather than doing it directly?

NeilBrown

--Sig_/O3/YEC0cfVz6AADutU7CybN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCl11Dnsnt1WYoG5AQJJsg/9FnUwDskgksBvUVtvUG2VvFkcuuTt4rlX
6Dfrokw3Bow+I8o4KQW6F1FK+uvPM3D7laDhTOTMDsFG96gkqb7VkL8iwiTVmCNw
uIvTQvvkbi8/VTIcIYpS4SEvujC2uYpkXC0NNx+4DlBJBpeAxCOH8hMGcvSoS2jP
KmhXxzt8lQhpL6OYHjL4vsiMG1ehywQamkY7X5vnj1aloT1itTWjvE6yJ33fzND3
3MhDQ6g84r2AfK3gWnx2B4Uer/h4rZYVf+SJiDgvI4uXfm0rU1lhVbHcH28qujq+
VGHa+ruGX9dihFmgkFKgD4E7ELDCc20rtIWlmhr0rnRiqJSqxa5kvMFUAl4wjKQu
aJnjhQmnk6R+B/hYN6dPBzI+yjKZD9soqlH5uG8YsoaWpOYh3O/wWp2rEj03gNjH
2eLyLKg6BaTa02t8PXCvPYRiFRt3LVj6yzpzUbb1dyF23+XhvbjRN8CHsSb+hLNo
Rz6L5FKvOHzeUnsZXkNnUWptqVr77BGMPyGdomX/+XgDEY3A8UjmlHGMwkSVnpdz
RKGDebEL4CRQVKrsmGff2bpJ9yhTT28SBG8wPT1iH3wJOktepLk3O1KIDNKLU2l+
qsm92WyYSNtIisVq4SQMJjyZDpgIMLyubWJM33I8v17P9T047AWrJHRnFdScBaMm
GTO3mYZYups=
=RrmW
-----END PGP SIGNATURE-----

--Sig_/O3/YEC0cfVz6AADutU7CybN--
