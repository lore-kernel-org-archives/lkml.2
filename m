Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2LMHfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 02:35:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49197 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2LMHfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 02:35:16 -0500
Date: Thu, 13 Dec 2012 08:34:29 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: NeilBrown <neilb@suse.de>
Cc: Grant Erickson <marathon96@gmail.com>, linux-omap@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAP: add pwm driver using dmtimers.
Message-ID: <20121213073429.GC9946@avionic-0098.adnet.avionic-design.de>
References: <20121212192430.50cea126@notabene.brown>
 <20121212113145.GA23598@avionic-0098.adnet.avionic-design.de>
 <20121213133828.55e50220@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xo44VMWPx7vlQ2+2"
Content-Disposition: inline
In-Reply-To: <20121213133828.55e50220@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:gfsM8DBxGVpcGmuSsovfzIZpVmFYQeoAgvT63Awsu+5
 hbnhUmJnWkVLpmkXJxTMyXYvIpoXDW6xm2zaHKP5/3vaiylViz
 rfvvDAGGDsF5+cZTVX4XWXMy6SLJCTi3aYcnLqsr2uIRPJOS4z
 8DvcIWkG0AGIyxCt06F4rOrsOgX/Hoo7vgtdfFBfqfxQSoKmlh
 tFjLV8hwfTeqlpiDXxNxj4VqVHOn43ApB0CnRpO0v2cFPGuX8r
 A5Rah2tmgAYXXdn0bj17ENiVpi0ac1DcdLjXD483dctgazcmBP
 mAdcAPH926Ft/4AsdElBErwgSEH0tfFF/tJ3YeQojYCzTcr2VN
 Yjx4JiPciIiahTg7PXMm/Pg4Mz9XKkqb26zpQ7OXFhwHvkB1+s
 gGvzfrB762t9DrUuDt+xpdjh8oYKFwPVTo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xo44VMWPx7vlQ2+2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 13, 2012 at 01:38:28PM +1100, NeilBrown wrote:
> On Wed, 12 Dec 2012 12:31:45 +0100 Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
>=20
> > On Wed, Dec 12, 2012 at 07:24:30PM +1100, NeilBrown wrote:
[...]
> > > +	struct omap_dm_timer	*dm_timer;
> > > +	unsigned int		polarity;
> >=20
> > The PWM subsystem already has enum pwm_polarity for this.
> >=20
>=20
> I'll use that then .... and as there  is a pwm_set_polarity() interface, =
that
> probably means that I don't need to configure the polarity via the platfo=
rm
> data?  That would be a lot cleaner.

I guess the answer to that question is: it depends. If the user can set
the polarity (via platform or other means), then yes, you don't have to
pass it in here. However there may be users that don't support setting
the polarity or there may even be situations where the PWM goes through
an additional inverter on the board and therefore doesn't need the
polarity inversed after all, even if the user driver requests it.

Generally though I think that it is up to the user drivers to take care
of this and call pwm_set_polarity() as appropriate, so yes, I don't
think you have to explicitly pass it via platform data at all.

> > > +	if (omap->duty_ns =3D=3D duty_ns &&
> > > +	    omap->period_ns =3D=3D period_ns)
> > > +		/* No change - don't cause any transients */
> > > +		return 0;
> >=20
> > Note to self: this might be a candidate to put in the core.
>=20
> might be useful, though the core doesn't currently "know" the current val=
ues.

Yes, but that can be changed. PWM is still a very young subsystem and
I'm trying to be cautious not to add too much cruft to it unless it's
really worth it.

> > > +	omap_dm_timer_set_pwm(omap->dm_timer,
> > > +			      !omap->polarity,
> > > +			      toggle,
> > > +			      trigger);
> >=20
> > This doesn't either. Also you should be explicit about the polarity
> > parameter, since enum pwm_polarity is an enum and therefore negating it
> > isn't very nice (it should work though).
> >=20
> > You could solve this by doing something like:
> >=20
> > 	if (omap->polarity =3D=3D PWM_POLARITY_NORMAL)
> > 		polarity =3D 1;
> > 	else
> > 		polarity =3D 0;
>=20
> (omap->polarity =3D=3D PWM_POLARITY_NORMAL)
>=20
> would have the same effect.

Yes, that should work as well. However I'm not a friend of using such
expressions in a function call. But since you'll probably be reworking
this anyway because of the pwm_set_polarity() comments from above you
might just want to stick the proper value into omap->polarity in your
=2Eset_polarity() implementation and not need the extra negation here.

