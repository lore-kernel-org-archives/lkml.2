Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0KHQSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 11:18:15 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48359 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab0KHQSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 11:18:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VKCr20Sb5EjpOZb33MmuPMtfwL/+1i2k/TK3VeqicubXa0a8VoE2FMmroVz4lYLszg
         ABtvGTZMOabHXNNfgfejcCXzvvMKXHJgdlqH3qt/LlH7/0tHt/ujc0swKwYflRJiARkN
         YR4ZNrkwHesjdjXY8NcsjTd0Goh3SEPF6zRrQ=
Date: Mon, 8 Nov 2010 18:18:01 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Davidlohr Bueso <dave@gnu.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] rcu_read_lock/unlock protect find_task_by_vpid call
Message-ID: <20101108161801.GD3971@swordfish.minsk.epam.com>
References: <20101029125550.GA3932@swordfish.minsk.epam.com>
 <1289232095.2206.5.camel@cowboy>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JwB53PgKC5A7+0Ej"
Content-Disposition: inline
In-Reply-To: <1289232095.2206.5.camel@cowboy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JwB53PgKC5A7+0Ej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (11/08/10 13:01), Davidlohr Bueso wrote:
> On Fri, 2010-10-29 at 15:55 +0300, Sergey Senozhatsky wrote:
> > Commit 4221a9918e38b7494cee341dda7b7b4bb8c04bde "Add RCU check for=20
> > find_task_by_vpid()" introduced rcu_lockdep_assert to find_task_by_pid_=
ns.
> > Assertion failed in sys_ioprio_get. The patch is fixing assertion
> > failure in ioprio_set as well.=20
> >=20
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> >  [ INFO: suspicious rcu_dereference_check() usage. ]
> >  ---------------------------------------------------
> >  kernel/pid.c:419 invoked rcu_dereference_check() without protection!
> > =20
> >  rcu_scheduler_active =3D 1, debug_locks =3D 0
> >  1 lock held by iotop/4254:
> >  #0:  (tasklist_lock){.?.?..}, at: [<ffffffff811104b4>] sys_ioprio_get+=
0x22/0x2da
> > =20
> >  stack backtrace:
> >  Pid: 4254, comm: iotop Not tainted
> >  Call Trace:
> >  [<ffffffff810656f2>] lockdep_rcu_dereference+0xaa/0xb2
> >  [<ffffffff81053c67>] find_task_by_pid_ns+0x4f/0x68
> >  [<ffffffff81053c9d>] find_task_by_vpid+0x1d/0x1f
> >  [<ffffffff811104e2>] sys_ioprio_get+0x50/0x2da
> >  [<ffffffff81002182>] system_call_fastpath+0x16/0x1b
> > =20
> >=20
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> >=20
> > ---
> >=20
> > diff --git a/fs/ioprio.c b/fs/ioprio.c
> > index 748cfb9..666343d 100644
> > --- a/fs/ioprio.c
> > +++ b/fs/ioprio.c
> > @@ -113,8 +113,11 @@ SYSCALL_DEFINE3(ioprio_set, int, which, int, who, =
int, ioprio)
> >  		case IOPRIO_WHO_PROCESS:
> >  			if (!who)
> >  				p =3D current;
> > -			else
> > +			else {
> > +				rcu_read_lock();
> >  				p =3D find_task_by_vpid(who);
> > +				rcu_read_unlock();
> > +			}
> >  			if (p)
> >  				ret =3D set_task_ioprio(p, ioprio);
> >  			break;
> > @@ -202,8 +205,11 @@ SYSCALL_DEFINE2(ioprio_get, int, which, int, who)
> >  		case IOPRIO_WHO_PROCESS:
> >  			if (!who)
> >  				p =3D current;
> > -			else
> > +			else {
> > +				rcu_read_lock();
> >  				p =3D find_task_by_vpid(who);
> > +				rcu_read_unlock();
> > +			}
> >  			if (p)
> >  				ret =3D get_task_ioprio(p);
> >  			break;
>=20
> If you add the rcu_read_lock/unlock() sections, we would also need to
> update the comment above accordingly.
>

Hello,
I think, this comment is relevant to IOPRIO_WHO_PGRP/IOPRIO_WHO_USER cases.
I only touched IOPRIO_WHO_PROCESS and IOPRIO_WHO_PROCESS.
So, imho, no need to remove it.


	Sergey
=20
>=20
> From: Davidlohr Bueso <dave@gnu.org>
> Subject: [PATCH] ioprio: remove comment to not use RCU
>=20
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  fs/ioprio.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/ioprio.c b/fs/ioprio.c
> index 748cfb9..72d71de 100644
> --- a/fs/ioprio.c
> +++ b/fs/ioprio.c
> @@ -103,11 +103,6 @@ SYSCALL_DEFINE3(ioprio_set, int, which, int, who,
> int, ioprio)
>  	}
> =20
>  	ret =3D -ESRCH;
> -	/*
> -	 * We want IOPRIO_WHO_PGRP/IOPRIO_WHO_USER to be "atomic",
> -	 * so we can't use rcu_read_lock(). See re-copy of ->ioprio
> -	 * in copy_process().
> -	 */
>  	read_lock(&tasklist_lock);
>  	switch (which) {
>  		case IOPRIO_WHO_PROCESS:

--JwB53PgKC5A7+0Ej
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAkzYIrkACgkQfKHnntdSXjSJKgQAxYob4cvsNQchAg6DhAa+MCaN
pBfMopbu3jKhYDUT6KDZRYZbbON9kI7Y4GVKfZY2o+pF/sUvzxn0Ksj0q9X26JfI
ypoppZQnsXq5P1AaQ4aVnEcurVcY3mL/wyYGhh4JxHmnE24hFRkKknLWTV0s8Pys
712317wU0fE1F9WFwSw=
=pyQt
-----END PGP SIGNATURE-----

--JwB53PgKC5A7+0Ej--
