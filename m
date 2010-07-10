Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab0GJJBn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 05:01:43 -0400
Received: from ms01.sssup.it ([193.205.80.99]:47822 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751511Ab0GJJBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 05:01:41 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Bjoern Brandenburg <bbb@email.unc.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <1278693304.1900.266.camel@laptop>
References: <1278682707.6083.227.camel@Palantir>
	 <1278685133.1900.201.camel@laptop>
	 <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu>
	 <1278693304.1900.266.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5uZ9Vo1A4n65HVVgkDMj"
Date: Sat, 10 Jul 2010 11:01:29 +0200
Message-ID: <1278752489.4390.97.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5uZ9Vo1A4n65HVVgkDMj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-07-09 at 18:35 +0200, Peter Zijlstra wrote:
> I think the easiest path for now would indeed be to split between hard
> and soft rt tasks, and limit hard to d=3D=3Dp, and later worry about
> supporting d<p for hard.
>=20
Mmm... I see... Are you thinking of another scheduling class? Or maybe
just another queue with "higher priority" inside the same scheduling
class (sched_dl.c)?

I mean I can do both, so I prefer to do what you like most in the first
place, instead of having to do it twice!! :-P

Maybe having two policies inside the same class (maybe handled in
separate queues/rb-trees) might save a lot of code duplication.
If we want to go like this, suggestions on the name(s) of the new (or of
both) policy(-ies) are more than welcome. :-D

> It will very much depend on how we're going to go about doing things
> with that 'load-balancer' thingy anyway.
>=20
Agree. The "load-balancer" right now pushes/pulls tasks to/from the
various runqueue --just how the saame thing happens in sched-rt-- to,
say, approximate G-EDF. Code is on the git... I just need some time to
clean up a little bit more and post the patches, but it's already
working at least... :-)

> The idea is that we approximate G-EDF by moving tasks around, but Dario
> told me the admission tests are still assuming P-EDF.
>=20
Yep, as said above, that's what we've done since now. Regarding
"partitioned admission", let me try to explain this.

You asked me to use sched_dl_runtime_us/sched_dl_period_us to let people
decide how much bandwidth should be devoted to EDF tasks. This obviously
yields to _only_one_ bandwidth value that is then utilized as the
utilization cap on *each* CPU, mainly for consistency reasons with
sched_rt_{runtime,period}_us. At that time I was using such value as the
"overall EDF bandwidth", but I changed to your suggested semantic.

Obviously this works perfectly as long as tasks stay on the CPU were
they are created, and if they're manually migrated (by explicitly
changing their affinity) I can easily check if there's enough bandwidth
on the target CPU, and if yes move the task and its bandwidth there.
That's how things were before the 'load-balancer' (and still does, if
you set affinities of tasks so to have a fully partitioned setup).

With global scheduling in place, we have this new situation. A task is
forked on a CPU (say 0), and I allow that if there's enough bandwidth
for it on that processor (and obviously, if yes, I also consume such
amount of bw). When the task is dynamically migrated to CPU 1 I have two
choices:
 (a) I move the bandwidth it occupies from 0 to 1 or,
 (b) I leave it (the bw, not the task) where it is, on 0.

If I go for (b) and the scheduler wants to move a 0.2 task from CPU 0=20
(loaded up to 1.0) to CPU 1 loaded up to 0.9, I'm having a "transitory"
situation with load 0.7 on CPU 0 and load 1.1 on CPU 1 --which I really
don't like--, but at least I'm still enforcing Sum_i(EDFtask_i)<1.9.
Moreover, If a new 0.1 task is being forked by someone on CPU 1
(independently whether it finds 1.1 or 1.0 load there), it will fail,
even if there is room for it in the system (on CPU 1) --which I really
don't like!! This is what, as I said to Peter in Brussels, I mean with
"still partitioned" admission test.

If I go for (a), and again the scheduler tries to move a 0.2 task from
CPU 0 (loaded up to 1) to CPU 1 (loaded up to 0.9) I again have, two
choices, failing or permitting this. Failing would mean another
limitation to global scheduling --which I really don't like-- but
allowing that would mean that another task of 0.2 can be created on CPU
0 so that I end up in bw(CPU0)+bw(CPU1)=3D1+1.1=3D2.1 --which I really don'=
t
like!! :-O :-O

More-moreover, if my bw limit is 0.7 on each of the 2 CPUs I have,
keeping the bandwidth separated forbids me to create a 0.2 task if both
the CPU are loaded up to 0.6, while it probably could be scheduled,
since we have global EDF! :-O

If you look at the code, you'll find (b) implemented right now, but, as
you might have understood, it's something I really don't like! :-(

If we want something better I cannot think on anything that doesn't
include having a global (per-domain should be fine as well) mechanism
for bandwidth accounting...

> Add to that the interesting problems of task affinity and we might soon
> all have a head-ache ;-)
>=20
We right now support affinity, i.e., tasks will be pushed/pulled to/by
CPUs where they can run. I'm not aware of any academic work that
analyzes such a situation, but this doesn't mean we can't figure
something out... Just to give people an example of "why real-time
scheduling theory still matters"!! ;-P ;-P

> One thing we can do is limit the task affinity to either 1 cpu or all
> cpus in the load-balance domain. Since there don't yet exist any
> applications we can disallow things to make life easier.
>=20
> If we only allow pinned tasks and free tasks, splitting the admission
> test in two would suffice I think, if keep one per-cpu utilization
> measure and use the maximum of these over all cpus to start the global
> utilization measure, things ought to work out.
>
Ok, that seems possible to me, but since I have to write the code you
must tell me what you want the semantic of (syswide and per-group)
sched_dl_{runtime,period} to become and how should I treat them! :-)

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-5uZ9Vo1A4n65HVVgkDMj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkw4NukACgkQk4XaBE3IOsTBqQCeNL52H24LthQjHhXG+aJo0Yrg
soUAoI4MwBN5y2Saccs84BUS51iXv3Fj
=DGkP
-----END PGP SIGNATURE-----

--=-5uZ9Vo1A4n65HVVgkDMj--

