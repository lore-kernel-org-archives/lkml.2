Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033Ab1LEFJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 00:09:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab1LEFJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 00:09:44 -0500
Date: Mon, 5 Dec 2011 16:09:25 +1100
From: NeilBrown <neilb@suse.de>
To: Chen Peter-B29397 <B29397@freescale.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "hzpeterchen@gmail.com" <hzpeterchen@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>
Subject: Re: [PATCH 1/1] driver core: disable device's runtime pm during
 shutdown
Message-ID: <20111205160925.753d7e22@notabene.brown>
In-Reply-To: <35AB98346D25394A9354ED89C4D76587228E65@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1321231380-11631-1-git-send-email-peter.chen@freescale.com>
	<201111142327.37524.rjw@sisk.pl>
	<20111115005951.GB26360@kroah.com>
	<201111160016.09174.rjw@sisk.pl>
	<20111205085632.5976fe96@notabene.brown>
	<35AB98346D25394A9354ED89C4D76587228E65@039-SN1MPN1-002.039d.mgd.msft.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FQwuVNXWwP0vGDXcv.HFBCJ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/FQwuVNXWwP0vGDXcv.HFBCJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Dec 2011 03:29:24 +0000 Chen Peter-B29397 <B29397@freescale.com>
wrote:

> =20
> >=20
> > Hi,
> >  this patches causes a problem for me.
> >=20
> > Specifically it makes it impossible to power-down a device which uses
> > twl4030
> > for power control on an omap3 processor.
> >=20
> > To perform the shutdown we need to send a command over the i2c bus.
> > The relevant bus is called omap_i2c.1 and this is normally in suspend
> > mode.
> > When a request is sent, omap_i2c_xfer uses pm_runtime_get_sync to wake =
it
> > up,
> > performs the transfer, then calls pm_runtime_put to let it go back to
> > sleep.
> >=20
> > So it is asleep when the new pm_runtime_disable() call is made, so it
> > stays
> > asleep, omap_i2c_xfer cannot wake it, the transfer doesn't happen and t=
he
> > system doesn't get powered off.
> >=20
> > So here is a device that should *not* have pm disabled at shutdown.
> >=20
> > So I feel this fix is a little too heavy-handed.
> > I don't fully understand the problem scenario described above but it
> > seems to
> > me that if the auto-suspend timer can fire after the hardware has been
> > shut
> > down, then maybe the hardware-shutdown should be disabling that timer.
> > Maybe?
> >=20
> Oh, I am sorry to cause your problem. I think it may not be easy to handl=
e this
> kinds of problem well.=20
>=20
> In my opinion, it is better to handle shutdown/suspend SYNC at device dri=
vers.
> Since the pm core is hard to know driver's shutdown is finished, and vice=
 versa.
>=20
> 1. Driver needs to has relationship between suspend/shutdown, like usb ho=
st,
> hcd needs to know downstream port's suspend, and usb core needs to know h=
cd's shutdown.=20
>=20
> 2. At driver's shutdown
> static void xxx_driver_shutdown(struct platform_device *pdev)
> {
> 	if (supports_autosuspend(&pdev->dev) {
> 		pm_runtime_cancel_pending(&pdev->dev);
> 		wait_xxx_driver_suspend(pdev); /* need to sync with driver's suspend */
> 	}
> 	real_shutdown();	=09
> }
>

I think that makes sense to me.
It might be reasonable to call pm_runtime_barrier() in device_shutdown() to
make it a bit easier for the ->shutdown function, but the final
synchronisation should probably happen right there where you suggest.

It seems that driver->shutdown() is called from other places than just
device_shutdown(). If a ->driver_shutdown function was allowed to assume th=
at
pm_runtime has been disabled, all of those call points would need to disable
pm_runtime, which doesn't seem like the right way to go.

Thanks,
NeilBrown



Thanks,
NeilBrown

--Sig_/FQwuVNXWwP0vGDXcv.HFBCJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtxSCjnsnt1WYoG5AQJPcg/+N2b6kF5hCnrhsJvmhID6dHcyepr1FHEm
ERijRgsMqfW54PeLHW1TDR+sVuSisHbtmXNLTI0xIDr19gqs2v/rq8Stx7oglW3Y
iNly1OL9uwZ6qANvDhWnkFKx8i99+3NZXxyxGZTSLErUNIVCXr5QQI0n1sDijGTo
fM1m2ex1w+rA6MIYzl5FhfqEqfLwWnBkZP8jHarBETWVOs3W9PI/Oigd2H8XjH+1
EBlEvCRUVHygzB63v+YdzJ2YLIl+BZbo+r37lVGi1rmuRkd9iPr8agAae5z+J2Sn
84f+SVO4MHI0NVMmtDLjZcVvMs/Ow07WtvvyVOjG3XU3FSYa9scNWIkgEteC7/Qg
7EMl/RDnvQDL4mhOxVZkKRerQLQCr9bg/U/Q6nptg8zQhpU0fBSxkpM3M2lazVwE
+BjSOm6u54jAs/FBontZQ9U7LO8U4k6G+8i3/Tlzac63vreqqM+QvsPOTteuLukp
yIXiHQGPiN82OeLTrLe5BAF4oHyz/DpRaYlpJeC0ckpdKOkcbCX5U8VeDg9mAf6z
2iHzAXVYrdQZAx4YfdnH40hnoV7HvVrZyHgXCfOfhm7GNpdYKOils1SF1BDNchF6
jNQ+RvMn45eNX1lCVWvUmXaWYG3+gFLiB1zhmAxPS7odwmSTLWTDj2i4sBGO0Glx
Uev96u3xcUg=
=seSA
-----END PGP SIGNATURE-----

--Sig_/FQwuVNXWwP0vGDXcv.HFBCJ--
