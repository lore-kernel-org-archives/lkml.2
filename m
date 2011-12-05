Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab1LESgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:36:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49754 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756446Ab1LESgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:36:13 -0500
Date: Tue, 6 Dec 2011 05:35:58 +1100
From: NeilBrown <neilb@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <tom.leiming@gmail.com>, Chen Peter-B29397 <B29397@freescale.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "hzpeterchen@gmail.com" <hzpeterchen@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>
Subject: Re: [PATCH 1/1] driver core: disable device's runtime pm during
 shutdown
Message-ID: <20111206053558.5430d7f1@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1112051100150.5138-100000@iolanthe.rowland.org>
References: <CACVXFVOc45HL_qPHvNcGrkcQ7XWxBoLHikrYd1ZrRMYkiw5=ag@mail.gmail.com>
	<Pine.LNX.4.44L0.1112051100150.5138-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/g.jBTcONQeth3uYdN8ooD_b"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/g.jBTcONQeth3uYdN8ooD_b
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Dec 2011 11:02:38 -0500 (EST) Alan Stern
<stern@rowland.harvard.edu> wrote:

> On Mon, 5 Dec 2011, Ming Lei wrote:
>=20
> > Sorry, the above is line wrapped badly, see the below:
> >=20
> > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > index d8b3d89..96b266c 100644
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
> > @@ -1743,8 +1743,9 @@ void device_shutdown(void)
> >  		 */
> >  		list_del_init(&dev->kobj.entry);
> >  		spin_unlock(&devices_kset->list_lock);
> > -		/* Disable all device's runtime power management */
> > -		pm_runtime_disable(dev);
> > +
> > +		/* put device into active state and forbit runtime pm */
> > +		pm_runtime_forbid(dev);
> >=20
> >  		if (dev->bus && dev->bus->shutdown) {
> >  			dev_dbg(dev, "shutdown\n");
>=20
> We don't want to put devices into the active state when it's not=20
> necessary.  A better approach would be:
>=20
> 		/* Don't allow any more runtime suspends */
> 		pm_runtime_get_noresume(dev);
> 		pm_runtime_barrier(dev);
>=20
> Alan Stern

That sounds like a reasonable approach if we really need to do something at
this level.  But is this the only place that ->shutdown methods are called
from?  If they are called from elsewhere, would those places need the
same pm_runtime protection?

BTW I was wrong when I said that only calling pm_runtime_disable if there w=
as
a ->shutdown function would not work for me. i.e. the following patch does
solve my particular issue (though I'm not sure it is "right").
I was getting confused by the two different devices: the i2c device and the
platform device.
The i2c device has a ->shutdown which does nothing, but doesn't need to wake
up.
The platform device is the one which needs to wake up, but it doesn't have a
->shutdown function is this patch causes it not have pm_runtime disabled.

Thanks,
NeilBrown

diff --git a/drivers/base/core.c b/drivers/base/core.c
index d8b3d89..b9aa5d2 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1743,13 +1743,13 @@ void device_shutdown(void)
 		 */
 		list_del_init(&dev->kobj.entry);
 		spin_unlock(&devices_kset->list_lock);
-		/* Disable all device's runtime power management */
-		pm_runtime_disable(dev);
=20
 		if (dev->bus && dev->bus->shutdown) {
+			pm_runtime_disable(dev);
 			dev_dbg(dev, "shutdown\n");
 			dev->bus->shutdown(dev);
 		} else if (dev->driver && dev->driver->shutdown) {
+			pm_runtime_disable(dev);
 			dev_dbg(dev, "shutdown\n");
 			dev->driver->shutdown(dev);
 		}

--Sig_/g.jBTcONQeth3uYdN8ooD_b
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt0PDjnsnt1WYoG5AQI/ng/+JAmHr6qq8Lj5qCvdIHixZZJhfZMDpFHh
s59w6FjcE/PkYHmrXdzpJUfdNcCJ8YjE4g1x80eixFhyyGiEdW49pyV5JtE6Z9Ry
N+V0SjrQ24XdU5MQ1+WdwQjZibN4llYXDebTPulmRzghG07AAx1f5MoWPCmcespO
u/06whQpUyUVhUgeLiXUGEOfVCmusyHtOTl7xdz1imVnIuWENJ4Oecnxt8Fz4zCz
+H2l2jHuChKv0JoDlRkiixbKHOJfkP3pJtW+By63U1IJLxEgzmPCtvIMooQ1VGU7
uXa6eSUyCcUFiVau2rb4q1FD4Eg2PJ7RFQdWIe158XqyB7ybq3vWiQshOc6s+PeW
+PE5HlfB3Y9FATMP+c7fN8wsS/ymVhJYqYPVR6opm5v5ymyw03+iyZUhzY0DMeI+
lhRaEm6yqDugBdnuKm4XYyvIYyrJqtTi0sGNBeujjlKHeD1c4i9h+Tk/nc8lJ+Lv
qD2ieSfj1NOPs0CnpJ2UPVy/8os6sT74wXtwgQML3xPmM9w6F2wDEFwlbeHMWdSC
eT8rfV2vHq6LwrzEUm6bS9qi206aSbiMIH+siPQm+/9pfEEYpM+VuRB4+mB5nho3
0Ce03DpgHjNlxrwdu3YWa/UKujZ0Pz3EfzfA1aQG4wy7uv8BpgUSg9k3ErV0bsAr
hIymBI5yZ00=
=Klq3
-----END PGP SIGNATURE-----

--Sig_/g.jBTcONQeth3uYdN8ooD_b--
