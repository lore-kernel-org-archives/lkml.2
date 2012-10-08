Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab2JHNkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 09:40:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56239 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab2JHNkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:40:08 -0400
Date: Mon, 8 Oct 2012 15:39:51 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: [PATCH 1/2] pwm: pwm-tiecap: Add device-tree binding support for
 APWM driver
Message-ID: <20121008133951.GA26525@avionic-0098.mockup.avionic-design.de>
References: <1348658863-29428-1-git-send-email-avinashphilip@ti.com>
 <1348658863-29428-2-git-send-email-avinashphilip@ti.com>
 <20121002060014.GA4298@avionic-0098.mockup.avionic-design.de>
 <518397C60809E147AF5323E0420B992E3E9CA1E8@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <518397C60809E147AF5323E0420B992E3E9CA1E8@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:POzTXT8UWjukApgTJd86JDFeiD5bMlAcOE6pOKc6PSl
 AjqIwjjqFtjcnHVPQzUfab5FsLVMRNG3bNG/lofh3xQGsy95p3
 8ePKxDyGUBcieceHmSKJhUhgVeW/uajDbB+s8AjnBafoH1qTuh
 /Y6aSJvRWc4d4epwFN37sAGquURn3f3YJcHGgBXqwllhasfX8F
 YiUisJlZFGk7xwcx/Kw8NA5RQMoTFzZbJOkKZO+DXjZNhmVxL5
 GzUNdLP5PmQS4teZK9vp8buMIl7qAdBBzS/t1dlcDqdBmLxNlm
 ZovDVCcz+/mNC2ZJMLCXDMoPRo8GVCK0f5bhvv02VVzXBSlGvq
 hhn+IaOguDHU7GyWl0gm52cA3UkWJ7ja2J1AauPKUA1Y6iUTZa
 GdedgC7nkQb+oEni9vi//7f96hES2b4trIKj3nnIg7CNP/Xtkf
 99C+L
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 08, 2012 at 01:31:19PM +0000, Philip, Avinash wrote:
> On Tue, Oct 02, 2012 at 11:30:14, Thierry Reding wrote:
> > On Wed, Sep 26, 2012 at 04:57:42PM +0530, Philip, Avinash wrote:
[...]
> > > @@ -231,13 +290,56 @@ static int __devinit ecap_pwm_probe(struct plat=
form_device *pdev)
> > >  	}
> > > =20
> > >  	pm_runtime_enable(&pdev->dev);
> > > +
> > > +	/*
> > > +	 * Some platform has extra PWM-subsystem common config space
> > > +	 * and requires special handling of clock gating.
> > > +	 */
> > > +	if (pdata && pdata->has_configspace) {
> > > +		r =3D platform_get_resource(pdev, IORESOURCE_MEM, 1);
> > > +		if (!r) {
> > > +			dev_err(&pdev->dev, "no memory resource defined\n");
> > > +			ret =3D -ENODEV;
> > > +			goto err_disable_clock;
> > > +		}
> > > +
> > > +		pc->config_base =3D devm_ioremap(&pdev->dev, r->start,
> > > +				resource_size(r));
> > > +		if (!pc->config_base) {
> > > +			dev_err(&pdev->dev, "failed to ioremap() registers\n");
> > > +			ret =3D -EADDRNOTAVAIL;
> > > +			goto err_disable_clock;
> > > +		}
> >=20
> > Isn't this missing a request_mem_region()? I assume you don't do that
> > here because you need the same region in the EHRPWM driver, right?
>=20
> request_mem_region() is avoided as this region is shared across PWM
> sub modules ECAP & EHRPWM.=20
>=20
> > This should be indication enough that the design is not right here.
> > I think we need a proper abstraction here. Can this not be done via
> > PM runtime support? If not, maybe this should be represented by
> > clock objects since the bit obviously enables a clock.
>=20
> It is not done as part of PM runtime as this is has nothing to
> do with clock tree of the SOC. The bits we were enabling here
> should consider as an enable of the individual sub module as
> part of IP integration. Hence we were handling these subsystem
> module enable in the driver itself.

My point remains valid: you shouldn't be able to access the same
register through two different drivers. That's one of the reasons, if
not the only reasen, why the request_mem_region() function exists. I
think you should add some abstraction to provide this functionality to
the drivers. I assume that eventually there will be more than just the
PWM cores that require access to this register.

Thierry

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQctenAAoJEN0jrNd/PrOhKY8P/3BV7jiQkYygJF7zxvcLJxBw
Jjn7isR3gLr3nN/6qN1Lw4cllDuN6TzzVFEzan3yJ6ZApIL7vPDKyP7o2xZHl7Br
zJ9y6KOcnE8gStHRjb/G7yYMH+bdMZW0qfAfAnY/CZvR3uiJBtXfu0lxpgvfYrq7
8wh9bK93MCXYs+uoZQnMWc8iT8QeVWNbv9UuVbPPZkTV7VrLy71s5JmF3Qkr2hJe
FIlph2P319lRv2Ql7pmGOi2Vg/bzjxUuT+5ZcAP+thGmh3hwM4aeM3dlwPChBuJR
OblsDXSS3pzGrDZghDPpe3Q4YMiCgC6YPYwqoqLXWTg2mvfpq9aUVX5rlQGU1u/+
3doC2gaP90CORQHT5oTJQVrMfjzNNmkHFC/tTi8tbpGeXkMVSDYE9ZquJslOaKpV
L5LW4M2ZuGg7UgIcDW/thCvvW8F0zHz6oJ8E8xINWioZHCHMEyzwU1f+K99N3vnW
ais/G534U9bXbantgSDQbJPByBWIixGjenJxPAl5AAFoo0i3IqrCmPO2drVBAPPW
xoPh4/oYsAcaIwrJqhPRLq4jUAkG7OCY4KcCeGTcDtY6wNkhPqCDcT4jFPT7jnC3
9t+yn3sgzVHo/HBrETPkL1jAjWIn0YDNuqPld4ADOsSkf+kHF/W62lMUcXSA0WO3
NfobIyCwnrAtG53bewB/
=gaFy
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
