Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab0KTWdm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 17:33:42 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:37563 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab0KTWdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 17:33:41 -0500
X-Spam-ASN: 
Date: Sun, 21 Nov 2010 01:33:27 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv4 05/17] pps: access pps device by direct pointer
Message-ID: <20101121013327.01bc9a86@apollo.gnet>
In-Reply-To: <20101120154416.GX13356@enneenne.com>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
	<57dad12253191b67a6a08bb9c464bd54e70e52a3.1290087479.git.lasaine@lvk.cs.msu.su>
	<20101120154416.GX13356@enneenne.com>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/1+T6+VyuqOwRUmXG.5IocgZ"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1+T6+VyuqOwRUmXG.5IocgZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Sat, 20 Nov 2010 16:44:17 +0100
Rodolfo Giometti <giometti@enneenne.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Thu, Nov 18, 2010 at 07:00:58PM +0300, Alexander Gordeev wrote:
> > Using device index as a pointer needs some unnecessary work to be done
> > every time the pointer is needed (in irq handler for example).
> > Using a direct pointer is much more easy (and safe as well).
> >=20
> > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> > ---
> >  drivers/pps/clients/pps-ktimer.c |   30 ++++-----
> >  drivers/pps/clients/pps-ldisc.c  |   52 ++++++++++------
> >  drivers/pps/kapi.c               |  124 +++++++++---------------------=
--------
> >  drivers/pps/pps.c                |   22 ++-----
> >  include/linux/pps_kernel.h       |   23 +++----
> >  5 files changed, 90 insertions(+), 161 deletions(-)
> >=20
> > diff --git a/drivers/pps/clients/pps-ktimer.c b/drivers/pps/clients/pps=
-ktimer.c
> > index e1bdd8b..966ead1 100644
> > --- a/drivers/pps/clients/pps-ktimer.c
> > +++ b/drivers/pps/clients/pps-ktimer.c
> > @@ -31,7 +31,7 @@
> >   * Global variables
> >   */
> > =20
> > -static int source;
> > +static struct pps_device *pps;
> >  static struct timer_list ktimer;
> > =20
> >  /*
> > @@ -47,7 +47,7 @@ static void pps_ktimer_event(unsigned long ptr)
> > =20
> >  	pr_info("PPS event at %lu\n", jiffies);
> > =20
> > -	pps_event(source, &ts, PPS_CAPTUREASSERT, NULL);
> > +	pps_event(pps, &ts, PPS_CAPTUREASSERT, NULL);
> > =20
> >  	mod_timer(&ktimer, jiffies + HZ);
> >  }
> > @@ -56,12 +56,11 @@ static void pps_ktimer_event(unsigned long ptr)
> >   * The echo function
> >   */
> > =20
> > -static void pps_ktimer_echo(int source, int event, void *data)
> > +static void pps_ktimer_echo(struct pps_device *pps, int event, void *d=
ata)
> >  {
> > -	pr_info("echo %s %s for source %d\n",
> > +	dev_info(pps->dev, "echo %s %s\n",
> >  		event & PPS_CAPTUREASSERT ? "assert" : "",
> > -		event & PPS_CAPTURECLEAR ? "clear" : "",
> > -		source);
> > +		event & PPS_CAPTURECLEAR ? "clear" : "");
> >  }
> > =20
> >  /*
> > @@ -84,30 +83,27 @@ static struct pps_source_info pps_ktimer_info =3D {
> > =20
> >  static void __exit pps_ktimer_exit(void)
> >  {
> > -	del_timer_sync(&ktimer);
> > -	pps_unregister_source(source);
> > +	dev_info(pps->dev, "ktimer PPS source unregistered\n");
> > =20
> > -	pr_info("ktimer PPS source unregistered\n");
> > +	del_timer_sync(&ktimer);
> > +	pps_unregister_source(pps);
> >  }
> > =20
> >  static int __init pps_ktimer_init(void)
> >  {
> > -	int ret;
> > -
> > -	ret =3D pps_register_source(&pps_ktimer_info,
> > +	pps =3D pps_register_source(&pps_ktimer_info,
> >  				PPS_CAPTUREASSERT | PPS_OFFSETASSERT);
> > -	if (ret < 0) {
> > +	if (pps =3D=3D NULL) {
> >  		printk(KERN_ERR "cannot register ktimer source\n");
> > -		return ret;
> > +		return -ENOMEM;
> >  	}
> > -	source =3D ret;
> > =20
> >  	setup_timer(&ktimer, pps_ktimer_event, 0);
> >  	mod_timer(&ktimer, jiffies + HZ);
> > =20
> > -	pr_info("ktimer PPS source registered at %d\n", source);
> > +	dev_info(pps->dev, "ktimer PPS source registered\n");
> > =20
> > -	return  0;
> > +	return 0;
> >  }
> > =20
> >  module_init(pps_ktimer_init);
> > diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-=
ldisc.c
> > index 20fc9f7..1950b15 100644
> > --- a/drivers/pps/clients/pps-ldisc.c
> > +++ b/drivers/pps/clients/pps-ldisc.c
> > @@ -23,14 +23,18 @@
> >  #include <linux/serial_core.h>
> >  #include <linux/tty.h>
> >  #include <linux/pps_kernel.h>
> > +#include <linux/spinlock.h>
> > =20
> >  #define PPS_TTY_MAGIC		0x0001
> > =20
> > +static DEFINE_SPINLOCK(pps_ldisc_lock);
> > +
> >  static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int st=
atus,
> >  				struct pps_event_time *ts)
> >  {
> > -	int id =3D (long)tty->disc_data;
> > +	struct pps_device *pps;
> >  	struct pps_event_time __ts;
> > +	unsigned long flags;
> > =20
> >  	/* First of all we get the time stamp... */
> >  	pps_get_ts(&__ts);
> > @@ -39,12 +43,18 @@ static void pps_tty_dcd_change(struct tty_struct *t=
ty, unsigned int status,
> >  	if (!ts)	/* No. Do it ourself! */
> >  		ts =3D &__ts;
> > =20
> > -	/* Now do the PPS event report */
> > -	pps_event(id, ts, status ? PPS_CAPTUREASSERT : PPS_CAPTURECLEAR,
> > -			NULL);
> > +	spin_lock_irqsave(&pps_ldisc_lock, flags);
> > =20
> > -	pr_debug("PPS %s at %lu on source #%d\n",
> > -			status ? "assert" : "clear", jiffies, id);
> > +	/* Now do the PPS event report */
> > +	pps =3D (struct pps_device *)tty->disc_data;
> > +	if (pps !=3D NULL) {
> > +		pps_event(pps, ts, status ? PPS_CAPTUREASSERT :
> > +				PPS_CAPTURECLEAR, NULL);
> > +		spin_unlock_irqrestore(&pps_ldisc_lock, flags);
> > +		dev_dbg(pps->dev, "PPS %s at %lu\n",
> > +				status ? "assert" : "clear", jiffies);
>=20
> I think you should swap these two lines because after you release the
> lock the pps pointer may be not valid...

Ah, yes, good catch, thank you!

> > +	} else
> > +		spin_unlock_irqrestore(&pps_ldisc_lock, flags);
> >  }
> > =20
> >  static int (*alias_n_tty_open)(struct tty_struct *tty);
> > @@ -54,7 +64,7 @@ static int pps_tty_open(struct tty_struct *tty)
> >  	struct pps_source_info info;
> >  	struct tty_driver *drv =3D tty->driver;
> >  	int index =3D tty->index + drv->name_base;
> > -	int ret;
> > +	struct pps_device *pps;
> > =20
> >  	info.owner =3D THIS_MODULE;
> >  	info.dev =3D NULL;
> > @@ -64,20 +74,22 @@ static int pps_tty_open(struct tty_struct *tty)
> >  			PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
> >  			PPS_CANWAIT | PPS_TSFMT_TSPEC;
> > =20
> > -	ret =3D pps_register_source(&info, PPS_CAPTUREBOTH | \
> > +	pps =3D pps_register_source(&info, PPS_CAPTUREBOTH | \
> >  				PPS_OFFSETASSERT | PPS_OFFSETCLEAR);
> > -	if (ret < 0) {
> > +	if (pps =3D=3D NULL) {
> >  		pr_err("cannot register PPS source \"%s\"\n", info.path);
> > -		return ret;
> > +		return -ENOMEM;
> >  	}
> > -	tty->disc_data =3D (void *)(long)ret;
> > +
> > +	spin_lock_irq(&pps_ldisc_lock);
> > +	tty->disc_data =3D pps;
> > +	spin_unlock_irq(&pps_ldisc_lock);
>=20
> Maybe this lock is useless... however, are we sure that before setting
> tty->disc_data to pps its value is null? Otherwise the dcd_change may
> be called with an oops! We cannot control serial port IRQ
> generation... :-/

No, locking here is necessary.
There is only one problem this spinlock protects us from: current tty
code neither disables interrupts nor doesn't ensure there are no
references to PPS ldisc from uart_handle_dcd_change() before closing it
(and removing PPS source). It relies on flushing workqueue and disabling
input. It worked good this way until dcd_change() was added which
doesn't use workqueues and is called in atomic context so can't lock
on mutex.

Imagine that (on SMP system) uart_handle_dcd_change() could obtain a
reference to ldisc and call dcd_change() until actually calling
pps_event(); then on another processor all the path from
tty_ldisc_halt() until tty_ldisc_stop() is executed. And then
pps_event() is called with illegal pps pointer.

I just thought you are right that disc_data can be set not NULL by
another ldisc and it's a problem. But actually I just realised how to
fix it completely. :)

I just have to add a spinlock to tty_struct, lock all the
uart_handle_dcd_change() with it and add a "barrier" between
tty_ldisc_halt() and tty_ldisc_close() i.e. just that:

...
spin_lock_irq();
spin_unlock_irq();
...

This "barrier" will ensure that there is no references to ldisc from
uart_handle_dcd_change(). It won't be able to obtain a new reference
after tty_ldisc_halt() so will become completely sane. Not disabling
interrupts won't be a problem because it won't be able to obtain an
ldisc reference until tty_ldisc_enable() which is called only after the
new ldisc is fully functional. If it's our ldisc than it will have both
dcd_change defined and a valid pps pointer. If it's not our ldisc it
won't have both so uart_handle_dcd_change() won't call dcd_change() at
all.

I think I'll do that as a separate patch.

> >  	/* Should open N_TTY ldisc too */
> > -	ret =3D alias_n_tty_open(tty);
> > -	if (ret < 0)
> > -		pps_unregister_source((long)tty->disc_data);
> > +	if (alias_n_tty_open(tty) < 0)
>=20
> Are you sure this code style is =C2=ABcanonical=C2=BB? What does checkpat=
ch say?
> ;)

