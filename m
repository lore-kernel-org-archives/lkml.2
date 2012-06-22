Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307Ab2FVPHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:07:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38820 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762263Ab2FVPHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:07:00 -0400
Message-ID: <4FE48A09.7050305@canonical.com>
Date: Fri, 22 Jun 2012 17:06:49 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Vagin <avagin@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH] sched: Fix race in task_group()
References: <1340364965.18025.71.camel@twins>
In-Reply-To: <1340364965.18025.71.camel@twins>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig05192119856E791F8CD2FFC7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig05192119856E791F8CD2FFC7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 22.06.2012 13:36, Peter Zijlstra wrote:
> Stefan reported a crash on a kernel before a3e5d1091c1 ("sched: Don't
> call task_group() too many times in set_task_rq()"), he found the reaso=
n
> to be that the multiple task_group() invocations in set_task_rq()
> returned different values.
>=20
> Looking at all that I found a lack of serialization and plain wrong
> comments.
>=20
> The below tries to fix it using an extra pointer which is updated under=

> the appropriate scheduler locks. Its not pretty, but I can't really see=

> another way given how all the cgroup stuff works.
>=20
> Anybody else got a better idea?
>=20
>=20
> Reported-by: Stefan Bader <stefan.bader@canonical.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/init_task.h |   12 +++++++++++-
>  include/linux/sched.h     |    5 ++++-
>  kernel/sched/core.c       |    9 ++++++++-
>  kernel/sched/sched.h      |   23 ++++++++++-------------
>  4 files changed, 33 insertions(+), 16 deletions(-)
>=20
> diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> index 4e4bc1a..53be033 100644
> --- a/include/linux/init_task.h
> +++ b/include/linux/init_task.h
> @@ -123,8 +123,17 @@ extern struct group_info init_groups;
> =20
>  extern struct cred init_cred;
> =20
> +extern struct task_group root_task_group;
> +
> +#ifdef CONFIG_CGROUP_SCHED
> +# define INIT_CGROUP_SCHED(tsk)						\
> +	.sched_task_group =3D &root_task_group,
> +#else
> +# define INIT_CGROUP_SCHED(tsk)
> +#endif
> +
>  #ifdef CONFIG_PERF_EVENTS
> -# define INIT_PERF_EVENTS(tsk)					\
> +# define INIT_PERF_EVENTS(tsk)						\
>  	.perf_event_mutex =3D 						\
>  		 __MUTEX_INITIALIZER(tsk.perf_event_mutex),		\
>  	.perf_event_list =3D LIST_HEAD_INIT(tsk.perf_event_list),
> @@ -168,6 +177,7 @@ extern struct cred init_cred;
>  	},								\
>  	.tasks		=3D LIST_HEAD_INIT(tsk.tasks),			\
>  	INIT_PUSHABLE_TASKS(tsk)					\
> +	INIT_CGROUP_SCHED(tsk)						\
>  	.ptraced	=3D LIST_HEAD_INIT(tsk.ptraced),			\
>  	.ptrace_entry	=3D LIST_HEAD_INIT(tsk.ptrace_entry),		\
>  	.real_parent	=3D &tsk,						\
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 32157b9..77437d4 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1246,6 +1246,9 @@ struct task_struct {
>  	const struct sched_class *sched_class;
>  	struct sched_entity se;
>  	struct sched_rt_entity rt;
> +#ifdef CONFIG_CGROUP_SCHED
> +	struct task_struct *sched_task_group;
> +#endif
> =20
>  #ifdef CONFIG_NUMA
>  	unsigned long	 numa_contrib;
> @@ -2741,7 +2744,7 @@ extern int sched_group_set_rt_period(struct task_=
group *tg,
>  extern long sched_group_rt_period(struct task_group *tg);
>  extern int sched_rt_can_attach(struct task_group *tg, struct task_stru=
ct *tsk);
>  #endif
> -#endif
> +#endif /* CONFIG_CGROUP_SCHED */
> =20
>  extern int task_can_switch_user(struct user_struct *up,
>  					struct task_struct *tsk);
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 9bb7d28..9adb9a0 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1096,7 +1096,7 @@ void set_task_cpu(struct task_struct *p, unsigned=
 int new_cpu)
>  	 * a task's CPU. ->pi_lock for waking tasks, rq->lock for runnable ta=
sks.
>  	 *
>  	 * sched_move_task() holds both and thus holding either pins the cgro=
up,
> -	 * see set_task_rq().
> +	 * see task_group().
>  	 *
>  	 * Furthermore, all task_rq users should acquire both locks, see
>  	 * task_rq_lock().
> @@ -7581,6 +7581,8 @@ void sched_destroy_group(struct task_group *tg)
>   */
>  void sched_move_task(struct task_struct *tsk)
>  {
> +	struct cgroup_subsys_state *css;
> +	struct task_group *tg;
>  	int on_rq, running;
>  	unsigned long flags;
>  	struct rq *rq;
> @@ -7595,6 +7597,11 @@ void sched_move_task(struct task_struct *tsk)
>  	if (unlikely(running))
>  		tsk->sched_class->put_prev_task(rq, tsk);
> =20
> +	tg =3D container_of(task_subsys_state(p, cpu_cgroup_subsys_id),
s/p/tsk/
> +			  struct task_group, css);
> +	tg =3D autogroup_task_group(p, tg);
s/p/tsk/
> +	tsk->sched_task_group =3D tg;
> +
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  	if (tsk->sched_class->task_move_group)
>  		tsk->sched_class->task_move_group(tsk, on_rq);
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 4134d37..c26378c 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -554,22 +554,19 @@ extern int group_balance_cpu(struct sched_group *=
sg);
>  /*
>   * Return the group to which this tasks belongs.
>   *
> - * We use task_subsys_state_check() and extend the RCU verification wi=
th
> - * pi->lock and rq->lock because cpu_cgroup_attach() holds those locks=
 for each
> - * task it moves into the cgroup. Therefore by holding either of those=
 locks,
> - * we pin the task to the current cgroup.
> + * We cannot use task_subsys_state() and friends because the cgroup
> + * subsystem changes that value before the cgroup_subsys::attach() met=
hod
> + * is called, therefore we cannot pin it and might observe the wrong v=
alue.
> + *
> + * The same is true for autogroup's p->signal->autogroup->tg, the auto=
group
> + * core changes this before calling sched_move_task().
> + *
> + * Instead we use a 'copy' which is updated from sched_move_task() whi=
le
> + * holding both task_struct::pi_lock and rq::lock.
>   */
>  static inline struct task_group *task_group(struct task_struct *p)
>  {
> -	struct task_group *tg;
> -	struct cgroup_subsys_state *css;
> -
> -	css =3D task_subsys_state_check(p, cpu_cgroup_subsys_id,
> -			lockdep_is_held(&p->pi_lock) ||
> -			lockdep_is_held(&task_rq(p)->lock));
> -	tg =3D container_of(css, struct task_group, css);
> -
> -	return autogroup_task_group(p, tg);
> +	return p->sched_task_group;
>  }
> =20
>  /* Change a task's cfs_rq and parent entity if it moves across CPUs/gr=
oups */
>=20

Tried out a backported (to 3.2) version of above patch which mainly diffe=
rs in
having to move sched/sched.h changes back into sched.c and got this warni=
ng on boot:

[    2.648099] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    2.648205] [ INFO: suspicious RCU usage. ]
[    2.648338] -------------------------------
[    2.648465] /home/smb/precise-amd64/ubuntu-2.6/include/linux/cgroup.h:=
548
suspicious rcu_dereference_check() usage!
[    2.648775]
[    2.648777] other info that might help us debug this:
[    2.648780]
[    2.649010]
[    2.649012] rcu_scheduler_active =3D 1, debug_locks =3D 0
[    2.649205] 3 locks held by udevd/91:
[    2.649296]  #0:  (&(&sighand->siglock)->rlock){......}, at:
[<ffffffff8107ff24>] __lock_task_sighand+0x94/0x1b0
[    2.649824]  #1:  (&p->pi_lock){-.-.-.}, at: [<ffffffff8104ee90>]
task_rq_lock+0x40/0xb0
[    2.650071]  #2:  (&rq->lock){-.-.-.}, at: [<ffffffff8104eeab>]
task_rq_lock+0x5b/0xb0
[    2.650297]
[    2.650299] stack backtrace:
[    2.650439] Pid: 91, comm: udevd Not tainted 3.2.0-26-generic #41+lp99=
9755v7
[    2.650562] Call Trace:
[    2.650562]  [<ffffffff810a5507>] lockdep_rcu_suspicious+0xd7/0xe0
[    2.650562]  [<ffffffff81065ea5>] sched_move_task+0x165/0x230
[    2.650562]  [<ffffffff8107feb3>] ? __lock_task_sighand+0x23/0x1b0
[    2.650562]  [<ffffffff8106607f>] autogroup_move_group+0xbf/0x160
[    2.650562]  [<ffffffff8106620e>] sched_autogroup_create_attach+0xce/0=
x150
[    2.650562]  [<ffffffff81084ca4>] sys_setsid+0xd4/0xf0
[    2.650562]  [<ffffffff816affc2>] system_call_fastpath+0x16/0x1b

Will see how well it survives the test but thought to let you know.

-Stefan


--------------enig05192119856E791F8CD2FFC7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJP5IoJAAoJEOhnXe7L7s6jz9gQALR75YyMQxZxxyJbim5isYR0
DBi9DT1xH8WvNmv8ilVqtHIAfIT9eOvcpJ9fg51Sb+354LQVbV/ivq4iERwaxXW0
eld/+EPJ4vcl7mr85T8nqDe2Olj5obi/3cq3eHcrpdMkHQF92t51MRTRDzt+xWVg
2EhCBR4AYXYG/KlSlXd3O+7RUV3EFrEZ9bIs3bd4AHvjiQcJ1ncmfyRyOE9SBBBB
e3VCnUy/oVH8j2I2iZ8XNWq41mtHcGVSRKGhOab4KvgbuxjHtPVqBLFGR7e4sUbR
CTlnJqMb7eGMDOZ9GQU81+BbLmk8E3hQGlg5ZNf1BnyqDSR9Rdovj/CIB3H1RWj8
4RPOoQXJ8DnVOvMgvQGU4EeSFwLoqUvdDBCgUm0h5LTCzZwSezpgW1UL2EmB1CYx
m+4Wrq4EjVYjEpK2mnrT6/cIav4r8Jr1bq24ZvzE1WDfApVYJJP/H6AdgQN+wqrF
iieSXBMXUO0lWs/ayHYYzSmHnjEm3k6g2z2nLDWr2FfbOWwW2SvaJIC3a99t1I+W
uB+5uSx9HMwogFSZQCTwaWjwt7OimVnSUOs3qPJpN9XSDHYpBUsyjFQbf4yq/jGy
5y5yDuMzoOY1cilUEVPqnOE03nnOLAgNf4NZklRDQb9vtDbEcOWXaqfVOL8KUpA3
36XZ6TZDl8h0mHeKF0JM
=QqBa
-----END PGP SIGNATURE-----

--------------enig05192119856E791F8CD2FFC7--
