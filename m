Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0KNJPS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 04:15:18 -0500
Received: from ms01.sssup.it ([193.205.80.99]:60925 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754330Ab0KNJPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 04:15:14 -0500
Subject: Re: [RFC][PATCH 07/22] sched: SCHED_DEADLINE push and pull logic
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1289578673.2084.314.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333935.8661.148.camel@Palantir>  <1289578673.2084.314.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zT/FI6JcXiYIgMtKP8Ww"
Date: Sun, 14 Nov 2010 10:14:59 +0100
Message-ID: <1289726099.6632.53.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zT/FI6JcXiYIgMtKP8Ww
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-11-12 at 17:17 +0100, Peter Zijlstra wrote:
> On Fri, 2010-10-29 at 08:32 +0200, Raistlin wrote:
> > Add dynamic migrations to SCHED_DEADLINE, so that tasks can
> > be moved among CPUs when necessary. It is also possible to bind a
> > task to a (set of) CPU(s), thus restricting its capability of
> > migrating, or forbidding migrations at all.
> >=20
> > The very same approach used in sched_rt is utilised:
> >  - -deadline tasks are kept into CPU-specific runqueues,
> >  - -deadline tasks are migrated among runqueues to achieve the
> >    following:
> >     * on an M-CPU system the M earliest deadline ready tasks
> >       are always running;
> >     * affinity/cpusets settings of all the -deadline tasks is
> >       always respected.=20
>=20
> I haven't fully digested the patch, I keep getting side-tracked and its
> a large patch..=20
>
BTW, I was thinking about your suggestion of adding a *debugging* knob
for achieving a "lock everything while I'm migrating" behaviour... :-)

Something like locking the root_domain during pushes and pulls won't
probably work, since both of them do a double_lock_balance, taking two
rq, which might race with this new "global" lock.
Something like we (CPU#1) hold rq1->lock, we take rd->lock, and then we
try to take rq2->lock. CPU#2 holds rq2->lock and try to take rd->lock.
Stuck! :-(
This should be possible if both CPU#1 and CPU#2 are into a push or a
pull which, on each one, involves some task on the other. Do you agree,
or I'm missing/mistaking something? :-)

Something we can probably do is locking the root_domain for
_each_and_every_ scheduling decision, having all the rq->locks nesting
inside our new root_domain->lock. This would emulate some sort of unique
global rq implementation, since also local decisions on a CPU will
affect all the others, as if they were sharing a single rq... But it's
going to be very slow on large machines (but I guess we can afford
that... It's debugging!), and will probably affect other scheduling
class.
I'm not sure we want the latter... But maybe it could be useful for
debugging others too (at least for FIFO/RR, it should be!).

Let me know what you think...

Thanks and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-zT/FI6JcXiYIgMtKP8Ww
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzfqJMACgkQk4XaBE3IOsRUHACfUpeO2hGrr4/bjbgMVmsYj9V0
IPkAoJDmLolZ4ZM7IvNMr0GR5144EJAl
=uAqF
-----END PGP SIGNATURE-----

--=-zT/FI6JcXiYIgMtKP8Ww--

