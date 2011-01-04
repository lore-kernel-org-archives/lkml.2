Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab1ADPzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:55:49 -0500
Received: from ms01.sssup.it ([193.205.80.99]:52248 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751774Ab1ADPzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:55:48 -0500
Subject: [RFC][PATCH 0/3] Refactoring sched_entity and sched_rt_entity.
From: Dario Faggioli <raistlin@linux.it>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Gregory Haskins <ghaskins@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Dhaval Giani <dhaval@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>, Dario <raistlin@linux.it>,
        Darren Hart <darren@dvhart.com>, oleg <oleg@redhat.com>,
        paulmck <paulmck@linux.vnet.ibm.com>, pjt@google.com,
        bharata@linux.vnet.ibm.co, lucas.de.marchi@gmail.com
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qG9ZhoVVHJpClsGsJaFq"
Date: Tue, 04 Jan 2011 16:55:24 +0100
Message-ID: <1294156524.6169.147.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qG9ZhoVVHJpClsGsJaFq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi everybody,

After having heard Peter talking about it many times, I finally decided
to give this thing a spin. It is basically the idea of putting the
current sched_entity and sched_rt_entity together in an union, contained
in a more general structure which hosts the common fields of the twos.
For example, it came out here: http://lkml.org/lkml/2009/7/9/153

Therefore, this patchset _DOES_NOT_ do that! :-O

In fact, this is some preliminary refactoring which I think it's needed
before union-ify the two data structure, and on which I would like to
get some preliminary comments, before going ahead with the wrong
approach.

Basically, I renamed struct sched_entity to struct sched_cfs_entity and
put it and sched_rt_entity inside a more general struct sched_entity...
Is that clear? :-)
The patches just cope with that. Yes, there's some work done by a patch
and undone by the next one. I now it's annoying, and I'm sorry, but I
did such for the sake of reviewability and for making each patch compile
cleanly.
As for the name of CFS's scheduling entities, sched_fair_entity would
probably have been better, but it's longer, and "_cfs" is already
present in many places, so I went for it... No big deal in changing
that, apart from stay-within-80-characters-per-line issues! :-P

They're not inside an union yet, because I'm not sure on how to treat
the task group case. In fact, tasks can only have _just_one_ scheduling
policy at a time, and thus, for example, they need the run_list _or_ the
rb_node for queueing (if the task is RT or fair, respectively), which is
perfect with respect to using an union.
OTOH, groups are always considered both fair _and_ RT entities, for
example they're always queued in _both_ an RT run_list and a fair
rb-tree. So I can't put them in an union, because I need both at the
same time!
Suggestions on how to deal with that will be appreciated.

I compiled and tested this on x86_64, and for [!]SMP, [!]CGROUP_SCHED,
[!]FAIR_GROUP_SCHED, [!]RT_GROUP_SCHED and [!]SCHEDSTATS, and some
combinations of these, but can't guarantee full coverage of all the
possibilities yet... Working on it, in the meanwhile, forgive me if you
find some configuration that does not build. ;-D

And as usual, comments of any kind are very very welcome! :-)

Thanks and Regards,
Dario Faggioli=20

[RFC][PATCH 0/3] Refactoring sched_entity and sched_rt_entity.
 include/linux/init_task.h |    8 +-
 include/linux/sched.h     |   35 ++-
 kernel/kthread.c          |    2 +-
 kernel/posix-cpu-timers.c |    4 +-
 kernel/sched.c            |  210 +++++++++------
 kernel/sched_debug.c      |   20 +-
 kernel/sched_fair.c       |  636 ++++++++++++++++++++++++-----------------=
----
 kernel/sched_rt.c         |   58 ++--
 8 files changed, 534 insertions(+), 439 deletions(-)

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-qG9ZhoVVHJpClsGsJaFq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0jQuwACgkQk4XaBE3IOsSiEgCfXKgiVliu7bdjQo3ugKj+wuBU
jiUAoJ5nTZtMIIkNL/i9RbV06je7pIHj
=TR9t
-----END PGP SIGNATURE-----

--=-qG9ZhoVVHJpClsGsJaFq--

