Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0KHK22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 05:28:28 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46607 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab0KHK20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 05:28:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=d74CwsDVBJ0eM06nhHljGrM9St1IdGhHYdSZRfqdMyezKpNWgAbK220SLYW/mNmtnL
         M6R7oKvznswnKKSxKxlR4xACEYwUC1COjpxEVJ01US1EkGebhu0fa7rKoXQ3Ju4x0Hge
         XkNKv7NP8nD6TZrTwZ768nsRB4xOONAqVqJSY=
Date: Mon, 8 Nov 2010 12:28:17 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        sergey.senozhatsky@gmail.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] rcu_read_lock/unlock protect find_task_by_vpid call
Message-ID: <20101108102817.GN27712@swordfish.minsk.epam.com>
References: <20101030093234.GK3932@swordfish.minsk.epam.com>
 <201010302214.DDF98906.MSFJOFtFHOLQVO@I-love.SAKURA.ne.jp>
 <20101030210244.GE2664@linux.vnet.ibm.com>
 <201010310833.CCE89052.FtQFHSOFLOOJMV@I-love.SAKURA.ne.jp>
 <20101107194330.GE15561@linux.vnet.ibm.com>
 <201011080704.GIH17609.SFVQLtJOOHFFMO@I-love.SAKURA.ne.jp>
 <20101108030116.GB2580@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1R6ZDISWaA1muLP0"
Content-Disposition: inline
In-Reply-To: <20101108030116.GB2580@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1R6ZDISWaA1muLP0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (11/07/10 19:01), Paul E. McKenney wrote:
> On Mon, Nov 08, 2010 at 07:04:43AM +0900, Tetsuo Handa wrote:
> > Hello.
> >=20
> > Paul E. McKenney wrote:
> > > > Users missing rcu_read_lock() when calling find_task_by_vpid():
> > > >=20
> > > >   check_clock() in kernel/posix-cpu-timers.c
> > >=20
> > > 	This one has read_lock(&tasklist_lock).
> > >=20
> > Excuse me. Holding tasklist_lock lock does not help.
> > We must call rcu_read_lock() explicitly.
> > That's why 9728e5d6 "kernel/pid.c: update comment on find_task_by_pid_n=
s" was made.
>=20
> OK, good point, there are a few more kernels of unpopped corn here.
>

Hello,
I prepared a patch for posix-cpu-timers.=20

[PATCH] posix-cpu-timers: rcu_read_lock/unlock protect find_task_by_vpid ca=
ll
Reviewed-by: Oleg Nesterov <oleg@redhat.com>

http://lkml.org/lkml/2010/11/3/257


	Sergey

=20
> > I think there are users who needlessly call read_lock(&tasklist_lock)
> > when they can use rcu_read_lock() instead.
> > But I don't know when to use read_lock(&tasklist_lock).
> >=20
> > If read_lock(&tasklist_lock) is needed only when we want to access
> > the "struct task_struct" after rcu_read_unlock(), maybe it is cleaner to
> > use a helper like
> >=20
> > struct task_struct *find_task_and_get(pid_t pid)
> > {
> > 	struct task_struct *task;
> > 	read_lock(&tasklist_lock);
> > 	rcu_read_lock();
> > 	task =3D find_task_by_vpid(pid);
> > 	rcu_read_unlock();
> > 	if (task)
> > 		get_task_struct(task);
> > 	read_unlock(&tasklist_lock);
> > 	return task;
> > }
> >=20
> > and hide tasklist_lock.
>=20
> This makes a lot of sense to me!  That said, most of the current
> open-coded variants of your find_task_and_get() seem to have the
> rcu_read_unlock() after the get_task_struct() rather than before.  But I
> don't claim to understand the locking design of this part of the kernel
> well enough to say which is the best approach.
>=20
> So, either way, will you be submitting the patches for this?
>=20
> 							Thanx, Paul
>=20

--1R6ZDISWaA1muLP0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAkzX0MEACgkQfKHnntdSXjT/jwP9Hg5YinStlYOOSKgUCvcILOZR
+uFJkkNM6M8vPjQafxewngAJMwvl0roP2ZruOtgo2lw21hjZqCQRRoH7T9Cb+1e3
bucscTC2SUOO1BNhLlG0FeRpvd7JUmxzFXeKyAZ2cRd7sZEIqJUUbAz0Ugi0CL/h
ZzKo7/+59hwuWCTmaNA=
=WbCc
-----END PGP SIGNATURE-----

--1R6ZDISWaA1muLP0--
