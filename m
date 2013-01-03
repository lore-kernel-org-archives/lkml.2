Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab3ACJB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 04:01:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:65438 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3ACJBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 04:01:24 -0500
Date: Thu, 3 Jan 2013 10:01:18 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH] RFC: leds-pwm: don't disable pwm when setting brightness
 to 0
Message-ID: <20130103090117.GA1845@avionic-0098.adnet.avionic-design.de>
References: <20121024095603.GH639@pengutronix.de>
 <1351086766-5837-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20121025080346.GB9921@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <20121025080346.GB9921@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:+wtvIU5KyUzDJ0ExZHaQgjPk8nXBcFrT5Ack97lf7GJ
 K+7Dmn3395EU9QMdxh+bkpqEguGOrhl5pOSzIu7pOBEkT9noJF
 HNShy4YMYdJffhGm59aAQwe0Y9L1YskKxrO54CIWRhg2yv/06S
 2BLdYjIzc6nUkjLme5Apb8vxmJBYfMAVDwnDGVTbmNavBlBkf5
 S22cPi5j01XkLOw8fgiV/FShWI4jniNsAQtNnLF4iaeEqwEh6D
 sG74vAFn03T9vLPBdLyo8kQ8K4Bj1jzjQjaU1NleKucyfcRK97
 qZf41T8buYlSKfIzx1te4gnbVfvWQjbDJLPPop2wOgpDvyGHeT
 JHqwvaKAAKIYC0k0C0CmdgB7HU9MJdFYQOCcnxLZumopB8wITO
 vMunh8KSgrdqqSt3oNJfPjBVhylEK3+I9A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 25, 2012 at 04:03:49PM +0800, Shawn Guo wrote:
> On Wed, Oct 24, 2012 at 03:52:46PM +0200, Uwe Kleine-K=C3=B6nig wrote:
> > This fixes disabling the LED on i.MX28. The PWM hardware delays using
> > the newly set pwm-config until the beginning of a new period.  It's very
> > likely that pwm_disable is called before the current period ends. In
> > case the LED was on brightness=3Dmax before the LED stays on because in
> > the disabled PWM block the period never ends.
> >=20
> > It's unclear if the mxs-pwm driver doesn't implement the API as expected
> > (i.e. it should block until the newly set config is effective) or if the
> > leds-pwm driver makes wrong assumptions. This patch assumes the latter.
> >=20
> > Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> > ---
> > Hello,
> >=20
> > I'm not sure this is correct, but this is the workaround I'm using until
> > I get some feed back.
>=20
> I'm fine with it, since it fixes a real problem.  Let's see what
> Thierry says.

I lost track of this thread somehow, so sorry for not getting back to
you earlier. The root cause of this problem seems to be that it isn't
very well defined (actually not at all) what is supposed to happen in
the case when a PWM is disabled.

There really are only two ways forward: a) we need to write down what
the PWM subsystem expects to happen when a PWM is disabled or b) keep
the currently undefined behaviour. With the latter I expect this kind
of issue to keep popping up every once in a while with all sorts of
ad-hoc solutions being implemented to solve the problem.

I think the best option would be to have some definition about what the
PWM signal should look like after a call to pwm_disable(). However this
doesn't turn out to be as trivial as it sounds. For instance, the most
straightforward definition in my opinion would be to specify that a PWM
signal should be constantly low after the call to pwm_disable(). It is
what I think most people would assume is the natural disable state of a
PWM.

However, one case where a similar problem was encountered involved a
hardware design that used an external inverter to change the polarity of
a PWM signal that was used to drive a backlight. In such a case, if the
controller were programmed to keep the output low when disabling, the
display would in fact be fully lit. This is further complicated by the
fact that the controller allows the output level of the disabled PWM
signal to be configured. This is nice because it means that pretty much
any scenario is covered, but it also doesn't make it any easier to put
this into a generic framework.

Having said that, I'm tempted to go with a simple definition like the
above anyway and handle obscure cases with board-specific quirks. I
don't see any other alternative that would allow the PWM framework to
stay relatively simple and clean.

Now I only have access to a limited amount of hardware and use-cases, so
any comments and suggestions as well as requirements on other platforms
are very welcome.

Thierry

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ5UjdAAoJEN0jrNd/PrOhu7QP+wReyMmVLAJXRKgzVOUg164e
2p5U25MmkbauiRUv/NqAn2UmGAKowtxmqcbZCo2w90alNHDzRzw1vFCCaJjZYC71
NZ8PFIU1Bc747wafJpb9aKmEDQlVkASg1Kin0To5OppCO7NXUu7IWhuFSijqIgwh
medVn5moZFbbAfizFElq3hXdlYnDPeeJfKAcqZMzFv5VvxCNlHDXALauhOvOqvsY
ubDWYF/2rvVP/YuuHUtQiYzOwdT+Wrtu2hJJlbNRD4Ct/6tD8ylZymRb5s8Qv+Yd
SnlLE8Rinm+g9yFDlFNJ5xKUR0Yy7+O0oeTfaVJJebZkiH8LpesPUOOpUC9ImXUI
1MLSyy0FMz6fLwq6Yes08yHPjVdPTna5wy5lcNGSVeGWeIY2Jwk2iGtWiytZm4nb
1dcE4Ek0vdP/M5Cp8XzHL2C/VRbLpayQWB5yr2NPhIDK5EKZF9uTY7Q6djEabx/b
ojld4w9BasaZxgkfUkSNk2j3GQXEIrXE8L+JB5TsnxRLun6UI3Bamm/vuMA+kDMA
FI+BKIf6uFm8o9gxhn5+1CIAvWKijAbG9emPI3IzlkmrgS//jiRnBqATeC/dSzGU
z863hkFWvPgLa2t9my7512n9KLoyj6MiBW7Dsi67B24S6JCKthjEsgMIJEjQjvjD
NYM/eq2sJDZD+wjTHNc+
=D6OW
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
