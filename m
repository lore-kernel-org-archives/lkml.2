Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215Ab2HWTLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 15:11:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64798 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab2HWTLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 15:11:13 -0400
Date: Thu, 23 Aug 2012 21:11:08 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] pwm: Call pwm_enable() before pwm_config()
Message-ID: <20120823191108.GB8127@avionic-0098.mockup.avionic-design.de>
References: <36966374.2768747.1345741025741.JavaMail.root@advansee.com>
 <50366464.4070801@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <50366464.4070801@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:N0p9PaQ+c/xsj3XQrLggyihgIkvYLOFRMNy2wZJ2cDV
 vn4vxzRsp2lUgAHhXU91SWnTcDX2xdoSYw8iNDvyiDQ/rlolYC
 3WUFhAJWgrsJdHBPmA9H6SalwNIqU6EtpzwTIPz5L6urVsGHsN
 0T5Z7xl9eg7886gGJSL15Mkr9s5gATDwLkaz4EEIux6lFucA/a
 y+rYDMe9KojxumqIJ5l0OumhrxpvkAkaZBtYg5ZH8AfJIvjwZ+
 wf/e7ISgBBrvFzvDkX9KPIDuFGeUzDmp16FhPHfrvFFpa27IeM
 WV9UGd6uhDMh7HnyATmvcEwfs7bjepMmLfUN9gU2MTufRY8MZB
 HrPVXVugspCTtIzae6cZuJecBaBLLlQyQpqc7sDZ/Z8p51YuB+
 1bRxPo5qoSS1gAqs2rogmxIJkAV4dM3sSUaDbQYaPURutjDaVg
 kz7T4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 23, 2012 at 07:12:04PM +0200, Lars-Peter Clausen wrote:
> On 08/23/2012 06:57 PM, Beno=C3=AEt Th=C3=A9baudeau wrote:
> > On Thursday, August 23, 2012 5:43:32 PM, Lars-Peter Clausen wrote:
> >> On 08/23/2012 04:19 PM, Beno=C3=AEt Th=C3=A9baudeau wrote:
> >>> Some PWM drivers enable the clock of the PWM peripheral in
> >>> pwm_enable(). Hence,
> >>> for these drivers, a call to pwm_config() does not have any effect
> >>> before
> >>> pwm_enable() has been called.
> >>>
> >>> This patch fixes the PWM users to make sure that they call
> >>> pwm_enable() before
> >>> pwm_config().
> >>>
> >>> This fixes the first setting of brightness through sysfs that had
> >>> no effect with
> >>> leds-pwm and the i.MX PWM driver.
> >>
> >> But isn't this a bug in the PWM peripheral driver? With this change
> >> the PWM
> >> will start with the old settings first. While this is not so much of
> >> a problem
> >> for a backlight (although it might cause a short flickering) it might
> >> cause
> >> problems for other applications, like using the PWM pin as a timing
> >> generator.
> >> In my opinion it's better to fix the PWM peripheral drivers which
> >> have this
> >> problem instead of trying to work around it in every user of the PWM
> >> API.
> >=20
> > I don't know. See my detailed description of this issue here:
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2012-August/11566=
7.html
> >=20
> > Where the bug is depends on the detailed definition of the PWM API, whi=
ch I
> > don't find documented anywhere.
> >=20
> > If pwm_enable() means "start PWM timer with the configured settings", t=
hen the
> > bug is in the drivers. If it means "enable the PWM peripheral so that w=
e can
> > work with it", then the bug is in the PWM users.
>=20
> It really is the former. See the description of pwm_enable() in drivers/p=
wm/core.c

Yes. pwm_enable() is only for starting the PWM and *not* the peripheral.
I should update the documentation to make this clearer.

> > I don't really have time to work on this, so I suggested this patch as =
a simple
> > solution. Otherwise, it means reworking several PWM drivers for differe=
nt
> > hardware that is not available to everyone for testing.
> >=20
> > If we decide to only change the i.MX PWM driver, the fix would be:
> > pwm_config()
> > {
> >         save passed config in private data;
> >         if (pwm enabled)
> >                 apply passed config;
> > }
> >=20
> > pwm_enable()
> > {
> >         if (!(pwm enabled)) {
> >                 enable pwm ip clk;
> >                 apply config from private data;
> >         }
> > }
>=20
> Another option is to enable the clock if it is disabled when the device is
> configured. E.g. that's what tegra does.

Yes, that would have been my proposal as well.

> > If we fix only this driver, we must not forget that the same issue prob=
ably
> > exists with several other PWM drivers.
>=20
> Since this seems to be a common pattern in a number of PWM drivers it mig=
ht
> make sense to simply add support for enabling/disabling a clk to the pwm =
core.
> Or maybe just use the runtime pm API for this. This probably makes even m=
ore
> sense and grab a reference to the pm context when the enable() is called,
> release it when disable() is called and also grab it before calling the
> device's config callback and release it afterward.

The problem with adding this kind of support in the core is that the
device or platform doesn't necessarily support runtime PM. Perhaps
adding a flag to mark compatible drivers would be an option. If the
runtime PM API gracefully handles cases where no callbacks are
implemented (and therefore assumed unneeded) things should also work.

On the other hand this really is very driver-specific stuff. A lot of
hardware doesn't require an explicit clock being enabled to write
registers so those wouldn't need the implicit PM calls either.

Thierry

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQNoBMAAoJEN0jrNd/PrOhFNAP/2uhljseGNlGBked4DEv/e9R
1/KQaSlNw9Hm1eQPN5f1hDyn4SRLHBXT0YFCwE5D8bJlk0K9/FJ8KThNSXZe3Szh
cEer2WYdb01RJxF2oOaZ0/vd+xIHGqWBfZYryY0ritKUNbea72S1eUMJx9MckgRX
MoAYDIXJRFTopmdZB+AqXceDfxKpW6Li7qTSi/J/73k2HmeyqT0C0+8gfJ4rhqgI
ImRkRugf8X6XmbsSvYRlbrl+6BWv7GJm3L8tECPADtXx9YFF2HbsTrtWjq+RJYm3
jRxyC4UtReu2I3FWGq0PcaCimoSUIJDbBBALuDyd5KKaHpA04SE+V5QQcROvixfH
1uvGaXR0cuk1hZbuCs8PFKAsWXmNwzLu+hJa3wiV+UpMyQHUTwP5vqchk6OXSl+9
FywJxTCFyzg1zcyGiokh6uxDiglLrAqnpib2YN0lfp4tjmdBiHPiSsmF9EbZfl6O
9TmVxxPsS2M86FBT3ub5T2LueNdEVzjriYBMRIsdH8o+tKofMVstljzpTvU9Rw8L
46m9+GIIBARgjfUUUXqhj5ndmcENX8vztpgHUdKXqEnua5rNeC/BSuto67gQgcax
+eRduop6fGf1ZGNbVstyX/d1gSbEF68Ag8Om0srTo3hSA288+0pRyw7ZqdKbbFRW
qCF8TC8TnDxdfQKcvdYk
=8IkA
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
