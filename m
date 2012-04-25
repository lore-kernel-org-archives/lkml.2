Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab2DYVES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 17:04:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076Ab2DYVEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 17:04:16 -0400
Date: Thu, 26 Apr 2012 07:04:07 +1000
From: NeilBrown <neilb@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 2/3] IRQ: allow check_wakeup_irqs to notice
 level-triggered interrupts.
Message-ID: <20120426070407.7646fb66@notabene.brown>
In-Reply-To: <alpine.LFD.2.02.1204251402360.2542@ionos>
References: <20120425025637.7832.14013.stgit@notabene.brown>
	<20120425030524.7832.85239.stgit@notabene.brown>
	<alpine.LFD.2.02.1204251018530.2542@ionos>
	<20120425193916.0db1b4b1@notabene.brown>
	<alpine.LFD.2.02.1204251402360.2542@ionos>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/G85f3yy0qH.p+TPobBHkpnf"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/G85f3yy0qH.p+TPobBHkpnf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Apr 2012 14:54:54 +0200 (CEST) Thomas Gleixner
<tglx@linutronix.de> wrote:

> On Wed, 25 Apr 2012, NeilBrown wrote:
> > On Wed, 25 Apr 2012 10:50:15 +0200 (CEST) Thomas Gleixner
> > <tglx@linutronix.de> wrote:
> >=20
> > > On Wed, 25 Apr 2012, NeilBrown wrote:
> > >=20
> > > > Level triggered interrupts do not cause IRQS_PENDING to be set, so
> > > > check_wakeup_irqs ignores them.
> > > > They don't need to set IRQS_PENDING as the level stays high which
> > > > shows that they must be pending.  However if such an interrupt fired
> > > > during late suspend, it will have been masked so the fact that it
> > > > is still asserted will not cause the suspend to abort.
> > > >=20
> > > > So if any wakeup interrupt is masked, unmask it when checking wakeup
> > > > irqs.  If the interrupt is asserted, suspend will abort.
> > > >=20
> > > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > > ---
> > > >=20
> > > >  kernel/irq/pm.c |    6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > >=20
> > > > diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
> > > > index 15e53b1..0d26206 100644
> > > > --- a/kernel/irq/pm.c
> > > > +++ b/kernel/irq/pm.c
> > > > @@ -106,6 +106,12 @@ int check_wakeup_irqs(void)
> > > >  		if (irqd_is_wakeup_set(&desc->irq_data)) {
> > > >  			if (desc->istate & IRQS_PENDING)
> > > >  				return -EBUSY;
> > > > +			if (irqd_irq_masked(&desc->irq_data))
> > > > +				/* Probably a level interrupt
> > > > +				 * which fired recently and was
> > > > +				 * masked
> > > > +				 */
> > > > +				unmask_irq(desc);
> > >=20
> > > Oh no. We don't unmask unconditionally. What about an interrupt which
> > > is disabled, has no handler ..... ? That needs more thought.
> >=20
> > If there is no handler, then irqd_is_wakeup_set() should fail should it=
 not?
>=20
> Well, it does not. The wakeup state is a permanent flag on the irq
> line. Though we don't have IRQS_SUSPENDED on that descriptor.
> =20
> > For disabled: would it be OK to check desc->depth?
> > Something like:
> >      if (desc->depth =3D=3D 1 && (desc->state & IRQS_SUSPENDED) &&
> >          irqd_irq_masked(&desc->irq_data))
> >               unmask_irq(desc);
> >=20
>=20
> Why not simply managing the pending bit for level irqs ?

Primarily because I was aiming for the simplest patch that would have the
desired effect.  Also because 'pending' is implicit in the level so it seems
superfluous to store the bit separately.  And understanding all the
consequences of that change is not something I felt up to.

However: thanks for the patch. I'll try to explore it tomorrow and see if
seems to be behaving correctly.

Thanks,
NeilBrown

>=20
> Index: tip/kernel/irq/chip.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- tip.orig/kernel/irq/chip.c
> +++ tip/kernel/irq/chip.c
> @@ -379,8 +379,10 @@ handle_level_irq(unsigned int irq, struc
>  	 * If its disabled or no action available
>  	 * keep it masked and get out of here
>  	 */
> -	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data)))
> +	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data))) {
> +		desc->istate |=3D IRQS_PENDING;
>  		goto out_unlock;
> +	}
> =20
>  	handle_irq_event(desc);
> =20
> Index: tip/kernel/irq/resend.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- tip.orig/kernel/irq/resend.c
> +++ tip/kernel/irq/resend.c
> @@ -58,10 +58,13 @@ void check_irq_resend(struct irq_desc *d
>  	/*
>  	 * We do not resend level type interrupts. Level type
>  	 * interrupts are resent by hardware when they are still
> -	 * active.
> +	 * active. Clear the pending bit so suspend/resume does not
> +	 * get confused.
>  	 */
> -	if (irq_settings_is_level(desc))
> +	if (irq_settings_is_level(desc)) {
> +		desc->istate &=3D ~IRQS_PENDING;
>  		return;
> +	}
>  	if (desc->istate & IRQS_REPLAY)
>  		return;
>  	if (desc->istate & IRQS_PENDING) {
>=20
> And to handle interrupts which have been disabled before suspend add:
>=20
> Index: tip/kernel/irq/pm.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- tip.orig/kernel/irq/pm.c
> +++ tip/kernel/irq/pm.c
> @@ -103,7 +103,8 @@ int check_wakeup_irqs(void)
>  	int irq;
> =20
>  	for_each_irq_desc(irq, desc) {
> -		if (irqd_is_wakeup_set(&desc->irq_data)) {
> +		if (desc->depth =3D=3D 1 &&
> +		    irqd_is_wakeup_set(&desc->irq_data)) {
>  			if (desc->istate & IRQS_PENDING)
>  				return -EBUSY;
>  			continue;


--Sig_/G85f3yy0qH.p+TPobBHkpnf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5hmxznsnt1WYoG5AQL+tBAAsKvuDyBoFkhRvjDoM9ee6zjrNweNJsr2
ZddlI4xxftsRJNBIyJbf1vCSfpeaCeFz66+VLrmP+ohrv/0CjXIPYjZPORgYH+NA
Djpv2UQpbfqmfrRAz+XiLy9f2H4miHx8fs659C4t06MJzP+AzZWYGQHWvvnMrw5S
y4RJdjRRPybTJx8drbjF0HKCpHp/wI3prsNN8YrCF+t8a+mSoRF8vsujdmuj0jiC
e+KhObN9XR65jRq408iyVeFnQji4+o73cwYMlbTMxUZi/dkkAnqOK9X6viPNg7hn
/WCE02xy4o9cJkzRAW/b3eSVXtEwGCKaB3TlsEhgBv49+o3/vVVRr0uGvWgIUEeZ
pszzotMWgF7fCUNsBgdkkGmNQDM/6C4kP9qcbX9rzDnNJp/z1mDsZWUoyi/iFYIF
vXARgt+l97XPg0r49s5WeNukGO57OI1CQnZ2ixKUKD758E7QJfVQrn3FPdCjDzXo
f2i4COvt8S9PrPLTxFJ5QfIngfbEC3cpsQzRmgsNE2o+YIiDvUKV4dItcMqrYAjO
JfAsIUfoG18J2wg2cbXBPzAT2phV/Xla1mFQw8YAzk1ck3hUYkbreYcW2OuiR6e0
06inLd31mkm0+/dbyTvFD6rnXGDjP6CqDgK6F+hbpJhNcZ9+wt40oztf74V3qvNj
Il3FQ3k0j9Y=
=sOrR
-----END PGP SIGNATURE-----

--Sig_/G85f3yy0qH.p+TPobBHkpnf--
