Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab2BPCTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 21:19:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47675 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496Ab2BPCTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 21:19:00 -0500
Date: Thu, 16 Feb 2012 13:18:52 +1100
From: NeilBrown <neilb@suse.de>
To: Thomas Weber <weber@corscience.de>
Cc: zbr@ioremap.net, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Fix w1_bq27000
Message-ID: <20120216131852.79724a63@notabene.brown>
In-Reply-To: <4F3BD0E9.5070305@corscience.de>
References: <20111230004947.11559.81184.stgit@notabene.brown>
	<20111230005849.11559.79397.stgit@notabene.brown>
	<4F3BD0E9.5070305@corscience.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AkCT3PTHO.vPrCtnINp3DMy"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/AkCT3PTHO.vPrCtnINp3DMy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Feb 2012 16:36:09 +0100 Thomas Weber <weber@corscience.de> wrote:

> Hello Neil,
>=20
> On 30.12.2011 01:58, NeilBrown wrote:
> > w1_bq27000 adds a bq27000-battery platform device but does not provide
> > platform data for it. This causes the bq27x00 driver to dereference a N=
ULL
> > pointer.
> > So provide the appropriate platform data.  This requires modifying
> > w1_bq27000_read so that it find the w1 device as the parent of the bq d=
evice.
> >=20
> > Also there is no point exporting w1_bq27000_read as nothing else uses it
> > or could use it.  So make it static.
> >=20
> > Finally, as there is no way to track how many batteries have been found=
, and
> > we will probably only find one, use an id number of '-1' to assert that=
 this
> > is a unique instance.
> >=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >=20
> >  drivers/w1/slaves/w1_bq27000.c |   17 ++++++++++++-----
> >  1 files changed, 12 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/drivers/w1/slaves/w1_bq27000.c b/drivers/w1/slaves/w1_bq27=
000.c
> > index 8f4c91f..8f10fd2 100644
> > --- a/drivers/w1/slaves/w1_bq27000.c
> > +++ b/drivers/w1/slaves/w1_bq27000.c
> > @@ -15,6 +15,7 @@
> >  #include <linux/types.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/mutex.h>
> > +#include <linux/power/bq27x00_battery.h>
> > =20
> >  #include "../w1.h"
> >  #include "../w1_int.h"
> > @@ -39,10 +40,10 @@ void w1_bq27000_write(struct device *dev, u8 buf, u=
8 reg)
> >  }
> >  EXPORT_SYMBOL(w1_bq27000_write);
> > =20
> > -int w1_bq27000_read(struct device *dev, u8 reg)
> > +static int w1_bq27000_read(struct device *dev, unsigned int reg)
> >  {
> >  	u8 val;
> > -	struct w1_slave *sl =3D container_of(dev, struct w1_slave, dev);
> > +	struct w1_slave *sl =3D container_of(dev->parent, struct w1_slave, de=
v);
> > =20
> >  	if (!dev)
> >  		return 0;
> > @@ -52,19 +53,25 @@ int w1_bq27000_read(struct device *dev, u8 reg)
> > =20
> >  	return val;
> >  }
> > -EXPORT_SYMBOL(w1_bq27000_read);
> > +
> > +static struct bq27000_platform_data bq27000_battery_info =3D {
> > +	.read   =3D w1_bq27000_read,
> > +	.name   =3D "bq27000-battery",
> > +};
> > =20
> >  static int w1_bq27000_add_slave(struct w1_slave *sl)
> >  {
> >  	int ret;
> > -	int id =3D 1;
> >  	struct platform_device *pdev;
> > =20
> > -	pdev =3D platform_device_alloc("bq27000-battery", id);
> > +	pdev =3D platform_device_alloc("bq27000-battery", -1);
> >  	if (!pdev) {
> >  		ret =3D -ENOMEM;
> >  		return ret;
> >  	}
> > +	ret =3D platform_device_add_data(pdev,
> > +				       &bq27000_battery_info,
> > +				       sizeof(bq27000_battery_info));
> >  	pdev->dev.parent =3D &sl->dev;
> > =20
> >  	ret =3D platform_device_add(pdev);
> >=20
> >=20
>=20
> Tested-by: Thomas Weber <weber@corscience.de>
>=20
> Thanks for the patch, now the platform data of the bq27000 are found.
>=20
> before:
>=20
> omap_hdq omap_hdq.0: OMAP HDQ Hardware Rev 0.5. Driver in Interrupt mode
> w1_master_driver w1_bus_master1: Family 1 for 01.000000000000.3d is not
> registered.
> bq27000-battery bq27000-battery.1: no platform_data supplied
> bq27000-battery: probe of bq27000-battery.1 failed with error -22
>=20
> after:
>=20
> omap_hdq omap_hdq.0: OMAP HDQ Hardware Rev 0.5. Driver in Interrupt mode
> w1_master_driver w1_bus_master1: Family 1 for 01.000000000000.3d is not
> registered.
> bq27000-battery bq27000-battery: support ver. 1.2.0 enabled
>=20

Hi Thomas,
 thanks for testing and forwarding to Greg - I appreciate it.

NeilBrown

--Sig_/AkCT3PTHO.vPrCtnINp3DMy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzxnjDnsnt1WYoG5AQKn6w/+LUNKb6DmG9BCln9lO2T+5g71RDe4bJzK
xFW2bM+55Kt3xEqWl/Hqo99ZcMZT/ur0PDhZvgPc9Ak26ZRpn+TfNVyqUWGKSsSP
h9M8UaMvgEbP361P14/vN5tktQPBoyPGQiROLiLOp86QzH0kDTvv1PTHBDaXoKfL
JnWLpiY+3MQMXwcUT6fKxHHs2M8/FVMuoYFmPgP4g9HVPyIcpDHneA8HIs+AUzrh
8arJsCUZ8MoUzuX+UJpjtyygolnT4nbLMppyrsNT65PLQ+g9c2hnLhnKXnQEhIS9
fbvxhetdefbfq6rcaENWw96HMauZp7j70E11GxFcXJVEz1dCn8QkNmL2U2Bbrq2M
zArtLsomoXytAfZwlJq3lbp6gDbfhe7OKThVlM6G2coh63egkHkswBqRuHYAVDsE
v5c9HgDrUgsmc/Jk1pBkE6aw+YlJs7LmpIjrhsN479quPZxYN41aoCFjt26FPJzk
519+otf8PFeqeULumsyaljfuHnrqzNGFYT5zYA+lgrIY2BLiyIJuvcnVp2X9TpKS
Y96UidAV4Q/lqFKIXt0uZLUmkQOHswZuBRvwodY1o8UixsbT92okLcGq3H2oGhwQ
XN6WpIiRILHj/siN6BlCbOSF4GP2avV6YsM65vYqVk/od4R2XrVmTRXapCZURZ8T
IYJk8OUb1fA=
=rcsy
-----END PGP SIGNATURE-----

--Sig_/AkCT3PTHO.vPrCtnINp3DMy--
