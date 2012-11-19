Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab2KSKXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:23:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54737 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab2KSKXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:23:09 -0500
Date: Mon, 19 Nov 2012 11:23:03 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: adc: Add Texas Instruments ADC081C021/027 support
Message-ID: <20121119102303.GA11566@avionic-0098.mockup.avionic-design.de>
References: <1353313289-983-1-git-send-email-thierry.reding@avionic-design.de>
 <50A9FCFC.60002@metafoo.de>
 <20121119095053.GA3951@avionic-0098.mockup.avionic-design.de>
 <50AA0431.9060609@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <50AA0431.9060609@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:3okItzpWv/0ChDAyI5HyCJK98MSkFhWFy54X+Sve/iK
 lPnsOu9p6RLS3MjukkD01Am2W1R84cJEK+faR774jVmUWlAnsH
 SRJHRiEyLUlms1ObQA5/O7VRP2Kl2TE1Oj+NKoljHTZ5lG5K/f
 OvQre3SN3Eau8GbPl8F7QOXjq+v3r8INH6WYuCUTBHENxO6hQs
 A4y5R96ObK5BstwvqfovOnKZ0DNQfCKrQ3ce7bZxpJVHUv3v4J
 OoLZq1c1iJtdrGfrgHOEjjnZWf1mwa9DGrMeEBCoyGW8HbVEoU
 ysC4isZtv4KxvNHnba4yMGCsNFddFxsBAMaFH0tsJ4ZgK7qtVu
 HauaicP+bewgFLRH0aHGdN/bsCgR5X4utZ4r8sCiswfbHxuwRt
 yq+zoSnDItcqLTfM2zQoYyX+Ary3G5z5Dx1JtJoTuTpbOfPaut
 CJfKW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 19, 2012 at 11:04:33AM +0100, Lars-Peter Clausen wrote:
> On 11/19/2012 10:50 AM, Thierry Reding wrote:
> > On Mon, Nov 19, 2012 at 10:33:48AM +0100, Lars-Peter Clausen wrote:
> >> On 11/19/2012 09:21 AM, Thierry Reding wrote:
> >>> Add support for reading conversion results from the ADC and provide t=
hem
> >>> through a single IIO channel. A proper scaling factor is also exported
> >>> based on the reference voltage provided by a regulator.
> >>>
> >>> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> >>> ---
> >> [...]
> >>> +static int adc081c_read_raw(struct iio_dev *iio,
> >>> +			    struct iio_chan_spec const *channel, int *value,
> >>> +			    int *micro, long mask)
> >>> +{
> >>> +	struct adc081c *adc =3D iio_priv(iio);
> >>> +	int err, scale;
> >>> +
> >>> +	switch (mask) {
> >>> +	case IIO_CHAN_INFO_RAW:
> >>> +		err =3D i2c_smbus_read_word_swapped(adc->i2c, REG_CONV_RES);
> >>> +		if (err < 0)
> >>> +			return err;
> >>> +
> >>> +		*value =3D (err >> 4) & 0xff;
> >>> +		return IIO_VAL_INT;
> >>> +
> >>> +	case IIO_CHAN_INFO_SCALE:
> >>> +		err =3D regulator_get_voltage(adc->ref);
> >>> +		if (err < 0)
> >>> +			return err;
> >>> +
> >>> +		scale =3D err / 255;
> >>
> >> Shouldn't this be 256?
> >=20
> > Well, the maximum value that the conversion register can contain is 255,
> > so if we divide by 256 we'll always be slightly off, right? Or maybe I
> > misunderstand what the scale factor is supposed to do. From reading the
> > documentation it seems like user-space is supposed to multiply the raw
> > value by the scale to obtain the real voltage.
>=20
> So usually for ADCs the scale is from 0V to VREF - 1 lsb or VREF - 0.5 LS=
B.
> I just had a look at the adc081c927 datasheet and it looks as if it is no
> exception.
>=20
> >=20
> >>> +
> >>> +		*value =3D scale / 1000000;
> >>> +		*micro =3D scale % 1000000;
> >>
> >> scale for voltages is in microvolt, so I think it this is off by a fac=
tor of
> >> 1000.
> >=20
> > If scale is supposed to be in microvolts, then this is off by a factor
> > of 1000000 since regulator_get_voltage() returns the voltage in
> > microvolts as well.
>=20
> sorry, I meant millivolts, too early in the morning ;)

Okay, so both of your arguments indicate that I should indeed go for
what you proposed below.

> >> For ADCs it often makes sense to use IIO_VAL_FRACTIONAL_LOG2 with the =
val
> >> being set to the reference voltage (in mV) and val2 being set to the n=
umber
> >> of bits.
> >>
> >> E.g in your case
> >>
> >> 		*val =3D err / 1000;
> >> 		*val2 =3D 8;

I'll update the patch, thanks for reviewing.

Thierry

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQqgiHAAoJEN0jrNd/PrOhI2YP/ip7SeO/A3DOPvetaAdZjpkE
jaJhRCPOZMscfXomrfVtIdpLcF6rJQJLyMZOu4lc78KISn/8NXbGha7QhdfXMkDc
zdSkoMWXBsfN6bMfpO4N48CY8yz8+Oq3uAA+u5MSGpbk/c/GMr4eYh7VnDcqCrlD
d80e9Kqqj6nj4tcsPAmH92Z677M8ZOlkR+lqOFUxi7CdnfvwY/Z1s3XPYXpL4FUx
EzqQss27zxi8CZqvRJJljhoTp3lki0gPXuxxfpLYTgQDeHsThKbncfuIsldD52jp
9dAVPbVAYo97K+Gwwozww7mZxUdJtdy4XRn41EmOB/xI66eBSS4jZYP7aadJYMmH
CKv6RKSZyCrJ0gXF7I8VCl57EgK/rlKbVZkOmbp9sIwDOu7YcJ4wUqSekW5+u1J3
DkuPKsaxd8fdzDbTR0HIQ7C2qgw/uDqE+rE68mimWRgyYWvWKGVWpQkvDD4KSYnc
CIEVsdYMW9WoG1uEQQifGIX5n2WyvBaVYgjHbaeNP/Km6ib2EGT85TQoM8/s3wP/
r+tEcquhTwp4aHDzVgaegFNEZvjmJRpiASQ0cdBBWuU/ROr1yAtsh9neSR73H+k+
Z7HHFNYnvJ8d1Ny1RMK5WF8gre9B09YnduGYQUDMvO+o2oiZrvCoP9x3GOdr+2L4
khMOEZkqBJDuW5vJfysO
=Tab+
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
