Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab0KTXXO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 18:23:14 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:35541 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab0KTXXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 18:23:13 -0500
X-Spam-ASN: 
Date: Sun, 21 Nov 2010 02:23:02 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv4 08/17] pps: add async PPS event handler
Message-ID: <20101121022302.2bce2240@apollo.gnet>
In-Reply-To: <20101120160851.GA13356@enneenne.com>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
	<65eae4de46680aa8d644619f6dc61ba17f1fdc77.1290087479.git.lasaine@lvk.cs.msu.su>
	<20101120160851.GA13356@enneenne.com>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/7QTY9lCYGUQXzVoMXaIODQ5"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7QTY9lCYGUQXzVoMXaIODQ5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Sat, 20 Nov 2010 17:08:51 +0100
Rodolfo Giometti <giometti@enneenne.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Thu, Nov 18, 2010 at 07:01:01PM +0300, Alexander Gordeev wrote:
> > This handler should be called from an IRQ handler. It uses per-device
> > workqueue internally.
>=20
> Can you please explain to me why do you need this patch? Maybe you can
> add a verbose patch's description? :)

Well, it's all about optimizing latencies on rt-preempt kernel: if
everything is done in a process context than we can use mutexes
(haven't done that yet) and don't disable interrupts, which is better
for hard real time. I measured that pps_event with kernel consumer
enabled takes 1-2us on my test machine. Not a big deal, of course...

Sorry, I've completely forgotten about an echo function. However quick
look to current clients shows that it is only used in pps-ktimer.c
for debug printing... Maybe it's not needed at all? I mean, have you
ever got any user request for this feature? If yes, it can be removed
IMHO since RFC-2783 says that it's optional. I can handle the removal in
the next version of the patchset.

If you don't want it I can have this patch on my rt branch only and
don't try to push it into mainline.

> > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> > ---
> >  drivers/pps/clients/pps-ktimer.c |    2 +-
> >  drivers/pps/clients/pps-ldisc.c  |    2 +-
> >  drivers/pps/kapi.c               |   95 ++++++++++++++++++++++++++++++=
++++++--
> >  drivers/pps/pps.c                |   14 +++++-
> >  include/linux/pps_kernel.h       |   12 +++++
> >  5 files changed, 117 insertions(+), 8 deletions(-)
> >=20
> > diff --git a/drivers/pps/clients/pps-ktimer.c b/drivers/pps/clients/pps=
-ktimer.c
> > index 2728469..26ed7a2 100644
> > --- a/drivers/pps/clients/pps-ktimer.c
> > +++ b/drivers/pps/clients/pps-ktimer.c
> > @@ -48,7 +48,7 @@ static void pps_ktimer_event(unsigned long ptr)
> > =20
> >  	dev_info(pps->dev, "PPS event at %lu\n", jiffies);
> > =20
> > -	pps_event(pps, &ts, PPS_CAPTUREASSERT, NULL);
> > +	pps_event_irq(pps, &ts, PPS_CAPTUREASSERT, NULL);
> > =20
> >  	mod_timer(&ktimer, jiffies + HZ);
> >  }
> > diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-=
ldisc.c
> > index 30789fa..7006f85 100644
> > --- a/drivers/pps/clients/pps-ldisc.c
> > +++ b/drivers/pps/clients/pps-ldisc.c
> > @@ -50,7 +50,7 @@ static void pps_tty_dcd_change(struct tty_struct *tty=
, unsigned int status,
> >  	/* Now do the PPS event report */
> >  	pps =3D (struct pps_device *)tty->disc_data;
> >  	if (pps !=3D NULL) {
> > -		pps_event(pps, ts, status ? PPS_CAPTUREASSERT :
> > +		pps_event_irq(pps, ts, status ? PPS_CAPTUREASSERT :
> >  				PPS_CAPTURECLEAR, NULL);
> >  		spin_unlock_irqrestore(&pps_ldisc_lock, flags);
> >  		dev_dbg(pps->dev, "PPS %s at %lu\n",
> > diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
> > index f5b2b78..ca3b4f8 100644
> > --- a/drivers/pps/kapi.c
> > +++ b/drivers/pps/kapi.c
> > @@ -32,9 +32,19 @@
> >  #include <linux/slab.h>
> > =20
> >  /*
> > + * Global variables
> > + */
> > +
> > +/* PPS event workqueue */
> > +struct workqueue_struct *pps_event_workqueue;
> > +
> > +/*
> >   * Local functions
> >   */
> > =20
> > +static void assert_work_func(struct work_struct *work);
> > +static void clear_work_func(struct work_struct *work);
> > +
> >  static void pps_add_offset(struct pps_ktime *ts, struct pps_ktime *off=
set)
> >  {
> >  	ts->nsec +=3D offset->nsec;
> > @@ -108,6 +118,9 @@ struct pps_device *pps_register_source(struct pps_s=
ource_info *info,
> >  	init_waitqueue_head(&pps->queue);
> >  	spin_lock_init(&pps->lock);
> > =20
> > +	INIT_WORK(&pps->assert_work, assert_work_func);
> > +	INIT_WORK(&pps->clear_work, clear_work_func);
> > +
> >  	/* Create the char device */
> >  	err =3D pps_register_cdev(pps);
> >  	if (err < 0) {
> > @@ -152,11 +165,12 @@ EXPORT_SYMBOL(pps_unregister_source);
> >   * @event: the event type
> >   * @data: userdef pointer
> >   *
> > - * This function is used by each PPS client in order to register a new
> > - * PPS event into the system (it's usually called inside an IRQ handle=
r).
> > + * This function is used by PPS clients in order to register a new
> > + * PPS event into the system. It should not be called from an IRQ
> > + * handler. Use pps_event_irq instead.
> >   *
> > - * If an echo function is associated with the PPS device it will be ca=
lled
> > - * as:
> > + * If an echo function is associated with the PPS device it will be
> > + * called as:
> >   *	pps->info.echo(pps, event, data);
> >   */
> >  void pps_event(struct pps_device *pps, struct pps_event_time *ts, int =
event,
> > @@ -226,3 +240,76 @@ void pps_event(struct pps_device *pps, struct pps_=
event_time *ts, int event,
> >  	spin_unlock_irqrestore(&pps->lock, flags);
> >  }
> >  EXPORT_SYMBOL(pps_event);
> > +
> > +/* Async event handlers */
> > +
> > +static void assert_work_func(struct work_struct *work)
> > +{
> > +	struct pps_device *pps =3D container_of(work,
> > +			struct pps_device, assert_work);
> > +
> > +	pps_event(pps, &pps->assert_work_ts, PPS_CAPTUREASSERT,
> > +			pps->assert_work_data);
> > +}
> > +
> > +static void clear_work_func(struct work_struct *work)
> > +{
> > +	struct pps_device *pps =3D container_of(work,
> > +			struct pps_device, clear_work);
> > +
> > +	pps_event(pps, &pps->clear_work_ts, PPS_CAPTURECLEAR,
> > +			pps->clear_work_data);
> > +}
>=20
> The RFC-2783 says that (see 3.1 PPS abstraction):
>=20
>    The API optionally supports an "echo" feature, in which events on
>    the
>    incoming PPS signal may be reflected through software, after the
>    capture of the corresponding timestamp, to an output signal pin.
>    This feature may be used to discover an upper bound on the actual
>    delay between the edges of the PPS signal and the capture of the
>    timestamps; such information may be useful in precise calibration
>    of
>    the system.
>=20
>    The designation of an output pin for the echo signal, and sense and
>    shape of the output transition, is outside the scope of this
>    specification, but SHOULD be documented for each implementation.
>    The
>    output pin MAY also undergo transitions at other times besides
>    those
>    caused by PPS input events.
>=20
> By applying this patch the echo function is called inside a work queue
> so it depends to the scheduler. I suppose this is not acceptable,
> otherwise we should drop the echo function support.
>=20
> > +/* pps_event_irq - register a PPS event for deffered handling using
> > + * workqueue
> > + *
> > + * @pps: the PPS device
> > + * @ts: the event timestamp
> > + * @event: the event type
> > + * @data: userdef pointer
> > + *
> > + * This function is used by PPS clients in order to register a new
> > + * PPS event into the system. It should be called from an IRQ handler
> > + * only.
> > + *
> > + * If an echo function is associated with the PPS device it will be
> > + * called as:
> > + *	pps->info.echo(pps, event, data);
> > + */
>=20
> The above comment talks about the echo function but you removed it
> from the code below...

Well, I meant that it will be called from pps_event(). :)
Actually just copied this comment from pps_event() and thought that
it's still right somehow. Do you want me to remove this comment?

> > +void pps_event_irq(struct pps_device *pps, struct pps_event_time *ts,
> > +		int event, void *data)
> > +{
> > +	/* check event type */
> > +	BUG_ON((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) =3D=3D 0);
> > +
> > +	if (event & PPS_CAPTUREASSERT) {
> > +		if (work_pending(&pps->assert_work)) {
> > +			dev_err(pps->dev, "deferred assert edge work haven't"
> > +					" been handled within a second\n");
> > +			/* FIXME: do something more intelligent
> > +			 * then just exit */
> > +		} else {
> > +			/* now we can copy data safely */
> > +			pps->assert_work_ts =3D *ts;
> > +			pps->assert_work_data =3D data;
> > +
> > +			queue_work(pps_event_workqueue, &pps->assert_work);
> > +		}
> > +	}
> > +	if (event & PPS_CAPTURECLEAR) {
> > +		if (work_pending(&pps->clear_work)) {
> > +			dev_err(pps->dev, "deferred clear edge work haven't"
> > +					" been handled within a second\n");
> > +			/* FIXME: do something more intelligent
> > +			 * then just exit */
> > +		} else {
> > +			/* now we can copy data safely */
> > +			pps->clear_work_ts =3D *ts;
> > +			pps->clear_work_data =3D data;
> > +
> > +			queue_work(pps_event_workqueue, &pps->clear_work);
> > +		}
> > +	}
> > +}
> > +EXPORT_SYMBOL(pps_event_irq);
> > diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
> > index 79b4455..f642558 100644
> > --- a/drivers/pps/pps.c
> > +++ b/drivers/pps/pps.c
> > @@ -321,18 +321,26 @@ void pps_unregister_cdev(struct pps_device *pps)
> > =20
> >  static void __exit pps_exit(void)
> >  {
> > -	class_destroy(pps_class);
> >  	unregister_chrdev_region(pps_devt, PPS_MAX_SOURCES);
> > +	class_destroy(pps_class);
> > +	destroy_workqueue(pps_event_workqueue);
> >  }
> > =20
> >  static int __init pps_init(void)
> >  {
> >  	int err;
> > =20
> > +	pps_event_workqueue =3D create_workqueue("pps");
> > +	if (!pps_event_workqueue) {
> > +		pr_err("failed to create workqueue\n");
> > +		return -ENOMEM;
> > +	}
> > +
> >  	pps_class =3D class_create(THIS_MODULE, "pps");
> >  	if (!pps_class) {
> >  		pr_err("failed to allocate class\n");
> > -		return -ENOMEM;
> > +		err =3D -ENOMEM;
> > +		goto destroy_workqueue;
> >  	}
> >  	pps_class->dev_attrs =3D pps_attrs;
> > =20
> > @@ -350,6 +358,8 @@ static int __init pps_init(void)
> > =20
> >  remove_class:
> >  	class_destroy(pps_class);
> > +destroy_workqueue:
> > +	destroy_workqueue(pps_event_workqueue);
> > =20
> >  	return err;
> >  }
> > diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
> > index 1aedf50..5af0498 100644
> > --- a/include/linux/pps_kernel.h
> > +++ b/include/linux/pps_kernel.h
> > @@ -26,6 +26,7 @@
> >  #include <linux/cdev.h>
> >  #include <linux/device.h>
> >  #include <linux/time.h>
> > +#include <linux/workqueue.h>
> > =20
> >  /*
> >   * Global defines
> > @@ -70,6 +71,13 @@ struct pps_device {
> >  	struct device *dev;
> >  	struct fasync_struct *async_queue;	/* fasync method */
> >  	spinlock_t lock;
> > +
> > +	struct work_struct assert_work;
> > +	struct work_struct clear_work;
> > +	struct pps_event_time assert_work_ts;
> > +	struct pps_event_time clear_work_ts;
> > +	void *assert_work_data;
> > +	void *clear_work_data;
> >  };
> > =20
> >  /*
> > @@ -78,6 +86,8 @@ struct pps_device {
> > =20
> >  extern struct device_attribute pps_attrs[];
> > =20
> > +extern struct workqueue_struct *pps_event_workqueue;
> > +
> >  /*
> >   * Exported functions
> >   */
> > @@ -89,6 +99,8 @@ extern int pps_register_cdev(struct pps_device *pps);
> >  extern void pps_unregister_cdev(struct pps_device *pps);
> >  extern void pps_event(struct pps_device *pps,
> >  		struct pps_event_time *ts, int event, void *data);
> > +extern void pps_event_irq(struct pps_device *pps,
> > +		struct pps_event_time *ts, int event, void *data);
> > =20
> >  static inline void timespec_to_pps_ktime(struct pps_ktime *kt,
> >  		struct timespec ts)
> > --=20
> > 1.7.2.3
> >=20
>=20
> Ciao,
>=20
> Rodolfo
>=20


--=20
  Alexander

--Sig_/7QTY9lCYGUQXzVoMXaIODQ5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJM6FhWAAoJEElrwznyooJbFQ8H/RLs2Y5s4tLEvY1n1KmoNkzC
zpbhpjbN/vDNnVjMwqLlzx5cWJHiRU65D+FbVjvb1xndnOYX6sapiucGETAv/ya1
TTkyKMz/PEjP4QnaK5sYLtWc2qTr8898I7DCAACXPzETfGwwJNIrUkSpwH2+0dDS
gisuAa9TNrBcTSFQzKcYtHcvLwyrUwZGJdiqpS91essyYqKzyPs5V7+VLlFsz9K9
bPobQulDZOtLmnXnYQDXV+u0ZJhg2/hfQNYyH+c7brFaRw9oFr1+rS31ZiGNHlPl
YF0Ds9uMVnhVFVPN2QqLhrJm814AmDdHsozvTl6IUYKXszoTNtC2ZYus1BIA2BE=
=hOsT
-----END PGP SIGNATURE-----

--Sig_/7QTY9lCYGUQXzVoMXaIODQ5--
