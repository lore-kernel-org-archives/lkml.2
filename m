Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab2FZRuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 13:50:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53070 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab2FZRt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 13:49:58 -0400
Message-ID: <4FE9F63B.1000908@canonical.com>
Date: Tue, 26 Jun 2012 19:49:47 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Vagin <avagin@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH] sched: Fix race in task_group()
References: <1340364965.18025.71.camel@twins>  <4FE48A09.7050305@canonical.com> <1340718515.21991.83.camel@twins>
In-Reply-To: <1340718515.21991.83.camel@twins>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigCF62B48190A42C1CA3C53AE0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCF62B48190A42C1CA3C53AE0
Content-Type: multipart/mixed;
 boundary="------------050301010404010306050602"

This is a multi-part message in MIME format.
--------------050301010404010306050602
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 26.06.2012 15:48, Peter Zijlstra wrote:
> Here's one that's actually compile tested (with the right CONFIG_foo
> enabled) and I fixed the autogroup lockdep splat.
>=20
> ---
> Subject: sched: Fix race in task_group()
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri, 22 Jun 2012 13:36:05 +0200
>=20
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
> Reported-by: Stefan Bader <stefan.bader@canonical.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/init_task.h |   12 +++++++++++-
>  include/linux/sched.h     |    5 ++++-
>  kernel/sched/core.c       |    9 ++++++++-
>  kernel/sched/sched.h      |   23 ++++++++++-------------
>  4 files changed, 33 insertions(+), 16 deletions(-)
>=20
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
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1246,6 +1246,9 @@ struct task_struct {
>  	const struct sched_class *sched_class;
>  	struct sched_entity se;
>  	struct sched_rt_entity rt;
> +#ifdef CONFIG_CGROUP_SCHED
> +	struct task_group *sched_task_group;
> +#endif
> =20
>  #ifdef CONFIG_NUMA
>  	unsigned long	 numa_contrib;
> @@ -2749,7 +2752,7 @@ extern int sched_group_set_rt_period(str
>  extern long sched_group_rt_period(struct task_group *tg);
>  extern int sched_rt_can_attach(struct task_group *tg, struct task_stru=
ct *tsk);
>  #endif
> -#endif
> +#endif /* CONFIG_CGROUP_SCHED */
> =20
>  extern int task_can_switch_user(struct user_struct *up,
>  					struct task_struct *tsk);
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1096,7 +1096,7 @@ void set_task_cpu(struct task_struct *p,
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
> @@ -7712,6 +7712,7 @@ void sched_destroy_group(struct task_gro
>   */
>  void sched_move_task(struct task_struct *tsk)
>  {
> +	struct task_group *tg;
>  	int on_rq, running;
>  	unsigned long flags;
>  	struct rq *rq;
> @@ -7726,6 +7727,12 @@ void sched_move_task(struct task_struct
>  	if (unlikely(running))
>  		tsk->sched_class->put_prev_task(rq, tsk);
> =20
> +	tg =3D container_of(task_subsys_state_check(tsk, cpu_cgroup_subsys_id=
,
> +				lockdep_is_held(&tsk->sighand->siglock)),
> +			  struct task_group, css);
> +	tg =3D autogroup_task_group(tsk, tg);
> +	tsk->sched_task_group =3D tg;
> +
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  	if (tsk->sched_class->task_move_group)
>  		tsk->sched_class->task_move_group(tsk, on_rq);
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -554,22 +554,19 @@ extern int group_balance_cpu(struct sche
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

I ran this version through the testcase and no more warning indeed. Also =
the
crash is not happening anymore (with the backported version).
This should probably get a "Cc: stable@vger.kernel.org # 2.6.38+" into th=
e s-o-b
area. I don't think 2.6.38..2.6.39 have a longterm support but at least t=
hat was
the time when autogroup came in. For 3.0..3.2 the patch needs a bit of tw=
eaking
due to some conference boredom. ;) I am  attaching the backport I was usi=
ng for
the test for convenience. Although ... it has to be refreshed after the o=
riginal
patch has landed upstream...

Cheers,
-Stefan


--------------050301010404010306050602
Content-Type: text/x-diff;
 name="0001-sched-Fix-race-in-task_group.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-sched-Fix-race-in-task_group.patch"

=46rom d751ab1f1e532f32412d99b71a1bfea3e5282d07 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Fri, 22 Jun 2012 13:36:00 +0200
Subject: [PATCH] sched: Fix race in task_group()

Stefan reported a crash on a kernel before a3e5d1091c1 ("sched: Don't
call task_group() too many times in set_task_rq()"), he found the reason
to be that the multiple task_group() invocations in set_task_rq()
returned different values.

Looking at all that I found a lack of serialization and plain wrong
comments.

The below tries to fix it using an extra pointer which is updated under
the appropriate scheduler locks. Its not pretty, but I can't really see
another way given how all the cgroup stuff works.

Reported-and-tested-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
[backported to apply to 3.0 and 3.2]
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 include/linux/init_task.h |   12 +++++++++++-
 include/linux/sched.h     |    5 ++++-
 kernel/sched.c            |   32 ++++++++++++++++++--------------
 3 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 32574ee..13b2684 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -117,8 +117,17 @@ extern struct group_info init_groups;
=20
 extern struct cred init_cred;
=20
+extern struct task_group root_task_group;
+
+#ifdef CONFIG_CGROUP_SCHED
+# define INIT_CGROUP_SCHED(tsk)						\
+	.sched_task_group =3D &root_task_group,
+#else
+# define INIT_CGROUP_SCHED(tsk)
+#endif
+
 #ifdef CONFIG_PERF_EVENTS
-# define INIT_PERF_EVENTS(tsk)					\
+# define INIT_PERF_EVENTS(tsk)						\
 	.perf_event_mutex =3D 						\
 		 __MUTEX_INITIALIZER(tsk.perf_event_mutex),		\
 	.perf_event_list =3D LIST_HEAD_INIT(tsk.perf_event_list),
@@ -155,6 +164,7 @@ extern struct cred init_cred;
 	},								\
 	.tasks		=3D LIST_HEAD_INIT(tsk.tasks),			\
 	INIT_PUSHABLE_TASKS(tsk)					\
+	INIT_CGROUP_SCHED(tsk)						\
 	.ptraced	=3D LIST_HEAD_INIT(tsk.ptraced),			\
 	.ptrace_entry	=3D LIST_HEAD_INIT(tsk.ptrace_entry),		\
 	.real_parent	=3D &tsk,						\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 56de5c1..1fd9884 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1242,6 +1242,9 @@ struct task_struct {
 	const struct sched_class *sched_class;
 	struct sched_entity se;
 	struct sched_rt_entity rt;
+#ifdef CONFIG_CGROUP_SCHED
+	struct task_struct *sched_task_group;
+#endif
=20
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	/* list of struct preempt_notifier: */
@@ -2646,7 +2649,7 @@ extern int sched_group_set_rt_period(struct task_gr=
oup *tg,
 extern long sched_group_rt_period(struct task_group *tg);
 extern int sched_rt_can_attach(struct task_group *tg, struct task_struct=
 *tsk);
 #endif
-#endif
+#endif /* CONFIG_CGROUP_SCHED */
=20
 extern int task_can_switch_user(struct user_struct *up,
 					struct task_struct *tsk);
diff --git a/kernel/sched.c b/kernel/sched.c
index aae0c1d..b99a61e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -746,22 +746,19 @@ static inline int cpu_of(struct rq *rq)
 /*
  * Return the group to which this tasks belongs.
  *
- * We use task_subsys_state_check() and extend the RCU verification with=

- * pi->lock and rq->lock because cpu_cgroup_attach() holds those locks f=
or each
- * task it moves into the cgroup. Therefore by holding either of those l=
ocks,
- * we pin the task to the current cgroup.
+ * We cannot use task_subsys_state() and friends because the cgroup
+ * subsystem changes that value before the cgroup_subsys::attach() metho=
d
+ * is called, therefore we cannot pin it and might observe the wrong val=
ue.
+ *
+ * The same is true for autogroup's p->signal->autogroup->tg, the autogr=
oup
+ * core changes this before calling sched_move_task().
+ *
+ * Instead we use a 'copy' which is updated from sched_move_task() while=

+ * holding both task_struct::pi_lock and rq::lock.
  */
 static inline struct task_group *task_group(struct task_struct *p)
 {
-	struct task_group *tg;
-	struct cgroup_subsys_state *css;
-
-	css =3D task_subsys_state_check(p, cpu_cgroup_subsys_id,
-			lockdep_is_held(&p->pi_lock) ||
-			lockdep_is_held(&task_rq(p)->lock));
-	tg =3D container_of(css, struct task_group, css);
-
-	return autogroup_task_group(p, tg);
+	return p->sched_task_group;
 }
=20
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/grou=
ps */
@@ -2373,7 +2370,7 @@ void set_task_cpu(struct task_struct *p, unsigned i=
nt new_cpu)
 	 * a task's CPU. ->pi_lock for waking tasks, rq->lock for runnable task=
s.
 	 *
 	 * sched_move_task() holds both and thus holding either pins the cgroup=
,
-	 * see set_task_rq().
+	 * see task_group().
 	 *
 	 * Furthermore, all task_rq users should acquire both locks, see
 	 * task_rq_lock().
@@ -8765,6 +8762,7 @@ void sched_destroy_group(struct task_group *tg)
  */
 void sched_move_task(struct task_struct *tsk)
 {
+	struct task_group *tg;
 	int on_rq, running;
 	unsigned long flags;
 	struct rq *rq;
@@ -8779,6 +8777,12 @@ void sched_move_task(struct task_struct *tsk)
 	if (unlikely(running))
 		tsk->sched_class->put_prev_task(rq, tsk);
=20
+	tg =3D container_of(task_subsys_state_check(tsk, cpu_cgroup_subsys_id,
+				lockdep_is_held(&tsk->sighand->siglock)),
+			  struct task_group, css);
+	tg =3D autogroup_task_group(tsk, tg);
+	tsk->sched_task_group =3D tg;
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	if (tsk->sched_class->task_move_group)
 		tsk->sched_class->task_move_group(tsk, on_rq);
--=20
1.7.9.5


--------------050301010404010306050602--

--------------enigCF62B48190A42C1CA3C53AE0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJP6fY7AAoJEOhnXe7L7s6jM84QALIiNCKGga3oUlc5dYb8O0wC
SioN0EXXTI9seI5rM9dwyTr9GgFU88I/RvAqeUqMLpPJlFqEx2sBmGWRmDD39swI
pl+ReGPIxtzWNBU+J/qWGumaUpvIAfM9zmIDBI8elUoF25MIaECqs0yrlbKaYLcF
v6g2fwQqD8MYrtEkPJvhhg+3GO06RfENkKO+mbKgCOy3JNDlrQNi4zyqNDEMrihg
Rt4EjaeTKNVjanNu6CTJYjQsXW9KtS2+a8Yi+VApx1Ms1XOgWOba7ebBIR8dku3r
RzHusOzt8vhyIW+BpgmlR2gSzjQlktDSZYEBMOqNO8GPaofLsgUHHZV4UiCMR6yK
IGC0j++Fz10v2uiBs/Jezuy6DBLXkR+PwuRoh5jonCbdHlTk9acMTpnTVlaaJwps
jGHVbvAzKD2ceC+uU5m5lSTWSHFMLrYJpLjK67X3qU8wJTQVXb2OMsQgfmtz98cF
51tOMmK4EcRVJrAmZKhN9f1apYXNUF1F+sVsKveQorN9Thm0JaKuJZDVvWL0UdCN
WwmW818+2nSvknXZ4CAO/lOKOMe4t0NQwYi8rthwAoN7cHSRM1xSgSG0xirOKf61
ToXTbjOXjCD1/vPFB+U0y6sUerqd4QYR1mbLzeJhflCwJKawHuKRM8G3qBtN1g9j
IYGB1AzKP8y9It1bFN+Y
=ck1R
-----END PGP SIGNATURE-----

--------------enigCF62B48190A42C1CA3C53AE0--