> > > +static int __devinit omap_pwm_probe(struct platform_device *pdev)
> >=20
> > No more __devinit, please.
>=20
> If you say so (having no idea what it did :-)

This was used to mark functions depending on whether HOTPLUG was enabled
or not. For instance functions marked __devinit could be discarded after
the init stage if HOTPLUG was disabled because it would be guaranteed to
not be called after the init stage. Recently however HOTPLUG was changed
to be always enabled because the gains were very small and most people
would get them wrong anyway.

> > > +#if CONFIG_PM
> > > +static int omap_pwm_suspend(struct platform_device *pdev, pm_message=
_t state)
> > > +{
> > > +	struct omap_chip *omap =3D platform_get_drvdata(pdev);
> > > +	/* No one preserve these values during suspend so reset them
> > > +	 * Otherwise driver leaves PWM unconfigured if same values
> > > +	 * passed to pwm_config
> > > +	 */
> > > +	omap->period_ns =3D 0;
> > > +	omap->duty_ns =3D 0;
> > > +
> > > +	return 0;
> > > +}
> > > +#else
> > > +#define omap_pwm_suspend	NULL
> > > +#endif
> >=20
> > This doesn't look right. You should implement .resume() if you really
> > care, in which case the resume callback would have to reconfigure with
> > the cached values. In that case maybe you should switch to dev_pm_ops
> > and SIMPLE_DEV_PM_OPS() as well.
> >=20
> > If you don't, just resetting these values will not make the PWM work
> > properly after resume either since it will have to be explicitly
> > reconfigured.
>=20
> I just copied that from pwm-samsung.c
>=20
> I think the point is to avoid the "no transients" short-circuit in
> omap_pwm_config if the config is unchanged.
>=20
> The assumption is that pwm_disable() will be called before suspend and
> pwm_config()/pwm_enable() after resume.  So there is no point actually
> configuring anything in .resume() - it makes sense to wait until pwm_conf=
ig()
> is called (if ever).  But we want to make sure that pwm_config actually d=
oes
> something.

Okay, that makes sense. User drivers should actually be better suited to
reset PWM devices to their proper state on resume.

> > > +MODULE_AUTHOR("Grant Erickson <marathon96@gmail.com>");
> > > +MODULE_AUTHOR("NeilBrown <neilb@suse.de>");
> >=20
> > Shouldn't this be "Neil Brown"? I noticed you use the concatenated form
> > in the email address as well, so maybe that's on purpose?
>=20
> Yes, it is on purpose.  With a surname like "Brown", one likes finding wa=
ys
> to be distinctive :-)

Hehe, alright then =3D).

Thierry

--xo44VMWPx7vlQ2+2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQyYUFAAoJEN0jrNd/PrOh5HUQAIYBWl0+EACGvGeRSGjQBQrr
e9g5Uuxh0t8xFZ7oNFVS/sS1TKpQwMtFraMqRfp6Z/Cx17e57w8pZgq4ZmKXx/zB
3gApvn+ZZoqri4cQDLh49yLA7xswXfNZvs5g60eMFSRwx5zyckcazhQcLvlWDuoQ
VDgtXZK9qJSFwEBHBfIOqXoTkAHMUl0euA+Dzyi+yPrXyBc6Wt2tmIDNST8SmCV0
okUhesJapEU6mEHyDyVy2r6ahdzhiyCNBZFz4SX4JLK7PyFkAq9RpA4dKwaLECzJ
2C3IbE1Qde2PTiaw68PWux5zU3L95qT7/zTIr3V5r/8NQQMA6f9OwRMUTHuyDIKq
YrQdJmqM7Njta8KAZC/hN7vf4JwM7VYmfTgAoYmrdz6z6gn+/+BNATLS8NvZ9XFX
PxzoiFwWNs5z3+mbBYr2ST7e/tkovI6O4R6gQeU0aQ0POpychKdXeGK53A3gu0s8
88H0SuNsZngOpri/02vvRxLs3uxA/KLoYkQazjQgz0lA+Akkq8cXIq6hzrqqylAJ
mYk+Vd3QWIzqaFDLkisVbzCcDLQ68hluss6CzfQpeEIWFKVWP46t08efvSl2+dLQ
/1udmJuCOnjbk9Z1jQGJO2T0AwbxOkJrn3zTQ7yrWWUNWd8jAvAwc5ejryzsI57m
k6iQRdHcH99+RhsuOb53
=iRMO
-----END PGP SIGNATURE-----

--xo44VMWPx7vlQ2+2--
