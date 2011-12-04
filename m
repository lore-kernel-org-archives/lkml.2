Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab1LDV4w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 16:56:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031Ab1LDV4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 16:56:51 -0500
Date: Mon, 5 Dec 2011 08:56:32 +1100
From: NeilBrown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>, Peter Chen <peter.chen@freescale.com>,
        gregkh@suse.de, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        stern@rowland.harvard.edu, hzpeterchen@gmail.com,
        Igor Grinberg <grinberg@compulab.co.il>
Subject: Re: [PATCH 1/1] driver core: disable device's runtime pm during
 shutdown
Message-ID: <20111205085632.5976fe96@notabene.brown>
In-Reply-To: <201111160016.09174.rjw@sisk.pl>
References: <1321231380-11631-1-git-send-email-peter.chen@freescale.com>
	<201111142327.37524.rjw@sisk.pl>
	<20111115005951.GB26360@kroah.com>
	<201111160016.09174.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3AlLKqqpRm91cThetDg_AFz"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3AlLKqqpRm91cThetDg_AFz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Nov 2011 00:16:08 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday, November 15, 2011, Greg KH wrote:
> > On Mon, Nov 14, 2011 at 11:27:37PM +0100, Rafael J. Wysocki wrote:
> > > On Monday, November 14, 2011, Peter Chen wrote:
> > > > There may be an issue when the user issue "reboot/shutdown" command=
, then
> > > > the device has shut down its hardware, after that, this runtime-pm =
featured
> > > > device's driver will probably be scheduled to do its suspend routin=
e,
> > > > and at its suspend routine, it may access hardware, but the device =
has
> > > > already shutdown physically, then the system hang may be occurred.
> > > >=20
> > > > I ran out this issue using an auto-suspend supported USB devices, l=
ike
> > > > 3G modem, keyboard. The usb runtime suspend routine may be scheduled
> > > > after the usb controller has been shut down, and the usb runtime su=
spend
> > > > routine will try to suspend its roothub(controller), it will access
> > > > register, then the system hang occurs as the controller is shutdown.
> > > > Signed-off-by: Peter Chen <peter.chen@freescale.com>
> > >=20
> > > Greg, do you want me to take this one?
> >=20
> > Please do:
> > 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
>=20
> Done, thanks!
>=20

Hi,
 this patches causes a problem for me.

Specifically it makes it impossible to power-down a device which uses twl40=
30
for power control on an omap3 processor.

To perform the shutdown we need to send a command over the i2c bus.
The relevant bus is called omap_i2c.1 and this is normally in suspend mode.
When a request is sent, omap_i2c_xfer uses pm_runtime_get_sync to wake it u=
p,
performs the transfer, then calls pm_runtime_put to let it go back to sleep.

So it is asleep when the new pm_runtime_disable() call is made, so it stays
asleep, omap_i2c_xfer cannot wake it, the transfer doesn't happen and the
system doesn't get powered off.

So here is a device that should *not* have pm disabled at shutdown.

So I feel this fix is a little too heavy-handed.
I don't fully understand the problem scenario described above but it seems =
to
me that if the auto-suspend timer can fire after the hardware has been shut
down, then maybe the hardware-shutdown should be disabling that timer.  May=
be?

Suggestions?

Thanks,
NeilBrown

--Sig_/3AlLKqqpRm91cThetDg_AFz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtvskDnsnt1WYoG5AQIzew//RbE0XmcA2KfdNr9HdMlULob/MnJA5J4Z
gODvdQEnBPEibH6qXGuW7SMPAx5if0xOoddpDlmQujx6OZ6o3J5iKwehFFrX+Ei+
9pQr7SlKqTFYzuOFejXkNbGfs378rMIkEkcNBt9Jw0taDva7VgRgBZ5N/ivcz69i
lSykq0DsFH8aH1iNAt4VP0l45aMXfpCtQCrXV4bRPTLrnSEHQyzQFM2uKcxbhbUb
3+mNk5OwjsuCfc++Jh0AaiLrIb8yFZRKwEs6C4mWgebh5YaiNDTOJln2znvdvwp0
JDsBNKMx4hzyxCH4Q/kaOKyx8/3whqhfcOYYe6OwVVY/HUS4haf2xEKTuUnvtZxm
sidhymYeHkvi9ls0pepLrURbBpxIgcHx9QZzK+mOf9Se5rG34Jwu0iM1QPvMKlir
f6dL6Vxpqok9PF2puED5xZGTLHFNGnjgxixiweeeVt/XF8wWd+5pGSH/E/IR/8rZ
vy0tzA5w9Lhl6HKeehIXuZcnUscJFR6vQsPjxcbJaPTgKTiLE/iR5TiuPQiW5jkJ
NIz2HGCrYTG1ZbxsYh5G43l3YoZ+G08yxtU0VWs4+PHW9BcwiGSQ7GPALU01ZLAP
yYLKg9tbG28cw1D5b6dX5yRYrdhbHId4SjMfedDXcVn6CQ+TglytKc9TdWkulzMm
3wxmCZNQNTk=
=fiNd
-----END PGP SIGNATURE-----

--Sig_/3AlLKqqpRm91cThetDg_AFz--
