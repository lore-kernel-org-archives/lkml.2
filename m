Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab0KBQCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 12:02:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46994 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab0KBQC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:02:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZbrrEIKer/TJ1XJXSW28GgK/0lYsMZtg4LkVTWIUrzsemBkorwpOUiKj2XAvjSt2V4
         W3v8C9HvyG7oZyrxaUv9VAPezVlzvatZE8VMgFoOoitB7Ive+Kk7mVYu6iZ/CUiCyY1Q
         Z9YaqQnN3zgaP3DB3RS1LMDjHWyxKUTDaDyls=
Date: Tue, 2 Nov 2010 18:02:23 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix-cpu-timers: rcu_read_lock/unlock protect
 find_task_by_vpid call
Message-ID: <20101102160223.GC5964@swordfish.minsk.epam.com>
References: <20101102135821.GA5964@swordfish.minsk.epam.com>
 <alpine.LFD.2.00.1011021630150.9357@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011021630150.9357@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (11/02/10 16:31), Thomas Gleixner wrote:
> On Tue, 2 Nov 2010, Sergey Senozhatsky wrote:
>=20
> > Commit 4221a9918e38b7494cee341dda7b7b4bb8c04bde "Add RCU check for
> > find_task_by_vpid()" introduced rcu_lockdep_assert to find_task_by_pid_=
ns.
> > Add rcu_read_lock/rcu_read_unlock to call find_task_by_vpid.
> >=20
> > Tetsuo Handa wrote:
> >=20
> > Quoting from one of posts in that thead
> > http://kerneltrap.org/mailarchive/linux-kernel/2010/2/8/4536388
> >=20
> > | Usually tasklist gives enough protection, but if copy_process() fails
> > | it calls free_pid() lockless and does call_rcu(delayed_put_pid().  =
=20
> > | This means, without rcu lock find_pid_ns() can't scan the hash table
> > | safely.
>=20
> We can remove the tasklist_lock while at it. rcu_read_lock is enough.
>=20

Please kindly review.

---

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 6842eeb..96fe2a3 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -37,13 +37,13 @@ static int check_clock(const clockid_t which_clock)
 	if (pid =3D=3D 0)
 		return 0;
=20
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p =3D find_task_by_vpid(pid);
 	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
 		   same_thread_group(p, current) : thread_group_leader(p))) {
 		error =3D -EINVAL;
 	}
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
=20
 	return error;
 }
@@ -390,7 +390,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
=20
 	INIT_LIST_HEAD(&new_timer->it.cpu.entry);
=20
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	if (CPUCLOCK_PERTHREAD(new_timer->it_clock)) {
 		if (pid =3D=3D 0) {
 			p =3D current;
@@ -414,7 +414,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
 	} else {
 		ret =3D -EINVAL;
 	}
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
=20
 	return ret;
 }


--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAkzQNg8ACgkQfKHnntdSXjRuhQP+ONFknVgP4Cpn2wqBy4l+oWE+
HANj1+v2D1Wjspl90nIBbgZ28LRbXxCu1nBckAom4X1esVB5J6WoFFPqII4boD4G
zoIaoy+FXz9n0Cb4z8N+KCrkfsaS2eiRqWUdvb6otuyZqhRCp/aVvAhOiw/j+uok
jvzl0IsaqeVr0X9qYG8=
=MPj2
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
