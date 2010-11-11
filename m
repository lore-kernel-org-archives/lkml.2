Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab0KKBCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 20:02:20 -0500
Received: from ms01.sssup.it ([193.205.80.99]:59630 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757401Ab0KKBCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 20:02:19 -0500
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
In-Reply-To: <1289418214.2084.48.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333814.8661.146.camel@Palantir>  <1289418214.2084.48.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-WRPI+puqxdqNDydKB5YJ"
Date: Thu, 11 Nov 2010 02:02:05 +0100
Message-ID: <1289437325.13577.445.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WRPI+puqxdqNDydKB5YJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-11-10 at 20:43 +0100, Peter Zijlstra wrote:
> On Fri, 2010-10-29 at 08:30 +0200, Raistlin wrote:
> > + * We are being explicitly informed that a new instance is starting,
> > + * and this means that:
> > + *  - the absolute deadline of the entity has to be placed at
> > + *    current time + relative deadline;
> > + *  - the runtime of the entity has to be set to the maximum value.
>=20
> When exactly are we a new instance? From a quick look dl_new gets set
> after a sched_setscheduler() call, is that the only way?
>=20
One of the only two ways. Later in the queue, that flag is set by a new
system call, i.e., sched_wait_interval, that can be used to inform the
scheduler (for example at the end of a periodic/sporadic job) that an
instance just ended. Moreover, it can be exploited by a task which want
the scheduler to wake it up when it can be given its full runtime.
It as been added as a consequence of the discussion happened in Dresden,
at last year RTLWS, aside of my presentation...

Whether or not this could be useful, I don't know, and I accept comments
as usual. My opinion is that it might be something worthwhile to have,
especially from the point of view of hard real-time-ish scenarios, but
we can remove it appears unnecessary.

> Could a task calling sched_setscheduler() on itself cheat the system?
>
I obviously might be wrong (especially at this time), but I would say no
for the following reasons.

If you are an overrunning -deadline task calling sched_setscheduler()
the deactivate_task->dequeue_task->dequeue_task_dl() below will trigger
the bandwidth enforcement, i.e., will set dl_throttled=3D1 and start
dl_timer:
	...
        on_rq =3D p->se.on_rq;                                             =
                                            =20
        running =3D task_current(rq, p);                                   =
                                            =20
        if (on_rq)
                deactivate_task(rq, p, 0);
        if (running)
                p->sched_class->put_prev_task(rq, p);
	...

Later, this enqueue:
	...
	if (running)                                                              =
                                   =20
                p->sched_class->set_curr_task(rq);                         =
                                          =20
        if (on_rq) {
                activate_task(rq, p, 0);                                   =
                                          =20
                                                                           =
                                          =20
                check_class_changed(rq, p, prev_class, oldprio, running);
        }
	...

even if it will find dl_new=3D1, will not enqueue the task back in its
dl_rq (since dl_throttled=3D1). The actual enqueueing happens at the
firing of dl_timer, where an update instead than a replenishment will be
performed, right because of the fact that dl_new=3D1. This means the
runtime will be fully replenished and the deadline moved toward
rq->clock+dl_se->dl_deadline.

Did this answer your question?

Thanks and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-WRPI+puqxdqNDydKB5YJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzbQI0ACgkQk4XaBE3IOsRuHwCfb8AaTHS07d0u93HMYstvh3Tp
FC8AnA6FfuUvp4WjzZi2OOuYAG4pW0kh
=C9cI
-----END PGP SIGNATURE-----

--=-WRPI+puqxdqNDydKB5YJ--

