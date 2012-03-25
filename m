Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab2CYVpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 17:45:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab2CYVp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 17:45:29 -0400
Date: Mon, 26 Mar 2012 08:45:15 +1100
From: NeilBrown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
Subject: Re: Recent "Run the driver callback directly" patch breaks libertas
 suspend
Message-ID: <20120326084515.0fd3ee7f@notabene.brown>
In-Reply-To: <201203252325.37478.rjw@sisk.pl>
References: <20120325203849.7a908e32@notabene.brown>
	<201203252309.48705.rjw@sisk.pl>
	<201203252325.37478.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YzUZXXf=lu0rKQdlV6obywa"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/YzUZXXf=lu0rKQdlV6obywa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 25 Mar 2012 23:25:37 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday, March 25, 2012, Rafael J. Wysocki wrote:
> > Hi,
> >=20
> > On Sunday, March 25, 2012, NeilBrown wrote:
> > >=20
> > > Hi Rafael,
> > >=20
> > >  Your recent patch:
> > >    commit 35cd133c
> > >    PM: Run the driver callback directly if the subsystem one is not t=
here
> > >=20
> > >  breaks suspend for my libertas wifi and probably other SDIO devices.
> >=20
> > Well, the patch is not recent.  The _commit_ is more than three months =
old
> > and the patch has been around since the last November (at least).
> >=20
> > >  SDIO (and possible MMC in general) has a protocol where the suspend
> > >  method can return -ENOSYS and this means "There is no point in suspe=
nding,
> > >  just turn me off".
> > >
> > >  The device itself "mmc1:0001" (I think) doesn't have any bus etc 'su=
spend'
> > >  function so the new code call the device's suspend function which re=
turns
> > >  ENOSYS and the suspend fails.
> > >=20
> > >  The previous code ignores the device as there is no bus suspend, and=
 when it
> > >  gets to suspend the ancestor - which for me is omap_hsmmc.1, it call=
s the
> > >  device suspend function catches the ENOSYS, and turns it off.
> >=20
> > Well, I can only call that a blatant abuse of the PM infrastructure.
> >=20
> > >  I suspect just reverting it isn't the right long term solution, howe=
ver I
> > >  can confirm that it works for me for now.
> >=20
> > It's not a solution at all, because there's code that depends on it alr=
eady in
> > the tree and the fact that it works for you doesn't mean it won't break=
 other
> > systems.  So no, it's not an option.
> >=20
> > >  I'm happy to try any alternate fixes you would like to suggest (but =
I cannot
> > >  promise how quickly I will get the testing done).
> > >=20
> > >  (I'm testing with 3.3)
> >=20
> > The only fix I can think of is to rework SDIO to stop abusing the PM ca=
llbacks.
> > I'll have a look at that next week, although I can't promise anything a=
ny time
> > soon, because I'm heading to San Francisco on Saturday.
>=20
> Well, this is kind of a long shot, but I wonder if the patch below makes
> any difference?

Hi Rafael,
 thanks for looking into this so quickly.

I removed the revert and applied this patch instead and can confirm that
suspend completes now (and resume works and the wifi works after resume).

Further, this patch fits with my (fairly shallow) understanding of the
problem.

Thanks!

NeilBrown

>=20
> Rafael
>=20
> ---
>  drivers/mmc/core/sdio_bus.c |   12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>=20
> Index: linux/drivers/mmc/core/sdio_bus.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/mmc/core/sdio_bus.c
> +++ linux/drivers/mmc/core/sdio_bus.c
> @@ -192,9 +192,15 @@ static int sdio_bus_remove(struct device
>  	return ret;
>  }
> =20
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
> +
> +static int pm_no_operation(struct device *dev)
> +{
> +	return 0;
> +}
> =20
>  static const struct dev_pm_ops sdio_bus_pm_ops =3D {
> +	SET_SYSTEM_SLEEP_PM_OPS(pm_no_operation, pm_no_operation)
>  	SET_RUNTIME_PM_OPS(
>  		pm_generic_runtime_suspend,
>  		pm_generic_runtime_resume,
> @@ -204,11 +210,11 @@ static const struct dev_pm_ops sdio_bus_
> =20
>  #define SDIO_PM_OPS_PTR	(&sdio_bus_pm_ops)
> =20
> -#else /* !CONFIG_PM_RUNTIME */
> +#else /* !CONFIG_PM */
> =20
>  #define SDIO_PM_OPS_PTR	NULL
> =20
> -#endif /* !CONFIG_PM_RUNTIME */
> +#endif /* !CONFIG_PM */
> =20
>  static struct bus_type sdio_bus_type =3D {
>  	.name		=3D "sdio",


--Sig_/YzUZXXf=lu0rKQdlV6obywa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2+R6znsnt1WYoG5AQLnxhAAq6vhBsqCPEvdZRS1NMqBGCM72z3xZunE
bbWvQioxMG4JMaRt/7jOmVQY2FO0DFr4EA6l8eGm0+EuIIKzKyoXdi2FiKfF/0Iv
UDa4MEAKg8Y7sWn6/OK3rNccLcJ1MzKt4p8HLpUVjaU/8E1S52GKugKhK+mzDkO7
o0B8hdqNJvs0gdeR49Q5SYaXtVE6BsNgiiDd59P6ALboJc1049GpZY00ZNQ6fDqy
JCoYRLFlf9FoNrugUISN1qS6dXz3kKaGcZtsBO7SHhFj3eFEhb2Vm2PosnlaF5GH
/vX6pQPFQByUK3k0oAAfXFg9PoYmX7oWMMxZTubQOoHRpGI5MiHz/CT/KkvAYt8o
1zF2QQTwVvIZZUxi4mnL/VHwFoJznZ4sVY7NSYVVjGYEi7P++EjGrgj6NakvVPfp
s9tI9w7o2qK4JGi5cUWsiTb8izsBUlgZ8JpjItkr1ZlmF9aoo5WfT/fFQ9k+ulB6
YzZwLbPzo5wVBFJ2gldx3+4xDqxku5amoOH757Uj+G73V5jeLYUV70ALlx1OzLs0
iL52jfvocz1oY+bxoPX/Wyz0KgcVZN101+xBYA/q0eYSeUjVoQTRUS3f2DEWHZPC
UR6bsDueMihe9aqfMxHNUNE3ZEIyaqQIH8yrVAQhjgEa3GSKYDiO5guLgbSLanCr
ndF6hREQHR0=
=M0aA
-----END PGP SIGNATURE-----

--Sig_/YzUZXXf=lu0rKQdlV6obywa--
