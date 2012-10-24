Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab2JXFyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 01:54:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49491 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2JXFyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 01:54:18 -0400
Date: Wed, 24 Oct 2012 07:54:12 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Subject: Re: [PATCH V3] PWM: Add SPEAr PWM chip driver support
Message-ID: <20121024055412.GD9787@avionic-0098.mockup.avionic-design.de>
References: <1350877903-8578-1-git-send-email-shiraz.hashim@st.com>
 <CAOh2x=mNWNtwcWB3a=mCsfwC8WqXiisW8zeg9amsXy7b2nLCkA@mail.gmail.com>
 <20121022060641.GB3900@localhost.localdomain>
 <CAKohpo=LHjV2tV1R34Q_As4s2Yh071+t-bLyFBDGSZ_u5vKo7Q@mail.gmail.com>
 <20121022075534.GA4931@avionic-0098.mockup.avionic-design.de>
 <50853A0A.3070007@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cHMo6Wbp1wrKhbfi"
Content-Disposition: inline
In-Reply-To: <50853A0A.3070007@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:E0ivTr46zaqP1yrn0sZxUjXXgt+sWQJcmA7i9imuQMw
 dOVJZzRj5AwAyXavmj+yW7IFJA0x9ueyXiU952WzNVJKNxXDfX
 SYlMSYvMho8Kd//uvQZEKtV8SMv02OQUdL/B1T75oabqLOfBpG
 z4Rs5MdrqdtA+BNCZAY0a3QkC/uGSbSm4P/HuFv3epw0C4tufS
 iis6Nwl0TSNpHaLeW2/tnpcrG/M0j0gfdNQKn4sXfRw2vsFNpw
 h8/7fNteZmx/KYPUml6GNEVvUiUL4GsuRuvH5qcWUUsvYQag5C
 xc22XpHQxhZy46fNzBR8d7QlDzcUWHFwDjc+05x9SDf9lcy4TJ
 iUa7M8WNyBtGgOPK8y9i3g7ABoOCCDTFcpcmxSq/dG8xC9IeZ4
 6QkyQ/Po/hB9f4oeSyaI/333Z9EkUxn7kOTts4FLJ74uhSlXuD
 DykeJ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cHMo6Wbp1wrKhbfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 22, 2012 at 02:20:26PM +0200, Lars-Peter Clausen wrote:
