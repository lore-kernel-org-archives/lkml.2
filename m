Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab1LNGSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 01:18:34 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:59160 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1LNGSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 01:18:32 -0500
Date: Wed, 14 Dec 2011 17:18:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the akpm with the cgroup tree
Message-Id: <20111214171822.681a4f67653657e655af149b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Dec_2011_17_18_22_+1100_v4m+34HriZsoHJ_C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Dec_2011_17_18_22_+1100_v4m+34HriZsoHJ_C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got conflicts in
kernel/sched/core.c and kernel/cpuset.c between commit bb9d97b6dffa
("cgroup: don't use subsys->can_attach_task() or ->attach_task()") from
the cgroup tree and commit "cpusets, cgroups: disallow attaching
kthreadd" from the akpm tree.

I fixed it up (maybe - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/cpuset.c
index e8ed75a,793eca6..0000000
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@@ -1388,34 -1418,11 +1389,36 @@@ static cpumask_var_t cpus_attach
  static nodemask_t cpuset_attach_nodemask_from;
  static nodemask_t cpuset_attach_nodemask_to;
 =20
 -/* Set-up work for before attaching each task. */
 -static void cpuset_pre_attach(struct cgroup *cont)
 +/* Called by cgroups to determine if a cpuset is usable; cgroup_mutex hel=
d */
 +static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cgr=
p,
 +			     struct cgroup_taskset *tset)
  {
 -	struct cpuset *cs =3D cgroup_cs(cont);
 +	struct cpuset *cs =3D cgroup_cs(cgrp);
 +	struct task_struct *task;
 +	int ret;
 +
 +	if (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
 +		return -ENOSPC;
 +
 +	cgroup_taskset_for_each(task, cgrp, tset) {
 +		/*
 +		 * Kthreads bound to specific cpus cannot be moved to a new
 +		 * cpuset; we cannot change their cpu affinity and
 +		 * isolating such threads by their set of allowed nodes is
 +		 * unnecessary.  Thus, cpusets are not applicable for such
 +		 * threads.  This prevents checking for success of
 +		 * set_cpus_allowed_ptr() on all attached tasks before
- 		 * cpus_allowed may be changed.
++		 * cpus_allowed may be changed.  We also disallow attaching
++		 * kthreadd, to prevent its child from becoming trapped should
++		 * it then acquire PF_THREAD_BOUND.
 +		 */
- 		if (task->flags & PF_THREAD_BOUND)
++		if (task->flags & PF_THREAD_BOUND || task =3D=3D kthreadd_task)
 +			return -EINVAL;
 +		if ((ret =3D security_task_setscheduler(task)))
 +			return ret;
 +	}
 =20
 +	/* prepare for attach */
  	if (cs =3D=3D &top_cpuset)
  		cpumask_copy(cpus_attach, cpu_possible_mask);
  	else
diff --cc kernel/sched/core.c
index 9775b8d,e1aa1f9..0000000
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@@ -7529,21 -7530,26 +7530,30 @@@ cpu_cgroup_destroy(struct cgroup_subsy
  	sched_destroy_group(tg);
  }
 =20
 -static int
 -cpu_cgroup_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 +static int cpu_cgroup_can_attach(struct cgroup_subsys *ss, struct cgroup =
*cgrp,
 +				 struct cgroup_taskset *tset)
  {
 -	/*
 -	 * kthreadd can fork workers for an RT workqueue in a cgroup
 -	 * which may or may not have rt_runtime allocated.  Just say no,
 -	 * as attaching a global resource to a non-root group  doesn't
 -	 * make any sense anyway.
 -	 */
 -	if (tsk =3D=3D kthreadd_task)
 -		return -EINVAL;
 +	struct task_struct *task;
 +
 +	cgroup_taskset_for_each(task, cgrp, tset) {
++		/*
++		 * kthreadd can fork workers for an RT workqueue in a cgroup
++		 * which may or may not have rt_runtime allocated.  Just say no,
++		 * as attaching a global resource to a non-root group  doesn't
++		 * make any sense anyway.
++		 */
++		if (task =3D=3D kthreadd_task)
++			return -EINVAL;
+=20
  #ifdef CONFIG_RT_GROUP_SCHED
 -	if (!sched_rt_can_attach(cgroup_tg(cgrp), tsk))
 -		return -EINVAL;
 +		if (!sched_rt_can_attach(cgroup_tg(cgrp), task))
 +			return -EINVAL;
  #else
 -	/* We don't support RT-tasks being in separate groups */
 -	if (tsk->sched_class !=3D &fair_sched_class)
 -		return -EINVAL;
 +		/* We don't support RT-tasks being in separate groups */
 +		if (task->sched_class !=3D &fair_sched_class)
 +			return -EINVAL;
  #endif
 +	}
  	return 0;
  }
 =20

--Signature=_Wed__14_Dec_2011_17_18_22_+1100_v4m+34HriZsoHJ_C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO6D+uAAoJEECxmPOUX5FE2N8QAI0tEpZs3t4mKv/WrevYPiq4
OTqKAS4soEpJXJS8eB4uiI0R19qxy032Rsvq/YKbwNWXjoxoO83+BRC7lHBm5RzX
ATeI3iYDH8RvgY77vovKugvW4ZsF+Uhdiy0vdPoA/5bj4XpU+Ty1hz8S5HbWSdG8
gnDP7+r0VqOZBChiKJ+DJH/FpmCaPtc4LS8LMBr7xquP+Qo7F1DcRA0lrLC7vutQ
JtPcAOIE6yNfIDdYXX0U1OsBrovLIdj6wqQcZmXvhT+19dHyPHlvjuGZqifHrbpp
0Y1CyfWYyzIcxJ0AhZJNWu2GrsYHm4SIH2p8J2gzQxLQFNmcFg4c3OpyspE8n+uH
31EMB8C6btKNFPqUS3JwCyzS9RcWY91R4wU0Qgvh9eeElcqHe6a8uh1K/faRNEYk
/KYh92HrzgU2JlB+nBio18Swqj5geG8A+rnC0cXeEPHvjp8QSsxNQ69LDRAjbqiJ
VfF632+SEa/BHoEUSeRMf/uBAzhkZZErzZm8AdXlVCPjmWqS17+NSJsl9b/9dhek
vpydm+D5VYQz5Kg5xjxsmdFwNnTHaMlQS9aKUIdRDdKuCI8/WnUOsQBPE/RN4IDC
C60mkpYMU5tDuJ1/n4nv715pMTtyALGJ0J301pa5FE8wspEu0RdjaeRvXeQs6or2
XFiaFDDlMVFjSsfVcsaa
=JVO2
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Dec_2011_17_18_22_+1100_v4m+34HriZsoHJ_C--
