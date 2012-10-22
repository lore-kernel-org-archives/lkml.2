Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750921Ab2JVHLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 03:11:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56085 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2JVHLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 03:11:31 -0400
Date: Mon, 22 Oct 2012 09:11:18 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/3] PWM: vt8500: Update vt8500 PWM driver support
Message-ID: <20121022071118.GA30026@avionic-0098.mockup.avionic-design.de>
References: <1350643135-13197-1-git-send-email-linux@prisktech.co.nz>
 <1350643135-13197-2-git-send-email-linux@prisktech.co.nz>
 <20121022063423.GA17181@avionic-0098.mockup.avionic-design.de>
 <1350888712.3592.11.camel@gitbox>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <1350888712.3592.11.camel@gitbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:aLyKiKmxdivnPGr+9aC4bqZSSS2AmKVtled8E1745RU
 iQkxB3sF39qEJEZyqIRIjxR5Z90+9VftBPhqc9KuVYPGR4iyRi
 34qm+ji0Y5WqMu1LlBcR0PX30HIrwBXhFKGp/aGK04dAHRiowC
 BJKWx5bpOGDdVaeikjTaQ+o2BeRLyp4MjQwenuVNR/Oo5CsWtf
 BrK5/ujbtuHPxKX/qU4Imn9b9MyqIAh/P6eZZ7fTdQy/2E9tzC
 jZ7RfZF9CM89yWfwrpZtI+WiZcbHCz4ZJX5vfZdmITrLyM4xvj
 6IuMNMutW8jEe7Z2eXBt0ZeEdpRjR9e/UXDg7iLHBaVDQvdEcB
 U4rZhYR1CUAWGVMeg4J06I272Ql4+rHeQ/qeapPhQvTXGpao6O
 Chp1MNTOfomRGlJ35LhFbvQ17peFUyTwa/EhJgUrqmOBegL6DE
 qDkqJ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 22, 2012 at 07:51:52PM +1300, Tony Prisk wrote:
> Replies to your comments inline:
>=20
> On Mon, 2012-10-22 at 08:34 +0200, Thierry Reding wrote:
> ...
> > > -static int __devinit pwm_probe(struct platform_device *pdev)
> > > +static const struct of_device_id vt8500_pwm_dt_ids[] =3D {
> > > +	{ .compatible =3D "via,vt8500-pwm", },
> > > +	{ /* Sentinel */ }
> > > +};
> > > +
> > > +static int __devinit vt8500_pwm_probe(struct platform_device *pdev)
> >=20
> > Since you're changing this line anyway, maybe you should drop __devinit
> > (and __devexit for the .remove() callback). HOTPLUG is always enabled
> > nowadays and will go away eventually, in which case these will need to
> > be removed anyway.
>=20
> Will do. I must say the inconstancy among comments is rather
> frustrating. In another patch I sent out a few days ago (completely
> unrelated to this), I told to add __devexit to a remove() function :\

This is a rather recent development, so maybe not everyone knows about
it yet. You can look at the following commit for the details:

	45f035ab9b8f45aaf1eb2213218b7e9c14af3fc2

It's been in linux-next for about 6 weeks and has also gone into
3.7-rc1.