> On 10/22/2012 09:55 AM, Thierry Reding wrote:
> > On Mon, Oct 22, 2012 at 11:51:11AM +0530, Viresh Kumar wrote:
> >> On 22 October 2012 11:36, Shiraz Hashim <shiraz.hashim@st.com> wrote:
> >>> On Mon, Oct 22, 2012 at 09:39:21AM +0530, viresh kumar wrote:
> >>>> On Mon, Oct 22, 2012 at 9:21 AM, Shiraz Hashim <shiraz.hashim@st.com=
> wrote:
> >>
> >>>>> +static int spear_pwm_remove(struct platform_device *pdev)
> >>>>> +{
> >>>>> +       struct spear_pwm_chip *pc =3D platform_get_drvdata(pdev);
> >>>>> +       int i;
> >>>>> +
> >>>>> +       for (i =3D 0; i < NUM_PWM; i++) {
> >>>>> +               struct pwm_device *pwm =3D &pc->chip.pwms[i];
> >>>>> +
> >>>>> +               if (test_bit(PWMF_ENABLED, &pwm->flags)) {
> >>>>> +                       spear_pwm_writel(pc, i, PWMCR, 0);
> >>>>> +                       clk_disable(pc->clk);
> >>>>> +               }
> >>>>> +       }
> >>>>> +
> >>>>> +       /* clk was prepared in probe, hence unprepare it here */
> >>>>> +       clk_unprepare(pc->clk);
> >>>>
> >>>> I believe you need to remove the chip first and then do above to
> >>>> avoid any race conditions, that might occur.
> >>>
> >>> I am afraid, I would loose all chips and their related information
> >>> (PWMF_ENABLED) then.
> >>
> >> I have just checked core's code, and yes you are correct.
> >> Now i have another doubt :)
> >>
> >> Why shouldn't you do this instead:
> >>
> >>        for (i =3D 0; i < NUM_PWM; i++)
> >>               pwm_diable(&pc->chip.pwms[i]);
> >>
> >> And, why should we put above code in pwmchip_remove() instead, so that
> >> pwm drivers don't need to do all this?
> >>
> >> @Thierry: Your inputs are required here :)
> >=20
> > We could probably do that in the core. I've had some discussions about
> > this with Lars-Peter (Cc'ed) who also had doubts about how this is
> > currently handled.
> >=20
> > The problem is that the core driver code ignores errors from the
> > driver's .remove() callback, so actually returning the error of
> > pwmchip_remove() here isn't terribly useful. I had actually assumed
> > (without checking the code) that the device wouldn't be removed if an
> > error was returned, but that isn't true.
> >=20
> > IIRC Lars-Peter suggested that we do reference counting on PWM devices
> > so that they could stay around after the module is unloaded but return
> > errors (-ENODEV?) on all operations to make sure users are aware of them
> > disappearing.
> >=20
> > What you're proposing is different, however. If we put that code in the
> > core it will mean that once the module is unloaded, all PWM devices will
> > be disabled. There is currently code in the core that prevents the chip
> > from being removed if one or more PWM devices are busy. But as explained
> > above, with the current core code this return value isn't useful at all.
> >=20
> > This needs to be addressed, but I'm not quite sure how yet. Obviously it
> > cannot be solved in the core, because the PWM devices may be provided by
> > real hotpluggable devices, so just preventing the driver from being
> > removed won't help.
>=20
> In my opinion it would make sense to put this into the PWM core. Even if =
the
> device is still physically connected, e.g. because it is a on-SoC device,=
 it
> should be stopped if the device is removed. You do not want the PWM device
> to continue to provide it's service (which is the PWM signal) after the
> device has been removed. This means this is something that needs to be
> implemented by every PWM driver.

Alright. Let's keep it in the driver for now and I'll remove it once I
get around to implementing the functionality in the core.

Thierry

--cHMo6Wbp1wrKhbfi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQh4KEAAoJEN0jrNd/PrOhYToQAJHlbzAWo0d1W0NP7Vs4JE8p
d+BKrcfqtwyMQEFZxMCscicxlwK2zrc/0vEZafUJsqmvI588tXHnO+0Saeo09KJJ
Ei9sObF3lLm/bE4WlGvCZGbMf7YffOy2Sdzkiunruy5bJPz2u8kAY6coh8TrZ5uP
Y+KWU1Oxmfbe9KeECV+Mv3o49Sn0qfSDBTw9Ii7WQZH/HFlIm6Q7XaIHboUkx2hk
AQxCGYHK9xL13bbTHSn7MgQSAYu9amuat5/a31RcXY8Nsd2H3x/o6dcf5o/RGCxs
k2j7atyDfAGzdumhnj6jmZPzXXHn+kDsbWPIDRW7gapFdE2eIo6Z0YtVSgSX2HtN
WkAHF8QBJNgl50wBvIF6kjpv+p6a/IPicyk3TZE4HL4jubIPKiWX4moAN9FlP/3C
etEJxZsuPS3g6g2M9zykWGu3JoHo2uM4wYD0/CfumKugaxRTNj9TfDqLMjjzVfiu
DjmTFp+y0IIaX2DtbNwop+AeiWiErGEs7ln8VrrtFzMBWI6bf1aNlYzDoOy8BUwP
XlTlIzLu73RgKsbDbmu0bUd5PTtf93GYGhFHhfG28hWauodUreqe84hZOVBVRblZ
xJnC0I3Wq1+GwfYvu2ahV9xaRFF7lcOEWt34MI7BXLStGmblaKRQcx7GBC6bKXsN
sdhZ+4W5fqmqZrZMdx9O
=D8h1
-----END PGP SIGNATURE-----

--cHMo6Wbp1wrKhbfi--
