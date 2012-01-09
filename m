Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab2AID3o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 22:29:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab2AID3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 22:29:42 -0500
Date: Mon, 9 Jan 2012 14:29:20 +1100
From: NeilBrown <neilb@suse.de>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, MyungJoo Ham <myungjoo.ham@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] Multithread initcalls to auto-resolve ordering
 issues.
Message-ID: <20120109142920.4aa2162c@notabene.brown>
In-Reply-To: <4F0A3D58.6050400@gmail.com>
References: <20120109112113.07882ed9@notabene.brown>
	<4F0A3D58.6050400@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/P7SI/bHG_TJD80C=sLJ/2qv"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/P7SI/bHG_TJD80C=sLJ/2qv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 09 Jan 2012 12:05:28 +1100 Ryan Mallon <rmallon@gmail.com> wrote:

> On 09/01/12 11:21, NeilBrown wrote:
>=20
> >=20
> > [ To: list stolen from "introduce External Connector Class (extcon)" th=
read
> >   where this topic was briefly mentioned. ]
> >=20
> > Hi,
> >  I welcome review/feedback on the following idea and code.
>=20
>=20
> Hi Neil,
>=20
> Interesting idea, some comments below.
>=20

Thanks for the quick review!

> > Proposed solution:
> >=20
> >   The solution I am proposing is to:
> >    1/ allow the 'request' functions which find and provide a resource t=
o block
> >       until the resource is available
> >    2/ run the init calls in multiple threads so that when one blocks wa=
iting
> >       for a resource, another starts up to run subsequent initcalls unt=
il
> >       the blocking call gets its resource and can complete.
>=20
> What happens if the resource isn't actually present (driver/hardware
> missing or resource probe fails for example)? Does the initcall thread
> get stuck forever, or is there a timeout?

With my code it will get stuck forever.
What is the alternative?  Just fail?

Is this a realistic scenario?  If it is we would probably need some way to
say "this resource is no longer expected" .. sounds messy.

>=20
> > Details and issues.
> >=20
> >   1/ Sometimes it is appropriate to fail rather than to block, and a re=
source
> >      providers need to know which.
> >      This is unlikely to be an issue with GPIO and IRQ as is the identi=
fying
> >      number is >=3D 0, then the resource must be expected at some stage.
> >      However for regulators a name is not given to the driver but rathe=
r the
> >      driver asks if a supply is available with a given name for the dev=
ice.
> >      If not, it makes do without.
> >      So for regulators (and probably other resources) we need to know w=
hat
> >      resources to expect so we know if a resource will never appear.
> >=20
> >      In this sample code I have added a call=20
> >           regulator_has_full_constraints_listed()
> >      which not only assures that all constraints are known, but list
> >      them (array of pointers to regulator_init_data) so when a supply is
> >      requested the regulator code can see if it expected.
> >=20
> >   2/ We probably don't want lots of threads running at once as there is
> >      no good way to decide how many (maybe num_cpus??).
> >      This patch takes the approach that only one thread should be runna=
ble
> >      at once in most cases.
>=20
>=20
> num_cpus won't work for UP systems. In practice the number of threads
> needed is probably low, since most devices probably only have a short
> dependency chain.

My reference to "num_cpus" was for how many threads should be runnable
concurrently (rather than blocking on something) so a value of '1' would be
OK and is what I (mostly) impose with the current code.

The total number of threads created with be the number of devices that are
dependent on something later in the default initcall order.  So it could be
longer than the longest chain if there are multiple long chains that all
block at once.  It could likely be a few, quite possibly be dozens, very
unlikely to be hundreds unless you really had lots and lots of devices.


>=20
> >=20
> >      We keep a count of the number of threads started and the number of
> >      threads that are blocked, and only start a new thread when all thr=
eads
> >      are blocked, and only start a new initcall when all other threads =
are
> >      blocked.
> >=20
> >      So when one initcall makes a resource available, another thread wh=
ich
> >      was waiting could wake up and both will run concurrently.  However=
 no
> >      more initcalls will start until all threads have completed or bloc=
ked.
>=20
>=20
> With this approach having an unbounded number of threads should be okay
> right? The number of threads shouldn't exceed the length of a dependency
> chain.
>=20
> >=20
> >   3/ The parent locking that __driver_attach() does which is "Needed fo=
r USB"
> >      was a little problem - I changed it to alert the initcall thread
> >      management so it knew that thread was blocking.  I think this woul=
dn't be
> >      a problem is the parent lock was *only* taken for USB...
> >=20
> >   4/ It is possible that some existing code registers a resource before=
 it is
> >      really ready to be used.  Currently that isn't a problem as no-one=
 will
> >      actually try to use it until the initcall has completed.  However =
with
> >      this patch the device that wants to use a resource can do so the m=
oment
> >      it is registered.
>=20
>=20
> Such code would be buggy and need fixing correct? This patch could
> possibly help identify such buggy code?

Probably.  When drivers are built as modules the initcalls can already run =
in
parallel so getting the setup wrong could conceivably be an issue already -
but yes, I think this patch could make those bugs more obvious.

