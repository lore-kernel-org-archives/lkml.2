Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab0L1Vil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 16:38:41 -0500
Received: from ms01.sssup.it ([193.205.80.99]:39308 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751016Ab0L1Vik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 16:38:40 -0500
Subject: Re: [PATCH resend] Reading POSIX CPU timer from outside the
 process.
From: Dario Faggioli <raistlin@linux.it>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, torbenh <torbenh@gmx.de>,
        john.stultz@linaro.org, roland@redhat.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
In-Reply-To: <20101228163829.GA26533@redhat.com>
References: <1293121303.3390.185.camel@Palantir>
	 <1293533742.2899.1028.camel@Palantir>  <20101228163829.GA26533@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-k17XL+3jgXoim0gF6uvO"
Date: Tue, 28 Dec 2010 22:38:24 +0100
Message-ID: <1293572304.2899.1214.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-k17XL+3jgXoim0gF6uvO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-12-28 at 17:38 +0100, Oleg Nesterov wrote:=20
> This patch doesn't look right,
>=20
Sorry then... :-(

> > All that because clock_getcpuclockid forbids accessing thread
> > specific CPU-time clocks from outside the thread group,
>=20
> First of all, linux has no clock_getcpuclockid() system call, so
> the changelog looks confusing.
>=20
Sure, you're right, this could have been more clear.

> >  	rcu_read_lock();
> >  	p =3D find_task_by_vpid(pid);
> > -	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
> > -		   same_thread_group(p, current) : has_group_leader_pid(p))) {
> > +	if (!p || (CPUCLOCK_PERTHREAD(which_clock) &&
> > +		   same_thread_group(p, current) && !has_group_leader_pid(p)))
> >  		error =3D -EINVAL;
> > -	}
> >  	rcu_read_unlock();
>=20
> How so? For example, with this change
> clock_getres(MAKE_THREAD_CPUCLOCK(pid_of_sub_thread)) won't work, no?
>=20
I tested all the clock_getres() calls that came to my mind (at least the
one that are possible from an userspace program), and they always worked
because of this (still in check_clock):

        const pid_t pid =3D CPUCLOCK_PID(which_clock);

        if (pid =3D=3D 0)
                return 0;

Which triggers all the times, except when you actually try to get a CPU
clockid from outside the process, but that's not possible with getres.

Anyway, looking at the code again I agree, it may work, but it's not
something I really like! :-|

The whole point was about, given the current implementation of
clock_getcpuclockid done by glibc, can we remove that "failed with
success" (showed in the changelog) thing and come up with some
meaningful clockid for that situation? It's more than possible for the
answer to be no!!! :-P

> I think, if we want to remove this limitation, we need something
> like the patch below. If it doesn't help, we should fix glibc.
>=20
> --- x/kernel/posix-cpu-timers.c
> +++ x/kernel/posix-cpu-timers.c
> @@ -39,10 +39,8 @@ static int check_clock(const clockid_t w
> =20
>  	rcu_read_lock();
>  	p =3D find_task_by_vpid(pid);
> -	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
> -		   same_thread_group(p, current) : has_group_leader_pid(p))) {
> +	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) || has_group_leader_pid(p))=
)
>  		error =3D -EINVAL;
> -	}
>  	rcu_read_unlock();
>
Which won't work because CPUCLOCK_PERTHREAD(which_clock) is always false
in this case.=20

> 	return error;
> @@ -350,10 +348,7 @@ int posix_cpu_clock_get(const clockid_t=20
>  		p =3D find_task_by_vpid(pid);
>  		if (p) {
>  			if (CPUCLOCK_PERTHREAD(which_clock)) {
> -				if (same_thread_group(p, current)) {
> -					error =3D cpu_clock_sample(which_clock,
> -								 p, &rtn);
> -				}
> +				error =3D cpu_clock_sample(which_clock, p, &rtn);
Same as above... To the point that I'm now wondering if we ever take
this branch here...

BTW, again, I see your point, the fix might need to happen at glibc
level. I'll check that and come back if I find something interesting.

Thanks anyway,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-k17XL+3jgXoim0gF6uvO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0aWMgACgkQk4XaBE3IOsToRQCfXvTuRt5pIQ33biAp3p9nDe2m
WxkAnRjWMRkSgbemBixLY4HZYyL+SAA4
=yqxW
-----END PGP SIGNATURE-----

--=-k17XL+3jgXoim0gF6uvO--

