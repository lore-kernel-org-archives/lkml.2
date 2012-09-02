Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab2IBUhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 16:37:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57244 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab2IBUhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 16:37:35 -0400
Date: Sun, 2 Sep 2012 22:37:22 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Antony Pavlov <antonynpavlov@gmail.com>,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: Re: [PATCH 3/3] pwm: Add Ingenic JZ4740 support
Message-ID: <20120902203722.GB21635@avionic-0098.mockup.avionic-design.de>
References: <1346579550-5990-1-git-send-email-thierry.reding@avionic-design.de>
 <1346579550-5990-4-git-send-email-thierry.reding@avionic-design.de>
 <504370BF.6090702@metafoo.de>
 <20120902195917.GB10930@avionic-0098.mockup.avionic-design.de>
 <5043C005.8060907@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline
In-Reply-To: <5043C005.8060907@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:SudN5a3td9UblLE96xwNPwHEutfAsj2xYqyS/CAFkMN
 73hOWvKj+5Kcsg8j1EqCM3FVdY16fSsKiGFKiZeykbbLVOgE61
 a4DParbi1BF2vSArlDbeUAT+pQtL3rpuxSOfuCuAa5krcLfzJg
 I+VJi+jLOltYR23KlAMnSa6pl+nupWovkeA1CNKRSqDNQrQUpY
 zm4CGXczAv23PsV4cJYNzUStNWc9bDFbRbOOVVltXDAd9Fx7Xz
 gpOOOgEkoxMI6WlH7mdQ98W+QY9ce8xEfLsSfLV6csCne9rL/3
 QNMp8t6WDq5GrdMZAMNgjrVehRjmoO61QezUun8GX4buKSg3L/
 poQJDEJnfQjfcqsLxwHakPs77PpOxxidC0/L/G6oE55pRkzDeJ
 iAe/1Hq8+UXaWwr7ceEOplA0CF7PHsjwgQC3hCTR7N+Eh3LjYA
 vCbN/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 02, 2012 at 10:22:29PM +0200, Lars-Peter Clausen wrote:
> On 09/02/2012 09:59 PM, Thierry Reding wrote:
> >>> +	is_enabled =3D jz4740_timer_is_enabled(pwm->hwpwm);
> >>> +	if (is_enabled)
> >>> +		pwm_disable(pwm);
> >>
> >> I think this should be jz4740_pwm_disable
> >>
> >>> +
> >>> +	jz4740_timer_set_count(pwm->hwpwm, 0);
> >>> +	jz4740_timer_set_duty(pwm->hwpwm, duty);
> >>> +	jz4740_timer_set_period(pwm->hwpwm, period);
> >>> +
> >>> +	ctrl =3D JZ_TIMER_CTRL_PRESCALER(prescaler) | JZ_TIMER_CTRL_SRC_EXT=
 |
> >>> +		JZ_TIMER_CTRL_PWM_ABBRUPT_SHUTDOWN;
> >>> +
> >>> +	jz4740_timer_set_ctrl(pwm->hwpwm, ctrl);
> >>> +
> >>> +	if (is_enabled)
> >>> +		pwm_enable(pwm);
> >>
> >> and jz4740_pwm_enable here.
> >=20
> > I wonder if this is actually required here. Can the timer really not be
> > reprogrammed while enabled?
> >
>=20
> It can, but we've observed this to cause permanent glitches until the tim=
er is
> reprogrammed again.

Okay. I've changed this to use jz4740_pwm_{enable,disable}() instead.

> >>> +{
> >>> +	struct jz4740_pwm_chip *jz4740 =3D platform_get_drvdata(pdev);
> >>> +	int ret;
> >>> +
> >>> +	ret =3D pwmchip_remove(&jz4740->chip);
> >>> +	if (ret < 0)
> >>> +		return ret;
> >>
> >> remove is not really allowed to fail, the return value is never really=
 tested
> >> and the device is removed nevertheless. But this seems to be a problem=
 with the
> >> PWM API. It should be possible to remove a PWM chip even if it is curr=
ently in
> >> use and after a PWM chip has been removed all calls to a pwm_device of=
 that
> >> chip it should return an error. This will require reference counting f=
or the
> >> pwm_device struct though. E.g. by adding a 'struct device' to it.
> >=20
> > I beg to differ. It shouldn't be possible to remove a PWM chip that
> > provides requested PWM devices. All other drivers do the same here.
>=20
> Part of the Linux device driver model is that that a device may appear or
> disappear at any given time (if the kernel has been compiled with
> CONFIG_HOTPLUG). So you can't prevent removal. The fact that the remove
> callback function return an int is kind of misleading and should probably=
 be
> fixed at some point. The return value is never checked and the device wil=
l be
> removed nevertheless. So the PWM subsystem must cope with the case where =
the
> PWM chip is removed while some of its pwm_devices are still in use.

I thought I had seen this work. But looking at the code, you're right.
Perhaps what I saw was caused by the reference counting done on the
pwm_ops structure. At least that keeps the module from being unloaded if
there are still any requested PWM devices, but it won't help if the
device suddenly goes away. I wonder if that's a realistic use-case,
though, at least for platform devices.

I currently can't run any tests because I don't have any hardware
available. I'll need to take another look when I'm back at work next
week and think of a way to solve this. Adding some reference counting as
you suggested earlier may be the only way.

Thierry

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQQ8OCAAoJEN0jrNd/PrOhLdIQAJBjhBAuvLgaIR7M2Im0Up5C
v+mUCGpF+cRzies9nxi255SuZTX7UnNnBvkJ2O0LAMJycfawGxZbl3sUdDD4MWFU
VJdAgSMP1hHBizNdE1rATSV7saKo7bqOZdmOoooCRmVOobjLkVD1qvOk4IxY2vYd
0Z59wM4ZQOCq/PGuUgMCAA2FjGOPP4C6rghBQSQlxNbO8bAJjHAAOuUUbaAmclJQ
triXc/Anc3pM5md/GdMkp0egB6wqdX2FGAgMNN7BsSkEEN9knZEcuducJnwT2ifY
OSVVD1gchCKAOLtY3AVIoB5WIkU4mLn91AOek6uoUNDeP8PJnGOPpjuVW7tBvlHn
xjOlrUId5rYSUAjBAg3gH8hzPMClQYZh+53rm6ZAY9crW76yV4roTilYqMsbdVFL
75G7FQ6Mdbm6jnB7+uO3tzizxSb3Rixvu5SiHZDqhT6WaSgkf1urAkCjxOUmsfAF
aaJm9Csl4+FWe+UJAnHLCazENyVrPVM2Keqlk51J4R6q4J6qsWk57BBPSeR9DQFQ
17+sJF+d9TShrXhPbrzxkw5zdfMbV3CJ8jcJ36MQk23MVtJ7awLsi5CyOzy6zzLU
D9wkgEA99n2mom8YeU6Fjn84kbhRzriU3uxuYdl7wC9PQqvQU6ndDTjUZG3JERzW
upBchj7N+Y5AvIeqzRAf
=ERXA
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
