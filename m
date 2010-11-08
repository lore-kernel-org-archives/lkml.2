Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0KHCUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 21:20:07 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:60447 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab0KHCUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 21:20:06 -0500
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Nov 2010 21:20:05 EST
Date: Mon, 8 Nov 2010 03:19:36 +0100
From: "Udo A. Steinberg" <udo@hypervisor.org>
To: paulmck@linux.vnet.ibm.com
Cc: Joe Korty <joe.korty@ccur.com>, fweisbec@gmail.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH] a local-timer-free version of RCU
Message-ID: <20101108031936.63a13ff2@laptop.hypervisor.org>
In-Reply-To: <20101108031136.0766149f@laptop.hypervisor.org>
References: <20101104232148.GA28037@linux.vnet.ibm.com>
	<20101105210059.GA27317@tsunami.ccur.com>
	<20101106192812.GI15561@linux.vnet.ibm.com>
	<20101108031136.0766149f@laptop.hypervisor.org>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/D=On9fVYoU4ux6cYEnVJGtM"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/D=On9fVYoU4ux6cYEnVJGtM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Nov 2010 03:11:36 +0100 Udo A. Steinberg (UAS) wrote:

UAS> On Sat, 6 Nov 2010 12:28:12 -0700 Paul E. McKenney (PEM) wrote:
UAS>=20
UAS> PEM> > + * rcu_quiescent() is called from rcu_read_unlock() when a
UAS> PEM> > + * RCU batch was started while the rcu_read_lock/rcu_read_unlo=
ck
UAS> PEM> > + * critical section was executing.
UAS> PEM> > + */
UAS> PEM> > +
UAS> PEM> > +void rcu_quiescent(int cpu)
UAS> PEM> > +{
UAS> PEM>=20
UAS> PEM> What prevents two different CPUs from calling this concurrently?
UAS> PEM> Ah, apparently nothing -- the idea being that
UAS> PEM> rcu_grace_period_complete() sorts it out.  Though if the second
UAS> PEM> CPU was delayed, it seems like it might incorrectly end a
UAS> PEM> subsequent grace period as follows:
UAS> PEM>=20
UAS> PEM> o	CPU 0 clears the second-to-last bit.
UAS> PEM>=20
UAS> PEM> o	CPU 1 clears the last bit.
UAS> PEM>=20
UAS> PEM> o	CPU 1 sees that the mask is empty, so invokes
UAS> PEM> 	rcu_grace_period_complete(), but is delayed in the function
UAS> PEM> 	preamble.
UAS> PEM>=20
UAS> PEM> o	CPU 0 sees that the mask is empty, so invokes
UAS> PEM> 	rcu_grace_period_complete(), ending the grace period.
UAS> PEM> 	Because the RCU_NEXT_PENDING is set, it also starts
UAS> PEM> 	a new grace period.
UAS> PEM>=20
UAS> PEM> o	CPU 1 continues in rcu_grace_period_complete(),
UAS> PEM> incorrectly ending the new grace period.
UAS> PEM>=20
UAS> PEM> Or am I missing something here?
UAS>=20
UAS> The scenario you describe seems possible. However, it should be easily
UAS> fixed by passing the perceived batch number as another parameter to
UAS> rcu_set_state() and making it part of the cmpxchg. So if the caller
UAS> tries to set state bits on a stale batch number (e.g., batch !=3D
UAS> rcu_batch), it can be detected.
UAS>=20
UAS> There is a similar, although harmless, issue in call_rcu(): Two CPUs c=
an
UAS> concurrently add callbacks to their respective nxt list and compute the
UAS> same value for nxtbatch. One CPU succeeds in setting the PENDING bit
UAS> while observing COMPLETE to be clear, so it starts a new batch.

Correction: while observing COMPLETE to be set!

UAS> Afterwards, the other CPU also sets the PENDING bit, but this time for
UAS> the next batch. So it ends up requesting nxtbatch+1, although there is
UAS> no need to. This also would be fixed by making the batch number part of
UAS> the cmpxchg.

Cheers,

	- Udo

--Sig_/D=On9fVYoU4ux6cYEnVJGtM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkzXXjgACgkQnhRzXSM7nSkgawCbB9rYXKIRyN79Np7MXggErF0j
sNwAnjbBMWG2gYM3o3yExW0WIvS4pFDm
=hohB
-----END PGP SIGNATURE-----

--Sig_/D=On9fVYoU4ux6cYEnVJGtM--
