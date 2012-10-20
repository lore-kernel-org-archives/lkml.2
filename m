Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977Ab2JTMhy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 08:37:54 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:49176 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932242Ab2JTMhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 08:37:52 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/r5j4hFdzrOjMr9YXgDP7TCqQv0hwmrg6rQYuRZJ
	P5+UoqzQcprG7d
Message-ID: <1350736696.5123.24.camel@maggy.simpson.net>
Subject: Re: [PATCH] sched, autogroup: fix kernel crashes caused by runtime
 disable autogroup
From: Mike Galbraith <efault@gmx.de>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Xiaotian Feng <dannyfeng@tencent.com>, Ingo Molnar <mingo@redhat.com>
Date: Sat, 20 Oct 2012 08:38:16 -0400
In-Reply-To: <CAJn8CcE5McFB-FH981Pj+eahNOt8ck3ncJwD4xocU_LrAtjBHA@mail.gmail.com>
References: <1350635770-9189-1-git-send-email-xtfeng@gmail.com>
	 <1350654126.2768.5.camel@twins>
	 <CAJn8CcE5McFB-FH981Pj+eahNOt8ck3ncJwD4xocU_LrAtjBHA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-20 at 14:42 +0800, Xiaotian Feng wrote: 
> On Fri, Oct 19, 2012 at 9:42 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > Always try and CC people who wrote the code..
> >
> > On Fri, 2012-10-19 at 16:36 +0800, Xiaotian Feng wrote:
> >> There's a regression from commit 800d4d30, in autogroup_move_group()
> >>
> >>       p->signal->autogroup = autogroup_kref_get(ag);
> >>
> >>       if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
> >>               goto out;
> >>       ...
> >>     out:
> >>       autogroup_kref_put(prev);
> >>
> >> So kernel changed p's autogroup to ag, but never sched_move_task(p).
> >> Then previous autogroup of p is released, which may release task_group
> >> related with p. After commit 8323f26ce, p->sched_task_group might point
> >> to this stale value, and thus caused kernel crashes.
> >>
> >> This is very easy to reproduce, add "kernel.sched_autogroup_enabled = 0"
> >> to your /etc/sysctl.conf, your system will never boot up. It is not reasonable
> >> to put the sysctl enabled check in autogroup_move_group(), kernel should check
> >> it before autogroup_create in sched_autogroup_create_attach().
> >>
> >> Reported-by: cwillu <cwillu@cwillu.com>
> >> Reported-by: Luis Henriques <luis.henriques@canonical.com>
> >> Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
> >> Cc: Ingo Molnar <mingo@redhat.com>
> >> Cc: Peter Zijlstra <peterz@infradead.org>
> >> ---
> >>  kernel/sched/auto_group.c |   10 +++++-----
> >>  1 file changed, 5 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/kernel/sched/auto_group.c b/kernel/sched/auto_group.c
> >> index 0984a21..ac62415 100644
> >> --- a/kernel/sched/auto_group.c
> >> +++ b/kernel/sched/auto_group.c
> >> @@ -143,15 +143,11 @@ autogroup_move_group(struct task_struct *p, struct autogroup *ag)
> >>
> >>       p->signal->autogroup = autogroup_kref_get(ag);
> >>
> >> -     if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
> >> -             goto out;
> >> -
> >>       t = p;
> >>       do {
> >>               sched_move_task(t);
> >>       } while_each_thread(p, t);
> >>
> >> -out:
> >>       unlock_task_sighand(p, &flags);
> >>       autogroup_kref_put(prev);
> >>  }
> >
> > So I've looked at this for all of 1 minute, but why isn't moving that
> > check up one line to be above the p->signal->autogroup assignment
> > enough?
> 
> I think if autogroup is disabled, we don't need to use
> autogroup_create() to create a new ag and tg, kernel will not use it.
> 
> >
> >> @@ -159,8 +155,12 @@ out:
> >>  /* Allocates GFP_KERNEL, cannot be called under any spinlock */
> >>  void sched_autogroup_create_attach(struct task_struct *p)
> >>  {
> >> -     struct autogroup *ag = autogroup_create();
> >> +     struct autogroup *ag;
> >> +
> >> +     if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
> >> +             return;
> >>
> >> +     ag = autogroup_create();
> >>       autogroup_move_group(p, ag);
> >>       /* drop extra reference added by autogroup_create() */
> >>       autogroup_kref_put(ag);
> >
> > Man,.. so on memory allocation fail we'll put the group in
> > autogroup_default, which I think ends up being the root cgroup.
> >
> > But what happens when sysctl_sched_autogroup_enabled is false?
> >
> 
> autogroup runtime disable is very nasty, as it might happen at any
> place of sched_move_group() for any setsid task.
> After sysctl_sched_autogroup_enabled is changed to false,
> autogroup_task_group(p, tg) will return tg, which is from its cpu
> cgroup.
> 
> > It looks like sched_autogroup_fork() is effective in that case, which
> > would mean we'll stay in whatever group our parent is in, which is not
> > the same as being disabled.
> 
> It's true, but after autogroup is disabled, p->signal->autogroup will
> never be used then, as autogroup_task_group() will not use it. But
> after autogroup is enabled again, it might be a disaster....

autogroups are intended to always exist, enable/disable only a choice of
whether you use it or not.

> I think we'd better delete the runtime enable/disable support for
> autogroup, because it might mess up the group scheduler....

Disabling runtime on/off sounds good to me too.  Not because it will
mess up the scheduler, it doesn't, but the on/off switch does not take
effect instantly, and in some cases doesn't ever take effect (fully
functional on/off was shot down, so doing that now won't fly either).

So what I would do is either let the user decide once at boot, in which
case if off, creating groups would be stupid), or, just rip autogroup
completely out, since systemd is taking over the known universe anyway.

-Mike

