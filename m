Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab1LDVoD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 16:44:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43419 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab1LDVoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 16:44:00 -0500
Date: Mon, 5 Dec 2011 08:43:42 +1100
From: NeilBrown <neilb@suse.de>
To: NeilBrown <neilb@suse.de>
Cc: Igor Grinberg <grinberg@compulab.co.il>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] MFD: TWL: add power off functionality
Message-ID: <20111205084342.43776420@notabene.brown>
In-Reply-To: <20111204215859.695b31aa@notabene.brown>
References: <1321177790-5886-1-git-send-email-grinberg@compulab.co.il>
	<4ED205F9.3070908@compulab.co.il>
	<20111203123516.5ebb057b@notabene.brown>
	<4EDB43DC.2050000@compulab.co.il>
	<20111204215859.695b31aa@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/riZ0cjETXiQ5pNZCCc2Vhb="; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/riZ0cjETXiQ5pNZCCc2Vhb=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 4 Dec 2011 21:58:59 +1100 NeilBrown <neilb@suse.de> wrote:

> On Sun, 04 Dec 2011 11:56:44 +0200 Igor Grinberg <grinberg@compulab.co.il>
> wrote:
>=20
> > Hi Neil,
> >=20
> > On 12/03/11 03:35, NeilBrown wrote:
> > > On Sun, 27 Nov 2011 11:42:17 +0200 Igor Grinberg <grinberg@compulab.c=
o.il>
> > > wrote:
> > >=20
> > >> ping!
> > >=20
> > > pong ...
> > >=20
> > >=20
> > > Hi,
> > >  I've been trying this patch out on my GTA04 with 3.2-rc4 and it does=
n't
> > >  work :-(
> >=20
> > Probably, v3.2-rc4 is not the best to try things out...
> > This patch is based on v3.1, can you try v3.1, so at least we can
> > check the that the patch itself has no problems?
> > Also, CC'ing linux-omap.
>=20
> I think I'll be able to give 3.1 a try - I'll let you know.
>=20

Yes, works fine with 3.1


I've managed to find the problem.

commit af8db1508f2c9f3b6e633e2d2d906c6557c617f9
Author: Peter Chen <peter.chen@freescale.com>
Date:   Tue Nov 15 21:52:29 2011 +0100

    PM / driver core: disable device's runtime PM during shutdown
=20
....

@@ -1742,6 +1743,8 @@ void device_shutdown(void)
                 */
                list_del_init(&dev->kobj.entry);
                spin_unlock(&devices_kset->list_lock);
+               /* Disable all device's runtime power management */
+               pm_runtime_disable(dev);
=20
                if (dev->bus && dev->bus->shutdown) {
                        dev_dbg(dev, "shutdown\n");



Removing this call allows power-off to work.

It seems that omap_i2c.1 is normally in runtime suspend.
omap_i2c_xfer wakes it up, performs the xfer, then puts it back to sleep.

So this pm_runtime_disable is called while the device is asleep, so it stays
asleep.  omap_i2c_xfer cannot wake it up and so cannot xfer anything.

I'll start a new thread including the people responsible for that patch.

Thanks for your time,
NeilBrown

--Sig_/riZ0cjETXiQ5pNZCCc2Vhb=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtvpkznsnt1WYoG5AQKGVQ//Yich3zDkql18C0cKp2bwcTzgDcwaicqH
vMQevZdVyrDBVrkoOW5oiV1eZuXzW5tqrk/aMh5GHq6vx9hBjoNrIc6fO3CD8mif
viZJxxJgeWA+GQU+b8en56l18Xg80mQDIPKe+87bV4DvZA3MdRNi7vSoJ/q3/FHM
vY2odwjE5ylKZB69buDBQCircElHaW5rOR7iS6Mjy1RNB7JLYUH0uUsTuo0UEKa8
QvqWSHeI65LCaIhiI5BpJ3mBvz7BgMdFGRL/cIJ+ylRXAEqmqpAcTS0tP55Ttw8t
97d9eps4tpWF9qlnxvVU11tuFM9j1oSHjAknNJ08748Kb/Ot9913zvOEmzE3Nym7
m3QNXNTW7B8NuJ5tz28M7SfFbMBIgNA07cMdYpbH4vXe8jzoSzRQu3Tue5uOVWuC
SLr7HqZNfKtcvZw4f++D7uGAqLs/Knt6FUFJZi7lIF2DgPRpc2N7IcxIEBASfGya
w6YoYpprEWEI0fo9bE4P8rWuybeK434nJgqINNJa/SiJgRt65MJ4Gt+cqcBGbrz9
FvdpAQN3uslh6QC5GJbwioek0qKKEQ9VSlU1ffinAVzYJFZPYzZyvrO97QD49odt
c32RrNsrZo+VJatCLArmVtabykCoAveSgRWWuDLCJhdJ2SedA2sq4u0L9InX+T8M
2AikQy2avnY=
=T40c
-----END PGP SIGNATURE-----

--Sig_/riZ0cjETXiQ5pNZCCc2Vhb=--
