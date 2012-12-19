Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab2LSOdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 09:33:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62304 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab2LSOdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 09:33:03 -0500
Date: Wed, 19 Dec 2012 15:32:58 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Boris BREZILLON <linux-arm@overkiz.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: Re: [PATCH v3] pwm: atmel: add Timer Counter Block PWM driver
Message-ID: <20121219143258.GA7837@avionic-0098.adnet.avionic-design.de>
References: <1355742810-4241-1-git-send-email-linux-arm@overkiz.com>
 <20121219112610.GA22613@avionic-0098.adnet.avionic-design.de>
 <50D1CACC.8090309@overkiz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <50D1CACC.8090309@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:T3S9x78f95lVOIS06WOmxWEReN0aQJELI/tOkzeRzWq
 Ystytxr95nW1Tgy0cDWDGdmDLU4FNqLXS9fMZD1D08pkBEfauD
 cDb41fYiB4wVqsSVDWm/kiiKQK5JIEQSYJLo0yuq42T6QC3u43
 92zl1r+6SBbqskj7FSruNnR/0RUbOhqc+y9Y6ZajI0WyRQM1QK
 trClCAf0049R4ocllCaHC19vlhhr9dWMDx78y6my2CZ/A6I7sU
 ilfjktimS2B+0VYJvG0JXjqptY3K3hCIiLyvLpzjxCuM0Oayfb
 MCIQRJkq3CyiMFFdSCuFGoZ2gt+ryUm0MECt0orYYk2PmLNj5H
 +tPLLHkZWnqNnOouUdK7ZLVCKQ/Wsu8hIxu7QWUNtMN+pLsxTw
 8ACNe9H99Qk1czrWidjCSodpymTO6ZRoEA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 19, 2012 at 03:10:20PM +0100, Boris BREZILLON wrote:
> On 19/12/2012 12:26, Thierry Reding wrote:
> > On Mon, Dec 17, 2012 at 12:13:30PM +0100, Boris BREZILLON wrote:
[...]
> >> +	/* configure new setting */
> >> +	cmr |=3D newcmr;
> >> +	__raw_writel(cmr, regs + ATMEL_TC_REG(group, CMR));
> >=20
> > I wonder why you bother setting newcmr and OR'ing it into cmr. Couldn't
> > you just mask all previous settings in cmr first, then OR the new bits?
>=20
> I did this to keep the locked portion of code as small as possible:
> I prepare the mask to apply to cmr register before getting the lock.
>=20
> But I can do it this way if you prefer:
>=20
> 	spin_lock(&tcbpwmc->lock);
> 	cmr =3D __raw_readl(regs + ATMEL_TC_REG(group, CMR));
>=20
> 	/* flush old setting and set the new one */
> 	if (index =3D=3D 0) {
> 		cmr &=3D ~ATMEL_TC_A_MASK;
> 		if (polarity =3D=3D PWM_POLARITY_INVERSED)
> 			cmr |=3D ATMEL_TC_ASWTRG_CLEAR;
> 		else
> 			cmr |=3D ATMEL_TC_ASWTRG_SET;
> 	} else {
> 		cmr &=3D ~ATMEL_TC_B_MASK;
> 		if (polarity =3D=3D PWM_POLARITY_INVERSED)
> 			cmr |=3D ATMEL_TC_BSWTRG_CLEAR;
> 		else
> 			cmr |=3D ATMEL_TC_BSWTRG_SET;
> 	}
>=20
> 	__raw_writel(cmr, regs + ATMEL_TC_REG(group, CMR));

Yes, that's along the lines of what I had in mind. It was more of a
suggestion because I think the above looks more obvious. But if you
think having a shorter critical section is worth it, then that's fine
too.

