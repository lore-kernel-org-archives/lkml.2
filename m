Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab1LETHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:07:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab1LETHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:07:38 -0500
Date: Tue, 6 Dec 2011 06:06:54 +1100
From: NeilBrown <neilb@suse.de>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-mmc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Daniel Drake <dsd@laptop.org>, Joe Woodward <jw@terrafix.co.uk>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH] mmc/sdio: don't allow interface to runtime-suspend
 until probe is finished.
Message-ID: <20111206060654.0e8bebe0@notabene.brown>
In-Reply-To: <CAK=Wgbb-6eV6aDxTdi3qFLZmu0cHSZvHRUpUEr3YQ=4tO5sCPw@mail.gmail.com>
References: <20111205125416.6093ecd8@notabene.brown>
	<CAK=Wgbb-6eV6aDxTdi3qFLZmu0cHSZvHRUpUEr3YQ=4tO5sCPw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AlrUhHGvZ.0DUp/WfjnurBT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/AlrUhHGvZ.0DUp/WfjnurBT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Dec 2011 12:25:42 +0200 Ohad Ben-Cohen <ohad@wizery.com> wrote:

> Hi Neil,
>=20
> On Mon, Dec 5, 2011 at 3:54 AM, NeilBrown <neilb@suse.de> wrote:
> > =A0I've been chasing down a problem with the SDIO-attached wifi card in=
 the
> > =A0GTA04 (www.gta04.org).
>=20
> 8686, right ?

yep, that's the one!

>=20
> > =A0The problem seems very similar to that described in
> >
> > =A0 =A0http://www.mail-archive.com/linux-mmc@vger.kernel.org/msg04289.h=
tml
>=20
> Don't go that far back, Joe just reported this exact problem in :
>=20
> http://comments.gmane.org/gmane.linux.kernel.mmc/11231

Indeed.

>=20
> > commit 08da834a24312157f512224691ad1fddd11c1073
> > Author: Daniel Drake <dsd@laptop.org>
> > Date: =A0 Wed Jul 20 17:39:22 2011 +0100
> >
> > =A0 =A0mmc: enable runtime PM by default
> >
> >
> > and if I revert that commit so that runtime PM is not enabled the probl=
em
> > goes away.
>=20
> And this is most likely what we're going to do, unless someone with
> the 8686 can further look into the problem.

Challenge accepted.

Even if I don't find a better solution, this seems backwards.  Sure the
default should be that PM is enabled, but individual board can request no
PM on MMC interfaces where it is a problem.

>=20
> > (The wifi chip is a libertas_sdio supported chip connected to an mmc
> > interface on an omap3, and has a separate regulator for power supply, p=
lus a
> > GPIO pin for reset, just like in the email thread. =A0The problem is
> > exemplified by:
> > [ =A0 64.643981] libertas_sdio: probe of mmc1:0001:1 failed with error =
-16
> > ).
>=20
> Yes, the same issue that Joe is seeing.
>=20
> > I finally managed to track down exactly what was happening - runtime PM=
 was
> > putting the interface to sleep before the SDIO functions were probed so
> > initialising them failed.
>=20
> Yeah, but the question is why it fails.

The chip has a requirement that the reset line is held down during power-on,
and raised shortly after (I don't know exactly how short).  So if you just
remove power and give it back, the chip doesn't come up properly.

>=20
> It's perfectly fine to power the card down before the functions are
> probed, because just before they are probed the bus is responsible to
> power the card up again.

"It *should be* perfectly fine ..." :-)

We just have to make sure the bug powers up the card properly.
Maybe I need to create a virtual regulator that powers on the real regulato=
r,
then raises the reset line.  I wonder how hard that is.


