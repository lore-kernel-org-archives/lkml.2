Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab2EABCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 21:02:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757312Ab2EABCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 21:02:12 -0400
Date: Tue, 1 May 2012 11:01:56 +1000
From: NeilBrown <neilb@suse.de>
To: <t-kristo@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 4/6] twl4030_charger: Allow charger to control the
 regulator that feeds it.
Message-ID: <20120501110156.730de36d@notabene.brown>
In-Reply-To: <1335780872.2149.181.camel@sokoban>
References: <20120425072931.20124.56635.stgit@notabene.brown>
	<20120425073310.20124.68293.stgit@notabene.brown>
	<1335780872.2149.181.camel@sokoban>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/El9bYR3tPHXoicIbXO2TuWR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/El9bYR3tPHXoicIbXO2TuWR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Apr 2012 13:14:32 +0300 Tero Kristo <t-kristo@ti.com> wrote:

> Hi Neil,
>=20
> As I am supposed to be acting as a maintainer for the drivers/mfd/twl-*,
> you can add an ack from me for the twl-core.c part. It looks kind of
> okay, even if I would eventually like to remove/fix the ugly regulator
> init from twl-core.

Thanks.

>=20
> Just a question, who is going to merge all this seeing it is touching
> stuff all over the place?

Good question.  I'll try Anton Vorontsov as he seems to handle drivers/powe=
r/
stuff.  Maybe with your ack he will take it.  Otherwise apkm seems to be the
default if no-one else cares :-)

Thanks,
NeilBrown


