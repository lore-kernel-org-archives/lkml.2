Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab1K1NKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 08:10:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51113 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab1K1NKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 08:10:00 -0500
MIME-Version: 1.0
In-Reply-To: <20111128120813.GK1775@moon>
References: <20111128120813.GK1775@moon>
Date: Mon, 28 Nov 2011 17:10:00 +0400
X-Google-Sender-Auth: FEXvYX9qzPRU6gPymppv97J6WG8
Message-ID: <CANaxB-wrRd94OJifpYJ=kibx_48oJ=GE51f9GWjZ3np2nCQYsA@mail.gmail.com>
Subject: Re: [RFC] cgroups: freezer -- Allow to attach a task to a frozen cgroup
From: Andrey Vagin <avagin@openvz.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Matt Helsley <matthltc@us.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>        void (*cancel_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
> -                             struct task_struct *tsk);
> +                             struct cgroup *old_cgrp, struct task_struct *tsk);

I'm not shure, that we need old_cgrp, because when cancel_attach is
executed, a task is in old cgroup and old_cgrp = task_cgroup(tsk);

...

>
> +static int freezer_task_transition(struct task_struct *task, int state_to)
> +{
> +       int retval = 0;
> +
> +       switch (state_to) {
> +       case CGROUP_THAWED:
> +               thaw_process(task);
> +               break;
> +       case CGROUP_FROZEN:
> +       case CGROUP_FREEZING:
> +               if (freeze_task(task, true)) {
> +                       if (!frozen(task)) {
> +                               if (!freezing(task) &&
> +                                   !freezer_should_skip(task))
> +                                       retval = -EBUSY;
> +                       }
> +               }
> +               break;
> +       }
> +
> +       return retval;
> +}
> +
> +static int freezer_can_attach_task(struct cgroup *cgroup, struct task_struct *task)
> +{
> +       struct freezer *old_freezer;
> +       struct freezer *freezer;
> +
> +       int goal_state, orig_state;
> +       int retval = 0;
> +
> +       old_freezer = task_freezer(task);
> +       freezer = cgroup_freezer(cgroup);
> +
> +       spin_lock_irq(&freezer->lock);
> +
> +       if (!spin_trylock_irq(&old_freezer->lock)) {
> +               retval = -EBUSY;

I think EBUSY is not a good idea in this place.  We can do something
like double_rq_lock.

.....

> +
> +static void freezer_cancel_attach(struct cgroup_subsys *ss,
> +                                 struct cgroup *cgroup,
> +                                 struct cgroup *old_cgroup,
> +                                 struct task_struct *task)
> +{
> +       struct freezer *freezer = cgroup_freezer(old_cgroup);
> +       int retval = 0;
> +
> +       spin_lock_irq(&freezer->lock);
> +       retval = freezer_task_transition(task, freezer->state);
> +       if (retval)
> +               pr_warning("freezer: Can't move task (pid %d) to %s state\n",
> +                          task_pid_nr(task),
> +                          freezer_state_strs[freezer->state]);

It's strange. A rollback can't fail. We have three situations:

frozen -> frozen
thawed -> frozen
frozen -> thawed

In first and second cases cancel_request can't fail.
In the third we have a problem, which may be solved if we will call
thaw_process(task) from attach_task(), we can do that, because
thaw_process() can't fail. It solves a problem, because
freezer_cancel_attach will be executed for the first and second cases
only.

If my suggestion is correct, we can replace pr_warning on BUG_ON

> +       spin_unlock_irq(&freezer->lock);
> +}
> +
