Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab0KYL1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 06:27:23 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33643 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab0KYL1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 06:27:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pZ9e//JfcZ0i5oDJqO+sf5oH5bqVVsJnezppcc6v4im8+urDVkax37JvA0xUHppuMb
         IxvX4ZCNfDrPWJymLZDXHuBg9/58zsZKoUEjlc2u9D67oWK+s5s+0qvRz6HEV3nl9IQ+
         /CR63EvOin3X3D3qi13RXLcmj0t5U7hgB+2oQ=
Date: Thu, 25 Nov 2010 13:28:00 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, tglx <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: rcu_read_lock/unlock protect find_task_by_vpid call in
 posix_cpu_timer_create
Message-ID: <20101125112800.GA4126@swordfish.minsk.epam.com>
References: <20101125010948.GA1371@redhat.com>
 <1290674436.2072.562.camel@laptop>
 <20101125110230.GB19031@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <20101125110230.GB19031@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On (11/25/10 12:02), Oleg Nesterov wrote:
> (another try, actually add Sergey)
>
Thank you.
=20
> On 11/25, Peter Zijlstra wrote:
> >
> > On Wed, 2010-11-24 at 20:09 -0500, Dave Jones wrote:
> > > --- a/kernel/posix-cpu-timers.c
> > > +++ b/kernel/posix-cpu-timers.c
> > > @@ -391,6 +391,7 @@ int posix_cpu_timer_create(struct k_itimer *new_t=
imer)
> > >  	INIT_LIST_HEAD(&new_timer->it.cpu.entry);
> > >
> > >  	read_lock(&tasklist_lock);
> > > +	rcu_read_lock();
> > >  	if (CPUCLOCK_PERTHREAD(new_timer->it_clock)) {
> > >  		if (pid =3D=3D 0) {
> > >  			p =3D current;
> > > @@ -414,6 +415,7 @@ int posix_cpu_timer_create(struct k_itimer *new_t=
imer)
> > >  	} else {
> > >  		ret =3D -EINVAL;
> > >  	}
> > > +	rcu_read_unlock();
> > >  	read_unlock(&tasklist_lock);
> > >
> > >  	return ret;
> >
> > Do we still need the tasklist_lock in this case?
>=20
> No. posix-cpu-timer.c shouldn't use tasklist at all. But it is not
> completely trivial to remove it.
>=20
> In particular, this patch is not exactly right, we can't trust
> thread_group_leader() without tasklist.
>=20
> Sergey already sent the patch which removes tasklist from
> posix_cpu_timer_create() and posix_cpu_timer_create(), and iirc
> Thomas queued it.
>=20

You're right, Oleg.

Commit-ID:  c0deae8c9587419ab13874b74425ce2eb2e18508
Gitweb:     http://git.kernel.org/tip/c0deae8c9587419ab13874b74425ce2eb2e18=
508
Author:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
AuthorDate: Wed, 3 Nov 2010 18:52:56 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 10 Nov 2010 13:07:06 +0100

posix-cpu-timers: Rcu_read_lock/unlock protect find_task_by_vpid call

queued (15 days so far).


> > Also, why is that think complaining, surely the tasklist_lock pins any
> > and all PID objects?
>=20
> The only problem is: if copy_process() fails, it does free_pid()
> lockless. This means, without rcu lock it is not safe to scan the
> rcu-protected lists.
>=20
> We can change copy_process() (in fact I sent the patch several
> years ago), but everybody think that find_pid/etc should always
> take rcu_read_lock() instead. I tend to agree.
>=20
> Oleg.
>=20

	Sergey
--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAkzuSEAACgkQfKHnntdSXjSp6wQA1TChd/MfycYlsRxVKOvrA+NM
htZqb1PTUqCzKB6sDfmYVk10xSfrY0KLQP7coBeo9lVj7WI8a+NLgXRXGKHPDCjF
r+wqcUBCI3jto90mS3wvcpvD0LqJ5jhNQmg0bVvjFCMZTIuTUOQrDehn3tYlgwAX
2w9ocWbxCNfnxQWzK9E=
=jsav
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