>=20
> -Tero
>=20
>=20
> On Wed, 2012-04-25 at 17:33 +1000, NeilBrown wrote:
> > The charger needs usb3v1 to be running, so add a new consumer to
> > keep it running.
> >=20
> > This allows the charger to draw current even when the USB driver has
> > powered down.
> >=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >=20
> >  drivers/mfd/twl-core.c          |    9 +++++----
> >  drivers/power/twl4030_charger.c |   15 +++++++++++++++
> >  2 files changed, 20 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
> > index 7c2267e..4cbf285 100644
> > --- a/drivers/mfd/twl-core.c
> > +++ b/drivers/mfd/twl-core.c
> > @@ -723,8 +723,9 @@ add_children(struct twl4030_platform_data *pdata, u=
nsigned irq_base,
> >  		static struct regulator_consumer_supply usb1v8 =3D {
> >  			.supply =3D	"usb1v8",
> >  		};
> > -		static struct regulator_consumer_supply usb3v1 =3D {
> > -			.supply =3D	"usb3v1",
> > +		static struct regulator_consumer_supply usb3v1[] =3D {
> > +			{ .supply =3D	"usb3v1" },
> > +			{ .supply =3D	"bci3v1" },
> >  		};
> > =20
> >  	/* First add the regulators so that they can be used by transceiver */
> > @@ -752,7 +753,7 @@ add_children(struct twl4030_platform_data *pdata, u=
nsigned irq_base,
> >  				return PTR_ERR(child);
> > =20
> >  			child =3D add_regulator_linked(TWL4030_REG_VUSB3V1,
> > -						      &usb_fixed, &usb3v1, 1,
> > +						      &usb_fixed, usb3v1, 2,
> >  						      features);
> >  			if (IS_ERR(child))
> >  				return PTR_ERR(child);
> > @@ -773,7 +774,7 @@ add_children(struct twl4030_platform_data *pdata, u=
nsigned irq_base,
> >  		if (twl_has_regulator() && child) {
> >  			usb1v5.dev_name =3D dev_name(child);
> >  			usb1v8.dev_name =3D dev_name(child);
> > -			usb3v1.dev_name =3D dev_name(child);
> > +			usb3v1[0].dev_name =3D dev_name(child);
> >  		}
> >  	}
> >  	if (twl_has_usb() && pdata->usb && twl_class_is_6030()) {
> > diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_ch=
arger.c
> > index 684662a..d9d8e4a 100644
> > --- a/drivers/power/twl4030_charger.c
> > +++ b/drivers/power/twl4030_charger.c
> > @@ -21,6 +21,7 @@
> >  #include <linux/power_supply.h>
> >  #include <linux/notifier.h>
> >  #include <linux/usb/otg.h>
> > +#include <linux/regulator/machine.h>
> > =20
> >  #define TWL4030_BCIMSTATEC	0x02
> >  #define TWL4030_BCIICHG		0x08
> > @@ -86,6 +87,8 @@ struct twl4030_bci {
> >  	struct work_struct	work;
> >  	int			irq_chg;
> >  	int			irq_bci;
> > +	struct regulator	*usb_reg;
> > +	int			usb_enabled;
> > =20
> >  	unsigned long		event;
> >  };
> > @@ -179,6 +182,12 @@ static int twl4030_charger_enable_usb(struct twl40=
30_bci *bci, bool enable)
> >  			return -EACCES;
> >  		}
> > =20
> > +		/* Need to keep regulator on */
> > +		if (!bci->usb_enabled) {
> > +			regulator_enable(bci->usb_reg);
> > +			bci->usb_enabled =3D 1;
> > +		}
> > +
> >  		/* forcing the field BCIAUTOUSB (BOOT_BCI[1]) to 1 */
> >  		ret =3D twl4030_clear_set_boot_bci(0, TWL4030_BCIAUTOUSB);
> >  		if (ret < 0)
> > @@ -189,6 +198,10 @@ static int twl4030_charger_enable_usb(struct twl40=
30_bci *bci, bool enable)
> >  			TWL4030_USBFASTMCHG, TWL4030_BCIMFSTS4);
> >  	} else {
> >  		ret =3D twl4030_clear_set_boot_bci(TWL4030_BCIAUTOUSB, 0);
> > +		if (bci->usb_enabled) {
> > +			regulator_disable(bci->usb_reg);
> > +			bci->usb_enabled =3D 0;
> > +		}
> >  	}
> > =20
> >  	return ret;
> > @@ -507,6 +520,8 @@ static int __init twl4030_bci_probe(struct platform=
_device *pdev)
> >  	bci->usb.num_properties =3D ARRAY_SIZE(twl4030_charger_props);
> >  	bci->usb.get_property =3D twl4030_bci_get_property;
> > =20
> > +	bci->usb_reg =3D regulator_get(bci->dev, "bci3v1");
> > +
> >  	ret =3D power_supply_register(&pdev->dev, &bci->usb);
> >  	if (ret) {
> >  		dev_err(&pdev->dev, "failed to register usb: %d\n", ret);
> >=20
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Sig_/El9bYR3tPHXoicIbXO2TuWR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT582BDnsnt1WYoG5AQJjZw/+LsE28e2aku5X4PQO8sM+tSlfGtWCc74B
0Tl2SwayPjLUZ7YrnPnP6RgXc2mHEmu2OnMH9CHcYq89xtwvy5DW7XpbJv2LbylI
5ovMBH4b917TlZsTat6ljda2OLJ4+Z1NqVQ1eShchdwf0n46JrIufEY6u3Owwwvy
9BQvQrXfQNaE2t4L7Mu/N6u8QmFcUuufveC05m/GNZgBlWPrD/g04nwKVcnFHl3C
ipilLUi4iW+0m6Zxj2DHDWK07rnpCGTf9lJJDyZKClgxJbFF6Kgt2MQ0WpIBfafr
M60bSIDRGufcWr0XUUyGJNeY7f5UgKx3ucOwsxdJ9vQ62mVjXIOANiqMy4xwU+6m
9u/z/69dnfQNHo0m8r0xAUmwnPAypkYsUDKH/ShM17fplJ1wgk9qtse5EQdF0cS4
ACCmTFfwpeq+w/sA5gkiqMlPSOByrJzMq+EXUXAAC4SnncA9zXQuKkxvcEhCrEdE
SrWp9OIgyk02ynX2O8Z0GMNf32m5ThBsgi5NxLSnQTAoWv2dAAiYzxsMNNhgwGcK
KL2ZrtqFsoqpjQU9WtBfEj+CCS85mfVJcsmhSSwarMT8QWgEjmFAiEBJcHrKV3OO
aRPw64DoCEJjeuj0laup44ymVGngXy8Rm8pV3dFUst5GWnDBV5NKnjVtNil2rwzF
8Ow3trZ/490=
=WzKC
-----END PGP SIGNATURE-----

--Sig_/El9bYR3tPHXoicIbXO2TuWR--
