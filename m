Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab0KDSQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 14:16:26 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45759 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab0KDSQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 14:16:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o3lvX4Jh6eO2p6/Ih220dwl2SRd/txlSOqKWus7wRTjGL4TyFRNb4ahYFRUf9argQ0
         0Z2rtTfXQSOH2c7MizlyzC9XqKskSlytGQ9wVVnlTYmkfpNL2NgOgRSl7vZy2EaNr/0x
         eDIZoHh6IBCAszVL7yjqKtc1+NMNWb3WGTlYU=
Date: Thu, 4 Nov 2010 20:16:06 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: task blocked for more than 120 seconds
Message-ID: <20101104181606.GA3942@swordfish.minsk.epam.com>
References: <20101104155826.GC13818@swordfish.minsk.epam.com>
 <20101104161943.GA6520@arch.trippelsdorf.de>
 <1288891946.2039.31.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <1288891946.2039.31.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (11/04/10 18:32), Peter Zijlstra wrote:
> On Thu, 2010-11-04 at 17:19 +0100, Markus Trippelsdorf wrote:
> > On Thu, Nov 04, 2010 at 05:58:26PM +0200, Sergey Senozhatsky wrote:
> > > Hello,
> > > Got the following traces:
> > >=20
> > > [42001.449295] INFO: task openbox:17761 blocked for more than 120 sec=
onds.
> > > [42001.449303] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" dis=
ables this message.
> > > [42001.449311] openbox       D 0000000000000003     0 17761   3723 0x=
00000000
> > > [42001.449321]  ffff88004ce8dc38 0000000000000046 0000000000000000 ff=
ff88004ce8c000
> > > [42001.449333]  ffff88004ce8dfd8 0000000000012040 ffff880133010000 ff=
ff88004ce8dfd8
> > > [42001.449343]  0000000000012040 0000000000012040 ffff88004ce8dfd8 00=
00000000012040
> > > [42001.449354] Call Trace:
> > > [42001.449369]  [<ffffffff814212ff>] schedule_timeout+0x38/0x220
> > > [42001.449381]  [<ffffffff81066f21>] ? mark_held_locks+0x50/0x72
> > > [42001.449389]  [<ffffffff81423dae>] ? _raw_spin_unlock_irq+0x2b/0x59
> > > [42001.449398]  [<ffffffff81036070>] ? get_parent_ip+0x11/0x41
> > > [42001.449406]  [<ffffffff81036132>] ? sub_preempt_count+0x92/0xa5
> > > [42001.449413]  [<ffffffff8142057e>] wait_for_common+0xca/0x144
> > > [42001.449421]  [<ffffffff81038b13>] ? default_wake_function+0x0/0xf
> > > [42001.449429]  [<ffffffff81423e4b>] ? _raw_spin_unlock_irqrestore+0x=
6f/0x74
> > > [42001.449436]  [<ffffffff81420692>] wait_for_completion+0x18/0x1a
> > > [42001.449445]  [<ffffffff81084808>] stop_one_cpu+0x8c/0xba
> >=20
> > These traces look related to:
> > http://article.gmane.org/gmane.linux.kernel/1055100
> >=20
> > Does reverting 34f971f6f7988be4d014eec3e3526bee6d007ffa help in your
> > case?
>=20
>

Hello,
I'll test "sched: Fixup cross sched_class wakeup preemption" first
and then (if it fails) I'll test 34f971f6f7988be4d014eec3e3526bee6d007ffa=
=20
revert.


	Sergey
=20
> ---
> Subject: sched: Fixup cross sched_class wakeup preemption
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Sun Oct 31 12:37:04 CET 2010
>=20
> Instead of dealing with sched classes inside each check_preempt_curr()
> implementation, pull out this logic into the generic wakeup preemption
> path.
>=20
> This fixes a hang in KVM (and others) where we are waiting for the
> stop machine thread to run..
>=20
> Tested-by: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> ---
>  kernel/sched.c          |   39 ++++++++++++++++++++++++++++-----------
>  kernel/sched_fair.c     |    6 ------
>  kernel/sched_stoptask.c |    2 +-
>  3 files changed, 29 insertions(+), 18 deletions(-)
>=20
> Index: linux-2.6/kernel/sched.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -560,18 +560,9 @@ struct rq {
> =20
>  static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
> =20
> -static inline
> -void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
> -{
> -	rq->curr->sched_class->check_preempt_curr(rq, p, flags);
> =20
> -	/*
> -	 * A queue event has occurred, and we're going to schedule.  In
> -	 * this case, we can save a useless back to back clock update.
> -	 */
> -	if (test_tsk_need_resched(p))
> -		rq->skip_clock_update =3D 1;
> -}
> +static inline
> +void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags);
> =20
>  static inline int cpu_of(struct rq *rq)
>  {
> @@ -9400,4 +9391,30 @@ void synchronize_sched_expedited(void)
>  }
>  EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
> =20
> +static inline
> +void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
> +{
> +	const struct sched_class *class;
> +
> +	if (p->sched_class =3D=3D rq->curr->sched_class)
> +		rq->curr->sched_class->check_preempt_curr(rq, p, flags);
> +
> +	for_each_class(class) {
> +		if (class =3D=3D rq->curr->sched_class)
> +			break;
> +		if (class =3D=3D p->sched_class) {
> +			resched_task(rq->curr);
> +			break;
> +		}
> +	}
> +
> +	/*
> +	 * A queue event has occurred, and we're going to schedule.  In
> +	 * this case, we can save a useless back to back clock update.
> +	 */
> +	if (test_tsk_need_resched(rq->curr))
> +		rq->skip_clock_update =3D 1;
> +}
> +
> +
>  #endif /* #else #ifndef CONFIG_SMP */
> Index: linux-2.6/kernel/sched_fair.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/kernel/sched_fair.c
> +++ linux-2.6/kernel/sched_fair.c
> @@ -1654,12 +1654,6 @@ static void check_preempt_wakeup(struct
>  	struct cfs_rq *cfs_rq =3D task_cfs_rq(curr);
>  	int scale =3D cfs_rq->nr_running >=3D sched_nr_latency;
> =20
> -	if (unlikely(rt_prio(p->prio)))
> -		goto preempt;
> -
> -	if (unlikely(p->sched_class !=3D &fair_sched_class))
> -		return;
> -
>  	if (unlikely(se =3D=3D pse))
>  		return;
> =20
> Index: linux-2.6/kernel/sched_stoptask.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/kernel/sched_stoptask.c
> +++ linux-2.6/kernel/sched_stoptask.c
> @@ -19,7 +19,7 @@ select_task_rq_stop(struct rq *rq, struc
>  static void
>  check_preempt_curr_stop(struct rq *rq, struct task_struct *p, int flags)
>  {
> -	resched_task(rq->curr); /* we preempt everything */
> +	/* we're never preempted */
>  }
> =20
>  static struct task_struct *pick_next_task_stop(struct rq *rq)
>=20

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAkzS+GYACgkQfKHnntdSXjTWZAP+LnV5v4bAzUC+8Qn/5UFnuL8u
aMqgUPY6W5FZuycO5j7TmUI4eF9WSl/xiDLSc3hhwxdcTysOIlp5kZ+EuPkyx5/r
RgS/GnwZ97AqGFOiYU1as4wSz6NdQVWk2UM1zu7b+OzV+0GQfSx2k74ci3WWny7q
jMWfWQjWXVtPYYo/WEU=
=ASPT
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
