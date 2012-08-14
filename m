Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab2HNIBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:01:55 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:60924 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836Ab2HNIBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:01:54 -0400
Date: Tue, 14 Aug 2012 10:58:07 +0300
From: Felipe Balbi <balbi@ti.com>
To: NeilBrown <neilb@suse.de>
Cc: balbi@ti.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Infinite looping in omap2430.c USB driver
Message-ID: <20120814075806.GA32585@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <20120707083949.2cf91eeb@notabene.brown>
 <20120809111549.GT12174@arwen.pp.htv.fi>
 <20120813123453.4cba14ca@notabene.brown>
 <20120813143233.GJ14781@arwen.pp.htv.fi>
 <20120814074659.3c48fa41@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20120814074659.3c48fa41@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 14, 2012 at 07:46:59AM +1000, NeilBrown wrote:
> On Mon, 13 Aug 2012 17:32:34 +0300 Felipe Balbi <balbi@ti.com> wrote:
>=20
> > Hi,
> >=20
> > On Mon, Aug 13, 2012 at 12:34:53PM +1000, NeilBrown wrote:
> > > On Thu, 9 Aug 2012 14:15:51 +0300 Felipe Balbi <balbi@ti.com> wrote:
> > >=20
> > >=20
> > > > hehe, that's nasty. Please send a patch converting to a try count a=
nd a
> > > > udelay_range(), or something.
> > > >=20
> > >=20
> > > how's this?
> > >=20
> > > Thanks,
> > > NeilBrown
> > >=20
> > >=20
> > > From: NeilBrown <neilb@suse.de>
> > > Date: Mon, 13 Aug 2012 12:32:58 +1000
> > > Subject: [PATCH] omap2430: don't loop indefinitely in interrupt.
> > >=20
> > > When called during resume_irqs, omap2430_musb_set_vbus() is run with
> > > interrupts disabled,  In that case 'jiffies' never changes so the loop
> > > can loop forever.
> > >=20
> > > So impose a maximum loop count and add an 'mdelay' to ensure we wait
> > > a reasonable amount of time for bit to be cleared.
> > >=20
> > > This fixes a hang on resume.
> > >=20
> > > Signed-of-by: NeilBrown <neilb@suse.de>
> > >=20
> > > diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> > > index c7785e8..8a93381 100644
> > > --- a/drivers/usb/musb/omap2430.c
> > > +++ b/drivers/usb/musb/omap2430.c
> > > @@ -34,6 +34,7 @@
> > >  #include <linux/dma-mapping.h>
> > >  #include <linux/pm_runtime.h>
> > >  #include <linux/err.h>
> > > +#include <linux/delay.h>
> > > =20
> > >  #include "musb_core.h"
> > >  #include "omap2430.h"
> > > @@ -145,6 +146,7 @@ static void omap2430_musb_set_vbus(struct musb *m=
usb, int is_on)
> > > =20
> > >  	if (is_on) {
> > >  		if (musb->xceiv->state =3D=3D OTG_STATE_A_IDLE) {
> > > +			int loops =3D 100;
> > >  			/* start the session */
> > >  			devctl |=3D MUSB_DEVCTL_SESSION;
> > >  			musb_writeb(musb->mregs, MUSB_DEVCTL, devctl);
> > > @@ -154,9 +156,11 @@ static void omap2430_musb_set_vbus(struct musb *=
musb, int is_on)
> > >  			 */
> > >  			while (musb_readb(musb->mregs, MUSB_DEVCTL) & 0x80) {
> > > =20
> > > +				mdelay(5);
> >=20
> > I would prefer udelay_range() as it will let scheduler group timers.
> > Something like:
> >=20
> > udelay_range(3000, 5000);
> >=20
> > should do, I gues...
> >=20
>=20
> Except that there is no udelay_range :-(
> There is a usleep_range, but that can only be used from non-atomic context
> and in the problem case interrupts are disabled and a spinlock is held so=
 we

my bad. Got confused. I will apply the original patch then. Thanks.

--=20
balbi

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQKgUOAAoJEIaOsuA1yqREI88P/0ZJsdAZYDGQLQqUig89f5w6
egEwF7NXFm1nGOyxI8wc1IzE7FpH9+UZOMJx4z4n4c2BCKOOL6w9krMX/k1NkxI1
lNM3xgnWlxjdSTPWM56inf0ZdQcrlw31QOhmO55LAc9xEp0jD59eJTnCN6KB4uEA
qp0PyziWyWFlUdLigQRPRO8EZnytOan/3aKTtPpAN4BGdLxYp6NBkC4YppckU/rn
S9JIkHkvLUJzlga28b90N+iyVfbFrlL2tmiGoXhnfvb8H4uoWqvRbepf9Wn34CRi
ovudLXL5dabgrhATmCYptFfHvjTnHsuI+TnD+PKQU43vdH2hvHVtgOiGNAdA8E0q
smZZXKv4KghTFXT+HSoHSMru2Fwzf1nmL0F68QxjtGKmpmO94/YAYCe8dt5GA3Ue
SvCzfousd5pfMqvydUpZ41iTwzVLpekkxXfzW/AlIGyUQiA7IdCP3dr7F/9flhqu
0FUhPlg+6/OFD0+Ek2G/+Vf4d85k8gmjJ3E1u8zx2bKyqiKJwXzoaeje3Fk4gqna
mOnbOJYLEI3visVMUOtn3gQV4bjK/EQbYW9HJjEJ/O75v2BKAMO4hZxNkp0RwIY6
K8kvNgk7RG/d9RekuBXa8hmoJI890oSd3TJNl+Lk6QG80rGy3LdRgn2Y6Y6htW1B
fvsef2dHhzipqTPKYrAJ
=iHdh
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
