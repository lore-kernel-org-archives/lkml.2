Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab0KKSd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:33:27 -0500
Received: from ms01.sssup.it ([193.205.80.99]:42387 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753348Ab0KKSdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:33:25 -0500
Subject: Re: [RFC][PATCH 05/22] sched: SCHED_DEADLINE policy implementation
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
In-Reply-To: <1289485023.2084.117.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333814.8661.146.camel@Palantir>  <1289485023.2084.117.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eMIU+LDd6+6W2wYkiZMY"
Date: Thu, 11 Nov 2010 19:33:08 +0100
Message-ID: <1289500388.6525.85.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eMIU+LDd6+6W2wYkiZMY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-11-11 at 15:17 +0100, Peter Zijlstra wrote:
> > +       dl_se->runtime -=3D delta_exec;
> > +       if (dl_runtime_exceeded(rq, dl_se)) {
> > +               __dequeue_task_dl(rq, curr, 0);
> > +               if (likely(start_dl_timer(dl_se)))
> > +                       dl_se->dl_throttled =3D 1;
> > +               else
> > +                       enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
> > +
> > +               resched_task(curr);
> > +       }
> > +}=20
>=20
> So you keep the current task in the rb-tree?=20
>
Yes, I do.

> If you remove the current
> task from the tree you don't have to do the whole dequeue/enqueue thing.
> Then again, I guess it only really matters once you push the deadline,
> which shouldn't be that often.
>=20
I'm not sure. The likelihood of runtime overrun/deadline pushing depends
on many things, and might happen even if nothing is going bad... Might
be wanted actually!

Suppose you have some sporadic task of some sort with computation ~10ms
and (minimum) interarrival time of jobs of 100ms. Moreover, I want it to
be able to react with a latency in the order of 100us. If I give it
10ms/100ms (or maybe 12ms/100ms, or whatever overprovisioning is
considered enough to be safe), and an instance arrives as soon as the it
has been throttled I may have to wait for 90ms (88, ?).
Thus, I give it 10us/100us, which means it won't stay throttled for more
tha 90us, but also that it's runtime will be exhausted (and it's
deadline pushed away) 1000 times for a typical instance!

Forgive me for the stupid example... What I was trying to point out is
that, especially considering we don't (want to!) have rock solid WCET
analysis, too much bias toward the case were the scheduling parameters
perfectly matches the applications' ones would not be as much
preferable.

For this reasons, I structured the code this way, and it seems to me
that keeping current out the the tree would complicate the code quite a
bit, but I'm also sure it's doable if you really think it is needed.
Just let me know... :-)

> Also, you might want to put a conditional around that resched, no point
> rescheduling if you're still the leftmost task.
>=20
Right. This should be done, indeed.

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-eMIU+LDd6+6W2wYkiZMY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzcNuQACgkQk4XaBE3IOsTTewCgqMNYLKZ2+nVTOYlH3qsF0buH
7rQAn3AbalUL4VKj30CA1YbMUcwjc8rv
=myax
-----END PGP SIGNATURE-----

--=-eMIU+LDd6+6W2wYkiZMY--

