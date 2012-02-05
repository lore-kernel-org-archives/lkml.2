Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab2BEJIY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 04:08:24 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:33221 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751766Ab2BEJIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 04:08:13 -0500
Date: Sun, 5 Feb 2012 11:08:06 +0200
From: Felipe Balbi <balbi@ti.com>
To: "Varadarajan, Charulatha" <charu@ti.com>
Cc: balbi@ti.com, Kevin Hilman <khilman@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>, linux-omap@vger.kernel.org,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v9 01/25] gpio/omap: remove dependency on gpio_bank_count
Message-ID: <20120205090805.GA13300@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20120202191630.GT15343@ponder.secretlab.ca>
 <20120202194545.GA29351@legolas.emea.dhcp.ti.com>
 <4F2AF68D.1000505@ti.com>
 <20120202214907.GA22888@legolas.emea.dhcp.ti.com>
 <20120202215350.GB22888@legolas.emea.dhcp.ti.com>
 <4F2B078B.1040709@ti.com>
 <20120202220744.GA23092@legolas.emea.dhcp.ti.com>
 <87liojajs4.fsf@ti.com>
 <20120204160802.GA10818@legolas.emea.dhcp.ti.com>
 <CA+HSevqvHAgA+PPLm8BH5vfWkc8yY8W+fRpqjT2urq2EWtSYiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <CA+HSevqvHAgA+PPLm8BH5vfWkc8yY8W+fRpqjT2urq2EWtSYiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Feb 05, 2012 at 12:37:55PM +0530, Varadarajan, Charulatha wrote:
> Felipe,
>=20
> On Sat, Feb 4, 2012 at 21:38, Felipe Balbi <balbi@ti.com> wrote:
> >
> > Hi,
> >
> > On Fri, Feb 03, 2012 at 09:50:19AM -0800, Kevin Hilman wrote:
> > > Felipe Balbi <balbi@ti.com> writes:
> > >
> > > [...]
> > >
> > > >> >This question remains. Why do we need those funtions ?
> > > >>
> > > >> These functions are called from the CPUIdle path so outside the sc=
ope
> > > >> of the GPIO driver. These are part of a bunch of nasty PM hacks we
> > > >> are doing in the CPU idle loop. We are in the process of getting r=
id
> > > >> of most of them, but it looks like some are still needed.
> > > >
> > > > Too bad. I can see that the gpio pm implementation seems a bit
> > > > "peculiar". I mean, pm does reference counting and yet the driver h=
as
> > > > checks to prevent multiple gets and puts on a single bank (meaning =
that
> > > > pm counter will be either 0 or 1 at any point in time).
> > > >
> > > > To me it looks like those functions are there in order to forcefull=
y put
> > > > PER power domain in OFF because drivers are always holding a refere=
nce
> > > > to their gpios (drivers generally gpio_request() on probe() and
> > > > gpio_free() on remove()).
> > > >
> > > > Looks like the entire pm implementation on OMAP gpio driver has alw=
ays
> > > > considered only the fact that gpios can be requested and freed, but
> > > > never that we want the system to go to OFF even while gpios are
> > > > requested, because we have I/O PAD wakeups. At some point that has =
to be
> > > > sorted out because that HACK is quite ugly :-)
> > > >
> > > > I'll see if I find some time to go over the interactions between
> > > > gpio-omap.c and pm24x.c and pm34xx.c any of these days, but I can't
> > > > promise anything ;-)
> > >
> > > If you look at the state of these prepare/resume hacks at the end of
> > > this series, you'll see that they are significantly cleaner and do
> > > nothing but call the runtime PM hooks.
> >
> > sure, definitely.
> >
> > > We have explored several ways to get rid of them completely in the id=
le
> > > path but have not yet come up with a clean way, but this series gets =
us
> > > a long ways towards that goal.
> >
> > have you thought about being a bit more aggressive at when to
> > runtime_get and runtime_put ?
> >
> > I didn't test below (will do probably on monday), but I think this will
> > help keeping GPIO block always suspended, and only wake it up when truly
> > needed. That way, you could, at some point, remove that list_head
> > because by the time you reach CPUIdle path, GPIO module is already
> > suspended. That's the theory at least, gotta run it first on silicon to
> > be sure
> >
> > diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> > index 4273401..2dd9ced 100644
> > --- a/drivers/gpio/gpio-omap.c
> > +++ b/drivers/gpio/gpio-omap.c
> > @@ -537,12 +537,7 @@ static int omap_gpio_request(struct gpio_chip *chi=
p, unsigned offset)
> > =A0 =A0 =A0 =A0struct gpio_bank *bank =3D container_of(chip, struct gpi=
o_bank, chip);
> > =A0 =A0 =A0 =A0unsigned long flags;
> >
> > - =A0 =A0 =A0 /*
> > - =A0 =A0 =A0 =A0* If this is the first gpio_request for the bank,
> > - =A0 =A0 =A0 =A0* enable the bank module.
> > - =A0 =A0 =A0 =A0*/
> > - =A0 =A0 =A0 if (!bank->mod_usage)
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pm_runtime_get_sync(bank->dev);
> > + =A0 =A0 =A0 pm_runtime_get_sync(bank->dev);
>=20
> bank->mod_usage check is used to take care of doing pm_runtime_get*/put* =
only
> if all the GPIOs in a particular bank are enabled or disabled respectivel=
y.

and why should you care about that ? The first get will enable the
resources you need, the second get will just increase a counter and so
on. So if you have 32 gets, you will disable the module when you have 32
puts.

> With the above change, pm_runtime_put*/get* would be called for every
> gpio_request()
> /_free() (that is, for upto 32 pins in OMAP3/4) in a bank irrespective
> of whether other

so ?

> GPIO pins are enabled or disabled in the same bank. Hence it is
> required to have a
> check based on mod_usage.

unnecessary.

--=20
balbi

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPLkb1AAoJEIaOsuA1yqREE5MP/A1N2SL+SWj0o+0C4NNnwu/m
iPbS7+V8mCBOmh1nD7WVusPnFceQKnePG+SY9+lzb2iQC+qXeeSN08Z+QjszpHZx
9G0dlDFQp5eA3IzlfNE1945pmxZZow5LP2Im9KuWAMn3S73LCXvht/LMno+2OioU
HM/Akb043I6Yk425xKjVndJN4jwAz60VzblsDSblZjYMNAosKDCzWbg+vvuUq/VH
1Bw5VniF60GsE7r2LHD6rfPyR04DWEyOCPeScy7dIiNjicBbbIJjiWaFNshSTDaN
O8LelfwC4+DAViZ2KjhxzrlOdcD/KVlIg42LhPz6yH1ic15pZc5meRkGks1l+cZt
TsLzcC37CvypSDor8Du5xJEc+8C4md5CfGab+i1WnmfVYaIQsu5aO4tALPodKSVs
bN5drhz3l2TlzLgRF6XVNr3p5muaxEm+Qka72KcPovWNjjibHbumx3B2UvonhIqW
oTTrUUz06DBmn64W3eRujJb0Ainv9A0hjltTVKDHRGeBCE8C4Pe5EctkeBFGk6UR
KHabRQdAheugWYskIwp6pLLdeq46iklu+qSotZ5MNkVrdPHf7ngKE9Iy5UdxA6dg
sCankAKJkW//PSZigI5M8JcR5QivXRjRiiOGhhqfVr0caWb8Klpbx529X63IkgCE
W462X4A4WRDet8ln3Hfv
=O1vm
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
