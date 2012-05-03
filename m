Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab2ECVIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:08:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928Ab2ECVIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:08:44 -0400
Date: Fri, 4 May 2012 07:08:38 +1000
From: NeilBrown <neilb@suse.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] w1: Introduce a slave mutex for serializing IO.
Message-ID: <20120504070838.5bd23110@notabene.brown>
In-Reply-To: <20120503175857.GA13988@ioremap.net>
References: <20120425124914.3187a794@notabene.brown>
	<20120501213958.GA15560@ioremap.net>
	<20120502162627.50544c8b@notabene.brown>
	<20120503175857.GA13988@ioremap.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vD+90Bu7bXaTo6hD4PVZelb"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/vD+90Bu7bXaTo6hD4PVZelb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 3 May 2012 21:58:57 +0400 Evgeniy Polyakov <zbr@ioremap.net> wrote:

> On Wed, May 02, 2012 at 04:26:27PM +1000, NeilBrown (neilb@suse.de) wrote:
> > Take takes me back to the deadlock.
> > To be precise:
> >   while scanning the w1 bus - with master->mutex held - w1_attach_slave=
_device
> >   eventually calls into bq27000_battery_probe  which calls
> >     power_supply_register -> device_add -> kobject_uevent_env
> >=20
> >   and the to get all the data for the uevent, power_supply_uevent calls
> >   the get_property callback which tries to read from the w1 bus and so
> >   needs the master->mutex.  Which is held.  Deadlock.
> >=20
> > So options seems to be:
> >  - drop the lock while attaching slave devices
> >  - create a list of slave devices, then attach them after the bus scan =
has
> >    finished.
> >  - have device_add run the kobject_uevent in a separate task (work_queu=
e)
> >  - or maybe the following which feels ugly but is easy.  Mark the bq270=
00 as
> >    not ready until after the power_supply_register, and if get_property=
 is=20
> >    called before the device is ready, return ENODATA.
> >    Simple and works.  Maybe horrible.
> >    power_supply_register will have scheduled a power_supply_changed() w=
hich
> >    will poll
>=20
> You can check mutex owner - and if it is you who holds it, then dig into
> low-level function without lock.
>=20

Interesting idea.  However:

struct mutex {
	/* 1: unlocked, 0: locked, negative: locked, possible waiters */
	atomic_t		count;
	spinlock_t		wait_lock;
	struct list_head	wait_list;
#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
	struct task_struct	*owner;
#endif


You can only check the owner on SMP builds, or when debugging is enabled.
So I don't think that approach can work.

Thanks,
NeilBrown

--Sig_/vD+90Bu7bXaTo6hD4PVZelb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6Lz1jnsnt1WYoG5AQKGEA//cujsOHdVlWFrfYWOyGBAB1qDZia5riMn
s4jYFVTGAsTQaohwtwhsdxAGV86dLfE0uK/IFhgL66lGWmZagbaiKitopJAS/L1X
huCHE+cstho6E+RLDXxudsvQiJKGPD+Yb7Cn8j+pEObqPBqp5BUoT61AGuW+n/jQ
XH2icnPgZ766SIgFi9nV1WxIANjBPHwnfWLRoY/Wi5jPyUMZDXa8ooOCBhYF16tl
CDrChoCKlfFs8PUrmmh0C0ylmdByZW7lAn1Mvs3UX+JijObbE9B9zoJ9Nm9CQIS5
eSQJgIyZPByT3BRhZfAjdi/yF8cDlGhcia9fPUSBcNqThIleAAv1qIoLBCNvme2q
QEbTnpRhFHWr/REIFsuXgdaC0mpPMrsCu3gHksJPjVZT1RMUnsMWkPyAg+6C0eCd
X9WYZJCssY9fCAOuTv8sNzYe6Lq6E++hHLiQxcf5fTh6gFy9IE46s6aWQTsENhCe
FT9pI4qBbQVNoQ6idF4/TNaBROiEAoovg05cULfbrWAgh4AoTEaygxsZqD/+z2Nv
2QmmKWz45u79wOWULGEf4HixU4Hq6qxOCFh11OWUfhJLSQWYbwnFnBbgzir2+Ue0
dH0/d9SoMonXpLYmGXBDbwccBf1BtT4Og+F0JyneGv315m9ppo7fH8ElK6x2yIyF
w4TwoaW/ong=
=ODJB
-----END PGP SIGNATURE-----

--Sig_/vD+90Bu7bXaTo6hD4PVZelb--
