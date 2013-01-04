Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab3ADHfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 02:35:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59176 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3ADHfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 02:35:05 -0500
Date: Fri, 4 Jan 2013 08:34:58 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH] RFC: leds-pwm: don't disable pwm when setting brightness
 to 0
Message-ID: <20130104073458.GA9289@avionic-0098.adnet.avionic-design.de>
References: <20121024095603.GH639@pengutronix.de>
 <1351086766-5837-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20121025080346.GB9921@S2101-09.ap.freescale.net>
 <20130103090117.GA1845@avionic-0098.adnet.avionic-design.de>
 <20130103205514.GG14860@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20130103205514.GG14860@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:SiXS/jhILKSJMWWyMmFGDMzGiuRZ8hC1AhNfgtTOmZS
 TCtZX6OwlgXx8dO1h0FB7qwh5ocwTJdPS35rHIpLekZv4Sz0r/
 Ed/5JaUH67DOCXKfqw9aKhHR5nx3JLa9O/JpOmXx9x3mZt5khJ
 Mep1P75VX2P1I8wPCT+Axw9FMbFaRbWs1ahvJHnjarI2Y2vPoL
 1LBpWqIzwbiOhoqrjVmDIgfpfyHKwpL1z5+lad5MEjxPrhNyBl
 kR0uxvSkXoZk8E3KRMpKJdMahiOkISfSG7Z3jEE9Ob1mXPJ/N0
 GZPlQlAVAXZ1cDsgG/BEejH9HTIOfcEZOrTE5TvDi6bnvGZgUr
 pwEpBtKdg+RZUVgn538yFdSMJmLjtoOAOkyL/brxtMzvcOXJNb
 9RA0n2NNfeLsaho1lwhL1wNQ/uMSF/EYCY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 03, 2013 at 09:55:14PM +0100, Uwe Kleine-K=C3=B6nig wrote:
> Hi Thierry,
>=20
> On Thu, Jan 03, 2013 at 10:01:18AM +0100, Thierry Reding wrote:
> > On Thu, Oct 25, 2012 at 04:03:49PM +0800, Shawn Guo wrote:
> > > On Wed, Oct 24, 2012 at 03:52:46PM +0200, Uwe Kleine-K=C3=B6nig wrote:
> > > > This fixes disabling the LED on i.MX28. The PWM hardware delays usi=
ng
> > > > the newly set pwm-config until the beginning of a new period.  It's=
 very
> > > > likely that pwm_disable is called before the current period ends. In
> > > > case the LED was on brightness=3Dmax before the LED stays on becaus=
e in
> > > > the disabled PWM block the period never ends.
> > > >=20
> > > > It's unclear if the mxs-pwm driver doesn't implement the API as exp=
ected
> > > > (i.e. it should block until the newly set config is effective) or i=
f the
> > > > leds-pwm driver makes wrong assumptions. This patch assumes the lat=
ter.
> > > >=20
> > > > Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.d=
e>
> > > > ---
> > > > Hello,
> > > >=20
> > > > I'm not sure this is correct, but this is the workaround I'm using =
until
> > > > I get some feed back.
> > >=20
> > > I'm fine with it, since it fixes a real problem.  Let's see what
> > > Thierry says.
> >=20
> > I lost track of this thread somehow, so sorry for not getting back to
> > you earlier. The root cause of this problem seems to be that it isn't
> > very well defined (actually not at all) what is supposed to happen in
> > the case when a PWM is disabled.
> >=20
> > There really are only two ways forward: a) we need to write down what
> > the PWM subsystem expects to happen when a PWM is disabled or b) keep
> > the currently undefined behaviour. With the latter I expect this kind
> > of issue to keep popping up every once in a while with all sorts of
> > ad-hoc solutions being implemented to solve the problem.
> >=20
> > I think the best option would be to have some definition about what the
> > PWM signal should look like after a call to pwm_disable(). However this
> > doesn't turn out to be as trivial as it sounds. For instance, the most
> > straightforward definition in my opinion would be to specify that a PWM
> > signal should be constantly low after the call to pwm_disable(). It is
> > what I think most people would assume is the natural disable state of a
> > PWM.
> >=20
> > However, one case where a similar problem was encountered involved a
> > hardware design that used an external inverter to change the polarity of
> > a PWM signal that was used to drive a backlight. In such a case, if the
> > controller were programmed to keep the output low when disabling, the
> > display would in fact be fully lit. This is further complicated by the
> > fact that the controller allows the output level of the disabled PWM
> > signal to be configured. This is nice because it means that pretty much
> > any scenario is covered, but it also doesn't make it any easier to put
> > this into a generic framework.
> >=20
> > Having said that, I'm tempted to go with a simple definition like the
> > above anyway and handle obscure cases with board-specific quirks. I
> I don't understand what you mean with "the above" here. I guess it's
> "PWM signal should be constantly low after the call to pwm_disable".

