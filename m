Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1LEDhc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 22:37:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53179 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab1LEDhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 22:37:31 -0500
Date: Mon, 5 Dec 2011 14:37:17 +1100
From: NeilBrown <neilb@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
        Peter Chen <peter.chen@freescale.com>, <gregkh@suse.de>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <hzpeterchen@gmail.com>, Igor Grinberg <grinberg@compulab.co.il>
Subject: Re: [PATCH 1/1] driver core: disable device's runtime pm during
 shutdown
Message-ID: <20111205143717.13cf6015@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1112042133470.7508-100000@netrider.rowland.org>
References: <20111205085632.5976fe96@notabene.brown>
	<Pine.LNX.4.44L0.1112042133470.7508-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=x2WosILi..323Nf1zqmUct"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=x2WosILi..323Nf1zqmUct
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 4 Dec 2011 21:42:02 -0500 (EST) Alan Stern
<stern@rowland.harvard.edu> wrote:

> On Mon, 5 Dec 2011, NeilBrown wrote:
>=20
> > Hi,
> >  this patches causes a problem for me.
> >=20
> > Specifically it makes it impossible to power-down a device which uses t=
wl4030
> > for power control on an omap3 processor.
> >=20
> > To perform the shutdown we need to send a command over the i2c bus.
> > The relevant bus is called omap_i2c.1 and this is normally in suspend m=
ode.
> > When a request is sent, omap_i2c_xfer uses pm_runtime_get_sync to wake =
it up,
> > performs the transfer, then calls pm_runtime_put to let it go back to s=
leep.
> >=20
> > So it is asleep when the new pm_runtime_disable() call is made, so it s=
tays
> > asleep, omap_i2c_xfer cannot wake it, the transfer doesn't happen and t=
he
> > system doesn't get powered off.
>=20
> In other words, to perform the system shutdown you need to send a=20
> command over the i2c bus after the bus controller's shutdown routine=20
> has been called?

Correct.
Though in this case the i2c bus doesn't have a shutdown routine so it doesn=
't
cause a problem.  It is only the inability to pm_resume that is a problem.


>=20
> > So here is a device that should *not* have pm disabled at shutdown.
>=20
> Or maybe it shouldn't be shut down at all.

Maybe not.  Current 'device_shutdown()' shuts down every device.
I guess having a "don't shutdown at power-off" flag could be used to solve
the problem.

>=20
> > So I feel this fix is a little too heavy-handed.
> > I don't fully understand the problem scenario described above but it se=
ems to
> > me that if the auto-suspend timer can fire after the hardware has been =
shut
> > down, then maybe the hardware-shutdown should be disabling that timer. =
 Maybe?
>=20
> That's not robust.  The timer can be restarted, and there are other=20
> ways of initiating runtime PM besides the timer.

Still, shouldn't they notice that the hardware has been shutdown and so not
do anything?

>=20
> > Suggestions?
>=20
> Can the shutdown routine for the i2c controller simply call
> pm_runtime_enable()?

No.
The shutdown routine is in drivers/mfd/twl4030-power.c (not in mainline
currently but there are various patches floating around that add
twl4030_poweroff, and this is the obviously-correct place for the code).
It has a 'struct i2c_adapter' device.
The device that needs to have pm_runtime_enable called on it is a 'struct
platform_device' that is linked through the dev_data of the i2c_adapter.

i.e. only omap-i2c specific code knows how to find the device that needs to
be enabled.  The twl4030 code doesn't.

So even if we had a used_for_shutdown flag in dev_pm_info I don't know how =
we
would manage to set it for the right device.... unless we had a dev_pm_ops
method to ask a device to set it on all devices it depends on.  Sounds mess=
y.

Thanks,
NeilBrown

--Sig_/=x2WosILi..323Nf1zqmUct
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtw8bTnsnt1WYoG5AQLBtQ//W1b/Q9NFi8bY4FgvlszkDaTzBg89Cxh/
C2UuRIMsshzAOU9+/GeecgmnYIkpaQhikkW7hOtATL7hw0dNeK7mjnovj3FhLSwU
FldZcpY7fYQ2oLkFVwOMLXvpWWy2GDUUpJ3fBFMqLwCFMn2uk/6FfgYMkf+9KlKW
8hG9mDYq6dCfItAQRv8iLMN7oU/c9iZJQEVzyUiShZw2iHAflin7ouu6yfd5L+LY
fiCR8nZ6KdnFXyDXUYLR9hICTy/SzvNGzSk9cb1pEVxdp3mNm7AlYo2yFXvThcoh
gYvar/8jAblM/6NFUY/MJjm0rbJ+UxkN9iUVql/eboKU9PO8NS8wD04GztTd/OPL
nEVO6iFCtrGTURQVnrHrS2JiEaEM47ThDuKS52kHWo9WqXY1DH+s7xYd+inbFUh4
wQCTXli76RMLWRn7xeu/1kRUw8GBEj94qHSOewrVNr2KXpIc4rGeOY/v1GQRi1Az
5S2FC08sWA8Q+6gGUAJsBLhOugdV6cRt/uF73aRydYcc+tcOhRSQmBuGA4EhbEf8
whUOyV+2UDdBWKG3mk/Nq3yMXmoy5kxCcwmL6PwEXe0It0WP+0RAo7/nm+F0kDVx
3rNyzkZZ6NPpw7of8E2Fq3rv7RX/+sTYoS3RGMyECa9QVPm5X5rWtvgANmC6XMjF
KGk9PL33sRM=
=/vTD
-----END PGP SIGNATURE-----

--Sig_/=x2WosILi..323Nf1zqmUct--
