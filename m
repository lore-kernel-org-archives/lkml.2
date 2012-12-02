Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2LBIqq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 03:46:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43341 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab2LBIqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 03:46:45 -0500
Date: Sun, 2 Dec 2012 19:46:25 +1100
From: NeilBrown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lkml <linux-kernel@vger.kernel.org>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH] PM / SDIO: Use empty system suspend/resume callbacks at
 the bus level (was: Re: Recent ...)
Message-ID: <20121202194625.5d66e239@notabene.brown>
In-Reply-To: <201203260029.24826.rjw@sisk.pl>
References: <20120325203849.7a908e32@notabene.brown>
	<201203252325.37478.rjw@sisk.pl>
	<20120326084515.0fd3ee7f@notabene.brown>
	<201203260029.24826.rjw@sisk.pl>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/92Ftmkv5wHEDBN_H5v/QMqo"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/92Ftmkv5wHEDBN_H5v/QMqo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Mar 2012 00:29:24 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:


> Thanks for the confirmation.
>=20
> Below it goes again with a changelog and tags.
>=20
> I don't really think that SDIO does the right thing here overall, but tha=
t's
> all I can do to address the problem timely.
>=20
> Thanks,
> Rafael

Hi Rafael,
 I just discovered that this patch has since been reverted - with an 'ack'
 from you:
----------
commit d8e2ac330f65bcf47e8894fe5331a7e8ee019c06
Author: Thierry Reding <thierry.reding@avionic-design.de>
Date:   Thu Aug 9 09:32:21 2012 +0000

    mmc: sdio: Fix PM_SLEEP related build warnings
   =20
    Power management callbacks defined by SIMPLE_DEV_PM_OPS are only used if
    the PM_SLEEP Kconfig symbol has been defined. If not, the compiler will
    complain about them being unused. However, since the callback for this
    driver doesn't do anything it can just as well be dropped.
   =20
    Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Chris Ball <cjb@laptop.org>
-----------

Unsurprisingly the problem which your patch fixed has come back.

Do you think we could get the patch back in again.  This time maybe we shou=
ld
put some comments in there pointing out that having a function which does
nothing is very different from not having any function at all?

Thanks,
NeilBrown


>=20
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / SDIO: Use empty system suspend/resume callbacks at the bus =
level
>=20
> Neil Brown reports that commit 35cd133c
>=20
>    PM: Run the driver callback directly if the subsystem one is not there
>=20
> breaks suspend for his libertas wifi, because SDIO has a protocol
> where the suspend method can return -ENOSYS and this means "There is
> no point in suspending, just turn me off".  Moreover, the suspend
> methods provided by SDIO drivers are not supposed to be called by
> the PM core or bus-level suspend routines (which aren't presend for
> SDIO).  Instead, when the SDIO core gets to suspend the device's
> ancestor, it calls the device driver's suspend function, catches the
> ENOSYS, and turns the device off.
>=20
> The commit above breaks the SDIO core's assumption that the device
> drivers' callbacks won't be executed if it doesn't provide any
> bus-level callbacks.  If fact, however, this assumption has never
> been really satisfied, because device class or device type suspend
> might very well use the driver's callback even without that commit.
>=20
> The simplest way to address this problem is to make the SDIO core
> tell the PM core to ignore driver callbacks, for example by providing
> no-operation suspend/resume callbacks at the bus level for it,
> which is implemented by this change.
>=20
> Reported-and-tested-by: Neil Brown <neilb@suse.de>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
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


--Sig_/92Ftmkv5wHEDBN_H5v/QMqo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBULsVYjnsnt1WYoG5AQIebA/+MliuCFpKwaUK6/lrbQrLshiq5WPjeogC
9c/U2+oM/zxfLXpwDIDqjUFJksfK9HxXPmVCT5DF6MLU+Vk7rCceb0jdbSuw37Go
s2cwBnkOU94WSjAOI310oqdQ/ZY8/RUwMO6uvgqdBkeDEz+EP0AWgTfxMetUCmJ5
xSLPXbVNgfill7w4v5GN1asMPi0+F0+ETOMRjKM1zifx2nBnjmcxa9Dbhr6cF/uL
ZRZO59oaHygpSFd7MkCBpsr4vWvVbERyDqIxO7bqU587ezU9cUIsldQ66Z3KM/vE
Ur6f7WEjuSW3RdMvGcuFlDbQWgvcFF2lrQhVGXYukPYqx9KP27lT5UlJiWjA5TAv
MkiWud8Zid7am/W88B/Gzbe1brxv5qqD4rpaOCzGOJVLn5Es/YT27qJEYgP3qMO+
EYjAiyHieDyeK9FwZdLmi5HphGDpqia02fpoKEfUEmdJmohz6aT72pS2jTEGcxD6
ZbtZBFFXzRfZXU90in2zJuovnMdZFoRQmv1dvnGt6eHLMlphkmSGwU/3dbv5p8fJ
U0MdBAAw6O0i55XOCY9raKLax02UsiBqIgIwPpDfWCoMej98Y4URCC66ElgrnIOo
Alkkg7Hjs1wBfCa598HbHnvtc3CxOF0Fn6Doj2exr/j1z0EaFtDvi69AX0aZWwq4
ZGOpOOb+yvo=
=t6zs
-----END PGP SIGNATURE-----

--Sig_/92Ftmkv5wHEDBN_H5v/QMqo--
