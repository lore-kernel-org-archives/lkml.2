Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab0LWRie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 12:38:34 -0500
Received: from ms01.sssup.it ([193.205.80.99]:54197 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753322Ab0LWRid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 12:38:33 -0500
Subject: Re: [PATCH] Read THREAD_CPUTIME clock from other  processes.
From: Dario Faggioli <raistlin@linux.it>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, torbenh <torbenh@gmx.de>,
        john.stultz@linaro.org, roland@redhat.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
In-Reply-To: <20101223164453.GA13111@redhat.com>
References: <1293121303.3390.185.camel@Palantir>
	 <20101223164453.GA13111@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OKHdrUfutEDvLgXul+R7"
Date: Thu, 23 Dec 2010 18:38:21 +0100
Message-ID: <1293125901.2748.10.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OKHdrUfutEDvLgXul+R7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-12-23 at 17:44 +0100, Oleg Nesterov wrote:=20
> > Therefore, this patch removes such limitation and enables the
> > following behaviour, for the threaded and process-based case,
> > respectively:
>=20
> Can't comment, I never understood this.
>=20
If I can ask... What's that you never understood? Why the limitation is
there? Or something else?

> >  	rcu_read_lock();
> >  	p =3D find_task_by_vpid(pid);
> > -	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
> > -		   same_thread_group(p, current) : has_group_leader_pid(p))) {
> > +	if (!p)
> >  		error =3D -EINVAL;
> > -	}
>=20
> This changes the behaviour of sys_clock_settime(). Probably doesn't
> matter since it does nothing, but perhaps !CPUCLOCK_PERTHREAD &&
> !group_leader should result in -EINAVL as before.
>=20
Oops, sure, you're right, I can fix this. :-)

> > @@ -349,18 +347,21 @@ int posix_cpu_clock_get(const clockid_t which_clo=
ck, struct timespec *tp)
> >  		rcu_read_lock();
> >  		p =3D find_task_by_vpid(pid);
> >  		if (p) {
> > -			if (CPUCLOCK_PERTHREAD(which_clock)) {
> > -				if (same_thread_group(p, current)) {
> > -					error =3D cpu_clock_sample(which_clock,
> > -								 p, &rtn);
> > -				}
> > +
> > +			if (CPUCLOCK_PERTHREAD(which_clock) &&
> > +			    same_thread_group(p, current)) {
> > +				error =3D cpu_clock_sample(which_clock,
> > +							 p, &rtn);
> >  			} else {
> >  				read_lock(&tasklist_lock);
> > -				if (thread_group_leader(p) && p->sighand) {
> > +				if (!CPUCLOCK_PERTHREAD(which_clock) &&
> > +				    thread_group_leader(p) && p->sighand)
> >  					error =3D
> >  					    cpu_clock_sample_group(which_clock,
> > -							           p, &rtn);
> > -				}
> > +								   p, &rtn);
> > +				else
> > +					error =3D cpu_clock_sample(which_clock,
> > +								 p, &rtn);
> >  				read_unlock(&tasklist_lock);
>=20
> Can't understand... why did you duplicate cpu_clock_sample() ?
>=20
> IOW, it seems to me you could simply kill the
> "if (same_thread_group(p, current)) {" line with the same efect, no?
>=20
Well, yes, but looking at the original code I thought that in the !
same_thread_group() case I might need the tasklist_lock...

Am I wrong? Is it there just because of cpu_clock_sample_group()?

Thanks and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-OKHdrUfutEDvLgXul+R7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0TiQ0ACgkQk4XaBE3IOsT8ngCfT+Cm5bFHjLbK8ac3aqa8UdHo
vwcAn2syTxMkFM2eSaRsv37xvk6yQp/I
=yA99
-----END PGP SIGNATURE-----

--=-OKHdrUfutEDvLgXul+R7--

