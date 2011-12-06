Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab1LFVfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 16:35:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974Ab1LFVfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 16:35:01 -0500
Date: Wed, 7 Dec 2011 08:34:46 +1100
From: NeilBrown <neilb@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ming Lei <tom.leiming@gmail.com>,
        Chen Peter-B29397 <B29397@freescale.com>, Greg KH <greg@kroah.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        "hzpeterchen@gmail.com" <hzpeterchen@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>
Subject: Re: [PATCH] Driver core: leave runtime PM enabled during system
 shutdown
Message-ID: <20111207083446.6ad6aa02@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1112061024240.1469-100000@iolanthe.rowland.org>
References: <201112052332.10822.rjw@sisk.pl>
	<Pine.LNX.4.44L0.1112061024240.1469-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qX.H.KbRet==tzqLA4Ax7iv"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qX.H.KbRet==tzqLA4Ax7iv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Dec 2011 10:26:14 -0500 (EST) Alan Stern
<stern@rowland.harvard.edu> wrote:

> Disabling all runtime PM during system shutdown turns out not to be a
> good idea, because some devices may need to be woken up from a
> low-power state at that time.
>=20
> The whole point of disabling runtime PM for system shutdown was to
> prevent untimely runtime-suspend method calls.  This patch (as1504)
> accomplishes the same result by incrementing the usage count for each
> device and waiting for ongoing runtime-PM callbacks to finish.  This
> is what we already do during system suspend and hibernation, which
> makes sense since the shutdown method is pretty much a legacy analog
> of the pm->poweroff method.
>=20
> This fixes a regression on some OMAP systems.
>=20
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Reported-by: NeilBrown <neilb@suse.de>
> CC: Chen Peter-B29397 <B29397@freescale.com>
>=20
> ---
>=20
>  drivers/base/core.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> Index: usb-3.2/drivers/base/core.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb-3.2.orig/drivers/base/core.c
> +++ usb-3.2/drivers/base/core.c
> @@ -1743,8 +1743,10 @@ void device_shutdown(void)
>  		 */
>  		list_del_init(&dev->kobj.entry);
>  		spin_unlock(&devices_kset->list_lock);
> -		/* Disable all device's runtime power management */
> -		pm_runtime_disable(dev);
> +
> +		/* Don't allow any more runtime suspends */
> +		pm_runtime_get_noresume(dev);
> +		pm_runtime_barrier(dev);
> =20
>  		if (dev->bus && dev->bus->shutdown) {
>  			dev_dbg(dev, "shutdown\n");


Thanks a lot.
I can confirm that this definitely fixes my problem.
  Tested-by: NeilBrown <neilb@suse.de>

Thanks for your help!

NeilBrown

--Sig_/qX.H.KbRet==tzqLA4Ax7iv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt6Kdjnsnt1WYoG5AQLKTw//dAkNcpdC6jyHCEQ1Enpv/vQgyxgmDAEa
VuM/R6lNBI4Nc0vSFKVuLIQ28zojgV/8hpR0LIWumSFYGcbaS71sI6MaCm0lq+sN
6zt9BdtRAa/eamRgpDo7a2HYm0pQ7nshOt3Msex6fYrnau5kUAfSZkWFV9xE5PTh
y7a67wPuk2YtMvhNQDCQlQgISbMaZMBl7qLcVhQJprEj4fNzhWw/CB/JTksYAbHz
57GMyIQiXQ0dKuC4TeDzNzVX+0VAA8dLTws9kbbndWSHLhY4VFdG/VP0OF2oSe/O
SBkIq09KhFfHss7MNG8PUsW5j5cBlYu5y8g3F0XQV5vAf7TftZTTNDWHpfce8qFH
kw8WZ4EOCmxNu0WNrH9QnozdkGsyykdEgasBklbHVxL+fVvghUn3tjsLQXlnViva
/qCVH3vh8RszRzoqPnRT4AW05g9MZcwpCvwsyGMAVty+sGlyWP/UASppxBm3shB/
JWzTNmOCcCWFHW+VUqNQvpl8E4KBNgFKc8eaWRquRv8qlX7LW/aT9Yy+aEBM2DmY
KM+c0Bs1T+6cpWs+4XmLL9lfBxUZlyM/1XlMPqzCW0nur9+Gpu1VUSn4fMsvR+O4
4sKhce75BLQylvd5YIGzgo/8oXb69Fv6EhKjAJGfKTFfzhC1zh+d1O6Bk/fLo7NX
UzkcOiRC3XY=
=jetS
-----END PGP SIGNATURE-----

--Sig_/qX.H.KbRet==tzqLA4Ax7iv--