> > >  {
> > >  	struct vt8500_chip *chip;
> > > -	struct resource *r;
> > > +	struct device_node *np =3D pdev->dev.of_node;
> > >  	int ret;
> > > =20
> > > +	if (!np) {
> > > +		dev_err(&pdev->dev, "invalid devicetree node\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> >=20
> > This effectively makes DT support mandatory. Shouldn't you be adding a
> > "depends on OF" into the Kconfig section in that case?
> This driver depends on ARCH_VT8500, which only supports DT so a
> dependency on OF seemed redundant. If you think its still necessary, let
> me know and I'll add it anyway.

Okay, in that case you don't need another dependency. I've recently seen
comments about the check for !np being unnecessary because it can't be
NULL if you depend on OF. I suppose there's some truth in it but to be
honest I haven't made up my mind about it yet.

> > >  	chip =3D devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
> > >  	if (chip =3D=3D NULL) {
> > >  		dev_err(&pdev->dev, "failed to allocate memory\n");
> > > @@ -123,26 +144,32 @@ static int __devinit pwm_probe(struct platform_=
device *pdev)
> > >  	chip->chip.ops =3D &vt8500_pwm_ops;
> > >  	chip->chip.base =3D -1;
> > >  	chip->chip.npwm =3D VT8500_NR_PWMS;
> > > +	chip->clk =3D of_clk_get(np, 0);
> >=20
> > I thought this was supposed to work transparently across OF and !OF
> > configurations by using just clk_get() or devm_clk_get()? I guess that
> > if the driver depends on OF, then this would be moot, but we should
> > probably stick to the standard usage anyway.
> >=20
> > Furthermore, of_clk_get() doesn't seem to be managed, so you'd need to
> > add explicit clk_put() in the error cleanup paths. One more argument in
> > favour of using devm_clk_get() instead.
>=20
> Hmm good point. I stuck with of_ functions because its an OF only driver
> and it seemed 'backward' to mix old code with new. It does pose the
> question of 'why have of_clk_get() if existing functions work better'.

I think wherever possible you should use the generic calls, since they
are (usually) explicitly designed to work with OF and non-OF and you
never know what your driver might end up being used for. Then again, if
the driver is VT8500 specific and VT8500 doesn't support anything but
device-tree I suppose using the of_*() functions would be okay. Maybe
adding devm_of_clk_get() would be a worthwhile addition.

You should also consider that other people may look at your driver as a
reference and may end up using the OF-only variants even if their driver
is used in non-DT setups. I'm not sure how valid that argument is,
though, since code review is supposed to catch those mistakes.

[...]
> > > -MODULE_LICENSE("GPL");
> > > +MODULE_DESCRIPTION("VT8500 PWM Driver");
> > > +MODULE_AUTHOR("Tony Prisk <linux@prisktech.co.nz>");
> > > +MODULE_LICENSE("GPL v2");
> >=20
> > IANAL, but I think you need the approval of all authors of this code
> > before changing the license. But I see that the file header actually
> > says that this code is GPL v2, so maybe this change could be considered
> > a bugfix. =3D)
>=20
> This is something I've already discussed with Alexey in regards to all
> the existing drivers he has in mainline. Since I have taken over as
> maintainer on this platform I have corrected the licenses as patch's
> have gone through. As you pointed out, it was already GPLv2 in the
> header, this is just a 'bugfix'.

Okay, works for me.

Thierry

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhPGWAAoJEN0jrNd/PrOhqOkP/2CRTf5rsXXvmeSxs/ftSXk5
AjFbpVy1EmV03WcvkzrJdfkOyTIZEH7THZ1aAi7jkqTyXp3it7M3Wuu9wymM49xZ
FauGdstY9nnibWWwktwdyuFRB4oDCWrs/Ld0VKg50v0rRew/k2kOPHGoKkO8PAcx
LGV7qpLF1CC2W8FJG52SmB/zgSu7HNs4xHqWn9V4EMogWSTiHAMSjP4Hpw7D5MBE
I1b3t+FPi0aHQKaIiUvB2zBj7WKYqtrDWJ54XfsOA+55Fn1PPtKFja/Irnfpi0QE
x1dkJQcefmCwIUcWRxn0/gfH1wEcWDmc+JgP1oBCgiYtwcQA2K05Fzacmxd4yr1Z
x9mLkmuo3fJxEr0fN+mRifshGaEfot9JMyeLGucOVIpiEsHpUpTdUodx2iHZ/1Zf
VHx91s1cwULqdxazWDvP6OrWt5jQclrbKFBjJ2HjsHV0pP7E0ATWhVlpOKBtk58J
MMe5uLN4La9aSPMTtcGtey3RfpPBcCO6uNT2A4obqKCFOSlp575vAESdIEL6eNEO
o0jkqeZwvhUIlaObgGJ6JvA9aef3IE6pOf8pSAXB0Nbyd+MnsZ2dWBpFEGt/HdFm
x/ZI7GZqX4DDs95OhSaglqwyS1wqiFsWeA56MhMHKuzQYzSHvT3V0MmiLX+npSEz
s98eDtd0C9b8GcO83G7B
=ysfJ
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