> >> +	/*
> >> +	 * If duty is 0 or equal to period there's no need to register
> >> +	 * a specific action on RA/RB and RC compare.
> >> +	 * The output will be configured on software trigger and keep
> >> +	 * this config till next config call.
> >> +	 */
> >> +	if (tcbpwm->duty !=3D tcbpwm->period && tcbpwm->duty > 0) {
> >> +		if (polarity =3D=3D PWM_POLARITY_INVERSED) {
> >> +			if (index =3D=3D 0)
> >> +				newcmr |=3D
> >> +					ATMEL_TC_ACPA_SET | ATMEL_TC_ACPC_CLEAR;
> >> +			else
> >> +				newcmr |=3D
> >> +					ATMEL_TC_BCPB_SET | ATMEL_TC_BCPC_CLEAR;
> >> +		} else {
> >> +			if (index =3D=3D 0)
> >> +				newcmr |=3D
> >> +					ATMEL_TC_ACPA_CLEAR | ATMEL_TC_ACPC_SET;
> >> +			else
> >> +				newcmr |=3D
> >> +					ATMEL_TC_BCPB_CLEAR | ATMEL_TC_BCPC_SET;
> >=20
> > If you can get rid of newcmr and OR directly into cmr instead, these
> > will fit on one line.
>=20
> I'm not sure I understand how you would do this.
> Here is the same function without the newcmr variable:

What I meant to say was: "these will each fit on one line".

> static int atmel_tcb_pwm_enable(struct pwm_chip *chip, struct pwm_device =
*pwm)
> {
> 	struct atmel_tcb_pwm_chip *tcbpwmc =3D to_tcb_chip(chip);
> 	struct atmel_tcb_pwm_device *tcbpwm =3D pwm_get_chip_data(pwm);
> 	struct atmel_tc *tc =3D tcbpwmc->tc;
> 	void __iomem *regs =3D tc->regs;
> 	unsigned group =3D pwm->hwpwm / 2;
> 	unsigned index =3D pwm->hwpwm % 2;
> 	u32 cmr;
> 	enum pwm_polarity polarity =3D tcbpwm->polarity;
>=20
> 	/* If duty is 0 reverse polarity */
> 	if (tcbpwm->duty =3D=3D 0)
> 		polarity =3D !polarity;
>=20
> 	spin_lock(&tcbpwmc->lock);
> 	cmr =3D __raw_readl(regs + ATMEL_TC_REG(group, CMR));
>=20
> 	/* flush old setting and set the new one */
> 	cmr &=3D ~ATMEL_TC_TCCLKS;
> 	if (index =3D=3D 0) {
> 		cmr &=3D ~ATMEL_TC_A_MASK;
>=20
> 		/* Set CMR flags according to given polarity */
> 		if (polarity =3D=3D PWM_POLARITY_INVERSED) {
> 			cmr |=3D ATMEL_TC_ASWTRG_CLEAR;
>=20
> 			/*
> 			 * If duty is 0 or equal to period there's no need to register
> 			 * a specific action on RA/RB and RC compare.
> 			 * The output will be configured on software trigger and keep
> 			 * this config till next config call.
> 			 */
> 			if (tcbpwm->duty !=3D tcbpwm->period && tcbpwm->duty > 0)
> 				cmr |=3D ATMEL_TC_ACPA_SET | ATMEL_TC_ACPC_CLEAR;
> 		} else {
> 			cmr |=3D ATMEL_TC_ASWTRG_SET;
> 			if (tcbpwm->duty !=3D tcbpwm->period && tcbpwm->duty > 0)
> 				cmr |=3D ATMEL_TC_ACPA_CLEAR | ATMEL_TC_ACPC_SET;
> 		}
> 	} else {
> 		cmr &=3D ~ATMEL_TC_B_MASK;
> 		if (polarity =3D=3D PWM_POLARITY_INVERSED) {
> 			cmr |=3D ATMEL_TC_BSWTRG_CLEAR;
> 			if (tcbpwm->duty !=3D tcbpwm->period && tcbpwm->duty > 0)
> 				cmr |=3D ATMEL_TC_BCPB_SET | ATMEL_TC_BCPC_CLEAR;
> 		} else {
> 			cmr |=3D ATMEL_TC_BSWTRG_SET;
> 			if (tcbpwm->duty !=3D tcbpwm->period && tcbpwm->duty > 0)
> 				cmr |=3D ATMEL_TC_BCPA_CLEAR | ATMEL_TC_BCPC_SET;
> 		}
> 	}
>=20
> 	__raw_writel(cmr, regs + ATMEL_TC_REG(group, CMR));
>=20
> 	if (index =3D=3D 0)
> 		__raw_writel(tcbpwm->duty, regs + ATMEL_TC_REG(group, RA));
> 	else
> 		__raw_writel(tcbpwm->duty, regs + ATMEL_TC_REG(group, RB));
>=20
> 	__raw_writel(tcbpwm->period, regs + ATMEL_TC_REG(group, RC));
>=20
> 	/* Use software trigger to apply the new setting */
> 	__raw_writel(ATMEL_TC_CLKEN | ATMEL_TC_SWTRG,
> 			regs + ATMEL_TC_REG(group, CCR));
> 	spin_unlock(&tcbpwmc->lock);
> 	return 0;
> }
>=20
>=20
> Is that what you're expecting?

Looking at the code above, maybe reshuffling isn't such a good idea
after all as you have to repeat the "duty 0 or equal to period" check
four times.

Thierry

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ0dAaAAoJEN0jrNd/PrOhGTIQALM3jBoG7Xvn69SElk4jbgEs
LqGg80TlY2VwWla3JJ6gImn7alayRSBWCAvvpmz+N0fxC+Cze2htarNenTy8Biz9
OG1TNTrdug/xW/h2cOn/Md6eVIeUtvT0mjdrSJ47k5+EmfB2B8zFyi58eUzU8wvK
frEm+jXVoFgK6Pt9k9wDwRWH9P239XvDcuyBg0igK8kc6AWbsBsgGMwbZSzrqazD
/KLqWDIwoin9lC9XvdZQkk7E1jJpgvnbKjeFJu6YKWo8yTp1Jcy8JC4fxlt/wvna
IeZrOkaIQ4ReTTFUi0pVBVGfKZGsU5BB6k+6HeqQMSdopXNb9R/nnqSwIprwGbKL
uRgoGhaMC3frCcgcdtxBEV/eJqfxWVHLLsZnztJee9UUuILJsmERKnPnTnzK7lZL
bnNhQDUG7XmH+iDTkVur2MZdsvC4FDf5kil9XRglsOP+CYf+px0+tDyTORKKricz
N7KuHic8lN5773OsV+Bs6vFSpXyI3ovKcgO//sqqIefn/oWfOZGL18TrD2iSzxo6
cutvM0yIExI0Q3ulj7Tff6J6Zg+kw2qFJ8xiAV9KJFMKc4YAm9sx9pCAxFO6SuV0
YZ6UCFa+O340977XOE2eHdTwVFpVkTC9zYunkNQmYQe9eobbziAN+KfgPSDg1NXU
9oREi6R+jYURkoJjdPYg
=nwS7
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