Yes, exactly.

> To cover this we could add a function pwm_disable_blurb() that accepts a
> parameter specifying the desired signal state: "high", "low" or (maybe)
> "don't care". pwm_disable would then (probably) mean
> pwm_disable_blurb("don't care"). But maybe this already contradicts your
> idea about being simple and clean?!

I'm wondering if that's really necessary. This really seems more of a
board-specific question. If you run pwm_disable() on a PWM device, it
should be turned "off" (whatever that means in the context of a board
design) after the call terminates.

Part of the problem is that we want to keep the board-specific
complexities out of client drivers. For instance in the case you
encountered, the leds-pwm driver shouldn't have to know any of the
details pertaining to the i.MX28. That is, leds-pwm should be able to
call pwm_disable() if it wants to turn off the PWM signal.

If we add pwm_disable_blurb() as you suggest, what is leds-pwm supposed
to pass in? Usually this would be "low", but on other hardware (with
additional inverter circuitry) it would be "high". We certainly don't
want to have leds-pwm handling that kind of logic. The PWM signal
polarity is entirely defined at the board-level and therefore should be
handled by board setup code (or encoded in DT).

> Also note that I had another/alternative issue with the API, i.e. when
> the pwm routines should return.

Right. All of the above would entail that pwm_config() should either
block until the configuration is active, or alternatively that when
pwm_disable() is called without the new configuration being active yet,
it is pwm_disable() that needs to wait until the configuration becomes
active.

Another alternative would be that leds-pwm wouldn't have to call
pwm_config() with a 0% duty cycle in the first place if pwm_disable() is
guaranteed to force the PWM signal to constant low.

Thierry

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ5oYiAAoJEN0jrNd/PrOhcioP/RnbwDLt+ZeJ3F6vH+PqzKuP
G0843oK0MlL3Q893taxMSLdIlnx4gtSyOaVR68qmsxfzuwUvASC4V19mB3N6yDr3
F2ALasIvu4RtovInD4nbPJFyw7xEUhUxlHn5bNZu/AO+6hhDQeQgOw+38CteB+P7
CEarPZSx6fxJkpBi6ai8EP61e9RQm4Xy+yRVSUG4iCQw1BYIDGgHiJFO9M22tHtF
5OeAtFD2L/rCmJNfF0iuqDEB1dOIgkLZFHU8rK4XgCcaq83cDLPM6CDIH8U4977m
YI35arUelOonUebdMWQKLMneH5G5tUiCXuGpisQTQ6iyk6mVJopDH/LnRCiZ8/tv
W+BYBz6hIiprumLJtyFLSekZ81WJL7AWsYZhA2o3K4TkIUROAPn45SmzRBnJzXJk
AGqgGZD8fU9dehIkeJ+mKyb6D0bGz7MqbqVCxoKvI4m4cjMU+KfayOR1FeJdT5A5
awBm4Menix1HFeypVFlB7HDIgBpVKUQZ0NDLCNC+UG9CZCVV5MJqA3/R+FNrEjnT
I7UfQYSdR+bz5zCr7ZuZtD340Jo4n4yRUZu7ODOKl/3y+ZKQAjq4qbh6fLXGypIJ
WM+Pn+mt4Q1QdvH2s7XuAXab8T2EZC+3fbOD4Nekj9L9AEX7v+Lq6kkw/7I/NA/S
PmL4e7469dg5k/AR9EnM
=c0ef
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
