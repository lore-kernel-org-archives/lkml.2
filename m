Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab2KSJvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 04:51:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50687 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab2KSJvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 04:51:08 -0500
Date: Mon, 19 Nov 2012 10:50:57 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: adc: Add Texas Instruments ADC081C021/027 support
Message-ID: <20121119095053.GA3951@avionic-0098.mockup.avionic-design.de>
References: <1353313289-983-1-git-send-email-thierry.reding@avionic-design.de>
 <50A9FCFC.60002@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <50A9FCFC.60002@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:na0Kon5IJx6/uVQmwCKKt8kidTb+nWFfkvhPDIiOvbd
 CdjVrgLCN0BkNhGrEjr3hwnX6bNcRLlKPx6s1HRub8yLjx+mKb
 gMEfiqwZQEDccMsW0Efwep5hLV/GuZDnyX8JdU5i6VdlA4HYc4
 1dpR14tdmpmi9xi5CR0SKKTpBa9a+PdGfWLWTxFw/JtFEhla+u
 A0CW9y485m6/7DemFi6LNtU4AIAbVy0EkWJZT68ZqUPx69085R
 TkUlPCL4FF3NQfhy0/8HTiZ2O3NhrnXpcJW8xXG9QVR/lWcV5S
 p+bh7+m9YOtTgdUow94yWWYrxDr8iNzjk/fpMnZjI35r2HONXz
 grOw8J/e4AaW7rPBYtpn1ujkL7OpoaxZLDijvMkKZarRzllaHG
 19K9tiWwgthdTYr1sHzuMs1j+1Fl5+uVtOCNpEw/iaV0LslbAj
 zHBjK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 19, 2012 at 10:33:48AM +0100, Lars-Peter Clausen wrote:
> On 11/19/2012 09:21 AM, Thierry Reding wrote:
> > Add support for reading conversion results from the ADC and provide them
> > through a single IIO channel. A proper scaling factor is also exported
> > based on the reference voltage provided by a regulator.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
> [...]
> > +static int adc081c_read_raw(struct iio_dev *iio,
> > +			    struct iio_chan_spec const *channel, int *value,
> > +			    int *micro, long mask)
> > +{
> > +	struct adc081c *adc =3D iio_priv(iio);
> > +	int err, scale;
> > +
> > +	switch (mask) {
> > +	case IIO_CHAN_INFO_RAW:
> > +		err =3D i2c_smbus_read_word_swapped(adc->i2c, REG_CONV_RES);
> > +		if (err < 0)
> > +			return err;
> > +
> > +		*value =3D (err >> 4) & 0xff;
> > +		return IIO_VAL_INT;
> > +
> > +	case IIO_CHAN_INFO_SCALE:
> > +		err =3D regulator_get_voltage(adc->ref);
> > +		if (err < 0)
> > +			return err;
> > +
> > +		scale =3D err / 255;
>=20
> Shouldn't this be 256?

Well, the maximum value that the conversion register can contain is 255,
so if we divide by 256 we'll always be slightly off, right? Or maybe I
misunderstand what the scale factor is supposed to do. From reading the
documentation it seems like user-space is supposed to multiply the raw
value by the scale to obtain the real voltage.

> > +
> > +		*value =3D scale / 1000000;
> > +		*micro =3D scale % 1000000;
>=20
> scale for voltages is in microvolt, so I think it this is off by a factor=
 of
> 1000.

If scale is supposed to be in microvolts, then this is off by a factor
of 1000000 since regulator_get_voltage() returns the voltage in
microvolts as well.

> For ADCs it often makes sense to use IIO_VAL_FRACTIONAL_LOG2 with the val
> being set to the reference voltage (in mV) and val2 being set to the numb=
er
> of bits.
>=20
> E.g in your case
>=20
> 		*val =3D err / 1000;
> 		*val2 =3D 8;

I'm confused, IIO_VAL_FRACTIONAL_LOG2 is supposed to return mV, but
IIO_VAL_INT_PLUS_MICRO will return uV?

And setting val2 to 8 will cause the scaling factor to be 256, and not
255, so the converted value will actually be off (as I mentioned above).

> > +
> > +		return IIO_VAL_INT_PLUS_MICRO;
[...]
> > +	adc->channel.type =3D IIO_VOLTAGE;
> > +	adc->channel.info_mask =3D IIO_CHAN_INFO_SCALE_SHARED_BIT |
> > +				 IIO_CHAN_INFO_RAW_SEPARATE_BIT;
>=20
> nitpick: Since it is the same for each driver I'd make the channel static=
 const.

Okay, that makes sense.

Thierry

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQqgD9AAoJEN0jrNd/PrOhu88P/1AhUElPuroqbvwjWSriitg7
fLTkFNMptS8MHISJTQWTR7fccjyQZ+SHLilRlFMIXklvdSIML9hg/vDV5y19Wsyj
Xk+sd5JM7309kcSxfQ96n3wEvw8tVl7p32Tuj9IKW6jJ36XiS/ZCr4d9COXIJ4O1
/+Mj0iAobaixpxCpa5UxDrkVa9nXcDh2jX/zuVrairK44MAMB9d+q0y4AXos/lMk
PamkMLlrFwLokD5/LW6YIiV0S8mTw9o2m6P+j7NuJHiYLPm0J8uMCyEMxXM/HW6Y
s8gY7p8lKlJ3LQ8//8X8GUpHCkAZp1IM5aKapkwG7BwAWo6vGba5S3gr2UJaPsaa
q9mQfh/Qwu5U3n0HRbuZKPZOX8TyQmqNZbaVs+X0z9DGqZB2Btf0NZPVRAYYV3UW
3yCPe/DDtqnQahdOL0wy1tIZhl/LlyMNi3Zul7NbFxhWM4/+uIrtfZfzmO4hymAt
U2KAJM8pAbUCvDGgINKIgnzEo3FKCBRDeuUtVyNeW6fxgLzRdwQgYHob/5dUXd38
2CBpiDsGU/9uW9OQmhktPF73C5aQ3L6RUW/xLEExhFkYNl5z/8tLLTk+8CornyJD
yVP2eh/pgGR8x57OhIO3m6yEmsK7jEaDVpVhHtBntq/jbtRuvdmmXo8ukqYawOPK
+ABmD8t9xziyGr80y+hP
=SrHS
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
