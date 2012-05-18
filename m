Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761576Ab2ERCrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:47:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39788 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab2ERCrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:47:10 -0400
Date: Fri, 18 May 2012 12:46:51 +1000
From: NeilBrown <neilb@suse.de>
To: Andi Shyti <andi.shyti@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH 3/4] power_supply/MFD: twl4030_charger: Allow charger to
 control the regulator that feeds it.
Message-ID: <20120518124651.39af8eeb@notabene.brown>
In-Reply-To: <20120513181208.GA2641@andi>
References: <20120508213518.2844.95446.stgit@notabene.brown>
	<20120508214040.2844.5662.stgit@notabene.brown>
	<20120513181208.GA2641@andi>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AANF5Su85=o39a8+tcU+HR9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/AANF5Su85=o39a8+tcU+HR9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 13 May 2012 20:12:08 +0200 Andi Shyti <andi.shyti@gmail.com> wrote:

> Hi Neil,
>=20
> On Wed, May 09, 2012 at 07:40:40AM +1000, NeilBrown wrote:
> > @@ -183,6 +186,12 @@ static int twl4030_charger_enable_usb(struct twl40=
30_bci *bci, bool enable)
> >  			return -EACCES;
> >  		}
> > =20
> > +		/* Need to keep regulator on */
> > +		if (!bci->usb_enabled) {
> > +			regulator_enable(bci->usb_reg);
>=20
> Should you consider here a failure case?

Probably.  Something like this?

+		/* Need to keep regulator on */
+		if (!bci->usb_enabled &&
+		    bci->usb_reg &&
+		    regulator_enable(bci->usb_reg) =3D=3D 0)
+			bci->usb_enabled =3D 1;
+

>=20
> > +			bci->usb_enabled =3D 1;
> > +		}
> > +
> >  		/* forcing the field BCIAUTOUSB (BOOT_BCI[1]) to 1 */
> >  		ret =3D twl4030_clear_set_boot_bci(0, TWL4030_BCIAUTOUSB);
> >  		if (ret < 0)
> > @@ -511,6 +524,8 @@ static int __init twl4030_bci_probe(struct platform=
_device *pdev)
> >  	bci->usb.num_properties =3D ARRAY_SIZE(twl4030_charger_props);
> >  	bci->usb.get_property =3D twl4030_bci_get_property;
> > =20
> > +	bci->usb_reg =3D regulator_get(bci->dev, "bci3v1");
>=20
> ... and here.

In what circumstances can that fail, I wonder.
Still, maybe this is best:


+	bci->usb_reg =3D regulator_get(bci->dev, "bci3v1");
+	if (IS_ERR(bci->usb_reg)) {
+		dev_warn(&bci->dev, "regulator get bci3v1 failed\n");
+		bci->usb_reg =3D NULL;
+	}
+

Thanks,
NeilBrown

--Sig_/AANF5Su85=o39a8+tcU+HR9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7W4Gznsnt1WYoG5AQIwzg/7BDG78G7JjjkH9grSoJ1dfD6Op+jfpvmU
+y29/5sRUuAyN9TcSKlnY3HDPcrCETz3MIwGXXMWw1wBdvCzPb4IuIZ6OsaDiJbd
findFVB+T4UzQZJXP7udVudol+17u1U3NpxIcvgLklPKHaI6Af6gNcNoss2YFy24
D83bWn1487wjaOMGVu/ZCNLZKFSQMr+s9Scqw5x+5BJaQo6huAlJNBepzVk76R8Z
5/6rAGN5FXVoK0Xgkor0rQipG9R9813K7M02/+FesOWV2M1oR0KqygwEXFOlT0X/
xDRJiYAsju5KTwRKAM9JSI1j/ABr1y6PdHQ/3JwqAWWnIiF8PUnVldBMawUn3Ps/
GHNnkdyKx4az5dQ9Xv1ge1qjrVANvTC2GQm4UGEJbi8FP2Kc8zU0eAI0pRrzdtBf
JB9+1+FK54V2225PqMMmtSeNp1UlmCVFa0VJfCZ37rNlYzhwTfPqbTWg2gIoEmwD
w5zLJa9ez2BB/8rxQ19lqENXp88WaAu69kwANNXDBKJ1jgh+j6+sFm432o0xHSy+
ZjYO6ChMud7Jhn1i6lB56PY1UJg+GYnNxzfuQl6iFlV38dBl8nvznQK3cpmH2KAX
BX+/DjAOJflSMm9ACaZupnq/hkVP8qEzpUjYQW9FiiHRbIUPbb7SP4AnF5wSBe4b
LPw63qqsrJ8=
=K48o
-----END PGP SIGNATURE-----

--Sig_/AANF5Su85=o39a8+tcU+HR9--
