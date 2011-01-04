Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab1ADS5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 13:57:36 -0500
Received: from ms01.sssup.it ([193.205.80.99]:34276 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751348Ab1ADS5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 13:57:35 -0500
Subject: Re: [RFC][PATCH 0/3] Refactoring sched_entity and sched_rt_entity.
From: Dario Faggioli <raistlin@linux.it>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Gregory Haskins <ghaskins@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Dhaval Giani <dhaval@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Darren Hart <darren@dvhart.com>, oleg <oleg@redhat.com>,
        paulmck <paulmck@linux.vnet.ibm.com>, pjt@google.com,
        bharata@linux.vnet.ibm.co
In-Reply-To: <AANLkTi=G1b3OHH1ZUGCcL+nnb3LaeUDMWsXk8z+FzWT2@mail.gmail.com>
References: <1294156524.6169.147.camel@Palantir>
	 <AANLkTi=wCmetef0tjfvdHtZMS9x4eswhL_xAM5Ybdwq+@mail.gmail.com>
	 <1294163897.6169.172.camel@Palantir>
	 <AANLkTi=G1b3OHH1ZUGCcL+nnb3LaeUDMWsXk8z+FzWT2@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DJIv3bGKFIEH4zSK/7bJ"
Date: Tue, 04 Jan 2011 19:57:10 +0100
Message-ID: <1294167430.6169.227.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DJIv3bGKFIEH4zSK/7bJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-01-04 at 16:29 -0200, Lucas De Marchi wrote:=20
> > Mmm... do I? While I'm cloning your git, could you elaborate a bit on
> > why, because I don't seem to see that... :-P
>=20
> Suppose a RT task blocks on a PI-mutex, the lock owner will be boosted
> to RT and go through a class change in rt_mutex_setprio().
> Since now a class change reinitializes the class-specific, if fair and
> rt fields are on the same memory space, we need to save the
> sched_fair_entity before changing the class to RT and put it again
> when going back to the fair class.
>=20
Well, I know, but you're deactivating+dequeueing and then
activating+enqueueing it back and forth within the proper scheduling
class, so that shouldn't be a big deal...

Actually, the point might be that forgetting something like, e.g.,
vruntime would then lead to unexpected behaviour when the task is back
to fair scheduling, but do we need to cache the whole sched_[cfs|
fair]_entity for that?

> Quoting Peter about this:
>=20
>  [ Initially I was thinking not, because the task slept we'll have to
> reinsert it in the rb-tree anyway, but upon further consideration
> that'll loose the old vruntime setting, which can lead to an unseemly
> gain of time in place_entity()'s never backward check failing.
>=20
> So yes, we'd have to place a copy of the old sched_entity in struct
> rt_mutex_waiter, not very hard to do. ]
>=20
Ok, exactly, I now see that, and it's probably not hard to do... But I'm
now thinking of how many fields must be saved to avoid this. Surely, not
these ones:
...=20
	struct rb_node          run_node;
	struct list_head        group_node;

#ifdef CONFIG_FAIR_GROUP_SCHED
	struct sched_cfs_entity *parent;
	/* rq on which this entity is (to be) queued: */
	struct cfs_rq           *cfs_rq;
	/* rq "owned" by this entity/group: */
	struct cfs_rq           *my_q;
#endif
...

I'll double check, but if it's just a matter of vruntime and a couple of
other u64, isn't it worth to just save them?

Thanks and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-DJIv3bGKFIEH4zSK/7bJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0jbYYACgkQk4XaBE3IOsTBTQCgkSH/imyq1n7ld9IW5Ju5bcPo
zOIAn1CT/0BuftBHHxR4qrARPkwG+aHl
=k4CT
-----END PGP SIGNATURE-----

--=-DJIv3bGKFIEH4zSK/7bJ--

