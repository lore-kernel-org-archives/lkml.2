Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab0J3Jcl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 05:32:41 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63382 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab0J3Jcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 05:32:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eVEsrDb6+Fl1epcPu43tWUELk4zHPBWyJsWZJ3cQq08cmHe0hYyvkBx0UHrTitx7iN
         oPe0zwcCVxkW2szRUbPnORoD0WsU4d0DrZH3fD7/UgnMXCjy1AnQe8y0GQYSkJ5khDTk
         RaDPkINGEISfcrzszitMdlT1R1q2+8aw6tsR8=
Date: Sat, 30 Oct 2010 12:32:34 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] rcu_read_lock/unlock protect find_task_by_vpid call
Message-ID: <20101030093234.GK3932@swordfish.minsk.epam.com>
References: <20101029125550.GA3932@swordfish.minsk.epam.com>
 <20101029201648.GK2367@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lZZ4ablUVnt2XgAh"
Content-Disposition: inline
In-Reply-To: <20101029201648.GK2367@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lZZ4ablUVnt2XgAh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (10/29/10 13:16), Paul E. McKenney wrote:
> On Fri, Oct 29, 2010 at 03:55:50PM +0300, Sergey Senozhatsky wrote:
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
> >=20
> >  rcu_scheduler_active =3D 1, debug_locks =3D 0
> >  1 lock held by iotop/4254:
> >  #0:  (tasklist_lock){.?.?..}, at: [<ffffffff811104b4>] sys_ioprio_get+=
0x22/0x2da
> >=20
> >  stack backtrace:
> >  Pid: 4254, comm: iotop Not tainted
> >  Call Trace:
> >  [<ffffffff810656f2>] lockdep_rcu_dereference+0xaa/0xb2
> >  [<ffffffff81053c67>] find_task_by_pid_ns+0x4f/0x68
> >  [<ffffffff81053c9d>] find_task_by_vpid+0x1d/0x1f
> >  [<ffffffff811104e2>] sys_ioprio_get+0x50/0x2da
> >  [<ffffffff81002182>] system_call_fastpath+0x16/0x1b
> >=20
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
>=20
> Interesting...
>=20
> The task-list lock is read-held at this point, which should mean that
> the PID mapping cannot change.  The lockdep_tasklist_lock_is_held()
> function does lockdep_is_held(&tasklist_lock), which must therefore
> only be checking for write-holding the lock.  The fix would be to
> make lockdep_tasklist_lock_is_held() check for either read-holding or
> write-holding tasklist lock.
>=20
> Or is there some subtle reason that read-holding the tasklist lock is
> not sufficient?
>

Hello,

On the kernel/pid.c side we have the requirement that=20
find_task_by_vpid -> find_task_by_pid_ns

should be called with rcu_read_lock.

/*
 * Must be called under rcu_read_lock().
 */
struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
{
	rcu_lockdep_assert(rcu_read_lock_held());
	return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
}

=20
Should it be changed to (let's say)

struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
{
-	rcu_lockdep_assert(rcu_read_lock_held());
+	rcu_lockdep_assert(rcu_read_lock_held() || lockdep_tasklist_lock_is_held(=
));
	return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
}


	Sergey

> 							Thanx, Paul
>=20
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
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
>=20

--lZZ4ablUVnt2XgAh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAkzL5jIACgkQfKHnntdSXjSLJwP5AWBc1bM1oN05jLk2jVbxTrki
oMT/UxAK9hkAv1L/g1mMiSU2RAYpq1HLy7xTY/PSYD+VPEdZUk0OUd0MPCl6OpQS
velwehJj+ba6BwCFOnq4mpGy+aMW2hfBxfh0tHizvhILbGmyXEPgaapSPl5PvrWx
0zMwImT6PHU+L8VgjZQ=
=RJrw
-----END PGP SIGNATURE-----

--lZZ4ablUVnt2XgAh--
