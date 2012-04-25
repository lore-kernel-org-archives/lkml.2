Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab2DYJj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 05:39:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab2DYJjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 05:39:25 -0400
Date: Wed, 25 Apr 2012 19:39:16 +1000
From: NeilBrown <neilb@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 2/3] IRQ: allow check_wakeup_irqs to notice
 level-triggered interrupts.
Message-ID: <20120425193916.0db1b4b1@notabene.brown>
In-Reply-To: <alpine.LFD.2.02.1204251018530.2542@ionos>
References: <20120425025637.7832.14013.stgit@notabene.brown>
	<20120425030524.7832.85239.stgit@notabene.brown>
	<alpine.LFD.2.02.1204251018530.2542@ionos>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hnsoQzRsD4uxXdJuDwM76Dm"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hnsoQzRsD4uxXdJuDwM76Dm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Apr 2012 10:50:15 +0200 (CEST) Thomas Gleixner
<tglx@linutronix.de> wrote:

> On Wed, 25 Apr 2012, NeilBrown wrote:
>=20
> > Level triggered interrupts do not cause IRQS_PENDING to be set, so
> > check_wakeup_irqs ignores them.
> > They don't need to set IRQS_PENDING as the level stays high which
> > shows that they must be pending.  However if such an interrupt fired
> > during late suspend, it will have been masked so the fact that it
> > is still asserted will not cause the suspend to abort.
> >=20
> > So if any wakeup interrupt is masked, unmask it when checking wakeup
> > irqs.  If the interrupt is asserted, suspend will abort.
> >=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >=20
> >  kernel/irq/pm.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> >=20
> > diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
> > index 15e53b1..0d26206 100644
> > --- a/kernel/irq/pm.c
> > +++ b/kernel/irq/pm.c
> > @@ -106,6 +106,12 @@ int check_wakeup_irqs(void)
> >  		if (irqd_is_wakeup_set(&desc->irq_data)) {
> >  			if (desc->istate & IRQS_PENDING)
> >  				return -EBUSY;
> > +			if (irqd_irq_masked(&desc->irq_data))
> > +				/* Probably a level interrupt
> > +				 * which fired recently and was
> > +				 * masked
> > +				 */
> > +				unmask_irq(desc);
>=20
> Oh no. We don't unmask unconditionally. What about an interrupt which
> is disabled, has no handler ..... ? That needs more thought.

If there is no handler, then irqd_is_wakeup_set() should fail should it not?

For disabled: would it be OK to check desc->depth?
Something like:
     if (desc->depth =3D=3D 1 && (desc->state & IRQS_SUSPENDED) &&
         irqd_irq_masked(&desc->irq_data))
              unmask_irq(desc);

??

Thanks,
NeilBrown

--Sig_/hnsoQzRsD4uxXdJuDwM76Dm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5fGRDnsnt1WYoG5AQJvKw/+KKhBJMIFk8CpZ8OAPy9UCzUqx34VChwC
av/lWZAzuiggZWVOx1f5AAeJuFuMw3qX/9H8Js/xEVJU/v1FerOO3yzQVIQp2VSr
4VP1jcWNA5KI6tP85D3ChJaZNNiUSQMCs6ui+Vzi1kSvR4KyD/os+cS+/XofEx4z
cFNSGf7QTHhDJiCtP6AlAvlxfL68uJ1bsIyqYOvo996hiD2Jk6yZGKhBpN0gDjwu
Rk/pwqxt+/BZqFktrQWvQLPRq5uMelWobBk5tnCk/BH/ZQqSBkUn9Ur499ePIKNw
3IxDRcWd9qyZKZgOk1xgCF0Q4asESfHyFSOzULfz6T33ue5mR7ORtKPhBw4LboyI
s4+PB6qRTbqP99JO++BzOvbz71rpbs0OgfxtilW+nF5BWA85xYtCyAS8AXW7q5IR
wOGMuVC+KQSKkvKMbUpTCN/Jw4J1S0OL4Cg69SXZPfnxuoU6a8Uy0SCLA6MkOXd7
E2tHsaYi2idxL3t7PbNVdO81I0fECtXXevYo/cIkuGNpQS6FKg+cf5GexIcYajW5
vEv8+XIvseYcMLEXLVrQMLFd/kaI5pbc66l1nJWOqZX31hQe5K4HVoGluKLoZRgM
OYtZ8PSWV4fqm1t/Y+WINd43m6KNpPm1zQWIvmbxmICvh8bU68+4ZPPqSnnpaqbs
JUkHdXE5Rw8=
=LroV
-----END PGP SIGNATURE-----

--Sig_/hnsoQzRsD4uxXdJuDwM76Dm--
