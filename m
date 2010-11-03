Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab0KCK62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:58:28 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42193 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab0KCK6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:58:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aO61/zAak7dnWdJi3dsvzcArfhEWtSalUhYl/OvyKnfVVw6KWFih3W4RSxTYeOzCYr
         WB5TJxWY3An3XqfodtaZ2sJLYv3kU/G0u9B2UBaqBwgs92aq59xN1fgegatXaVZYWC2J
         lRSuazY1fm8YOY/N7i/2448YcjDbC5DMtl/lE=
Date: Wed, 3 Nov 2010 12:58:32 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH] posix-cpu-timers: rcu_read_lock/unlock protect
 find_task_by_vpid call
Message-ID: <20101103105832.GA30053@swordfish.minsk.epam.com>
References: <20101102135821.GA5964@swordfish.minsk.epam.com>
 <alpine.LFD.2.00.1011021630150.9357@localhost6.localdomain6>
 <20101102160223.GC5964@swordfish.minsk.epam.com>
 <alpine.LFD.2.00.1011021704110.9357@localhost6.localdomain6>
 <20101102183308.GA17720@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <20101102183308.GA17720@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (11/02/10 19:33), Oleg Nesterov wrote:
> > On Tue, 2 Nov 2010, Sergey Senozhatsky wrote:
> >
> > > > We can remove the tasklist_lock while at it. rcu_read_lock is enoug=
h.
> > > >
>=20
> Yes, I believe posix-cpu-timers.c shouldn't use tasklist at all,
> but it is not trivial to change this code.
>
>[..]=20
>=20
> I think this change is fine, but please note that thread_group_leader()
> check is not relaible without tasklist. If we race with de_thread()
> find_task_by_vpid() can find the new leader before it updates its
> ->group_leader. IOW, posix_cpu_timer_create() can fail when it shouldn't.
>=20
> Not that I think this really matters, posix_cpu_timer_create() has
> other problems with de_thread(). But perhaps it makes sense to
> change posix_cpu_timer_create() to use has_group_leader_pid() instead,
> just to make this code not look racy and avoid adding new problems.
>=20
> The real fix, I think, should change cpu_timer_list to use
> struct pid* instead of task_struct.
>=20

Hello,
Using has_group_leader_pid instead of thread_group_leader, when tasklist_lo=
ck=20
is not aquired (check_clock and posix_cpu_timer_create).

---

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 6842eeb..05bb717 100644
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
-		   same_thread_group(p, current) : thread_group_leader(p))) {
+		   same_thread_group(p, current) : has_group_leader_pid(p))) {
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
@@ -404,7 +404,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
 			p =3D current->group_leader;
 		} else {
 			p =3D find_task_by_vpid(pid);
-			if (p && !thread_group_leader(p))
+			if (p && !has_group_leader_pid(p))
 				p =3D NULL;
 		}
 	}
@@ -414,7 +414,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
 	} else {
 		ret =3D -EINVAL;
 	}
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
=20
 	return ret;
 }



--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAkzRQFgACgkQfKHnntdSXjTxBgP+PU0Gyg28KDNFzwV/d3mmKgGn
ZgEYm/Rpq06duvQe/Ha3467v242SdMGvbbEBdsOmYQemBy6wVit5CUyZk0ih54n+
168xmjH4l26i4nc1ELHku9XYeU0StCD1lbBM8UNivm1NfJFKyb6C9DIkn8vQOWDa
nN27Mneuu/oZuDFSvHs=
=eeaR
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
