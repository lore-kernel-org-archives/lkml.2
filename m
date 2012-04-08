Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab2DHX6h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 19:58:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906Ab2DHX6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 19:58:36 -0400
Date: Mon, 9 Apr 2012 09:58:25 +1000
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shuahkhan@gmail.com, rpurdie@linux.intel.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] LEDS-One-Shot-Timer-Trigger-implementation
Message-ID: <20120409095825.36a436ef@notabene.brown>
In-Reply-To: <20120406165353.ab667eb0.akpm@linux-foundation.org>
References: <1333310039.2879.4.camel@lorien2>
	<20120406165353.ab667eb0.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cVIp+0C9XaqYn7VAAlqsX/E"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/cVIp+0C9XaqYn7VAAlqsX/E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Apr 2012 16:53:53 -0700 Andrew Morton <akpm@linux-foundation.org>
wrote:

> On Sun, 01 Apr 2012 13:53:59 -0600
> Shuah Khan <shuahkhan@gmail.com> wrote:
>=20
> > LED infrastructure lacks support for one shot timer trigger and activat=
ion.
> > The current support allows for setting two timers, one for specifying h=
ow
> > long a state to be on, and the second for how long the state to be off.=
 For
> > example, delay_on value specifies the time period an LED should stay in=
 on
> > state, followed by a delay_off value that specifies how long the LED sh=
ould
> > stay in off state. The on and off cycle repeats until the trigger gets
> > deactivated. There is no provision for one time activation to implement
> > features that require an on or off state to be held just once and then =
stay
> > in the original state forever.
> >=20
> > This feature will help implement vibrate functionality which requires o=
ne
> > time activation of vibrate mode without a continuous vibrate on/off cyc=
les.
> >=20
> > >From 1ebe0fd67580da833f8f06fc3119445e9991100f Mon Sep 17 00:00:00 2001
> > From: Shuah Khan <shuahkhan@gmail.com>
> > Date: Sat, 31 Mar 2012 21:56:07 -0600
> > Subject: [PATCH] LEDS-One-Shot-Timer-Trigger-implementation
>=20
> Should be "leds: one shot timer trigger implementation", please.
>=20
> >
> > ...
> >
> > +This feature will help implement vibrate functionality which requires =
one
> > +time activation of vibrate mode without a continuous vibrate on/off cy=
cles.
>=20
> They make vibrating LED? ;)
>=20
> What's going on here?  You're proposing to repurpose the LEDs code to
> drive vibration devices?  Or some devices couple a LED with a vibration
> device?

We use 'scsi' devices to drive SATA disks.
We use 'input' devices to beep the PC 'speaker'.

It is no great deviation from this pattern to use a 'led' device to trigger=
 a
vibrator.

We could rename all of these subsystems, but that probably won't win us any
friends.
It may well make sense to create a 'vibrator' class which shared 99% of the
code of the 'led' class.  This is a bit like the 'backlight' class which al=
so
drives LEDs (sometimes) and sets their brightness.  It is presumably helpful
for user-space to see the difference intention of the LEDS - some for displ=
ay
backlight and some for signalling - and so also helpful to differentiate
output devices - some emit light, some emit kinetic energy.

It would be really nice to have a system-wide holistic way to address these
classification issues.  But as we tend to work in an incremental-development
approach, it is easiest just to add functionality where it seems to fit.

> > ...
> >
> > --- a/drivers/leds/ledtrig-timer.c
> > +++ b/drivers/leds/ledtrig-timer.c
> > @@ -24,6 +24,9 @@ static ssize_t led_delay_on_show(struct device *dev,
> >  {
> >  	struct led_classdev *led_cdev =3D dev_get_drvdata(dev);
> > =20
> > +	if (led_cdev->blink_delay_on =3D=3D LED_TIMER_FOREVER)
> > +		return sprintf(buf, "forever\n");
> > +
> >  	return sprintf(buf, "%lu\n", led_cdev->blink_delay_on);
> >  }
>=20
> This is a somewhat risky kernel interface change.  Previously the
> output was always a decimal string.  With this change it is either a
> decimal string or "forever".  Applications which were coded to the old
> interface will probably misinterpret the "forever" as a zero.  Or they
> will crash and burn.
>=20
> A safer approach would be to just print the value.  So it comes out as
> 4294967295 or 18446744073709551615.  That's pretty nasty, and invites
> people to write programs which are busted on 32-bit userspace (or on
> 64-bit).
>=20
> Maybe it was just a mistake to overload ->blink_delay_on in this
> fashion.  Perhaps the code will be cleaner if we add a couple of new
> booleans to the led_cdev.
>=20
> Anyway, please have a think about this.
>=20

I don't think it is very risky.  The output will continue to always be a
decimal string unless user-space explicitly chooses to write "forever".
So the risky step is to modify part of userspace to write 'forever' without
modifying other parts to recognise 'forever'.  I doubt anyone would actually
do that but in any case it is not the place of the kernel to care.  The
kernel change is perfectly safe (Well.... it would be if we trapped an
attempt to write 'MAXINT' and converted  it to 'MAXINT-1' - that is trivial
to do and then we would be perfectly safe).

However it might make sense to discard the 'forever' and instead introduce a
'repeat_count' attribute which defaults to 'forever' but could be explicitly
set to '1' (or 2 or 3).
I didn't advocate that at first as it seemed a bigger change than needed (a=
nd
incremental development is good), but maybe it is better to take that bigger
step.

NeilBrown

--Sig_/cVIp+0C9XaqYn7VAAlqsX/E
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4ImITnsnt1WYoG5AQJgShAAgTIh/jTlGmp3/rB+HJev6lgwlHucOwhb
Dl98eHZFQ6+2u6VGUDOYB1u9kwt/TQcFuaU3z2BtiCFxs/AiDmAyfcJDcIhSWGk1
yF0a9U43DhfP6JZpaZDLrX7sk44ZHDhuqc2qUttu7In9BPcIkMnj1TOqvpzP38mK
DTkmEidBwdL2rKFLwQiNBOLpAoo6vVKF0jWxjKnI2arqawevlHmtdO3wbjJF51eT
FDWwAli1+ELsxE7rhTzlX/8vTY6RF7sdhj8uJmha4+pCAXsifnMalYUaqfJ196o9
2rSzj9ASUs0L0erqtJAwX+lOs21W1TA1wjKpzGVIaN1BrAJCoAEbU8nQDCJ8kpyQ
2vNY/XTIdCICgGPxY3snnrb+eAgue5ICUVGwhad9HliOQD5lYOfYER6P5Jq/zBct
5IgVdbkhuE2johPRQe+zOBt3ZgBf9bEAb5bBpH4HtKpG1ROsBCZd1cHG9gLxkA/q
7LEueEhDtHnfHXPCVreg3GCKLwNsNs/XOUGzsP5rwqnTSmQKOimVqzrr4a7z9cgf
+VOY6Xse/7JDz4ohO/CAoMReNTbLpe7sIztpHkvUj1YsfxxzyL7LBzGHGpj89JGM
Lc7bCxZ7SF/BERqZ2PnH3qg+2rHknlEL2CEyYjssvcKeGEX0YEjmVb1Kckyyhnp5
PSMM85wWvrw=
=wuM/
-----END PGP SIGNATURE-----

--Sig_/cVIp+0C9XaqYn7VAAlqsX/E--
