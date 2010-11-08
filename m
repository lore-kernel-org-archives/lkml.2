Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab0KHChK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 21:37:10 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:39475 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab0KHChJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 21:37:09 -0500
Date: Mon, 8 Nov 2010 03:11:36 +0100
From: "Udo A. Steinberg" <udo@hypervisor.org>
To: paulmck@linux.vnet.ibm.com
Cc: Joe Korty <joe.korty@ccur.com>, fweisbec@gmail.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH] a local-timer-free version of RCU
Message-ID: <20101108031136.0766149f@laptop.hypervisor.org>
In-Reply-To: <20101106192812.GI15561@linux.vnet.ibm.com>
References: <20101104232148.GA28037@linux.vnet.ibm.com>
	<20101105210059.GA27317@tsunami.ccur.com>
	<20101106192812.GI15561@linux.vnet.ibm.com>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/IFZ/RhRDAMbWDgTaLvmOIp/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/IFZ/RhRDAMbWDgTaLvmOIp/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 6 Nov 2010 12:28:12 -0700 Paul E. McKenney (PEM) wrote:

PEM> > + * rcu_quiescent() is called from rcu_read_unlock() when a
PEM> > + * RCU batch was started while the rcu_read_lock/rcu_read_unlock
PEM> > + * critical section was executing.
PEM> > + */
PEM> > +
PEM> > +void rcu_quiescent(int cpu)
PEM> > +{
PEM>=20
PEM> What prevents two different CPUs from calling this concurrently?
PEM> Ah, apparently nothing -- the idea being that
PEM> rcu_grace_period_complete() sorts it out.  Though if the second CPU was
PEM> delayed, it seems like it might incorrectly end a subsequent grace
PEM> period as follows:
PEM>=20
PEM> o	CPU 0 clears the second-to-last bit.
PEM>=20
PEM> o	CPU 1 clears the last bit.
PEM>=20
PEM> o	CPU 1 sees that the mask is empty, so invokes
PEM> 	rcu_grace_period_complete(), but is delayed in the function
PEM> 	preamble.
PEM>=20
PEM> o	CPU 0 sees that the mask is empty, so invokes
PEM> 	rcu_grace_period_complete(), ending the grace period.
PEM> 	Because the RCU_NEXT_PENDING is set, it also starts
PEM> 	a new grace period.
PEM>=20
PEM> o	CPU 1 continues in rcu_grace_period_complete(), incorrectly
PEM> 	ending the new grace period.
PEM>=20
PEM> Or am I missing something here?

The scenario you describe seems possible. However, it should be easily fixed
by passing the perceived batch number as another parameter to rcu_set_state=
()
and making it part of the cmpxchg. So if the caller tries to set state bits
on a stale batch number (e.g., batch !=3D rcu_batch), it can be detected.

There is a similar, although harmless, issue in call_rcu(): Two CPUs can
concurrently add callbacks to their respective nxt list and compute the same
value for nxtbatch. One CPU succeeds in setting the PENDING bit while
observing COMPLETE to be clear, so it starts a new batch. Afterwards, the
other CPU also sets the PENDING bit, but this time for the next batch. So
it ends up requesting nxtbatch+1, although there is no need to. This also
would be fixed by making the batch number part of the cmpxchg.

Cheers,

	- Udo

--Sig_/IFZ/RhRDAMbWDgTaLvmOIp/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkzXXFkACgkQnhRzXSM7nSkPuQCeIoTlzCTAG0nAyXy9CRqgi53i
7asAnAwqyjXL/K2P0DcSVJYU8eIiIhtZ
=V9Np
-----END PGP SIGNATURE-----

--Sig_/IFZ/RhRDAMbWDgTaLvmOIp/--