checkpatch is completely happy about all patches. :)
But indeed it's not good. I'll fix it, thanks!

> > +		pps_unregister_source(pps);
>=20
> If the above function fails I suppose you should invalidate
> tty->disc_data, then unregister the pps source and, in the end, return
> error (I know old code returns 0 anywhere, but I think it can be fixed
> right now! ;).

OK. :)

> > -	pr_info("PPS source #%d \"%s\" added\n", ret, info.path);
> > +	dev_info(pps->dev, "source \"%s\" added\n", info.path);
> > =20
> >  	return 0;
> >  }
> > @@ -86,12 +98,16 @@ static void (*alias_n_tty_close)(struct tty_struct =
*tty);
> > =20
> >  static void pps_tty_close(struct tty_struct *tty)
> >  {
> > -	int id =3D (long)tty->disc_data;
> > +	struct pps_device *pps =3D (struct pps_device *)tty->disc_data;
> > =20
> > -	pps_unregister_source(id);
> >  	alias_n_tty_close(tty);
> > =20
> > -	pr_info("PPS source #%d removed\n", id);
> > +	spin_lock_irq(&pps_ldisc_lock);
> > +	tty->disc_data =3D NULL;
> > +	spin_unlock_irq(&pps_ldisc_lock);
> > +
> > +	dev_info(pps->dev, "removed\n");
> > +	pps_unregister_source(pps);
> >  }
> > =20
> >  static struct tty_ldisc_ops pps_ldisc_ops;
>=20
> I suppose you can solve all your problems if you do the lock into
> pps_tty_init...
>=20
> Ciao,
>=20
> Rodolfo
>=20


--=20
  Alexander

--Sig_/1+T6+VyuqOwRUmXG.5IocgZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJM6Ey3AAoJEElrwznyooJbgekH/3YBQHdMen6isXygy0sJqLxD
OpCG0F61rYvXxFqBGKk/deHDh7BxxZcpJIuKRNzc52ABibvVTIFqhiubB9idcsVY
adIZYU5iejc0XGoD5lLRrhPcG1CgdnAAYYlPshXN4mxCp7BcwPhez8yQuguypD+J
h6mZ7eQEvZongDos1e4IV8LanUYEuU6hJ3oJ5pnH330DxTiWwXC01edJvz7UxlXw
UCVe9nNVA90Nir/VQ3ehKEvzAzv9S0JXtlcS5iDPK8IzBQjxbsaCDBLc4lIK6GVj
cjdck2F6JsdadheHNdOiEdMYR5bo4G4T7WafcjvoaP2OqEYy/jI3nBYINkIwPZM=
=ANRt
-----END PGP SIGNATURE-----

--Sig_/1+T6+VyuqOwRUmXG.5IocgZ--