>=20
> > From: NeilBrown <neilb@suse.de>
> > Date: Mon, 5 Dec 2011 11:34:47 +1100
> > Subject: [PATCH] mmc/sdio: don't allow interface to runtime-suspend unt=
il probe is finished.
>=20
> You can't tell when probe is finished. In fact, in can happen very far
> in the future or even never at all (e.g. when the function driver
> isn't loaded).

Ahhh... I naively assumed that=20

	/*
	 * ...then the SDIO functions.
	 */
	for (i =3D 0;i < funcs;i++) {
		err =3D sdio_add_func(host->card->sdio_func[i]);
		if (err)
			goto remove_added;
	}

would add all the functions.  but as you say: the drivers might not be load=
ed
yet.


>=20
> > mmc_attach_sdio currently enables runtime power management on
> > the mmc interface before it completes the probe of functions.
> > This means that it might be asleep during the probe and the probe
> > will fail.
>=20
> No - the sdio bus powers the card up before probing the drivers. See
> sdio_bus_probe.
>=20
> > In particular, if 'drivers_autoprobe' is enabled on the mmc bus, then
> > device_attach() will be called by bus_probe_device() from device_add()
> > and it will pm_runtime_get_noresume()/pm_runtime_put_sync().
> >
> > As runtime power management this the device is running
> > (pm_runtime_set_active() in mmc_attach_sdio()) and rtpm is enabled
> > (pm_runtime_enable()), the pm_runtime_put_sync() call puts the mmc
> > interface to sleep,
>=20
> This is fine
>=20
> > so function probing fails.
>=20
> The question is why. Again - sdio_bus_probe should power up the card.
> For some reason, it (or something else) fails to do so with the 8686
> on some setups. Other chips might have similar issues, too - we just
> don't know (all we know is that it works great with the wl12xx, and
> with the Daniel's 8686 setup).
>=20
> > So this patch moves the call to pm_runtime_enable to after all the
> > calls to sdio_add_func.
>=20
> Looks like this will have the undesired side-effect of keeping the
> chip powered up, even if it doesn't have any driver loaded for it.
>=20
> And this doesn't really address the problem: we still don't know why
> the 8686 fails to power up at this point.
>=20
> Can you please tell us where exactly is the first failure coming from
> ? is this from libertas own probe function ? is this sdio_bus_probe
> getting an error from calling pm_runtime_get_sync ?
>=20
> Thanks,
> Ohad

I'll spend some more time on this and get back to you - probably next week.

Thanks for the hints and perspective.

NeilBrown

--Sig_/AlrUhHGvZ.0DUp/WfjnurBT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt0WTjnsnt1WYoG5AQKPxA/+NO018Dfyb+bQW5Edw9Kz4dzc6zNctzTG
Gb1r6lBSlhjCU13C5AESXMGI57aDyjSaMvjtADgEFugbBCEnaoE4D1GUWmsODUYy
Ec8tEsl+RmF8PF/eMOWe4piDZIyPtHUWt84Yl8UX4lQexao4fz3UQLbg9PiYpCl1
lq+cMgpJZ7k/o9kNX0gz4fdNk2lK6E71L56eIr0NkzHOyctoqip0Ihf6xs2939yV
asE/kH9g33n6kdDxKhq3Bf12ksnI4a0cXFHpFagxEU8AR3qk1GjEsTmzf1rdpjJH
0wJS0mMFOzCORFb1bYdPPYFa6XbD2AV+DjLku/oTTf6nFETvt6Hj7R8OInX3yqa7
+1ov+EJGr5ckEhPZouz7Id9bQiZE3SS5kHglu30mcc95g6g+/PW13wx6c847j588
I8TwjCJbYbLLVc/I/UVItXyS2gjQGrMb6dmuiIHXLKq8Z2y5JXQIBSI6zs+qV+hZ
WgOaBPkk0hqBogsftGtP2OW3s63XhJfmwCLZ1+XDi1VsOFqTwvy7iS3Xb9DRggx3
lx11UpYVia1EM51gcVrcIjmpSXiJCJleHqbwUtiwz4sNU5ys2MJ4hNE6c7MjCggc
j0OHemGOYHpBMVS/zQ/yvXYRMCzUi04gNqgjorqf2sc1fGkPaxf2D42HYB+4oP/Y
zwYkAdri8sg=
=9KJb
-----END PGP SIGNATURE-----

--Sig_/AlrUhHGvZ.0DUp/WfjnurBT--
