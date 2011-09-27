Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1I0WW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 18:22:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56787 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab1I0WWZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 18:22:25 -0400
Subject: Re: [RFD 3/9] Display /proc/stat information per cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: Balbir Singh <bsingharora@gmail.com>, linux-kernel@vger.kernel.org,
        paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        jbottomley@parallels.com
Date: Wed, 28 Sep 2011 00:21:47 +0200
In-Reply-To: <4E821920.3000509@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
	 <1316816432-9237-4-git-send-email-glommer@parallels.com>
	 <CAKTCnz=5wLq2OAKLfCOh5bX+t2T1exhhCdHUMkQchPzHNyU5Hw@mail.gmail.com>
	 <4E821920.3000509@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317162107.21836.35.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 15:42 -0300, Glauber Costa wrote:
> >> +static inline void task_cgroup_account_field(struct task_struct *p,
> >> +                                            cputime64_t tmp, int index)
> >> +{
> >> +       struct kernel_stat *kstat;
> >> +       struct task_group *tg = task_group(p);
> >> +
> >> +       do {
> >> +               kstat = this_cpu_ptr(tg->cpustat);
> >> +               kstat->cpustat[index] = cputime64_add(kstat->cpustat[index],
> >> +                                                     tmp);
> >> +               tg = tg->parent;
> >> +       } while (tg);
> >> +}
> >
> > What protects the walk (tg = tg->parent)? Could you please document it
> I think that the fact that the hierarchy only grows down, thus parent 
> never changes (or am I wrong?)
> 
> And since we run all this with preempt disabled and with the runqueue 
> locked, we should have no problems.
> 
> Do you agree? 

Right, so the tg can't be destroyed unless its empty, us finding this
task in it means its not empty, we require rq->lock or p->pi_lock to
move the task.

However, afaict we don't actually have any of those locks.

That said, it should be sufficient to wrap the whole thing in
rcu_read_lock(), accounting one tick funny because a cgroup move race
isn't the end of the world and its really no different than moving the
task a little later anyway.

task_group() should complain about this if you compile a kernel with
CONFIG_PROVE_RCU.