As an example of something that might be a bug (And I had to look hard to
find it), in gpio-pl061.c in the _probe function it calls:

		set_irq_flags(i+chip->irq_base, IRQF_VALID);
		irq_set_chip_data(i + chip->irq_base, chip);

Now I haven't set up any code for blocking when IRQs aren't available yet,
but I suspect that the point they become available is when set_irq_flags is
called to set IRQF_VALID.  If some other driver immediately tired to use th=
at
irq it would find that the ->chip_data is NULL. e.g. it could call
pl061_irq_enable() which immediately gets the chip_data and dereferences it.


> > @@ -1179,15 +1195,41 @@ int gpio_request(unsigned gpio, const char *lab=
el)
> >  	struct gpio_chip	*chip;
> >  	int			status =3D -EINVAL;
> >  	unsigned long		flags;
> > +	int			can_wait =3D !in_atomic();
>=20
>=20
> I don't think you can reliably do this. Callers should always track
> whether they can sleep or not. See: http://lwn.net/Articles/274695/

Undoubtedly true.  I'm not even sure that gpio_request can be called from
atomic context, but as spin_lock_irqsave was used (below) instead of
spin_lock_irq, I thought it safest to test.

If this gets past the initial review stage I'm sure I'll get help from
someone how knows this code to make it right.


Thanks again,

NeilBrown

>=20
> > =20
> >  	spin_lock_irqsave(&gpio_lock, flags);
> > =20
> >  	if (!gpio_is_valid(gpio))
> >  		goto done;
> >  	desc =3D &gpio_desc[gpio];
> > +	if (desc->chip =3D=3D NULL) {
> > +		/* possibly need to wait for the chip to appear */
> > +		struct gpio_waiter w;
> > +		int status2 =3D 0;
> > +		DEFINE_WAIT(wait);
> > +		if (test_and_set_bit(FLAG_WAITING, &desc->flags))
> > +			/* Only one waiter allowed */
> > +			goto done;
> > +		if (!can_wait)
> > +			goto done;
> > +
> > +		init_waitqueue_head(&w.queue);
> > +		w.gpio =3D gpio;
> > +		list_add(&w.list, &waiters);
> > +		prepare_to_wait(&w.queue, &wait, TASK_UNINTERRUPTIBLE);
> > +
> > +		while (desc->chip =3D=3D NULL && status2 =3D=3D 0) {
> > +			spin_unlock_irqrestore(&gpio_lock, flags);
> > +			status2 =3D initcall_schedule();
> > +			spin_lock_irqsave(&gpio_lock, flags);
> > +			prepare_to_wait(&w.queue, &wait, TASK_UNINTERRUPTIBLE);
> > +		}
> > +		finish_wait(&w.queue, &wait);
> > +		list_del(&w.list);
> > +		if (desc->chip =3D=3D NULL)
> > +			goto done;
> > +	}
> >  	chip =3D desc->chip;
> > -	if (chip =3D=3D NULL)
> > -		goto done;
> > =20
> >  	if (!try_module_get(chip->owner))
> >  		goto done;

--Sig_/P7SI/bHG_TJD80C=sLJ/2qv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwpfEDnsnt1WYoG5AQJ45w//RVRwvSbKaQ7cSiipzWKVFRMxBD6d5LbA
OJIO8hiZyROw+L1kNy9275TZEVFjhwxcAK5600VLUOiVh+SWWmPExBUJj/fd3ZDK
JJYlqrZwDi4YJDiGsrzqQ3tGxepce90nbZGsbx6ab/Dt+Fg+uc3agWhlGlteapsy
X8jcN4PPQ3cGKeeVYAGKOjxl8HgewwaSjONDmw1ajkCr5pbijNQOwCb97OUjVW+I
+0Qd/KZb6I3mRnaHAgxnoMs9dkXpnsxMWW9Y0NVg+v/Qn4jXiwTkwhw+//incl70
3kzpzOuELwXw6l0MUqoDRjXz0uOsy8KcCDGjmQmiO+bNnXWNUyQdhCunI+JIvEQF
F1wGETXEmMD3anUywLyHRpgY4F7avz5WFDdTE5MdUI2QpGEK3pwI59QhTlScAKRo
u+XBZm+IS6TA5uJRayPY4mwOQXxq3J2OcZedhnd/b8JyZ56JOvDpH1dECr6lw2uj
aGZZfSal1siSmCMdLrfFAk8i5CmV3pFcj5I9Us6LmDrdz52ZU5psa/8t0XeZR4kt
19eE0WA7iEgyzEmu2zPBNKhhHIZ1hy6exRukciCyb63i+PkgET2nFkdVKhWcvTGC
jVPDtPaDslEwZrWzgExyhkTUdTtX6AMY6ZVmXgPiTmu3apI4Z9Z4/F/VIub0y0FH
YWBJi8kBvI8=
=5ZXw
-----END PGP SIGNATURE-----

--Sig_/P7SI/bHG_TJD80C=sLJ/2qv--
