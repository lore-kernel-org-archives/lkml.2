Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979Ab2JVHzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 03:55:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62892 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab2JVHzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 03:55:39 -0400
Date: Mon, 22 Oct 2012 09:55:34 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Shiraz Hashim <shiraz.hashim@st.com>, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH V3] PWM: Add SPEAr PWM chip driver support
Message-ID: <20121022075534.GA4931@avionic-0098.mockup.avionic-design.de>
References: <1350877903-8578-1-git-send-email-shiraz.hashim@st.com>
 <CAOh2x=mNWNtwcWB3a=mCsfwC8WqXiisW8zeg9amsXy7b2nLCkA@mail.gmail.com>
 <20121022060641.GB3900@localhost.localdomain>
 <CAKohpo=LHjV2tV1R34Q_As4s2Yh071+t-bLyFBDGSZ_u5vKo7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <CAKohpo=LHjV2tV1R34Q_As4s2Yh071+t-bLyFBDGSZ_u5vKo7Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:4aOXAOfjQFKJ/6G1GLray4Prc0jpt5ygXOuQoPE0RY+
 u8zcbYHJ2kVJfkqHoOh3YmBukklp6VmbGYfE9EAhbNcnKyOUIv
 6t4ROFeDsDDaYseLQx04gnDQGn1DvG91AUy1fUtfG9SnroedMM
 f0A65b1aT0CDm934+Ll41Nuw0UDlBV1Yy6fuW3TY/4BGLm+CVk
 VGciccpto8p2DGpSsy6PLyBnnFNa8h90/+09brO+JE9caB++yU
 ZQiaa7+VzRD7P3qn8zDj/k1vw7EdRBdXyP29u0EWMdFmLqIT8S
 /iaNZ5sDxSLjVtnbwq585B9raMX9OvyzTcnf5PpyIvYFYIg+48
 akUK7ck1G0Xf4poqL3qyzt0plkybk5VkI6mkOzcVNT0/eQSvGd
 GoZJh6Ik+YgE8bRXmEEn2kgVyMGJKObJkX///8goxG1iUpMFhn
 nfGHg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 22, 2012 at 11:51:11AM +0530, Viresh Kumar wrote:
> On 22 October 2012 11:36, Shiraz Hashim <shiraz.hashim@st.com> wrote:
> > On Mon, Oct 22, 2012 at 09:39:21AM +0530, viresh kumar wrote:
> >> On Mon, Oct 22, 2012 at 9:21 AM, Shiraz Hashim <shiraz.hashim@st.com> =
wrote:
>=20
> >> > +static int spear_pwm_remove(struct platform_device *pdev)
> >> > +{
> >> > +       struct spear_pwm_chip *pc =3D platform_get_drvdata(pdev);
> >> > +       int i;
> >> > +
> >> > +       for (i =3D 0; i < NUM_PWM; i++) {
> >> > +               struct pwm_device *pwm =3D &pc->chip.pwms[i];
> >> > +
> >> > +               if (test_bit(PWMF_ENABLED, &pwm->flags)) {
> >> > +                       spear_pwm_writel(pc, i, PWMCR, 0);
> >> > +                       clk_disable(pc->clk);
> >> > +               }
> >> > +       }
> >> > +
> >> > +       /* clk was prepared in probe, hence unprepare it here */
> >> > +       clk_unprepare(pc->clk);
> >>
> >> I believe you need to remove the chip first and then do above to
> >> avoid any race conditions, that might occur.
> >
> > I am afraid, I would loose all chips and their related information
> > (PWMF_ENABLED) then.
>=20
> I have just checked core's code, and yes you are correct.
> Now i have another doubt :)
>=20
> Why shouldn't you do this instead:
>=20
>        for (i =3D 0; i < NUM_PWM; i++)
>               pwm_diable(&pc->chip.pwms[i]);
>=20
> And, why should we put above code in pwmchip_remove() instead, so that
> pwm drivers don't need to do all this?
>=20
> @Thierry: Your inputs are required here :)

We could probably do that in the core. I've had some discussions about
this with Lars-Peter (Cc'ed) who also had doubts about how this is
currently handled.

The problem is that the core driver code ignores errors from the
driver's .remove() callback, so actually returning the error of
pwmchip_remove() here isn't terribly useful. I had actually assumed
(without checking the code) that the device wouldn't be removed if an
error was returned, but that isn't true.

IIRC Lars-Peter suggested that we do reference counting on PWM devices
so that they could stay around after the module is unloaded but return
errors (-ENODEV?) on all operations to make sure users are aware of them
disappearing.

What you're proposing is different, however. If we put that code in the
core it will mean that once the module is unloaded, all PWM devices will
be disabled. There is currently code in the core that prevents the chip
=66rom being removed if one or more PWM devices are busy. But as explained
above, with the current core code this return value isn't useful at all.

This needs to be addressed, but I'm not quite sure how yet. Obviously it
cannot be solved in the core, because the PWM devices may be provided by
real hotpluggable devices, so just preventing the driver from being
removed won't help.

Thierry

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhPv2AAoJEN0jrNd/PrOht5UP/305YEFCXnaXAgRJmRLS1/ef
3MUWmd49GkNH5U3bMXDXifLChLpifCgZuXR0X1JoswADUhrUdZiIKMpVFdCB6jCK
HwzqysYyY+klWdVR3mqIVSp2Vs4WZnpWcRR3BIfSW9mO/F+9vk0eAflXYL8K0lRr
EXWbglWNLKeibiXYKB0+LhayLyt8+daYvhGczh8vxSG+vQeHGauR0/TREspUQ82D
hzdlfN9E913tXxH+cmx1UYekEFocXQB3tkndmsNfl+0GAvvDhBXZtfg87sWkM9bd
+Mndp56ykA4qiX06dV0fCGAzGVq+MbYc0OkaEBf96qQQ95L8FmuW1q8c4HhGe/R6
JDNjH/ssshJf/DaohLzIBj1rTiXkx21wGAH+qRnuF8wLZayT+6kknKcLcm6B4eMz
rkHXGZ8mHGN7NrQdyeAnZNCSHwKJrLnTIQ2jcFRLjNRf80yi+5z1ZaNhrrXsejY2
7+tyItu9Rk1ctj7WGc5ZFn1dnZ5z5F4918ala3c/WUD6Kebv7foL4Xy29vXVv5MI
E0E0aY36649vHpzAQRtbD5UHyCBcJYTCvBBrQDGq8cYZz/+7ia0IqTVs3pWFJ3at
upMCnPWiCbxsGeoijNX+1tvdgBbOs8lZNAbHtW/+RJ2kfcgrdgAYpMMeW8q52YQn
kUOlH8q1CdZUGsulYB9C
=Aqlw
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
