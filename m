Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab1LEEx6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 23:53:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998Ab1LEEx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 23:53:57 -0500
Date: Mon, 5 Dec 2011 15:53:38 +1100
From: NeilBrown <neilb@suse.de>
To: Ming Lei <tom.leiming@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
        Peter Chen <peter.chen@freescale.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        stern@rowland.harvard.edu, hzpeterchen@gmail.com,
        Igor Grinberg <grinberg@compulab.co.il>
Subject: Re: [PATCH 1/1] driver core: disable device's runtime pm during
 shutdown
Message-ID: <20111205155338.1bd658b9@notabene.brown>
In-Reply-To: <CACVXFVNkapRDJ8QkgmJCh+n1c2+7cHBiLf1ef22Nfdd8YrPpGg@mail.gmail.com>
References: <1321231380-11631-1-git-send-email-peter.chen@freescale.com>
	<201111142327.37524.rjw@sisk.pl>
	<20111115005951.GB26360@kroah.com>
	<201111160016.09174.rjw@sisk.pl>
	<20111205085632.5976fe96@notabene.brown>
	<CACVXFVNkapRDJ8QkgmJCh+n1c2+7cHBiLf1ef22Nfdd8YrPpGg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/89JkVVsS.3DMueJzQRmYo.s"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/89JkVVsS.3DMueJzQRmYo.s
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Dec 2011 11:26:40 +0800 Ming Lei <tom.leiming@gmail.com> wrote:

> Hi,
>=20
> On Mon, Dec 5, 2011 at 5:56 AM, NeilBrown <neilb@suse.de> wrote:
> >
> > Hi,
> > =A0this patches causes a problem for me.
> >
> > Specifically it makes it impossible to power-down a device which uses t=
wl4030
> > for power control on an omap3 processor.
> >
> > To perform the shutdown we need to send a command over the i2c bus.
> > The relevant bus is called omap_i2c.1 and this is normally in suspend m=
ode.
> > When a request is sent, omap_i2c_xfer uses pm_runtime_get_sync to wake =
it up,
> > performs the transfer, then calls pm_runtime_put to let it go back to s=
leep.
> >
> > So it is asleep when the new pm_runtime_disable() call is made, so it s=
tays
> > asleep, omap_i2c_xfer cannot wake it, the transfer doesn't happen and t=
he
> > system doesn't get powered off.
> >
> > So here is a device that should *not* have pm disabled at shutdown.
> >
> > So I feel this fix is a little too heavy-handed.
>=20
> Maybe the device's runtime PM should not be disabled if
> there is no ->shutdown defined in its driver, how about the blew?

Thanks, but that won't actually help.

dev->bus->shutdown is i2c_device_shutdown so there is a shutdown method.
However i2c_device_shutdown just finds the driver can calls
driver->shutdown(), and that is the 'shutdown' that is NULL.

Thanks,
NeilBrown



>=20
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index d8b3d89..ca30659 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1743,14 +1743,16 @@ void device_shutdown(void)
>  		 */
>  		list_del_init(&dev->kobj.entry);
>  		spin_unlock(&devices_kset->list_lock);
> -		/* Disable all device's runtime power management */
> -		pm_runtime_disable(dev);
>=20
> +		/* Disable the device's runtime power management if
> +		 * it is to be shutdown*/
>  		if (dev->bus && dev->bus->shutdown) {
>  			dev_dbg(dev, "shutdown\n");
> +			pm_runtime_disable(dev);
>  			dev->bus->shutdown(dev);
>  		} else if (dev->driver && dev->driver->shutdown) {
>  			dev_dbg(dev, "shutdown\n");
> +			pm_runtime_disable(dev);
>  			dev->driver->shutdown(dev);
>  		}
>  		put_device(dev);
>=20
>=20
> > I don't fully understand the problem scenario described above but it se=
ems to
> > me that if the auto-suspend timer can fire after the hardware has been =
shut
> > down, then maybe the hardware-shutdown should be disabling that timer. =
=A0Maybe?
> >
> > Suggestions?
> >
> > Thanks,
> > NeilBrown
>=20
>=20
> thanks,


--Sig_/89JkVVsS.3DMueJzQRmYo.s
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtxOUjnsnt1WYoG5AQIFnA/+O14YFmXR3xpZDLyrQX+fiQfcbkPObGHO
8eepL1jdWL65GbRfkmhDbDNW7e91tPiHg4eLvwZakfpJXVm84JFtMZyLYzeeTpU7
CrHEOwbGfzngQZrKqhCKB9Z95hwFzs9NxMDj/DzUQk7tpkhEx3xCvAfu6sFboabh
+s8v1Lta+wKcGgPP5WE+cWf/Mt52LA1eSn2qCllYHSOKpfWMl8alU1L24MUhz+ev
9gENTbU7/5LoB4drEdXhtwtK+LwPChSIbbGFkmHFesz6CHjedxT323Tz8l37m+bR
YB22+8t7D6D3NIFdRHPJ+qzT3Mt3OUW+IXH1DIRBQlwk2DZFK2MTgVfgGxfaRKD0
kFsXUkqpUj6AkhaGMw1CyyLF8vXNZo6cL5WQtd+pa+FYkESL0eQ0Wr3exs+OCDtK
89xKaBXeIiQAgUPmUrp4nuI+fzMUEt0QCVqRzVqm5xKe6eCvmAg1IzShQt0gDab4
pxNowxJPKjDeieCI6vtRQmfI2QyWfE+MDS/b1lLO+/jbbm9++HAOf2pOeLMK3AbE
XOmqEwmqwiTYqsl4pJ0XkGIRHKgd3t8q1SbhkQmKs7ucc+EYXowiuRu7JpCKQ+TY
gGleIO7Abga9/5jG1pr2MgGzd7Hse6ieNHbgLp4sp2aEJR9iO7uDDY9KfiJYEKKB
8OYzD5GLNqw=
=iBWS
-----END PGP SIGNATURE-----

--Sig_/89JkVVsS.3DMueJzQRmYo.s--
